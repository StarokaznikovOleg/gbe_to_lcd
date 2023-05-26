library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   

entity eth_control is
	port(	
		reset,clock : in std_logic;	  
		--inputs 
		ETH_LED : in std_logic_vector(2 downto 0); 
		--sys events 
		eth_link,eth_speed : out std_logic	
		
		);
end eth_control;

architecture main of eth_control is	 
	signal eth_led_sync : std_logic_vector(2 downto 1):=(others=>'0'); 
begin 
	
	n : for i in 2 to 2 generate	
		eth_led_sync_x : entity work.sync 
		generic map(regime=>"level", inDelay=>1, outDelay=>1)
		port map( reset => reset,
			clk_in => clock, data_in => ETH_LED(i),
			clk_out => clock, data_out => eth_led_sync(i) );	
	end generate n;	
	
	main_proc: process (clock)
	begin
		if rising_edge(clock) then 	
			if reset='1' then eth_link<='0'; eth_speed<='0'; 
			elsif eth_led_sync(2)='0' then eth_link<='1'; eth_speed<='1';  
			else eth_link<='0'; eth_speed<='0';  
			end if;
		end if;
	end process main_proc; 
	
end main;
