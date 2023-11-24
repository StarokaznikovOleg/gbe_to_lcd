-------------------------------------------------------------------------------
-- Title       : bme280 calculate
-- Design      : Bosch bme280 sensor
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.bme280_lib.all; 

entity bme280_data_comp is
	port ( reset : in  std_logic; 
		clock : in  std_logic;  
		i_bme280 : in  type_inBME280;
		o_bme280 : out  type_outBME280
		);
end entity bme280_data_comp;

architecture main of bme280_data_comp is
	-- Attention!
	-- For normal operation of the calculator in the required range, you need
	-- to adjust the width of the variables. The variable width can be changed
	-- in the range from 20 to 64. The higher the value, the wider the measurement
	-- range, but the larger the FPGA LUT is required to operate.	
	constant t_width : integer :=24; --24;  
	constant p_width : integer :=30; --30;  
	constant h_width : integer :=22; --22; 
	
	-- Temperature
	constant t_pipeline_lenght : integer := 7;
	type type_t_var is array (4 downto 0) of signed(t_width-1 downto 0);
	signal t_var : type_t_var;
	signal t_fine : signed(t_width-1 downto 0);
	
	-- Pressure
	constant p_pipeline_lenght : integer := 22;
	type type_p_const is array (1 to 4) of integer;
	constant p_const : type_p_const := (64000,1048576,6250,32768);
	type type_p_var is array (19 downto 0) of signed(p_width-1 downto 0);
	signal p_var : type_p_var;
	
	-- Humidity
	constant h_pipeline_lenght  : integer := 18;
	type type_h_const is array (1 to 6) of integer;
	constant h_const : type_h_const := (76800,4096,2048,65536,0,100000);
	type type_h_var is array (13 downto 0) of signed(h_width-1 downto 0);
	signal h_var : type_h_var; 
	
	constant pipeline_lenght      : integer := t_pipeline_lenght + p_pipeline_lenght + h_pipeline_lenght;
	signal count_vid : integer range 0 to pipeline_lenght;
	signal count_dbg : integer range 0 to 19;
	signal p_div_valid : boolean;
	signal t_act,p_act,h_act : boolean;
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
			o_bme280.act <= (count_vid=0 and p_div_valid) or (t_act and p_act and h_act);  
		end if;
	end process valid_proc;	 
	
	dbg_proc: process (reset,clock)
		variable t_varx : signed(39 downto 0);
		variable p_varx : signed(39 downto 0);
		variable h_varx : signed(39 downto 0);
		variable t_digx,p_digx,h_digx : signed(31 downto 0);
	begin
		if rising_edge(clock) then
			t_act<= t_varx=to_signed(0,t_width) or t_digx=0; 
			-- Temperature dbg
			if  count_dbg<=4 then t_varx:=resize(t_var(count_dbg),40);
			elsif  count_dbg=5 then t_varx:=resize(t_fine,40);
			else t_varx:=to_signed(0,40);
			end if;
			if  count_dbg<=3 then  t_digx:=i_bme280.t_dig(count_dbg);
			else t_digx:=to_signed(0,32);
			end if;
			-- Pressure	dbg
			p_act<= p_varx=to_signed(0,p_width) or p_digx=0; 
			if  count_dbg<=19 then  p_varx:=resize(p_var(count_dbg),40);
			else p_varx:=to_signed(2,40);
			end if;
			if  count_dbg<=9 then  p_digx:=i_bme280.p_dig(count_dbg);
			else p_digx:=to_signed(0,32);
			end if;
			-- Humidity	dbg
			h_act<= h_varx=to_signed(0,h_width) or h_digx=0; 
			if  count_dbg<=13 then  h_varx:=resize(h_var(count_dbg),40);
			else h_varx:=to_signed(0,40);
			end if;
			if  count_dbg<=6 then  h_digx:=i_bme280.h_dig(count_dbg);
			else h_digx:=to_signed(0,32);
			end if;
			
			if count_dbg=19 then
				count_dbg<=0;
			else
				count_dbg<=count_dbg+1;
			end if;
		end if;
	end process dbg_proc;
	
	t_calc_proc: process (clock)
	begin
		if rising_edge(clock) then         
			t_var(0) <= signed(resize(shift_right(i_bme280.t_adc,0),t_width)) - signed(resize(shift_left(i_bme280.t_dig(1),4),t_width));
			t_var(1) <= resize(shift_right(t_var(0) * i_bme280.t_dig(2),12), t_width);
			t_var(2) <= shift_right(signed(shift_right(resize(i_bme280.t_adc,t_width),4)) - signed(resize(i_bme280.t_dig(1),t_width)),4);
			t_var(3) <= resize(shift_right((t_var(2) * t_var(2)),8), t_width);
			t_var(4) <= resize(shift_right(t_var(3) * i_bme280.t_dig(3),8), t_width);
			t_fine <= signed(shift_right(t_var(1) + t_var(4), 2));
			o_bme280.T <= std_logic_vector(shift_right(resize(t_fine * 5, outbme280_width) + 128,8));
		end if;
	end process t_calc_proc;
	
	p_calc_proc: process (clock)
	begin
		if rising_edge(clock) then
			p_var(0) <= resize(shift_right(t_fine,1),p_width) - p_const(1);
			p_var(1) <= resize(shift_right(p_var(0) * p_var(0),8),p_width);
			p_var(2) <= resize(shift_right(p_var(1) * i_bme280.p_dig(6),7),p_width); 
			p_var(3) <= resize(shift_left(p_var(0) * i_bme280.p_dig(5),1),p_width);
			p_var(4) <= p_var(2) + p_var(3);
			p_var(5) <= shift_right(p_var(4),2) + resize(shift_left(i_bme280.p_dig(4), 16),p_width);
			p_var(6) <= resize(shift_right(p_var(1) * i_bme280.p_dig(3),15),p_width);
			p_var(7) <= resize(shift_right(p_var(0) * i_bme280.p_dig(2),4),p_width);
			p_var(8) <= shift_right(p_var(6) + p_var(7),15);  
			p_var(9) <= shift_right(p_var(8) + p_const(4),2);
			p_var(10) <= resize(shift_right(p_var(9) * i_bme280.p_dig(1),16),p_width);
			p_var(11) <= p_const(2) - signed(resize(i_bme280.p_adc,p_width));
			p_var(12) <= p_var(11)-shift_right(p_var(5),12);
			p_var(13) <= resize(shift_right(p_var(12) * p_const(3),3),p_width);
			--	p_var(14) <= p_var(13) / p_var(10)
			p_var(15) <= resize(shift_right(p_var(14) * p_var(14),16),p_width);
			p_var(16) <= resize(shift_right(p_var(15) * i_bme280.p_dig(9),15),p_width);
			p_var(17) <= resize(shift_right(p_var(14) * i_bme280.p_dig(8),15),p_width);
			p_var(18) <= p_var(16) + p_var(17);
			p_var(19) <= shift_right(p_var(18) + resize(i_bme280.p_dig(7),p_width), 4);
			o_bme280.P <= std_logic_vector(resize(p_var(14)+p_var(19),outbme280_width));
			
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
			h_var(0) <= resize(shift_right(t_fine - h_const(1),7),h_width);
			h_var(1) <= resize(shift_right(h_var(0) * i_bme280.h_dig(3),7),h_width);
			h_var(2) <= resize(shift_right(h_var(0) * i_bme280.h_dig(5),5),h_width);
			h_var(3) <= resize(shift_right(h_var(0) * i_bme280.h_dig(6),7),h_width);
			h_var(4) <= shift_right(h_var(1) + h_const(2),12);
			h_var(5) <= resize(shift_right(h_var(3) * h_var(4),1),h_width);
			h_var(6) <= shift_right(h_var(5) + h_const(3),1);
			h_var(7) <= resize(shift_right(h_var(6) * i_bme280.h_dig(2),10),h_width);
			h_var(8) <= shift_right(h_var(2) + resize(shift_left(i_bme280.h_dig(4),8),h_width),1);
			h_var(9) <= shift_right(resize(i_bme280.h_adc,h_width) - shift_right(h_var(8),1),0);
			h_var(10) <= resize(shift_right(h_var(7) * h_var(9),10),h_width);
			h_var(11) <= resize(shift_right(h_var(10) * i_bme280.h_dig(1),9),h_width);	   
			h_var(12) <= shift_right(h_const(4) - h_var(11),6);
			h_var(13) <= resize(shift_right(h_var(10) * h_var(12),6),h_width);
			if h_var(13) < h_const(5) then
				o_bme280.H <= std_logic_vector(to_signed(h_const(5),outbme280_width));
			elsif h_var(13) > h_const(6) then
				o_bme280.H <= std_logic_vector(to_signed(h_const(6),outbme280_width));
			else
				o_bme280.H <= std_logic_vector(resize(shift_right(h_var(13)*51,9),outbme280_width));
			end if;
		end if;
	end process h_calc_proc;
end architecture main;

