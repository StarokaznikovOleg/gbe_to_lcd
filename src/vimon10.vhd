library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  

library work;
use work.vimon10_lib.all;								    
use work.lcd_lib.all;

entity vimon10 is
	port(	
		--system
		PWG	: in STD_LOGIC;
		CLK25M	: in STD_LOGIC;
		LED_GREEN,LED_BLUE,LED_RED : out STD_LOGIC; 	
		DB : in STD_LOGIC_VECTOR(3 downto 0); 
		
		--LCD port
		LCD_EN_VDD,LCD_PWM : out STD_LOGIC; 
		LCD_EN_LED,LCD_RST : out STD_LOGIC; 
		LCD_DIM : in STD_LOGIC; 
		LVDS_A_OUT_CLK : out STD_LOGIC; 
		LVDS_A_OUTP : out STD_LOGIC_VECTOR(3 downto 0); 
		
		--ETH0 port
		ETH0_RSTN : out STD_LOGIC;
		ETH0_CLKOUT : in STD_LOGIC; 
		ETH0_RXCLK,ETH0_RXCTL : in STD_LOGIC; 
		ETH0_RXD : in STD_LOGIC_VECTOR(3 downto 0); 
		ETH0_TXCLK,ETH0_TXCTL : out STD_LOGIC; 
		ETH0_TXD : out STD_LOGIC_VECTOR(3 downto 0); 
		
		--ETH1 port
		ETH1_RSTN : out STD_LOGIC;
		ETH1_CLKOUT : in STD_LOGIC; 
		ETH1_RXCLK,ETH1_RXCTL : in STD_LOGIC; 
		ETH1_RXD : in STD_LOGIC_VECTOR(3 downto 0); 
		ETH1_TXCLK,ETH1_TXCTL : out STD_LOGIC; 
		ETH1_TXD : out STD_LOGIC_VECTOR(3 downto 0);  
		
		--MDI port
		ETH_MDC : inout STD_LOGIC;
		ETH_MDIO : inout STD_LOGIC;
		
		--internal SDRAM 
		O_sdram_clk,O_sdram_cke,O_sdram_cs_n,O_sdram_cas_n,O_sdram_ras_n,O_sdram_wen_n : out STD_LOGIC;
		O_sdram_dqm: out STD_LOGIC_VECTOR(3 downto 0); 
		O_sdram_addr: out STD_LOGIC_VECTOR(10 downto 0); 
		O_sdram_ba: out STD_LOGIC_VECTOR(1 downto 0); 
		IO_sdram_dq: inout STD_LOGIC_VECTOR(31 downto 0) 
		);
	
end vimon10;

