library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
library work;
use work.corund10_lib.all;

entity cmd_i2ctouch is
	generic( ref_freq:integer:=1280; outfreq:integer:=160);
	port(	
		reset,clock : in STD_LOGIC;	  
		i2c_err : out std_logic_vector(2 downto 0);
		--int interface
		valid : out STD_LOGIC;	
		dout : out std_logic_vector(7 downto 0);
		--ext interface
		SCL : inout STD_LOGIC;	
		SDA : inout STD_LOGIC	
		);
end cmd_i2ctouch;

architecture main of cmd_i2ctouch is	 
	constant First_finger_down: std_logic_vector(7 downto 0):=x"70";
	constant Second_finger_down: std_logic_vector(7 downto 0):=x"71";
	constant First_finger_up: std_logic_vector(7 downto 0):=x"40";
	constant Second_finger_up: std_logic_vector(7 downto 0):=x"41";
	signal i2c_start,i2c_stop,i2c_ready,i2c_write: std_logic:='0';
	signal i2c_data: std_logic_vector(7 downto 0):=(others=>'0');
	type state_type is (idle,set_cmd,wait_ready_cmd,rd_data,wait_ready_data);
	signal state : state_type:=idle;
begin 
	
	i2c_proc: process (reset,clock)	
		constant count_delay : integer :=7;
		constant count_delay_max: integer :=2047;
		variable count: integer range 0 to count_delay:=0;
		variable count_add: integer range 0 to count_delay_max:=0;
	begin 
		if reset='1' then
			i2c_start<='0'; 
			i2c_stop<='0'; 
			state<=idle; 
			count:=0;
		elsif rising_edge(clock) then 
			case state is
				when idle =>	 
					if count=0 and count_add=0 then 
						if i2c_ready='1' then 
							state<=set_cmd; 
						end if;	
					else				
						if count=0 then
							count:=count_delay;	 
							count_add:=count_add-1;
						else
							count:=count-1;
						end if;	 
					end if;	 
				
				when set_cmd =>	 
					i2c_start<='1';  
					i2c_stop<='0';
					i2c_write<='1';
					i2c_data<=x"71";	 
					count:=count_delay;
					state<= wait_ready_cmd; 
				
				when wait_ready_cmd =>	 
					i2c_start<='0';  
					if count=0  then 
						if i2c_ready='1' then 
							state<=rd_data; 
						end if;	
					else
						count:=count-1;
					end if;	 
				
				when rd_data =>	 
					i2c_start<='1';  
					i2c_stop<='1';
					i2c_write<='0';
					i2c_data<=x"FF";	 
					count:=count_delay;
					state<= wait_ready_data; 
				
				when wait_ready_data =>	 
					i2c_start<='0';  
					if count=0  then 
						if i2c_ready='1' then 
							count:=count_delay;
							count_add:=count_delay_max;
							state<=idle; 
						end if;	
					else
						count:=count-1;
					end if;	 
				
			end case;
			
		end if;
	end process i2c_proc; 
	
	i2c_1 : entity work.i2c 
	generic map( ref_freq=>ref_freq, outfreq=>outfreq )
	port map(
		reset => reset,
		clock => clock,
		i2c_err => i2c_err,
		ready => i2c_ready,
		start => i2c_start,
		stop => i2c_stop,
		write => i2c_write,
		din => i2c_data,
		valid => valid,
		dout => dout,
		SCL => SCL,
		SDA => SDA
		);	
end main;
