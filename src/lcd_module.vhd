-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity lcd_module is
	generic( hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=23;
		hpicture:integer:=960; vpicture:integer:=540; 
		vfild:integer:=32; rgb_ground:type_rgb_color:=rgb_sienna );
	port(
		reset : in STD_LOGIC;
		sclk,pclk: in std_logic; 
		EN : in std_logic;  
		backlight : in integer;  
		err,vsync: out std_logic; 	
		
		Vcount,Hcount: out integer; 
		no_signal: in std_logic; 
		grafics_act : in boolean; 
		grafics_color :in type_rgb_color;
		
		lcd_a_clk: out std_logic;
		lcd_a : out std_logic_vector(3 downto 0);  
		
		LCD_EN_VDD,LCD_RST,LCD_EN,LCD_PWM : out STD_LOGIC; 
		
		mem_a : out std_logic_vector(9 downto 0);  
		mem_wr: out std_logic;
		mem_d : out std_logic_vector(31 downto 0);  
		mem_q : in std_logic_vector(95 downto 0)  
		
		);
end lcd_module;

architecture main of lcd_module is	  	
	
	constant fps: integer :=60;
	constant PWMfreq: integer :=18517;
	constant PWMsize: integer :=99;
	constant max_PWMcount: integer :=((hsize+hblank)*(vsize+vblank)) /(PWMfreq/fps*PWMsize);
	constant corr_PWMcount: integer :=((hsize+hblank)*(vsize+vblank)) mod(PWMfreq/fps*PWMsize);
	signal PWM_ena : std_logic;
	constant picture_dalay: integer :=8;
	
	constant adrBuff_status : integer:=0;
	constant adrBuff_start : integer:=1;
	constant status_signature : std_logic_vector(15 downto 0):=x"428F";
	
	signal lcd,stream : type_LCD;
	type state_type is (Vpause,Hpause,Start1,Start2,Start3,Line,error);
	signal state : state_type:=Vpause;
	constant max_adrBuff: integer :=8192*2-1;
	signal adrBuff,count_adrBuff : integer range 0 to 2**10-1 :=0;	
	constant max_intDcount: integer :=hsize*2-1;
	signal intDcount : integer range 0 to max_intDcount :=0;	
	signal intHcount : integer range 0 to hblank+hsize-1 :=0;	
	signal store0Request,store1Request,intVcount,intVAcount : integer range 0 to vblank+vsize-1 :=0;	
	signal Frame,Vstart,Vstop,Hstart,Hstop,req_act,edgingv_act,edgingh_act,picturev_act,pictureh_act,status_buffer : boolean:=false;	
	signal adrBuffHi, numBuff:std_logic:='0';	
	signal Hphase : integer range 0 to 3 :=0;	
	signal YCC420stream : std_logic_vector(47 downto 0):=(others=>'0');
	signal err_sequence : std_logic;
	
	signal YCC444stream : type_ycc_color:=ycc_black;
	signal RGBstream : type_rgb_color:=rgb_black;
	signal genY :std_logic_vector(7 downto 0);