architecture main of vimon10 is	 
	
	signal reset: std_logic:='0';	  
	signal all_lock,sdrampll_lock,ethtxpll_lock,lcd_lock: std_logic:='0';	
	signal clock_2MHz,clk_125MHz: std_logic:='0';	
	signal ref_sclk,lcd_sclk,lcd_pclk: std_logic:='0';	
	
	signal eth0rx_ref,eth1rx_ref: std_logic:='0';  
	signal eth0rx_clock,eth0_txclk_int,eth0_txclk_ext,eth0rxpll_lock: std_logic:='0';  
	signal eth1rx_clock,eth1_txclk_int,eth1_txclk_ext,eth1rxpll_lock: std_logic:='0';  
	
	signal eth0tx_en,eth0rx_dv,eth1tx_en,eth1rx_dv: std_logic:='0';
	signal eth0rx_d,eth0tx_d,eth1rx_d,eth1tx_d: std_logic_vector(7 downto 0):=(others=>'0');  	   
	signal rgmii0_rxdin,rgmii0_txdout,rgmii1_rxdin,rgmii1_txdout: std_logic_vector(4 downto 0):=(others=>'0');  	   
	signal rgmii0_rxdout,rgmii0_txdin,rgmii1_rxdout,rgmii1_txdin: std_logic_vector(9 downto 0):=(others=>'0'); 
	
	signal rgmii0_rxvalue: std_logic_vector(6 downto 0):=(others=>'0'); 
	signal rgmii0_rxsdtap,rgmii0_rxsetn: std_logic:='0';
	
	signal gpu_err: std_logic_vector(3 downto 0):=(others=>'0'); 
	signal ethrx_err: std_logic_vector(3 downto 0):=(others=>'0'); 
	signal lcd_err: std_logic:='0';  
	
	signal ethv_a: std_logic_vector(11 downto 0):=(others=>'0'); 
	signal gputx_sel: std_logic_vector(2 downto 0):=(others=>'0'); 
	signal gpurx_a: std_logic_vector(11 downto 0):=(others=>'0'); 
	signal gputx_a,lcd_a: std_logic_vector(9 downto 0):=(others=>'0'); 
	signal ethv_wr,gpurx_wr,gputx_wr,lcd_wr: std_logic:='0'; 
	signal ethv_d: std_logic_vector(31 downto 0):=(others=>'0'); 
	signal gpurx_d,gputx_d: std_logic_vector(31 downto 0):=(others=>'0'); 
	signal lcd_d: std_logic_vector(31 downto 0):=(others=>'0'); 
	signal lcd_q: std_logic_vector(95 downto 0):=(others=>'0'); 
	signal ethv_q,gpurx_q,gputx_q: std_logic_vector(31 downto 0):=(others=>'0'); 
	
	signal err_clk,err_pulse: type_pulse_err:=(others=>'0'); 
	
	signal rst_hw,rst_gpu,rst_lcd,rst_eth: std_logic:='0';  
	signal gpu_clk,sdram_clk: std_logic:='0';   
	signal lcd_vsync,eth_vsync: std_logic:='0';   	  
	
	signal sdrc_rst_n,sdrc_selfrefresh,sdrc_power_down,sdrc_wr_n,sdrc_rd_n,sdrc_init_done,sdrc_busy_n,sdrc_rd_valid,sdrc_wrd_ack : std_logic:='0'; 
	signal sdrc_addr: std_logic_vector(20 downto 0):=(others=>'0'); 
	signal sdrc_data_len: std_logic_vector(7 downto 0):=(others=>'0'); 
	signal sdrc_dqm: std_logic_vector(3 downto 0):=(others=>'0'); 
	signal sdrc_data_out: std_logic_vector(31 downto 0):=(others=>'0'); 
	signal sdrc_data: std_logic_vector(31 downto 0):=(others=>'0'); 
	
	signal set_LCD_PWM: std_logic_vector(7 downto 0); 
	signal set_LCD_EN,int_LCD_EN,int_LCD_PWM: std_logic; 
	signal no_signal: std_logic; 	 	   	 
	
	signal lcd_Vcount,lcd_Hcount: integer; 	 
	signal grafics_act_pixel : boolean;
	signal grafics_color_pixel : type_rgb_color;
	
	signal txt_mapadr : std_logic_vector(13 downto 0);
	signal txt_mapwr : std_logic;
	signal txt_mapdin : std_logic_vector(7 downto 0);
	signal power,video : std_logic;
	signal eth_link : std_logic_vector(1 downto 0);
	signal eth0_clksel, eth1_clksel : std_logic_vector(3 downto 0);
	signal dbg : std_logic_vector(3 downto 0);
	
