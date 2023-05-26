-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity LCDserializer is
	port(
		--input stream
		reset,sclk,pclk : in std_logic;
		lcd : in type_LCD;		
		-- output to lvds
		lvds_clk : out std_logic;
		lvds_out : out std_logic_vector(3 downto 0)		
		);
end LCDserializer;

architecture main of LCDserializer is	 
	signal wr_sync: STD_LOGIC:='0';
	signal a_sync,b_sync,c_sync,d_sync : std_logic:='0';
	signal cam_dd: STD_LOGIC_VECTOR(34 downto 0):=(Others=>'0');
	
begin 
	
	clk_pulse_proc: process (sclk)
		variable in_sync : std_logic_vector(1 downto 0):="00";
	begin
		if rising_edge(sclk)then
			if b_sync='1' then
				a_sync<='0';
			elsif in_sync="01" then
				a_sync<='1';
			end if;
			b_sync<=a_sync and (not b_sync);
			c_sync<=b_sync;
			in_sync:=in_sync(0) & pclk;
		end if;
	end process clk_pulse_proc; 
	wr_sync<=c_sync;   
	
	lvds_clock : entity work.ser7to1 
	port map(
		reset => reset,
		clock => sclk,
		wr_sync => wr_sync,
		din => cam_dd(6 downto 0),
		ser => lvds_clk);
	
	n : for n in 1 to 4 generate	
		lvds_line : entity work.ser7to1 
		port map(
			reset => reset,
			clock => sclk,
			wr_sync => wr_sync,
			din => cam_dd(n*7+6 downto n*7),
			ser => lvds_out(n-1));	
	end generate n;	  
	
	cor_proc: process (pclk)
	begin
		if rising_edge(pclk) then 	
			cam_dd<=lcd_to_data(lcd);
		end if;
	end process cor_proc; 
	
end main;

