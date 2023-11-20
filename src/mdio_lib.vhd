-------------------------------------------------------------------------------
-- Title       : mdio_interface
-- Design      : common
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


package mdio_lib is  
	constant mem_a_mdio_width : integer :=11;
	constant mem_d_mdio_width : integer :=9;
	subtype type_mem_a_mdio is std_logic_vector(mem_a_mdio_width-1 downto 0);
	subtype type_mem_d_mdio is std_logic_vector(mem_d_mdio_width-1 downto 0);
	subtype type_data_mdio is std_logic_vector(15 downto 0);
end mdio_lib;	
