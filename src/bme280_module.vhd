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
package bme280_lib is  	   
	subtype type_inbme280val is std_logic_vector(31 downto 0);	 
	type type_inBME280 is record
		act : std_logic;
		P : std_logic_vector(31 downto 0);
		T : std_logic_vector(31 downto 0);
		H : std_logic_vector(31 downto 0);
	end record;
	constant max_bme280val : integer :=16; 	  
	subtype type_bme280val is std_logic_vector(max_bme280val-1 downto 0);	 
	type type_outBME280 is record
		act : boolean;
		P : type_bme280val;
		T : type_bme280val;
		H : type_bme280val;
	end record;
	constant clear_bme280 : type_outBME280 := (false,(others=>'0'),(others=>'0'),(others=>'0'));	
end bme280_lib;
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
		BME280: out type_outBME280 );
end bme280_module;

architecture main of bme280_module is			 
	constant bme280_ID : std_logic_vector(7 downto 0) :=x"60";	 
	
	constant adr_bme280 : integer :=16#07#;
	
	constant adr_press2 : integer :=16#87#;
	constant adr_press1 : integer :=16#8f#;
	constant adr_press0 : integer :=16#97#;
	constant adr_temp2 	: integer :=16#9f#;
	constant adr_temp1 	: integer :=16#a7#;
	constant adr_temp0 	: integer :=16#af#;
	constant adr_hum1 	: integer :=16#b7#;
	constant adr_hum0 	: integer :=16#bf#;	  
	
	constant adr_digT1_l 	: integer :=16#0f7#;	 
	constant adr_digT1_h 	: integer :=16#0ff#;	 
	constant adr_digT2_l 	: integer :=16#107#;	 
	constant adr_digT2_h 	: integer :=16#10f#;	 
	constant adr_digT3_l 	: integer :=16#117#;	 
	constant adr_digT3_h 	: integer :=16#11f#;
	
	constant adr_digP1_l 	: integer :=16#127#;	 
	constant adr_digP1_h 	: integer :=16#12f#;	 
	constant adr_digP2_l 	: integer :=16#137#;	 
	constant adr_digP2_h 	: integer :=16#13f#;	 
	constant adr_digP3_l 	: integer :=16#147#;	 
	constant adr_digP3_h 	: integer :=16#14f#;	 
	constant adr_digP4_l 	: integer :=16#157#;	 
	constant adr_digP4_h 	: integer :=16#15f#;	 
	constant adr_digP5_l 	: integer :=16#167#;	 
	constant adr_digP5_h 	: integer :=16#16f#;	 
	constant adr_digP6_l 	: integer :=16#177#;	 
	constant adr_digP6_h 	: integer :=16#17f#;	 
	constant adr_digP7_l 	: integer :=16#187#;	 
	constant adr_digP7_h 	: integer :=16#18f#;	 
	constant adr_digP8_l 	: integer :=16#197#;	 
	constant adr_digP8_h 	: integer :=16#19f#;	 
	constant adr_digP9_l 	: integer :=16#1a7#;	 
	constant adr_digP9_h 	: integer :=16#1af#;	 
	
	constant adr_digH1 		: integer :=16#1b7#;	 
	constant adr_digH2_l 	: integer :=16#1bf#;	 
	constant adr_digH2_h 	: integer :=16#1c7#;	 
	constant adr_digH3 		: integer :=16#1cf#;	 
	constant adr_digH4 		: integer :=16#1d7#;	 
	constant adr_digH45		: integer :=16#1df#;	 
	constant adr_digH5 		: integer :=16#1e7#;	
	constant adr_digH6 		: integer :=16#1ef#;	
	
	constant adr_access : integer :=16#87#;
	
	constant value_calc_data : integer :=16;	 
	subtype type_calc_data is std_logic_vector(value_calc_data-1 downto 0);
	subtype type_calc2_data is std_logic_vector(value_calc_data*2-1 downto 0);
	subtype type_calc3_data is std_logic_vector(value_calc_data*3-1 downto 0);
	subtype type_calc4_data is std_logic_vector(value_calc_data*4-1 downto 0); 
	
	function shift32L(d:type_calc2_data; n:integer) return type_calc2_data is
		variable q : type_calc2_data;
	begin 
		q(value_calc_data*2-1 downto n):=d(value_calc_data*2-1-n downto 0);
		q(n-1 downto 0):=(others=>'0');																	  
		return q;																	  
	end shift32L; 
	function shift32R(d:type_calc2_data;n:integer) return type_calc2_data is
		variable q : type_calc2_data;
	begin 
		q(value_calc_data*2-n-1 downto 0):=d(value_calc_data*2-1 downto n);
		q(value_calc_data*2-1 downto value_calc_data*2-n):=(others=>'0');																	  
		return q;																	  
	end shift32R;  
	
	function shiftS32R(d:type_calc2_data;n:integer) return type_calc2_data is
		variable q : type_calc2_data;
	begin 
		q(value_calc_data*2-n-1 downto 0):=d(value_calc_data*2-1 downto n);
		q(value_calc_data*2-1 downto value_calc_data*2-n):=(others=>q(value_calc_data*2-1));																	  
		return q;																	  
	end shiftS32R;  
	
	function shiftS48R(d:type_calc3_data;n:integer) return type_calc3_data is
		variable q : type_calc3_data;
	begin 
		q(value_calc_data*3-n-1 downto 0):=d(value_calc_data*3-1 downto n);
		q(value_calc_data*3-1 downto value_calc_data*3-n):=(others=>q(value_calc_data*3-1));																	  
		return q;																	  
	end shiftS48R; 
	
	signal ena: boolean:= false; 
	signal i2c_valid : boolean;
	signal i2c_adr_mem : type_mem_i2c;
	signal i2c_data_mem : type_mem_i2c;
	signal i2c_q : type_data_i2c;
	
	signal dig_T1,dig_T2,dig_T3: std_logic_vector(15 downto 0); 
	signal adc_T: std_logic_vector(19 downto 0); 
