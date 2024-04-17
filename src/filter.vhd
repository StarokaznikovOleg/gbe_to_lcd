-------------------------------------------------------------------------------
-- Title       : sync
-- Design      : async
-- Author      : Starokaznikov OV
-- Company     : Protei
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
entity filter is
	generic( regime : string:="blank"; filter : integer:=0);
	port(
		reset	: in STD_LOGIC;
		clk_in	: in STD_LOGIC;	data_in : in STD_LOGIC;
		clk_out	: in STD_LOGIC;	data_out: out STD_LOGIC
		);
end filter;

architecture main of filter is
	signal	sync_pulse_data_a_false_path_sync,sync_pulse_data_b_false_path_sync,sync_d: STD_LOGIC:='0';
begin 
	dff_in: process (reset,clk_in)
	begin
		if reset='1'  then
			sync_pulse_data_a_false_path_sync<='0';
		elsif rising_edge(clk_in) then	
			sync_pulse_data_a_false_path_sync<=data_in;
		end if;
	end process dff_in;
	dff_out: process (reset,clk_out)
	begin
		if reset='1' then
			sync_pulse_data_b_false_path_sync<='0';
			sync_d<='0';
		elsif rising_edge(clk_out) then
			sync_pulse_data_b_false_path_sync<=sync_pulse_data_a_false_path_sync;
			sync_d<=sync_pulse_data_b_false_path_sync;
		end if;
	end process dff_out; 
	------------------------------------------------------------------------------
	none_sync:	if regime="blank" generate
		data_out<=sync_d;
	end generate;
	------------------------------------------------------------------------------
	level_sync:	if regime="level" generate
		level_filter: process (reset,clk_out)
			variable count: integer range 0 to filter;
			variable state: std_logic;
		begin
			if reset='1' then
				count:=0;
				state:='0';
				data_out<='0';
			elsif rising_edge(clk_out) then	  
				if state=sync_d then 
					if count/=filter then
						count:=count+1;
					else 
						data_out<=state; 
					end if;	
				else
					count:=0;
					state:=sync_d;
				end if;	
			end if;
		end process level_filter; 
	end generate;  
	------------------------------------------------------------------------------
	pulse_sync:	if regime="pulse" generate
		pulse_filter: process (reset,clk_out)
			variable count: integer range 0 to filter;
			variable state: std_logic;
		begin
			if reset='1' then
				count:=0;
				state:='0';
				data_out<='0';
			elsif rising_edge(clk_out) then	  
				if count=filter-1 and state='1' then
					data_out<='1'; 
				else 
					data_out<='0'; 
				end if;	
				if state=sync_d then 
					if count/=filter then
						count:=count+1;
					end if;	
				else
					count:=0;
					state:=sync_d;
				end if;	
			end if;
		end process pulse_filter; 
	end generate;
	
end main;