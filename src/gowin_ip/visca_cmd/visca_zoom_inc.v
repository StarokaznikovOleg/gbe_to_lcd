//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2AR-LV18EQ144C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Sat Jul 20 12:28:32 2024

module visca_zoom_inc (dout, ad);

output [7:0] dout;
input [2:0] ad;

wire gw_gnd;

assign gw_gnd = 1'b0;

ROM16 rom16_inst_0 (
    .DO(dout[0]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_0.INIT_0 = 16'h006A;

ROM16 rom16_inst_1 (
    .DO(dout[1]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_1.INIT_0 = 16'h000F;

ROM16 rom16_inst_2 (
    .DO(dout[2]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_2.INIT_0 = 16'h001B;

ROM16 rom16_inst_3 (
    .DO(dout[3]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_3.INIT_0 = 16'h0002;

ROM16 rom16_inst_4 (
    .DO(dout[4]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_4.INIT_0 = 16'h0002;

ROM16 rom16_inst_5 (
    .DO(dout[5]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_5.INIT_0 = 16'h0002;

ROM16 rom16_inst_6 (
    .DO(dout[6]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_6.INIT_0 = 16'h0002;

ROM16 rom16_inst_7 (
    .DO(dout[7]),
    .AD({gw_gnd,ad[2:0]})
);

defparam rom16_inst_7.INIT_0 = 16'h0042;

endmodule //visca_zoom_inc
