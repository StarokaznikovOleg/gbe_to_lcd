//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.07 
//Created Time: 2023-03-14 14:41:13
create_clock -name clock_eth0rx_ext -period 8 -waveform {0 4} [get_ports {ETH0_RXCLK}]
//create_clock -name clock_eth1rx_ext -period 8 -waveform {0 4} [get_ports {ETH1_RXCLK}]
create_clock -name clock_2MHz -period 400 -waveform {0 200} [get_pins {gen_2M/osc_inst/OSCOUT}]
create_clock -name clock_25MHz -period 40 -waveform {0 20} [get_ports {CLK25M}]
create_generated_clock -name clock_sclk -source [get_ports {CLK25M}] -master_clock clock_25MHz -multiply_by 9 -duty_cycle 50 -phase 45 [get_pins {lcd_sclk_pll/rpll_inst/CLKOUTP}]
create_generated_clock -name clock_250MHz -source [get_ports {CLK25M}] -master_clock clock_25MHz -multiply_by 9 -duty_cycle 50 [get_pins {lcd_sclk_pll/rpll_inst/CLKOUT}]
create_generated_clock -name clock_pclk -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 7 -multiply_by 20 -duty_cycle 50 [get_pins {lcd_pclk_pll/clkdiv_inst/CLKOUT}]
//create_generated_clock -name clock_eth0rx -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 1 -multiply_by 5 -duty_cycle 50 -phase 45 [get_pins {rx_eth0_rpll/rpll_inst/CLKOUTP}]
create_generated_clock -name clock_gpu -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 1 -multiply_by 5 -duty_cycle 50 -phase 45 [get_pins {sdram_rpll1/rpll_inst/CLKOUTP}]
create_generated_clock -name clock_sdram -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 1 -multiply_by 5 -duty_cycle 50 [get_pins {sdram_rpll1/rpll_inst/CLKOUT}]
//set_false_path -from [get_clocks {clock_eth0rx}] -to [get_clocks {clock_2MHz}] 
//set_false_path -from [get_clocks {clock_eth0rx}] -to [get_clocks {clock_pclk}] 
set_false_path -from [get_clocks {clock_gpu}] -to [get_clocks {clock_pclk}] 
set_false_path -from [get_clocks {clock_2MHz}] -to [get_clocks {clock_pclk}] 
//set_false_path -from [get_clocks {clock_2MHz}] -to [get_clocks {clock_eth0rx}] 
set_false_path -from [get_clocks {clock_2MHz}] -to [get_clocks {clock_gpu}] 
set_false_path -from [get_clocks {clock_pclk}] -to [get_clocks {clock_sclk}] 
set_false_path -from [get_clocks {clock_pclk}] -to [get_clocks {clock_gpu}] 
set_false_path -from [get_clocks {clock_pclk}] -to [get_clocks {clock_2MHz}] 
//set_false_path -from [get_clocks {clock_pclk}] -to [get_clocks {clock_eth0rx}] 
//set_max_delay -from [get_pins {rgmii0_tx1/oddr_gen[0].oddr_inst/Q0 rgmii0_tx1/oddr_gen[1].oddr_inst/Q0 rgmii0_tx1/oddr_gen[2].oddr_inst/Q0 rgmii0_tx1/oddr_gen[3].oddr_inst/Q0 rgmii0_tx1/oddr_gen[4].oddr_inst/Q0}] -to [get_ports {ETH0_TXCTL ETH0_TXD[3] ETH0_TXD[2] ETH0_TXD[1] ETH0_TXD[0]}] 5
//report_timing -setup -from_clock [get_clocks {clock_eth0rx}] -to_clock [get_clocks {clock_eth0rx}] -max_paths 200 -max_common_paths 1
report_timing -setup -from_clock [get_clocks {clock_gpu}] -to_clock [get_clocks {clock_gpu}] -max_paths 200 -max_common_paths 1
report_timing -setup -from_clock [get_clocks {clock_pclk}] -to_clock [get_clocks {clock_pclk}] -max_paths 200 -max_common_paths 1
//report_timing -setup -to [get_ports {ETH0_TXCTL ETH0_TXD[3] ETH0_TXD[2] ETH0_TXD[1] ETH0_TXD[0]}]
report_high_fanout_nets -max_nets 20
set_operating_conditions -grade c -model slow -speed 8 -setup -hold -max -min -max_min
