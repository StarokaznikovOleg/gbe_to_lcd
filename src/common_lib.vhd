-------------------------------------------------------------------------------
-- Title       : common lib
-- Design      : lib
-- Author      : Starokaznikov OV
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
package common_lib is  
	
	function boolean_to_data(data:boolean) return std_logic;	
	function data_to_boolean(data:std_logic) return boolean;	
	
end common_lib;	

package body common_lib is   
	function boolean_to_data(data:boolean) return std_logic is
	begin 
		if data then return '1';
		else return '0';
		end if;
	end boolean_to_data;
	function data_to_boolean(data:std_logic) return boolean is
	begin 
		return data='1';																	  
	end data_to_boolean; 
	
	
end common_lib;																


