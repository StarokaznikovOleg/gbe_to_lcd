-------------------------------------------------------------------------------
-- Title       : video generator protei logo
-- Design      : gen_ethvideo
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.corund10_lib.all;
use work.lcd_lib.all;

entity gen_ethvideo is
	generic( hsize:integer:=1280; hblank:integer:=25; vsize:integer:=800; vblank:integer:=1 );
	port(
		reset,clock: in std_logic; 
		eth_en: out std_logic;
		eth_d : out std_logic_vector(7 downto 0)  
		);
end gen_ethvideo;

architecture main of gen_ethvideo is			 
	constant cap_len : integer :=22; --	pre(4)+macd(6)+macs(6)+vcount(2)+...+crc32(4)
	type state_type is (vpause,hpause,send_preambule,send_macd,send_macs,send_vcount,send_rgb,send_crc,error);
	signal state : state_type:=error;	
	signal shift_d: std_logic_vector(63 downto 0):= (others=>'0'); 
	signal fcount: integer range 0 to 255:= 0; 
	signal vcount: integer range 0 to vsize:= 0; 
	signal hcount: integer range 0 to hsize+hblank-cap_len-1:= 0;  
	
	signal int_d : std_logic_vector(7 downto 0):=(others=>'0'); 
	signal pixel : type_lcd_color:=black; 
	signal pixel_light : type_lcd_color:=white; 
	signal pixel_dark : type_lcd_color:=gray; 
	
	signal int_en,intcrc_clr,intcrc_en : std_logic:='0';
	signal crc_calc : std_logic_vector(31 downto 0):=(others=>'0');
	signal crc_act,RGBact : boolean:=false;	
	
	constant speed_route : integer :=1;
	constant logoHlen : integer :=256;
	constant logoVlen : integer :=300;
	constant logoHstart_min : integer :=4;
	constant logoHstart_max : integer :=hsize-logoHlen-4;
	constant logoVstart_min : integer :=1;
	constant logoVstart_max : integer :=vsize-logoVlen-1;
	signal Vframe,logoVdir,logoHdir,dir_cos,dir_cos_delay,dir_state_route,negative_logo : boolean:=false;	
	signal logoVstart : integer range 0 to vsize :=0;
	signal logoHstart : integer range 0 to hsize :=0;
	signal count_logo,adr_logo : std_logic_vector(16 downto 0):=(others=>'0');
	signal pixel_logo : std_logic_vector(0 downto 0):=(others=>'0');
	signal count_state_route : integer range 0 to 15 :=0;
	signal count_adr_cos : integer range 0 to logoHlen/2-1 :=0;
	signal adr_cos : std_logic_vector(10 downto 0):=(others=>'0');
	signal count_cos : std_logic_vector(6 downto 0):=(others=>'0');
	signal hadr_logo : std_logic_vector(7 downto 0):=(others=>'0');
	signal q_cos : std_logic_vector(7 downto 0):=(others=>'0');
	signal cos_logo : std_logic_vector(6 downto 0):=(others=>'0');
	
