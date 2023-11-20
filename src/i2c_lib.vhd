-------------------------------------------------------------------------------
-- Title       : i2c_interface
-- Design      : common
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


package i2c_lib is  
	constant mem_a_i2c_width : integer :=11;
	constant mem_d_i2c_width : integer :=9;
	subtype type_mem_a_i2c is std_logic_vector(mem_a_i2c_width-1 downto 0);
	subtype type_mem_d_i2c is std_logic_vector(mem_d_i2c_width-1 downto 0);
	subtype type_data_i2c is std_logic_vector(7 downto 0);
end i2c_lib;	
