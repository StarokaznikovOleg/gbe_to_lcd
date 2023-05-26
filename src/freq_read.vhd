-------------------------------------------------------------------------------
-- Title       : freq
-- Design      : async
-- Author      : Starokaznikov OV
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
library work;

entity freq_read is
	generic( ref_freq : integer:=25000000);
	port(
		reset,ref_clk	: in std_logic;
		clk : in std_logic;
		freq: out std_logic_vector(31 downto 0) 
		);
end freq_read;

architecture main of freq_read is  	  
	component Sync
		generic(
			regime : STRING := "blank";
			inDelay : INTEGER := 0;
			outDelay : INTEGER := 0);
		port(
			reset : in STD_LOGIC;
			clk_in : in STD_LOGIC;
			data_in : in STD_LOGIC;
			clk_out : in STD_LOGIC;
			data_out : out STD_LOGIC);
	end component; 
	constant max_freq : integer :=800000000;
	
	signal	count_4s : integer range 0 to (ref_freq*4-1); 
	signal	ref_ena : std_logic;
	
	type array8_ena_type is array (3 downto 0) of std_logic;
	type array8_reg_type is array (3 downto 0) of std_logic_vector(31 downto 0);
	
	signal	clk4div,clk2div,clk_ena : std_logic;
	signal	clk_count  :  integer range 0 to max_freq-1;
	signal	clk_reg: std_logic_vector(31 downto 0);
begin  
	freq<=clk_reg;
	ref1s_proccess: process (reset,ref_clk) 
	begin
		if reset='1' then 
			count_4s<=0; 
			ref_ena<='0';
		elsif rising_edge(ref_clk) then   
			if count_4s=0 then 
				ref_ena<='1';
				count_4s<=(ref_freq*4-1);
			else	
				ref_ena<='0';
				count_4s<=count_4s-1;
			end if;
		end if;
	end process ref1s_proccess;
	div2_proccess: process (clk) 
	begin
		if rising_edge(clk) then  
			clk2div<=not clk2div;
		end if;
	end process div2_proccess;
	div4_proccess: process (clk2div) 
	begin
		if rising_edge(clk2div) then  
			clk4div<=not clk4div;
		end if;
	end process div4_proccess;
	
	clk_pulse : Sync
	generic map( regime=>"pulse", inDelay=>0, outDelay=>0 )
	port map( reset=>reset,
		clk_in=>ref_clk, data_in=>ref_ena,
		clk_out=>clk4div, data_out=>clk_ena );
	clk_proccess: process (reset,clk4div) 
	begin
		if reset='1' then 
			clk_count<=0; 
			clk_reg<=conv_std_logic_vector(0,32);
		elsif rising_edge(clk4div) then  
			if clk_ena='1' then
				clk_reg<=conv_std_logic_vector(clk_count,32);
				clk_count<=1;
			elsif clk_count/=max_freq-1 then
				clk_count<=clk_count+1;
			end if;
		end if;
	end process clk_proccess;
	
end main;
