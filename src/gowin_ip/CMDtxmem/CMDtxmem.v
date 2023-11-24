//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2AR-LV18EQ144PC8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Wed Nov 22 07:26:06 2023

module CMDtxmem (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

output [8:0] dout;
input clka;
input cea;
input reseta;
input clkb;
input ceb;
input resetb;
input oce;
input [10:0] ada;
input [8:0] din;
input [10:0] adb;

wire [26:0] sdpx9b_inst_0_dout_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

SDPX9B sdpx9b_inst_0 (
    .DO({sdpx9b_inst_0_dout_w[26:0],dout[8:0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,gw_gnd,gw_gnd}),
    .BLKSELB({gw_gnd,gw_gnd,gw_gnd}),
    .ADA({ada[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]}),
    .ADB({adb[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam sdpx9b_inst_0.READ_MODE = 1'b0;
defparam sdpx9b_inst_0.BIT_WIDTH_0 = 9;
defparam sdpx9b_inst_0.BIT_WIDTH_1 = 9;
defparam sdpx9b_inst_0.BLK_SEL_0 = 3'b000;
defparam sdpx9b_inst_0.BLK_SEL_1 = 3'b000;
defparam sdpx9b_inst_0.RESET_MODE = "SYNC";
defparam sdpx9b_inst_0.INIT_RAM_00 = 288'h88D020140804023900805160108C6C2641FA8F403FFFFFFFFFFFFFEAD56AB55AAD56AB55;
defparam sdpx9b_inst_0.INIT_RAM_01 = 288'h00000000000000000000000000000003436D84403D70495F2AE5B58F6B2EDB58F6B35777;
defparam sdpx9b_inst_0.INIT_RAM_02 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_03 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_04 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_05 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_06 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_07 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_08 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_09 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_0F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_10 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_11 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_12 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_13 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_14 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_15 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_16 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_17 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_18 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_19 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_1F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_20 = 288'h88D020140FFFFE3900805160108C6C2641FA8F403FFFFFFFFFFFFFEAD56AB55AAD56AB55;
defparam sdpx9b_inst_0.INIT_RAM_21 = 288'h00000000000000000000000000000003436D84403D70495F2AE5B58F6B2EDB58F6B35777;
defparam sdpx9b_inst_0.INIT_RAM_22 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_23 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_24 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_25 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_26 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_27 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_28 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_29 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_2F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_30 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_31 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_32 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_33 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_34 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_35 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_36 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_37 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_38 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_39 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam sdpx9b_inst_0.INIT_RAM_3F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;

endmodule //CMDtxmem
