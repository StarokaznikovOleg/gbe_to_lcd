library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   

entity sysled is
	generic( max_lock:integer:=6; max_err:integer:=9);
	port(	
		reset,clock : in STD_LOGIC;	  
		--inputs
		lock : in std_logic_vector(max_lock-1 downto 0);
		lock_clk : in std_logic_vector(max_lock-1 downto 0);
		err : in std_logic_vector(max_err-1 downto 0);
		err_clk : in std_logic_vector(max_err-1 downto 0);
		--sys leds 
		LED_GREEN,LED_BLUE,LED_RED : out STD_LOGIC	
		
		);
end sysled;

architecture main of sysled is	 
	
	function boolean_to_data(data:boolean) return std_logic is
	begin if data then return '1'; else return '0'; end if;
	end boolean_to_data;
	signal time_128mS,time_1mS,led_sync: boolean:=false;
	type led_type is (R,G,B,X);
	type led_type_array is array (5 downto 0) of led_type; 
	signal led_state : led_type_array:=(Others=>R);	
	signal lock_sync : std_logic_vector(max_lock-1 downto 0):=(others=>'0');
	signal err_sync,err_sync_pulse : std_logic_vector(max_err-1 downto 0):=(others=>'0');
	signal sdrampll_lock_sync,ethrxpll_lock_sync,ethtxpll_lock_sync,lcd_lock_sync,eth_1g_sync: std_logic:='0';
	
begin
	main_proc: process (reset,clock)
	begin 
		if rising_edge(clock) then 	
			if reset='1' then led_state<=(R,R,R,R,R,R); 
			elsif lock_sync(0)='0' then led_state<=(R,R,R,R,R,X); 
			elsif lock_sync(1)='0' then led_state<=(R,R,R,R,R,B); 
			elsif lock_sync(2)='0' then led_state<=(R,R,R,R,R,G); 
			elsif lock_sync(3)='0' then led_state<=(R,R,R,R,X,G); 
				--			elsif lock_sync(4)='1' then led_state<=(R,R,R,R,X,B); 
				
			elsif err_sync_pulse(0)='1'  then led_state<=(R,X,X,X,X,X); 
			elsif err_sync_pulse(1)='1'  then led_state<=(R,B,X,B,X,B); 
			elsif err_sync_pulse(2)='1'  then led_state<=(R,B,B,B,B,B);
				
			elsif err_sync_pulse(3)='1'  then led_state<=(R,B,X,X,X,X); 
			elsif err_sync_pulse(4)='1'  then led_state<=(R,B,X,B,X,X); 
			elsif err_sync_pulse(5)='1'  then led_state<=(R,B,B,B,B,X); 
				
			elsif err_sync_pulse(6)='1'  then led_state<=(R,X,X,X,X,B); 
			elsif err_sync_pulse(7)='1'  then led_state<=(R,X,X,B,X,B); 
			elsif err_sync_pulse(8)='1'  then led_state<=(R,X,B,B,B,B); 
				
				--			elsif err_sync_pulse(9)='1'  then led_state<=(R,X,R,X,X,X); 
				--			elsif err_sync_pulse(10)='1' then led_state<=(R,X,R,B,B,B); 
				--			elsif err_sync_pulse(11)='1' then led_state<=(R,X,R,B,X,B); 
				--			elsif err_sync_pulse(12)='1' then led_state<=(R,X,R,X,B,X); 
				--			elsif err_sync_pulse(13)='1' then led_state<=(R,X,R,X,X,B); 
				--			elsif err_sync_pulse(14)='1' then led_state<=(R,X,R,B,X,X); 
				
				
			else led_state<=(G,G,G,G,G,B); 
			end if;
		end if;
	end process main_proc; 
	
	n : for n in 0 to max_lock-1 generate	
		lock_x : entity work.sync 
		generic map(regime=>"level", inDelay=>0, outDelay=>1)
		port map(
			reset => '0',
			clk_in => lock_clk(n),
			data_in => lock(n),
			clk_out => clock,
			data_out => lock_sync(n)
			);	
	end generate n;	
	
	m : for m in 0 to max_err-1 generate	
		err_x : entity work.sync 
		generic map(regime=>"pulse", inDelay=>0, outDelay=>1)
		port map(
			reset => '0',
			clk_in => err_clk(m),
			data_in => err(m),
			clk_out => clock,
			data_out => err_sync(m)
			);	
		
		pulse_led_proc: process (clock)
			variable verr : std_logic_vector(2 downto 0):=(others=>'0');
		begin
			if rising_edge(clock) then 
				if err_sync(m)='1' and verr="000" then
					verr:="001";
				elsif led_sync and time_1mS and time_128mS then   
					err_sync_pulse(m)<=verr(2); 
					verr:=verr(1 downto 0) & '0';
				end if;
			end if;
		end process pulse_led_proc;   
		
	end generate m;
	
	
	time_1mS_proc: process (clock)
		constant cnt_1mS : integer :=2000;
		variable count : integer range 0 to cnt_1mS :=0;
	begin
		if rising_edge(clock) then 
			time_1mS<=count=cnt_1mS;
			if count=cnt_1mS then 
				count:=0;
			else
				count:=count+1;
			end if;
		end if;
	end process time_1mS_proc;  
	
	time_128mS_proc: process (clock,time_1mS)
		variable count : integer range 0 to 127 :=0;
	begin
		if rising_edge(clock) and time_1mS then 
			time_128mS<=count=0;
			if count=0 then
				count:=127;
			else
				count:=count-1;
			end if;
		end if;
	end process time_128mS_proc;  
	
	led_proc: process (clock,time_1mS,time_128mS)
		variable count : integer range 0 to 5 :=0;
	begin
		if rising_edge(clock) and time_1mS and time_128mS then 
			LED_GREEN<= not boolean_to_data(led_state(count)=G);
			LED_RED<= not boolean_to_data(led_state(count)=R);
			LED_BLUE<= not boolean_to_data(led_state(count)=B);
			led_sync<=count=4;
			if count=5 then
				count:=0;
			else
				count:=count+1;
			end if;
		end if;
	end process led_proc;   
	
end main;
