-------------------------------------------------------------------------------
-- Title       : sync
-- Design      : async
-- Author      : Starokaznikov OV
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
entity resync is
	--	generic( inDelay : integer:=0; outDelay : integer:=0);
	port(
		reset,clock	: in std_logic:='0';
--		clk_gpu,clk_lcd,clk_eth	: in std_logic:='0';
		rst_hw,rst_eth,rst_gpu,rst_lcd	: out std_logic	
		);
end resync;

architecture main of resync is	
	constant work_phase : integer:=100;
	constant hw_phase : integer:=40;
	constant eth_phase : integer:=30;
	constant gpu_phase : integer:=20;
	constant lcd_phase : integer:=10;
	constant reset_phase : integer:=5;
--	signal	inclk,inerr,err_sync: std_logic_vector(2 downto 0):=(others=>'0');
	signal	allerr: boolean:= false;
	signal	int_reset,int_rst_gpu,int_rst_lcd,int_rst_eth: std_logic;
begin 
--	inclk(0)<=gpu_clk;		inerr(0)<=gpu_err(2);
--	inclk(1)<=gpu_clk;		inerr(1)<=gpu_err(3);
--	n : for n in 0 to 3 generate	
--		Sync_err : entity work.Sync 
--		generic map( regime=>"spuls", inDelay=>1, outDelay=>1 )
--		port map( reset=>'0',
--			clk_in=>inclk(n), data_in=>inerr(n),
--			clk_out=>clock, data_out=>err_sync(n) );	
--	end generate n;	
		reset_sync : entity work.Sync 
		generic map( regime=>"level", inDelay=>1, outDelay=>1 )
		port map( reset=>'0',
			clk_in=>clock, data_in=>reset,
			clk_out=>clock, data_out=>int_reset );	
	
	main_proc: process (reset,clock) 
		variable count : integer range 0 to work_phase :=0;
	begin
		if rising_edge(clock) then   
--			allerr<= err_sync/="0000" or reset='1';
			allerr<= int_reset='1';
			if count=reset_phase then 
				rst_hw<='1';
			elsif count=hw_phase then 
				rst_hw<='0'; 
			end if;
			if count=reset_phase then 
				rst_gpu<='1';
			elsif count=gpu_phase then 
				rst_gpu<='0'; 
			end if;
			if count=reset_phase then 
				rst_lcd<='1';
			elsif count=lcd_phase then 
				rst_lcd<='0'; 
			end if;
			if count=reset_phase then 
				rst_eth<='1';
			elsif count=eth_phase then 
				rst_eth<='0'; 
			end if;
			if count=work_phase and allerr then
				count:=0;
			elsif count/=work_phase then
				count:=count+1;
			end if;
		end if;
	end process main_proc; 	 
--	
--		gpu_sync : entity work.Sync 
--		generic map( regime=>"level", inDelay=>1, outDelay=>1 )
--		port map( reset=>'0',
--			clk_in=>clock, data_in=>int_rst_gpu,
--			clk_out=>clk_gpu, data_out=>rst_gpu );	
--		lcd_sync : entity work.Sync 
--		generic map( regime=>"level", inDelay=>1, outDelay=>1 )
--		port map( reset=>'0',
--			clk_in=>clock, data_in=>int_rst_lcd,
--			clk_out=>clk_lcd, data_out=>rst_lcd );	
--		eth_sync : entity work.Sync 
--		generic map( regime=>"level", inDelay=>1, outDelay=>1 )
--		port map( reset=>'0',
--			clk_in=>clock, data_in=>int_rst_eth,
--			clk_out=>clk_eth, data_out=>rst_eth );	
	
	
end main;