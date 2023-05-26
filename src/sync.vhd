-------------------------------------------------------------------------------
-- Title       : sync
-- Design      : async
-- Author      : Starokaznikov OV
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
entity Sync is
	generic( regime : string:="blank"; inDelay : integer:=0; outDelay : integer:=0);
	port(
		reset	: in STD_LOGIC;
		clk_in	: in STD_LOGIC;	data_in : in STD_LOGIC;
		clk_out	: in STD_LOGIC;	data_out: out STD_LOGIC
		);
end Sync;

architecture main of Sync is
	signal	data_input,sync_pulse_data_a_false_path_sync,sync_pulse_data_b_false_path_sync,data_c: STD_LOGIC:='0';
	signal  input_delay_false_path_sync : std_logic_vector(inDelay downto 0):=(others=>'0');
	signal  output_delay : std_logic_vector(outDelay downto 0):=(others=>'0');
begin 
	------------------------------------------------------------------------------
	input_delay_false_path_sync(0) <= data_in;
	in_delay:	if inDelay>0 generate
		delay_input: process (reset,clk_in) 
		begin
			if reset='1' then 
				input_delay_false_path_sync(inDelay downto 1)<=conv_std_logic_vector(0,inDelay);
			elsif rising_edge(clk_in) then
				input_delay_false_path_sync(inDelay downto 1)<=input_delay_false_path_sync(inDelay-1 downto 0);
			end if;
		end process delay_input;
	end generate;
	data_input<=input_delay_false_path_sync(inDelay);
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	none_sync:	if regime="blank" generate
		data_c<=data_input;
	end generate;
	------------------------------------------------------------------------------
	pulse_sync:	if regime="pulse" generate
		dff_in: process (reset,data_c,clk_in,data_input)
		begin
			if reset='1' or data_c='1' then
				sync_pulse_data_a_false_path_sync<='0';
			elsif rising_edge(clk_in) and data_input='1' then	
				sync_pulse_data_a_false_path_sync<='1';
			end if;
		end process dff_in;
		dff_out: process (reset,clk_out)
		begin
			if reset='1' then
				sync_pulse_data_b_false_path_sync<='0';
				data_c<='0';
			elsif rising_edge(clk_out) then
				sync_pulse_data_b_false_path_sync<=sync_pulse_data_a_false_path_sync and (not sync_pulse_data_b_false_path_sync);
				data_c<=sync_pulse_data_b_false_path_sync;
			end if;
		end process dff_out; 
	end generate;
	------------------------------------------------------------------------------
	spulse_sync:	if regime="spuls" generate
		dff_in: process (reset,data_c,clk_in)
			variable int_false_path_sync : std_logic_vector(1 downto 0);
		begin
			if reset='1' or data_c='1' then
				sync_pulse_data_a_false_path_sync<='0';
				int_false_path_sync:="11";
			elsif rising_edge(clk_in)then
				if int_false_path_sync="01" then
					sync_pulse_data_a_false_path_sync<='1';
				end if;
				int_false_path_sync:=int_false_path_sync(0) & data_input;
			end if;
		end process dff_in;
		dff_out: process (reset,clk_out)
		begin
			if reset='1' then
				sync_pulse_data_b_false_path_sync<='0';
				data_c<='0';
			elsif rising_edge(clk_out) then
				sync_pulse_data_b_false_path_sync<=sync_pulse_data_a_false_path_sync and (not sync_pulse_data_b_false_path_sync);
				data_c<=sync_pulse_data_b_false_path_sync;
			end if;
		end process dff_out; 
	end generate;
	-------------------------------------------------------------------------------	
	level_sync:	if regime="level" generate
		dff_in: process (reset,clk_in)
		begin
			if reset='1'  then
				sync_pulse_data_a_false_path_sync<='0';
			elsif rising_edge(clk_in) then	
				sync_pulse_data_a_false_path_sync<=data_input;
			end if;
		end process dff_in;
		dff_out: process (reset,clk_out)
		begin
			if reset='1' then
				sync_pulse_data_b_false_path_sync<='0';
				data_c<='0';
			elsif rising_edge(clk_out) then
				sync_pulse_data_b_false_path_sync<=sync_pulse_data_a_false_path_sync;
				data_c<=sync_pulse_data_b_false_path_sync;
			end if;
		end process dff_out; 
	end generate;
	------------------------------------------------------------------------------
	output_delay(0)<=data_c;
	out_delay:	if outDelay>0 generate
		delay_output: process (reset,clk_out) 
		begin
			if reset='1' then 
				output_delay(outDelay downto 1)<=conv_std_logic_vector(0,outDelay);
			elsif rising_edge(clk_out) then
				output_delay(outDelay downto 1)<=output_delay(outDelay-1 downto 0);
			end if;
		end process delay_output;
	end generate;
	data_out<=output_delay(outDelay);
	-------------------------------------------------------------------------------
end main;