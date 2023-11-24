-------------------------------------------------------------------------------
-- Title       : bme280_module
-- Design      : Bosch bme280 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

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
	constant bme280_ID : type_data_i2c :=x"60";	 
	
	constant adr_bme280 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#07#,mem_a_i2c_width));
	
	constant adr_press : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#97#,mem_a_i2c_width));
	constant adr_temp  : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#af#,mem_a_i2c_width));
	constant adr_hum   : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#bf#,mem_a_i2c_width));	  
	
	constant adr_digT1 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#0ff#,mem_a_i2c_width));	 
	constant adr_digT2 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#10f#,mem_a_i2c_width));	 
	constant adr_digT3 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#11f#,mem_a_i2c_width));
	
	constant adr_digP1 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#12f#,mem_a_i2c_width));	 
	constant adr_digP2 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#13f#,mem_a_i2c_width));	 
	constant adr_digP3 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#14f#,mem_a_i2c_width));	 
	constant adr_digP4 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#15f#,mem_a_i2c_width));	 
	constant adr_digP5 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#16f#,mem_a_i2c_width));	 
	constant adr_digP6 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#17f#,mem_a_i2c_width));	 
	constant adr_digP7 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#18f#,mem_a_i2c_width));	 
	constant adr_digP8 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#19f#,mem_a_i2c_width));	 
	constant adr_digP9 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1af#,mem_a_i2c_width));	 
	
	constant adr_digH1 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1b7#,mem_a_i2c_width));	 
	constant adr_digH2 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1c7#,mem_a_i2c_width));	 
	constant adr_digH3 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1cf#,mem_a_i2c_width));	 
	constant adr_digH4 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1df#,mem_a_i2c_width));	 
	constant adr_digH5 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1e7#,mem_a_i2c_width));	
	constant adr_digH6 : type_mem_a_i2c :=std_logic_vector(to_unsigned(16#1ef#,mem_a_i2c_width));	
	
	signal ena: boolean:= false; 
	signal i2c_valid : boolean;
	signal i2c_adr_mem : type_mem_a_i2c;
	signal i2c_data_mem : type_mem_d_i2c;
	type type_array_i2c_q is array (2 downto 0) of type_data_i2c; 
	signal i2c_q : type_array_i2c_q;
	signal inBME280: type_inBME280;  
	
	signal data12a,data12b : std_logic_vector(11 downto 0);
	signal sign_d0d1 : std_logic_vector(15 downto 0);
	signal unsign_d0d1,unsign_d0,adc20,adc16 : std_logic_vector(31 downto 0);
	signal signed_q0q1,unsigned_q0q1,unsigned_q0,signed_q0,signed_qa,signed_qb,unsigned_adc20,unsigned_adc16 : signed(31 downto 0);
	
begin
	unsign_d0d1<=x"0000" & i2c_q(0) & i2c_q(1);
	unsigned_q0q1<=signed(unsign_d0d1);
	sign_d0d1<=i2c_q(0) & i2c_q(1);
	signed_q0q1<=resize(signed(sign_d0d1),32);
	unsign_d0<=x"000000" & i2c_q(0);
	unsigned_q0<=signed(unsign_d0);
	signed_q0<=resize(signed(i2c_q(0)),32);
	
	data12a<=i2c_q(1) & i2c_q(0)(3 downto 0);
	signed_qa<=resize(signed(data12a),32);

	data12b<=i2c_q(0) & i2c_q(1)(7 downto 4);
	signed_qb<=resize(signed(data12b),32); 
	
	adc20<=x"000" & i2c_q(2) & i2c_q(1) & i2c_q(0)(7 downto 4);
	unsigned_adc20<=signed(adc20);
	adc16<=x"0000" & i2c_q(1) & i2c_q(0);
	unsigned_adc16<=signed(adc16);
  
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			inBME280<=clear_inbme280; 
		elsif rising_edge(clock) and ena then 
			if i2c_valid then i2c_q(2 downto 1)<=i2c_q(1 downto 0); end if;
			if i2c_valid and i2c_adr_mem=adr_bme280 then	inBME280.act<=i2c_q(0)=bme280_ID; end if;
			--------------------------------------------	
			if i2c_valid and i2c_adr_mem=adr_digT1 then	inBME280.t_dig(1)<=unsigned_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digT2 then	inBME280.t_dig(2)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digT3 then	inBME280.t_dig(3)<=signed_q0q1; end if;
			------------------------	
			if i2c_valid and i2c_adr_mem=adr_digP1 then	inBME280.p_dig(1)<=unsigned_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP2 then	inBME280.p_dig(2)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP3 then	inBME280.p_dig(3)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP4 then	inBME280.p_dig(4)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP5 then	inBME280.p_dig(5)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP6 then	inBME280.p_dig(6)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP7 then	inBME280.p_dig(7)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP8 then	inBME280.p_dig(8)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digP9 then	inBME280.p_dig(9)<=signed_q0q1; end if;
			------------------------	
			if i2c_valid and i2c_adr_mem=adr_digH1 then	inBME280.h_dig(1)<=unsigned_q0; end if;
			if i2c_valid and i2c_adr_mem=adr_digH2 then	inBME280.h_dig(2)<=signed_q0q1; end if;
			if i2c_valid and i2c_adr_mem=adr_digH3 then	inBME280.h_dig(3)<=unsigned_q0; end if;
			if i2c_valid and i2c_adr_mem=adr_digH4 then	inBME280.h_dig(4)<=signed_qa; end if;
			if i2c_valid and i2c_adr_mem=adr_digH5 then	inBME280.h_dig(5)<=signed_qb; end if;
			if i2c_valid and i2c_adr_mem=adr_digH6 then	inBME280.h_dig(6)<=signed_q0; end if;
			------------------------	
			if i2c_valid and i2c_adr_mem=adr_press then inBME280.p_adc<=unsigned_adc20; end if;
			if i2c_valid and i2c_adr_mem=adr_temp then inBME280.t_adc<=unsigned_adc20; end if;
			if i2c_valid and i2c_adr_mem=adr_hum then inBME280.h_adc<=unsigned_adc16; end if;
		end if;
	end process main_proc; 
	--------------------------------------------	
	bme240_i2cmem1 : entity work.bme240_i2cmem 
	port map( reset=>reset, clk=>clock,
		ce=>'1', oce=>'1',
		ad=>i2c_adr_mem,
		dout=>i2c_data_mem );
	
	I2C_interface1 : entity work.I2C_interface 
	generic map( ref_freq=>ref_freq, scl_freq=>500000 )
	port map( reset=>reset, clock=>clock,
		scl=>scl, sda=>sda,
		ena=>ena,
		adr=>i2c_adr_mem,
		data=>i2c_data_mem,
		i2c_valid=>i2c_valid,
		i2c_q=>i2c_q(0) );
	
	bme280_data_calc1 : entity work.bme280_data_comp 
	port map( reset=>reset, clock=>clock,
		i_BME280=>inBME280,
		o_BME280=>bme280 ); 
	
end main; 