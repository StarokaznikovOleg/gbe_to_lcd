-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity lcd_module is
	generic( hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=23 );
	port(
		reset : in STD_LOGIC;
		sclk,pclk: in std_logic; 
		EN : in std_logic;  
		PWM : in std_logic_vector(7 downto 0);  
		err,vsync: out std_logic; 	
		
		
		Vcount,Hcount: out integer; 
		grafics_act : in boolean; 
		grafics_color :in type_lcd_color;

		lcd_a_clk: out std_logic;
		lcd_a : out std_logic_vector(3 downto 0);  
		
		LCD_EN,LCD_PWM : out STD_LOGIC; 
		
		mem_a : out std_logic_vector(9 downto 0);  
		mem_wr: out std_logic;
		mem_d : out std_logic_vector(95 downto 0);  
		mem_q : in std_logic_vector(95 downto 0)  
		
		);
end lcd_module;

architecture main of lcd_module is	  	
--	constant lcd_err_val : integer :=16;
--	signal err_act,mask_act,err_sync: type_pulse_err:=(others=>'0'); 
	
--	constant v_logo_min : integer :=0;
--	constant v_logo_max : integer :=vsize-300;
--	constant h_logo_min : integer :=hblank;
--	constant h_logo_max : integer :=hsize+hblank-256;
--	signal vs_logo,hs_logo : boolean; 
	
--	signal pixel_logo,pixel_touch,pixel_err : type_lcd_color;
--	signal act_logo,act_touch,act_err :boolean;
	
	constant fps: integer :=60;
	constant PWMfreq: integer :=18517;
	constant PWMsize: integer :=256;
	constant max_PWMcount: integer :=((hsize+hblank)*(vsize+vblank)) /(PWMfreq/fps*PWMsize);
	constant corr_PWMcount: integer :=((hsize+hblank)*(vsize+vblank)) mod(PWMfreq/fps*PWMsize);
	
	constant adrBuff_status : integer:=0;
	constant adrBuff_start : integer:=1;
	constant status_signature : std_logic_vector(15 downto 0):=x"428F";
	
	signal lcd : type_LCD;
	type state_type is (Vpause,Hpause,Start1,Start2,Start3,Line,error);
	signal state : state_type:=Vpause;
	constant max_adrBuff: integer :=8192*2-1;
	signal adrBuff,count_adrBuff : integer range 0 to 2**10-1 :=0;	
	signal intHcount : integer range 0 to hblank+hsize-1 :=0;	
	signal intVcount : integer range 0 to vblank+vsize-1 :=0;	
	signal Frame,Vstart,Vstop,Hstart,Hstop : boolean:=false;	
	signal adrBuffHi, numBuff:std_logic:='0';	
	signal Hphase : integer range 0 to 3 :=0;	
	signal Hdata_shift : std_logic_vector(47 downto 0):=(others=>'0');
	signal err_sequence : std_logic;
	signal store_Lcount : integer range 0 to 1280 :=0;
	
