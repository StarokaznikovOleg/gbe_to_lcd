-- Title       : GW project
-- Design      : ethrx dma controller
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
library work;
use work.vimon10_lib.all;

entity ethrx_ctr is 
	generic(reg_sadr: integer:=16#0001#; mem_sadr: integer:=16#0020#);
	port( 
		reset : in std_logic;
		error : out std_logic; 
		
		delay : out std_logic_vector(15 downto 0);  
		
		eth_clk: in std_logic;
		eth_dv: in std_logic;
		eth_d: in std_logic_vector(7 downto 0);  
		
		avl_clk,avl_write,avl_read: in std_logic;
		avl_address: in std_logic_vector(31 downto 0);
		avl_writedata: in std_logic_vector(31 downto 0); 
		avl_readdata: out std_logic_vector(31 downto 0); 
		avl_readdatavalid: out std_logic
		
		);	
	
end ethrx_ctr;	  		 
architecture main of ethrx_ctr is  
	constant dev_adr_width : integer :=8;	   
	constant reg_adr_width : integer :=4;	   
	constant mem_adr_width : integer :=11;	   
	constant mem_size: integer:=(2**mem_adr_width)*4;	   
	constant max_packet_len : integer :=8191; 
	constant avl_data_width : integer :=32;	   
	constant sign_marker : std_logic_vector(7 downto 0) := x"27";	  
	
	constant eth_dma_ver : integer :=2;
	constant eth_dma_rev : integer :=2;
	constant eth_dma_option : integer :=0;
--	constant eth_dma_chanels : integer :=1;	 
	
	signal eth_intdv,eth_intstart : std_logic;	
	signal eth_intd : std_logic_vector(7 downto 0);	
	type state_type is (init_cycle,err_cycle,check_cycle,idle_state,sign_state,preamble_cycle,data_cycle);
	signal state	: state_type;	
	signal count_st	: integer range 0 to 15;	
	signal eth_MTU : integer range 0 to max_packet_len+4;   
	signal eth_packetlen	: integer range 0 to max_packet_len+4;	
	signal eth_shiftdata : std_logic_vector(avl_data_width-1 downto 0);	
	signal avl_wrprt,avl_rdprt,eth_wrprt,eth_rdprt,eth_freesize,eth_address,eth_inc1address,eth_inc2address : std_logic_vector(mem_adr_width-1 downto 0);	
	signal crc_sload,crc_enable : std_logic;	
	signal crc_out,crc_check : std_logic_vector(avl_data_width-1 downto 0);
	
	signal avl_device: integer range 0 to 2**dev_adr_width-1;	
	signal avl_reg: integer range 0 to 2**reg_adr_width-1;		
	signal avl_MTU : std_logic_vector(15 downto 0);	
	signal avl_delay : std_logic_vector(15 downto 0);	
	signal avl_delaydatavalid: std_logic_vector(3 downto 0);	
	signal eth_write : std_logic;	
	signal avl_memsel : std_logic;	
	signal avl_memdout,eth_writedata : std_logic_vector(avl_data_width-1 downto 0);	
	signal avl_syncrdprt,eth_syncrdprt,eth_syncwrprt,avl_syncwrprt,avl_syncmtu,eth_syncmtu,avl_run,eth_run,avl_rst,eth_rst : std_logic;	
	signal avl_statpacket: integer range 0 to 2**16-1;		
begin 	 
	
	rxd_proc: process (eth_clk) 
	begin
		if rising_edge(eth_clk) then 
			eth_intd<=eth_d;
			eth_intstart<=eth_dv and not eth_intdv;
			eth_intdv<=eth_dv;
		end if;
	end process rxd_proc;  
	
	eth_proc: process (reset,avl_rst,eth_clk) 
	begin
		if reset='1' or avl_rst='1' then 
			eth_syncwrprt<='0';
			eth_rst<='0';	 
			error<='0';	 
			eth_MTU<=1510;	 
			eth_freesize<=(others=>'0');	 
			eth_address<=(others=>'0');
			eth_inc1address<=(others=>'0');
			eth_inc2address<=(others=>'0');
			eth_writedata<=(others=>'0');
			eth_write<='0';
			eth_shiftdata<=(others=>'0');
			state<=init_cycle; count_st<=3;
			eth_rdprt<=conv_std_logic_vector(0,mem_adr_width);
			eth_wrprt<=conv_std_logic_vector(0,mem_adr_width);
			eth_packetlen<=0;	
			crc_sload<='0';
			crc_enable<='0';
		elsif rising_edge(eth_clk) then 
			case state is
				when init_cycle => 
					eth_rst<='1';	 
					error<='0';	 
					crc_sload<='0';
					crc_enable<='0';
					eth_syncwrprt<='1';
					eth_wrprt<=conv_std_logic_vector(0,mem_adr_width);
					eth_packetlen<=0;	
					if count_st=0 then 
						state<=check_cycle; count_st<=2;
					else 
						count_st<=count_st-1;  
					end if;
				
				when check_cycle =>  -- wrprt update	  
					eth_write<='0';
					eth_syncwrprt<='0';
					eth_rst<='0';	 
					crc_sload<='0';
					crc_enable<='0';
					if eth_run='1' then
						error<=eth_intstart;	 
						if count_st=0 then 	 
							if conv_integer(eth_freesize)>60 then
								state<=idle_state; 
								count_st<=0;	
							else
								count_st<=2;
							end if;	
						else 
							count_st<=count_st-1;  
						end if;	
					end if;	
				
				when idle_state => 
					if eth_intdv='1' then	 
						state<=preamble_cycle; count_st<=0;	
						crc_sload<='1';
					end if;	
					eth_write<='0';	 
					eth_packetlen<=0;
					eth_address<=eth_wrprt;
					eth_shiftdata<=eth_intd & eth_shiftdata(31 downto 8);
					crc_enable<='0';
				
				when preamble_cycle =>  
					if eth_intdv='1' then 
						if eth_shiftdata=x"d5555555" then
							state<=data_cycle; count_st<=3;
							crc_sload<='0';
							crc_enable<='1'; 
						end if;	 
					else  -- uncorrected start frame(error)
						error<='1';
						state<=err_cycle; count_st<=3;	
					end if;	 
					eth_shiftdata<=eth_intd & eth_shiftdata(avl_data_width-1 downto 8);
				
				when data_cycle => 
					if eth_rdprt=eth_inc2address then  -- eof memory buffer(error)
						error<='1';
						state<=err_cycle; count_st<=3;	
					elsif eth_packetlen=eth_MTU  then 
						state<=err_cycle; count_st<=3; -- packet len bigger MTU(filter) 	
					elsif eth_intdv/='1'  then  
						state<=sign_state; count_st<=1;	
						crc_enable<='0';
					end if;
					if count_st=0 then 	
						eth_address<=eth_inc1address;	
						eth_write<='1';	 
						count_st<=3;	
					else 
						eth_write<='0';	 
						count_st<=count_st-1;  
					end if;	
					eth_writedata<=eth_shiftdata;
					eth_packetlen<=eth_packetlen+1;
					--					eth_shiftdata<=eth_shiftdata(23 downto 0) & eth_d;  --reverse order bytes for tx eth
					eth_shiftdata<=eth_intd & eth_shiftdata(avl_data_width-1 downto 8);
				
				when sign_state => 
					eth_write<='1';  
					eth_syncwrprt<='1';
					if conv_std_logic_vector(eth_packetlen,2)/="00" then -- save new wrprt when packet writing success without crc32
						eth_wrprt<=eth_inc1address; 
					else 
						eth_wrprt<=eth_address; 
					end if;	
					error<=boolean_to_data(crc_check/=x"00000000"); -- uncorrected crc32 (error) 
					crc_enable<='0';
					eth_address<=eth_wrprt; --set marker when packet writing success
					eth_writedata<=sign_marker & conv_std_logic_vector(eth_packetlen-4,24);	-- write sign and packet len without crc32
					state<=check_cycle; count_st<=2;
				
				when others =>	--err_cycle
					if count_st=0 and eth_intdv/='1' then state<=check_cycle; count_st<=2; end if; 
					error<='0';
					crc_sload<='0';
					crc_enable<='0';
					if count_st/=0 then  count_st<=count_st-1; end if;	
				
			end case;		
			--			if conv_integer(eth_address)=mem_size/4-1 then
			--				eth_inc1address<=conv_std_logic_vector(0,mem_adr_width);	
			--			else
			eth_inc1address<=eth_address+1;	
			--			end if;
			--			if conv_integer(eth_address)=mem_size/4-1 then
			--				eth_inc2address<=conv_std_logic_vector(1,mem_adr_width);	
			--			elsif conv_integer(eth_address)=mem_size/4-2 then
			--				eth_inc2address<=conv_std_logic_vector(0,mem_adr_width);	
			--			else
			eth_inc2address<=eth_address+2;	
			--			end if;	  
			if eth_rdprt>eth_wrprt then
				eth_freesize<=eth_rdprt-eth_wrprt-1;
			else
				eth_freesize<=eth_rdprt-eth_wrprt+mem_size-1;
			end if;	
			--			eth_rdprt<=eth_wrprt;
			if eth_syncrdprt='1' then eth_rdprt<=avl_rdprt; end if;
			if eth_syncmtu='1' then eth_MTU<=conv_integer(avl_MTU+4); end if;
		end if;
	end process eth_proc;   
	--------------------------------------
	wrprt_sync : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	port map( reset => '0',
		clk_in => eth_clk,
		data_in => eth_syncwrprt,
		clk_out => avl_clk,
		data_out => avl_syncwrprt );	
	rdprt_sync : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	port map( reset => '0',
		clk_in => avl_clk,
		data_in => avl_syncrdprt,
		clk_out => eth_clk,
		data_out => eth_syncrdprt );	
	mtu_sync : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	port map( reset => '0',
		clk_in => avl_clk,
		data_in => avl_syncmtu,
		clk_out => eth_clk,
		data_out => eth_syncmtu );	
	run_sync : entity work.sync 
	generic map(regime=>"level", inDelay=>0, outDelay=>0)
	port map( reset => '0',
		clk_in => avl_clk,
		data_in => avl_run,
		clk_out => eth_clk,
		data_out => eth_run );	
	-------------------------------------- 
	delay<=avl_delay;
	avl_device<=conv_integer(avl_address(dev_adr_width+16-1 downto 16));
	avl_reg<=conv_integer(avl_address(reg_adr_width+2-1 downto 2));	 
	avl_readdatavalid<=avl_delaydatavalid(0) or avl_delaydatavalid(2);
	avl_proc: process (reset,eth_rst,avl_clk)
	begin
		if reset='1' or eth_rst='1' then
			avl_readdata<=(others=>'0');
			avl_delay<=(others=>'0');
			avl_rst<='0'; 
			avl_run<='1'; 
			avl_syncmtu<='0'; 
			avl_syncrdprt<='0'; 
			avl_wrprt<=conv_std_logic_vector(0,mem_adr_width);
			avl_rdprt<=conv_std_logic_vector(0,mem_adr_width);
			avl_MTU<=conv_std_logic_vector(1510,16);
			avl_delaydatavalid<=(others=>'0');
			avl_statpacket<=0; 
		elsif rising_edge(avl_clk) then  
			if avl_device=reg_sadr then
				avl_delaydatavalid(1 downto 0)<='0' & avl_read;
				if avl_reg=0 and avl_read='1' then  avl_readdata<=
					conv_std_logic_vector(eth_dma_ver,8) & 
					conv_std_logic_vector(eth_dma_rev,8) & 
					conv_std_logic_vector(eth_dma_option,8) & 
					x"07";
				elsif avl_reg=1 and avl_read='1' then avl_readdata<=conv_std_logic_vector(mem_sadr,16) & x"0000";
				elsif avl_reg=2 and avl_read='1' then avl_readdata<=conv_std_logic_vector(mem_size,avl_data_width);
				elsif avl_reg=3 and avl_read='1' then avl_readdata(avl_data_width-1 downto 2)<=(others=>'0');
					avl_readdata(0)<=avl_rst;
					avl_readdata(1)<=avl_run;
				elsif avl_reg=3 and avl_write='1' then 
					avl_rst<=avl_writedata(0);
					avl_run<=avl_writedata(1);
				elsif avl_reg=4 and avl_write='1' then avl_MTU<=avl_writedata(15 downto 0);
				elsif avl_reg=4 and avl_read='1' then avl_readdata<=ext(avl_MTU,avl_data_width);
				elsif avl_reg=5 and avl_read='1' then avl_readdata<=ext(avl_wrprt,avl_data_width);
				elsif avl_reg=6 and avl_read='1' then avl_readdata<=ext(avl_rdprt,avl_data_width);
				elsif avl_reg=6 and avl_write='1' then avl_rdprt<=avl_writedata(mem_adr_width-1 downto 0); 
				elsif avl_reg=7 and avl_write='1' then avl_delay<=avl_writedata(15 downto 0);
				elsif avl_reg=7 and avl_read='1' then avl_readdata<=ext(avl_delay,avl_data_width);
				elsif avl_reg=8 and avl_read='1' then avl_readdata<=conv_std_logic_vector(avl_statpacket,avl_data_width);
				else  avl_readdata<=avl_memdout;
				end if;	 
			elsif avl_device=mem_sadr then avl_readdata<=avl_memdout; avl_delaydatavalid(1 downto 0)<=avl_read & '0';
			else  avl_readdata<=avl_memdout; avl_delaydatavalid(1 downto 0)<="00";
			end if;	
			if avl_rst='1' then avl_rst<='0'; end if;
			if avl_syncwrprt='1' then avl_wrprt<=eth_wrprt; end if; 
			if avl_syncwrprt='1' then avl_statpacket<=avl_statpacket+1; end if; 
			avl_delaydatavalid(3 downto 2)<=avl_delaydatavalid(2 downto 1);
			avl_syncmtu<=boolean_to_data(avl_reg=4 and avl_write='1');
			avl_syncrdprt<=boolean_to_data(avl_reg=6 and avl_write='1');
		end if;
	end process avl_proc;    
	
	ethcrc32_check : entity work.crc32
	generic map( BusWidth => 8 )
	port map(
		aclr => reset,
		clock => eth_clk,
		sload => crc_sload,
		enable => crc_enable,
		data_in => eth_shiftdata(avl_data_width-1 downto 24),
		crc_out => open,
		crc_check => crc_check,
		crc_calc => open
		);	  
	
	avl_memsel<='1' when avl_device=mem_sadr else '0';
	ethrxdma_mem : entity work.ethdma_mem 
	port map(
		reseta => '0',
		clka => eth_clk,
		cea => '1',
		ada => eth_address,
		wrea => eth_write,
		dina => eth_writedata,	   
		ocea => '0',
		douta => open,
		resetb => '0',
		clkb => avl_clk,
		ceb => avl_memsel,
		adb => avl_address(12 downto 2),
		wreb => avl_write,
		dinb => avl_writedata,
		oceb => '1',
		doutb =>avl_memdout
		);
end;	 
