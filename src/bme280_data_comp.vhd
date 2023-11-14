-------------------------------------------------------------------------------
-- Title       : bme280 calculate
-- Design      : Bosch bme280 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use IEEE.std_logic_unsigned.all;
use work.bme280_lib.all;

entity bme280_data_comp is
	port ( reset : in  std_logic; 
		clock : in  std_logic;  
		i_bme280 : in  type_inBME280;
		o_bme280 : out  type_outBME280
		);
end entity bme280_data_comp;

architecture rtl of bme280_data_comp is
	
	constant dig_T1 : signed(31 downto 0) := to_signed(28383, 32);
	constant dig_T2 : signed(31 downto 0) := to_signed(26777, 32);
	constant dig_T3 : signed(31 downto 0) := to_signed(   50, 32);
	
	constant dig_P1 : signed(63 downto 0) := to_signed( 36602, 64);
	constant dig_P2 : signed(63 downto 0) := to_signed(-10496, 64);
	constant dig_P3 : signed(63 downto 0) := to_signed(  3024, 64);
	constant dig_P4 : signed(63 downto 0) := to_signed(  6826, 64);
	constant dig_P5 : signed(63 downto 0) := to_signed(  19, 64);
	constant dig_P6 : signed(63 downto 0) := to_signed(    -7, 64);
	constant dig_P7 : signed(63 downto 0) := to_signed( 9900, 64);
	constant dig_P8 : signed(63 downto 0) := to_signed(-10230, 64);
	constant dig_P9 : signed(63 downto 0) := to_signed(  4285, 64);
	
	constant dig_H1 : signed(31 downto 0) := to_signed( 75, 32);
	constant dig_H2 : signed(31 downto 0) := to_signed(370, 32);
	constant dig_H3 : signed(31 downto 0) := to_signed(  0, 32);
	constant dig_H4 : signed(31 downto 0) := to_signed(300, 32);
	constant dig_H5 : signed(31 downto 0) := to_signed( 50, 32);
	constant dig_H6 : signed(31 downto 0) := to_signed( 30, 32);
	
	-- Temperature
	--	signal t_var1       : signed(31 downto 0);
	signal t_var1_temp1 : signed(31 downto 0);
	signal t_var1_temp2 : signed(31 downto 0);
	--	signal t_var2       : signed(31 downto 0);
	signal t_var2_temp1 : signed(31 downto 0);
	signal t_var2_temp2 : signed(31 downto 0);
	signal t_var2_temp3 : signed(31 downto 0);
	signal t_fine       : signed(31 downto 0);
	
	-- Pressure
	signal p_var1_temp1 : signed(63 downto 0);
	signal p_var1_temp2 : signed(63 downto 0);
	signal p_var1_temp3 : signed(63 downto 0);
	signal p_var1_temp4 : signed(63 downto 0);
	signal p_var1_temp5 : signed(63 downto 0);
	signal p_var1_temp6 : signed(63 downto 0);
	signal p_var1_temp7 : signed(63 downto 0);
	signal p_var1       : signed(63 downto 0);
	signal p_var2_temp1 : signed(63 downto 0);
	signal p_var2_temp2 : signed(63 downto 0);
	signal p_var2_temp3 : signed(63 downto 0);
	signal p_var2_temp4 : signed(63 downto 0);
	signal p_var2       : signed(63 downto 0);
	signal p_temp1      : signed(63 downto 0);
	signal p_temp2      : signed(63 downto 0);
	signal p_temp3      : signed(63 downto 0);
	signal var3_temp1   : signed(63 downto 0);
	signal var3         : signed(63 downto 0);
	signal var4         : signed(63 downto 0);
	signal p_temp4      : signed(63 downto 0);
	signal p_temp5      : signed(63 downto 0);
	signal p_temp6      : signed(63 downto 0);
	
	-- Humidity
	signal h_var1        : signed(31 downto 0);
	signal h_var2_temp1  : signed(31 downto 0);
	signal h_var2_temp2  : signed(31 downto 0);
	signal h_var2_temp3  : signed(31 downto 0);
	signal h_var2_temp4  : signed(31 downto 0);
	signal h_var2_temp5  : signed(31 downto 0);
	signal h_var2_temp6  : signed(31 downto 0);
	signal h_var2_temp7  : signed(31 downto 0);
	signal h_var2_temp8  : signed(31 downto 0);
	signal h_var2_temp9  : signed(31 downto 0);
	signal h_var2_temp10 : signed(31 downto 0);
	signal h_var2_temp11 : signed(31 downto 0);
	signal h_var2_temp11_temp : signed(31 downto 0);
	signal h_var2        : signed(31 downto 0);
	--	signal h_var3_temp1  : signed(31 downto 0);
	signal h_var3_temp2  : signed(31 downto 0);
	signal h_var3_temp3  : signed(31 downto 0);
	signal h_var3        : signed(31 downto 0);
	
	-- Constants in calculation formulars
	constant C_PRESSURE_CONST1 : signed(63 downto 0) := x"0000_0000_0000_FA00"; --64000
	constant C_PRESSURE_CONST2 : signed(63 downto 0) := x"0000_0000_0010_0000"; --1048576
	constant C_PRESSURE_CONST3 : signed(63 downto 0) := x"0000_0000_0000_186a"; --6250
	constant C_PRESSURE_CONST4 : signed(63 downto 0) := x"0000_0000_0000_8000"; --32768
	constant C_HUMIDITY_CONST1 : signed(31 downto 0) := x"0001_2C00"; --76800
	constant C_HUMIDITY_CONST2 : signed(31 downto 0) := x"0000_8000"; --32768
	constant C_HUMIDITY_CONST3 : signed(31 downto 0) := x"0000_8000"; --32768
	constant C_HUMIDITY_CONST4 : signed(31 downto 0) := x"0000_2000"; --8192
	constant C_HUMIDITY_CONST5 : signed(31 downto 0) := x"0020_0000"; --2097152
	constant C_HUMIDITY_CONST6 : signed(31 downto 0) := x"1900_0000"; --419430400
	
	
	constant C_TEMP_PIPELINE_LENGTH : integer := 6;
	constant C_PRES_PIPELINE_LENGTH : integer := 18;
	constant C_DIV_PIPELINE_LENGTH  : integer := 0;
	constant C_HUM_PIPELINE_LENGTH  : integer := 11;
	constant C_PIPELINE_LENGTH      : integer := C_TEMP_PIPELINE_LENGTH + C_PRES_PIPELINE_LENGTH + C_DIV_PIPELINE_LENGTH + C_HUM_PIPELINE_LENGTH;
	--	signal vld_pipeline : std_logic_vector(C_PIPELINE_LENGTH - 1 downto 0);	 
	type type_array_boolean is array (C_PIPELINE_LENGTH - 1 downto 0) of boolean;
	signal temp_vld_pipeline : type_array_boolean;
	--	signal valid        : std_logic;
	signal p_quotient : std_logic_vector(63 downto 0);
	