--	signal T_var2d: std_logic_vector(15 downto 0); 
--	signal T_var1,T_var1b,T_var2,T_var2b,T_var2c: std_logic_vector(31 downto 0); 
--	signal T_var1a,T_var2a,Ta: std_logic_vector(47 downto 0); 
--	signal t_fine: std_logic_vector(31 downto 0); 
--	signal T: std_logic_vector(15 downto 0); 	
	
	signal dig_P1,dig_P2,dig_P3,dig_P4,dig_P5,dig_P6,dig_P7,dig_P8,dig_P9: std_logic_vector(15 downto 0); 
	signal adc_P: std_logic_vector(19 downto 0); 
--	signal P_var1a: std_logic_vector(31 downto 0); 
--	signal P_varXa: std_logic_vector(47 downto 0); 
--	signal P_var2b,P_var2c: std_logic_vector(51 downto 0); 
--	signal P_var2a: std_logic_vector(63 downto 0); 
	
	signal dig_H1,dig_H3,dig_H6: std_logic_vector(7 downto 0); 
	signal dig_H4,dig_H5: std_logic_vector(11 downto 0); 
	signal dig_H2: std_logic_vector(15 downto 0); 
	signal adc_H: std_logic_vector(15 downto 0); 
--	signal H_var1: std_logic_vector(31 downto 0); 
	
	signal present: std_logic;
	signal inBME280,outBME280: type_inBME280; 
	