begin  
	
	power<='0';
	video<= not no_signal;
	dbg<=DB(3 downto 0);		
	
	all_lock<=PWG and sdrampll_lock and lcd_lock;
	reset<=not(all_lock);
	--------------------------------------------------------	
	
	ETH0_RSTN<='1'; --not rst_hw;
	ETH1_RSTN<=not rst_hw;
	
	--------------------------------------------------------	
	--  errors control	
	err_clk(00)<=gpu_clk;		err_pulse(00)<=sdrampll_lock; 	--GPU and SDRAM pll ok
	err_clk(01)<=lcd_pclk;		err_pulse(01)<=lcd_lock;		--LCD pll ok
	err_clk(02)<=CLK25M;		err_pulse(02)<=eth_link(0);	--eth0 link ok
	err_clk(03)<=gpu_clk;		err_pulse(03)<=not no_signal;	--eth0 video	ok
	
	err_clk(04)<=eth0rx_clock;	err_pulse(04)<=ethrx_err(0);		--RXETH: video packet crc32 error
	err_clk(05)<=eth0rx_clock;	err_pulse(05)<=ethrx_err(1); 		--RXETH: video packet frame error
	err_clk(06)<=eth0rx_clock;	err_pulse(06)<=ethrx_err(2); 		--RXETH: video packet len error
	err_clk(07)<=eth0rx_clock;	err_pulse(07)<=ethrx_err(3); 		--RXETH: video packet sequence error
	err_clk(08)<=gpu_clk;		err_pulse(08)<=gpu_err(0);   		--GPU: video signature error
	err_clk(09)<=gpu_clk;		err_pulse(09)<=gpu_err(1);			--GPU: video sequence error
	err_clk(10)<=gpu_clk;		err_pulse(10)<=gpu_err(2);			--sdram wrd_ack error
	err_clk(11)<=gpu_clk;		err_pulse(11)<=gpu_err(3);			--sdram read timeout error
	err_clk(12)<=lcd_pclk;		err_pulse(12)<=lcd_err;				--LCD: video sequence error
	
	--------------------------------------------------------	
	--  internal clock 2.3MHz	
	gen_2M : entity work.main_OSC 
	port map(
		oscout => clock_2MHz 	--clock 2MHz
		);	 
	
	--------------------------------------------------------	
	--  sdram pll	
	sdram_rpll1 : entity work.sdram_rpll 
	port map(
		clkin => CLK25M,
		lock => sdrampll_lock,
		clkout => sdram_clk,
		clkoutp => gpu_clk
		);	
	
	--------------------------------------------------------	
	--  lcd pll	
	lcd_sclk_pll : entity work.lcd_rpll 
	port map (
		clkin => CLK25M,		--reference 25MHz
		lock => lcd_lock,
		clkout => ref_sclk,		--clock 250MHz
		clkoutp => lcd_sclk,	--clock 250MHz shift 45°
		clkoutd => open --clk_125MHz   --clock 125MHz
		); 	 		 
	
	lcd_pclk_pll : entity work.lcd_clkdiv 
	port map(
		resetn => '1',
		hclkin => ref_sclk,	--clock 250MHz
		clkout => lcd_pclk	 --clock 250MHz/3.5=71.429MHz
		);	
	
	--------------------------------------------------------	
	--  rx_eth0 path	
	eth0rx_clock<=ETH0_RXCLK;
	rgmii0_rxdin(4)<=ETH0_RXCTL;
	rgmii0_rxdin(3 downto 0)<=ETH0_RXD;
	rgmii0_rx1 : entity work.rgmii_rx 
	port map( clk => eth0rx_clock,
		din => rgmii0_rxdin,
		q => rgmii0_rxdout );	
	
	eth0rx_mux_proc: process (eth0rx_clock)
	begin
		if rising_edge(eth0rx_clock) then 	
			eth0rx_dv<=rgmii0_rxdout(4);
			eth0rx_d<=rgmii0_rxdout(8 downto 5) & rgmii0_rxdout(3 downto 0); 
		end if;
	end process eth0rx_mux_proc;
	
	--	--------------------------------------------------------	
	--	--  rx_eth1 path	
	eth1rx_clock<=ETH1_RXCLK;
	rgmii1_rxdin(4)<=ETH1_RXCTL;
	rgmii1_rxdin(3 downto 0)<=ETH1_RXD;
	rgmii1_rx2 : entity work.rgmii_rx 
	port map( clk => eth1rx_clock,
		din => rgmii1_rxdin,
		q => rgmii1_rxdout );	
	
	eth1rx_mux_proc: process (eth1rx_clock)
	begin
		if rising_edge(eth1rx_clock) then 	
			eth1rx_dv<=rgmii1_rxdout(4);
			eth1rx_d<=rgmii1_rxdout(8 downto 5) & rgmii1_rxdout(3 downto 0); 
		end if;
	end process eth1rx_mux_proc;
	--------------------------------------------------------
	-- eth0 & eth1 connections 
	eth0_clksel<="0010";
	eth0tx_en<=eth1rx_dv;
	eth0tx_d<=eth1rx_d;		  
	eth1_clksel<="0001";
	eth1tx_en<=eth0rx_dv;
	eth1tx_d<=eth0rx_d;	 
		eth0_txclock : entity work.eth_txclock 
	port map(
		clkout => ETH0_TXCLK, clksel => eth0_clksel,
		clk0 => eth0rx_clock, clk1 => eth1rx_clock, clk2 => ETH0_CLKOUT, clk3 => ETH1_CLKOUT);
		eth1_txclock : entity work.eth_txclock 
	port map(
		clkout => ETH1_TXCLK, clksel => eth1_clksel,
		clk0 => eth0rx_clock, clk1 => eth1rx_clock, clk2 => ETH0_CLKOUT, clk3 => ETH1_CLKOUT);

	--------------------------------------------------------	
	--  tx_eth0 path	
	rgmii0_txdin(9)<=eth0tx_en;
	rgmii0_txdin(8 downto 5)<=eth0tx_d(7 downto 4);
	rgmii0_txdin(4)<=eth0tx_en;
	rgmii0_txdin(3 downto 0)<=eth0tx_d(3 downto 0);
	rgmii0_tx1 : entity work.rgmii_tx 
	port map( clk => eth1rx_clock,
		din => rgmii0_txdin,
		q => rgmii0_txdout );	
	ETH0_TXD<=rgmii0_txdout(3 downto 0);
	ETH0_TXCTL<=rgmii0_txdout(4);
	--	--------------------------------------------------------	
	--	--  tx_eth1 path	 
	rgmii1_txdin(9)<=eth1tx_en;
	rgmii1_txdin(8 downto 5)<=eth1tx_d(7 downto 4);
	rgmii1_txdin(4)<=eth1tx_en;
	rgmii1_txdin(3 downto 0)<=eth1tx_d(3 downto 0);
	rgmii1_tx1 : entity work.rgmii_tx 
	port map( clk => eth0rx_clock,
		din => rgmii1_txdin,
		q => rgmii1_txdout );	
	ETH1_TXD<=rgmii1_txdout(3 downto 0);
	ETH1_TXCTL<=rgmii1_txdout(4);
	--------------------------------------------------------	
	--  grafics_ctr		  
	grafics_ctr1 : entity work.grafics_ctr
	generic map(hsize=>LCD_hsize, hblank=>LCD_hblank, vsize=>LCD_vsize, vblank=>LCD_vblank)
	port map(
		reset => rst_gpu, 
		dbg => dbg,
		err_clk => err_clk,
		err_pulse => err_pulse,
		
		pclk => lcd_pclk,
		Vcount => lcd_Vcount,
		Hcount => lcd_Hcount,
		act_pixel => grafics_act_pixel,
		color_pixel => grafics_color_pixel,
		
		txt_mapadr => txt_mapadr,
		txt_mapclk => lcd_pclk,
		txt_mapwr => txt_mapwr,
		txt_mapdin => txt_mapdin
		);	
	
	text_ctr1 : entity work.text_ctr 
	port map(
		reset => reset,
		clock => lcd_pclk,
		map_adr => txt_mapadr,
		map_wr => txt_mapwr,
		map_dout => txt_mapdin,
		link0 => eth_link(0),
		link1 => eth_link(1),
		power => power,
		video => video
		);
	
	--------------------------------------------------------	
	sysled3 : entity work.sysled 
	generic map( max_lock=>len_lockerr, max_err=>len_err-len_lockerr)
	port map( reset => rst_hw, clock => clock_2MHz,
		LED_GREEN => LED_GREEN, LED_BLUE => LED_BLUE, LED_RED => LED_RED,
		lock => err_pulse(len_lockerr-1 downto 0),
		lock_clk => err_clk(len_lockerr-1 downto 0),
		err => err_pulse(len_err-1 downto len_lockerr),
		err_clk => err_clk(len_err-1 downto len_lockerr)
		);	
	
	sync_all : entity work.resync 
	port map(
		reset => reset,
		clock => clock_2MHz,
		rst_hw => rst_hw,
		rst_eth => rst_eth,
		rst_gpu => rst_gpu,
		rst_lcd => rst_lcd
		);		
	
	ethrx_module1 : entity work.ethrx_module 
	generic map( hsize => 1920, vsize => 1080)
	port map(
		reset => reset, --rst_eth,
		clock => eth0rx_clock,
		err => ethrx_err,
		vsync => eth_vsync,
		ethrx_en => eth0rx_dv,
		ethrx_d => eth0rx_d,
		ethv_a => ethv_a,
		ethv_wr => ethv_wr,
		ethv_d => ethv_d
		);	
	
	rx_video_mem : entity work.video_mem4096x32
	port map(
		reseta => reset, --rst_eth,
		clka => eth0rx_clock,
		cea => '1',
		ada => ethv_a,
		wrea => ethv_wr,
		dina => ethv_d,
		ocea => '1',
		douta => ethv_q,
		resetb => rst_gpu,
		clkb => gpu_clk,
		ceb => '1',
		adb => gpurx_a,
		wreb => gpurx_wr,
		dinb => gpurx_d,
		oceb => '1',
		doutb => gpurx_q
		);
	
	gpu1 : entity work.gpu 
	port map(
		reset => reset, --rst_gpu,
		clock => gpu_clk,
		err => gpu_err,
		no_signal => no_signal,
		
		rx_a => gpurx_a,
		rx_wr => gpurx_wr,
		rx_d => gpurx_d,
		rx_q => gpurx_q,
		tx_sel => gputx_sel,
		tx_a => gputx_a,
		tx_wr => gputx_wr,
		tx_d => gputx_d,
		tx_q => gputx_q,
		
		O_sdrc_rst_n => sdrc_rst_n,
		O_sdrc_power_down => sdrc_power_down,
		O_sdrc_selfrefresh => sdrc_selfrefresh,
		O_sdrc_data_len => sdrc_data_len,
		I_sdrc_init_done => sdrc_init_done,
		I_sdrc_busy_n => sdrc_busy_n,
		O_sdrc_addr => sdrc_addr,
		O_sdrc_wr_n => sdrc_wr_n,
		O_sdrc_rd_n => sdrc_rd_n,
		I_sdrc_wrd_ack => sdrc_wrd_ack,
		O_sdrc_dqm => sdrc_dqm,
		O_sdrc_data => sdrc_data,
		I_sdrc_data => sdrc_data_out,
		I_sdrc_rd_valid => sdrc_rd_valid
		);
	
	sdram_int1 : entity work.sdram_int 
	port map(
		I_sdrc_rst_n => sdrc_rst_n,
		I_sdrc_clk => gpu_clk,
		I_sdram_clk => sdram_clk,
		I_sdrc_selfrefresh => sdrc_selfrefresh,
		I_sdrc_power_down => sdrc_power_down,
		O_sdrc_init_done => sdrc_init_done,
		O_sdrc_busy_n => sdrc_busy_n,
		I_sdrc_addr => sdrc_addr,
		I_sdrc_data_len => sdrc_data_len,
		I_sdrc_wr_n => sdrc_wr_n,
		I_sdrc_rd_n => sdrc_rd_n,
		O_sdrc_wrd_ack => sdrc_wrd_ack,
		I_sdrc_dqm => sdrc_dqm,
		I_sdrc_data => sdrc_data,
		O_sdrc_data => sdrc_data_out,
		O_sdrc_rd_valid => sdrc_rd_valid,
		O_sdram_clk =>O_sdram_clk,
		O_sdram_cke => O_sdram_cke,
		O_sdram_cs_n => O_sdram_cs_n,
		O_sdram_cas_n => O_sdram_cas_n,
		O_sdram_ras_n => O_sdram_ras_n,
		O_sdram_wen_n => O_sdram_wen_n,
		O_sdram_addr => O_sdram_addr,
		O_sdram_ba => O_sdram_ba,
		O_sdram_dqm => O_sdram_dqm,
		IO_sdram_dq => IO_sdram_dq
		);
	
	tx_video_mem_Y0 : entity work.video_mem1024x32 
	port map(
		reseta=>reset, --rst_gpu,
		clka=>gpu_clk, cea=>gputx_sel(0), ada=>gputx_a, wrea=>gputx_wr, dina=>gputx_d, ocea=>'1', douta=>gputx_q,
		resetb=>rst_lcd, clkb=>lcd_pclk, ceb=>'1', adb=>lcd_a, wreb=>lcd_wr, dinb=>lcd_d(31 downto 0), oceb=>'1', doutb=>lcd_q(31 downto 0) ); 
	
	tx_video_mem_Y1 : entity work.video_mem1024x32 
	port map(
	reseta=>reset, --rst_gpu,
	clka=>gpu_clk, cea=>gputx_sel(1), ada=>gputx_a, wrea=>gputx_wr, dina=>gputx_d, ocea=>'0', douta=>open,
	resetb=>rst_lcd, clkb=>lcd_pclk, ceb=>'1', adb=>lcd_a, wreb=>'0', dinb=>x"00000000", oceb=>'1', doutb=>lcd_q(63 downto 32) ); 
	
	tx_video_mem_C : entity work.video_mem1024x32 
	port map(
	reseta=>reset, --rst_gpu,
	clka=>gpu_clk, cea=>gputx_sel(2), ada=>gputx_a, wrea=>gputx_wr, dina=>gputx_d, ocea=>'0', douta=>open,
	resetb=>rst_lcd, clkb=>lcd_pclk, ceb=>'1', adb=>lcd_a, wreb=>'0', dinb=>x"00000000", oceb=>'1', doutb=>lcd_q(95 downto 64) ); 
	-----------------------------------
	-- LCD part	
	set_LCD_EN<='1';
	set_LCD_PWM<=x"f0"; -- backlight is fixed now :(
	LCD_EN_LED<=not int_LCD_EN ;
	LCD_PWM<= not int_LCD_PWM; 	
	lcd_module1 : entity work.lcd_module 
	generic map( hsize=>LCD_hsize, hblank=>LCD_hblank, vsize=>LCD_vsize, vblank=>LCD_vblank,
		hpicture=>960, vfild=>32 )
	port map(
		reset => reset, --rst_lcd,
		sclk => lcd_sclk,
		pclk => lcd_pclk,
		err => lcd_err,
		vsync => lcd_vsync,
		EN => set_LCD_EN,
		PWM => set_LCD_PWM,
		mem_a => lcd_a,
		mem_wr => lcd_wr,
		mem_d => lcd_d,
		mem_q => lcd_q,
		LCD_EN_VDD => LCD_EN_VDD,
		LCD_RST => LCD_RST,
		LCD_READY => LCD_DIM,
		LCD_EN => int_LCD_EN,
		LCD_PWM => int_LCD_PWM,
		lcd_a_clk => LVDS_A_OUT_CLK,
		lcd_a => LVDS_A_OUTP,
		Vcount => lcd_Vcount,
		Hcount => lcd_Hcount,
		grafics_act => grafics_act_pixel,
		grafics_color => grafics_color_pixel
		); 
	
	MDIO_module1 : entity work.MDIO_module 
	port map(
		reset => reset,
		clock => CLK25M,
		MDC => ETH_MDC,
		MDIO => ETH_MDIO,
		link => eth_link
		);	
end main;