begin
	
	Valid_proc: process (reset,clock)
	begin
		if reset = '1' then
			temp_vld_pipeline <= (others => false);
			o_bme280.act <= false;
		elsif rising_edge(clock) then
			temp_vld_pipeline <= i_bme280.act & temp_vld_pipeline(C_PIPELINE_LENGTH - 1 downto 1);
			
			if temp_vld_pipeline(0) then
				o_bme280.act <= true;
			elsif i_bme280.act then
				o_bme280.act <= false;
			end if;
		end if;
	end process Valid_proc;
	
	Tcalc_proc: process (clock)
	begin
		if rising_edge(clock) then         
			t_var1_temp1 <= shift_right(signed(i_bme280.adc_T), 3) - signed(shift_left(dig_T1, 1));
			t_var1_temp2 <= resize(t_var1_temp1 * dig_T2, 32);
			t_var2_temp1 <= shift_right(signed(i_bme280.adc_T), 4) - signed(dig_T1);
			t_var2_temp2 <= shift_right(resize(t_var2_temp1 * t_var2_temp1, 32), 12);
			t_var2_temp3 <= resize(t_var2_temp2 * dig_T3, 32);
			t_fine <= shift_right(signed(t_var1_temp2), 11) + shift_right(t_var2_temp3, 14);
			o_bme280.T <= std_logic_vector(shift_right(resize(t_fine * 5, 32) + x"00000080", 8));
		end if;
	end process Tcalc_proc;
	
	
	Pcalc1_proc: process (clock)
	begin
		if rising_edge(clock) then
			p_var1_temp1 <= shift_right(resize(t_fine, 64) - C_PRESSURE_CONST1, 2);
			p_var1_temp2 <= resize(p_var1_temp1 * p_var1_temp1, 64);
			p_var2_temp1 <= shift_right(resize(p_var1_temp2 * dig_P6, 64), 15); 
			p_var2_temp2 <= shift_left(resize(p_var1_temp1 * dig_P5, 64), 1);
			p_var2_temp3 <= p_var2_temp1 + p_var2_temp2;
			p_var2_temp4 <= shift_right(p_var2_temp3,2) + shift_left(dig_P4, 16);
			
			p_var1_temp3 <= shift_right(resize(p_var1_temp2 * dig_P3, 64), 19);
			p_var1_temp4 <= shift_right(resize(p_var1_temp1 * dig_P2, 64), 19);
			p_var1_temp5 <= p_var1_temp3 + p_var1_temp4;   
			p_var1_temp6 <= shift_right(C_PRESSURE_CONST4 + p_var1_temp5,15);
			p_var1_temp7 <= resize(p_var1_temp6 * dig_P1, 64);
			p_temp1 <= C_PRESSURE_CONST2 - resize(signed(i_bme280.adc_P), 64);
			p_temp2 <= p_temp1-shift_right(p_var2_temp4, 12);
			p_temp3 <= resize(p_temp2 * C_PRESSURE_CONST3, 64);
			--numenator <= p_temp3;
			--denumenator <= p_var1_temp7;
			--p_temp4<=p_quotient
			var3_temp1 <= resize(shift_right(p_temp4, 13) * shift_right(p_temp4, 13), 64);
			var3 <= shift_right(resize(dig_P9 * var3_temp1, 64), 7);
			var4 <= shift_right(resize(dig_P8 * p_temp4, 64), 15);
			p_temp5 <= var3 + var4;
			p_temp6 <= shift_left(p_temp5 + dig_P7, 4);
			o_bme280.P <= std_logic_vector(shift_right(resize(unsigned(std_logic_vector(p_temp4+p_temp6)), 32),8));
			
		end if;
	end process Pcalc1_proc;
	
	--	lpm_divide_s64_1 : entity work.lpm_divide_s64 
	--	port map(
	--		rstn => '1', clk => clock,
	--		dividend => std_logic_vector(p_temp3),
	--		divisor => std_logic_vector(p_var1_temp7),
	--		quotient => p_quotient); 
	--	p_temp4<=signed(p_quotient);
	
	lpm_divide_s64_1: process (clock)
		variable int_p_temp3 : signed(63 downto 0);
		variable int_p_var1 : signed(63 downto 0);
		variable int_p_quotient : std_logic_vector(63 downto 0);
	begin
		if rising_edge(clock) then	
			if int_p_temp3<int_p_var1 then
				int_p_temp3:=int_p_temp3-int_p_var1;
				int_p_quotient:=std_logic_vector(resize(signed(int_p_quotient) + 1,64));
			else
				int_p_temp3:=p_temp3;
				int_p_var1:=p_var1_temp7;
				p_temp4<=signed(int_p_quotient);
				int_p_quotient:=(others=>'0'); 
			end if;
		end if;
	end process lpm_divide_s64_1;
	
	Hcalc_proc: process (clock)
	begin
		if rising_edge(clock) then
			h_var1 <= t_fine - C_HUMIDITY_CONST1;
			h_var2_temp1  <= shift_left(resize(signed(i_bme280.adc_h),32), 14);
			h_var2_temp2  <= shift_left(dig_H4, 20);
			h_var2_temp3  <= resize(dig_H5 * h_var1, 32);
			h_var2_temp4  <= shift_right(h_var2_temp1 - h_var2_temp2 - h_var2_temp3 + C_HUMIDITY_CONST2, 15);	   
			h_var2_temp5  <= shift_right(resize(h_var1 * dig_H6, 32), 10);
			h_var2_temp6  <= shift_right(resize(h_var1 * dig_H3, 32), 11);
			h_var2_temp7  <= h_var2_temp6 + C_HUMIDITY_CONST3;
			h_var2_temp8  <= shift_right(resize(h_var2_temp5 * h_var2_temp7, 32), 10);
			h_var2_temp9  <= h_var2_temp8 + C_HUMIDITY_CONST5;
			h_var2_temp10 <= resize(h_var2_temp9 * dig_H2, 32);
			h_var2_temp11 <= shift_right(resize(h_var2_temp10 + C_HUMIDITY_CONST4, 32), 14);
			h_var2        <= resize(h_var2_temp4 * h_var2_temp11, 32);
			h_var3_temp2 <= shift_right(resize(shift_right(h_var2, 15) * shift_right(h_var2, 15), 32), 7);
			h_var3_temp3 <= shift_right(resize(h_var3_temp2 * dig_H1, 32), 4);
			h_var3       <= h_var2 - h_var3_temp3;
			if h_var3 < x"0000_0000" then
				o_bme280.H  <= (others => '0');
			elsif h_var3 > C_HUMIDITY_CONST6 then
				o_bme280.H    <= std_logic_vector(resize(unsigned(std_logic_vector(shift_right(C_HUMIDITY_CONST6, 12))), 32));
			else
				o_bme280.H    <= std_logic_vector(resize(unsigned(std_logic_vector(shift_right(h_var3, 12))), 32));
			end if;
		end if;
	end process Hcalc_proc;
	
end architecture rtl;

