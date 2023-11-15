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

architecture main of bme280_data_comp is
	-- Temperature
	constant t_width : integer :=32;  
	constant t_pipeline_lenght : integer := 7;
	type type_t_dig is array (1 to 3) of integer;
	constant t_dig : type_t_dig := (28383,26777,50);	 
	type type_t_var is array (4 downto 0) of signed(t_width-1 downto 0);
	signal t_var : type_t_var;
	signal t_fine : signed(t_width-1 downto 0);
	
	-- Pressure
	constant p_width : integer :=34;  
	constant p_pipeline_lenght : integer := 22;
	type type_p_dig is array (1 to 9) of integer;
	constant p_dig : type_p_dig := (36602,-10496,3024,6826,19,-7,9900,-10230,4285);	 
	type type_p_const is array (1 to 4) of integer;
	constant p_const : type_p_const := (64000,1048576,6250,32768);
	type type_p_var is array (19 downto 0) of signed(p_width-1 downto 0);
	signal p_var : type_p_var;
	
	-- Humidity
	constant h_width : integer :=32;  
	constant h_pipeline_lenght  : integer := 18;
	type type_h_dig is array (1 to 6) of integer;
	constant h_dig : type_h_dig := (75,370,0,300,50,30);	 
	type type_h_const is array (1 to 6) of integer;
	constant h_const : type_h_const := (76800,32768,32768,8192,2097152,419430400);
	type type_h_var is array (15 downto 0) of signed(h_width-1 downto 0);
	signal h_var : type_h_var; 
	
	constant pipeline_lenght      : integer := t_pipeline_lenght + p_pipeline_lenght + h_pipeline_lenght;
	signal count_vid : integer range 0 to pipeline_lenght;
	signal p_div_valid : boolean;
