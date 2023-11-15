-------------------------------------------------------------------------------
-- Title       : bme280_lib
-- Design      : Bosch bme280 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package bme280_lib is 
	constant inbme280_width : integer :=32;  
	constant bme280dig_width : integer :=16;  
	
	type type_p_dig is array (1 to 9) of integer; -- std_logic_vector(bme280dig_width-1 downto 0);
	constant clear_p_dig : type_p_dig :=((others=>0)); -- ((others=>(others=>'0')));	
	type type_t_dig is array (1 to 3) of integer; --std_logic_vector(bme280dig_width-1 downto 0);
	constant clear_t_dig : type_t_dig := ((others=>0)); --((others=>(others=>'0')));	
	type type_h_dig is array (1 to 6) of integer; --std_logic_vector(bme280dig_width-1 downto 0);
	constant clear_h_dig : type_h_dig := ((others=>0)); --((others=>(others=>'0')));	
	type type_inBME280 is record
		act : boolean;
		p_adc : integer;
		p_dig : type_p_dig;
		t_adc : integer;
		t_dig : type_t_dig;
		h_adc : integer;
		h_dig : type_h_dig;
	end record;	
	constant clear_inbme280 : type_inBME280 := (false,0,clear_p_dig,0,clear_t_dig,0,clear_h_dig);	
	
	constant outbme280_width : integer :=32;  
	type type_outBME280 is record
		act : boolean;
		P : std_logic_vector(outbme280_width-1 downto 0);
		T : std_logic_vector(outbme280_width-1 downto 0);
		H : std_logic_vector(outbme280_width-1 downto 0);
	end record;
	constant clear_bme280 : type_outBME280 := (false,(others=>'0'),(others=>'0'),(others=>'0'));	
end bme280_lib;
