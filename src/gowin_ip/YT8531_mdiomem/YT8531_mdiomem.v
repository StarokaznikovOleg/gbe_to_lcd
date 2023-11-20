//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2AR-LV18EQ144C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Sun Nov 19 23:12:36 2023

module YT8531_mdiomem (dout, clk, oce, ce, reset, ad);

output [8:0] dout;
input clk;
input oce;
input ce;
input reset;
input [10:0] ad;

wire [26:0] promx9_inst_0_dout_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

pROMX9 promx9_inst_0 (
    .DO({promx9_inst_0_dout_w[26:0],dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam promx9_inst_0.READ_MODE = 1'b0;
defparam promx9_inst_0.BIT_WIDTH = 9;
defparam promx9_inst_0.RESET_MODE = "SYNC";
defparam promx9_inst_0.INIT_RAM_00 = 288'h9003C001F00C801EA00F0064001080100320000000000000000000005842051278080380;
defparam promx9_inst_0.INIT_RAM_01 = 288'h000000000000000000000000000000000080B050080910000640F10007C032001A803C01;
defparam promx9_inst_0.INIT_RAM_02 = 288'h9003C001F01C801EA00F00E400108010072000000000000000000040580A051278080780;
defparam promx9_inst_0.INIT_RAM_03 = 288'h00000000000000000000000000000000000000000000000000000000002C340202440003;
defparam promx9_inst_0.INIT_RAM_04 = 288'h80044030005006000300C000401800040300000000000B02401E000F807000F500780320;
defparam promx9_inst_0.INIT_RAM_05 = 288'h00000000000000000000000000000000000000000000000000000000002C21500C002601;
defparam promx9_inst_0.INIT_RAM_06 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_07 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_08 = 288'h8004407000500E000301C000403800040700000000040B00401E000F80F020F500780720;
defparam promx9_inst_0.INIT_RAM_09 = 288'h00000000000000000000000000000000000000000000000000000000202C01501C002603;
defparam promx9_inst_0.INIT_RAM_0A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_0B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_0C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_0D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_0E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_0F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_10 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_11 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_12 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_13 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_14 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_15 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_16 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_17 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_18 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_19 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_1F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_20 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_21 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_22 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_23 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_24 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_25 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_26 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_27 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_28 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_29 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_2F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_30 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_31 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_32 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_33 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_34 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_35 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_36 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_37 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_38 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_39 = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3A = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3B = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3C = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3D = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3E = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
defparam promx9_inst_0.INIT_RAM_3F = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;

endmodule //YT8531_mdiomem
