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
use work.common_lib.all;
use work.i2c_lib.all;
use work.bme280_lib.all;

entity bme280_module is
	generic( ref_freq : integer:=125000000 );
	port( reset,clock: in std_logic; 
		scl,sda: inout std_logic;
		bme280: out type_outBME280 );
end bme280_module;

architecture main of bme280_module is			 
	constant bme280_ID : std_logic_vector(7 downto 0) :=x"60";	 
	
	constant adr_bme280 : integer :=16#07#;
	
	constant adr_press : integer :=16#97#;
	constant adr_temp 	: integer :=16#af#;
	constant adr_hum 	: integer :=16#bf#;	  
	
	constant adr_digT1 	: integer :=16#0ff#;	 
	constant adr_digT2 	: integer :=16#10f#;	 
	constant adr_digT3 	: integer :=16#11f#;
	
	constant adr_digP1 	: integer :=16#12f#;	 
	constant adr_digP2 	: integer :=16#13f#;	 
	constant adr_digP3 	: integer :=16#14f#;	 
	constant adr_digP4 	: integer :=16#15f#;	 
	constant adr_digP5 	: integer :=16#16f#;	 
	constant adr_digP6 	: integer :=16#17f#;	 
	constant adr_digP7 	: integer :=16#18f#;	 
	constant adr_digP8 	: integer :=16#19f#;	 
	constant adr_digP9 	: integer :=16#1af#;	 
	
	constant adr_digH1 		: integer :=16#1b7#;	 
	constant adr_digH2 		: integer :=16#1c7#;	 
	constant adr_digH3 		: integer :=16#1cf#;	 
	constant adr_digH4		: integer :=16#1df#;	 
	constant adr_digH5 		: integer :=16#1e7#;	
	constant adr_digH6 		: integer :=16#1ef#;	
	
	constant adr_access : integer :=16#87#;
	
	signal ena: boolean:= false; 
	signal i2c_valid : boolean;
	signal i2c_adr_mem : type_mem_i2c;
	signal i2c_data_mem : type_mem_i2c;
	type type_array_i2c_q is array (2 downto 0) of type_data_i2c; 
	signal i2c_q : type_array_i2c_q;
	
	signal inBME280: type_inBME280; 
	
begin
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			inBME280<=clear_inbme280; 
		elsif rising_edge(clock) and ena then 
			
			if i2c_valid then i2c_q(2 downto 1)<=i2c_q(1 downto 0); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_bme280 then	inBME280.act<=i2c_q(0)=bme280_ID; end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT1 then	inBME280.t_dig(1)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT2 then	inBME280.t_dig(2)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT3 then	inBME280.t_dig(3)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP1 then	inBME280.p_dig(1)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP2 then	inBME280.p_dig(2)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP3 then	inBME280.p_dig(3)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP4 then	inBME280.p_dig(4)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP5 then	inBME280.p_dig(5)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP6 then	inBME280.p_dig(6)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP7 then	inBME280.p_dig(7)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP8 then	inBME280.p_dig(8)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP9 then	inBME280.p_dig(9)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH1 then	inBME280.h_dig(1)<=conv_integer(i2c_q(0)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH2 then	inBME280.h_dig(2)<=conv_integer(i2c_q(0) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH3 then	inBME280.h_dig(3)<=conv_integer(i2c_q(0)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH4 then	inBME280.h_dig(4)<=conv_integer(i2c_q(1) & i2c_q(0)(3 downto 0)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH5 then	inBME280.h_dig(5)<=conv_integer(i2c_q(0)(7 downto 4) & i2c_q(1)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH6 then	inBME280.h_dig(6)<=conv_integer(i2c_q(0)); end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_press then inBME280.p_adc<=conv_integer(i2c_q(2) & i2c_q(1) & i2c_q(0)(7 downto 4)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_temp then inBME280.t_adc<=conv_integer(i2c_q(2) & i2c_q(1) & i2c_q(0)(7 downto 4)); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_hum then inBME280.h_adc<=conv_integer(i2c_q(1) & i2c_q(0)); end if;
		end if;
	end process main_proc; 
	--------------------------------------------	
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
	generic map( ref_freq => ref_freq, scl_freq => 500000 )
	port map(
		reset => reset,
		clock => clock,
		scl => scl,
		sda => sda,
		ena => ena,
		adr => i2c_adr_mem,
		data => i2c_data_mem,
		i2c_valid => i2c_valid,
		i2c_q => i2c_q(0)
		);
	
	bme280_data_calc1 : entity work.bme280_data_comp 
	port map( reset => reset, clock => clock,
		i_BME280 => inBME280,
		o_BME280 => bme280
		); 

end main; 