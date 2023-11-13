//
//Written by GowinSynthesis
//Product Version "V1.9.9 Beta-3"
//Mon Nov 13 17:01:54 2023

//Source file index table:
//file0 "\D:/Gowin/Gowin_V1.9.9Beta-3/IDE/ipcore/DDR/data/ddr.v"
`timescale 100 ps/100 ps
module rgmii_tx (
  din,
  clk,
  q
)
;
input [9:0] din;
input clk;
output [4:0] q;
wire \oddr_gen[0].oddr_inst_1_Q1 ;
wire \oddr_gen[1].oddr_inst_1_Q1 ;
wire \oddr_gen[2].oddr_inst_1_Q1 ;
wire \oddr_gen[3].oddr_inst_1_Q1 ;
wire \oddr_gen[4].oddr_inst_1_Q1 ;
wire VCC;
wire GND;
  ODDR \oddr_gen[0].oddr_inst  (
    .Q0(q[0]),
    .Q1(\oddr_gen[0].oddr_inst_1_Q1 ),
    .D0(din[0]),
    .D1(din[5]),
    .TX(GND),
    .CLK(clk) 
);
  ODDR \oddr_gen[1].oddr_inst  (
    .Q0(q[1]),
    .Q1(\oddr_gen[1].oddr_inst_1_Q1 ),
    .D0(din[1]),
    .D1(din[6]),
    .TX(GND),
    .CLK(clk) 
);
  ODDR \oddr_gen[2].oddr_inst  (
    .Q0(q[2]),
    .Q1(\oddr_gen[2].oddr_inst_1_Q1 ),
    .D0(din[2]),
    .D1(din[7]),
    .TX(GND),
    .CLK(clk) 
);
  ODDR \oddr_gen[3].oddr_inst  (
    .Q0(q[3]),
    .Q1(\oddr_gen[3].oddr_inst_1_Q1 ),
    .D0(din[3]),
    .D1(din[8]),
    .TX(GND),
    .CLK(clk) 
);
  ODDR \oddr_gen[4].oddr_inst  (
    .Q0(q[4]),
    .Q1(\oddr_gen[4].oddr_inst_1_Q1 ),
    .D0(din[4]),
    .D1(din[9]),
    .TX(GND),
    .CLK(clk) 
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
endmodule /* rgmii_tx */
