//
//Written by GowinSynthesis
//Product Version "GowinSynthesis V1.9.8.07"
//Fri Oct 21 16:25:34 2022

//Source file index table:
//file0 "\D:/Projects/corund10/src/gowin_ip/sdram_int/temp/SDRC_EMBEDDED/sdrc_defines.v"
//file1 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/SDRAM_controller_top_SIP.v"
//file2 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/sdrc_control_fsm.v"
//file3 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/sdrc_user_interface.v"
//file4 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/sdrc_autorefresh.v"
//file5 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/sdrc_top.v"
//file6 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/SDRC_EMB/data/GENERAL/top_defines.v"
`timescale 100 ps/100 ps
module \~control_fsm.sdram_int  (
  I_sdrc_clk,
  I_sdrc_selfrefresh,
  ctrl_fsm_wr_n,
  ctrl_fsm_rd_n,
  I_sdrc_power_down,
  ctrl_double_wrd_flag,
  autorefresh_req,
  autorefresh_req_a,
  I_sdrc_rst_n,
  ctrl_fsm_data0,
  ctrl_fsm_addr_bk,
  ctrl_fsm_addr_row,
  ctrl_fsm_data_len,
  IO_sdram_dq_in,
  ctrl_fsm_addr_col,
  ctrl_fsm_dqm,
  ctrl_fsm_init,
  ctrl_fsm_busy_n,
  ctrl_fsm_data_valid,
  O_sdram_cke,
  ctrl_fsm_wrd_done,
  autorefresh_ack,
  O_sdram_wen_n,
  O_sdram_cas_n,
  O_sdram_ras_n,
  n316_6,
  IO_sdram_dq_0_6,
  O_sdram_addr,
  O_sdram_ba,
  O_sdram_dqm,
  Ctrl_fsm_data,
  ctrl_fsm_data1
)
;
input I_sdrc_clk;
input I_sdrc_selfrefresh;
input ctrl_fsm_wr_n;
input ctrl_fsm_rd_n;
input I_sdrc_power_down;
input ctrl_double_wrd_flag;
input autorefresh_req;
input autorefresh_req_a;
input I_sdrc_rst_n;
input [31:0] ctrl_fsm_data0;
input [1:0] ctrl_fsm_addr_bk;
input [10:0] ctrl_fsm_addr_row;
input [7:0] ctrl_fsm_data_len;
input [31:0] IO_sdram_dq_in;
input [7:0] ctrl_fsm_addr_col;
input [3:0] ctrl_fsm_dqm;
output ctrl_fsm_init;
output ctrl_fsm_busy_n;
output ctrl_fsm_data_valid;
output O_sdram_cke;
output ctrl_fsm_wrd_done;
output autorefresh_ack;
output O_sdram_wen_n;
output O_sdram_cas_n;
output O_sdram_ras_n;
output n316_6;
output IO_sdram_dq_0_6;
output [10:0] O_sdram_addr;
output [1:0] O_sdram_ba;
output [3:0] O_sdram_dqm;
output [31:0] Ctrl_fsm_data;
output [31:0] ctrl_fsm_data1;
wire Reset_init_count;
wire n243_3;
wire Reset_cmd_count;
wire n272_3;
wire n273_3;
wire n274_3;
wire n275_3;
wire n276_3;
wire n277_3;
wire n278_3;
wire n953_3;
wire n956_3;
wire n962_7;
wire O_ctrl_fsm_wrd_done_5;
wire n661_9;
wire n927_8;
wire n930_8;
wire n955_10;
wire n961_10;
wire n964_10;
wire n966_10;
wire n968_10;
wire n970_10;
wire n972_10;
wire n974_10;
wire n976_10;
wire n980_10;
wire n982_10;
wire n984_10;
wire n986_10;
wire n626_11;
wire n630_9;
wire n636_9;
wire n642_11;
wire n646_9;
wire n652_9;
wire n95_14;
wire n97_14;
wire n99_14;
wire n101_14;
wire n103_14;
wire n105_14;
wire n107_14;
wire n109_14;
wire n111_15;
wire n593_22;
wire n596_23;
wire n598_23;
wire n600_22;
wire n602_22;
wire n604_22;
wire n606_22;
wire n608_23;
wire n610_22;
wire n612_23;
wire n614_21;
wire n616_22;
wire n618_23;
wire n620_22;
wire n622_21;
wire n624_21;
wire n93_15;
wire n705_5;
wire O_autorefresh_ack_6;
wire n9_4;
wire n8_4;
wire n7_4;
wire n155_4;
wire n154_4;
wire n153_4;
wire n272_4;
wire n273_4;
wire n274_4;
wire n275_4;
wire n276_4;
wire n277_4;
wire n959_4;
wire n959_5;
wire O_ctrl_fsm_wrd_done_6;
wire Flag_sdrc_wrd_8;
wire n927_10;
wire n958_11;
wire n974_11;
wire n976_11;
wire n980_11;
wire n982_11;
wire n984_11;
wire n986_11;
wire n626_12;
wire n630_10;
wire n634_10;
wire n642_12;
wire n646_10;
wire n650_10;
wire n95_15;
wire n97_15;
wire n101_15;
wire n593_23;
wire n596_24;
wire n598_25;
wire n598_26;
wire n600_23;
wire n606_23;
wire n608_24;
wire n612_24;
wire n616_23;
wire n618_24;
wire n620_23;
wire O_autorefresh_ack_7;
wire Flag_sdrc_wrd_9;
wire n927_11;
wire n927_12;
wire n593_24;
wire n596_26;
wire n596_27;
wire n598_27;
wire n618_25;
wire n620_24;
wire n927_13;
wire n596_28;
wire n598_29;
wire n959_7;
wire Flag_sdrc_wrd_11;
wire n930_11;
wire n927_15;
wire n958_13;
wire Ctrl_fsm_addr_col_7_12;
wire n593_27;
wire n596_30;
wire n279_5;
wire n132_10;
wire n132_14;
wire Ctrl_wr_data_valid_13;
wire n628_14;
wire n626_18;
wire n632_14;
wire n634_15;
wire n638_14;
wire n640_12;
wire n644_14;
wire n642_18;
wire n648_14;
wire n650_15;
wire n654_14;
wire n656_12;
wire n856_12;
wire n857_12;
wire n858_12;
wire n859_12;
wire n963_5;
wire n638_16;
wire n634_17;
wire n632_16;
wire n628_16;
wire n654_16;
wire n650_17;
wire n648_16;
wire n644_16;
wire \Cmd_init_state.INIT_STATE_PRECHARGEALL ;
wire \Cmd_init_state.INIT_STATE_PRECHARGE_DELAY ;
wire \Cmd_init_state.INIT_STATE_AUTOREFRESH1 ;
wire \Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ;
wire \Cmd_init_state.INIT_STATE_AUTOREFRESH2 ;
wire \Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ;
wire \Cmd_init_state.INIT_STATE_LOAD_MODEREG ;
wire \Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY ;
wire \Cmd_init_state.INIT_STATE_INIT_DONE ;
wire I_selfrefresh_reg;
wire \Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ;
wire \Cmd_fsm_state.SDRC_STATE_IDLE ;
wire \Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ;
wire \Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ;
wire \Cmd_fsm_state.SDRC_STATE_ACTIVE ;
wire \Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ;
wire \Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ;
wire \Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ;
wire \Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ;
wire \Cmd_fsm_state.SDRC_STATE_PRECHARGE ;
wire \Cmd_fsm_state.SDRC_STATE_INIT ;
wire \Cmd_fsm_state.SDRC_STATE_POWER_DOWN ;
wire \Cmd_fsm_state.SDRC_STATE_SELFREFRESH ;
wire \Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ;
wire \Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ;
wire \Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT ;
wire Flag_sdrc_wrd;
wire \Cmd_init_state.INIT_STATE_IDLE ;
wire Ctrl_wr_data_valid;
wire Reset_autorefresh;
wire Flag_autorefresh;
wire Flag_autorefresh0;
wire n509_1_SUM;
wire n509_3;
wire n510_1_SUM;
wire n510_3;
wire n511_1_SUM;
wire n511_3;
wire n512_1_SUM;
wire n512_3;
wire n513_1_SUM;
wire n513_3;
wire n514_1_SUM;
wire n514_3;
wire n515_1_SUM;
wire n515_3;
wire n516_1_SUM;
wire n516_3;
wire n529_1_SUM;
wire n529_3;
wire n530_1_SUM;
wire n530_3;
wire n531_1_SUM;
wire n531_3;
wire n532_1_SUM;
wire n532_3;
wire n533_1_SUM;
wire n533_3;
wire n534_1_SUM;
wire n534_3;
wire n535_1_SUM;
wire n535_3;
wire n536_1_SUM;
wire n536_3;
wire n962_8;
wire n341_7;
wire n10_6;
wire n156_6;
wire [3:0] Count_init_delay;
wire [3:0] Count_cmd_delay;
wire [1:0] Ctrl_fsm_addr_bk;
wire [10:0] Ctrl_fsm_addr_row;
wire [7:0] Ctrl_fsm_burst_num_i;
wire [3:0] Rd_data_valid_reg;
wire [7:0] Ctrl_fsm_addr_col;
wire [7:0] Count_burst_num_wr;
wire [7:0] Count_burst_num_rd;
wire VCC;
wire GND;
  LUT4 Reset_init_count_s1 (
    .F(Reset_init_count),
    .I0(\Cmd_init_state.INIT_STATE_LOAD_MODEREG ),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ),
    .I2(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ),
    .I3(\Cmd_init_state.INIT_STATE_PRECHARGEALL ) 
);
defparam Reset_init_count_s1.INIT=16'hFFFE;
  LUT2 n243_s0 (
    .F(n243_3),
    .I0(ctrl_fsm_wr_n),
    .I1(ctrl_fsm_rd_n) 
);
defparam n243_s0.INIT=4'h7;
  LUT4 Reset_cmd_count_s1 (
    .F(Reset_cmd_count),
    .I0(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ) 
);
defparam Reset_cmd_count_s1.INIT=16'hFFFE;
  LUT4 n272_s0 (
    .F(n272_3),
    .I0(ctrl_fsm_addr_col[7]),
    .I1(n272_4),
    .I2(Ctrl_fsm_addr_col[7]),
    .I3(n243_3) 
);
defparam n272_s0.INIT=16'hAA3C;
  LUT4 n273_s0 (
    .F(n273_3),
    .I0(ctrl_fsm_addr_col[6]),
    .I1(n273_4),
    .I2(Ctrl_fsm_addr_col[6]),
    .I3(n243_3) 
);
defparam n273_s0.INIT=16'hAA3C;
  LUT4 n274_s0 (
    .F(n274_3),
    .I0(ctrl_fsm_addr_col[5]),
    .I1(n274_4),
    .I2(Ctrl_fsm_addr_col[5]),
    .I3(n243_3) 
);
defparam n274_s0.INIT=16'hAA3C;
  LUT4 n275_s0 (
    .F(n275_3),
    .I0(ctrl_fsm_addr_col[4]),
    .I1(Ctrl_fsm_addr_col[4]),
    .I2(n275_4),
    .I3(n243_3) 
);
defparam n275_s0.INIT=16'hAA3C;
  LUT4 n276_s0 (
    .F(n276_3),
    .I0(ctrl_fsm_addr_col[3]),
    .I1(n276_4),
    .I2(Ctrl_fsm_addr_col[3]),
    .I3(n243_3) 
);
defparam n276_s0.INIT=16'hAA3C;
  LUT4 n277_s0 (
    .F(n277_3),
    .I0(ctrl_fsm_addr_col[2]),
    .I1(n277_4),
    .I2(Ctrl_fsm_addr_col[2]),
    .I3(n243_3) 
);
defparam n277_s0.INIT=16'hAA3C;
  LUT4 n278_s0 (
    .F(n278_3),
    .I0(ctrl_fsm_addr_col[1]),
    .I1(Ctrl_fsm_addr_col[0]),
    .I2(Ctrl_fsm_addr_col[1]),
    .I3(n243_3) 
);
defparam n278_s0.INIT=16'hAA3C;
  LUT3 n953_s0 (
    .F(n953_3),
    .I0(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ),
    .I2(n959_7) 
);
defparam n953_s0.INIT=8'hFE;
  LUT2 n956_s0 (
    .F(n956_3),
    .I0(\Cmd_init_state.INIT_STATE_PRECHARGEALL ),
    .I1(n959_7) 
);
defparam n956_s0.INIT=4'hE;
  LUT3 n962_s3 (
    .F(n962_7),
    .I0(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ),
    .I1(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ),
    .I2(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ) 
);
defparam n962_s3.INIT=8'h01;
  LUT2 O_ctrl_fsm_wrd_done_s3 (
    .F(O_ctrl_fsm_wrd_done_5),
    .I0(O_ctrl_fsm_wrd_done_6),
    .I1(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ) 
);
defparam O_ctrl_fsm_wrd_done_s3.INIT=4'hB;
  LUT2 n661_s5 (
    .F(n661_9),
    .I0(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ) 
);
defparam n661_s5.INIT=4'hE;
  LUT4 n927_s4 (
    .F(n927_8),
    .I0(Ctrl_fsm_addr_row[5]),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n927_15),
    .I3(n927_10) 
);
defparam n927_s4.INIT=16'hF8FF;
  LUT4 n930_s4 (
    .F(n930_8),
    .I0(Ctrl_fsm_addr_row[4]),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n930_11),
    .I3(n927_10) 
);
defparam n930_s4.INIT=16'hF8FF;
  LUT3 n955_s5 (
    .F(n955_10),
    .I0(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n955_s5.INIT=8'h10;
  LUT3 n961_s5 (
    .F(n961_10),
    .I0(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n958_11) 
);
defparam n961_s5.INIT=8'h10;
  LUT4 n964_s5 (
    .F(n964_10),
    .I0(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I1(Ctrl_wr_data_valid_13),
    .I2(Ctrl_fsm_addr_bk[1]),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n964_s5.INIT=16'hF100;
  LUT4 n966_s5 (
    .F(n966_10),
    .I0(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I1(Ctrl_wr_data_valid_13),
    .I2(Ctrl_fsm_addr_bk[0]),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n966_s5.INIT=16'hF100;
  LUT4 n968_s5 (
    .F(n968_10),
    .I0(Ctrl_fsm_addr_row[10]),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n927_10),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n968_s5.INIT=16'h8F00;
  LUT4 n970_s5 (
    .F(n970_10),
    .I0(Ctrl_fsm_addr_row[9]),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n927_10),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n970_s5.INIT=16'h8F00;
  LUT4 n972_s5 (
    .F(n972_10),
    .I0(Ctrl_fsm_addr_row[8]),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I2(n927_10),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n972_s5.INIT=16'h8F00;
  LUT3 n974_s5 (
    .F(n974_10),
    .I0(n927_10),
    .I1(n974_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n974_s5.INIT=8'h70;
  LUT3 n976_s5 (
    .F(n976_10),
    .I0(n927_10),
    .I1(n976_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n976_s5.INIT=8'h70;
  LUT3 n980_s5 (
    .F(n980_10),
    .I0(n927_10),
    .I1(n980_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n980_s5.INIT=8'h70;
  LUT3 n982_s5 (
    .F(n982_10),
    .I0(n927_10),
    .I1(n982_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n982_s5.INIT=8'h70;
  LUT3 n984_s5 (
    .F(n984_10),
    .I0(n927_10),
    .I1(n984_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n984_s5.INIT=8'h70;
  LUT3 n986_s5 (
    .F(n986_10),
    .I0(n927_10),
    .I1(n986_11),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n986_s5.INIT=8'h70;
  LUT4 n626_s6 (
    .F(n626_11),
    .I0(Count_burst_num_wr[6]),
    .I1(n626_12),
    .I2(Count_burst_num_wr[7]),
    .I3(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ) 
);
defparam n626_s6.INIT=16'h7800;
  LUT4 n630_s5 (
    .F(n630_9),
    .I0(Count_burst_num_wr[4]),
    .I1(n630_10),
    .I2(Count_burst_num_wr[5]),
    .I3(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ) 
);
defparam n630_s5.INIT=16'h7800;
  LUT4 n636_s5 (
    .F(n636_9),
    .I0(Count_burst_num_wr[0]),
    .I1(Count_burst_num_wr[1]),
    .I2(Count_burst_num_wr[2]),
    .I3(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ) 
);
defparam n636_s5.INIT=16'h7800;
  LUT4 n642_s6 (
    .F(n642_11),
    .I0(Count_burst_num_rd[6]),
    .I1(n642_12),
    .I2(Count_burst_num_rd[7]),
    .I3(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n642_s6.INIT=16'h7800;
  LUT4 n646_s5 (
    .F(n646_9),
    .I0(Count_burst_num_rd[4]),
    .I1(n646_10),
    .I2(Count_burst_num_rd[5]),
    .I3(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n646_s5.INIT=16'h7800;
  LUT4 n652_s5 (
    .F(n652_9),
    .I0(Count_burst_num_rd[0]),
    .I1(Count_burst_num_rd[1]),
    .I2(Count_burst_num_rd[2]),
    .I3(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n652_s5.INIT=16'h7800;
  LUT3 n95_s10 (
    .F(n95_14),
    .I0(n95_15),
    .I1(\Cmd_init_state.INIT_STATE_PRECHARGEALL ),
    .I2(\Cmd_init_state.INIT_STATE_IDLE ) 
);
defparam n95_s10.INIT=8'hF4;
  LUT4 n97_s10 (
    .F(n97_14),
    .I0(n959_4),
    .I1(n97_15),
    .I2(\Cmd_init_state.INIT_STATE_PRECHARGE_DELAY ),
    .I3(\Cmd_init_state.INIT_STATE_PRECHARGEALL ) 
);
defparam n97_s10.INIT=16'hFF70;
  LUT4 n99_s10 (
    .F(n99_14),
    .I0(n97_15),
    .I1(n95_15),
    .I2(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ),
    .I3(\Cmd_init_state.INIT_STATE_PRECHARGE_DELAY ) 
);
defparam n99_s10.INIT=16'hFA30;
  LUT4 n101_s10 (
    .F(n101_14),
    .I0(n959_5),
    .I1(n101_15),
    .I2(\Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ),
    .I3(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ) 
);
defparam n101_s10.INIT=16'hFF70;
  LUT4 n103_s10 (
    .F(n103_14),
    .I0(n101_15),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ),
    .I2(n95_15),
    .I3(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ) 
);
defparam n103_s10.INIT=16'h8F88;
  LUT4 n105_s10 (
    .F(n105_14),
    .I0(n959_5),
    .I1(n101_15),
    .I2(\Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ),
    .I3(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ) 
);
defparam n105_s10.INIT=16'hFF70;
  LUT4 n107_s10 (
    .F(n107_14),
    .I0(n101_15),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ),
    .I2(n95_15),
    .I3(\Cmd_init_state.INIT_STATE_LOAD_MODEREG ) 
);
defparam n107_s10.INIT=16'h8F88;
  LUT4 n109_s10 (
    .F(n109_14),
    .I0(n959_4),
    .I1(n97_15),
    .I2(\Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY ),
    .I3(\Cmd_init_state.INIT_STATE_LOAD_MODEREG ) 
);
defparam n109_s10.INIT=16'hFF70;
  LUT3 n111_s11 (
    .F(n111_15),
    .I0(\Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY ),
    .I1(n97_15),
    .I2(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n111_s11.INIT=8'hF8;
  LUT3 n593_s18 (
    .F(n593_22),
    .I0(n593_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ) 
);
defparam n593_s18.INIT=8'hF4;
  LUT4 n596_s19 (
    .F(n596_23),
    .I0(O_ctrl_fsm_wrd_done_6),
    .I1(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .I2(n596_24),
    .I3(n596_30) 
);
defparam n596_s19.INIT=16'hF8FF;
  LUT4 n598_s19 (
    .F(n598_23),
    .I0(n598_29),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .I2(n598_25),
    .I3(n598_26) 
);
defparam n598_s19.INIT=16'h4F44;
  LUT3 n600_s18 (
    .F(n600_22),
    .I0(n600_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ) 
);
defparam n600_s18.INIT=8'hF4;
  LUT4 n602_s18 (
    .F(n602_22),
    .I0(n243_3),
    .I1(n598_29),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Flag_sdrc_wrd_8) 
);
defparam n602_s18.INIT=16'hFA30;
  LUT3 n604_s18 (
    .F(n604_22),
    .I0(n593_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ) 
);
defparam n604_s18.INIT=8'hF4;
  LUT4 n606_s18 (
    .F(n606_22),
    .I0(n516_3),
    .I1(n600_23),
    .I2(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I3(n606_23) 
);
defparam n606_s18.INIT=16'hFFB0;
  LUT4 n608_s19 (
    .F(n608_23),
    .I0(n536_3),
    .I1(n600_23),
    .I2(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I3(n608_24) 
);
defparam n608_s19.INIT=16'hFFB0;
  LUT4 n610_s18 (
    .F(n610_22),
    .I0(n593_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ),
    .I2(n536_3),
    .I3(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ) 
);
defparam n610_s18.INIT=16'h4F44;
  LUT3 n612_s19 (
    .F(n612_23),
    .I0(n600_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .I2(n612_24) 
);
defparam n612_s19.INIT=8'h4F;
  LUT2 n614_s17 (
    .F(n614_21),
    .I0(n600_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_INIT ) 
);
defparam n614_s17.INIT=4'h4;
  LUT3 n616_s18 (
    .F(n616_22),
    .I0(n600_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ),
    .I2(n616_23) 
);
defparam n616_s18.INIT=8'hF4;
  LUT4 n618_s19 (
    .F(n618_23),
    .I0(n598_29),
    .I1(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ),
    .I2(n618_24),
    .I3(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n618_s19.INIT=16'hF444;
  LUT4 n620_s18 (
    .F(n620_22),
    .I0(I_selfrefresh_reg),
    .I1(n620_23),
    .I2(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ),
    .I3(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ) 
);
defparam n620_s18.INIT=16'hFFB0;
  LUT4 n622_s17 (
    .F(n622_21),
    .I0(n620_23),
    .I1(I_selfrefresh_reg),
    .I2(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ),
    .I3(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ) 
);
defparam n622_s17.INIT=16'hF530;
  LUT4 n624_s17 (
    .F(n624_21),
    .I0(n600_23),
    .I1(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT ),
    .I2(I_sdrc_power_down),
    .I3(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ) 
);
defparam n624_s17.INIT=16'h4F44;
  LUT2 n93_s10 (
    .F(n93_15),
    .I0(n95_15),
    .I1(\Cmd_init_state.INIT_STATE_IDLE ) 
);
defparam n93_s10.INIT=4'h4;
  LUT4 n705_s1 (
    .F(n705_5),
    .I0(I_sdrc_power_down),
    .I1(I_selfrefresh_reg),
    .I2(Flag_autorefresh0),
    .I3(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n705_s1.INIT=16'h0100;
  LUT3 O_autorefresh_ack_s4 (
    .F(O_autorefresh_ack_6),
    .I0(O_autorefresh_ack_7),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ) 
);
defparam O_autorefresh_ack_s4.INIT=8'hAC;
  LUT2 n9_s0 (
    .F(n9_4),
    .I0(Count_init_delay[0]),
    .I1(Count_init_delay[1]) 
);
defparam n9_s0.INIT=4'h6;
  LUT3 n8_s0 (
    .F(n8_4),
    .I0(Count_init_delay[0]),
    .I1(Count_init_delay[1]),
    .I2(Count_init_delay[2]) 
);
defparam n8_s0.INIT=8'h78;
  LUT4 n7_s0 (
    .F(n7_4),
    .I0(Count_init_delay[0]),
    .I1(Count_init_delay[1]),
    .I2(Count_init_delay[2]),
    .I3(Count_init_delay[3]) 
);
defparam n7_s0.INIT=16'h7F80;
  LUT2 n155_s0 (
    .F(n155_4),
    .I0(Count_cmd_delay[0]),
    .I1(Count_cmd_delay[1]) 
);
defparam n155_s0.INIT=4'h6;
  LUT3 n154_s0 (
    .F(n154_4),
    .I0(Count_cmd_delay[0]),
    .I1(Count_cmd_delay[1]),
    .I2(Count_cmd_delay[2]) 
);
defparam n154_s0.INIT=8'h78;
  LUT4 n153_s0 (
    .F(n153_4),
    .I0(Count_cmd_delay[0]),
    .I1(Count_cmd_delay[1]),
    .I2(Count_cmd_delay[2]),
    .I3(Count_cmd_delay[3]) 
);
defparam n153_s0.INIT=16'h7F80;
  LUT4 n272_s1 (
    .F(n272_4),
    .I0(Ctrl_fsm_addr_col[6]),
    .I1(Ctrl_fsm_addr_col[5]),
    .I2(Ctrl_fsm_addr_col[4]),
    .I3(n275_4) 
);
defparam n272_s1.INIT=16'h8000;
  LUT3 n273_s1 (
    .F(n273_4),
    .I0(Ctrl_fsm_addr_col[5]),
    .I1(Ctrl_fsm_addr_col[4]),
    .I2(n275_4) 
);
defparam n273_s1.INIT=8'h80;
  LUT2 n274_s1 (
    .F(n274_4),
    .I0(Ctrl_fsm_addr_col[4]),
    .I1(n275_4) 
);
defparam n274_s1.INIT=4'h8;
  LUT4 n275_s1 (
    .F(n275_4),
    .I0(Ctrl_fsm_addr_col[0]),
    .I1(Ctrl_fsm_addr_col[3]),
    .I2(Ctrl_fsm_addr_col[2]),
    .I3(Ctrl_fsm_addr_col[1]) 
);
defparam n275_s1.INIT=16'h8000;
  LUT3 n276_s1 (
    .F(n276_4),
    .I0(Ctrl_fsm_addr_col[0]),
    .I1(Ctrl_fsm_addr_col[2]),
    .I2(Ctrl_fsm_addr_col[1]) 
);
defparam n276_s1.INIT=8'h80;
  LUT2 n277_s1 (
    .F(n277_4),
    .I0(Ctrl_fsm_addr_col[0]),
    .I1(Ctrl_fsm_addr_col[1]) 
);
defparam n277_s1.INIT=4'h8;
  LUT2 n959_s1 (
    .F(n959_4),
    .I0(\Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ) 
);
defparam n959_s1.INIT=4'h1;
  LUT2 n959_s2 (
    .F(n959_5),
    .I0(\Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY ),
    .I1(\Cmd_init_state.INIT_STATE_PRECHARGE_DELAY ) 
);
defparam n959_s2.INIT=4'h1;
  LUT4 O_ctrl_fsm_wrd_done_s4 (
    .F(O_ctrl_fsm_wrd_done_6),
    .I0(Count_cmd_delay[0]),
    .I1(Count_cmd_delay[2]),
    .I2(Count_cmd_delay[3]),
    .I3(Count_cmd_delay[1]) 
);
defparam O_ctrl_fsm_wrd_done_s4.INIT=16'h0100;
  LUT3 Flag_sdrc_wrd_s4 (
    .F(Flag_sdrc_wrd_8),
    .I0(ctrl_double_wrd_flag),
    .I1(Flag_sdrc_wrd_9),
    .I2(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam Flag_sdrc_wrd_s4.INIT=8'hE0;
  LUT4 n927_s6 (
    .F(n927_10),
    .I0(\Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .I2(n927_11),
    .I3(n927_12) 
);
defparam n927_s6.INIT=16'h1000;
  LUT4 n958_s6 (
    .F(n958_11),
    .I0(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .I1(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ),
    .I2(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ),
    .I3(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
defparam n958_s6.INIT=16'h0100;
  LUT4 n974_s6 (
    .F(n974_11),
    .I0(Ctrl_fsm_addr_col[7]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[7]) 
);
defparam n974_s6.INIT=16'h0777;
  LUT4 n976_s6 (
    .F(n976_11),
    .I0(Ctrl_fsm_addr_col[6]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[6]) 
);
defparam n976_s6.INIT=16'h0777;
  LUT4 n980_s6 (
    .F(n980_11),
    .I0(Ctrl_fsm_addr_col[3]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[3]) 
);
defparam n980_s6.INIT=16'h0777;
  LUT4 n982_s6 (
    .F(n982_11),
    .I0(Ctrl_fsm_addr_col[2]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[2]) 
);
defparam n982_s6.INIT=16'h0777;
  LUT4 n984_s6 (
    .F(n984_11),
    .I0(Ctrl_fsm_addr_col[1]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[1]) 
);
defparam n984_s6.INIT=16'h0777;
  LUT4 n986_s6 (
    .F(n986_11),
    .I0(Ctrl_fsm_addr_col[0]),
    .I1(Ctrl_wr_data_valid_13),
    .I2(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .I3(Ctrl_fsm_addr_row[0]) 
);
defparam n986_s6.INIT=16'h0777;
  LUT3 n626_s7 (
    .F(n626_12),
    .I0(Count_burst_num_wr[4]),
    .I1(Count_burst_num_wr[5]),
    .I2(n630_10) 
);
defparam n626_s7.INIT=8'h80;
  LUT4 n630_s6 (
    .F(n630_10),
    .I0(Count_burst_num_wr[0]),
    .I1(Count_burst_num_wr[1]),
    .I2(Count_burst_num_wr[2]),
    .I3(Count_burst_num_wr[3]) 
);
defparam n630_s6.INIT=16'h8000;
  LUT3 n634_s6 (
    .F(n634_10),
    .I0(Count_burst_num_wr[0]),
    .I1(Count_burst_num_wr[1]),
    .I2(Count_burst_num_wr[2]) 
);
defparam n634_s6.INIT=8'h80;
  LUT3 n642_s7 (
    .F(n642_12),
    .I0(Count_burst_num_rd[4]),
    .I1(Count_burst_num_rd[5]),
    .I2(n646_10) 
);
defparam n642_s7.INIT=8'h80;
  LUT4 n646_s6 (
    .F(n646_10),
    .I0(Count_burst_num_rd[0]),
    .I1(Count_burst_num_rd[1]),
    .I2(Count_burst_num_rd[2]),
    .I3(Count_burst_num_rd[3]) 
);
defparam n646_s6.INIT=16'h8000;
  LUT3 n650_s6 (
    .F(n650_10),
    .I0(Count_burst_num_rd[0]),
    .I1(Count_burst_num_rd[1]),
    .I2(Count_burst_num_rd[2]) 
);
defparam n650_s6.INIT=8'h80;
  LUT4 n95_s11 (
    .F(n95_15),
    .I0(n959_5),
    .I1(n97_15),
    .I2(n959_4),
    .I3(n101_15) 
);
defparam n95_s11.INIT=16'hEEE0;
  LUT4 n97_s11 (
    .F(n97_15),
    .I0(Count_init_delay[0]),
    .I1(Count_init_delay[2]),
    .I2(Count_init_delay[3]),
    .I3(Count_init_delay[1]) 
);
defparam n97_s11.INIT=16'h0100;
  LUT4 n101_s11 (
    .F(n101_15),
    .I0(Count_init_delay[0]),
    .I1(Count_init_delay[1]),
    .I2(Count_init_delay[2]),
    .I3(Count_init_delay[3]) 
);
defparam n101_s11.INIT=16'h0100;
  LUT3 n593_s19 (
    .F(n593_23),
    .I0(O_ctrl_fsm_wrd_done_6),
    .I1(n593_24),
    .I2(n593_27) 
);
defparam n593_s19.INIT=8'h80;
  LUT4 n596_s20 (
    .F(n596_24),
    .I0(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .I1(\Cmd_fsm_state.SDRC_STATE_INIT ),
    .I2(n596_26),
    .I3(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n596_s20.INIT=16'hEF00;
  LUT4 n598_s21 (
    .F(n598_25),
    .I0(ctrl_double_wrd_flag),
    .I1(Flag_autorefresh),
    .I2(n243_3),
    .I3(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ) 
);
defparam n598_s21.INIT=16'hB0BB;
  LUT4 n598_s22 (
    .F(n598_26),
    .I0(I_sdrc_power_down),
    .I1(I_selfrefresh_reg),
    .I2(ctrl_double_wrd_flag),
    .I3(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n598_s22.INIT=16'hF100;
  LUT4 n600_s19 (
    .F(n600_23),
    .I0(Flag_sdrc_wrd_8),
    .I1(n243_3),
    .I2(n598_27),
    .I3(n596_26) 
);
defparam n600_s19.INIT=16'hD000;
  LUT3 n606_s19 (
    .F(n606_23),
    .I0(Flag_sdrc_wrd),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .I2(O_ctrl_fsm_wrd_done_6) 
);
defparam n606_s19.INIT=8'h40;
  LUT3 n608_s20 (
    .F(n608_24),
    .I0(Flag_sdrc_wrd),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .I2(O_ctrl_fsm_wrd_done_6) 
);
defparam n608_s20.INIT=8'h80;
  LUT4 n612_s20 (
    .F(n612_24),
    .I0(\Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ),
    .I1(O_ctrl_fsm_wrd_done_6),
    .I2(n516_3),
    .I3(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n612_s20.INIT=16'h7077;
  LUT3 n616_s19 (
    .F(n616_23),
    .I0(ctrl_double_wrd_flag),
    .I1(I_sdrc_power_down),
    .I2(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n616_s19.INIT=8'h40;
  LUT4 n618_s20 (
    .F(n618_24),
    .I0(I_selfrefresh_reg),
    .I1(n618_25),
    .I2(I_sdrc_power_down),
    .I3(ctrl_double_wrd_flag) 
);
defparam n618_s20.INIT=16'hCC0E;
  LUT4 n620_s19 (
    .F(n620_23),
    .I0(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ),
    .I1(I_sdrc_power_down),
    .I2(n620_24),
    .I3(n593_27) 
);
defparam n620_s19.INIT=16'h0700;
  LUT4 O_autorefresh_ack_s5 (
    .F(O_autorefresh_ack_7),
    .I0(Count_cmd_delay[1]),
    .I1(Count_cmd_delay[2]),
    .I2(Count_cmd_delay[0]),
    .I3(Count_cmd_delay[3]) 
);
defparam O_autorefresh_ack_s5.INIT=16'h1000;
  LUT3 Flag_sdrc_wrd_s5 (
    .F(Flag_sdrc_wrd_9),
    .I0(I_sdrc_power_down),
    .I1(I_selfrefresh_reg),
    .I2(Flag_autorefresh) 
);
defparam Flag_sdrc_wrd_s5.INIT=8'h01;
  LUT3 n927_s7 (
    .F(n927_11),
    .I0(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_INIT ) 
);
defparam n927_s7.INIT=8'h01;
  LUT4 n927_s8 (
    .F(n927_12),
    .I0(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .I2(n927_13),
    .I3(n962_7) 
);
defparam n927_s8.INIT=16'h1000;
  LUT4 n593_s20 (
    .F(n593_24),
    .I0(I_selfrefresh_reg),
    .I1(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ),
    .I2(I_sdrc_power_down),
    .I3(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ) 
);
defparam n593_s20.INIT=16'h0777;
  LUT2 n596_s22 (
    .F(n596_26),
    .I0(n620_24),
    .I1(n593_24) 
);
defparam n596_s22.INIT=4'h4;
  LUT4 n596_s23 (
    .F(n596_27),
    .I0(O_autorefresh_ack_7),
    .I1(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ),
    .I3(n596_28) 
);
defparam n596_s23.INIT=16'h0700;
  LUT4 n598_s23 (
    .F(n598_27),
    .I0(ctrl_fsm_init),
    .I1(\Cmd_fsm_state.SDRC_STATE_INIT ),
    .I2(O_autorefresh_ack_7),
    .I3(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ) 
);
defparam n598_s23.INIT=16'hB0BB;
  LUT4 n618_s21 (
    .F(n618_25),
    .I0(Flag_autorefresh),
    .I1(ctrl_double_wrd_flag),
    .I2(n243_3),
    .I3(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ) 
);
defparam n618_s21.INIT=16'h0D00;
  LUT4 n620_s20 (
    .F(n620_24),
    .I0(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .I1(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .I2(\Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ),
    .I3(O_ctrl_fsm_wrd_done_6) 
);
defparam n620_s20.INIT=16'h00FE;
  LUT3 n927_s9 (
    .F(n927_13),
    .I0(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ),
    .I2(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT ) 
);
defparam n927_s9.INIT=8'h01;
  LUT3 n596_s24 (
    .F(n596_28),
    .I0(ctrl_fsm_init),
    .I1(\Cmd_fsm_state.SDRC_STATE_INIT ),
    .I2(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT ) 
);
defparam n596_s24.INIT=8'h07;
  LUT3 n598_s24 (
    .F(n598_29),
    .I0(n598_27),
    .I1(n620_24),
    .I2(n593_24) 
);
defparam n598_s24.INIT=8'h20;
  LUT4 n959_s3 (
    .F(n959_7),
    .I0(\Cmd_init_state.INIT_STATE_IDLE ),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ),
    .I2(\Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ),
    .I3(n959_5) 
);
defparam n959_s3.INIT=16'hFEFF;
  LUT4 Flag_sdrc_wrd_s6 (
    .F(Flag_sdrc_wrd_11),
    .I0(n243_3),
    .I1(ctrl_double_wrd_flag),
    .I2(Flag_sdrc_wrd_9),
    .I3(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam Flag_sdrc_wrd_s6.INIT=16'hA800;
  LUT3 n930_s6 (
    .F(n930_11),
    .I0(Ctrl_fsm_addr_col[4]),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n930_s6.INIT=8'hA8;
  LUT3 n927_s10 (
    .F(n927_15),
    .I0(Ctrl_fsm_addr_col[5]),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam n927_s10.INIT=8'hA8;
  LUT3 n958_s7 (
    .F(n958_13),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I2(n958_11) 
);
defparam n958_s7.INIT=8'h10;
  LUT4 Ctrl_fsm_addr_col_7_s5 (
    .F(Ctrl_fsm_addr_col_7_12),
    .I0(ctrl_fsm_wr_n),
    .I1(ctrl_fsm_rd_n),
    .I2(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I3(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam Ctrl_fsm_addr_col_7_s5.INIT=16'hFFF7;
  LUT4 n593_s22 (
    .F(n593_27),
    .I0(Flag_sdrc_wrd_8),
    .I1(ctrl_fsm_wr_n),
    .I2(ctrl_fsm_rd_n),
    .I3(n598_27) 
);
defparam n593_s22.INIT=16'h7F00;
  LUT4 n596_s25 (
    .F(n596_30),
    .I0(Flag_sdrc_wrd_8),
    .I1(ctrl_fsm_wr_n),
    .I2(ctrl_fsm_rd_n),
    .I3(n596_27) 
);
defparam n596_s25.INIT=16'h7F00;
  LUT4 n279_s1 (
    .F(n279_5),
    .I0(ctrl_fsm_addr_col[0]),
    .I1(Ctrl_fsm_addr_col[0]),
    .I2(ctrl_fsm_wr_n),
    .I3(ctrl_fsm_rd_n) 
);
defparam n279_s1.INIT=16'h3AAA;
  LUT3 n132_s5 (
    .F(n132_10),
    .I0(Flag_autorefresh),
    .I1(Reset_autorefresh),
    .I2(autorefresh_req) 
);
defparam n132_s5.INIT=8'h32;
  LUT3 n132_s7 (
    .F(n132_14),
    .I0(Reset_autorefresh),
    .I1(Flag_autorefresh0),
    .I2(autorefresh_req_a) 
);
defparam n132_s7.INIT=8'h54;
  LUT2 Ctrl_wr_data_valid_s4 (
    .F(Ctrl_wr_data_valid_13),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ) 
);
defparam Ctrl_wr_data_valid_s4.INIT=4'hE;
  LUT3 n628_s8 (
    .F(n628_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_wr[6]),
    .I2(n626_12) 
);
defparam n628_s8.INIT=8'h28;
  LUT2 n626_s8 (
    .F(n626_18),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n626_s8.INIT=4'hE;
  LUT3 n632_s8 (
    .F(n632_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_wr[4]),
    .I2(n630_10) 
);
defparam n632_s8.INIT=8'h28;
  LUT3 n634_s9 (
    .F(n634_15),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_wr[3]),
    .I2(n634_10) 
);
defparam n634_s9.INIT=8'h28;
  LUT3 n638_s8 (
    .F(n638_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_wr[1]),
    .I2(Count_burst_num_wr[0]) 
);
defparam n638_s8.INIT=8'h28;
  LUT3 n640_s7 (
    .F(n640_12),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(Count_burst_num_wr[0]) 
);
defparam n640_s7.INIT=8'h1A;
  LUT3 n644_s8 (
    .F(n644_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_rd[6]),
    .I2(n642_12) 
);
defparam n644_s8.INIT=8'h28;
  LUT2 n642_s8 (
    .F(n642_18),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ) 
);
defparam n642_s8.INIT=4'hE;
  LUT3 n648_s8 (
    .F(n648_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_rd[4]),
    .I2(n646_10) 
);
defparam n648_s8.INIT=8'h28;
  LUT3 n650_s9 (
    .F(n650_15),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_rd[3]),
    .I2(n650_10) 
);
defparam n650_s9.INIT=8'h28;
  LUT3 n654_s8 (
    .F(n654_14),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(Count_burst_num_rd[1]),
    .I2(Count_burst_num_rd[0]) 
);
defparam n654_s8.INIT=8'h28;
  LUT3 n656_s7 (
    .F(n656_12),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(Count_burst_num_rd[0]) 
);
defparam n656_s7.INIT=8'h1A;
  LUT4 n856_s5 (
    .F(n856_12),
    .I0(Ctrl_wr_data_valid_13),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(ctrl_fsm_dqm[3]),
    .I3(O_sdram_dqm[3]) 
);
defparam n856_s5.INIT=16'hD5C0;
  LUT4 n857_s5 (
    .F(n857_12),
    .I0(Ctrl_wr_data_valid_13),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(ctrl_fsm_dqm[2]),
    .I3(O_sdram_dqm[2]) 
);
defparam n857_s5.INIT=16'hD5C0;
  LUT4 n858_s5 (
    .F(n858_12),
    .I0(Ctrl_wr_data_valid_13),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(ctrl_fsm_dqm[1]),
    .I3(O_sdram_dqm[1]) 
);
defparam n858_s5.INIT=16'hD5C0;
  LUT4 n859_s5 (
    .F(n859_12),
    .I0(Ctrl_wr_data_valid_13),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(ctrl_fsm_dqm[0]),
    .I3(O_sdram_dqm[0]) 
);
defparam n859_s5.INIT=16'hD5C0;
  LUT4 n963_s1 (
    .F(n963_5),
    .I0(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ),
    .I1(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ),
    .I2(\Cmd_init_state.INIT_STATE_PRECHARGEALL ),
    .I3(n959_7) 
);
defparam n963_s1.INIT=16'hFFFE;
  LUT4 n638_s9 (
    .F(n638_16),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n638_14),
    .I3(Count_burst_num_wr[1]) 
);
defparam n638_s9.INIT=16'hF1F0;
  LUT4 n634_s10 (
    .F(n634_17),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n634_15),
    .I3(Count_burst_num_wr[3]) 
);
defparam n634_s10.INIT=16'hF1F0;
  LUT4 n632_s9 (
    .F(n632_16),
    .I0(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n632_14),
    .I3(Count_burst_num_wr[4]) 
);
defparam n632_s9.INIT=16'hF1F0;
  LUT4 n628_s9 (
    .F(n628_16),
    .I0(n628_14),
    .I1(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I3(Count_burst_num_wr[6]) 
);
defparam n628_s9.INIT=16'hABAA;
  LUT4 n654_s9 (
    .F(n654_16),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n654_14),
    .I3(Count_burst_num_rd[1]) 
);
defparam n654_s9.INIT=16'hF1F0;
  LUT4 n650_s10 (
    .F(n650_17),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n650_15),
    .I3(Count_burst_num_rd[3]) 
);
defparam n650_s10.INIT=16'hF1F0;
  LUT4 n648_s9 (
    .F(n648_16),
    .I0(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I1(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I2(n648_14),
    .I3(Count_burst_num_rd[4]) 
);
defparam n648_s9.INIT=16'hF1F0;
  LUT4 n644_s9 (
    .F(n644_16),
    .I0(n644_14),
    .I1(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .I2(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .I3(Count_burst_num_rd[6]) 
);
defparam n644_s9.INIT=16'hABAA;
  DFFR Count_init_delay_2_s0 (
    .Q(Count_init_delay[2]),
    .D(n8_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_init_count) 
);
  DFFR Count_init_delay_1_s0 (
    .Q(Count_init_delay[1]),
    .D(n9_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_init_count) 
);
  DFFR Count_init_delay_0_s0 (
    .Q(Count_init_delay[0]),
    .D(n10_6),
    .CLK(I_sdrc_clk),
    .RESET(Reset_init_count) 
);
  DFFC \Cmd_init_state.INIT_STATE_PRECHARGEALL_s0  (
    .Q(\Cmd_init_state.INIT_STATE_PRECHARGEALL ),
    .D(n95_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_PRECHARGE_DELAY_s0  (
    .Q(\Cmd_init_state.INIT_STATE_PRECHARGE_DELAY ),
    .D(n97_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_AUTOREFRESH1_s0  (
    .Q(\Cmd_init_state.INIT_STATE_AUTOREFRESH1 ),
    .D(n99_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY_s0  (
    .Q(\Cmd_init_state.INIT_STATE_AUTOREFRESH1_DELAY ),
    .D(n101_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_AUTOREFRESH2_s0  (
    .Q(\Cmd_init_state.INIT_STATE_AUTOREFRESH2 ),
    .D(n103_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY_s0  (
    .Q(\Cmd_init_state.INIT_STATE_AUTOREFRESH2_DELAY ),
    .D(n105_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_LOAD_MODEREG_s0  (
    .Q(\Cmd_init_state.INIT_STATE_LOAD_MODEREG ),
    .D(n107_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY_s0  (
    .Q(\Cmd_init_state.INIT_STATE_LOAD_MODEREG_DELAY ),
    .D(n109_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_init_state.INIT_STATE_INIT_DONE_s0  (
    .Q(\Cmd_init_state.INIT_STATE_INIT_DONE ),
    .D(n111_15),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Flag_init_done_s0 (
    .Q(ctrl_fsm_init),
    .D(\Cmd_init_state.INIT_STATE_INIT_DONE ),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFR Count_cmd_delay_3_s0 (
    .Q(Count_cmd_delay[3]),
    .D(n153_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_cmd_count) 
);
  DFFR Count_cmd_delay_2_s0 (
    .Q(Count_cmd_delay[2]),
    .D(n154_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_cmd_count) 
);
  DFFR Count_cmd_delay_1_s0 (
    .Q(Count_cmd_delay[1]),
    .D(n155_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_cmd_count) 
);
  DFFS Count_cmd_delay_0_s0 (
    .Q(Count_cmd_delay[0]),
    .D(n156_6),
    .CLK(I_sdrc_clk),
    .SET(Reset_cmd_count) 
);
  DFF Ctrl_fsm_data_31_s0 (
    .Q(Ctrl_fsm_data[31]),
    .D(ctrl_fsm_data0[31]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_30_s0 (
    .Q(Ctrl_fsm_data[30]),
    .D(ctrl_fsm_data0[30]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_29_s0 (
    .Q(Ctrl_fsm_data[29]),
    .D(ctrl_fsm_data0[29]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_28_s0 (
    .Q(Ctrl_fsm_data[28]),
    .D(ctrl_fsm_data0[28]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_27_s0 (
    .Q(Ctrl_fsm_data[27]),
    .D(ctrl_fsm_data0[27]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_26_s0 (
    .Q(Ctrl_fsm_data[26]),
    .D(ctrl_fsm_data0[26]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_25_s0 (
    .Q(Ctrl_fsm_data[25]),
    .D(ctrl_fsm_data0[25]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_24_s0 (
    .Q(Ctrl_fsm_data[24]),
    .D(ctrl_fsm_data0[24]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_23_s0 (
    .Q(Ctrl_fsm_data[23]),
    .D(ctrl_fsm_data0[23]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_22_s0 (
    .Q(Ctrl_fsm_data[22]),
    .D(ctrl_fsm_data0[22]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_21_s0 (
    .Q(Ctrl_fsm_data[21]),
    .D(ctrl_fsm_data0[21]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_20_s0 (
    .Q(Ctrl_fsm_data[20]),
    .D(ctrl_fsm_data0[20]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_19_s0 (
    .Q(Ctrl_fsm_data[19]),
    .D(ctrl_fsm_data0[19]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_18_s0 (
    .Q(Ctrl_fsm_data[18]),
    .D(ctrl_fsm_data0[18]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_17_s0 (
    .Q(Ctrl_fsm_data[17]),
    .D(ctrl_fsm_data0[17]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_16_s0 (
    .Q(Ctrl_fsm_data[16]),
    .D(ctrl_fsm_data0[16]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_15_s0 (
    .Q(Ctrl_fsm_data[15]),
    .D(ctrl_fsm_data0[15]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_14_s0 (
    .Q(Ctrl_fsm_data[14]),
    .D(ctrl_fsm_data0[14]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_13_s0 (
    .Q(Ctrl_fsm_data[13]),
    .D(ctrl_fsm_data0[13]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_12_s0 (
    .Q(Ctrl_fsm_data[12]),
    .D(ctrl_fsm_data0[12]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_11_s0 (
    .Q(Ctrl_fsm_data[11]),
    .D(ctrl_fsm_data0[11]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_10_s0 (
    .Q(Ctrl_fsm_data[10]),
    .D(ctrl_fsm_data0[10]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_9_s0 (
    .Q(Ctrl_fsm_data[9]),
    .D(ctrl_fsm_data0[9]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_8_s0 (
    .Q(Ctrl_fsm_data[8]),
    .D(ctrl_fsm_data0[8]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_7_s0 (
    .Q(Ctrl_fsm_data[7]),
    .D(ctrl_fsm_data0[7]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_6_s0 (
    .Q(Ctrl_fsm_data[6]),
    .D(ctrl_fsm_data0[6]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_5_s0 (
    .Q(Ctrl_fsm_data[5]),
    .D(ctrl_fsm_data0[5]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_4_s0 (
    .Q(Ctrl_fsm_data[4]),
    .D(ctrl_fsm_data0[4]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_3_s0 (
    .Q(Ctrl_fsm_data[3]),
    .D(ctrl_fsm_data0[3]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_2_s0 (
    .Q(Ctrl_fsm_data[2]),
    .D(ctrl_fsm_data0[2]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_1_s0 (
    .Q(Ctrl_fsm_data[1]),
    .D(ctrl_fsm_data0[1]),
    .CLK(I_sdrc_clk) 
);
  DFF Ctrl_fsm_data_0_s0 (
    .Q(Ctrl_fsm_data[0]),
    .D(ctrl_fsm_data0[0]),
    .CLK(I_sdrc_clk) 
);
  DFFE Ctrl_fsm_addr_bk_1_s0 (
    .Q(Ctrl_fsm_addr_bk[1]),
    .D(ctrl_fsm_addr_bk[1]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_bk_0_s0 (
    .Q(Ctrl_fsm_addr_bk[0]),
    .D(ctrl_fsm_addr_bk[0]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_10_s0 (
    .Q(Ctrl_fsm_addr_row[10]),
    .D(ctrl_fsm_addr_row[10]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_9_s0 (
    .Q(Ctrl_fsm_addr_row[9]),
    .D(ctrl_fsm_addr_row[9]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_8_s0 (
    .Q(Ctrl_fsm_addr_row[8]),
    .D(ctrl_fsm_addr_row[8]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_7_s0 (
    .Q(Ctrl_fsm_addr_row[7]),
    .D(ctrl_fsm_addr_row[7]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_6_s0 (
    .Q(Ctrl_fsm_addr_row[6]),
    .D(ctrl_fsm_addr_row[6]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_5_s0 (
    .Q(Ctrl_fsm_addr_row[5]),
    .D(ctrl_fsm_addr_row[5]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_4_s0 (
    .Q(Ctrl_fsm_addr_row[4]),
    .D(ctrl_fsm_addr_row[4]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_3_s0 (
    .Q(Ctrl_fsm_addr_row[3]),
    .D(ctrl_fsm_addr_row[3]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_2_s0 (
    .Q(Ctrl_fsm_addr_row[2]),
    .D(ctrl_fsm_addr_row[2]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_1_s0 (
    .Q(Ctrl_fsm_addr_row[1]),
    .D(ctrl_fsm_addr_row[1]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_addr_row_0_s0 (
    .Q(Ctrl_fsm_addr_row[0]),
    .D(ctrl_fsm_addr_row[0]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_7_s0 (
    .Q(Ctrl_fsm_burst_num_i[7]),
    .D(ctrl_fsm_data_len[7]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_6_s0 (
    .Q(Ctrl_fsm_burst_num_i[6]),
    .D(ctrl_fsm_data_len[6]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_5_s0 (
    .Q(Ctrl_fsm_burst_num_i[5]),
    .D(ctrl_fsm_data_len[5]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_4_s0 (
    .Q(Ctrl_fsm_burst_num_i[4]),
    .D(ctrl_fsm_data_len[4]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_3_s0 (
    .Q(Ctrl_fsm_burst_num_i[3]),
    .D(ctrl_fsm_data_len[3]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_2_s0 (
    .Q(Ctrl_fsm_burst_num_i[2]),
    .D(ctrl_fsm_data_len[2]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_1_s0 (
    .Q(Ctrl_fsm_burst_num_i[1]),
    .D(ctrl_fsm_data_len[1]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFFE Ctrl_fsm_burst_num_i_0_s0 (
    .Q(Ctrl_fsm_burst_num_i[0]),
    .D(ctrl_fsm_data_len[0]),
    .CLK(I_sdrc_clk),
    .CE(n243_3) 
);
  DFF I_selfrefresh_reg_s0 (
    .Q(I_selfrefresh_reg),
    .D(I_sdrc_selfrefresh),
    .CLK(I_sdrc_clk) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .D(n593_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_IDLE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_IDLE ),
    .D(n596_23),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .D(n598_23),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .D(n600_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_ACTIVE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_ACTIVE ),
    .D(n602_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_ACTIVE2RW_DELAY ),
    .D(n604_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .D(n606_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .D(n608_23),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_DATAIN2ACTIVE ),
    .D(n610_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_PRECHARGE_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_PRECHARGE ),
    .D(n612_23),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFP \Cmd_fsm_state.SDRC_STATE_INIT_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_INIT ),
    .D(n614_21),
    .CLK(I_sdrc_clk),
    .PRESET(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_POWER_DOWN_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN ),
    .D(n616_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_SELFREFRESH_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH ),
    .D(n618_23),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_WAIT ),
    .D(n620_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_SELFREFRESH_EXIT ),
    .D(n622_21),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC \Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT_s0  (
    .Q(\Cmd_fsm_state.SDRC_STATE_POWER_DOWN_EXIT ),
    .D(n624_21),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFCE Flag_sdrc_wrd_s0 (
    .Q(Flag_sdrc_wrd),
    .D(n341_7),
    .CLK(I_sdrc_clk),
    .CE(Flag_sdrc_wrd_11),
    .CLEAR(n316_6) 
);
  DFFC O_ctrl_fsm_busy_n_s0 (
    .Q(ctrl_fsm_busy_n),
    .D(n705_5),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFR O_ctrl_fsm_data_31_s0 (
    .Q(ctrl_fsm_data1[31]),
    .D(IO_sdram_dq_in[31]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_30_s0 (
    .Q(ctrl_fsm_data1[30]),
    .D(IO_sdram_dq_in[30]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_29_s0 (
    .Q(ctrl_fsm_data1[29]),
    .D(IO_sdram_dq_in[29]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_28_s0 (
    .Q(ctrl_fsm_data1[28]),
    .D(IO_sdram_dq_in[28]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_27_s0 (
    .Q(ctrl_fsm_data1[27]),
    .D(IO_sdram_dq_in[27]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_26_s0 (
    .Q(ctrl_fsm_data1[26]),
    .D(IO_sdram_dq_in[26]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_25_s0 (
    .Q(ctrl_fsm_data1[25]),
    .D(IO_sdram_dq_in[25]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_24_s0 (
    .Q(ctrl_fsm_data1[24]),
    .D(IO_sdram_dq_in[24]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_23_s0 (
    .Q(ctrl_fsm_data1[23]),
    .D(IO_sdram_dq_in[23]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_22_s0 (
    .Q(ctrl_fsm_data1[22]),
    .D(IO_sdram_dq_in[22]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_21_s0 (
    .Q(ctrl_fsm_data1[21]),
    .D(IO_sdram_dq_in[21]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_20_s0 (
    .Q(ctrl_fsm_data1[20]),
    .D(IO_sdram_dq_in[20]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_19_s0 (
    .Q(ctrl_fsm_data1[19]),
    .D(IO_sdram_dq_in[19]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_18_s0 (
    .Q(ctrl_fsm_data1[18]),
    .D(IO_sdram_dq_in[18]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_17_s0 (
    .Q(ctrl_fsm_data1[17]),
    .D(IO_sdram_dq_in[17]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_16_s0 (
    .Q(ctrl_fsm_data1[16]),
    .D(IO_sdram_dq_in[16]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_15_s0 (
    .Q(ctrl_fsm_data1[15]),
    .D(IO_sdram_dq_in[15]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_14_s0 (
    .Q(ctrl_fsm_data1[14]),
    .D(IO_sdram_dq_in[14]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_13_s0 (
    .Q(ctrl_fsm_data1[13]),
    .D(IO_sdram_dq_in[13]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_12_s0 (
    .Q(ctrl_fsm_data1[12]),
    .D(IO_sdram_dq_in[12]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_11_s0 (
    .Q(ctrl_fsm_data1[11]),
    .D(IO_sdram_dq_in[11]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_10_s0 (
    .Q(ctrl_fsm_data1[10]),
    .D(IO_sdram_dq_in[10]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_9_s0 (
    .Q(ctrl_fsm_data1[9]),
    .D(IO_sdram_dq_in[9]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_8_s0 (
    .Q(ctrl_fsm_data1[8]),
    .D(IO_sdram_dq_in[8]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_7_s0 (
    .Q(ctrl_fsm_data1[7]),
    .D(IO_sdram_dq_in[7]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_6_s0 (
    .Q(ctrl_fsm_data1[6]),
    .D(IO_sdram_dq_in[6]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_5_s0 (
    .Q(ctrl_fsm_data1[5]),
    .D(IO_sdram_dq_in[5]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_4_s0 (
    .Q(ctrl_fsm_data1[4]),
    .D(IO_sdram_dq_in[4]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_3_s0 (
    .Q(ctrl_fsm_data1[3]),
    .D(IO_sdram_dq_in[3]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_2_s0 (
    .Q(ctrl_fsm_data1[2]),
    .D(IO_sdram_dq_in[2]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_1_s0 (
    .Q(ctrl_fsm_data1[1]),
    .D(IO_sdram_dq_in[1]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFR O_ctrl_fsm_data_0_s0 (
    .Q(ctrl_fsm_data1[0]),
    .D(IO_sdram_dq_in[0]),
    .CLK(I_sdrc_clk),
    .RESET(Ctrl_wr_data_valid) 
);
  DFFC Ctrl_rd_data_valid_s0 (
    .Q(ctrl_fsm_data_valid),
    .D(Rd_data_valid_reg[3]),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Rd_data_valid_reg_3_s0 (
    .Q(Rd_data_valid_reg[3]),
    .D(Rd_data_valid_reg[2]),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Rd_data_valid_reg_2_s0 (
    .Q(Rd_data_valid_reg[2]),
    .D(Rd_data_valid_reg[1]),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Rd_data_valid_reg_1_s0 (
    .Q(Rd_data_valid_reg[1]),
    .D(Rd_data_valid_reg[0]),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Rd_data_valid_reg_0_s0 (
    .Q(Rd_data_valid_reg[0]),
    .D(\Cmd_fsm_state.SDRC_STATE_READ_WITHOUT_AUTOPRE ),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFS O_sdram_cke_s0 (
    .Q(O_sdram_cke),
    .D(n962_7),
    .CLK(I_sdrc_clk),
    .SET(n962_8) 
);
  DFFS O_sdram_addr_5_s0 (
    .Q(O_sdram_addr[5]),
    .D(n927_8),
    .CLK(I_sdrc_clk),
    .SET(n962_8) 
);
  DFFS O_sdram_addr_4_s0 (
    .Q(O_sdram_addr[4]),
    .D(n930_8),
    .CLK(I_sdrc_clk),
    .SET(n962_8) 
);
  DFFR Count_init_delay_3_s0 (
    .Q(Count_init_delay[3]),
    .D(n7_4),
    .CLK(I_sdrc_clk),
    .RESET(Reset_init_count) 
);
  DFFP \Cmd_init_state.INIT_STATE_IDLE_s0  (
    .Q(\Cmd_init_state.INIT_STATE_IDLE ),
    .D(n93_15),
    .CLK(I_sdrc_clk),
    .PRESET(n316_6) 
);
  DFFCE O_ctrl_fsm_wrd_done_s1 (
    .Q(ctrl_fsm_wrd_done),
    .D(\Cmd_fsm_state.SDRC_STATE_PRECHARGE_DELAY ),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_wrd_done_5),
    .CLEAR(n316_6) 
);
defparam O_ctrl_fsm_wrd_done_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_7_s1 (
    .Q(Ctrl_fsm_addr_col[7]),
    .D(n272_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_7_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_6_s1 (
    .Q(Ctrl_fsm_addr_col[6]),
    .D(n273_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_6_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_5_s1 (
    .Q(Ctrl_fsm_addr_col[5]),
    .D(n274_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_5_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_4_s1 (
    .Q(Ctrl_fsm_addr_col[4]),
    .D(n275_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_4_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_3_s1 (
    .Q(Ctrl_fsm_addr_col[3]),
    .D(n276_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_3_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_2_s1 (
    .Q(Ctrl_fsm_addr_col[2]),
    .D(n277_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_2_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_1_s1 (
    .Q(Ctrl_fsm_addr_col[1]),
    .D(n278_3),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_1_s1.INIT=1'b0;
  DFFE Ctrl_fsm_addr_col_0_s1 (
    .Q(Ctrl_fsm_addr_col[0]),
    .D(n279_5),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_fsm_addr_col_7_12) 
);
defparam Ctrl_fsm_addr_col_0_s1.INIT=1'b0;
  DFFCE Ctrl_wr_data_valid_s1 (
    .Q(Ctrl_wr_data_valid),
    .D(\Cmd_fsm_state.SDRC_STATE_WRITE_WITHOUT_AUTOPRE ),
    .CLK(I_sdrc_clk),
    .CE(Ctrl_wr_data_valid_13),
    .CLEAR(n316_6) 
);
defparam Ctrl_wr_data_valid_s1.INIT=1'b0;
  DFFCE Reset_autorefresh_s1 (
    .Q(Reset_autorefresh),
    .D(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH ),
    .CLK(I_sdrc_clk),
    .CE(n661_9),
    .CLEAR(n316_6) 
);
defparam Reset_autorefresh_s1.INIT=1'b0;
  DFFCE Count_burst_num_wr_7_s1 (
    .Q(Count_burst_num_wr[7]),
    .D(n626_11),
    .CLK(I_sdrc_clk),
    .CE(n626_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_7_s1.INIT=1'b0;
  DFFCE Count_burst_num_wr_5_s1 (
    .Q(Count_burst_num_wr[5]),
    .D(n630_9),
    .CLK(I_sdrc_clk),
    .CE(n626_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_5_s1.INIT=1'b0;
  DFFCE Count_burst_num_wr_2_s1 (
    .Q(Count_burst_num_wr[2]),
    .D(n636_9),
    .CLK(I_sdrc_clk),
    .CE(n626_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_2_s1.INIT=1'b0;
  DFFCE Count_burst_num_rd_7_s1 (
    .Q(Count_burst_num_rd[7]),
    .D(n642_11),
    .CLK(I_sdrc_clk),
    .CE(n642_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_7_s1.INIT=1'b0;
  DFFCE Count_burst_num_rd_5_s1 (
    .Q(Count_burst_num_rd[5]),
    .D(n646_9),
    .CLK(I_sdrc_clk),
    .CE(n642_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_5_s1.INIT=1'b0;
  DFFCE Count_burst_num_rd_2_s1 (
    .Q(Count_burst_num_rd[2]),
    .D(n652_9),
    .CLK(I_sdrc_clk),
    .CE(n642_18),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_2_s1.INIT=1'b0;
  DFFCE O_autorefresh_ack_s2 (
    .Q(autorefresh_ack),
    .D(\Cmd_fsm_state.SDRC_STATE_AUTOREFRESH_DELAY ),
    .CLK(I_sdrc_clk),
    .CE(O_autorefresh_ack_6),
    .CLEAR(n316_6) 
);
defparam O_autorefresh_ack_s2.INIT=1'b0;
  DFFS O_sdram_wen_n_s1 (
    .Q(O_sdram_wen_n),
    .D(n955_10),
    .CLK(I_sdrc_clk),
    .SET(n953_3) 
);
  DFFS O_sdram_cas_n_s1 (
    .Q(O_sdram_cas_n),
    .D(n958_13),
    .CLK(I_sdrc_clk),
    .SET(n956_3) 
);
  DFFS O_sdram_ras_n_s1 (
    .Q(O_sdram_ras_n),
    .D(n961_10),
    .CLK(I_sdrc_clk),
    .SET(n959_7) 
);
  DFFS O_sdram_ba_1_s1 (
    .Q(O_sdram_ba[1]),
    .D(n964_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_ba_0_s1 (
    .Q(O_sdram_ba[0]),
    .D(n966_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_10_s1 (
    .Q(O_sdram_addr[10]),
    .D(n968_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_9_s1 (
    .Q(O_sdram_addr[9]),
    .D(n970_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_8_s1 (
    .Q(O_sdram_addr[8]),
    .D(n972_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_7_s1 (
    .Q(O_sdram_addr[7]),
    .D(n974_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_6_s1 (
    .Q(O_sdram_addr[6]),
    .D(n976_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_3_s1 (
    .Q(O_sdram_addr[3]),
    .D(n980_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_2_s1 (
    .Q(O_sdram_addr[2]),
    .D(n982_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_1_s1 (
    .Q(O_sdram_addr[1]),
    .D(n984_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFS O_sdram_addr_0_s1 (
    .Q(O_sdram_addr[0]),
    .D(n986_10),
    .CLK(I_sdrc_clk),
    .SET(n963_5) 
);
  DFFC Flag_autorefresh_s4 (
    .Q(Flag_autorefresh),
    .D(n132_10),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Flag_autorefresh_s4.INIT=1'b0;
  DFFC Flag_autorefresh0_s4 (
    .Q(Flag_autorefresh0),
    .D(n132_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Flag_autorefresh0_s4.INIT=1'b0;
  DFFC O_sdram_dqm_3_s3 (
    .Q(O_sdram_dqm[3]),
    .D(n856_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam O_sdram_dqm_3_s3.INIT=1'b0;
  DFFC O_sdram_dqm_2_s3 (
    .Q(O_sdram_dqm[2]),
    .D(n857_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam O_sdram_dqm_2_s3.INIT=1'b0;
  DFFC O_sdram_dqm_1_s3 (
    .Q(O_sdram_dqm[1]),
    .D(n858_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam O_sdram_dqm_1_s3.INIT=1'b0;
  DFFC O_sdram_dqm_0_s3 (
    .Q(O_sdram_dqm[0]),
    .D(n859_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam O_sdram_dqm_0_s3.INIT=1'b0;
  DFFC Count_burst_num_wr_6_s2 (
    .Q(Count_burst_num_wr[6]),
    .D(n628_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_6_s2.INIT=1'b0;
  DFFC Count_burst_num_wr_4_s2 (
    .Q(Count_burst_num_wr[4]),
    .D(n632_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_4_s2.INIT=1'b0;
  DFFC Count_burst_num_wr_3_s2 (
    .Q(Count_burst_num_wr[3]),
    .D(n634_17),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_3_s2.INIT=1'b0;
  DFFC Count_burst_num_wr_1_s2 (
    .Q(Count_burst_num_wr[1]),
    .D(n638_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_1_s2.INIT=1'b0;
  DFFC Count_burst_num_wr_0_s2 (
    .Q(Count_burst_num_wr[0]),
    .D(n640_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_wr_0_s2.INIT=1'b0;
  DFFC Count_burst_num_rd_6_s2 (
    .Q(Count_burst_num_rd[6]),
    .D(n644_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_6_s2.INIT=1'b0;
  DFFC Count_burst_num_rd_4_s2 (
    .Q(Count_burst_num_rd[4]),
    .D(n648_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_4_s2.INIT=1'b0;
  DFFC Count_burst_num_rd_3_s2 (
    .Q(Count_burst_num_rd[3]),
    .D(n650_17),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_3_s2.INIT=1'b0;
  DFFC Count_burst_num_rd_1_s2 (
    .Q(Count_burst_num_rd[1]),
    .D(n654_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_1_s2.INIT=1'b0;
  DFFC Count_burst_num_rd_0_s2 (
    .Q(Count_burst_num_rd[0]),
    .D(n656_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_burst_num_rd_0_s2.INIT=1'b0;
  ALU n509_s0 (
    .SUM(n509_1_SUM),
    .COUT(n509_3),
    .I0(Count_burst_num_rd[0]),
    .I1(Ctrl_fsm_burst_num_i[0]),
    .I3(GND),
    .CIN(GND) 
);
defparam n509_s0.ALU_MODE=3;
  ALU n510_s0 (
    .SUM(n510_1_SUM),
    .COUT(n510_3),
    .I0(Count_burst_num_rd[1]),
    .I1(Ctrl_fsm_burst_num_i[1]),
    .I3(GND),
    .CIN(n509_3) 
);
defparam n510_s0.ALU_MODE=3;
  ALU n511_s0 (
    .SUM(n511_1_SUM),
    .COUT(n511_3),
    .I0(Count_burst_num_rd[2]),
    .I1(Ctrl_fsm_burst_num_i[2]),
    .I3(GND),
    .CIN(n510_3) 
);
defparam n511_s0.ALU_MODE=3;
  ALU n512_s0 (
    .SUM(n512_1_SUM),
    .COUT(n512_3),
    .I0(Count_burst_num_rd[3]),
    .I1(Ctrl_fsm_burst_num_i[3]),
    .I3(GND),
    .CIN(n511_3) 
);
defparam n512_s0.ALU_MODE=3;
  ALU n513_s0 (
    .SUM(n513_1_SUM),
    .COUT(n513_3),
    .I0(Count_burst_num_rd[4]),
    .I1(Ctrl_fsm_burst_num_i[4]),
    .I3(GND),
    .CIN(n512_3) 
);
defparam n513_s0.ALU_MODE=3;
  ALU n514_s0 (
    .SUM(n514_1_SUM),
    .COUT(n514_3),
    .I0(Count_burst_num_rd[5]),
    .I1(Ctrl_fsm_burst_num_i[5]),
    .I3(GND),
    .CIN(n513_3) 
);
defparam n514_s0.ALU_MODE=3;
  ALU n515_s0 (
    .SUM(n515_1_SUM),
    .COUT(n515_3),
    .I0(Count_burst_num_rd[6]),
    .I1(Ctrl_fsm_burst_num_i[6]),
    .I3(GND),
    .CIN(n514_3) 
);
defparam n515_s0.ALU_MODE=3;
  ALU n516_s0 (
    .SUM(n516_1_SUM),
    .COUT(n516_3),
    .I0(Count_burst_num_rd[7]),
    .I1(Ctrl_fsm_burst_num_i[7]),
    .I3(GND),
    .CIN(n515_3) 
);
defparam n516_s0.ALU_MODE=3;
  ALU n529_s0 (
    .SUM(n529_1_SUM),
    .COUT(n529_3),
    .I0(Count_burst_num_wr[0]),
    .I1(Ctrl_fsm_burst_num_i[0]),
    .I3(GND),
    .CIN(GND) 
);
defparam n529_s0.ALU_MODE=3;
  ALU n530_s0 (
    .SUM(n530_1_SUM),
    .COUT(n530_3),
    .I0(Count_burst_num_wr[1]),
    .I1(Ctrl_fsm_burst_num_i[1]),
    .I3(GND),
    .CIN(n529_3) 
);
defparam n530_s0.ALU_MODE=3;
  ALU n531_s0 (
    .SUM(n531_1_SUM),
    .COUT(n531_3),
    .I0(Count_burst_num_wr[2]),
    .I1(Ctrl_fsm_burst_num_i[2]),
    .I3(GND),
    .CIN(n530_3) 
);
defparam n531_s0.ALU_MODE=3;
  ALU n532_s0 (
    .SUM(n532_1_SUM),
    .COUT(n532_3),
    .I0(Count_burst_num_wr[3]),
    .I1(Ctrl_fsm_burst_num_i[3]),
    .I3(GND),
    .CIN(n531_3) 
);
defparam n532_s0.ALU_MODE=3;
  ALU n533_s0 (
    .SUM(n533_1_SUM),
    .COUT(n533_3),
    .I0(Count_burst_num_wr[4]),
    .I1(Ctrl_fsm_burst_num_i[4]),
    .I3(GND),
    .CIN(n532_3) 
);
defparam n533_s0.ALU_MODE=3;
  ALU n534_s0 (
    .SUM(n534_1_SUM),
    .COUT(n534_3),
    .I0(Count_burst_num_wr[5]),
    .I1(Ctrl_fsm_burst_num_i[5]),
    .I3(GND),
    .CIN(n533_3) 
);
defparam n534_s0.ALU_MODE=3;
  ALU n535_s0 (
    .SUM(n535_1_SUM),
    .COUT(n535_3),
    .I0(Count_burst_num_wr[6]),
    .I1(Ctrl_fsm_burst_num_i[6]),
    .I3(GND),
    .CIN(n534_3) 
);
defparam n535_s0.ALU_MODE=3;
  ALU n536_s0 (
    .SUM(n536_1_SUM),
    .COUT(n536_3),
    .I0(Count_burst_num_wr[7]),
    .I1(Ctrl_fsm_burst_num_i[7]),
    .I3(GND),
    .CIN(n535_3) 
);
defparam n536_s0.ALU_MODE=3;
  INV n316_s2 (
    .O(n316_6),
    .I(I_sdrc_rst_n) 
);
  INV IO_sdram_dq_0_s3 (
    .O(IO_sdram_dq_0_6),
    .I(Ctrl_wr_data_valid) 
);
  INV n962_s4 (
    .O(n962_8),
    .I(\Cmd_init_state.INIT_STATE_INIT_DONE ) 
);
  INV n341_s3 (
    .O(n341_7),
    .I(ctrl_fsm_wr_n) 
);
  INV n10_s2 (
    .O(n10_6),
    .I(Count_init_delay[0]) 
);
  INV n156_s2 (
    .O(n156_6),
    .I(Count_cmd_delay[0]) 
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
endmodule /* \~control_fsm.sdram_int  */
module \~user_interface.sdram_int  (
  I_sdrc_clk,
  n316_6,
  ctrl_fsm_data_valid,
  I_sdrc_wr_n,
  I_sdrc_rd_n,
  I_sdrc_rst_n,
  ctrl_fsm_init,
  autorefresh_req_a,
  ctrl_fsm_wrd_done,
  ctrl_fsm_busy_n,
  I_sdrc_data_len,
  I_sdrc_addr,
  I_sdrc_data,
  I_sdrc_dqm,
  ctrl_fsm_data1,
  ctrl_double_wrd_flag,
  O_sdrc_rd_valid,
  O_sdrc_init_done,
  O_sdrc_busy_n,
  O_sdrc_wrd_ack,
  ctrl_fsm_rd_n,
  ctrl_fsm_wr_n,
  O_sdrc_data,
  ctrl_fsm_addr_bk,
  ctrl_fsm_addr_row,
  ctrl_fsm_addr_col,
  ctrl_fsm_data_len,
  ctrl_fsm_data0,
  ctrl_fsm_dqm
)
;
input I_sdrc_clk;
input n316_6;
input ctrl_fsm_data_valid;
input I_sdrc_wr_n;
input I_sdrc_rd_n;
input I_sdrc_rst_n;
input ctrl_fsm_init;
input autorefresh_req_a;
input ctrl_fsm_wrd_done;
input ctrl_fsm_busy_n;
input [7:0] I_sdrc_data_len;
input [20:0] I_sdrc_addr;
input [31:0] I_sdrc_data;
input [3:0] I_sdrc_dqm;
input [31:0] ctrl_fsm_data1;
output ctrl_double_wrd_flag;
output O_sdrc_rd_valid;
output O_sdrc_init_done;
output O_sdrc_busy_n;
output O_sdrc_wrd_ack;
output ctrl_fsm_rd_n;
output ctrl_fsm_wr_n;
output [31:0] O_sdrc_data;
output [1:0] ctrl_fsm_addr_bk;
output [10:0] ctrl_fsm_addr_row;
output [7:0] ctrl_fsm_addr_col;
output [7:0] ctrl_fsm_data_len;
output [31:0] ctrl_fsm_data0;
output [3:0] ctrl_fsm_dqm;
wire n9_3;
wire n1594_3;
wire n983_3;
wire n984_3;
wire n985_3;
wire n986_3;
wire n987_3;
wire n988_3;
wire n989_3;
wire n990_3;
wire O_ctrl_fsm_data_31_7;
wire n645_13;
wire n642_13;
wire \User_model_state.STATE_WAITING_10 ;
wire n95_15;
wire n96_13;
wire n98_13;
wire n645_15;
wire n642_15;
wire n570_12;
wire n572_12;
wire n574_12;
wire n576_12;
wire n578_12;
wire n580_12;
wire n582_12;
wire n584_12;
wire n586_12;
wire n588_12;
wire n590_12;
wire n592_12;
wire n594_12;
wire n596_20;
wire n598_20;
wire n600_20;
wire n602_20;
wire n604_20;
wire n606_20;
wire n608_20;
wire n610_20;
wire n625_12;
wire n627_12;
wire n629_12;
wire n631_12;
wire n633_12;
wire n635_12;
wire n637_12;
wire n639_12;
wire n547_20;
wire n548_24;
wire n549_24;
wire n550_25;
wire n551_25;
wire n553_25;
wire n555_25;
wire n562_18;
wire n559_17;
wire n982_22;
wire n648_17;
wire n651_15;
wire n654_15;
wire n657_15;
wire n660_15;
wire n663_15;
wire n666_15;
wire n669_15;
wire O_sdrc_wrd_ack_6;
wire n13_4;
wire n12_4;
wire n11_4;
wire n1714_4;
wire n983_4;
wire n985_4;
wire n989_4;
wire n990_4;
wire O_ctrl_fsm_data_31_8;
wire n95_16;
wire n562_20;
wire \User_model_state.STATE_READ_9 ;
wire \User_model_state.STATE_READ_10 ;
wire n95_17;
wire n95_18;
wire n96_14;
wire n96_15;
wire n97_14;
wire n97_15;
wire n98_14;
wire n98_16;
wire n645_16;
wire n642_16;
wire n570_13;
wire n570_14;
wire n572_13;
wire n574_13;
wire n576_13;
wire n578_13;
wire n580_13;
wire n582_13;
wire n584_13;
wire n586_13;
wire n588_13;
wire n590_13;
wire n592_13;
wire n594_13;
wire n625_13;
wire n627_13;
wire n629_13;
wire n631_13;
wire n633_13;
wire n635_13;
wire n637_13;
wire n639_13;
wire n547_21;
wire n554_27;
wire n559_19;
wire n559_20;
wire n982_23;
wire n982_25;
wire n982_26;
wire n654_16;
wire n654_18;
wire n663_16;
wire n666_16;
wire O_ctrl_fsm_data_31_9;
wire O_ctrl_fsm_data_31_10;
wire n562_21;
wire n96_16;
wire n645_17;
wire n570_15;
wire n547_22;
wire n982_27;
wire n982_28;
wire n982_31;
wire n982_32;
wire n982_33;
wire n648_20;
wire n982_34;
wire n982_35;
wire n982_36;
wire n982_37;
wire n95_22;
wire O_ctrl_fsm_addr_col_7_8;
wire O_ctrl_fsm_addr_col_6_8;
wire O_ctrl_fsm_addr_col_5_8;
wire O_ctrl_fsm_addr_col_4_8;
wire O_ctrl_fsm_addr_col_3_8;
wire O_ctrl_fsm_addr_col_2_8;
wire O_ctrl_fsm_addr_col_1_8;
wire O_ctrl_fsm_addr_col_0_8;
wire n648_22;
wire n95_24;
wire \User_model_state.STATE_READ_14 ;
wire n562_23;
wire n654_20;
wire n556_28;
wire n554_29;
wire \User_model_state.STATE_READ_18 ;
wire n559_22;
wire n982_39;
wire n982_41;
wire n982_43;
wire n988_6;
wire n987_6;
wire n986_6;
wire n984_6;
wire n1714_6;
wire n648_24;
wire n98_18;
wire n97_17;
wire n648_26;
wire n95_26;
wire n1692_5;
wire n565_19;
wire n565_21;
wire n568_21;
wire n559_24;
wire n562_28;
wire O_ctrl_fsm_addr_bk_1_7;
wire n129_13;
wire \User_model_state.STATE_IDLE ;
wire Double_wrd_flag;
wire Sdrc_wr_n_i;
wire Sdrc_rd_n_i;
wire Sdrc_wr_n_i_reg;
wire Sdrc_rd_n_i_reg;
wire User_busy_flag_n;
wire \User_model_state.STATE_READ ;
wire \User_model_state.STATE_WRITE_WAIT ;
wire \User_model_state.STATE_WRITE ;
wire \User_model_state.STATE_WRITE_2 ;
wire \User_model_state.STATE_READ_WAIT ;
wire \User_model_state.STATE_READ_2 ;
wire \User_model_state.STATE_READ_2_WAIT ;
wire \User_model_state.STATE_WRITE_2_WAIT ;
wire \User_model_state.STATE_WAITING ;
wire User_data_i_0_5;
wire n245_17_SUM;
wire n245_20;
wire n245_18_SUM;
wire n245_22;
wire n245_19_SUM;
wire n245_24;
wire n245_20_SUM;
wire n245_26;
wire n245_21_SUM;
wire n245_28;
wire n245_22_SUM;
wire n245_30;
wire n245_23_SUM;
wire n245_32;
wire n435_17_SUM;
wire n435_20;
wire n435_18_SUM;
wire n435_22;
wire n435_19_SUM;
wire n435_24;
wire n435_20_SUM;
wire n435_26;
wire n435_21_SUM;
wire n435_28;
wire n435_22_SUM;
wire n435_30;
wire n435_23_SUM;
wire n435_32;
wire n128_1;
wire n128_2;
wire n127_1;
wire n127_2;
wire n126_1;
wire n126_2;
wire n125_1;
wire n125_2;
wire n124_1;
wire n124_2;
wire n123_1;
wire n123_2;
wire n122_1;
wire n122_2;
wire n121_1;
wire n121_2;
wire n120_1;
wire n120_2;
wire n119_1;
wire n119_2;
wire n118_1;
wire n118_2;
wire n117_1;
wire n117_0_COUT;
wire n981_1;
wire n981_2;
wire n980_1;
wire n980_2;
wire n979_1;
wire n979_2;
wire n978_1;
wire n978_2;
wire n977_1;
wire n977_2;
wire n976_1;
wire n976_2;
wire n975_1;
wire n975_2;
wire n974_1;
wire n974_0_COUT;
wire n1276_6;
wire n1277_6;
wire n1278_6;
wire n1279_6;
wire n1280_6;
wire n1281_6;
wire n1282_6;
wire n1283_6;
wire n14_6;
wire User_data_i_0_24;
wire [3:0] Count_buffer_wr;
wire [10:0] Addr_row_reg;
wire [1:0] Addr_bank_reg;
wire [7:0] Sdrc_data_len_i;
wire [20:0] Sdrc_addr_i;
wire [7:0] Column_remain_len_wrd;
wire [7:0] Data_len_1_wrd;
wire [7:0] Data_len_0_wrd;
wire [3:0] Count_buffer_rd;
wire [2:0] Count_ACTIVE2RW_DELAY;
wire [7:0] Count_data_len_0_wr;
wire [31:0] User_data_i_reg;
wire [3:0] Dqm_data_i_reg;
wire VCC;
wire GND;
  LUT2 n9_s0 (
    .F(n9_3),
    .I0(autorefresh_req_a),
    .I1(User_busy_flag_n) 
);
defparam n9_s0.INIT=4'h4;
  LUT2 n1594_s0 (
    .F(n1594_3),
    .I0(Sdrc_wr_n_i_reg),
    .I1(Sdrc_rd_n_i_reg) 
);
defparam n1594_s0.INIT=4'h7;
  LUT2 n983_s0 (
    .F(n983_3),
    .I0(n983_4),
    .I1(Sdrc_data_len_i[7]) 
);
defparam n983_s0.INIT=4'h8;
  LUT4 n984_s0 (
    .F(n984_3),
    .I0(n984_6),
    .I1(n983_4),
    .I2(Sdrc_data_len_i[7]),
    .I3(Sdrc_data_len_i[6]) 
);
defparam n984_s0.INIT=16'hAE20;
  LUT3 n985_s0 (
    .F(n985_3),
    .I0(n985_4),
    .I1(Sdrc_data_len_i[5]),
    .I2(n982_22) 
);
defparam n985_s0.INIT=8'hAC;
  LUT3 n986_s0 (
    .F(n986_3),
    .I0(Sdrc_data_len_i[4]),
    .I1(n986_6),
    .I2(n982_22) 
);
defparam n986_s0.INIT=8'h3A;
  LUT3 n987_s0 (
    .F(n987_3),
    .I0(Sdrc_data_len_i[3]),
    .I1(n987_6),
    .I2(n982_22) 
);
defparam n987_s0.INIT=8'h3A;
  LUT3 n988_s0 (
    .F(n988_3),
    .I0(Sdrc_data_len_i[2]),
    .I1(n988_6),
    .I2(n982_22) 
);
defparam n988_s0.INIT=8'h3A;
  LUT3 n989_s0 (
    .F(n989_3),
    .I0(n989_4),
    .I1(Sdrc_data_len_i[1]),
    .I2(n982_22) 
);
defparam n989_s0.INIT=8'hAC;
  LUT3 n990_s0 (
    .F(n990_3),
    .I0(n990_4),
    .I1(Sdrc_data_len_i[0]),
    .I2(n982_22) 
);
defparam n990_s0.INIT=8'hAC;
  LUT2 O_ctrl_fsm_data_31_s5 (
    .F(O_ctrl_fsm_data_31_7),
    .I0(O_ctrl_fsm_data_31_8),
    .I1(I_sdrc_rst_n) 
);
defparam O_ctrl_fsm_data_31_s5.INIT=4'h4;
  LUT4 n645_s9 (
    .F(n645_13),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(\User_model_state.STATE_READ ),
    .I2(\User_model_state.STATE_READ_WAIT ),
    .I3(\User_model_state.STATE_READ_2 ) 
);
defparam n645_s9.INIT=16'hFFFE;
  LUT4 n642_s9 (
    .F(n642_13),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(\User_model_state.STATE_WRITE_WAIT ),
    .I2(\User_model_state.STATE_WRITE ),
    .I3(\User_model_state.STATE_WRITE_2_WAIT ) 
);
defparam n642_s9.INIT=16'hFFFE;
  LUT4 \User_model_state.STATE_READ_s3  (
    .F(\User_model_state.STATE_WAITING_10 ),
    .I0(O_sdrc_init_done),
    .I1(\User_model_state.STATE_WAITING ),
    .I2(\User_model_state.STATE_READ_9 ),
    .I3(\User_model_state.STATE_READ_10 ) 
);
defparam \User_model_state.STATE_READ_s3 .INIT=16'h0B00;
  LUT4 n95_s10 (
    .F(n95_15),
    .I0(n95_16),
    .I1(n95_17),
    .I2(n95_18),
    .I3(\User_model_state.STATE_IDLE ) 
);
defparam n95_s10.INIT=16'hF444;
  LUT4 n96_s9 (
    .F(n96_13),
    .I0(n95_16),
    .I1(n96_14),
    .I2(n96_15),
    .I3(\User_model_state.STATE_IDLE ) 
);
defparam n96_s9.INIT=16'hF444;
  LUT4 n98_s9 (
    .F(n98_13),
    .I0(n98_14),
    .I1(n98_18),
    .I2(n98_16),
    .I3(Count_buffer_rd[0]) 
);
defparam n98_s9.INIT=16'hFACF;
  LUT4 n645_s10 (
    .F(n645_15),
    .I0(n645_16),
    .I1(ctrl_fsm_rd_n),
    .I2(\User_model_state.STATE_READ_2 ),
    .I3(\User_model_state.STATE_READ ) 
);
defparam n645_s10.INIT=16'hFFF4;
  LUT4 n642_s10 (
    .F(n642_15),
    .I0(ctrl_fsm_wr_n),
    .I1(n642_16),
    .I2(\User_model_state.STATE_WRITE_WAIT ),
    .I3(\User_model_state.STATE_WRITE_2_WAIT ) 
);
defparam n642_s10.INIT=16'hFFF2;
  LUT3 n570_s8 (
    .F(n570_12),
    .I0(ctrl_fsm_addr_bk[1]),
    .I1(n570_13),
    .I2(n570_14) 
);
defparam n570_s8.INIT=8'h8F;
  LUT3 n572_s8 (
    .F(n572_12),
    .I0(ctrl_fsm_addr_bk[0]),
    .I1(n570_13),
    .I2(n572_13) 
);
defparam n572_s8.INIT=8'h8F;
  LUT3 n574_s8 (
    .F(n574_12),
    .I0(ctrl_fsm_addr_row[10]),
    .I1(n570_13),
    .I2(n574_13) 
);
defparam n574_s8.INIT=8'h8F;
  LUT3 n576_s8 (
    .F(n576_12),
    .I0(ctrl_fsm_addr_row[9]),
    .I1(n570_13),
    .I2(n576_13) 
);
defparam n576_s8.INIT=8'h8F;
  LUT3 n578_s8 (
    .F(n578_12),
    .I0(ctrl_fsm_addr_row[8]),
    .I1(n570_13),
    .I2(n578_13) 
);
defparam n578_s8.INIT=8'h8F;
  LUT3 n580_s8 (
    .F(n580_12),
    .I0(ctrl_fsm_addr_row[7]),
    .I1(n570_13),
    .I2(n580_13) 
);
defparam n580_s8.INIT=8'h8F;
  LUT3 n582_s8 (
    .F(n582_12),
    .I0(ctrl_fsm_addr_row[6]),
    .I1(n570_13),
    .I2(n582_13) 
);
defparam n582_s8.INIT=8'h8F;
  LUT3 n584_s8 (
    .F(n584_12),
    .I0(ctrl_fsm_addr_row[5]),
    .I1(n570_13),
    .I2(n584_13) 
);
defparam n584_s8.INIT=8'h8F;
  LUT3 n586_s8 (
    .F(n586_12),
    .I0(ctrl_fsm_addr_row[4]),
    .I1(n570_13),
    .I2(n586_13) 
);
defparam n586_s8.INIT=8'h8F;
  LUT3 n588_s8 (
    .F(n588_12),
    .I0(ctrl_fsm_addr_row[3]),
    .I1(n570_13),
    .I2(n588_13) 
);
defparam n588_s8.INIT=8'h8F;
  LUT3 n590_s8 (
    .F(n590_12),
    .I0(ctrl_fsm_addr_row[2]),
    .I1(n570_13),
    .I2(n590_13) 
);
defparam n590_s8.INIT=8'h8F;
  LUT3 n592_s8 (
    .F(n592_12),
    .I0(ctrl_fsm_addr_row[1]),
    .I1(n570_13),
    .I2(n592_13) 
);
defparam n592_s8.INIT=8'h8F;
  LUT3 n594_s8 (
    .F(n594_12),
    .I0(ctrl_fsm_addr_row[0]),
    .I1(n570_13),
    .I2(n594_13) 
);
defparam n594_s8.INIT=8'h8F;
  LUT2 n596_s14 (
    .F(n596_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[7]) 
);
defparam n596_s14.INIT=4'h8;
  LUT2 n598_s14 (
    .F(n598_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[6]) 
);
defparam n598_s14.INIT=4'h8;
  LUT2 n600_s14 (
    .F(n600_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[5]) 
);
defparam n600_s14.INIT=4'h8;
  LUT2 n602_s14 (
    .F(n602_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[4]) 
);
defparam n602_s14.INIT=4'h8;
  LUT2 n604_s14 (
    .F(n604_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[3]) 
);
defparam n604_s14.INIT=4'h8;
  LUT2 n606_s14 (
    .F(n606_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[2]) 
);
defparam n606_s14.INIT=4'h8;
  LUT2 n608_s14 (
    .F(n608_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[1]) 
);
defparam n608_s14.INIT=4'h8;
  LUT2 n610_s14 (
    .F(n610_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[0]) 
);
defparam n610_s14.INIT=4'h8;
  LUT3 n625_s8 (
    .F(n625_12),
    .I0(ctrl_fsm_data_len[7]),
    .I1(n570_13),
    .I2(n625_13) 
);
defparam n625_s8.INIT=8'h8F;
  LUT3 n627_s8 (
    .F(n627_12),
    .I0(ctrl_fsm_data_len[6]),
    .I1(n570_13),
    .I2(n627_13) 
);
defparam n627_s8.INIT=8'h8F;
  LUT3 n629_s8 (
    .F(n629_12),
    .I0(ctrl_fsm_data_len[5]),
    .I1(n570_13),
    .I2(n629_13) 
);
defparam n629_s8.INIT=8'h8F;
  LUT3 n631_s8 (
    .F(n631_12),
    .I0(ctrl_fsm_data_len[4]),
    .I1(n570_13),
    .I2(n631_13) 
);
defparam n631_s8.INIT=8'h8F;
  LUT3 n633_s8 (
    .F(n633_12),
    .I0(ctrl_fsm_data_len[3]),
    .I1(n570_13),
    .I2(n633_13) 
);
defparam n633_s8.INIT=8'h8F;
  LUT3 n635_s8 (
    .F(n635_12),
    .I0(ctrl_fsm_data_len[2]),
    .I1(n570_13),
    .I2(n635_13) 
);
defparam n635_s8.INIT=8'h8F;
  LUT3 n637_s8 (
    .F(n637_12),
    .I0(ctrl_fsm_data_len[1]),
    .I1(n570_13),
    .I2(n637_13) 
);
defparam n637_s8.INIT=8'h8F;
  LUT3 n639_s8 (
    .F(n639_12),
    .I0(ctrl_fsm_data_len[0]),
    .I1(n570_13),
    .I2(n639_13) 
);
defparam n639_s8.INIT=8'h8F;
  LUT3 n547_s16 (
    .F(n547_20),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(n547_21),
    .I2(\User_model_state.STATE_WAITING_10 ) 
);
defparam n547_s16.INIT=8'h3B;
  LUT3 n548_s20 (
    .F(n548_24),
    .I0(Sdrc_rd_n_i_reg),
    .I1(Sdrc_wr_n_i_reg),
    .I2(\User_model_state.STATE_IDLE ) 
);
defparam n548_s20.INIT=8'h40;
  LUT2 n549_s20 (
    .F(n549_24),
    .I0(Sdrc_wr_n_i_reg),
    .I1(\User_model_state.STATE_IDLE ) 
);
defparam n549_s20.INIT=4'h4;
  LUT4 n550_s21 (
    .F(n550_25),
    .I0(Count_ACTIVE2RW_DELAY[2]),
    .I1(Count_ACTIVE2RW_DELAY[0]),
    .I2(Count_ACTIVE2RW_DELAY[1]),
    .I3(\User_model_state.STATE_WRITE_WAIT ) 
);
defparam n550_s21.INIT=16'h4000;
  LUT4 n551_s21 (
    .F(n551_25),
    .I0(Count_ACTIVE2RW_DELAY[2]),
    .I1(Count_ACTIVE2RW_DELAY[1]),
    .I2(Count_ACTIVE2RW_DELAY[0]),
    .I3(\User_model_state.STATE_WRITE_2_WAIT ) 
);
defparam n551_s21.INIT=16'h4000;
  LUT4 n553_s21 (
    .F(n553_25),
    .I0(Count_ACTIVE2RW_DELAY[2]),
    .I1(Count_ACTIVE2RW_DELAY[0]),
    .I2(Count_ACTIVE2RW_DELAY[1]),
    .I3(\User_model_state.STATE_READ ) 
);
defparam n553_s21.INIT=16'h4000;
  LUT4 n555_s21 (
    .F(n555_25),
    .I0(Count_ACTIVE2RW_DELAY[2]),
    .I1(Count_ACTIVE2RW_DELAY[1]),
    .I2(Count_ACTIVE2RW_DELAY[0]),
    .I3(\User_model_state.STATE_READ_2 ) 
);
defparam n555_s21.INIT=16'h4000;
  LUT4 n562_s13 (
    .F(n562_18),
    .I0(Count_ACTIVE2RW_DELAY[0]),
    .I1(Count_ACTIVE2RW_DELAY[1]),
    .I2(n562_20),
    .I3(Count_ACTIVE2RW_DELAY[2]) 
);
defparam n562_s13.INIT=16'h0708;
  LUT4 n559_s12 (
    .F(n559_17),
    .I0(ctrl_fsm_wrd_done),
    .I1(n559_19),
    .I2(User_busy_flag_n),
    .I3(n559_20) 
);
defparam n559_s12.INIT=16'hFF10;
  LUT4 n982_s17 (
    .F(n982_22),
    .I0(n982_23),
    .I1(n982_43),
    .I2(n982_25),
    .I3(n982_26) 
);
defparam n982_s17.INIT=16'hE0FF;
  LUT4 n648_s11 (
    .F(n648_17),
    .I0(n648_24),
    .I1(Count_data_len_0_wr[6]),
    .I2(n648_22),
    .I3(Count_data_len_0_wr[7]) 
);
defparam n648_s11.INIT=16'hBAC0;
  LUT3 n651_s10 (
    .F(n651_15),
    .I0(n648_22),
    .I1(n648_24),
    .I2(Count_data_len_0_wr[6]) 
);
defparam n651_s10.INIT=8'hCA;
  LUT4 n654_s10 (
    .F(n654_15),
    .I0(n654_16),
    .I1(n654_20),
    .I2(n654_18),
    .I3(Count_data_len_0_wr[5]) 
);
defparam n654_s10.INIT=16'h5F0C;
  LUT4 n657_s10 (
    .F(n657_15),
    .I0(n654_16),
    .I1(n654_20),
    .I2(Count_data_len_0_wr[4]),
    .I3(Count_data_len_0_wr[3]) 
);
defparam n657_s10.INIT=16'h5CD0;
  LUT3 n660_s10 (
    .F(n660_15),
    .I0(n654_20),
    .I1(n654_16),
    .I2(Count_data_len_0_wr[3]) 
);
defparam n660_s10.INIT=8'h3A;
  LUT4 n663_s10 (
    .F(n663_15),
    .I0(O_ctrl_fsm_data_31_8),
    .I1(n663_16),
    .I2(n654_16),
    .I3(Count_data_len_0_wr[2]) 
);
defparam n663_s10.INIT=16'h0F44;
  LUT4 n666_s10 (
    .F(n666_15),
    .I0(n666_16),
    .I1(O_ctrl_fsm_data_31_8),
    .I2(Count_data_len_0_wr[0]),
    .I3(Count_data_len_0_wr[1]) 
);
defparam n666_s10.INIT=16'h5730;
  LUT3 n669_s10 (
    .F(n669_15),
    .I0(O_ctrl_fsm_data_31_8),
    .I1(n666_16),
    .I2(Count_data_len_0_wr[0]) 
);
defparam n669_s10.INIT=8'h35;
  LUT4 O_sdrc_wrd_ack_s4 (
    .F(O_sdrc_wrd_ack_6),
    .I0(\User_model_state.STATE_READ ),
    .I1(\User_model_state.STATE_WRITE_WAIT ),
    .I2(n1594_3),
    .I3(\User_model_state.STATE_IDLE ) 
);
defparam O_sdrc_wrd_ack_s4.INIT=16'hF0EE;
  LUT2 n13_s0 (
    .F(n13_4),
    .I0(Count_buffer_wr[1]),
    .I1(Count_buffer_wr[0]) 
);
defparam n13_s0.INIT=4'h6;
  LUT3 n12_s0 (
    .F(n12_4),
    .I0(Count_buffer_wr[1]),
    .I1(Count_buffer_wr[0]),
    .I2(Count_buffer_wr[2]) 
);
defparam n12_s0.INIT=8'h78;
  LUT4 n11_s0 (
    .F(n11_4),
    .I0(Count_buffer_wr[2]),
    .I1(Count_buffer_wr[1]),
    .I2(Count_buffer_wr[0]),
    .I3(Count_buffer_wr[3]) 
);
defparam n11_s0.INIT=16'h7F80;
  LUT2 n1714_s1 (
    .F(n1714_4),
    .I0(I_sdrc_wr_n),
    .I1(I_sdrc_rd_n) 
);
defparam n1714_s1.INIT=4'h8;
  LUT4 n983_s1 (
    .F(n983_4),
    .I0(Column_remain_len_wrd[7]),
    .I1(I_sdrc_addr[7]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n983_s1.INIT=16'hA333;
  LUT4 n985_s1 (
    .F(n985_4),
    .I0(Column_remain_len_wrd[5]),
    .I1(I_sdrc_addr[5]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n985_s1.INIT=16'hA333;
  LUT4 n989_s1 (
    .F(n989_4),
    .I0(Column_remain_len_wrd[1]),
    .I1(I_sdrc_addr[1]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n989_s1.INIT=16'hA333;
  LUT4 n990_s1 (
    .F(n990_4),
    .I0(Column_remain_len_wrd[0]),
    .I1(I_sdrc_addr[0]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n990_s1.INIT=16'hA333;
  LUT4 O_ctrl_fsm_data_31_s6 (
    .F(O_ctrl_fsm_data_31_8),
    .I0(O_ctrl_fsm_data_31_9),
    .I1(\User_model_state.STATE_WRITE_2 ),
    .I2(O_ctrl_fsm_data_31_10),
    .I3(\User_model_state.STATE_WRITE ) 
);
defparam O_ctrl_fsm_data_31_s6.INIT=16'h0777;
  LUT2 n95_s11 (
    .F(n95_16),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(\User_model_state.STATE_WRITE_2 ) 
);
defparam n95_s11.INIT=4'h1;
  LUT4 n562_s15 (
    .F(n562_20),
    .I0(\User_model_state.STATE_READ ),
    .I1(\User_model_state.STATE_WRITE_WAIT ),
    .I2(\User_model_state.STATE_WRITE_2_WAIT ),
    .I3(\User_model_state.STATE_READ_2 ) 
);
defparam n562_s15.INIT=16'h0001;
  LUT4 \User_model_state.STATE_READ_s4  (
    .F(\User_model_state.STATE_READ_9 ),
    .I0(Count_ACTIVE2RW_DELAY[2]),
    .I1(Count_ACTIVE2RW_DELAY[1]),
    .I2(Count_ACTIVE2RW_DELAY[0]),
    .I3(n562_20) 
);
defparam \User_model_state.STATE_READ_s4 .INIT=16'h00BF;
  LUT4 \User_model_state.STATE_READ_s5  (
    .F(\User_model_state.STATE_READ_10 ),
    .I0(ctrl_fsm_wrd_done),
    .I1(ctrl_fsm_busy_n),
    .I2(\User_model_state.STATE_READ_18 ),
    .I3(\User_model_state.STATE_READ_14 ) 
);
defparam \User_model_state.STATE_READ_s5 .INIT=16'h00FE;
  LUT4 n95_s12 (
    .F(n95_17),
    .I0(n98_14),
    .I1(n95_22),
    .I2(n95_24),
    .I3(Count_buffer_rd[3]) 
);
defparam n95_s12.INIT=16'hAF30;
  LUT3 n95_s13 (
    .F(n95_18),
    .I0(Count_buffer_wr[3]),
    .I1(Count_buffer_rd[3]),
    .I2(Sdrc_wr_n_i_reg) 
);
defparam n95_s13.INIT=8'hCA;
  LUT4 n96_s10 (
    .F(n96_14),
    .I0(n98_14),
    .I1(n95_22),
    .I2(n96_16),
    .I3(Count_buffer_rd[2]) 
);
defparam n96_s10.INIT=16'hAF30;
  LUT3 n96_s11 (
    .F(n96_15),
    .I0(Count_buffer_wr[2]),
    .I1(Count_buffer_rd[2]),
    .I2(Sdrc_wr_n_i_reg) 
);
defparam n96_s11.INIT=8'hCA;
  LUT4 n97_s10 (
    .F(n97_14),
    .I0(n98_14),
    .I1(n95_22),
    .I2(Count_buffer_rd[0]),
    .I3(Count_buffer_rd[1]) 
);
defparam n97_s10.INIT=16'hAF30;
  LUT4 n97_s11 (
    .F(n97_15),
    .I0(Count_buffer_wr[1]),
    .I1(Count_buffer_rd[1]),
    .I2(Sdrc_wr_n_i_reg),
    .I3(\User_model_state.STATE_IDLE ) 
);
defparam n97_s11.INIT=16'hCA00;
  LUT4 n98_s10 (
    .F(n98_14),
    .I0(Count_data_len_0_wr[7]),
    .I1(Data_len_0_wrd[7]),
    .I2(n245_32),
    .I3(\User_model_state.STATE_WRITE ) 
);
defparam n98_s10.INIT=16'h2B00;
  LUT4 n98_s12 (
    .F(n98_16),
    .I0(Sdrc_wr_n_i_reg),
    .I1(\User_model_state.STATE_IDLE ),
    .I2(Count_buffer_wr[0]),
    .I3(Count_buffer_rd[0]) 
);
defparam n98_s12.INIT=16'hC8BF;
  LUT4 n645_s11 (
    .F(n645_16),
    .I0(n554_27),
    .I1(\User_model_state.STATE_READ_WAIT ),
    .I2(n645_17),
    .I3(\User_model_state.STATE_IDLE ) 
);
defparam n645_s11.INIT=16'hB0BB;
  LUT4 n642_s11 (
    .F(n642_16),
    .I0(n554_27),
    .I1(\User_model_state.STATE_WRITE ),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_wr_n_i_reg) 
);
defparam n642_s11.INIT=16'h0BBB;
  LUT3 n570_s9 (
    .F(n570_13),
    .I0(ctrl_fsm_wrd_done),
    .I1(ctrl_fsm_busy_n),
    .I2(\User_model_state.STATE_WRITE ) 
);
defparam n570_s9.INIT=8'hD0;
  LUT4 n570_s10 (
    .F(n570_14),
    .I0(n570_15),
    .I1(Addr_bank_reg[1]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[20]) 
);
defparam n570_s10.INIT=16'h0BBB;
  LUT4 n572_s9 (
    .F(n572_13),
    .I0(n570_15),
    .I1(Addr_bank_reg[0]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[19]) 
);
defparam n572_s9.INIT=16'h0BBB;
  LUT4 n574_s9 (
    .F(n574_13),
    .I0(n570_15),
    .I1(Addr_row_reg[10]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[18]) 
);
defparam n574_s9.INIT=16'h0BBB;
  LUT4 n576_s9 (
    .F(n576_13),
    .I0(n570_15),
    .I1(Addr_row_reg[9]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[17]) 
);
defparam n576_s9.INIT=16'h0BBB;
  LUT4 n578_s9 (
    .F(n578_13),
    .I0(n570_15),
    .I1(Addr_row_reg[8]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[16]) 
);
defparam n578_s9.INIT=16'h0BBB;
  LUT4 n580_s9 (
    .F(n580_13),
    .I0(n570_15),
    .I1(Addr_row_reg[7]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[15]) 
);
defparam n580_s9.INIT=16'h0BBB;
  LUT4 n582_s9 (
    .F(n582_13),
    .I0(n570_15),
    .I1(Addr_row_reg[6]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[14]) 
);
defparam n582_s9.INIT=16'h0BBB;
  LUT4 n584_s9 (
    .F(n584_13),
    .I0(n570_15),
    .I1(Addr_row_reg[5]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[13]) 
);
defparam n584_s9.INIT=16'h0BBB;
  LUT4 n586_s9 (
    .F(n586_13),
    .I0(n570_15),
    .I1(Addr_row_reg[4]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[12]) 
);
defparam n586_s9.INIT=16'h0BBB;
  LUT4 n588_s9 (
    .F(n588_13),
    .I0(n570_15),
    .I1(Addr_row_reg[3]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[11]) 
);
defparam n588_s9.INIT=16'h0BBB;
  LUT4 n590_s9 (
    .F(n590_13),
    .I0(n570_15),
    .I1(Addr_row_reg[2]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[10]) 
);
defparam n590_s9.INIT=16'h0BBB;
  LUT4 n592_s9 (
    .F(n592_13),
    .I0(n570_15),
    .I1(Addr_row_reg[1]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[9]) 
);
defparam n592_s9.INIT=16'h0BBB;
  LUT4 n594_s9 (
    .F(n594_13),
    .I0(n570_15),
    .I1(Addr_row_reg[0]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Sdrc_addr_i[8]) 
);
defparam n594_s9.INIT=16'h0BBB;
  LUT4 n625_s9 (
    .F(n625_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[7]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[7]) 
);
defparam n625_s9.INIT=16'h0BBB;
  LUT4 n627_s9 (
    .F(n627_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[6]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[6]) 
);
defparam n627_s9.INIT=16'h0BBB;
  LUT4 n629_s9 (
    .F(n629_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[5]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[5]) 
);
defparam n629_s9.INIT=16'h0BBB;
  LUT4 n631_s9 (
    .F(n631_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[4]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[4]) 
);
defparam n631_s9.INIT=16'h0BBB;
  LUT4 n633_s9 (
    .F(n633_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[3]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[3]) 
);
defparam n633_s9.INIT=16'h0BBB;
  LUT4 n635_s9 (
    .F(n635_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[2]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[2]) 
);
defparam n635_s9.INIT=16'h0BBB;
  LUT4 n637_s9 (
    .F(n637_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[1]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[1]) 
);
defparam n637_s9.INIT=16'h0BBB;
  LUT4 n639_s9 (
    .F(n639_13),
    .I0(n570_15),
    .I1(Data_len_1_wrd[0]),
    .I2(\User_model_state.STATE_IDLE ),
    .I3(Data_len_0_wrd[0]) 
);
defparam n639_s9.INIT=16'h0BBB;
  LUT4 n547_s17 (
    .F(n547_21),
    .I0(O_sdrc_init_done),
    .I1(\User_model_state.STATE_WAITING ),
    .I2(n547_22),
    .I3(\User_model_state.STATE_READ_18 ) 
);
defparam n547_s17.INIT=16'h7770;
  LUT3 n554_s23 (
    .F(n554_27),
    .I0(ctrl_fsm_busy_n),
    .I1(ctrl_fsm_wrd_done),
    .I2(Double_wrd_flag) 
);
defparam n554_s23.INIT=8'h40;
  LUT2 n559_s14 (
    .F(n559_19),
    .I0(\User_model_state.STATE_WRITE_2 ),
    .I1(\User_model_state.STATE_READ_2_WAIT ) 
);
defparam n559_s14.INIT=4'h1;
  LUT4 n559_s15 (
    .F(n559_20),
    .I0(\User_model_state.STATE_READ_14 ),
    .I1(n559_22),
    .I2(n562_21),
    .I3(ctrl_fsm_busy_n) 
);
defparam n559_s15.INIT=16'hBF00;
  LUT4 n982_s18 (
    .F(n982_23),
    .I0(n982_27),
    .I1(n982_28),
    .I2(n982_41),
    .I3(n982_39) 
);
defparam n982_s18.INIT=16'h00F1;
  LUT3 n982_s20 (
    .F(n982_25),
    .I0(n984_6),
    .I1(Sdrc_data_len_i[6]),
    .I2(n982_33) 
);
defparam n982_s20.INIT=8'hD0;
  LUT4 n982_s21 (
    .F(n982_26),
    .I0(Sdrc_data_len_i[7]),
    .I1(n983_4),
    .I2(Sdrc_data_len_i[6]),
    .I3(n984_6) 
);
defparam n982_s21.INIT=16'hDD4D;
  LUT4 n654_s11 (
    .F(n654_16),
    .I0(Count_data_len_0_wr[2]),
    .I1(n663_16),
    .I2(n95_16),
    .I3(n666_16) 
);
defparam n654_s11.INIT=16'hF800;
  LUT4 n654_s13 (
    .F(n654_18),
    .I0(n95_16),
    .I1(Count_data_len_0_wr[4]),
    .I2(Count_data_len_0_wr[3]),
    .I3(Count_data_len_0_wr[5]) 
);
defparam n654_s13.INIT=16'hEA3F;
  LUT2 n663_s11 (
    .F(n663_16),
    .I0(Count_data_len_0_wr[1]),
    .I1(Count_data_len_0_wr[0]) 
);
defparam n663_s11.INIT=4'h8;
  LUT3 n666_s11 (
    .F(n666_16),
    .I0(O_ctrl_fsm_data_31_9),
    .I1(\User_model_state.STATE_WRITE_2 ),
    .I2(n98_14) 
);
defparam n666_s11.INIT=8'h0B;
  LUT3 O_ctrl_fsm_data_31_s7 (
    .F(O_ctrl_fsm_data_31_9),
    .I0(Count_data_len_0_wr[7]),
    .I1(Data_len_1_wrd[7]),
    .I2(n435_32) 
);
defparam O_ctrl_fsm_data_31_s7.INIT=8'hD4;
  LUT3 O_ctrl_fsm_data_31_s8 (
    .F(O_ctrl_fsm_data_31_10),
    .I0(Count_data_len_0_wr[7]),
    .I1(Data_len_0_wrd[7]),
    .I2(n245_32) 
);
defparam O_ctrl_fsm_data_31_s8.INIT=8'hD4;
  LUT2 n562_s16 (
    .F(n562_21),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(\User_model_state.STATE_READ_WAIT ) 
);
defparam n562_s16.INIT=4'h1;
  LUT2 n96_s12 (
    .F(n96_16),
    .I0(Count_buffer_rd[1]),
    .I1(Count_buffer_rd[0]) 
);
defparam n96_s12.INIT=4'h8;
  LUT2 n645_s12 (
    .F(n645_17),
    .I0(Sdrc_rd_n_i_reg),
    .I1(Sdrc_wr_n_i_reg) 
);
defparam n645_s12.INIT=4'h4;
  LUT4 n570_s11 (
    .F(n570_15),
    .I0(ctrl_fsm_busy_n),
    .I1(\User_model_state.STATE_WRITE ),
    .I2(ctrl_fsm_wrd_done),
    .I3(\User_model_state.STATE_READ_WAIT ) 
);
defparam n570_s11.INIT=16'h00BF;
  LUT4 n547_s18 (
    .F(n547_22),
    .I0(Double_wrd_flag),
    .I1(n559_19),
    .I2(ctrl_fsm_wrd_done),
    .I3(ctrl_fsm_busy_n) 
);
defparam n547_s18.INIT=16'h008F;
  LUT4 n982_s22 (
    .F(n982_27),
    .I0(I_sdrc_addr[2]),
    .I1(Column_remain_len_wrd[2]),
    .I2(Sdrc_data_len_i[2]),
    .I3(n1714_4) 
);
defparam n982_s22.INIT=16'h0C05;
  LUT4 n982_s23 (
    .F(n982_28),
    .I0(Sdrc_data_len_i[1]),
    .I1(n989_4),
    .I2(n990_4),
    .I3(Sdrc_data_len_i[0]) 
);
defparam n982_s23.INIT=16'hD4DD;
  LUT4 n982_s26 (
    .F(n982_31),
    .I0(I_sdrc_addr[4]),
    .I1(Sdrc_data_len_i[4]),
    .I2(I_sdrc_addr[5]),
    .I3(Sdrc_data_len_i[5]) 
);
defparam n982_s26.INIT=16'h0777;
  LUT4 n982_s27 (
    .F(n982_32),
    .I0(Column_remain_len_wrd[4]),
    .I1(Sdrc_data_len_i[4]),
    .I2(Column_remain_len_wrd[5]),
    .I3(Sdrc_data_len_i[5]) 
);
defparam n982_s27.INIT=16'hB0BB;
  LUT4 n982_s28 (
    .F(n982_33),
    .I0(Sdrc_data_len_i[5]),
    .I1(n985_4),
    .I2(Sdrc_data_len_i[7]),
    .I3(n983_4) 
);
defparam n982_s28.INIT=16'hB0BB;
  LUT3 n648_s14 (
    .F(n648_20),
    .I0(Count_data_len_0_wr[5]),
    .I1(Count_data_len_0_wr[4]),
    .I2(Count_data_len_0_wr[3]) 
);
defparam n648_s14.INIT=8'h80;
  LUT4 n982_s29 (
    .F(n982_34),
    .I0(Column_remain_len_wrd[2]),
    .I1(Sdrc_data_len_i[2]),
    .I2(Column_remain_len_wrd[3]),
    .I3(Sdrc_data_len_i[3]) 
);
defparam n982_s29.INIT=16'hB0BB;
  LUT4 n982_s30 (
    .F(n982_35),
    .I0(I_sdrc_addr[2]),
    .I1(Sdrc_data_len_i[2]),
    .I2(I_sdrc_addr[3]),
    .I3(Sdrc_data_len_i[3]) 
);
defparam n982_s30.INIT=16'h0777;
  LUT4 n982_s31 (
    .F(n982_36),
    .I0(Sdrc_data_len_i[3]),
    .I1(Column_remain_len_wrd[3]),
    .I2(Sdrc_data_len_i[4]),
    .I3(Column_remain_len_wrd[4]) 
);
defparam n982_s31.INIT=16'hB0BB;
  LUT4 n982_s32 (
    .F(n982_37),
    .I0(I_sdrc_addr[3]),
    .I1(Sdrc_data_len_i[3]),
    .I2(I_sdrc_addr[4]),
    .I3(Sdrc_data_len_i[4]) 
);
defparam n982_s32.INIT=16'hEEE0;
  LUT4 n95_s16 (
    .F(n95_22),
    .I0(\User_model_state.STATE_WRITE_2 ),
    .I1(Count_data_len_0_wr[7]),
    .I2(Data_len_0_wrd[7]),
    .I3(n245_32) 
);
defparam n95_s16.INIT=16'h0445;
  LUT4 O_ctrl_fsm_addr_col_7_s5 (
    .F(O_ctrl_fsm_addr_col_7_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[7]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_7_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_6_s5 (
    .F(O_ctrl_fsm_addr_col_6_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[6]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_6_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_5_s5 (
    .F(O_ctrl_fsm_addr_col_5_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[5]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_5_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_4_s5 (
    .F(O_ctrl_fsm_addr_col_4_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[4]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_4_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_3_s5 (
    .F(O_ctrl_fsm_addr_col_3_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[3]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_3_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_2_s5 (
    .F(O_ctrl_fsm_addr_col_2_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[2]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_2_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_1_s5 (
    .F(O_ctrl_fsm_addr_col_1_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[1]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_1_s5.INIT=16'h8F00;
  LUT4 O_ctrl_fsm_addr_col_0_s5 (
    .F(O_ctrl_fsm_addr_col_0_8),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(Sdrc_addr_i[0]),
    .I2(n570_13),
    .I3(O_ctrl_fsm_addr_bk_1_7) 
);
defparam O_ctrl_fsm_addr_col_0_s5.INIT=16'h8F00;
  LUT4 n648_s15 (
    .F(n648_22),
    .I0(Count_data_len_0_wr[5]),
    .I1(Count_data_len_0_wr[4]),
    .I2(Count_data_len_0_wr[3]),
    .I3(n654_20) 
);
defparam n648_s15.INIT=16'h8000;
  LUT3 n95_s17 (
    .F(n95_24),
    .I0(Count_buffer_rd[2]),
    .I1(Count_buffer_rd[1]),
    .I2(Count_buffer_rd[0]) 
);
defparam n95_s17.INIT=8'h80;
  LUT3 \User_model_state.STATE_READ_s8  (
    .F(\User_model_state.STATE_READ_14 ),
    .I0(Sdrc_wr_n_i_reg),
    .I1(Sdrc_rd_n_i_reg),
    .I2(\User_model_state.STATE_IDLE ) 
);
defparam \User_model_state.STATE_READ_s8 .INIT=8'h80;
  LUT3 n562_s17 (
    .F(n562_23),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(\User_model_state.STATE_WRITE ),
    .I2(\User_model_state.STATE_READ_WAIT ) 
);
defparam n562_s17.INIT=8'h01;
  LUT4 n654_s14 (
    .F(n654_20),
    .I0(O_ctrl_fsm_data_31_8),
    .I1(Count_data_len_0_wr[2]),
    .I2(Count_data_len_0_wr[1]),
    .I3(Count_data_len_0_wr[0]) 
);
defparam n654_s14.INIT=16'h4000;
  LUT4 n556_s23 (
    .F(n556_28),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(ctrl_fsm_busy_n),
    .I2(ctrl_fsm_wrd_done),
    .I3(Double_wrd_flag) 
);
defparam n556_s23.INIT=16'h2000;
  LUT4 n554_s24 (
    .F(n554_29),
    .I0(\User_model_state.STATE_READ_WAIT ),
    .I1(ctrl_fsm_busy_n),
    .I2(ctrl_fsm_wrd_done),
    .I3(Double_wrd_flag) 
);
defparam n554_s24.INIT=16'h2000;
  LUT4 \User_model_state.STATE_READ_s10  (
    .F(\User_model_state.STATE_READ_18 ),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(\User_model_state.STATE_READ_WAIT ),
    .I2(\User_model_state.STATE_WRITE_2 ),
    .I3(\User_model_state.STATE_READ_2_WAIT ) 
);
defparam \User_model_state.STATE_READ_s10 .INIT=16'h0001;
  LUT3 n559_s16 (
    .F(n559_22),
    .I0(\User_model_state.STATE_WAITING ),
    .I1(\User_model_state.STATE_WRITE_2 ),
    .I2(\User_model_state.STATE_READ_2_WAIT ) 
);
defparam n559_s16.INIT=8'h01;
  LUT4 n982_s33 (
    .F(n982_39),
    .I0(n982_36),
    .I1(n982_37),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n982_s33.INIT=16'h5333;
  LUT4 n982_s34 (
    .F(n982_41),
    .I0(n982_34),
    .I1(n982_35),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n982_s34.INIT=16'h5333;
  LUT4 n982_s35 (
    .F(n982_43),
    .I0(n982_31),
    .I1(n982_32),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n982_s35.INIT=16'h3555;
  LUT4 n988_s2 (
    .F(n988_6),
    .I0(I_sdrc_addr[2]),
    .I1(Column_remain_len_wrd[2]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n988_s2.INIT=16'h3AAA;
  LUT4 n987_s2 (
    .F(n987_6),
    .I0(I_sdrc_addr[3]),
    .I1(Column_remain_len_wrd[3]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n987_s2.INIT=16'h3AAA;
  LUT4 n986_s2 (
    .F(n986_6),
    .I0(I_sdrc_addr[4]),
    .I1(Column_remain_len_wrd[4]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n986_s2.INIT=16'h3AAA;
  LUT4 n984_s2 (
    .F(n984_6),
    .I0(I_sdrc_addr[6]),
    .I1(Column_remain_len_wrd[6]),
    .I2(I_sdrc_wr_n),
    .I3(I_sdrc_rd_n) 
);
defparam n984_s2.INIT=16'hC555;
  LUT3 n1714_s2 (
    .F(n1714_6),
    .I0(I_sdrc_wr_n),
    .I1(I_sdrc_rd_n),
    .I2(I_sdrc_rst_n) 
);
defparam n1714_s2.INIT=8'h70;
  LUT4 n648_s16 (
    .F(n648_24),
    .I0(n654_16),
    .I1(n648_20),
    .I2(\User_model_state.STATE_WRITE ),
    .I3(\User_model_state.STATE_WRITE_2 ) 
);
defparam n648_s16.INIT=16'h7770;
  LUT3 n98_s13 (
    .F(n98_18),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(\User_model_state.STATE_WRITE_2 ),
    .I2(n95_22) 
);
defparam n98_s13.INIT=8'h0E;
  LUT4 n97_s12 (
    .F(n97_17),
    .I0(\User_model_state.STATE_WRITE ),
    .I1(\User_model_state.STATE_WRITE_2 ),
    .I2(n97_14),
    .I3(n97_15) 
);
defparam n97_s12.INIT=16'hFFE0;
  LUT4 n648_s17 (
    .F(n648_26),
    .I0(\User_model_state.STATE_WRITE_WAIT ),
    .I1(\User_model_state.STATE_WRITE_2_WAIT ),
    .I2(\User_model_state.STATE_WRITE ),
    .I3(\User_model_state.STATE_WRITE_2 ) 
);
defparam n648_s17.INIT=16'hFFFE;
  LUT3 n95_s18 (
    .F(n95_26),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(\User_model_state.STATE_WRITE ),
    .I2(\User_model_state.STATE_WRITE_2 ) 
);
defparam n95_s18.INIT=8'hFE;
  LUT2 n1692_s1 (
    .F(n1692_5),
    .I0(I_sdrc_rst_n),
    .I1(\User_model_state.STATE_IDLE ) 
);
defparam n1692_s1.INIT=4'h8;
  LUT3 n565_s14 (
    .F(n565_19),
    .I0(n565_21),
    .I1(n562_28),
    .I2(Count_ACTIVE2RW_DELAY[1]) 
);
defparam n565_s14.INIT=8'hBA;
  LUT3 n565_s15 (
    .F(n565_21),
    .I0(Count_ACTIVE2RW_DELAY[1]),
    .I1(n562_20),
    .I2(Count_ACTIVE2RW_DELAY[0]) 
);
defparam n565_s15.INIT=8'h12;
  LUT3 n568_s15 (
    .F(n568_21),
    .I0(n562_20),
    .I1(Count_ACTIVE2RW_DELAY[0]),
    .I2(n562_23) 
);
defparam n568_s15.INIT=8'h9F;
  LUT4 n559_s17 (
    .F(n559_24),
    .I0(n562_23),
    .I1(\User_model_state.STATE_WAITING ),
    .I2(\User_model_state.STATE_WRITE_2 ),
    .I3(\User_model_state.STATE_READ_2_WAIT ) 
);
defparam n559_s17.INIT=16'hFFFD;
  LUT4 n562_s19 (
    .F(n562_28),
    .I0(n562_20),
    .I1(\User_model_state.STATE_IDLE ),
    .I2(\User_model_state.STATE_WRITE ),
    .I3(\User_model_state.STATE_READ_WAIT ) 
);
defparam n562_s19.INIT=16'hFFFD;
  LUT4 O_ctrl_fsm_addr_bk_1_s4 (
    .F(O_ctrl_fsm_addr_bk_1_7),
    .I0(\User_model_state.STATE_IDLE ),
    .I1(\User_model_state.STATE_WRITE ),
    .I2(\User_model_state.STATE_READ_WAIT ),
    .I3(I_sdrc_rst_n) 
);
defparam O_ctrl_fsm_addr_bk_1_s4.INIT=16'hFE00;
  LUT4 n129_s5 (
    .F(n129_13),
    .I0(I_sdrc_rst_n),
    .I1(\User_model_state.STATE_IDLE ),
    .I2(Addr_row_reg[0]),
    .I3(Sdrc_addr_i[8]) 
);
defparam n129_s5.INIT=16'h70F8;
  DFFC Count_buffer_wr_3_s0 (
    .Q(Count_buffer_wr[3]),
    .D(n11_4),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_buffer_wr_3_s0.INIT=1'b0;
  DFFC Count_buffer_wr_2_s0 (
    .Q(Count_buffer_wr[2]),
    .D(n12_4),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_buffer_wr_2_s0.INIT=1'b0;
  DFFC Count_buffer_wr_1_s0 (
    .Q(Count_buffer_wr[1]),
    .D(n13_4),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_buffer_wr_1_s0.INIT=1'b0;
  DFFC Count_buffer_wr_0_s0 (
    .Q(Count_buffer_wr[0]),
    .D(n14_6),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_buffer_wr_0_s0.INIT=1'b0;
  DFFCE O_ctrl_double_wrd_flag_s0 (
    .Q(ctrl_double_wrd_flag),
    .D(n1594_3),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_IDLE ),
    .CLEAR(n316_6) 
);
  DFFC \User_model_state.STATE_IDLE_s0  (
    .Q(\User_model_state.STATE_IDLE ),
    .D(n547_20),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFE O_ctrl_fsm_addr_bk_1_s0 (
    .Q(ctrl_fsm_addr_bk[1]),
    .D(n570_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_bk_0_s0 (
    .Q(ctrl_fsm_addr_bk[0]),
    .D(n572_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_10_s0 (
    .Q(ctrl_fsm_addr_row[10]),
    .D(n574_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_9_s0 (
    .Q(ctrl_fsm_addr_row[9]),
    .D(n576_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_8_s0 (
    .Q(ctrl_fsm_addr_row[8]),
    .D(n578_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_7_s0 (
    .Q(ctrl_fsm_addr_row[7]),
    .D(n580_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_6_s0 (
    .Q(ctrl_fsm_addr_row[6]),
    .D(n582_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_5_s0 (
    .Q(ctrl_fsm_addr_row[5]),
    .D(n584_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_4_s0 (
    .Q(ctrl_fsm_addr_row[4]),
    .D(n586_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_3_s0 (
    .Q(ctrl_fsm_addr_row[3]),
    .D(n588_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_2_s0 (
    .Q(ctrl_fsm_addr_row[2]),
    .D(n590_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_1_s0 (
    .Q(ctrl_fsm_addr_row[1]),
    .D(n592_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_row_0_s0 (
    .Q(ctrl_fsm_addr_row[0]),
    .D(n594_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_addr_col_7_s0 (
    .Q(ctrl_fsm_addr_col[7]),
    .D(n596_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_7_8) 
);
  DFFE O_ctrl_fsm_addr_col_6_s0 (
    .Q(ctrl_fsm_addr_col[6]),
    .D(n598_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_6_8) 
);
  DFFE O_ctrl_fsm_addr_col_5_s0 (
    .Q(ctrl_fsm_addr_col[5]),
    .D(n600_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_5_8) 
);
  DFFE O_ctrl_fsm_addr_col_4_s0 (
    .Q(ctrl_fsm_addr_col[4]),
    .D(n602_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_4_8) 
);
  DFFE O_ctrl_fsm_addr_col_3_s0 (
    .Q(ctrl_fsm_addr_col[3]),
    .D(n604_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_3_8) 
);
  DFFE O_ctrl_fsm_addr_col_2_s0 (
    .Q(ctrl_fsm_addr_col[2]),
    .D(n606_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_2_8) 
);
  DFFE O_ctrl_fsm_addr_col_1_s0 (
    .Q(ctrl_fsm_addr_col[1]),
    .D(n608_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_1_8) 
);
  DFFE O_ctrl_fsm_addr_col_0_s0 (
    .Q(ctrl_fsm_addr_col[0]),
    .D(n610_20),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_col_0_8) 
);
  DFFE Addr_row_reg_10_s0 (
    .Q(Addr_row_reg[10]),
    .D(n119_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_9_s0 (
    .Q(Addr_row_reg[9]),
    .D(n120_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_8_s0 (
    .Q(Addr_row_reg[8]),
    .D(n121_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_7_s0 (
    .Q(Addr_row_reg[7]),
    .D(n122_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_6_s0 (
    .Q(Addr_row_reg[6]),
    .D(n123_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_5_s0 (
    .Q(Addr_row_reg[5]),
    .D(n124_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_4_s0 (
    .Q(Addr_row_reg[4]),
    .D(n125_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_3_s0 (
    .Q(Addr_row_reg[3]),
    .D(n126_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_2_s0 (
    .Q(Addr_row_reg[2]),
    .D(n127_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_row_reg_1_s0 (
    .Q(Addr_row_reg[1]),
    .D(n128_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_bank_reg_1_s0 (
    .Q(Addr_bank_reg[1]),
    .D(n117_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE Addr_bank_reg_0_s0 (
    .Q(Addr_bank_reg[0]),
    .D(n118_1),
    .CLK(I_sdrc_clk),
    .CE(n1692_5) 
);
  DFFE O_ctrl_fsm_burst_num_7_s0 (
    .Q(ctrl_fsm_data_len[7]),
    .D(n625_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_6_s0 (
    .Q(ctrl_fsm_data_len[6]),
    .D(n627_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_5_s0 (
    .Q(ctrl_fsm_data_len[5]),
    .D(n629_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_4_s0 (
    .Q(ctrl_fsm_data_len[4]),
    .D(n631_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_3_s0 (
    .Q(ctrl_fsm_data_len[3]),
    .D(n633_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_2_s0 (
    .Q(ctrl_fsm_data_len[2]),
    .D(n635_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_1_s0 (
    .Q(ctrl_fsm_data_len[1]),
    .D(n637_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFE O_ctrl_fsm_burst_num_0_s0 (
    .Q(ctrl_fsm_data_len[0]),
    .D(n639_12),
    .CLK(I_sdrc_clk),
    .CE(O_ctrl_fsm_addr_bk_1_7) 
);
  DFFC O_sdrc_rd_flag_s0 (
    .Q(O_sdrc_rd_valid),
    .D(ctrl_fsm_data_valid),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFC Double_wrd_flag_s0 (
    .Q(Double_wrd_flag),
    .D(n982_22),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFP Sdrc_wr_n_i_s0 (
    .Q(Sdrc_wr_n_i),
    .D(I_sdrc_wr_n),
    .CLK(I_sdrc_clk),
    .PRESET(n316_6) 
);
  DFFP Sdrc_rd_n_i_s0 (
    .Q(Sdrc_rd_n_i),
    .D(I_sdrc_rd_n),
    .CLK(I_sdrc_clk),
    .PRESET(n316_6) 
);
  DFFE O_user_data_31_s0 (
    .Q(O_sdrc_data[31]),
    .D(ctrl_fsm_data1[31]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_30_s0 (
    .Q(O_sdrc_data[30]),
    .D(ctrl_fsm_data1[30]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_29_s0 (
    .Q(O_sdrc_data[29]),
    .D(ctrl_fsm_data1[29]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_28_s0 (
    .Q(O_sdrc_data[28]),
    .D(ctrl_fsm_data1[28]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_27_s0 (
    .Q(O_sdrc_data[27]),
    .D(ctrl_fsm_data1[27]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_26_s0 (
    .Q(O_sdrc_data[26]),
    .D(ctrl_fsm_data1[26]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_25_s0 (
    .Q(O_sdrc_data[25]),
    .D(ctrl_fsm_data1[25]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_24_s0 (
    .Q(O_sdrc_data[24]),
    .D(ctrl_fsm_data1[24]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_23_s0 (
    .Q(O_sdrc_data[23]),
    .D(ctrl_fsm_data1[23]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_22_s0 (
    .Q(O_sdrc_data[22]),
    .D(ctrl_fsm_data1[22]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_21_s0 (
    .Q(O_sdrc_data[21]),
    .D(ctrl_fsm_data1[21]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_20_s0 (
    .Q(O_sdrc_data[20]),
    .D(ctrl_fsm_data1[20]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_19_s0 (
    .Q(O_sdrc_data[19]),
    .D(ctrl_fsm_data1[19]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_18_s0 (
    .Q(O_sdrc_data[18]),
    .D(ctrl_fsm_data1[18]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_17_s0 (
    .Q(O_sdrc_data[17]),
    .D(ctrl_fsm_data1[17]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_16_s0 (
    .Q(O_sdrc_data[16]),
    .D(ctrl_fsm_data1[16]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_15_s0 (
    .Q(O_sdrc_data[15]),
    .D(ctrl_fsm_data1[15]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_14_s0 (
    .Q(O_sdrc_data[14]),
    .D(ctrl_fsm_data1[14]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_13_s0 (
    .Q(O_sdrc_data[13]),
    .D(ctrl_fsm_data1[13]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_12_s0 (
    .Q(O_sdrc_data[12]),
    .D(ctrl_fsm_data1[12]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_11_s0 (
    .Q(O_sdrc_data[11]),
    .D(ctrl_fsm_data1[11]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_10_s0 (
    .Q(O_sdrc_data[10]),
    .D(ctrl_fsm_data1[10]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_9_s0 (
    .Q(O_sdrc_data[9]),
    .D(ctrl_fsm_data1[9]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_8_s0 (
    .Q(O_sdrc_data[8]),
    .D(ctrl_fsm_data1[8]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_7_s0 (
    .Q(O_sdrc_data[7]),
    .D(ctrl_fsm_data1[7]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_6_s0 (
    .Q(O_sdrc_data[6]),
    .D(ctrl_fsm_data1[6]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_5_s0 (
    .Q(O_sdrc_data[5]),
    .D(ctrl_fsm_data1[5]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_4_s0 (
    .Q(O_sdrc_data[4]),
    .D(ctrl_fsm_data1[4]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_3_s0 (
    .Q(O_sdrc_data[3]),
    .D(ctrl_fsm_data1[3]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_2_s0 (
    .Q(O_sdrc_data[2]),
    .D(ctrl_fsm_data1[2]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_1_s0 (
    .Q(O_sdrc_data[1]),
    .D(ctrl_fsm_data1[1]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE O_user_data_0_s0 (
    .Q(O_sdrc_data[0]),
    .D(ctrl_fsm_data1[0]),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE sdrc_init_done_done_s0 (
    .Q(O_sdrc_init_done),
    .D(ctrl_fsm_init),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Sdrc_wr_n_i_reg_s0 (
    .Q(Sdrc_wr_n_i_reg),
    .D(Sdrc_wr_n_i),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Sdrc_rd_n_i_reg_s0 (
    .Q(Sdrc_rd_n_i_reg),
    .D(Sdrc_rd_n_i),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Sdrc_data_len_i_7_s0 (
    .Q(Sdrc_data_len_i[7]),
    .D(I_sdrc_data_len[7]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_6_s0 (
    .Q(Sdrc_data_len_i[6]),
    .D(I_sdrc_data_len[6]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_5_s0 (
    .Q(Sdrc_data_len_i[5]),
    .D(I_sdrc_data_len[5]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_4_s0 (
    .Q(Sdrc_data_len_i[4]),
    .D(I_sdrc_data_len[4]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_3_s0 (
    .Q(Sdrc_data_len_i[3]),
    .D(I_sdrc_data_len[3]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_2_s0 (
    .Q(Sdrc_data_len_i[2]),
    .D(I_sdrc_data_len[2]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_1_s0 (
    .Q(Sdrc_data_len_i[1]),
    .D(I_sdrc_data_len[1]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_data_len_i_0_s0 (
    .Q(Sdrc_data_len_i[0]),
    .D(I_sdrc_data_len[0]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_20_s0 (
    .Q(Sdrc_addr_i[20]),
    .D(I_sdrc_addr[20]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_19_s0 (
    .Q(Sdrc_addr_i[19]),
    .D(I_sdrc_addr[19]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_18_s0 (
    .Q(Sdrc_addr_i[18]),
    .D(I_sdrc_addr[18]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_17_s0 (
    .Q(Sdrc_addr_i[17]),
    .D(I_sdrc_addr[17]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_16_s0 (
    .Q(Sdrc_addr_i[16]),
    .D(I_sdrc_addr[16]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_15_s0 (
    .Q(Sdrc_addr_i[15]),
    .D(I_sdrc_addr[15]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_14_s0 (
    .Q(Sdrc_addr_i[14]),
    .D(I_sdrc_addr[14]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_13_s0 (
    .Q(Sdrc_addr_i[13]),
    .D(I_sdrc_addr[13]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_12_s0 (
    .Q(Sdrc_addr_i[12]),
    .D(I_sdrc_addr[12]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_11_s0 (
    .Q(Sdrc_addr_i[11]),
    .D(I_sdrc_addr[11]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_10_s0 (
    .Q(Sdrc_addr_i[10]),
    .D(I_sdrc_addr[10]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_9_s0 (
    .Q(Sdrc_addr_i[9]),
    .D(I_sdrc_addr[9]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_8_s0 (
    .Q(Sdrc_addr_i[8]),
    .D(I_sdrc_addr[8]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_7_s0 (
    .Q(Sdrc_addr_i[7]),
    .D(I_sdrc_addr[7]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_6_s0 (
    .Q(Sdrc_addr_i[6]),
    .D(I_sdrc_addr[6]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_5_s0 (
    .Q(Sdrc_addr_i[5]),
    .D(I_sdrc_addr[5]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_4_s0 (
    .Q(Sdrc_addr_i[4]),
    .D(I_sdrc_addr[4]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_3_s0 (
    .Q(Sdrc_addr_i[3]),
    .D(I_sdrc_addr[3]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_2_s0 (
    .Q(Sdrc_addr_i[2]),
    .D(I_sdrc_addr[2]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_1_s0 (
    .Q(Sdrc_addr_i[1]),
    .D(I_sdrc_addr[1]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Sdrc_addr_i_0_s0 (
    .Q(Sdrc_addr_i[0]),
    .D(I_sdrc_addr[0]),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_7_s0 (
    .Q(Column_remain_len_wrd[7]),
    .D(n1276_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_6_s0 (
    .Q(Column_remain_len_wrd[6]),
    .D(n1277_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_5_s0 (
    .Q(Column_remain_len_wrd[5]),
    .D(n1278_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_4_s0 (
    .Q(Column_remain_len_wrd[4]),
    .D(n1279_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_3_s0 (
    .Q(Column_remain_len_wrd[3]),
    .D(n1280_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_2_s0 (
    .Q(Column_remain_len_wrd[2]),
    .D(n1281_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_1_s0 (
    .Q(Column_remain_len_wrd[1]),
    .D(n1282_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Column_remain_len_wrd_0_s0 (
    .Q(Column_remain_len_wrd[0]),
    .D(n1283_6),
    .CLK(I_sdrc_clk),
    .CE(n1714_6) 
);
  DFFE Data_len_1_wrd_7_s0 (
    .Q(Data_len_1_wrd[7]),
    .D(n974_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_6_s0 (
    .Q(Data_len_1_wrd[6]),
    .D(n975_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_5_s0 (
    .Q(Data_len_1_wrd[5]),
    .D(n976_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_4_s0 (
    .Q(Data_len_1_wrd[4]),
    .D(n977_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_3_s0 (
    .Q(Data_len_1_wrd[3]),
    .D(n978_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_2_s0 (
    .Q(Data_len_1_wrd[2]),
    .D(n979_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_1_s0 (
    .Q(Data_len_1_wrd[1]),
    .D(n980_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_1_wrd_0_s0 (
    .Q(Data_len_1_wrd[0]),
    .D(n981_1),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_7_s0 (
    .Q(Data_len_0_wrd[7]),
    .D(n983_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_6_s0 (
    .Q(Data_len_0_wrd[6]),
    .D(n984_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_5_s0 (
    .Q(Data_len_0_wrd[5]),
    .D(n985_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_4_s0 (
    .Q(Data_len_0_wrd[4]),
    .D(n986_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_3_s0 (
    .Q(Data_len_0_wrd[3]),
    .D(n987_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_2_s0 (
    .Q(Data_len_0_wrd[2]),
    .D(n988_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_1_s0 (
    .Q(Data_len_0_wrd[1]),
    .D(n989_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFE Data_len_0_wrd_0_s0 (
    .Q(Data_len_0_wrd[0]),
    .D(n990_3),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFFC O_sdrc_busy_n_s0 (
    .Q(O_sdrc_busy_n),
    .D(n9_3),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFCE O_sdrc_wrd_ack_s2 (
    .Q(O_sdrc_wrd_ack),
    .D(\User_model_state.STATE_IDLE ),
    .CLK(I_sdrc_clk),
    .CE(O_sdrc_wrd_ack_6),
    .CLEAR(n316_6) 
);
defparam O_sdrc_wrd_ack_s2.INIT=1'b0;
  DFFCE Count_buffer_rd_3_s2 (
    .Q(Count_buffer_rd[3]),
    .D(n95_15),
    .CLK(I_sdrc_clk),
    .CE(n95_26),
    .CLEAR(n316_6) 
);
defparam Count_buffer_rd_3_s2.INIT=1'b0;
  DFFCE Count_buffer_rd_2_s2 (
    .Q(Count_buffer_rd[2]),
    .D(n96_13),
    .CLK(I_sdrc_clk),
    .CE(n95_26),
    .CLEAR(n316_6) 
);
defparam Count_buffer_rd_2_s2.INIT=1'b0;
  DFFCE Count_buffer_rd_1_s2 (
    .Q(Count_buffer_rd[1]),
    .D(n97_17),
    .CLK(I_sdrc_clk),
    .CE(n95_26),
    .CLEAR(n316_6) 
);
defparam Count_buffer_rd_1_s2.INIT=1'b0;
  DFFCE Count_buffer_rd_0_s2 (
    .Q(Count_buffer_rd[0]),
    .D(n98_13),
    .CLK(I_sdrc_clk),
    .CE(n95_26),
    .CLEAR(n316_6) 
);
defparam Count_buffer_rd_0_s2.INIT=1'b0;
  DFFCE Count_ACTIVE2RW_DELAY_2_s1 (
    .Q(Count_ACTIVE2RW_DELAY[2]),
    .D(n562_18),
    .CLK(I_sdrc_clk),
    .CE(n562_28),
    .CLEAR(n316_6) 
);
defparam Count_ACTIVE2RW_DELAY_2_s1.INIT=1'b0;
  DFFPE O_ctrl_fsm_rd_n_s4 (
    .Q(ctrl_fsm_rd_n),
    .D(n645_15),
    .CLK(I_sdrc_clk),
    .CE(n645_13),
    .PRESET(n316_6) 
);
defparam O_ctrl_fsm_rd_n_s4.INIT=1'b1;
  DFFPE O_ctrl_fsm_wr_n_s4 (
    .Q(ctrl_fsm_wr_n),
    .D(n642_15),
    .CLK(I_sdrc_clk),
    .CE(n642_13),
    .PRESET(n316_6) 
);
defparam O_ctrl_fsm_wr_n_s4.INIT=1'b1;
  DFFCE User_busy_flag_n_s1 (
    .Q(User_busy_flag_n),
    .D(n559_17),
    .CLK(I_sdrc_clk),
    .CE(n559_24),
    .CLEAR(n316_6) 
);
defparam User_busy_flag_n_s1.INIT=1'b0;
  DFFCE Count_data_len_0_wr_7_s4 (
    .Q(Count_data_len_0_wr[7]),
    .D(n648_17),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_7_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_6_s4 (
    .Q(Count_data_len_0_wr[6]),
    .D(n651_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_6_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_5_s4 (
    .Q(Count_data_len_0_wr[5]),
    .D(n654_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_5_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_4_s4 (
    .Q(Count_data_len_0_wr[4]),
    .D(n657_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_4_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_3_s4 (
    .Q(Count_data_len_0_wr[3]),
    .D(n660_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_3_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_2_s4 (
    .Q(Count_data_len_0_wr[2]),
    .D(n663_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_2_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_1_s4 (
    .Q(Count_data_len_0_wr[1]),
    .D(n666_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_1_s4.INIT=1'b0;
  DFFCE Count_data_len_0_wr_0_s4 (
    .Q(Count_data_len_0_wr[0]),
    .D(n669_15),
    .CLK(I_sdrc_clk),
    .CE(n648_26),
    .CLEAR(n316_6) 
);
defparam Count_data_len_0_wr_0_s4.INIT=1'b0;
  DFFCE \User_model_state.STATE_READ_s1  (
    .Q(\User_model_state.STATE_READ ),
    .D(n548_24),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_READ_s1 .INIT=1'b0;
  DFFCE \User_model_state.STATE_WRITE_WAIT_s1  (
    .Q(\User_model_state.STATE_WRITE_WAIT ),
    .D(n549_24),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_WRITE_WAIT_s1 .INIT=1'b0;
  DFFCE \User_model_state.STATE_WRITE_s2  (
    .Q(\User_model_state.STATE_WRITE ),
    .D(n550_25),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_WRITE_s2 .INIT=1'b0;
  DFFCE \User_model_state.STATE_WRITE_2_s2  (
    .Q(\User_model_state.STATE_WRITE_2 ),
    .D(n551_25),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_WRITE_2_s2 .INIT=1'b0;
  DFFCE \User_model_state.STATE_READ_WAIT_s2  (
    .Q(\User_model_state.STATE_READ_WAIT ),
    .D(n553_25),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_READ_WAIT_s2 .INIT=1'b0;
  DFFCE \User_model_state.STATE_READ_2_s1  (
    .Q(\User_model_state.STATE_READ_2 ),
    .D(n554_29),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_READ_2_s1 .INIT=1'b0;
  DFFCE \User_model_state.STATE_READ_2_WAIT_s2  (
    .Q(\User_model_state.STATE_READ_2_WAIT ),
    .D(n555_25),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_READ_2_WAIT_s2 .INIT=1'b0;
  DFFCE \User_model_state.STATE_WRITE_2_WAIT_s1  (
    .Q(\User_model_state.STATE_WRITE_2_WAIT ),
    .D(n556_28),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .CLEAR(n316_6) 
);
defparam \User_model_state.STATE_WRITE_2_WAIT_s1 .INIT=1'b0;
  DFFPE \User_model_state.STATE_WAITING_s4  (
    .Q(\User_model_state.STATE_WAITING ),
    .D(GND),
    .CLK(I_sdrc_clk),
    .CE(\User_model_state.STATE_WAITING_10 ),
    .PRESET(n316_6) 
);
defparam \User_model_state.STATE_WAITING_s4 .INIT=1'b1;
  DFFE User_data_i_0_s2 (
    .Q(User_data_i_0_5),
    .D(User_data_i_0_24),
    .CLK(I_sdrc_clk),
    .CE(I_sdrc_rst_n) 
);
  DFF Addr_row_reg_0_s1 (
    .Q(Addr_row_reg[0]),
    .D(n129_13),
    .CLK(I_sdrc_clk) 
);
defparam Addr_row_reg_0_s1.INIT=1'b0;
  DFFC Count_ACTIVE2RW_DELAY_1_s2 (
    .Q(Count_ACTIVE2RW_DELAY[1]),
    .D(n565_19),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_ACTIVE2RW_DELAY_1_s2.INIT=1'b0;
  DFFC Count_ACTIVE2RW_DELAY_0_s2 (
    .Q(Count_ACTIVE2RW_DELAY[0]),
    .D(n568_21),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_ACTIVE2RW_DELAY_0_s2.INIT=1'b0;
  SDPX9B Buffer_data_in_Buffer_data_in_0_0_s (
    .DO({ctrl_fsm_dqm[3:0],ctrl_fsm_data0[31:0]}),
    .DI({Dqm_data_i_reg[3:0],User_data_i_reg[31:0]}),
    .BLKSELA({GND,GND,GND}),
    .BLKSELB({GND,GND,GND}),
    .ADA({GND,GND,GND,GND,GND,Count_buffer_wr[3:0],GND,VCC,VCC,VCC,VCC}),
    .ADB({GND,GND,GND,GND,GND,Count_buffer_rd[3:0],GND,GND,GND,GND,GND}),
    .CLKA(I_sdrc_clk),
    .CLKB(I_sdrc_clk),
    .CEA(I_sdrc_rst_n),
    .CEB(O_ctrl_fsm_data_31_7),
    .OCE(GND),
    .RESETA(GND),
    .RESETB(GND) 
);
defparam Buffer_data_in_Buffer_data_in_0_0_s.BIT_WIDTH_0=36;
defparam Buffer_data_in_Buffer_data_in_0_0_s.BIT_WIDTH_1=36;
defparam Buffer_data_in_Buffer_data_in_0_0_s.READ_MODE=1'b0;
defparam Buffer_data_in_Buffer_data_in_0_0_s.RESET_MODE="SYNC";
defparam Buffer_data_in_Buffer_data_in_0_0_s.BLK_SEL_0=3'b000;
defparam Buffer_data_in_Buffer_data_in_0_0_s.BLK_SEL_1=3'b000;
  RAM16S4 User_data_i_0_s4 (
    .DO(User_data_i_reg[3:0]),
    .DI(I_sdrc_data[3:0]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s6 (
    .DO(User_data_i_reg[7:4]),
    .DI(I_sdrc_data[7:4]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s8 (
    .DO(User_data_i_reg[11:8]),
    .DI(I_sdrc_data[11:8]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s10 (
    .DO(User_data_i_reg[15:12]),
    .DI(I_sdrc_data[15:12]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s12 (
    .DO(User_data_i_reg[19:16]),
    .DI(I_sdrc_data[19:16]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s14 (
    .DO(User_data_i_reg[23:20]),
    .DI(I_sdrc_data[23:20]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s16 (
    .DO(User_data_i_reg[27:24]),
    .DI(I_sdrc_data[27:24]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 User_data_i_0_s18 (
    .DO(User_data_i_reg[31:28]),
    .DI(I_sdrc_data[31:28]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  RAM16S4 Dqm_data_i_0_s4 (
    .DO(Dqm_data_i_reg[3:0]),
    .DI(I_sdrc_dqm[3:0]),
    .AD({GND,GND,GND,User_data_i_0_5}),
    .WRE(I_sdrc_rst_n),
    .CLK(I_sdrc_clk) 
);
  ALU n245_s16 (
    .SUM(n245_17_SUM),
    .COUT(n245_20),
    .I0(VCC),
    .I1(Count_data_len_0_wr[0]),
    .I3(GND),
    .CIN(Data_len_0_wrd[0]) 
);
defparam n245_s16.ALU_MODE=1;
  ALU n245_s17 (
    .SUM(n245_18_SUM),
    .COUT(n245_22),
    .I0(Data_len_0_wrd[1]),
    .I1(Count_data_len_0_wr[1]),
    .I3(GND),
    .CIN(n245_20) 
);
defparam n245_s17.ALU_MODE=1;
  ALU n245_s18 (
    .SUM(n245_19_SUM),
    .COUT(n245_24),
    .I0(Data_len_0_wrd[2]),
    .I1(Count_data_len_0_wr[2]),
    .I3(GND),
    .CIN(n245_22) 
);
defparam n245_s18.ALU_MODE=1;
  ALU n245_s19 (
    .SUM(n245_20_SUM),
    .COUT(n245_26),
    .I0(Data_len_0_wrd[3]),
    .I1(Count_data_len_0_wr[3]),
    .I3(GND),
    .CIN(n245_24) 
);
defparam n245_s19.ALU_MODE=1;
  ALU n245_s20 (
    .SUM(n245_21_SUM),
    .COUT(n245_28),
    .I0(Data_len_0_wrd[4]),
    .I1(Count_data_len_0_wr[4]),
    .I3(GND),
    .CIN(n245_26) 
);
defparam n245_s20.ALU_MODE=1;
  ALU n245_s21 (
    .SUM(n245_22_SUM),
    .COUT(n245_30),
    .I0(Data_len_0_wrd[5]),
    .I1(Count_data_len_0_wr[5]),
    .I3(GND),
    .CIN(n245_28) 
);
defparam n245_s21.ALU_MODE=1;
  ALU n245_s22 (
    .SUM(n245_23_SUM),
    .COUT(n245_32),
    .I0(Data_len_0_wrd[6]),
    .I1(Count_data_len_0_wr[6]),
    .I3(GND),
    .CIN(n245_30) 
);
defparam n245_s22.ALU_MODE=1;
  ALU n435_s16 (
    .SUM(n435_17_SUM),
    .COUT(n435_20),
    .I0(VCC),
    .I1(Count_data_len_0_wr[0]),
    .I3(GND),
    .CIN(Data_len_1_wrd[0]) 
);
defparam n435_s16.ALU_MODE=1;
  ALU n435_s17 (
    .SUM(n435_18_SUM),
    .COUT(n435_22),
    .I0(Data_len_1_wrd[1]),
    .I1(Count_data_len_0_wr[1]),
    .I3(GND),
    .CIN(n435_20) 
);
defparam n435_s17.ALU_MODE=1;
  ALU n435_s18 (
    .SUM(n435_19_SUM),
    .COUT(n435_24),
    .I0(Data_len_1_wrd[2]),
    .I1(Count_data_len_0_wr[2]),
    .I3(GND),
    .CIN(n435_22) 
);
defparam n435_s18.ALU_MODE=1;
  ALU n435_s19 (
    .SUM(n435_20_SUM),
    .COUT(n435_26),
    .I0(Data_len_1_wrd[3]),
    .I1(Count_data_len_0_wr[3]),
    .I3(GND),
    .CIN(n435_24) 
);
defparam n435_s19.ALU_MODE=1;
  ALU n435_s20 (
    .SUM(n435_21_SUM),
    .COUT(n435_28),
    .I0(Data_len_1_wrd[4]),
    .I1(Count_data_len_0_wr[4]),
    .I3(GND),
    .CIN(n435_26) 
);
defparam n435_s20.ALU_MODE=1;
  ALU n435_s21 (
    .SUM(n435_22_SUM),
    .COUT(n435_30),
    .I0(Data_len_1_wrd[5]),
    .I1(Count_data_len_0_wr[5]),
    .I3(GND),
    .CIN(n435_28) 
);
defparam n435_s21.ALU_MODE=1;
  ALU n435_s22 (
    .SUM(n435_23_SUM),
    .COUT(n435_32),
    .I0(Data_len_1_wrd[6]),
    .I1(Count_data_len_0_wr[6]),
    .I3(GND),
    .CIN(n435_30) 
);
defparam n435_s22.ALU_MODE=1;
  ALU n128_s (
    .SUM(n128_1),
    .COUT(n128_2),
    .I0(Sdrc_addr_i[9]),
    .I1(Sdrc_addr_i[8]),
    .I3(GND),
    .CIN(GND) 
);
defparam n128_s.ALU_MODE=0;
  ALU n127_s (
    .SUM(n127_1),
    .COUT(n127_2),
    .I0(Sdrc_addr_i[10]),
    .I1(GND),
    .I3(GND),
    .CIN(n128_2) 
);
defparam n127_s.ALU_MODE=0;
  ALU n126_s (
    .SUM(n126_1),
    .COUT(n126_2),
    .I0(Sdrc_addr_i[11]),
    .I1(GND),
    .I3(GND),
    .CIN(n127_2) 
);
defparam n126_s.ALU_MODE=0;
  ALU n125_s (
    .SUM(n125_1),
    .COUT(n125_2),
    .I0(Sdrc_addr_i[12]),
    .I1(GND),
    .I3(GND),
    .CIN(n126_2) 
);
defparam n125_s.ALU_MODE=0;
  ALU n124_s (
    .SUM(n124_1),
    .COUT(n124_2),
    .I0(Sdrc_addr_i[13]),
    .I1(GND),
    .I3(GND),
    .CIN(n125_2) 
);
defparam n124_s.ALU_MODE=0;
  ALU n123_s (
    .SUM(n123_1),
    .COUT(n123_2),
    .I0(Sdrc_addr_i[14]),
    .I1(GND),
    .I3(GND),
    .CIN(n124_2) 
);
defparam n123_s.ALU_MODE=0;
  ALU n122_s (
    .SUM(n122_1),
    .COUT(n122_2),
    .I0(Sdrc_addr_i[15]),
    .I1(GND),
    .I3(GND),
    .CIN(n123_2) 
);
defparam n122_s.ALU_MODE=0;
  ALU n121_s (
    .SUM(n121_1),
    .COUT(n121_2),
    .I0(Sdrc_addr_i[16]),
    .I1(GND),
    .I3(GND),
    .CIN(n122_2) 
);
defparam n121_s.ALU_MODE=0;
  ALU n120_s (
    .SUM(n120_1),
    .COUT(n120_2),
    .I0(Sdrc_addr_i[17]),
    .I1(GND),
    .I3(GND),
    .CIN(n121_2) 
);
defparam n120_s.ALU_MODE=0;
  ALU n119_s (
    .SUM(n119_1),
    .COUT(n119_2),
    .I0(Sdrc_addr_i[18]),
    .I1(GND),
    .I3(GND),
    .CIN(n120_2) 
);
defparam n119_s.ALU_MODE=0;
  ALU n118_s (
    .SUM(n118_1),
    .COUT(n118_2),
    .I0(Sdrc_addr_i[19]),
    .I1(GND),
    .I3(GND),
    .CIN(n119_2) 
);
defparam n118_s.ALU_MODE=0;
  ALU n117_s (
    .SUM(n117_1),
    .COUT(n117_0_COUT),
    .I0(Sdrc_addr_i[20]),
    .I1(GND),
    .I3(GND),
    .CIN(n118_2) 
);
defparam n117_s.ALU_MODE=0;
  ALU n981_s (
    .SUM(n981_1),
    .COUT(n981_2),
    .I0(Sdrc_addr_i[0]),
    .I1(Sdrc_data_len_i[0]),
    .I3(GND),
    .CIN(GND) 
);
defparam n981_s.ALU_MODE=0;
  ALU n980_s (
    .SUM(n980_1),
    .COUT(n980_2),
    .I0(Sdrc_addr_i[1]),
    .I1(Sdrc_data_len_i[1]),
    .I3(GND),
    .CIN(n981_2) 
);
defparam n980_s.ALU_MODE=0;
  ALU n979_s (
    .SUM(n979_1),
    .COUT(n979_2),
    .I0(Sdrc_addr_i[2]),
    .I1(Sdrc_data_len_i[2]),
    .I3(GND),
    .CIN(n980_2) 
);
defparam n979_s.ALU_MODE=0;
  ALU n978_s (
    .SUM(n978_1),
    .COUT(n978_2),
    .I0(Sdrc_addr_i[3]),
    .I1(Sdrc_data_len_i[3]),
    .I3(GND),
    .CIN(n979_2) 
);
defparam n978_s.ALU_MODE=0;
  ALU n977_s (
    .SUM(n977_1),
    .COUT(n977_2),
    .I0(Sdrc_addr_i[4]),
    .I1(Sdrc_data_len_i[4]),
    .I3(GND),
    .CIN(n978_2) 
);
defparam n977_s.ALU_MODE=0;
  ALU n976_s (
    .SUM(n976_1),
    .COUT(n976_2),
    .I0(Sdrc_addr_i[5]),
    .I1(Sdrc_data_len_i[5]),
    .I3(GND),
    .CIN(n977_2) 
);
defparam n976_s.ALU_MODE=0;
  ALU n975_s (
    .SUM(n975_1),
    .COUT(n975_2),
    .I0(Sdrc_addr_i[6]),
    .I1(Sdrc_data_len_i[6]),
    .I3(GND),
    .CIN(n976_2) 
);
defparam n975_s.ALU_MODE=0;
  ALU n974_s (
    .SUM(n974_1),
    .COUT(n974_0_COUT),
    .I0(Sdrc_addr_i[7]),
    .I1(Sdrc_data_len_i[7]),
    .I3(GND),
    .CIN(n975_2) 
);
defparam n974_s.ALU_MODE=0;
  INV n1276_s3 (
    .O(n1276_6),
    .I(I_sdrc_addr[7]) 
);
  INV n1277_s3 (
    .O(n1277_6),
    .I(I_sdrc_addr[6]) 
);
  INV n1278_s3 (
    .O(n1278_6),
    .I(I_sdrc_addr[5]) 
);
  INV n1279_s3 (
    .O(n1279_6),
    .I(I_sdrc_addr[4]) 
);
  INV n1280_s3 (
    .O(n1280_6),
    .I(I_sdrc_addr[3]) 
);
  INV n1281_s3 (
    .O(n1281_6),
    .I(I_sdrc_addr[2]) 
);
  INV n1282_s3 (
    .O(n1282_6),
    .I(I_sdrc_addr[1]) 
);
  INV n1283_s3 (
    .O(n1283_6),
    .I(I_sdrc_addr[0]) 
);
  INV n14_s2 (
    .O(n14_6),
    .I(Count_buffer_wr[0]) 
);
  INV User_data_i_0_s24 (
    .O(User_data_i_0_24),
    .I(User_data_i_0_5) 
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
endmodule /* \~user_interface.sdram_int  */
module \~autorefresh.sdram_int  (
  I_sdrc_clk,
  n316_6,
  autorefresh_ack,
  autorefresh_req,
  autorefresh_req_a
)
;
input I_sdrc_clk;
input n316_6;
input autorefresh_ack;
output autorefresh_req;
output autorefresh_req_a;
wire n73_3;
wire n52_6;
wire n49_6;
wire n47_6;
wire n55_5;
wire n73_4;
wire n51_7;
wire n49_7;
wire n46_7;
wire n45_7;
wire n44_7;
wire n55_6;
wire n73_7;
wire Count_autorefresh_11_10;
wire n48_9;
wire n50_9;
wire n44_10;
wire n45_11;
wire n46_12;
wire n48_14;
wire n50_12;
wire n51_10;
wire n53_9;
wire Count_autorefresh_11_21;
wire n73_10;
wire n54_16;
wire Count_autorefresh_11_23;
wire n54_18;
wire O_autorefresh_req_5;
wire [10:0] Count_autorefresh;
wire VCC;
wire GND;
  LUT3 n73_s0 (
    .F(n73_3),
    .I0(n73_4),
    .I1(Count_autorefresh[4]),
    .I2(n73_10) 
);
defparam n73_s0.INIT=8'h40;
  LUT4 n52_s2 (
    .F(n52_6),
    .I0(Count_autorefresh[0]),
    .I1(Count_autorefresh[1]),
    .I2(Count_autorefresh[2]),
    .I3(n54_18) 
);
defparam n52_s2.INIT=16'h7800;
  LUT4 n49_s2 (
    .F(n49_6),
    .I0(n49_7),
    .I1(n51_7),
    .I2(Count_autorefresh[5]),
    .I3(n54_18) 
);
defparam n49_s2.INIT=16'h7800;
  LUT4 n47_s2 (
    .F(n47_6),
    .I0(Count_autorefresh[6]),
    .I1(n48_9),
    .I2(Count_autorefresh[7]),
    .I3(n54_18) 
);
defparam n47_s2.INIT=16'h7800;
  LUT4 n55_s1 (
    .F(n55_5),
    .I0(Count_autorefresh[0]),
    .I1(n73_10),
    .I2(n55_6),
    .I3(n49_7) 
);
defparam n55_s1.INIT=16'h8000;
  LUT3 n73_s1 (
    .F(n73_4),
    .I0(Count_autorefresh[1]),
    .I1(Count_autorefresh[2]),
    .I2(Count_autorefresh[3]) 
);
defparam n73_s1.INIT=8'hE3;
  LUT3 n51_s3 (
    .F(n51_7),
    .I0(Count_autorefresh[0]),
    .I1(Count_autorefresh[1]),
    .I2(Count_autorefresh[2]) 
);
defparam n51_s3.INIT=8'h80;
  LUT2 n49_s3 (
    .F(n49_7),
    .I0(Count_autorefresh[3]),
    .I1(Count_autorefresh[4]) 
);
defparam n49_s3.INIT=4'h8;
  LUT3 n46_s3 (
    .F(n46_7),
    .I0(Count_autorefresh[6]),
    .I1(Count_autorefresh[7]),
    .I2(n48_9) 
);
defparam n46_s3.INIT=8'h80;
  LUT4 n45_s3 (
    .F(n45_7),
    .I0(Count_autorefresh[6]),
    .I1(Count_autorefresh[7]),
    .I2(Count_autorefresh[8]),
    .I3(n48_9) 
);
defparam n45_s3.INIT=16'h8000;
  LUT2 n44_s3 (
    .F(n44_7),
    .I0(Count_autorefresh[9]),
    .I1(n45_7) 
);
defparam n44_s3.INIT=4'h8;
  LUT2 n55_s2 (
    .F(n55_6),
    .I0(Count_autorefresh[1]),
    .I1(Count_autorefresh[2]) 
);
defparam n55_s2.INIT=4'h1;
  LUT4 n73_s4 (
    .F(n73_7),
    .I0(Count_autorefresh[5]),
    .I1(Count_autorefresh[6]),
    .I2(Count_autorefresh[7]),
    .I3(Count_autorefresh[8]) 
);
defparam n73_s4.INIT=16'h0001;
  LUT4 Count_autorefresh_11_s5 (
    .F(Count_autorefresh_11_10),
    .I0(n55_6),
    .I1(n49_7),
    .I2(n73_7),
    .I3(Count_autorefresh[10]) 
);
defparam Count_autorefresh_11_s5.INIT=16'h4F00;
  LUT4 n48_s4 (
    .F(n48_9),
    .I0(Count_autorefresh[5]),
    .I1(Count_autorefresh[3]),
    .I2(Count_autorefresh[4]),
    .I3(n51_7) 
);
defparam n48_s4.INIT=16'h8000;
  LUT4 n50_s4 (
    .F(n50_9),
    .I0(Count_autorefresh[3]),
    .I1(Count_autorefresh[0]),
    .I2(Count_autorefresh[1]),
    .I3(Count_autorefresh[2]) 
);
defparam n50_s4.INIT=16'h8000;
  LUT4 n44_s5 (
    .F(n44_10),
    .I0(Count_autorefresh_11_21),
    .I1(Count_autorefresh[10]),
    .I2(n44_7),
    .I3(autorefresh_ack) 
);
defparam n44_s5.INIT=16'h006C;
  LUT4 n45_s5 (
    .F(n45_11),
    .I0(autorefresh_ack),
    .I1(Count_autorefresh[9]),
    .I2(n45_7),
    .I3(Count_autorefresh_11_10) 
);
defparam n45_s5.INIT=16'h5414;
  LUT4 n46_s6 (
    .F(n46_12),
    .I0(Count_autorefresh_11_21),
    .I1(autorefresh_ack),
    .I2(Count_autorefresh[8]),
    .I3(n46_7) 
);
defparam n46_s6.INIT=16'h1230;
  LUT4 n48_s7 (
    .F(n48_14),
    .I0(Count_autorefresh_11_21),
    .I1(autorefresh_ack),
    .I2(Count_autorefresh[6]),
    .I3(n48_9) 
);
defparam n48_s7.INIT=16'h1230;
  LUT4 n50_s6 (
    .F(n50_12),
    .I0(Count_autorefresh_11_21),
    .I1(autorefresh_ack),
    .I2(Count_autorefresh[4]),
    .I3(n50_9) 
);
defparam n50_s6.INIT=16'h1230;
  LUT4 n51_s5 (
    .F(n51_10),
    .I0(Count_autorefresh_11_21),
    .I1(autorefresh_ack),
    .I2(Count_autorefresh[3]),
    .I3(n51_7) 
);
defparam n51_s5.INIT=16'h1230;
  LUT4 n53_s4 (
    .F(n53_9),
    .I0(Count_autorefresh_11_21),
    .I1(autorefresh_ack),
    .I2(Count_autorefresh[1]),
    .I3(Count_autorefresh[0]) 
);
defparam n53_s4.INIT=16'h1230;
  LUT2 Count_autorefresh_11_s7 (
    .F(Count_autorefresh_11_21),
    .I0(Count_autorefresh[9]),
    .I1(Count_autorefresh_11_10) 
);
defparam Count_autorefresh_11_s7.INIT=4'h7;
  LUT3 n73_s5 (
    .F(n73_10),
    .I0(Count_autorefresh[9]),
    .I1(Count_autorefresh[10]),
    .I2(n73_7) 
);
defparam n73_s5.INIT=8'h80;
  LUT4 n54_s8 (
    .F(n54_16),
    .I0(Count_autorefresh[9]),
    .I1(Count_autorefresh_11_10),
    .I2(autorefresh_ack),
    .I3(Count_autorefresh[0]) 
);
defparam n54_s8.INIT=16'h0807;
  LUT3 Count_autorefresh_11_s8 (
    .F(Count_autorefresh_11_23),
    .I0(Count_autorefresh[9]),
    .I1(Count_autorefresh_11_10),
    .I2(autorefresh_ack) 
);
defparam Count_autorefresh_11_s8.INIT=8'hF7;
  LUT3 n54_s9 (
    .F(n54_18),
    .I0(autorefresh_ack),
    .I1(Count_autorefresh[9]),
    .I2(Count_autorefresh_11_10) 
);
defparam n54_s9.INIT=8'h15;
  DFFCE O_autorefresh_req_s0 (
    .Q(autorefresh_req),
    .D(n55_5),
    .CLK(I_sdrc_clk),
    .CE(O_autorefresh_req_5),
    .CLEAR(n316_6) 
);
  DFFC O_autorefresh_req_a_s0 (
    .Q(autorefresh_req_a),
    .D(n73_3),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
  DFFCE Count_autorefresh_7_s1 (
    .Q(Count_autorefresh[7]),
    .D(n47_6),
    .CLK(I_sdrc_clk),
    .CE(Count_autorefresh_11_23),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_7_s1.INIT=1'b0;
  DFFCE Count_autorefresh_5_s1 (
    .Q(Count_autorefresh[5]),
    .D(n49_6),
    .CLK(I_sdrc_clk),
    .CE(Count_autorefresh_11_23),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_5_s1.INIT=1'b0;
  DFFCE Count_autorefresh_2_s1 (
    .Q(Count_autorefresh[2]),
    .D(n52_6),
    .CLK(I_sdrc_clk),
    .CE(Count_autorefresh_11_23),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_2_s1.INIT=1'b0;
  DFFC Count_autorefresh_10_s3 (
    .Q(Count_autorefresh[10]),
    .D(n44_10),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_10_s3.INIT=1'b0;
  DFFC Count_autorefresh_9_s3 (
    .Q(Count_autorefresh[9]),
    .D(n45_11),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_9_s3.INIT=1'b0;
  DFFC Count_autorefresh_8_s3 (
    .Q(Count_autorefresh[8]),
    .D(n46_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_8_s3.INIT=1'b0;
  DFFC Count_autorefresh_6_s3 (
    .Q(Count_autorefresh[6]),
    .D(n48_14),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_6_s3.INIT=1'b0;
  DFFC Count_autorefresh_4_s3 (
    .Q(Count_autorefresh[4]),
    .D(n50_12),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_4_s3.INIT=1'b0;
  DFFC Count_autorefresh_3_s3 (
    .Q(Count_autorefresh[3]),
    .D(n51_10),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_3_s3.INIT=1'b0;
  DFFC Count_autorefresh_1_s3 (
    .Q(Count_autorefresh[1]),
    .D(n53_9),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_1_s3.INIT=1'b0;
  DFFC Count_autorefresh_0_s3 (
    .Q(Count_autorefresh[0]),
    .D(n54_16),
    .CLK(I_sdrc_clk),
    .CLEAR(n316_6) 
);
defparam Count_autorefresh_0_s3.INIT=1'b0;
  INV O_autorefresh_req_s3 (
    .O(O_autorefresh_req_5),
    .I(autorefresh_ack) 
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
endmodule /* \~autorefresh.sdram_int  */
module \~top.sdram_int  (
  I_sdrc_clk,
  I_sdrc_selfrefresh,
  I_sdrc_power_down,
  I_sdrc_rst_n,
  I_sdrc_wr_n,
  I_sdrc_rd_n,
  I_sdrc_data_len,
  I_sdrc_addr,
  I_sdrc_data,
  I_sdrc_dqm,
  IO_sdram_dq_in,
  O_sdram_cke,
  O_sdram_wen_n,
  O_sdram_cas_n,
  O_sdram_ras_n,
  IO_sdram_dq_0_6,
  O_sdrc_rd_valid,
  O_sdrc_init_done,
  O_sdrc_busy_n,
  O_sdrc_wrd_ack,
  O_sdram_addr,
  O_sdram_ba,
  O_sdram_dqm,
  O_sdrc_data,
  Ctrl_fsm_data
)
;
input I_sdrc_clk;
input I_sdrc_selfrefresh;
input I_sdrc_power_down;
input I_sdrc_rst_n;
input I_sdrc_wr_n;
input I_sdrc_rd_n;
input [7:0] I_sdrc_data_len;
input [20:0] I_sdrc_addr;
input [31:0] I_sdrc_data;
input [3:0] I_sdrc_dqm;
input [31:0] IO_sdram_dq_in;
output O_sdram_cke;
output O_sdram_wen_n;
output O_sdram_cas_n;
output O_sdram_ras_n;
output IO_sdram_dq_0_6;
output O_sdrc_rd_valid;
output O_sdrc_init_done;
output O_sdrc_busy_n;
output O_sdrc_wrd_ack;
output [10:0] O_sdram_addr;
output [1:0] O_sdram_ba;
output [3:0] O_sdram_dqm;
output [31:0] O_sdrc_data;
output [31:0] Ctrl_fsm_data;
wire ctrl_fsm_init;
wire ctrl_fsm_busy_n;
wire ctrl_fsm_data_valid;
wire ctrl_fsm_wrd_done;
wire autorefresh_ack;
wire n316_6;
wire ctrl_double_wrd_flag;
wire ctrl_fsm_rd_n;
wire ctrl_fsm_wr_n;
wire autorefresh_req;
wire autorefresh_req_a;
wire [31:0] ctrl_fsm_data1;
wire [1:0] ctrl_fsm_addr_bk;
wire [10:0] ctrl_fsm_addr_row;
wire [7:0] ctrl_fsm_addr_col;
wire [7:0] ctrl_fsm_data_len;
wire [31:0] ctrl_fsm_data0;
wire [3:0] ctrl_fsm_dqm;
wire VCC;
wire GND;
  \~control_fsm.sdram_int  U0 (
    .I_sdrc_clk(I_sdrc_clk),
    .I_sdrc_selfrefresh(I_sdrc_selfrefresh),
    .ctrl_fsm_wr_n(ctrl_fsm_wr_n),
    .ctrl_fsm_rd_n(ctrl_fsm_rd_n),
    .I_sdrc_power_down(I_sdrc_power_down),
    .ctrl_double_wrd_flag(ctrl_double_wrd_flag),
    .autorefresh_req(autorefresh_req),
    .autorefresh_req_a(autorefresh_req_a),
    .I_sdrc_rst_n(I_sdrc_rst_n),
    .ctrl_fsm_data0(ctrl_fsm_data0[31:0]),
    .ctrl_fsm_addr_bk(ctrl_fsm_addr_bk[1:0]),
    .ctrl_fsm_addr_row(ctrl_fsm_addr_row[10:0]),
    .ctrl_fsm_data_len(ctrl_fsm_data_len[7:0]),
    .IO_sdram_dq_in(IO_sdram_dq_in[31:0]),
    .ctrl_fsm_addr_col(ctrl_fsm_addr_col[7:0]),
    .ctrl_fsm_dqm(ctrl_fsm_dqm[3:0]),
    .ctrl_fsm_init(ctrl_fsm_init),
    .ctrl_fsm_busy_n(ctrl_fsm_busy_n),
    .ctrl_fsm_data_valid(ctrl_fsm_data_valid),
    .O_sdram_cke(O_sdram_cke),
    .ctrl_fsm_wrd_done(ctrl_fsm_wrd_done),
    .autorefresh_ack(autorefresh_ack),
    .O_sdram_wen_n(O_sdram_wen_n),
    .O_sdram_cas_n(O_sdram_cas_n),
    .O_sdram_ras_n(O_sdram_ras_n),
    .n316_6(n316_6),
    .IO_sdram_dq_0_6(IO_sdram_dq_0_6),
    .O_sdram_addr(O_sdram_addr[10:0]),
    .O_sdram_ba(O_sdram_ba[1:0]),
    .O_sdram_dqm(O_sdram_dqm[3:0]),
    .Ctrl_fsm_data(Ctrl_fsm_data[31:0]),
    .ctrl_fsm_data1(ctrl_fsm_data1[31:0])
);
  \~user_interface.sdram_int  U1 (
    .I_sdrc_clk(I_sdrc_clk),
    .n316_6(n316_6),
    .ctrl_fsm_data_valid(ctrl_fsm_data_valid),
    .I_sdrc_wr_n(I_sdrc_wr_n),
    .I_sdrc_rd_n(I_sdrc_rd_n),
    .I_sdrc_rst_n(I_sdrc_rst_n),
    .ctrl_fsm_init(ctrl_fsm_init),
    .autorefresh_req_a(autorefresh_req_a),
    .ctrl_fsm_wrd_done(ctrl_fsm_wrd_done),
    .ctrl_fsm_busy_n(ctrl_fsm_busy_n),
    .I_sdrc_data_len(I_sdrc_data_len[7:0]),
    .I_sdrc_addr(I_sdrc_addr[20:0]),
    .I_sdrc_data(I_sdrc_data[31:0]),
    .I_sdrc_dqm(I_sdrc_dqm[3:0]),
    .ctrl_fsm_data1(ctrl_fsm_data1[31:0]),
    .ctrl_double_wrd_flag(ctrl_double_wrd_flag),
    .O_sdrc_rd_valid(O_sdrc_rd_valid),
    .O_sdrc_init_done(O_sdrc_init_done),
    .O_sdrc_busy_n(O_sdrc_busy_n),
    .O_sdrc_wrd_ack(O_sdrc_wrd_ack),
    .ctrl_fsm_rd_n(ctrl_fsm_rd_n),
    .ctrl_fsm_wr_n(ctrl_fsm_wr_n),
    .O_sdrc_data(O_sdrc_data[31:0]),
    .ctrl_fsm_addr_bk(ctrl_fsm_addr_bk[1:0]),
    .ctrl_fsm_addr_row(ctrl_fsm_addr_row[10:0]),
    .ctrl_fsm_addr_col(ctrl_fsm_addr_col[7:0]),
    .ctrl_fsm_data_len(ctrl_fsm_data_len[7:0]),
    .ctrl_fsm_data0(ctrl_fsm_data0[31:0]),
    .ctrl_fsm_dqm(ctrl_fsm_dqm[3:0])
);
  \~autorefresh.sdram_int  U2 (
    .I_sdrc_clk(I_sdrc_clk),
    .n316_6(n316_6),
    .autorefresh_ack(autorefresh_ack),
    .autorefresh_req(autorefresh_req),
    .autorefresh_req_a(autorefresh_req_a)
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
endmodule /* \~top.sdram_int  */
module sdram_int (
  O_sdram_clk,
  O_sdram_cke,
  O_sdram_cs_n,
  O_sdram_cas_n,
  O_sdram_ras_n,
  O_sdram_wen_n,
  O_sdram_dqm,
  O_sdram_addr,
  O_sdram_ba,
  IO_sdram_dq,
  I_sdrc_rst_n,
  I_sdrc_clk,
  I_sdram_clk,
  I_sdrc_selfrefresh,
  I_sdrc_power_down,
  I_sdrc_wr_n,
  I_sdrc_rd_n,
  I_sdrc_addr,
  I_sdrc_data_len,
  I_sdrc_dqm,
  I_sdrc_data,
  O_sdrc_data,
  O_sdrc_init_done,
  O_sdrc_busy_n,
  O_sdrc_rd_valid,
  O_sdrc_wrd_ack
)
;
output O_sdram_clk;
output O_sdram_cke;
output O_sdram_cs_n;
output O_sdram_cas_n;
output O_sdram_ras_n;
output O_sdram_wen_n;
output [3:0] O_sdram_dqm;
output [10:0] O_sdram_addr;
output [1:0] O_sdram_ba;
inout [31:0] IO_sdram_dq;
input I_sdrc_rst_n;
input I_sdrc_clk;
input I_sdram_clk;
input I_sdrc_selfrefresh;
input I_sdrc_power_down;
input I_sdrc_wr_n;
input I_sdrc_rd_n;
input [20:0] I_sdrc_addr;
input [7:0] I_sdrc_data_len;
input [3:0] I_sdrc_dqm;
input [31:0] I_sdrc_data;
output [31:0] O_sdrc_data;
output O_sdrc_init_done;
output O_sdrc_busy_n;
output O_sdrc_rd_valid;
output O_sdrc_wrd_ack;
wire IO_sdram_dq_0_6;
wire [31:0] IO_sdram_dq_in;
wire [31:0] Ctrl_fsm_data;
wire VCC;
wire GND;
  IOBUF IO_sdram_dq_0_iobuf (
    .O(IO_sdram_dq_in[0]),
    .IO(IO_sdram_dq[0]),
    .I(Ctrl_fsm_data[0]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_1_iobuf (
    .O(IO_sdram_dq_in[1]),
    .IO(IO_sdram_dq[1]),
    .I(Ctrl_fsm_data[1]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_2_iobuf (
    .O(IO_sdram_dq_in[2]),
    .IO(IO_sdram_dq[2]),
    .I(Ctrl_fsm_data[2]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_3_iobuf (
    .O(IO_sdram_dq_in[3]),
    .IO(IO_sdram_dq[3]),
    .I(Ctrl_fsm_data[3]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_4_iobuf (
    .O(IO_sdram_dq_in[4]),
    .IO(IO_sdram_dq[4]),
    .I(Ctrl_fsm_data[4]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_5_iobuf (
    .O(IO_sdram_dq_in[5]),
    .IO(IO_sdram_dq[5]),
    .I(Ctrl_fsm_data[5]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_6_iobuf (
    .O(IO_sdram_dq_in[6]),
    .IO(IO_sdram_dq[6]),
    .I(Ctrl_fsm_data[6]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_7_iobuf (
    .O(IO_sdram_dq_in[7]),
    .IO(IO_sdram_dq[7]),
    .I(Ctrl_fsm_data[7]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_8_iobuf (
    .O(IO_sdram_dq_in[8]),
    .IO(IO_sdram_dq[8]),
    .I(Ctrl_fsm_data[8]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_9_iobuf (
    .O(IO_sdram_dq_in[9]),
    .IO(IO_sdram_dq[9]),
    .I(Ctrl_fsm_data[9]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_10_iobuf (
    .O(IO_sdram_dq_in[10]),
    .IO(IO_sdram_dq[10]),
    .I(Ctrl_fsm_data[10]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_11_iobuf (
    .O(IO_sdram_dq_in[11]),
    .IO(IO_sdram_dq[11]),
    .I(Ctrl_fsm_data[11]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_12_iobuf (
    .O(IO_sdram_dq_in[12]),
    .IO(IO_sdram_dq[12]),
    .I(Ctrl_fsm_data[12]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_13_iobuf (
    .O(IO_sdram_dq_in[13]),
    .IO(IO_sdram_dq[13]),
    .I(Ctrl_fsm_data[13]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_14_iobuf (
    .O(IO_sdram_dq_in[14]),
    .IO(IO_sdram_dq[14]),
    .I(Ctrl_fsm_data[14]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_15_iobuf (
    .O(IO_sdram_dq_in[15]),
    .IO(IO_sdram_dq[15]),
    .I(Ctrl_fsm_data[15]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_16_iobuf (
    .O(IO_sdram_dq_in[16]),
    .IO(IO_sdram_dq[16]),
    .I(Ctrl_fsm_data[16]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_17_iobuf (
    .O(IO_sdram_dq_in[17]),
    .IO(IO_sdram_dq[17]),
    .I(Ctrl_fsm_data[17]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_18_iobuf (
    .O(IO_sdram_dq_in[18]),
    .IO(IO_sdram_dq[18]),
    .I(Ctrl_fsm_data[18]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_19_iobuf (
    .O(IO_sdram_dq_in[19]),
    .IO(IO_sdram_dq[19]),
    .I(Ctrl_fsm_data[19]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_20_iobuf (
    .O(IO_sdram_dq_in[20]),
    .IO(IO_sdram_dq[20]),
    .I(Ctrl_fsm_data[20]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_21_iobuf (
    .O(IO_sdram_dq_in[21]),
    .IO(IO_sdram_dq[21]),
    .I(Ctrl_fsm_data[21]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_22_iobuf (
    .O(IO_sdram_dq_in[22]),
    .IO(IO_sdram_dq[22]),
    .I(Ctrl_fsm_data[22]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_23_iobuf (
    .O(IO_sdram_dq_in[23]),
    .IO(IO_sdram_dq[23]),
    .I(Ctrl_fsm_data[23]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_24_iobuf (
    .O(IO_sdram_dq_in[24]),
    .IO(IO_sdram_dq[24]),
    .I(Ctrl_fsm_data[24]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_25_iobuf (
    .O(IO_sdram_dq_in[25]),
    .IO(IO_sdram_dq[25]),
    .I(Ctrl_fsm_data[25]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_26_iobuf (
    .O(IO_sdram_dq_in[26]),
    .IO(IO_sdram_dq[26]),
    .I(Ctrl_fsm_data[26]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_27_iobuf (
    .O(IO_sdram_dq_in[27]),
    .IO(IO_sdram_dq[27]),
    .I(Ctrl_fsm_data[27]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_28_iobuf (
    .O(IO_sdram_dq_in[28]),
    .IO(IO_sdram_dq[28]),
    .I(Ctrl_fsm_data[28]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_29_iobuf (
    .O(IO_sdram_dq_in[29]),
    .IO(IO_sdram_dq[29]),
    .I(Ctrl_fsm_data[29]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_30_iobuf (
    .O(IO_sdram_dq_in[30]),
    .IO(IO_sdram_dq[30]),
    .I(Ctrl_fsm_data[30]),
    .OEN(IO_sdram_dq_0_6) 
);
  IOBUF IO_sdram_dq_31_iobuf (
    .O(IO_sdram_dq_in[31]),
    .IO(IO_sdram_dq[31]),
    .I(Ctrl_fsm_data[31]),
    .OEN(IO_sdram_dq_0_6) 
);
  \~top.sdram_int  sdrc_top_inst (
    .I_sdrc_clk(I_sdrc_clk),
    .I_sdrc_selfrefresh(I_sdrc_selfrefresh),
    .I_sdrc_power_down(I_sdrc_power_down),
    .I_sdrc_rst_n(I_sdrc_rst_n),
    .I_sdrc_wr_n(I_sdrc_wr_n),
    .I_sdrc_rd_n(I_sdrc_rd_n),
    .I_sdrc_data_len(I_sdrc_data_len[7:0]),
    .I_sdrc_addr(I_sdrc_addr[20:0]),
    .I_sdrc_data(I_sdrc_data[31:0]),
    .I_sdrc_dqm(I_sdrc_dqm[3:0]),
    .IO_sdram_dq_in(IO_sdram_dq_in[31:0]),
    .O_sdram_cke(O_sdram_cke),
    .O_sdram_wen_n(O_sdram_wen_n),
    .O_sdram_cas_n(O_sdram_cas_n),
    .O_sdram_ras_n(O_sdram_ras_n),
    .IO_sdram_dq_0_6(IO_sdram_dq_0_6),
    .O_sdrc_rd_valid(O_sdrc_rd_valid),
    .O_sdrc_init_done(O_sdrc_init_done),
    .O_sdrc_busy_n(O_sdrc_busy_n),
    .O_sdrc_wrd_ack(O_sdrc_wrd_ack),
    .O_sdram_addr(O_sdram_addr[10:0]),
    .O_sdram_ba(O_sdram_ba[1:0]),
    .O_sdram_dqm(O_sdram_dqm[3:0]),
    .O_sdrc_data(O_sdrc_data[31:0]),
    .Ctrl_fsm_data(Ctrl_fsm_data[31:0])
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
  GSR GSR (
    .GSRI(VCC) 
);
assign O_sdram_clk = I_sdram_clk;
assign O_sdram_cs_n = GND;
endmodule /* sdram_int */