begin  
	--------------------------------------------		
	-- move logo		
	move_logo_proc: process (reset,clock,Vframe)
	begin
		if reset='1' then 
			logoVdir<=false;
			logoVstart<=0;
			logoHdir<=false;
			logoHstart<=0;
			pixel_light<=white;
			pixel_dark<=gray;
		elsif rising_edge(clock) and Vframe then  
			if logoVdir then
				if logoVstart=logoVstart_min then
					logoVdir<=false; 
					pixel_light<=color_change_light(pixel_light); 
					pixel_dark<=color_change_dark(pixel_dark); 
				else
					logoVstart<=logoVstart-1;
				end if;
			else
				if logoVstart=logoVstart_max then
					logoVdir<=true; 
					pixel_light<=color_change_light(pixel_light); 
					pixel_dark<=color_change_dark(pixel_dark); 
				else
					logoVstart<=logoVstart+1;
				end if;
			end if;
			if logoHdir then
				if logoHstart=logoHstart_min then
					logoHdir<=false; 
				else
					logoHstart<=logoHstart-1;
				end if;
			else
				if logoHstart=logoHstart_max then
					logoHdir<=true; 
				else
					logoHstart<=logoHstart+1;
				end if;
			end if;
		end if;
	end process move_logo_proc; 
	
	--------------------------------------------		
	-- draw logo		
	graffic_proc: process (reset,clock,RGBact)
		variable rHstart,rHact,rHstop,aHstart,aHact,aHstop,Vstart,Vstop,Vact,dHstart,dHstop,dHact : boolean:=false;
		variable dir_adr_cos : boolean:=false;
	begin
		if reset='1' then 
			pixel<=black;
			count_adr_cos<=0;
			count_state_route<=0; 
			dir_adr_cos:=false;
			dir_cos<=false;
			dir_state_route<=false;
			count_logo<=(others=>'0');
			count_cos<=(others=>'0');
			negative_logo<= false;
		elsif rising_edge(clock) and RGBact then 
			if Vstop then
				count_logo<=(others=>'0');
			elsif aHact and Vact then
				count_logo<=count_logo+1;
			end if;
			
			if aHstart then
				count_cos<=(others=>'0');
				dir_cos<=false; 
			elsif aHact and Vact then  
				if count_cos=x"7f"	and not dir_cos then
					dir_cos<=true; 
				elsif count_cos=x"00" and dir_cos then
					dir_cos<=false; 
				elsif dir_cos then
					count_cos<=count_cos-1;	  
				else
					count_cos<=count_cos+1;	  
				end if;	
			end if;	
			
			if Vstop then 
				if count_state_route=0 then	
					count_state_route<=count_state_route+1; 
					dir_state_route<=false;
				elsif count_state_route=15 then
					count_state_route<=count_state_route-1; 
					dir_state_route<=true;
					negative_logo<= not negative_logo;
				elsif dir_state_route then
					count_state_route<=count_state_route-1; 
				else
					count_state_route<=count_state_route+1; 
				end if;
			end if;	 
			
			if rHstart then
				count_adr_cos<=0;
				dir_adr_cos:=false;
			elsif count_adr_cos=0 then
				count_adr_cos<=count_adr_cos+1;
				dir_adr_cos:=false;
			elsif count_adr_cos=(logoHlen/2-1) then
				dir_adr_cos:=true;
			elsif aHact then
				if dir_adr_cos then 
					count_adr_cos<=count_adr_cos-1;
				else
					count_adr_cos<=count_adr_cos+1;
				end if;	
			end if;	
			
			if dHact and Vact then
				if pixel_logo(0)='1' then 
					if negative_logo then
						pixel<=pixel_dark;
					else
						pixel<=pixel_light;
					end if;
				else
					pixel<=black;
				end if;
			else
				pixel<=black;
			end if;		
			-- window for route rom inc			
			if rHstart then rHact:=true; elsif rHstop then rHact:=false; end if;
			rHstart:=Hcount=(hsize-logoHstart+4) and state=send_rgb;	
			rHstop:=Hcount=(hsize-logoHstart-logoHlen+4) and state=send_rgb;	
			
			-- window for address rom inc			
			if aHstart then aHact:=true; elsif aHstop then aHact:=false; end if;
			aHstart:=Hcount=(hsize-logoHstart+2) and state=send_rgb;	
			aHstop:=Hcount=(hsize-logoHstart-logoHlen+2) and state=send_rgb;			
			
			-- H window for data rom read			
			if dHstart then dHact:=true; elsif dHstop then dHact:=false; end if;
			dHstart:=Hcount=(hsize-logoHstart) and state=send_rgb;	
			dHstop:=Hcount=(hsize-logoHstart-logoHlen) and state=send_rgb;	
			
			-- V window for data rom read			
			if Vstart then Vact:=true; elsif Vstop then Vact:=false; end if;
			Vstart:=Vcount=logoVstart and Hcount=(hsize-1);			
			Vstop:=Vcount=logoVstart+logoVlen and Hcount=(hsize-1);
		end if;
	end process graffic_proc; 
	
	--------------------------------------------		
	-- logo map	
	hadr_logo<=not(count_logo(7) & cos_logo) when negative_logo else count_logo(7) & cos_logo;	
	adr_logo<=count_logo(16 downto 8) & hadr_logo;	
	logo_rom1 : entity work.logo_rom 
	port map(
		reset => reset,
		clk => clock,
		ce => '1',
		ad => adr_logo,
		oce => '1',
		dout => pixel_logo
		);	
	
	--------------------------------------------		
	-- cos map		
	adr_cos<=conv_std_logic_vector(count_state_route,4) & count_cos;
	logo_route : entity work.cos_table 
	port map(
		reset => reset,
		clk => clock,
		ce => '1',
		ad => adr_cos,
		oce => '1',
		dout => q_cos
		);
	cos_logo<=not q_cos(6 downto 0) when dir_cos_delay else q_cos(6 downto 0);	
	--------------------------------------------		
	-- create eth video traffic		
	ethtx_video_proc: process (reset,clock)
		variable count : integer range 0 to 15;
	begin
		if reset='1' then 	
			eth_d<=(others=>'0');	
			eth_en<='0';	 
			int_d<=(others=>'0');
			int_en<='0';
			shift_d<=(others=>'0');	 
			intcrc_clr<='0';
			intcrc_en<='0';
			hcount<=0;  
			vcount<=0;  
			fcount<=0;  
			count:=0;  
			RGBact<=false;
			Vframe<=false;	
			state<=error; 
			dir_cos_delay<=false;
		elsif rising_edge(clock) then 
			dir_cos_delay<=dir_cos;
			if crc_act then 
				case count is
					when 3 => eth_d<=crc_calc(31 downto 24);	
					when 2 => eth_d<=crc_calc(23 downto 16);	
					when 1 => eth_d<=crc_calc(15 downto 8);	
					when others => eth_d<=crc_calc(7 downto 0);	   
				end case;
			else
				eth_d<=int_d;	
			end if;
			crc_act<=state=send_crc;
			int_d<=shift_d(63 downto 56);
			eth_en<=int_en;	 
			case state is
				when vpause =>
					Vframe<=false;	
					int_en<='0';  
					if hcount=0 then
						hcount<=hsize+hblank-cap_len-1;  
						if vcount=vblank then
							vcount<=1;
							fcount<=fcount+1;
							hcount<=hblank-cap_len-1;  
							state<=hpause; 
						else
							vcount<=vcount+1;
						end if;	
					else
						hcount<=hcount-1;
					end if;	
				
				when hpause =>
					int_en<='0';  
					if hcount=0 then
						shift_d<=x"55555555555555d5";	
						hcount<=hsize;
						count:=7;  
						intcrc_clr<='1';
						state<=send_preambule; 
					else
						hcount<=hcount-1;
					end if;
				
				when send_preambule =>
					intcrc_clr<='0';
					int_en<='1';
					if count=0 then
						shift_d<=x"ffffffffffff"  & conv_std_logic_vector(0,16);	
						count:=5;  
						state<=send_macd; 
					else
						shift_d<=shift_d(55 downto 0) & x"00";	
						count:=count-1;
					end if;
				
				when send_macd =>
					intcrc_en<='1';
					if count=0 then
						shift_d<=x"001EFA40428F"  & conv_std_logic_vector(0,16);	
						count:=5;  
						state<=send_macs; 
					else
						shift_d<=shift_d(55 downto 0) & x"00";	
						count:=count-1;
					end if;
				
				when send_macs =>
					if count=0 then
						shift_d<=conv_std_logic_vector(vcount,16) & conv_std_logic_vector(0,16+32);	
						count:=1;  
						state<=send_vcount; 
					else
						shift_d<=shift_d(55 downto 0) & x"00";	
						count:=count-1;
					end if;	
				
				when send_vcount =>
					if count=0 then
						count:=2; 
						shift_d<=pixel.r & pixel.g & pixel.b & conv_std_logic_vector(0,8+32);	
						hcount<=hcount-1;
						state<=send_rgb; 
					else
						shift_d<=shift_d(55 downto 0) & x"00";	
						count:=count-1;
					end if;	
				
				when send_rgb => 
					RGBact<=count=1;
					if count=0 then
						if hcount=0 then
							shift_d<=x"dd" & conv_std_logic_vector(0,56);	
							count:=4;  
							state<=send_crc; 
						else
							shift_d<=pixel.r & pixel.g & pixel.b & conv_std_logic_vector(0,8+32);	
							hcount<=hcount-1;  
							count:=2;  
						end if;	
					else
						shift_d<=shift_d(55 downto 0) & x"00";	
						count:=count-1;
					end if;	
				
				when send_crc => 
					RGBact<=false;
					intcrc_en<='0';
					if count=1 then
						if vcount=vsize then
							vcount<=1;   
							hcount<=hsize+hblank-cap_len-1;  
							Vframe<=true;	
							state<=vpause; 
						else
							vcount<=vcount+1;   
							hcount<=hblank-cap_len-1;  
							state<=hpause; 
						end if;	
					end if;	
					count:=count-1;
				
				when others => --error
					int_en<='0';
					shift_d<=(others=>'0');	 
					intcrc_clr<='0';
					intcrc_en<='0';
					hcount<=0;  
					vcount<=1;  
					count:=0;  
					state<=vpause; 
				
			end case;
		end if;
	end process ethtx_video_proc; 
	
	ethtx_crc32 : entity work.crc32 
	generic map( BusWidth=>8 )
	port map(
		aclr => reset,
		clock => clock,
		sload => intcrc_clr,
		enable => intcrc_en,
		data_in => int_d,
		crc_out => open,
		crc_check => open,
		crc_calc => crc_calc
		);
	
end main;