begin 
	err<=err_sequence;	
	Vcount<=intVcount;
	Hcount<=intHcount;
	EN_proc: process (pclk,Frame)
		variable max_count : integer:=32;
		variable count : integer range 0 to max_count-1;
	begin
		if rising_edge(pclk) and Frame then 
			if count=max_count-1 then
				LCD_EN<=EN;
				count:=0;
			else
				count:=count+1;
			end if;
		end if;	   
	end process EN_proc; 
	
	PWM_proc: process (pclk)
		variable count_pwm : integer range 0 to PWMsize-1;
		variable count : integer range 0 to corr_PWMcount+max_PWMcount-1;
		variable count_pwm_inc : boolean:= false;
	begin
		if rising_edge(pclk)then 
			if count_pwm=0 then
				LCD_PWM<='1';	
			elsif count_pwm=conv_integer(PWM) then
				LCD_PWM<='0';	
			end if;
			if count_pwm_inc then
				if count_pwm=255 then
					count_pwm:=0;
				else 
					count_pwm:=count_pwm+1;
				end if;
			end if;
			count_pwm_inc:=count=0;
			if Frame then
				count:=corr_PWMcount+max_PWMcount-1;
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
	
	main_proc: process (pclk)
	begin
		if rising_edge(pclk) then  
			mem_d(31 downto 16)<=status_signature;
			mem_d(15)<='0';
			mem_d(14)<='0';	
			if intVcount=vsize then	 
				mem_d(13 downto 4)<=conv_std_logic_vector(0,10);  
			else
				mem_d(13 downto 4)<=conv_std_logic_vector(intVcount,10);  
			end if;
			mem_d(3)<='0';
			mem_d(2)<=numBuff;
			mem_d(1)<=boolean_to_data(intVcount=vsize-1);
			mem_d(0)<=boolean_to_data(intVcount=0);
			Vstart<=intVcount=1 and intHcount=hblank+hsize-2;	
			Vstop<=intVcount=vsize+1 and intHcount=hblank+hsize-2;	
			Hstart<=intHcount=hblank-4;	
			Hstop<=intHcount=hblank+hsize-2;	
			vsync<=boolean_to_data(intVcount=0);
			if Hstart then 
				if  intVcount=vblank+vsize-1 then	
					intVcount<=0;	
				else
					intVcount<=intVcount+1;
				end if;
			end if;
			if intHcount=hblank+hsize-1 then	 
				intHcount<=0;
			else
				intHcount<=intHcount+1;
			end if;	
			
			case state is 
				when Hpause =>  
					lcd<=(black,hs);
					mem_wr<=boolean_to_data(intHcount=2);
					Frame<=false;
					if intHcount=3 then	
						numBuff<=not numBuff;
					end if;	
					if Hstart then	
						adrBuffHi<=numBuff;	
						adrBuff<=adrBuff_start;
						state<=Start1;  
					else
						adrBuffHi<='0';	
						adrBuff<=adrBuff_status;
					end if;	
				
				when Start1 =>
					lcd<=(black,cl);
					adrBuff<=adrBuff+1;	
					mem_wr<='0';
					state<=Start2; 
				
				when Start2 =>
					lcd<=(black,cl);
					if intVcount/=(conv_integer(mem_q(11 downto 0))+1) then
						err_sequence<='1';
					end if;
					adrBuff<=adrBuff+1;	
					state<=Start3; 
				
				when Start3 =>
					err_sequence<='0';
					lcd<=(black,cl);
					adrBuff<=adrBuff+1;	
					Hphase<=1;
					Hdata_shift<= mem_q(31 downto 0) & x"00" & x"00";
					state<=Line; 
				
				when Line =>  
					lcd.sync<=de;  
					if grafics_act then 
						lcd.color<=grafics_color;
					else
						lcd.color.r<=Hdata_shift(47 downto 40);
						lcd.color.g<=Hdata_shift(39 downto 32);
						lcd.color.b<=Hdata_shift(31 downto 24);
					end if;
					case Hphase is
						when 0 => Hdata_shift<= mem_q(31 downto 0) & x"00" & x"00";	
						when 1 => Hdata_shift<= Hdata_shift(23 downto 16) & mem_q(31 downto 0) & x"00";	
						when 2 => Hdata_shift<= Hdata_shift(23 downto 8) & mem_q(31 downto 0);	
						when 3 => Hdata_shift<= Hdata_shift(23 downto 0) & x"00" & x"00" & x"00";	
					end case;
					if Hphase/=3 then  
						Hphase<=Hphase+1;
					else
						Hphase<=0;
					end if;
					if Hphase/=2 then  
						adrBuff<=adrBuff+1;	
					end if;
					if Vstop then	
						state<=Vpause;
					elsif Hstop then	
						state<=Hpause;
					end if;	
				
				when Vpause =>  
					lcd<=(black,vs);
					if Vstart then
						Frame<=true;
						state<=Hpause;
					end if;	
				
				when others =>	--err_cycle
					lcd<=(black,cl);
					adrBuffHi<='0';	
					numBuff<='0';
					adrBuff<=0;  
					mem_wr<='0';
					Hdata_shift<=(others=>'0');
					Hphase<=0;
					state<=Vpause;
				
			end case;		
		end if;
	end process main_proc; 	
end main; 
