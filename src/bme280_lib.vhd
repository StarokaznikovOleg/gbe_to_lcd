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
	subtype type_inbme280val is std_logic_vector(31 downto 0);	
	type type_dig_P is array (9 downto 1) of std_logic_vector(15 downto 0);
	constant clear_dig_P : type_dig_P := ((others=>(others=>'0')));	
	type type_dig_T is array (3 downto 1) of std_logic_vector(15 downto 0);
	constant clear_dig_T : type_dig_T := ((others=>(others=>'0')));	
	type type_dig_H is array (6 downto 1) of std_logic_vector(15 downto 0);
	constant clear_dig_H : type_dig_H := ((others=>(others=>'0')));	
	type type_inBME280 is record
		act : boolean;
		adc_P : std_logic_vector(31 downto 0);
		dig_P : type_dig_P;
		adc_T : std_logic_vector(31 downto 0);
		dig_T : type_dig_T;
		adc_H : std_logic_vector(31 downto 0);
		dig_H : type_dig_H;
	end record;	
	constant clear_inbme280 : type_inBME280 := (false,(others=>'0'),clear_dig_P,(others=>'0'),clear_dig_T,(others=>'0'),clear_dig_H);	
	type type_outBME280 is record
		act : boolean;
		P : std_logic_vector(31 downto 0);
		T : std_logic_vector(31 downto 0);
		H : std_logic_vector(31 downto 0);
	end record;
	constant clear_bme280 : type_outBME280 := (false,(others=>'0'),(others=>'0'),(others=>'0'));	
end bme280_lib;
