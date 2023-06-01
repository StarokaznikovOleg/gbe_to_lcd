library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
package lcd_lib is  
	type type_ycc_color is record
		Y : std_logic_vector(7 downto 0);
		Cb : std_logic_vector(7 downto 0);
		Cr : std_logic_vector(7 downto 0);
	end record;
	constant ycc_black 	: type_ycc_color := (x"10",x"80",x"80");	
	constant ycc_white 	: type_ycc_color := (x"eb",x"80",x"80");	
	constant ycc_red 	: type_ycc_color := (x"51",x"5a",x"eb");
	
	type type_lcd_color is record
		R : std_logic_vector(7 downto 0);
		G : std_logic_vector(7 downto 0);
		B : std_logic_vector(7 downto 0);
	end record;
	constant black 	: type_lcd_color := (x"00",x"00",x"00");	
	
	constant white 	: type_lcd_color := (x"ff",x"ff",x"ff");	
	constant red 	: type_lcd_color := (x"ff",x"00",x"00");	
	constant lime 	: type_lcd_color := (x"00",x"ff",x"00");	
	constant blue 	: type_lcd_color := (x"00",x"00",x"ff");
	constant aqua 	: type_lcd_color := (x"00",x"ff",x"ff");	
	constant magenta: type_lcd_color := (x"ff",x"00",x"ff");	
	constant yellow : type_lcd_color := (x"ff",x"ff",x"00");	
	
	constant gray 	: type_lcd_color := (x"80",x"80",x"80");	
	constant maroon : type_lcd_color := (x"80",x"00",x"00");	
	constant green  : type_lcd_color := (x"00",x"80",x"00");
	constant navy 	: type_lcd_color := (x"00",x"00",x"80");
	constant teal 	: type_lcd_color := (x"00",x"80",x"80");
	constant purpure: type_lcd_color := (x"80",x"00",x"80");	 
	constant olive 	: type_lcd_color := (x"80",x"80",x"00");
	
	constant gold 			: type_lcd_color := (x"ff",x"d7",x"00");	
	constant dark_yellow 	: type_lcd_color := (x"33",x"33",x"00");	
	constant indigo 		: type_lcd_color := (x"4b",x"00",x"82");	
	constant chocolate 		: type_lcd_color := (x"d2",x"69",x"1e");	
	constant sienna 		: type_lcd_color := (x"a0",x"52",x"2d");	
	
	
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
		color : type_lcd_color;
		sync : type_lcd_sync;
	end record;	
	subtype type_LCD_data is std_logic_vector(34 downto 0);  
	
	function lcd_to_data(d:type_LCD) return type_LCD_data;
--	function color_change_light(d:type_lcd_color) return type_lcd_color;
--	function color_change_dark(d:type_lcd_color) return type_lcd_color;
	
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
--		q(13 downto 07):=d.color.r(0) 	& d.color.r(1)	& d.color.r(2)	& d.color.r(3)	& d.color.r(4)	& d.color.r(5)	& d.color.g(0); 
--		q(20 downto 14):=d.color.g(1) 	& d.color.g(2)	& d.color.g(3)	& d.color.g(4)	& d.color.g(5)	& d.color.b(0)	& d.color.b(1);
--		q(27 downto 21):=d.color.b(2) 	& d.color.b(3) 	& d.color.b(4) 	& d.color.b(5)	& d.sync.h 		& d.sync.v 		& d.sync.de   ; 
--		q(34 downto 28):=d.color.r(6) 	& d.color.r(7) 	& d.color.g(6)	& d.color.g(7) 	& d.color.b(6)	& d.color.b(7)	& d.sync.x 	  ;   
		return q; 
	end lcd_to_data;
--	function color_change_light(d:type_lcd_color) return type_lcd_color is
--		variable q : type_lcd_color;
--	begin 
--		if 		d=white 	then 	q:=red 		; 
--		elsif 	d=red 		then 	q:=green 	;  
--		elsif 	d=green 	then 	q:=blue 	;  
--		elsif 	d=blue 		then 	q:=aqua 	;  
--		elsif 	d=aqua 		then 	q:=magenta	;  
--		elsif 	d=magenta 	then 	q:=yellow  	;  
--		else 						q:=white 	;	
--		end if;
--		return q; 
--	end color_change_light;	 
--	
--	function color_change_dark(d:type_lcd_color) return type_lcd_color is
--		variable q : type_lcd_color;
--	begin 
--		if 		d=gray 		then 	q:=maroon 	; 
--		elsif 	d=maroon 	then 	q:=office 	;  
--		elsif 	d=office 	then 	q:=navy 	;  
--		elsif 	d=navy 		then 	q:=teal 	;  
--		elsif 	d=teal 		then 	q:=purpure	;  
--		elsif 	d=purpure 	then 	q:=olive	;  
--		else 						q:=gray 	;	
--		end if;
--		return q; 
--	end color_change_dark;
	
	
end lcd_lib;																