begin 
	err<=err_sequence;	
	Vcount<=intVcount;
	Hcount<=intHcount;
	EN_proc: process (reset,pclk,Frame)
		variable max_count : integer:=32;
		variable count : integer range 0 to max_count-1;
	begin
		if reset='1' then 
			count:=0;  
			LCD_EN_VDD<='0';  
			LCD_RST<='0'; 
			LCD_EN<='0'; 
			PWM_ena<='0'; 
		elsif rising_edge(pclk) and Frame then 	 
			case count is
				when 00 => LCD_EN_VDD<='0'; LCD_RST<='0'; LCD_EN<='0'; PWM_ena<='0';
				when 01 => LCD_EN_VDD<='1'; LCD_RST<='1'; LCD_EN<='0'; PWM_ena<='0';
				when 10 => LCD_EN_VDD<='1'; LCD_RST<='0'; LCD_EN<='0'; PWM_ena<='0';
				when 15 => LCD_EN_VDD<='1'; LCD_RST<='0'; LCD_EN<='1'; PWM_ena<='0';
				when 30 => LCD_EN_VDD<='1'; LCD_RST<='0'; LCD_EN<='1'; PWM_ena<='1';
				when others => null;
			end case;
			if EN='1' then
				if count/=max_count-1 then
					count:=count+1;
				end if;
			else 
				count:=0;  
			end if;
		end if;	   
	end process EN_proc; 
	
	PWM_proc: process (pclk)
		constant max_count_pwm : integer:=98;
		variable count_pwm : integer range 0 to max_count_pwm;
		variable count : integer range 0 to corr_PWMcount+max_PWMcount-1;
		variable count_pwm_inc : boolean:= false;
	begin
		if rising_edge(pclk)then 
			if count_pwm=0 then
				LCD_PWM<=PWM_ena;	
			elsif count_pwm=backlight then
				LCD_PWM<='0';	
			end if;
			if Frame then
				count_pwm:=0;
			elsif count_pwm_inc then
				if count_pwm=max_count_pwm then
					count_pwm:=0;
				else 
					count_pwm:=count_pwm+1;
				end if;
			end if;
			count_pwm_inc:=count=0;
			if Frame then
				count:=max_PWMcount-1;
				--				count:=corr_PWMcount+max_PWMcount-1;
			elsif count=0 then
				count:=max_PWMcount-1;
			else
				count:=count-1;
			end if;
		end if;
	end process PWM_proc; 
	
	LCDserializer1 : entity work.LCDserializer 
	port map(
		reset => '0',
		sclk => sclk,
		pclk => pclk,
		lcd => lcd,
		lvds_clk => lcd_a_clk,
		lvds_out => lcd_a
		);	
	
	mem_a(9)<=adrBuffHi;	
	mem_a(8 downto 0)<=conv_std_logic_vector(adrBuff,9);	
	numBuff<=conv_std_logic_vector(intVAcount,1)(0);
	
	mem_d(31 downto 16)<=status_signature;
	mem_d(15)<='0';
	mem_d(14)<='0';	
	mem_d(3)<='0';
	main_proc: process (pclk)
	begin
		if rising_edge(pclk) then 
			if conv_std_logic_vector(intHcount+intVcount+intDcount,16)(10)='0' then
				genY<="00" & conv_std_logic_vector(intHcount+intVcount+intDcount,16)(9 downto 4); 
			else
				genY<="00" & not conv_std_logic_vector(intHcount+intVcount+intDcount,16)(9 downto 4); 
			end if;
			if intVAcount=vpicture then	 
				mem_d(13 downto 4)<=conv_std_logic_vector(0,10);  
				mem_d(2)<='0';
				mem_d(1)<='0';
				mem_d(0)<='1';
			else
				mem_d(13 downto 4)<=conv_std_logic_vector(intVAcount+1,10);  
				mem_d(2)<=not numBuff;
				mem_d(1)<=boolean_to_data(intVAcount=vpicture-1);
				mem_d(0)<='0';
			end if;
			Vstart<=intVcount=1 and intHcount=hblank+hsize-2;	
			Vstop<=intVcount=vsize+1 and intHcount=hblank+hsize-2;	
			Hstart<=intHcount=hblank-4;	
			Hstop<=intHcount=hblank+hsize-2;	
			vsync<=boolean_to_data(intVcount=0); 
			req_act<=intVcount>=vfild-1 and intVcount<vpicture+vfild-1;
			picturev_act<=intVcount>=vfild and intVcount<vpicture+vfild;
			edgingv_act<=intVcount<vfild or intVcount>=vfild+vpicture;
			edgingh_act<=intHcount<hblank+(hsize-hpicture)/2 or intHcount>=hblank+hsize-(hsize-hpicture)/2;
			pictureh_act<=intHcount>=hblank+(hsize-hpicture)/2-picture_dalay and intHcount<hblank+hsize-(hsize-hpicture)/2-picture_dalay;
			if numBuff='0' then
				status_buffer<=mem_q(31 downto 16)=conv_std_logic_vector(store1Request,16);	  
			else
				status_buffer<=mem_q(15 downto 0)=conv_std_logic_vector(store0Request,16);	  
			end if;
			if intVcount=0 and intHcount=0 then 
				if  intDcount=max_intDcount then	
					intDcount<=0;	
				else
					intDcount<=intDcount+16;	
				end if;
			end if;
			if intHcount=0 then 
				if  intVcount=vblank+vsize-1 then	
					intVcount<=0;	
				else
					intVcount<=intVcount+1;	
				end if;
			end if;
			if intHcount=0 then
				if intVcount=vfild-1 then 
					intVAcount<=0;	
				elsif picturev_act then
					intVAcount<=intVAcount+1;	
				end if;
			end if;
			if intHcount=hblank+hsize-1 then	 
				intHcount<=0;
			else
				intHcount<=intHcount+1;
			end if;	
			
			case state is 
				when Hpause =>  
					lcd<=(rgb_black,hs);
					adrBuffHi<=boolean_to_data(intHcount>5);	
					adrBuff<=adrBuff_status;
					if intHcount=2 then	
						if numBuff='0' then
							store0Request<=intVAcount; 
						else
							store1Request<=intVAcount;
						end if;
					end if;	 
					mem_wr<=boolean_to_data(intHcount=2 and req_act);  
					Frame<=false;
					if Hstart then	
						state<=Start1;  
					end if;	
				
				when Start1 =>
					lcd<=(rgb_black,cl);
					if not status_buffer and not edgingv_act then
						err_sequence<='1';
					end if;
					state<=Start2; 
				
				when Start2 =>
					err_sequence<='0';
					lcd<=(rgb_black,cl);
					Hphase<=0;
					adrBuffHi<=numBuff;	
					adrBuff<=adrBuff_start;
					state<=Line; 
				
				when Line =>  
					lcd.sync<=de;  
					if grafics_act then 
						lcd.color<=grafics_color;
					elsif edgingh_act or edgingv_act then 
						lcd.color<=rgb_ground;
					else
						lcd.color<=RGBstream;
					end if;	   
					if no_signal='1' then
						YCC420stream<= ycc_black.Cb & ycc_black.Cr & genY & genY & genY & genY; --[Cb/Cr] & [Y11/Y10] & [Y01/Y00]
					elsif picturev_act and pictureh_act and Hphase=1 then  
						adrBuff<=adrBuff+1;	
						YCC420stream<= mem_q(95 downto 80) & mem_q(63 downto 48) & mem_q(31 downto 16); --[Cb/Cr] & [Y11/Y10] & [Y01/Y00]
						Hphase<=0;
					else
						YCC420stream<= mem_q(79 downto 64) & mem_q(47 downto 32) & mem_q(15 downto 0);	--[Cb/Cr] & [Y11/Y10] & [Y01/Y00]
						Hphase<=1;
					end if;	
					
					if Vstop then	
						state<=Vpause;
					elsif Hstop then	
						state<=Hpause;
					end if;	
				
				when Vpause =>  
					lcd<=(rgb_black,vs);
					if Vstart then
						Frame<=true;
						state<=Hpause;
					end if;	
				
				when others =>	--err_cycle
					lcd<=(rgb_black,cl);
					adrBuffHi<='0';	
					adrBuff<=0;  
					mem_wr<='0';
					YCC420stream<=(others=>'0');
					Hphase<=0;
					state<=Vpause;
				
			end case;		
		end if;
	end process main_proc; 	
	
	--------------------------------------------------------	
	--  video converters	
	div2_ycc : entity work.YCC420_to_YCC444div2 
	port map(
		clock => pclk,
		YCC420 => YCC420stream(47 downto 0),
		YCbCr => YCC444stream
		);
	conv_ycc_to_rgb : entity work.ycc2rgb 
	port map (
		clock => pclk,
		YCbCr => YCC444stream,
		RGB => RGBstream
		);
end main; 
