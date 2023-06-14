-------------------------------------------------------------------------------
-- Title       : logo generator
-- Design      : gen_logo
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity gen_logo is
	generic( hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=23; 
		logo_hsize:integer:=256; logo_vsize:integer:=300; 
		top_plane:type_rgb_color:=white; bottom_plane:type_rgb_color:=gray);
	port(
		clock: in std_logic; 
		Vcount,Hcount: in integer; 
		act: out boolean; 
		pixel :out type_rgb_color  
		);
end gen_logo;

architecture main of gen_logo is			 
	constant fcount_max : integer := 255;  
	
	constant v_logo_min : integer :=0;
	constant v_logo_max : integer :=vsize-logo_vsize;
	constant h_logo_min : integer :=hblank;
	constant h_logo_max : integer :=hsize+hblank-logo_hsize;
	
	signal vstart,hstart: boolean; 	 
	
	signal int_vcount: integer range 0 to logo_vsize:= 0; 
	signal int_hcount: integer range 0 to logo_hsize:= 0; 
	
	type boolean3_array is array (2 downto 0) of boolean; 
	signal hsync : boolean3_array:=(others=>false);
	type boolean5_array is array (4 downto 0) of boolean; 
	signal hact : boolean5_array:=(others=>false);
	
	signal frame: boolean; 
	signal vact,vstop,hstop,dir_cos,dir_cos_delay,dir_state_route,negative_logo : boolean:=false;	
	signal count_logo,adr_logo : std_logic_vector(16 downto 0):=(others=>'0');
	signal pixel_logo : std_logic_vector(0 downto 0):=(others=>'0');
	signal count_state_route : integer range 0 to 15 :=0;
	signal adr_cos : std_logic_vector(10 downto 0):=(others=>'0');
	signal count_cos : std_logic_vector(6 downto 0):=(others=>'0');
	signal hadr_logo : std_logic_vector(7 downto 0):=(others=>'0');
	signal q_cos : std_logic_vector(7 downto 0):=(others=>'0');
	signal cos_logo : std_logic_vector(6 downto 0):=(others=>'0');
	
begin 
	--------------------------------------------		
	-- pozition logo		
	position_logo: process (clock)
		variable v_position : integer range v_logo_min to v_logo_max :=v_logo_min;
		variable h_position : integer range h_logo_min to h_logo_max :=h_logo_min;
		variable vdir,hdir : boolean:= false;
	begin
		if rising_edge(clock)then 
			frame<=Vcount=0 and hcount=0;
			vstart<=Vcount=v_position and Hcount=0;
			hstart<=Hcount=h_position;
			if frame then
				if vdir then	
					v_position:=v_position-1;
				else
					v_position:=v_position+1;
				end if;
				if hdir then	
					h_position:=h_position-1;
				else
					h_position:=h_position+1;
				end if;
				if v_position=v_logo_max then	
					vdir:=true;
				elsif v_position=v_logo_min then	
					vdir:=false;
				end if;
				if h_position=h_logo_max then	
					hdir:=true;
				elsif h_position=h_logo_min then	
					hdir:=false;
				end if;
			end if;
		end if;
	end process position_logo; 
	--------------------------------------------		
	-- draw logo		
	graffic_proc: process (clock)
	begin
		if rising_edge(clock) then 
			dir_cos_delay<=dir_cos;
			if vstart then 
				if count_state_route=15 then
					negative_logo<= not negative_logo;
				end if;
				if count_state_route=0 then	
					dir_state_route<=false;
					count_state_route<=count_state_route+1; 
				elsif count_state_route=15 then
					dir_state_route<=true;
					count_state_route<=count_state_route-1; 
				elsif dir_state_route then
					count_state_route<=count_state_route-1; 
				else
					count_state_route<=count_state_route+1; 
				end if;
			end if;
			
			if hsync(0) then
				count_cos<=(others=>'0');
				dir_cos<=false; 
			elsif vact and hact(0) then  
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
			
			if vstart then
				count_logo<=(others=>'0');
			elsif vact and hact(1) then
				count_logo<=count_logo+1;
			end if;
			
			if vact and hact(4) then
				if pixel_logo(0)='1' then 
					act<=true;
					if negative_logo then
						pixel<=bottom_plane;
					else
						pixel<=top_plane;
					end if;
				else
					act<=false;
					pixel<=black;
				end if;
			else
				act<=false;
				pixel<=black;
			end if;		
			
		end if;
	end process graffic_proc; 
	--------------------------------------------		
	-- sync counters		
	hsync(0)<=hstart;
	count_proc: process (clock)
	begin
		if rising_edge(clock) then
			hsync(2 downto 1)<=hsync(1 downto 0);
			hact(4 downto 1)<=hact(3 downto 0);
			if vstart then vact<=true; elsif vstop then vact<=false; end if;
			if hstart then hact(0)<=vact; elsif hstop then hact(0)<=false; end if;
			vstop<=(int_vcount=logo_vsize-1) and (int_hcount=logo_hsize-1);
			hstop<=int_hcount=logo_hsize-2;
			if vstart then	
				int_vcount<=0;
			elsif hstart then	
				int_vcount<=int_vcount+1;
			end if;
			if vact and hstart then	
				int_hcount<=0;
			elsif int_hcount<logo_hsize and int_vcount<logo_vsize then
				int_hcount<=int_hcount+1;
			end if;
		end if;
	end process count_proc; 
	
	--------------------------------------------		
	-- cos map		
	adr_cos<=conv_std_logic_vector(count_state_route,4) & count_cos;
	logo_route : entity work.cos_table 
	port map(
		reset => '0',
		clk => clock,
		ce => '1',
		ad => adr_cos,
		oce => '1',
		dout => q_cos
		);
	cos_logo<=not q_cos(6 downto 0) when dir_cos_delay else q_cos(6 downto 0);	
	
	--------------------------------------------		
	-- logo map	
	hadr_logo<=not(count_logo(7) & cos_logo) when negative_logo else count_logo(7) & cos_logo;	
	adr_logo<=count_logo(16 downto 8) & hadr_logo;	
	logo_rom1 : entity work.logo_rom 
	port map(
		reset => '0',
		clk => clock,
		ce => '1',
		ad => adr_logo,
		oce => '1',
		dout => pixel_logo
		);	
	
end main;