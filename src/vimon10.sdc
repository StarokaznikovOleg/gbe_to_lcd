//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-3
//Created Time: 2023-11-14 14:51:36
create_clock -name clock_25MHz -period 40 -waveform {0 20} [get_ports {CLK25M}]
create_clock -name clock_eth0rx_ext -period 8 -waveform {0 4} [get_ports {ETH0_RXCLK}]
create_clock -name clock_eth1rx_ext -period 8 -waveform {0 4} [get_ports {ETH1_RXCLK}]
create_generated_clock -name clock_sdram -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 1 -multiply_by 5 -duty_cycle 50 [get_pins {sdram_rpll1/rpll_inst/CLKOUT}]
create_generated_clock -name clock_gpu -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 1 -multiply_by 5 -duty_cycle 50 -phase 45 [get_pins {sdram_rpll1/rpll_inst/CLKOUTP}]
create_generated_clock -name clock_sclk -source [get_ports {CLK25M}] -master_clock clock_25MHz -multiply_by 9 -duty_cycle 50 -offset 0.000 [get_pins {lcd_sclk_pll/rpll_inst/CLKOUT}]
create_generated_clock -name clock_pclk -source [get_ports {CLK25M}] -master_clock clock_25MHz -multiply_by 18 -divide_by 7 -duty_cycle 50  -offset 0.000 [get_pins {lcd_pclk_pll/clkdiv_inst/CLKOUT}]
create_generated_clock -name clock_int -source [get_ports {CLK25M}] -master_clock clock_25MHz -divide_by 49 -multiply_by 36 -duty_cycle 50 [get_pins {intclk_source/clkdiv_inst/CLKOUT}]
set_false_path -to [get_regs {*false_path_sync*}] 
report_high_fanout_nets -max_nets 100
set_operating_conditions -grade c -model slow -speed 8 -setup -hold -max -min -max_min
