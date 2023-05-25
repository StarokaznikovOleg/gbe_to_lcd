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
		reset,dbg: in std_logic; 	
		err_clk,err_pulse: in type_pulse_err:=(others=>'0');   
		
		-- grafics interface		
		pclk,no_signal: in std_logic; 	
		Vcount,Hcount: in integer; 
		act_pixel : out boolean; 
		color_pixel :out type_lcd_color
		
		);
end grafics_ctr;	  		 
architecture main of grafics_ctr is 
	
	signal act_err,act_logo : boolean;
	signal pixel_err,pixel_logo : type_lcd_color;
	signal run_err,run_logo : std_logic;
	signal dbg_on,dbg_off,dbg_on_avl,dbg_off_avl : std_logic;
	
begin
	dbg_on<=not dbg;
	dbg_off<=dbg; 
	
	dbg_on_pulse : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>1)
	port map( reset => '0',
		clk_in => pclk, data_in => dbg_on,
		clk_out => pclk, data_out => dbg_on_avl );	
	
	dbg_off_pulse : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>1)
	port map( reset => '0',
		clk_in => pclk, data_in => dbg_off,
		clk_out => pclk, data_out => dbg_off_avl );	
	
	reg_proc: process (reset,pclk)
	begin
		if reset='1' then
			run_err<='0';  
			run_logo<='0';	
		elsif rising_edge(pclk) then  
			if dbg_on_avl='1' then 
				run_err<='1';  
				run_logo<='1';	
			elsif dbg_off_avl='1' then
				run_err<='0';  
				run_logo<='0';	
			end if;
		end if;
	end process reg_proc;    
	---------------------------------------------------------------------
	mix_proc: process (pclk)
	begin
		if rising_edge(pclk)then 
			if run_err='1' and act_err then 
				act_pixel<=true;
				color_pixel<=pixel_err;
			elsif act_logo and (no_signal='1' or run_logo='1') then 
				act_pixel<=true;
				color_pixel<=pixel_logo;
			else
				act_pixel<=false;
				color_pixel<=black;
			end if;
		end if;
	end process mix_proc; 
	
	lcd_logo : entity work.gen_logo 
	generic map( vsize=>vsize,vblank=>vblank,hblank=>hblank,hsize=>hsize,
		logo_hsize=>256,logo_vsize=>300,top_plane=>olive,bottom_plane=>dark_yellow )
	port map(
		clock => pclk,
		Vcount => Vcount,
		Hcount => Hcount,
		act => act_logo,
		pixel => pixel_logo );	
	
	lcd_err_ind : entity work.lcd_ind 
	generic map( hsize=>hsize, hblank=>hblank+16, vsize=>vsize, vblank=>18, size=>len_err,
		err_color=>red, mask_color=>white )
	port map(
		pclk => pclk,
		Vcount => Vcount, Hcount => Hcount,
		err_clk => err_clk, err_pulse => err_pulse,
		act => act_err,
		pixel => pixel_err );	  
	
end;	 
