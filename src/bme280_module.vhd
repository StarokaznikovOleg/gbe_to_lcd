-------------------------------------------------------------------------------
-- Title       : bme280_module
-- Design      : Bosch bme280 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.i2c_lib.all;

entity bme280_module is
	generic( ref_freq : integer:=125000000);
	port(
		reset,clock: in std_logic; 
		scl,sda: inout std_logic;
		
		temperature: out std_logic_vector(19 downto 0); 
		pressure: out std_logic_vector(19 downto 0); 
		humidity: out std_logic_vector(19 downto 0) 
		);
end bme280_module;

architecture main of bme280_module is			 
	constant temperature2 : integer :=98;
	constant temperature1 : integer :=97;
	constant temperature0 : integer :=90;
	
	signal ena: boolean:= false; 
	signal i2c_valid : boolean;
	signal i2c_adr_mem : type_mem_i2c;
	signal i2c_data_mem : type_mem_i2c;
	signal i2c_q : type_data_i2c;
		signal reg_temperature: std_logic_vector(19 downto 0); 
	
begin
	--------------------------------------------	
	reg_temperature<=reg_temperature;
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			reg_temperature<=(others=>'0');
		elsif rising_edge(clock) and ena then 
			if i2c_valid and conv_integer(i2c_adr_mem)=temperature2 then
				reg_temperature(19 downto 12)<=i2c_q;
			end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=temperature1 then
				reg_temperature(11 downto 4)<=i2c_q;
			end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=temperature0 then
				reg_temperature(3 downto 0)<=i2c_q(7 downto 4);
			end if;
		end if;
		
	end process main_proc; 
	
	bme240_i2cmem1 : entity work.bme240_i2cmem 
	port map(
		reset => reset,
		clk => clock,
		oce => '1',
		ce => '1',
		ad => i2c_adr_mem,
		dout => i2c_data_mem
		);
	I2C_interface1 : entity work.I2C_interface 
	generic map(
		ref_freq => ref_freq,
		scl_freq => 500000
		)
	port map(
		reset => reset,
		clock => clock,
		scl => scl,
		sda => sda,
		i2c_ena => ena,
		i2c_adr => i2c_adr_mem,
		i2c_mem => i2c_data_mem,
		i2c_valid => i2c_valid,
		i2c_q => i2c_q
	);end main; 
