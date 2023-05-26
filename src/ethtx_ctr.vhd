-- Title       : CXM project
-- Design      : ethtx dma controller
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
library work;
use work.vimon10_lib.all;

entity ethtx_ctr is 
	generic(reg_sadr: integer:=16#0001#; mem_sadr: integer:=16#2000#);
	port( 
		reset : in std_logic;
		error : out std_logic;
		
		delay : out std_logic_vector(15 downto 0);  
		
		eth_clk: in std_logic;
		eth_rdy: out std_logic;
		eth_start: in std_logic;
		eth_pre: out std_logic;
		eth_dv: out std_logic;
		eth_d : out std_logic_vector(7 downto 0); 
		
		avl_clk,avl_write,avl_read: in std_logic;
		avl_address: in std_logic_vector(31 downto 0);
		avl_writedata: in std_logic_vector(31 downto 0); 
		avl_readdata: out std_logic_vector(31 downto 0); 
		avl_readdatavalid: out std_logic
		);
end ethtx_ctr;	  		 
architecture main of ethtx_ctr is 	
	constant dev_adr_width : integer :=8;	   
	constant reg_adr_width : integer :=4;	   
	constant mem_adr_width : integer :=11;	   
	constant mem_size: integer:=(2**mem_adr_width)*4;	   
	constant max_packet_len : integer :=8191;  
	constant avl_data_width : integer :=32;	   
	constant sign_marker : std_logic_vector(15 downto 0) := x"2700";	  
	
	constant eth_dma_ver : integer :=2;
	constant eth_dma_rev : integer :=2;
	constant eth_dma_option : integer :=0;
	
	signal eth_packetRTS,eth_marker,eth_value,eth_valok : boolean;		  -- ready to send :)
	type state_type is (init_cycle,err_cycle,rdprt_update,check_cycle,idle_state,sign_state,preamble_cycle,data_cycle,traller_cycle);
	signal state	: state_type;	
	signal count_st	: integer range 0 to 15;	
	signal eth_packetlen	: integer range 0 to max_packet_len+4;	
	signal eth_minpacketlen	: integer range 0 to 60;	
	signal eth_shiftdata : std_logic_vector(avl_data_width-1 downto 0);	
	signal eth_rdprt,eth_wrprt,avl_rdprt,avl_wrprt,eth_address,eth_inc1address : std_logic_vector(mem_adr_width-1 downto 0);	  
	
	signal eth_errcode : std_logic_vector(7 downto 0);	
	
	signal avl_device: integer range 0 to 2**dev_adr_width-1;	
	signal avl_reg: integer range 0 to 2**reg_adr_width-1;		
	signal eth_bufvalue: integer range 0 to 2**mem_adr_width-1;		
	--	signal avl_MTU,eth_MTU : integer range 0 to 8191;	
	--	signal avl_syncmtu,eth_syncmtu : std_logic;	
	signal avl_delay : std_logic_vector(15 downto 0);	
	signal avl_delaydatavalid: std_logic_vector(2 downto 0);	
	signal avl_memsel : std_logic;	
	signal avl_memdout,eth_readdata : std_logic_vector(31 downto 0);	
	signal eth_syncrdprt,avl_syncrdprt,avl_syncwrprt,eth_syncwrprt,avl_rst,eth_rst : std_logic;	
	signal avl_statpacket: integer range 0 to 2**15-1;		
	