begin
--	--------------------------------------------
--	-- BME280.T calculation
--	-- var1=((((adc_T/8)-(dig_T1*2)))*(dig_T2))/2048
--	T_var1b<=(shift32R(ext(adc_T,32),3)- shift32L(sxt(dig_T1,32),1));
--	mult_1 : entity work.mult32x16 
--	port map( reset => reset, clk => clock, ce => '1',
--		a => T_var1b, b => dig_T2, dout => T_var1a );
--	T_var1<=sxt(shiftS48R(T_var1a,11),32);  
--	-- var2=(((((adc_T/16)-(dig_T1))*((adc_T/16)-(dig_T1)))/4096)*(dig_T3))/16384
--	T_var2d<=ext(shift32R(ext(adc_T,32),4),16)- dig_T1;
--	mult_2 : entity work.mult16x16 
--	port map( reset => reset, clk => clock, ce => '1',
--		a => T_var2d, b => T_var2d, dout => T_var2c );
--	T_var2b<=shift32R(T_var2c,12);
--	mult_3 : entity work.mult32x16 
--	port map( reset => reset, clk => clock, ce => '1',
--		a => T_var2b, b => dig_T3, dout => T_var2a );
--	T_var2<=sxt(shiftS48R(T_var2a,14),32);
--	-- t_fine=var1+var2
--	t_fine<=T_var1 + T_var2;  
--	-- T=(t_fine*5+128)/256
--	mult_4 : entity work.mult32x16 
--	port map( reset => reset, clk => clock, ce => '1',
--	a => t_fine, b => x"0005", dout => Ta );
--	T<=sxt(shiftS48R((Ta+128),8),16);
	--------------------------------------------	
	--// Returns BME280.P in Pa as unsigned 32 bit integer in Q24.8 format (24 integer bits and 8 fractional bits).
	--// Output value of “24674867” represents 24674867/256 = 96386.2 Pa = 963.862 hPa
	--BME280_U32_t BME280_compensate_P_int64(BME280_S32_t adc_P)
	--{
	--BME280_S64_t var1, var2, p;
	--var1 = ((BME280_S64_t)t_fine) – 128000;
	--var2 = var1 * var1 * (BME280_S64_t)dig_P6;  
	--var2 = var2 + ((var1*(BME280_S64_t)dig_P5)<<17);	
	--var2 = var2 + (((BME280_S64_t)dig_P4)<<35);
	--var1 = ((var1 * var1 * (BME280_S64_t)dig_P3)>>8) + ((var1 * (BME280_S64_t)dig_P2)<<12);
	--var1 = (((((BME280_S64_t)1)<<47)+var1))*((BME280_S64_t)dig_P1)>>33;
	--if (var1 == 0)
	--{
	--return 0; // avoid exception caused by division by zero
	--}
	--p = 1048576-adc_P;
	--p = (((p<<31)-var2)*3125)/var1;
	--var1 = (((BME280_S64_t)dig_P9) * (p>>13) * (p>>13)) >> 25;
	--var2 = (((BME280_S64_t)dig_P8) * p) >> 19;
	--p = ((p + var1 + var2) >> 8) + (((BME280_S64_t)dig_P7)<<4);
	--return (BME280_U32_t)p;		
	
	
	
	--------------------------------------------	
	--// Returns BME280.H in %RH as unsigned 32 bit integer in Q22.10 format (22 integer and 10 fractional bits).
	--// Output value of “47445” represents 47445/1024 = 46.333 %RH
	--BME280_U32_t bme280_compensate_H_int32(BME280_S32_t adc_H)
	--{
	--BME280_S32_t v_x1_u32r;
	--v_x1_u32r = (t_fine – ((BME280_S32_t)76800));
	--v_x1_u32r = (((((adc_H << 14) – (((BME280_S32_t)dig_H4) << 20) – (((BME280_S32_t)dig_H5) * v_x1_u32r)) + ((BME280_S32_t)16384)) >> 15) * (((((((v_x1_u32r * ((BME280_S32_t)dig_H6)) >> 10) * (((v_x1_u32r * ((BME280_S32_t)dig_H3)) >> 11) + ((BME280_S32_t)32768))) >> 10) + ((BME280_S32_t)2097152)) * ((BME280_S32_t)dig_H2) + 8192) >> 14)); 
	--v_x1_u32r = (v_x1_u32r – (((((v_x1_u32r >> 15) * (v_x1_u32r >> 15)) >> 7) * ((BME280_S32_t)dig_H1)) >> 4));
	--v_x1_u32r = (v_x1_u32r < 0 ? 0 : v_x1_u32r);
	--v_x1_u32r = (v_x1_u32r > 419430400 ? 419430400 : v_x1_u32r); return (BME280_U32_t)(v_x1_u32r>>12);	
	--------------------------------------------	
	--------------------------------------------	
	------v_x1_u32r = (((((adc_H << 14) – (((BME280_S32_t)dig_H4) << 20) – (((BME280_S32_t)dig_H5) * v_x1_u32r)) + ((BME280_S32_t)16384)) >> 15) * (((((((v_x1_u32r * ((BME280_S32_t)dig_H6)) >> 10) * (((v_x1_u32r * ((BME280_S32_t)dig_H3)) >> 11) + ((BME280_S32_t)32768))) >> 10) + ((BME280_S32_t)2097152)) * ((BME280_S32_t)dig_H2) + 8192) >> 14)); 
	----v_x1_u32rA = ((((adc_H << 14) – (((BME280_S32_t)dig_H4) << 20) – (((BME280_S32_t)dig_H5) * v_x1_u32r)) + ((BME280_S32_t)16384)) >> 15)
	--v_x1_u32rA1 =(adc_H << 14) – (((BME280_S32_t)dig_H4) << 20)
	--v_x1_u32rA2 =(((BME280_S32_t)dig_H5) * v_x1_u32r)
	--v_x1_u32rA3 =v_x1_u32rA1 – v_x1_u32rA2
	--v_x1_u32rA =v_x1_u32rA3 + ((BME280_S32_t)16384)) >> 15)
	----v_x1_u32rB = (((((((v_x1_u32r * ((BME280_S32_t)dig_H6)) >> 10) * (((v_x1_u32r * ((BME280_S32_t)dig_H3)) >> 11) + ((BME280_S32_t)32768))) >> 10) + ((BME280_S32_t)2097152)) * ((BME280_S32_t)dig_H2) + 8192) >> 14); 
	--v_x1_u32rB1 = (v_x1_u32r * ((BME280_S32_t)dig_H6))
	--v_x1_u32rB2 = ((v_x1_u32r * ((BME280_S32_t)dig_H3))
	--v_x1_u32rB3 = (v_x1_u32rB1 >> 10) * (v_x1_u32rB2 >> 11)
	--v_x1_u32rB4 = (v_x1_u32rB3 + 32768) >> 10
	--v_x1_u32rB5 = v_x1_u32rB4 + 2097152
	--v_x1_u32rB6 = v_x1_u32rB5 * dig_H2
	--v_x1_u32rB = (v_x1_u32rB6 + 8192) >> 14
	----v_x1_u32r = v_x1_u32rA * v_x1_u32rB
	
	
	
	
	------v_x1_u32r = (v_x1_u32r – (((((v_x1_u32r >> 15) * (v_x1_u32r >> 15)) >> 7) * ((BME280_S32_t)dig_H1)) >> 4));
	------v_x1_u32r = (v_x1_u32r < 0 ? 0 : v_x1_u32r);
	------v_x1_u32r = (v_x1_u32r > 419430400 ? 419430400 : v_x1_u32r); return (BME280_U32_t)(v_x1_u32r>>12);	
	
	--------------------------------------------	
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			present<='0';
			BME280<=clear_bme280; 
		elsif rising_edge(clock) and ena then 
			BME280.act<=present='1'; 
			if outBME280.act='1' then	
				BME280.P<=outBME280.P(15 downto 0); 
				BME280.T<=outBME280.T(15 downto 0); 
				BME280.H<=outBME280.H(15 downto 0); 
			end if;
			
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_bme280 then	present<=boolean_to_data(i2c_q=bme280_ID); end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT1_h then	dig_T1(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT1_l then	dig_T1(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT2_h then	dig_T2(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT2_l then	dig_T2(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT3_h then	dig_T3(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digT3_l then	dig_T3(7 downto 0)<=i2c_q; end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP1_h then	dig_P1(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP1_l then	dig_P1(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP2_h then	dig_P2(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP2_l then	dig_P2(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP3_h then	dig_P3(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP3_l then	dig_P3(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP4_h then	dig_P4(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP4_l then	dig_P4(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP5_h then	dig_P5(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP5_l then	dig_P5(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP6_h then	dig_P6(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP6_l then	dig_P6(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP7_h then	dig_P7(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP7_l then	dig_P7(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP8_h then	dig_P8(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP8_l then	dig_P8(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP9_h then	dig_P9(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digP9_l then	dig_P9(7 downto 0)<=i2c_q; end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH1 then	dig_H1<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH2_h then	dig_H2(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH2_l then	dig_H2(7 downto 0)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH3 then	dig_H3<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH4 then	dig_H4(11 downto 4)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH45 then	dig_H4(3 downto 0)<=i2c_q(3 downto 0); dig_H5(3 downto 0)<=i2c_q(7 downto 4); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH5 then	dig_H5(11 downto 4)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_digH6 then	dig_H6<=i2c_q; end if;
			--------------------------------------------	
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_press2 then adc_P(19 downto 12)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_press1 then adc_P(11 downto 4)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_press0 then adc_P(3 downto 0)<=i2c_q(7 downto 4); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_temp2 then adc_T(19 downto 12)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_temp1 then adc_T(11 downto 4)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_temp0 then adc_T(3 downto 0)<=i2c_q(7 downto 4); end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_hum1 then adc_H(15 downto 8)<=i2c_q; end if;
			if i2c_valid and conv_integer(i2c_adr_mem)=adr_hum0 then adc_H(7 downto 0)<=i2c_q; end if;
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
		i2c_q => i2c_q
		);
	
	inBME280.act<=present;
	inBME280.P<=ext(adc_P,32);
	inBME280.T<=ext(adc_T,32);
	inBME280.H<=ext(adc_H,32);
	bme280_data_calc1 : entity work.bme280_data_comp 
	port map(
		i_rst => reset,
		i_clk => clock,
		i_adc_T => inBME280.T,
		i_adc_P => inBME280.P,
		i_adc_H => inBME280.H,
		i_adc_vld => inBME280.act,
		o_temperature => outBME280.T,
		o_pressure => outBME280.P,
		o_humidity => outBME280.H,
		o_valid => outBME280.act
		);
end main; 