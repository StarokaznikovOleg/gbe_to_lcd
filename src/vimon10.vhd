library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  

library work;
use work.vimon10_lib.all;								    
use work.lcd_lib.all;
use work.bme280_lib.all;

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
		ETH_MDC,ETH_MDIO : inout STD_LOGIC;	  
		
		--Sensor I2C  port
		Sensor_SCL,Sensor_SDA	: inout STD_LOGIC;	 
		
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
	signal all_lock,sdrampll_lock,commonpll_lock,ethtxpll_lock,lcd_lock: std_logic:='0';	
	signal clk_125MHz: std_logic:='0';	
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
	signal gpu_clk,sdram_clk,common_clk: std_logic:='0';   
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
	signal power,detect_video,detect_voice : std_logic;
	signal eth_link : std_logic_vector(1 downto 0);
	signal eth0_clksel, eth1_clksel : std_logic_vector(3 downto 0);
	signal dbg : std_logic_vector(3 downto 0);	 
	
	signal bme280: type_outBME280; 
	signal LCD_backlight : integer range 0 to 100;
	
begin  
	
	power<='0';
	dbg<=DB(3 downto 0);		
	
	all_lock<=PWG and sdrampll_lock and lcd_lock and commonpll_lock;
	reset<=not(all_lock);
	--------------------------------------------------------	
	
	ETH0_RSTN<=not rst_eth;
	ETH1_RSTN<=not rst_eth;
	
	--------------------------------------------------------	
	err_clk(00)<=eth0rx_clock;	err_pulse(00)<=ethrx_err(0);		--RXETH: video packet crc32 error
	err_clk(01)<=eth0rx_clock;	err_pulse(01)<=ethrx_err(1); 		--RXETH: video packet frame error
	err_clk(02)<=eth0rx_clock;	err_pulse(02)<=ethrx_err(2); 		--RXETH: video packet len error
	err_clk(03)<=eth0rx_clock;	err_pulse(03)<=ethrx_err(3); 		--RXETH: video packet sequence error
	err_clk(04)<=gpu_clk;		err_pulse(04)<=gpu_err(0);   		--GPU: video signature error
	err_clk(05)<=gpu_clk;		err_pulse(05)<=gpu_err(1);			--GPU: video sequence error
	err_clk(06)<=gpu_clk;		err_pulse(06)<=gpu_err(2);			--sdram wrd_ack error
	err_clk(07)<=gpu_clk;		err_pulse(07)<=gpu_err(3);			--sdram read timeout error
	err_clk(08)<=lcd_pclk;		err_pulse(08)<=lcd_err;				--LCD: video sequence error
	
	--------------------------------------------------------	
	--  common pll	
	common_rpll1 : entity work.common_rpll 
	port map( clkin=>CLK25M,
		lock=>commonpll_lock,
		clkout=>common_clk );	
	--------------------------------------------------------	
	--  sdram pll	
	sdram_rpll1 : entity work.sdram_rpll 
	port map( clkin=>CLK25M,
		lock=>sdrampll_lock,
		clkout=>sdram_clk,
		clkoutp=>gpu_clk );	
	
	--------------------------------------------------------	
	--  lcd pll	
	lcd_sclk_pll : entity work.lcd_rpll 
	port map ( clkin=>CLK25M,		--reference 25MHz
		lock=>lcd_lock,
		clkout=>ref_sclk,		--clock 225MHz
		clkoutp=>lcd_sclk ); 		--clock 225MHz shift 45°
	
	lcd_pclk_pll : entity work.lcd_clkdiv 
	port map(
		resetn=>'1',
		hclkin=>ref_sclk,	--clock 225MHz
		clkout=>lcd_pclk	 --clock 225MHz/3.5=64.286MHz
		);	
	
	--------------------------------------------------------	
	--  rx_eth0 path	
	eth0rx_clock<=ETH0_RXCLK;
	rgmii0_rxdin(4)<=ETH0_RXCTL;
	rgmii0_rxdin(3 downto 0)<=ETH0_RXD;
	rgmii0_rx1 : entity work.rgmii_rx 
	port map( clk=>eth0rx_clock,
		din=>rgmii0_rxdin,
		q=>rgmii0_rxdout );	
	
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
	port map( clk=>eth1rx_clock,
		din=>rgmii1_rxdin,
		q=>rgmii1_rxdout );	
	
	eth1rx_mux_proc: process (eth1rx_clock)
	begin
		if rising_edge(eth1rx_clock) then 	
			eth1rx_dv<=rgmii1_rxdout(4);
			eth1rx_d<=rgmii1_rxdout(8 downto 5) & rgmii1_rxdout(3 downto 0); 
		end if;
	end process eth1rx_mux_proc;
	--------------------------------------------------------
	-- eth0 & eth1 connections 
	eth0tx_en<=eth1rx_dv;
	eth0tx_d<=eth1rx_d;		  
	eth1tx_en<=eth0rx_dv;
	eth1tx_d<=eth0rx_d;	 
	
	--------------------------------------------------------	
	--  tx_eth0 path	
	rgmii0_txdin(9)<=eth0tx_en;
	rgmii0_txdin(8 downto 5)<=eth0tx_d(7 downto 4);
	rgmii0_txdin(4)<=eth0tx_en;
	rgmii0_txdin(3 downto 0)<=eth0tx_d(3 downto 0);
	rgmii0_tx1 : entity work.rgmii_tx 
	port map( clk=>eth1rx_clock,
		din=>rgmii0_txdin,
		q=>rgmii0_txdout );	
	ETH0_TXD<=rgmii0_txdout(3 downto 0);
	ETH0_TXCTL<=rgmii0_txdout(4);
	ETH0_TXCLK<=eth1rx_clock;
	--	--------------------------------------------------------	
	--	--  tx_eth1 path	 
	rgmii1_txdin(9)<=eth1tx_en;
	rgmii1_txdin(8 downto 5)<=eth1tx_d(7 downto 4);
	rgmii1_txdin(4)<=eth1tx_en;
	rgmii1_txdin(3 downto 0)<=eth1tx_d(3 downto 0);
	rgmii1_tx1 : entity work.rgmii_tx 
	port map( clk=>eth0rx_clock,
		din=>rgmii1_txdin,
		q=>rgmii1_txdout );	
	ETH1_TXD<=rgmii1_txdout(3 downto 0);
	ETH1_TXCTL<=rgmii1_txdout(4);
	ETH1_TXCLK<=eth0rx_clock;
	--------------------------------------------------------	
	--  grafics_ctr		  
	grafics_ctr1 : entity work.grafics_ctr
	generic map(hsize=>LCD_hsize, hblank=>LCD_hblank, vsize=>LCD_vsize, vblank=>LCD_vblank)
	port map(
		reset=>rst_gpu, 
		dbg=>dbg,
		err_clk=>err_clk,
		err_pulse=>err_pulse,
		
		pclk=>lcd_pclk,
		Vcount=>lcd_Vcount,
		Hcount=>lcd_Hcount,
		act_pixel=>grafics_act_pixel,
		color_pixel=>grafics_color_pixel,
		
		txt_mapclk=>common_clk,
		txt_mapadr=>txt_mapadr,
		txt_mapwr=>txt_mapwr,
		txt_mapdin=>txt_mapdin );	
	detect_video<=not no_signal;
	detect_voice<='1';

	stat_module1 : entity work.stat_module 
	port map( reset=>reset, clock=>common_clk,
		bme280=>bme280,
		eth_link=>eth_link(1), 
		detect_video=>detect_video, 
		detect_voice=>detect_voice, 
		LCD_backlight=>LCD_backlight,
		MAPTXT_a=>txt_mapadr,
		MAPTXT_d=>txt_mapdin,
		MAPTXT_wr=>txt_mapwr );	
	LED_GREEN<='1';
	LED_BLUE<='1';
	LED_RED<='1';
	
	sync_all : entity work.resync 
	port map( reset=>reset, clock=>common_clk,
		rst_hw=>rst_hw,
		clk_eth=>eth1rx_clock,
		rst_eth=>rst_eth,
		clk_gpu=>gpu_clk,
		rst_gpu=>rst_gpu,
		clk_lcd=>lcd_pclk,
		rst_lcd=>rst_lcd );		
	
	ethrx_module1 : entity work.ethrx_module 
	generic map( hsize=>1920, vsize=>1080)
	port map( reset=>rst_eth, clock=>eth1rx_clock,
		err=>ethrx_err,
		vsync=>eth_vsync,
		ethrx_en=>eth1rx_dv,
		ethrx_d=>eth1rx_d,
		ethv_a=>ethv_a,
		ethv_wr=>ethv_wr,
		ethv_d=>ethv_d );	
	
	rx_video_mem : entity work.video_mem4096x32
	port map( reseta=>rst_eth, clka=>eth1rx_clock,
		cea=>'1',
		ada=>ethv_a,
		wrea=>ethv_wr,
		dina=>ethv_d,
		ocea=>'1',
		douta=>ethv_q,
		resetb=>rst_gpu,
		clkb=>gpu_clk,
		ceb=>'1',
		adb=>gpurx_a,
		wreb=>gpurx_wr,
		dinb=>gpurx_d,
		oceb=>'1',
		doutb=>gpurx_q  );
	
	gpu1 : entity work.gpu 
	port map( reset=>rst_gpu, clock=>gpu_clk,
		err=>gpu_err,
		no_signal=>no_signal,
		
		rx_a=>gpurx_a,
		rx_wr=>gpurx_wr,
		rx_d=>gpurx_d,
		rx_q=>gpurx_q,
		tx_sel=>gputx_sel,
		tx_a=>gputx_a,
		tx_wr=>gputx_wr,
		tx_d=>gputx_d,
		tx_q=>gputx_q,
		
		O_sdrc_rst_n=>sdrc_rst_n,
		O_sdrc_power_down=>sdrc_power_down,
		O_sdrc_selfrefresh=>sdrc_selfrefresh,
		O_sdrc_data_len=>sdrc_data_len,
		I_sdrc_init_done=>sdrc_init_done,
		I_sdrc_busy_n=>sdrc_busy_n,
		O_sdrc_addr=>sdrc_addr,
		O_sdrc_wr_n=>sdrc_wr_n,
		O_sdrc_rd_n=>sdrc_rd_n,
		I_sdrc_wrd_ack=>sdrc_wrd_ack,
		O_sdrc_dqm=>sdrc_dqm,
		O_sdrc_data=>sdrc_data,
		I_sdrc_data=>sdrc_data_out,
		I_sdrc_rd_valid=>sdrc_rd_valid );
	
	sdram_int1 : entity work.sdram_int 
	port map(
		I_sdrc_rst_n=>sdrc_rst_n,
		I_sdrc_clk=>gpu_clk,
		I_sdram_clk=>sdram_clk,
		I_sdrc_selfrefresh=>sdrc_selfrefresh,
		I_sdrc_power_down=>sdrc_power_down,
		O_sdrc_init_done=>sdrc_init_done,
		O_sdrc_busy_n=>sdrc_busy_n,
		I_sdrc_addr=>sdrc_addr,
		I_sdrc_data_len=>sdrc_data_len,
		I_sdrc_wr_n=>sdrc_wr_n,
		I_sdrc_rd_n=>sdrc_rd_n,
		O_sdrc_wrd_ack=>sdrc_wrd_ack,
		I_sdrc_dqm=>sdrc_dqm,
		I_sdrc_data=>sdrc_data,
		O_sdrc_data=>sdrc_data_out,
		O_sdrc_rd_valid=>sdrc_rd_valid,
		O_sdram_clk =>O_sdram_clk,
		O_sdram_cke=>O_sdram_cke,
		O_sdram_cs_n=>O_sdram_cs_n,
		O_sdram_cas_n=>O_sdram_cas_n,
		O_sdram_ras_n=>O_sdram_ras_n,
		O_sdram_wen_n=>O_sdram_wen_n,
		O_sdram_addr=>O_sdram_addr,
		O_sdram_ba=>O_sdram_ba,
		O_sdram_dqm=>O_sdram_dqm,
		IO_sdram_dq=>IO_sdram_dq );
	
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
	LCD_backlight<=100; -- backlight is fixed now :(
	LCD_EN_LED<=int_LCD_EN ;
	LCD_PWM<= not int_LCD_PWM; 	
	lcd_module1 : entity work.lcd_module 
	generic map( hsize=>LCD_hsize, hblank=>LCD_hblank, vsize=>LCD_vsize, vblank=>LCD_vblank,
		hpicture=>960, vfild=>32 )
	port map( reset=>reset, --rst_lcd,
		sclk=>lcd_sclk,
		pclk=>lcd_pclk,
		err=>lcd_err,
		vsync=>lcd_vsync,
		EN=>set_LCD_EN,
		backlight=>LCD_backlight,
		mem_a=>lcd_a,
		mem_wr=>lcd_wr,
		mem_d=>lcd_d,
		mem_q=>lcd_q,
		LCD_EN_VDD=>LCD_EN_VDD,
		LCD_RST=>LCD_RST,
		LCD_READY=>LCD_DIM,
		LCD_EN=>int_LCD_EN,
		LCD_PWM=>int_LCD_PWM,
		lcd_a_clk=>LVDS_A_OUT_CLK,
		lcd_a=>LVDS_A_OUTP,
		Vcount=>lcd_Vcount,
		Hcount=>lcd_Hcount,
		grafics_act=>grafics_act_pixel,
		grafics_color=>grafics_color_pixel ); 
	
	MDIO_module1 : entity work.MDIO_module 
	port map( reset=>rst_eth, clock=>common_clk,
		MDC=>ETH_MDC, MDIO=>ETH_MDIO,
		link=>eth_link );	
	
	sensor1_bme280 : entity work.bme280_module
	generic map( ref_freq=>12500000 )
	port map( reset=>reset, clock=>common_clk,
		scl=>Sensor_SCL, sda=>Sensor_SDA,
		bme280=>bme280 );	
	
end main;

