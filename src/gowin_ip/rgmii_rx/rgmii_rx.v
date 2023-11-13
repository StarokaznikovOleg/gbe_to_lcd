//
//Written by GowinSynthesis
//Product Version "V1.9.9 Beta-3"
//Mon Nov 13 17:01:38 2023

//Source file index table:
//file0 "\D:/Gowin/Gowin_V1.9.9Beta-3/IDE/ipcore/DDR/data/ddr.v"
`timescale 100 ps/100 ps
module rgmii_rx (
  din,
  clk,
  q
)
;
input [4:0] din;
input clk;
output [9:0] q;
wire \iodelay_gen[0].iodelay_inst_1_DF ;
wire \iodelay_gen[1].iodelay_inst_1_DF ;
wire \iodelay_gen[2].iodelay_inst_1_DF ;
wire \iodelay_gen[3].iodelay_inst_1_DF ;
wire \iodelay_gen[4].iodelay_inst_1_DF ;
wire [4:0] iodly_o;
wire VCC;
wire GND;
  IODELAY \iodelay_gen[0].iodelay_inst  (
    .DO(iodly_o[0]),
    .DF(\iodelay_gen[0].iodelay_inst_1_DF ),
    .DI(din[0]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[0].iodelay_inst .C_STATIC_DLY=63;
  IODELAY \iodelay_gen[1].iodelay_inst  (
    .DO(iodly_o[1]),
    .DF(\iodelay_gen[1].iodelay_inst_1_DF ),
    .DI(din[1]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[1].iodelay_inst .C_STATIC_DLY=63;
  IODELAY \iodelay_gen[2].iodelay_inst  (
    .DO(iodly_o[2]),
    .DF(\iodelay_gen[2].iodelay_inst_1_DF ),
    .DI(din[2]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[2].iodelay_inst .C_STATIC_DLY=63;
  IODELAY \iodelay_gen[3].iodelay_inst  (
    .DO(iodly_o[3]),
    .DF(\iodelay_gen[3].iodelay_inst_1_DF ),
    .DI(din[3]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[3].iodelay_inst .C_STATIC_DLY=63;
  IODELAY \iodelay_gen[4].iodelay_inst  (
    .DO(iodly_o[4]),
    .DF(\iodelay_gen[4].iodelay_inst_1_DF ),
    .DI(din[4]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[4].iodelay_inst .C_STATIC_DLY=63;
  IDDR \iddr_gen[0].iddr_inst  (
    .Q0(q[0]),
    .Q1(q[5]),
    .D(iodly_o[0]),
    .CLK(clk) 
);
  IDDR \iddr_gen[1].iddr_inst  (
    .Q0(q[1]),
    .Q1(q[6]),
    .D(iodly_o[1]),
    .CLK(clk) 
);
  IDDR \iddr_gen[2].iddr_inst  (
    .Q0(q[2]),
    .Q1(q[7]),
    .D(iodly_o[2]),
    .CLK(clk) 
);
  IDDR \iddr_gen[3].iddr_inst  (
    .Q0(q[3]),
    .Q1(q[8]),
    .D(iodly_o[3]),
    .CLK(clk) 
);
  IDDR \iddr_gen[4].iddr_inst  (
    .Q0(q[4]),
    .Q1(q[9]),
    .D(iodly_o[4]),
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
endmodule /* rgmii_rx */
