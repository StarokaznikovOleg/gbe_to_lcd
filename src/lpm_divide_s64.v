//
//Written by GowinSynthesis
//Product Version "V1.9.9 Beta-3"
//Thu Nov 09 16:35:55 2023

//Source file index table:
//file0 "\D:/Gowin/Gowin_V1.9.9Beta-3/IDE/ipcore/Integer_Division/data/integer_division_wrap.v"
//file1 "\D:/Gowin/Gowin_V1.9.9Beta-3/IDE/ipcore/Integer_Division/data/integer_division.v"
`timescale 100 ps/100 ps
module lpm_divide_s64 (
  clk,
  rstn,
  dividend,
  divisor,
  quotient
)
;
input clk;
input rstn;
input [63:0] dividend;
input [63:0] divisor;
output [63:0] quotient;
wire VCC;
wire GND;
  \~integer_division.lpm_divide_s64  integer_division_inst (
    .clk(clk),
    .rstn(rstn),
    .dividend(dividend[63:0]),
    .divisor(divisor[63:0]),
    .quotient(quotient[63:0])
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
endmodule /* lpm_divide_s64 */
