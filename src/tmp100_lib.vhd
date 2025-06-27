-------------------------------------------------------------------------------
-- Title       : tmp100_module
-- Design      : 4x tmp100 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package tmp100_lib is  
	
	constant max_tmp100numb : integer :=3; 	  
	constant max_tmp100val : integer :=16; 	  
	subtype type_tmp100val is std_logic_vector(max_tmp100val-1 downto 0);	 
	type type_tmp100 is record
		act : boolean;
		val : type_tmp100val;
	end record;
	constant clear_tmp100 : type_tmp100 := (false,x"012c");	
	type tmp100_array is array (max_tmp100numb-1 downto 0) of type_tmp100;
	type type_adr_array is array (0 to max_tmp100numb-1) of integer;  
end tmp100_lib;
