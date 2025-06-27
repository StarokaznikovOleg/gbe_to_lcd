-------------------------------------------------------------------------------
-- Title       : nau88c_lib
-- Design      : codec lib
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package visca_lib is  
	type type_visca_param is record	 
		ena : std_logic;
		clock : std_logic;
		zoom : std_logic_vector(15 downto 0);
	end record;	
	constant clear_visca_param : type_visca_param := ('0','0',(others=>'0'));	 
	
end visca_lib;
