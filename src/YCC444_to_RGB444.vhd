-- Title       : HDMI
-- Design      : RGB444_to_YCC444
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
use ieee.numeric_std.all; 

entity YCC444_to_RGB444 is 
	port( 
		clock : in std_logic;
		YCC : in std_logic_vector(23 downto 0);
		RGB : out std_logic_vector(23 downto 0)
		);
end YCC444_to_RGB444;	  		 
architecture main of YCC444_to_RGB444 is  	 
	signal y,cr,cb,r,g,b : std_logic_vector(7 downto 0);
begin 
	ycc2rgb_1 : entity work.ycc2rgb 
	port map(
		clock => clock,
		y => y,
		cr => cr,
		cb => cb,
		r => r,
		g => g,
		b => b
		);
	y<=YCC(07 downto 00);
	cr<=YCC(07 downto 00);
	cb<=YCC(07 downto 00);
	RGB(07 downto 00)<=r;
	RGB(15 downto 08)<=g;
	RGB(23 downto 16)<=b;
end;