begin				   
	valid_proc: process (reset,clock)
	begin
		if reset = '1' then
			count_vid<=pipeline_lenght;
			o_bme280.act <= false;
		elsif rising_edge(clock) then
			if not i_bme280.act then
				count_vid<=pipeline_lenght;
			elsif count_vid/=0 then
				count_vid<=count_vid-1;
			end if;
			o_bme280.act <= count_vid=0 and p_div_valid;
		end if;
	end process valid_proc;
	
	t_calc_proc: process (clock)
	begin
		if rising_edge(clock) then         
			t_var(0) <= shift_right(resize(signed(i_bme280.adc_T),t_width), 3) - signed(shift_left(to_signed(t_dig(1),t_width), 1));
			t_var(1) <= resize(t_var(0) * t_dig(2), t_width);
			t_var(2) <= shift_right(resize(signed(i_bme280.adc_T),t_width), 4) - signed(to_signed(t_dig(1),t_width));
			t_var(3) <= shift_right(resize(t_var(2) * t_var(2), t_width), 12);
			t_var(4) <= resize(t_var(3) * t_dig(3), t_width);
			t_fine <= shift_right(signed(t_var(1)), 11) + shift_right(t_var(4), 14);
			o_bme280.T <= std_logic_vector(shift_right(resize(t_fine * 5, outbme280_width) + 128, 8));
		end if;
	end process t_calc_proc;
	
	p_calc_proc: process (clock)
	begin
		if rising_edge(clock) then
			p_var(0) <= shift_right(resize(t_fine, p_width),1) - p_const(1);
			p_var(1) <= resize(p_var(0) * p_var(0), p_width);
			p_var(2) <= shift_right(resize(p_var(1) * p_dig(6), p_width), 15); 
			p_var(3) <= shift_left(resize(p_var(0) * p_dig(5), p_width), 1);
			p_var(4) <= p_var(2) + p_var(3);
			p_var(5) <= shift_right(p_var(4),2) + shift_left(to_signed(p_dig(4),p_width), 16);
			p_var(6) <= shift_right(resize(p_var(1) * p_dig(3), p_width), 19);
			p_var(7) <= resize(p_var(0) * p_dig(2), p_width);
			p_var(8) <= shift_right(p_var(6) + p_var(7), 19);  
			p_var(9) <= p_const(4) + p_var(8);
			p_var(10) <= shift_right(resize(p_var(9) * p_dig(1), p_width),15);
			p_var(11) <= p_const(2) - resize(signed(i_bme280.adc_P), p_width);
			p_var(12) <= p_var(11)-shift_right(p_var(5), 12);
			p_var(13) <= resize(p_var(12) * p_const(3), p_width);
			--					numenator 	<= p_var(13);
			--					denumenator <= p_var(10);
			--	p_var(14)	<=	p_quotient
			p_var(15) <= resize(shift_right(p_var(14), 8) * shift_right(p_var(14), 13), p_width);
			p_var(16) <= shift_right(resize(p_dig(9) * p_var(15), p_width), 15);
			p_var(17) <= shift_right(resize(p_dig(8) * p_var(14), p_width), 15);
			p_var(18) <= p_var(16) + p_var(17);
			p_var(19) <= shift_right(p_var(18) + p_dig(7), 4);
			o_bme280.P <= std_logic_vector(resize(p_var(14)+p_var(19), outbme280_width));
			
		end if;
	end process p_calc_proc;
	
	p_divide_proc: process (reset,clock)
		constant zero : signed(63 downto 0) := (others=>'0'); 
		variable valid : boolean;
		variable dividend : signed(p_width-1 downto 0);
		variable divisor : signed(p_width-1 downto 0);
		variable quotient : std_logic_vector(p_width-1 downto 0);
	begin
		if reset='1' then	
			p_div_valid<=false;
			valid:=false;
			dividend:=(others=>'0');
			divisor:=(others=>'0');
			p_var(14)<=(others=>'0');
			quotient:=(others=>'0'); 
		elsif rising_edge(clock) then	
			if  dividend<divisor then
				if divisor/=zero and i_bme280.act then
					p_div_valid<=valid;
					valid:=true;
				else
					p_div_valid<=false;
					valid:=false;
				end if;
			end if;
			if  dividend<divisor or divisor=zero or not i_bme280.act then
				dividend:=p_var(13);
				divisor:=p_var(10);
				p_var(14)<=signed(quotient);
				quotient:=(others=>'0'); 
			else
				dividend:=dividend-divisor;
				quotient:=std_logic_vector(resize(signed(quotient) + 1,p_width));
			end if;
		end if;
	end process p_divide_proc;	  
	
	h_calc_proc: process (clock)
	begin
		if rising_edge(clock) then
			h_var(0) <= t_fine - h_const(1);
			h_var(1)  <= shift_left(resize(signed(i_bme280.adc_h),h_width), 14);
			h_var(2)  <= shift_left(to_signed(h_dig(4),h_width), 20);
			h_var(3)  <= resize(h_dig(5) * h_var(0), h_width);
			h_var(4)  <= shift_right(h_var(1) - h_var(2) - h_var(3) + h_const(2), 15);	   
			h_var(5)  <= shift_right(resize(h_var(0) * h_dig(6), h_width), 10);
			h_var(6)  <= shift_right(resize(h_var(0) * h_dig(3), h_width), 11);
			h_var(7)  <= h_var(6) + h_const(3);
			h_var(8)  <= shift_right(resize(h_var(5) * h_var(7), h_width), 10);
			h_var(9)  <= h_var(8) + h_const(5);
			h_var(10) <= resize(h_var(9) * h_dig(2), h_width);
			h_var(11) <= shift_right(resize(h_var(10) + h_const(4), h_width), 14);
			h_var(12) <= resize(h_var(4) * h_var(11), h_width);
			h_var(13) <= shift_right(resize(shift_right(h_var(12), 15) * shift_right(h_var(12), 15), h_width), 7);
			h_var(14) <= shift_right(resize(h_var(13) * h_dig(1), h_width), 4);
			h_var(15)       <= h_var(12) - h_var(14);
			if h_var(15) < x"0000_0000" then
				o_bme280.H  <= (others => '0');
			elsif h_var(15) > h_const(6) then
				o_bme280.H    <= std_logic_vector(shift_right(to_signed(h_const(6),outbme280_width), 12));
			else
				o_bme280.H    <= std_logic_vector(shift_right(resize(h_var(15),outbme280_width), 12));
			end if;
		end if;
	end process h_calc_proc;
end architecture main;

