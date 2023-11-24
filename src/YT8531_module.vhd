-------------------------------------------------------------------------------
-- Title       : YT8531_module
-- Design      : YT8531 eth transeiver
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

library work;
use work.common_lib.all;
use work.mdio_lib.all;

entity YT8531_module is
	generic( ref_freq : integer:=125000000 );
	port( reset,clock: in std_logic; 
		mdc,mdio: inout std_logic;
		link: out std_logic_vector(1 downto 0) );
end YT8531_module;

architecture main of YT8531_module is			 
	
	constant adr_chip0 : type_mem_a_mdio :=std_logic_vector(to_unsigned(16#000#,mem_a_mdio_width));
	constant adr_link0 : type_mem_a_mdio :=std_logic_vector(to_unsigned(16#093#,mem_a_mdio_width));
	constant adr_chip1 : type_mem_a_mdio :=std_logic_vector(to_unsigned(16#040#,mem_a_mdio_width));
	constant adr_link1 : type_mem_a_mdio :=std_logic_vector(to_unsigned(16#113#,mem_a_mdio_width));
	
	signal ena: boolean:= false; 
	signal mdio_valid : boolean;
	signal mdio_adr_mem : type_mem_a_mdio;
	signal mdio_data_mem : type_mem_d_mdio;
	signal mdio_q : type_data_mdio;
	
begin
	
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			link<=(others=>'0'); 
		elsif rising_edge(clock) and ena then 
			if mdio_adr_mem=adr_chip0 then
				link(0)<='0'; 
			elsif mdio_valid and mdio_adr_mem=adr_link0 then	
				link(0)<=mdio_q(2); 
			end if;
			if mdio_adr_mem=adr_chip1 then
				link(1)<='0'; 
			elsif mdio_valid and mdio_adr_mem=adr_link1 then	
				link(1)<=mdio_q(2); 
			end if;
		end if;
	end process main_proc; 
	--------------------------------------------	
	YT8531_mdiomem1 : entity work.YT8531_mdiomem 
	port map( reset=>reset, clk=>clock,
		ce=>'1', oce=>'1',
		ad=>mdio_adr_mem,
		dout=>mdio_data_mem );
	
	mdio_interface1 : entity work.mdio_interface 
	generic map( ref_freq=>ref_freq, mdc_freq=>500000 )
	port map( reset=>reset, clock=>clock,
		mdc=>mdc, mdio=>mdio,
		ena=>ena,
		adr=>mdio_adr_mem,
		data=>mdio_data_mem,
		mdio_valid=>mdio_valid,
		mdio_q=>mdio_q );
	
	
end main; 