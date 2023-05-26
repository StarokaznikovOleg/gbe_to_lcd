//
//Written by GowinSynthesis
//Product Version "GowinSynthesis V1.9.8.07"
//Fri Oct 21 16:28:11 2022

//Source file index table:
//file0 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/DDR/data/ddr.v"
`timescale 100 ps/100 ps
module ddrout (
  din,
  clk,
  q
)
;
input [1:0] din;
input clk;
output [0:0] q;
wire \oddr_gen[0].oddr_inst_1_Q1 ;
wire VCC;
wire GND;
  ODDR \oddr_gen[0].oddr_inst  (
    .Q0(q[0]),
    .Q1(\oddr_gen[0].oddr_inst_1_Q1 ),
    .D0(din[0]),
    .D1(din[1]),
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
endmodule /* ddrout */
