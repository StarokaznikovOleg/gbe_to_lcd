-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;

entity ser7to1 is
	port(
		reset,clock: in std_logic;   
		
		wr_sync: in std_logic;
		din : in std_logic_vector(6 downto 0);  
		ser: out std_logic
		);
end ser7to1;

architecture main of ser7to1 is	
	signal ddr_in : std_logic_vector(1 downto 0):=(Others=>'0');	
	signal ddr_out : std_logic_vector(0 downto 0):=(Others=>'0');	
	signal even: std_logic:='0';
	signal shift_wr: std_logic_vector(6 downto 0):=(Others=>'0');
	signal shift_ddr: std_logic_vector(7 downto 0):=(Others=>'0');
begin  
	cor_proc: process (clock)
	begin
		if rising_edge(clock) then 
			shift_ddr<= shift_ddr(5 downto 0) & "00";
			if wr_sync='1' then 
				even<=not even;
			end if;
			if wr_sync='1' and even='1' then 
				shift_wr<="0010001";
			else
				shift_wr<=shift_wr(5 downto 0) & shift_wr(6);
			end if;
			if shift_wr(6)='1' then
				if  even='0' then
					shift_ddr(6 downto 0)<=din;
				else
					shift_ddr(7 downto 1)<=din;
				end if;
			end if;
		end if;
	end process cor_proc; 
	
	ddr_in <= shift_ddr(6) & shift_ddr(7);
	ddr1 : entity work.ddrout 
	port map(
		clk => clock,
		din => ddr_in,
		q => ddr_out );	  
	ser<=ddr_out(0);
	
end main;