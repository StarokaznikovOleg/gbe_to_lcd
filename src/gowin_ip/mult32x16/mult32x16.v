//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2AR-LV18EQ144C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Sun Oct 08 22:12:51 2023

module mult32x16 (dout, a, b, ce, clk, reset);

output [47:0] dout;
input [31:0] a;
input [15:0] b;
input ce;
input clk;
input reset;

wire [23:0] dout_w;
wire gw_vcc;

assign gw_vcc = 1'b1;

MULT36X36 mult36x36_inst (
    .DOUT({dout_w[23:0],dout[47:0]}),
    .A({a[31],a[31],a[31],a[31],a[31:0]}),
    .B({b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15],b[15:0]}),
    .ASIGN(gw_vcc),
    .BSIGN(gw_vcc),
    .CE(ce),
    .CLK(clk),
    .RESET(reset)
);

defparam mult36x36_inst.AREG = 1'b1;
defparam mult36x36_inst.BREG = 1'b1;
defparam mult36x36_inst.OUT0_REG = 1'b1;
defparam mult36x36_inst.PIPE_REG = 1'b0;
defparam mult36x36_inst.ASIGN_REG = 1'b0;
defparam mult36x36_inst.BSIGN_REG = 1'b0;
defparam mult36x36_inst.MULT_RESET_MODE = "SYNC";

endmodule //mult32x16
