-- Title       : GW FPGA project
-- Design      : grafics controller
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
library work;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity grafics_ctr is 
	generic(hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=23);
	port( 
		reset: in std_logic; 	
		dbg: in std_logic_vector(3 downto 0); 	
		err_clk,err_pulse: in type_pulse_err:=(others=>'0');   
		
		-- grafics interface		
		pclk: in std_logic; 	
		Vcount,Hcount: in integer; 
		act_pixel : out boolean; 
		color_pixel :out type_rgb_color;
		
		txt_mapadr : in std_logic_vector(13 downto 0);
		txt_mapclk,txt_mapwr : in std_logic;
		txt_mapdin : in std_logic_vector(7 downto 0)
		
		);
end grafics_ctr;	  		 
architecture main of grafics_ctr is 
	
	signal act_errl,act_errp,act_logo,act_txt : boolean;
	signal pixel_errl,pixel_errp,pixel_logo,pixel_txt : type_rgb_color;
	
begin
	---------------------------------------------------------------------
	mix_proc: process (pclk)
	begin
		if rising_edge(pclk)then 
			if act_errl and dbg(1)='1' then 
				act_pixel<=true;
				color_pixel<=pixel_errl;
			elsif act_errp and dbg(2)='1' then 
				act_pixel<=true;
				color_pixel<=pixel_errp;
			elsif act_txt and dbg(3)='1' then 
				act_pixel<=true;
				color_pixel<=pixel_txt;
			else
				act_pixel<=false;
				color_pixel<=rgb_black;
			end if;
		end if;
	end process mix_proc; 
	lcd_txt : entity work.gen_txt 
	generic map( vsize=>vsize,vblank=>vblank,hblank=>hblank,hsize=>hsize,
		text_color=>rgb_white )
	port map(
		clock => pclk,
		Vcount => Vcount,
		Hcount => Hcount,
		act => act_txt,
		pixel => pixel_txt,
		map_adr => txt_mapadr,
		map_clk => txt_mapclk,
		map_wr => txt_mapwr,
		map_din => txt_mapdin
	);	
	
	lcd_err_ind0 : entity work.lcd_ind 
	generic map( hsize=>hsize, hblank=>hblank, vsize=>vsize, vblank=>vblank, hstart=>734, vstart=>630, size=>16,
	err_color=>rgb_green, mask_color=>rgb_white,
	level=>len_lockerr, pulse=>0)
	port map(
		pclk => pclk,
		Vcount => Vcount, Hcount => Hcount,
		ind_clk => err_clk(len_lockerr-1 downto 0), ind_data => err_pulse(len_lockerr-1 downto 0),
		act => act_errl,
		pixel => pixel_errl );	
		
	lcd_err_ind1 : entity work.lcd_ind 
	generic map( hsize=>hsize, hblank=>hblank, vsize=>vsize, vblank=>vblank, hstart=>734, vstart=>654, size=>16,
	err_color=>rgb_red, mask_color=>rgb_white,
	level=>0, pulse=>len_err-len_lockerr)
	port map(
		pclk => pclk,
		Vcount => Vcount, Hcount => Hcount,
		ind_clk => err_clk(len_err-1 downto len_lockerr), ind_data => err_pulse(len_err-1 downto len_lockerr),
		act => act_errp,
		pixel => pixel_errp );	  
	
end;	 
