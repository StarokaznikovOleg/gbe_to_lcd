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
begin 
	delay_proc: process (clock)
	begin
		if rising_edge(clock) then 
			RGB(07 downto 00)<=YCC(07 downto 00);
			RGB(15 downto 08)<=YCC(07 downto 00);
			RGB(23 downto 16)<=YCC(07 downto 00);
		end if;
	end process delay_proc; 
end;