begin 	 
	eth_proc: process (reset,avl_rst,eth_clk) 
	begin
		if reset='1' or avl_rst='1' then  
			eth_packetRTS<=false;
			eth_marker<=false;
			eth_value<=false;
			eth_valok<=false;
			eth_rdy<='0';
			eth_pre<='0';
			eth_dv<='0';
			eth_d<=(others=>'0');
			eth_rst<='0';
			error<='0';	 
			eth_address<=(others=>'0');
			eth_inc1address<=(others=>'0');
			eth_shiftdata<=(others=>'0');
			state<=init_cycle; count_st<=3;
			eth_wrprt<=conv_std_logic_vector(0,mem_adr_width);
			eth_rdprt<=conv_std_logic_vector(0,mem_adr_width);
			eth_packetlen<=0;	
			eth_minpacketlen<=0;
			eth_errcode<=x"00"; -- clr error sign
			--			eth_MTU<=1510;	
			eth_bufvalue<=0;	
		elsif rising_edge(eth_clk) then 
			eth_packetRTS<=eth_marker and eth_value and eth_valok;
			eth_marker<=eth_readdata(31 downto 16)=sign_marker;
			eth_value<=conv_integer(eth_readdata(mem_adr_width+2-1 downto 0))<=(eth_bufvalue*4);
			eth_valok<=conv_integer(eth_readdata(15 downto mem_adr_width+2))=0;
			eth_bufvalue<=conv_integer(eth_wrprt - eth_rdprt);
			case state is
				when init_cycle => 
					error<='0';	 
					eth_rdy<='0';
					eth_pre<='0';
					eth_dv<='0';
					eth_d<=x"00";
					if count_st=0 then 
						eth_rst<='1';
						state<=idle_state;
					else 
						count_st<=count_st-1;  
					end if;
				
				when rdprt_update =>  -- rdprt update
					eth_syncrdprt<='1';
					eth_rdy<='0';
					eth_pre<='0';
					eth_dv<='0';
					eth_d<=x"00";
					state<=idle_state;   
				
				when check_cycle =>  
					eth_syncrdprt<='0';
					eth_rst<='0';
					state<=idle_state; 
				
				when idle_state => 
					eth_syncrdprt<='0';
					eth_rst<='0';
					eth_address<=eth_rdprt;
					if eth_rdprt/=eth_wrprt then	 -- wrprt checked
						state<=sign_state; 
						count_st<=2;	   -- =3 of gw memory error, =2 if cyclone
					end if;	
				
				when sign_state => 
					if count_st=0 then
						eth_address<=eth_inc1address;
						if  eth_packetRTS then
							state<=preamble_cycle; count_st<=4;	 
						else
							state<=err_cycle; count_st<=3;	
						end if;
					else
						count_st<=count_st-1;  
					end if;	
					eth_packetlen<=conv_integer(eth_readdata(12 downto 0));	 --max 8191  
					eth_minpacketlen<=60;
				
				when preamble_cycle =>  
					eth_rdy<='1';
					eth_pre<='1';
					eth_dv<='1';
					if count_st=0 then eth_d<=x"d5"; else eth_d<=x"55"; end if;
					if eth_start='1' then
						if count_st=0 then eth_address<=eth_inc1address; end if;	
						if count_st=0 then 
							state<=data_cycle; count_st<=3;	
						else 
							count_st<=count_st-1;  
						end if;	
					end if;	 
					eth_shiftdata<=eth_readdata;
				
				when data_cycle => 
					eth_pre<='0';
					eth_d<=eth_shiftdata(7 downto 0);
					if eth_packetlen=1 and eth_minpacketlen>1 then	 
						eth_rdprt<=eth_address;
						state<=traller_cycle;	
					elsif eth_packetlen=1 then	 
						eth_rdprt<=eth_address;
						state<=rdprt_update; count_st<=1;	
					end if;	
					if count_st=0 and eth_packetlen>1 then eth_address<=eth_inc1address; end if;	
					if count_st=0 then 
						count_st<=3;	
						eth_shiftdata<=eth_readdata;
					else 
						eth_shiftdata<=x"00" & eth_shiftdata(31 downto 8);
						count_st<=count_st-1;  
					end if;	
					eth_packetlen<=eth_packetlen-1;	   
					if eth_minpacketlen/=0 then eth_minpacketlen<=eth_minpacketlen-1; end if;   
				
				when traller_cycle => 
					eth_d<=x"00";
					if eth_minpacketlen=1 then	 
						state<=rdprt_update; count_st<=1;	
					end if;	
					eth_minpacketlen<=eth_minpacketlen-1;	   
				
				when others =>	--err_cycle
					eth_rdy<='0';
					eth_pre<='0';
					eth_dv<='0';
					eth_d<=x"00";
					eth_errcode<=x"ff"; -- set error sign
					error<=boolean_to_data(count_st=1);  
					if count_st/=0 then  count_st<=count_st-1;  end if;	
				
			end case;		
			--			if conv_integer(eth_address)=mem_size/4-1 then
			--				eth_inc1address<=conv_std_logic_vector(0,mem_adr_width);	
			--			else
			eth_inc1address<=eth_address+1;	
			--			end if;
			if eth_syncwrprt='1' then eth_wrprt<=avl_wrprt; end if;
			--			if eth_syncmtu='1' then eth_MTU<=avl_MTU; end if;
		end if;
	end process eth_proc;   
	--------------------------------------
	rdprt_sync : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	port map(
		reset => '0',
		clk_in => eth_clk,
		data_in => eth_syncrdprt,
		clk_out => avl_clk,
		data_out => avl_syncrdprt
		);	
	wrprt_sync : entity work.sync 
	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	port map(
		reset => '0',
		clk_in => avl_clk,
		data_in => avl_syncwrprt,
		clk_out => eth_clk,
		data_out => eth_syncwrprt
		);	
	--	mtu_sync : entity work.sync 
	--	generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
	--	port map(
	--		reset => '0',
	--		clk_in => avl_clk,
	--		data_in => avl_syncmtu,
	--		clk_out => eth_clk,
	--		data_out => eth_syncmtu
	--		);	
	-------------------------------------- 
	delay<=avl_delay;
	avl_device<=conv_integer(avl_address(dev_adr_width+16-1 downto 16));
	avl_reg<=conv_integer(avl_address(reg_adr_width+2-1 downto 2));	 
	avl_readdatavalid<=avl_delaydatavalid(0) or avl_delaydatavalid(2);
	reg_proc: process (reset,eth_rst,avl_clk)
	begin
		if reset='1' or eth_rst='1' then
			avl_readdata<=(others=>'0');
			avl_delay<=(others=>'0');
			avl_rst<='0';
			--			avl_MTU<=1510;
			--			avl_syncmtu<='0';
			avl_syncwrprt<='0';
			avl_wrprt<=(others=>'0');
			avl_rdprt<=(others=>'0');
			avl_statpacket<=0; 
			avl_delaydatavalid<=(others=>'0');
		elsif rising_edge(avl_clk) then  
			if avl_device=reg_sadr then
				avl_delaydatavalid(1 downto 0)<='0' & avl_read;
				if avl_reg=0 and avl_read='1' then  avl_readdata<=
					conv_std_logic_vector(eth_dma_ver,8) & 
					conv_std_logic_vector(eth_dma_rev,8) & 
					conv_std_logic_vector(eth_dma_option,8) & 
					x"0a";
				elsif avl_reg=1 and avl_read='1' then avl_readdata<=conv_std_logic_vector(mem_sadr,16) & x"0000";
				elsif avl_reg=2 and avl_read='1' then avl_readdata<=conv_std_logic_vector(mem_size,avl_data_width);
				elsif avl_reg=3 and avl_write='1' then avl_rst<=avl_writedata(0);
					--				elsif avl_reg=4 and avl_write='1' then avl_MTU<=conv_integer(avl_writedata(15 downto 0));
					--				elsif avl_reg=4 and avl_read='1' then avl_readdata<=conv_std_logic_vector(avl_MTU,avl_data_width);
				elsif avl_reg=5 and avl_read='1' then avl_readdata<=eth_errcode & ext(avl_wrprt,24);
				elsif avl_reg=5 and avl_write='1' then avl_wrprt<=avl_writedata(mem_adr_width-1 downto 0); 
				elsif avl_reg=6 and avl_read='1' then avl_readdata<=eth_errcode & ext(avl_rdprt,24);
				elsif avl_reg=7 and avl_write='1' then avl_delay<=avl_writedata(15 downto 0);
				elsif avl_reg=7 and avl_read='1' then avl_readdata<=ext(avl_delay,avl_data_width);
				elsif avl_reg=8 and avl_read='1' then avl_readdata<=conv_std_logic_vector(avl_statpacket,avl_data_width);
				else  avl_readdata<=(others=>'0');
				end if;	 
			elsif avl_device=mem_sadr then avl_readdata<=avl_memdout; avl_delaydatavalid(1 downto 0)<=avl_read & '0';
			else  avl_readdata<=(others=>'0'); avl_delaydatavalid(1 downto 0)<="00";
			end if;	
			if avl_rst='1' then avl_rst<='0'; end if;
			if avl_syncrdprt='1' then avl_rdprt<=eth_rdprt; end if; 
			if avl_syncrdprt='1' then avl_statpacket<=avl_statpacket+1; end if; 
			avl_delaydatavalid(2 downto 2)<=avl_delaydatavalid(1 downto 1);
			avl_syncwrprt<=boolean_to_data(avl_device=reg_sadr and avl_reg=5 and avl_write='1');
			--			avl_syncmtu<=boolean_to_data(avl_reg=4 and avl_write='1');
		end if;
	end process reg_proc;    
	
	avl_memsel<='1' when avl_device=mem_sadr else '0';
	ethtxdma_mem : entity work.ethdma_mem 
	port map(
	reseta => '0',
	clka => eth_clk,
	cea => '1',
	ada => eth_address,
	wrea => '0',
	dina => x"00000000",	   
	ocea => '1',
	douta => eth_readdata,
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
