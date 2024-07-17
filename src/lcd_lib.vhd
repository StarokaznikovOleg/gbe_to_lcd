library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
package lcd_lib is  
	--------------------------------------------------
	----------        LCD parameters        ----------	
	constant lcd_hsize:integer:=1024;
	constant lcd_hblank:integer:=320; 
	constant lcd_vsize:integer:=768; 
	constant lcd_vblank:integer:=38;
	--------------------------------------------------
	type type_ycc_color is record
		Y : std_logic_vector(7 downto 0);
		Cb : std_logic_vector(7 downto 0);
		Cr : std_logic_vector(7 downto 0);
	end record;
	constant ycc_black 	: type_ycc_color := (x"10",x"80",x"80");	
	constant ycc_white 	: type_ycc_color := (x"eb",x"80",x"80");	
	constant ycc_red 	: type_ycc_color := (x"51",x"5a",x"eb");
	
	type type_rgb_color is record
		R : std_logic_vector(7 downto 0);
		G : std_logic_vector(7 downto 0);
		B : std_logic_vector(7 downto 0);
	end record;
	constant rgb_black 	: type_rgb_color := (x"00",x"00",x"00");	
	
	constant rgb_white 	: type_rgb_color := (x"ff",x"ff",x"ff");	
	constant rgb_red 	: type_rgb_color := (x"ff",x"00",x"00");	
	constant rgb_lime 	: type_rgb_color := (x"00",x"ff",x"00");	
	constant rgb_blue 	: type_rgb_color := (x"00",x"00",x"ff");
	constant rgb_aqua 	: type_rgb_color := (x"00",x"ff",x"ff");	
	constant rgb_magenta: type_rgb_color := (x"ff",x"00",x"ff");	
	constant rgb_yellow : type_rgb_color := (x"ff",x"ff",x"00");	
	
	constant rgb_lgray 	: type_rgb_color := (x"c5",x"c9",x"cd");	
	constant rgb_gray 	: type_rgb_color := (x"80",x"80",x"80");	
	constant rgb_maroon : type_rgb_color := (x"80",x"00",x"00");	
	constant rgb_green  : type_rgb_color := (x"00",x"80",x"00");
	constant rgb_navy 	: type_rgb_color := (x"00",x"00",x"80");
	constant rgb_teal 	: type_rgb_color := (x"00",x"80",x"80");
	constant rgb_purpure: type_rgb_color := (x"80",x"00",x"80");	 
	constant rgb_olive 	: type_rgb_color := (x"80",x"80",x"00");
	
	constant rgb_gold 			: type_rgb_color := (x"ff",x"d7",x"00");	
	constant rgb_dark_yellow 	: type_rgb_color := (x"33",x"33",x"00");	
	constant rgb_indigo 		: type_rgb_color := (x"4b",x"00",x"82");	
	constant rgb_chocolate 		: type_rgb_color := (x"d2",x"69",x"1e");	
	constant rgb_sienna 		: type_rgb_color := (x"a0",x"52",x"2d");	
	
	
	type type_lcd_sync is record
		v : std_logic;
		h : std_logic;
		de : std_logic;
		x : std_logic;
	end record;
	constant vs : type_lcd_sync := ('1','0','0','1');
	constant hs : type_lcd_sync := ('0','1','0','1');
	constant de : type_lcd_sync := ('0','0','1','1');
	constant cl : type_lcd_sync := ('0','0','0','1');
	
	type type_LCD is record
		color : type_rgb_color;
		sync : type_lcd_sync;
	end record;	
	subtype type_LCD_data is std_logic_vector(34 downto 0);  
	
	function lcd_to_data(d:type_LCD) return type_LCD_data;
	
end lcd_lib;	

package body lcd_lib is  
	
	function lcd_to_data(d:type_LCD) return type_LCD_data is
		variable q : type_LCD_data;
	begin 
		q(6 downto 0):="1100011"; 
		q(13 downto 07):=d.color.g(0) 	& d.color.r(5)	& d.color.r(4)	& d.color.r(3)	& d.color.r(2)	& d.color.r(1)	& d.color.r(0); 
		q(20 downto 14):=d.color.b(1) 	& d.color.b(0)	& d.color.g(5)	& d.color.g(4)	& d.color.g(3)	& d.color.g(2)	& d.color.g(1);
		q(27 downto 21):=d.sync.de 		& d.sync.v 		& d.sync.h  	& d.color.b(5) 	& d.color.b(4) 	& d.color.b(3) 	& d.color.b(2); 
		q(34 downto 28):=d.sync.x 		& d.color.b(7) 	& d.color.b(6) 	& d.color.g(7)	& d.color.g(6) 	& d.color.r(7)	& d.color.r(6);   
		return q; 
	end lcd_to_data;
	
end lcd_lib;																



