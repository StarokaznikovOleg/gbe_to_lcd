//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-3
//Part Number: GW2AR-LV18EQ144C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Wed Apr 17 10:01:32 2024

module video_mem4096x32 (douta, doutb, clka, ocea, cea, reseta, wrea, clkb, oceb, ceb, resetb, wreb, ada, dina, adb, dinb);

output [31:0] douta;
output [31:0] doutb;
input clka;
input ocea;
input cea;
input reseta;
input wrea;
input clkb;
input oceb;
input ceb;
input resetb;
input wreb;
input [11:0] ada;
input [31:0] dina;
input [11:0] adb;
input [31:0] dinb;

wire [15:0] dpb_inst_0_douta;
wire [15:0] dpb_inst_0_doutb;
wire [15:0] dpb_inst_1_douta;
wire [15:0] dpb_inst_1_doutb;
wire [15:0] dpb_inst_2_douta;
wire [15:0] dpb_inst_2_doutb;
wire [15:0] dpb_inst_3_douta;
wire [15:0] dpb_inst_3_doutb;
wire [31:16] dpb_inst_4_douta;
wire [31:16] dpb_inst_4_doutb;
wire [31:16] dpb_inst_5_douta;
wire [31:16] dpb_inst_5_doutb;
wire [31:16] dpb_inst_6_douta;
wire [31:16] dpb_inst_6_doutb;
wire [31:16] dpb_inst_7_douta;
wire [31:16] dpb_inst_7_doutb;
wire dff_q_0;
wire dff_q_1;
wire dff_q_2;
wire dff_q_3;
wire mux_o_0;
wire mux_o_1;
wire mux_o_3;
wire mux_o_4;
wire mux_o_6;
wire mux_o_7;
wire mux_o_9;
wire mux_o_10;
wire mux_o_12;
wire mux_o_13;
wire mux_o_15;
wire mux_o_16;
wire mux_o_18;
wire mux_o_19;
wire mux_o_21;
wire mux_o_22;
wire mux_o_24;
wire mux_o_25;
wire mux_o_27;
wire mux_o_28;
wire mux_o_30;
wire mux_o_31;
wire mux_o_33;
wire mux_o_34;
wire mux_o_36;
wire mux_o_37;
wire mux_o_39;
wire mux_o_40;
wire mux_o_42;
wire mux_o_43;
wire mux_o_45;
wire mux_o_46;
wire mux_o_48;
wire mux_o_49;
wire mux_o_51;
wire mux_o_52;
wire mux_o_54;
wire mux_o_55;
wire mux_o_57;
wire mux_o_58;
wire mux_o_60;
wire mux_o_61;
wire mux_o_63;
wire mux_o_64;
wire mux_o_66;
wire mux_o_67;
wire mux_o_69;
wire mux_o_70;
wire mux_o_72;
wire mux_o_73;
wire mux_o_75;
wire mux_o_76;
wire mux_o_78;
wire mux_o_79;
wire mux_o_81;
wire mux_o_82;
wire mux_o_84;
wire mux_o_85;
wire mux_o_87;
wire mux_o_88;
wire mux_o_90;
wire mux_o_91;
wire mux_o_93;
wire mux_o_94;
wire mux_o_96;
wire mux_o_97;
wire mux_o_99;
wire mux_o_100;
wire mux_o_102;
wire mux_o_103;
wire mux_o_105;
wire mux_o_106;
wire mux_o_108;
wire mux_o_109;
wire mux_o_111;
wire mux_o_112;
wire mux_o_114;
wire mux_o_115;
wire mux_o_117;
wire mux_o_118;
wire mux_o_120;
wire mux_o_121;
wire mux_o_123;
wire mux_o_124;
wire mux_o_126;
wire mux_o_127;
wire mux_o_129;
wire mux_o_130;
wire mux_o_132;
wire mux_o_133;
wire mux_o_135;
wire mux_o_136;
wire mux_o_138;
wire mux_o_139;
wire mux_o_141;
wire mux_o_142;
wire mux_o_144;
wire mux_o_145;
wire mux_o_147;
wire mux_o_148;
wire mux_o_150;
wire mux_o_151;
wire mux_o_153;
wire mux_o_154;
wire mux_o_156;
wire mux_o_157;
wire mux_o_159;
wire mux_o_160;
wire mux_o_162;
wire mux_o_163;
wire mux_o_165;
wire mux_o_166;
wire mux_o_168;
wire mux_o_169;
wire mux_o_171;
wire mux_o_172;
wire mux_o_174;
wire mux_o_175;
wire mux_o_177;
wire mux_o_178;
wire mux_o_180;
wire mux_o_181;
wire mux_o_183;
wire mux_o_184;
wire mux_o_186;
wire mux_o_187;
wire mux_o_189;
wire mux_o_190;
wire cea_w;
wire ceb_w;
wire gw_vcc;
wire gw_gnd;

assign cea_w = ~wrea & cea;
assign ceb_w = ~wreb & ceb;
assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;

DPB dpb_inst_0 (
    .DOA(dpb_inst_0_douta[15:0]),
    .DOB(dpb_inst_0_doutb[15:0]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[15:0]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[15:0])
);

defparam dpb_inst_0.READ_MODE0 = 1'b0;
defparam dpb_inst_0.READ_MODE1 = 1'b0;
defparam dpb_inst_0.WRITE_MODE0 = 2'b00;
defparam dpb_inst_0.WRITE_MODE1 = 2'b00;
defparam dpb_inst_0.BIT_WIDTH_0 = 16;
defparam dpb_inst_0.BIT_WIDTH_1 = 16;
defparam dpb_inst_0.BLK_SEL_0 = 3'b000;
defparam dpb_inst_0.BLK_SEL_1 = 3'b000;
defparam dpb_inst_0.RESET_MODE = "SYNC";

DPB dpb_inst_1 (
    .DOA(dpb_inst_1_douta[15:0]),
    .DOB(dpb_inst_1_doutb[15:0]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[15:0]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[15:0])
);

defparam dpb_inst_1.READ_MODE0 = 1'b0;
defparam dpb_inst_1.READ_MODE1 = 1'b0;
defparam dpb_inst_1.WRITE_MODE0 = 2'b00;
defparam dpb_inst_1.WRITE_MODE1 = 2'b00;
defparam dpb_inst_1.BIT_WIDTH_0 = 16;
defparam dpb_inst_1.BIT_WIDTH_1 = 16;
defparam dpb_inst_1.BLK_SEL_0 = 3'b001;
defparam dpb_inst_1.BLK_SEL_1 = 3'b001;
defparam dpb_inst_1.RESET_MODE = "SYNC";

DPB dpb_inst_2 (
    .DOA(dpb_inst_2_douta[15:0]),
    .DOB(dpb_inst_2_doutb[15:0]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[15:0]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[15:0])
);

defparam dpb_inst_2.READ_MODE0 = 1'b0;
defparam dpb_inst_2.READ_MODE1 = 1'b0;
defparam dpb_inst_2.WRITE_MODE0 = 2'b00;
defparam dpb_inst_2.WRITE_MODE1 = 2'b00;
defparam dpb_inst_2.BIT_WIDTH_0 = 16;
defparam dpb_inst_2.BIT_WIDTH_1 = 16;
defparam dpb_inst_2.BLK_SEL_0 = 3'b010;
defparam dpb_inst_2.BLK_SEL_1 = 3'b010;
defparam dpb_inst_2.RESET_MODE = "SYNC";

DPB dpb_inst_3 (
    .DOA(dpb_inst_3_douta[15:0]),
    .DOB(dpb_inst_3_doutb[15:0]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[15:0]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[15:0])
);

defparam dpb_inst_3.READ_MODE0 = 1'b0;
defparam dpb_inst_3.READ_MODE1 = 1'b0;
defparam dpb_inst_3.WRITE_MODE0 = 2'b00;
defparam dpb_inst_3.WRITE_MODE1 = 2'b00;
defparam dpb_inst_3.BIT_WIDTH_0 = 16;
defparam dpb_inst_3.BIT_WIDTH_1 = 16;
defparam dpb_inst_3.BLK_SEL_0 = 3'b011;
defparam dpb_inst_3.BLK_SEL_1 = 3'b011;
defparam dpb_inst_3.RESET_MODE = "SYNC";

DPB dpb_inst_4 (
    .DOA(dpb_inst_4_douta[31:16]),
    .DOB(dpb_inst_4_doutb[31:16]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[31:16]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[31:16])
);

defparam dpb_inst_4.READ_MODE0 = 1'b0;
defparam dpb_inst_4.READ_MODE1 = 1'b0;
defparam dpb_inst_4.WRITE_MODE0 = 2'b00;
defparam dpb_inst_4.WRITE_MODE1 = 2'b00;
defparam dpb_inst_4.BIT_WIDTH_0 = 16;
defparam dpb_inst_4.BIT_WIDTH_1 = 16;
defparam dpb_inst_4.BLK_SEL_0 = 3'b000;
defparam dpb_inst_4.BLK_SEL_1 = 3'b000;
defparam dpb_inst_4.RESET_MODE = "SYNC";

DPB dpb_inst_5 (
    .DOA(dpb_inst_5_douta[31:16]),
    .DOB(dpb_inst_5_doutb[31:16]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[31:16]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[31:16])
);

defparam dpb_inst_5.READ_MODE0 = 1'b0;
defparam dpb_inst_5.READ_MODE1 = 1'b0;
defparam dpb_inst_5.WRITE_MODE0 = 2'b00;
defparam dpb_inst_5.WRITE_MODE1 = 2'b00;
defparam dpb_inst_5.BIT_WIDTH_0 = 16;
defparam dpb_inst_5.BIT_WIDTH_1 = 16;
defparam dpb_inst_5.BLK_SEL_0 = 3'b001;
defparam dpb_inst_5.BLK_SEL_1 = 3'b001;
defparam dpb_inst_5.RESET_MODE = "SYNC";

DPB dpb_inst_6 (
    .DOA(dpb_inst_6_douta[31:16]),
    .DOB(dpb_inst_6_doutb[31:16]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[31:16]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[31:16])
);

defparam dpb_inst_6.READ_MODE0 = 1'b0;
defparam dpb_inst_6.READ_MODE1 = 1'b0;
defparam dpb_inst_6.WRITE_MODE0 = 2'b00;
defparam dpb_inst_6.WRITE_MODE1 = 2'b00;
defparam dpb_inst_6.BIT_WIDTH_0 = 16;
defparam dpb_inst_6.BIT_WIDTH_1 = 16;
defparam dpb_inst_6.BLK_SEL_0 = 3'b010;
defparam dpb_inst_6.BLK_SEL_1 = 3'b010;
defparam dpb_inst_6.RESET_MODE = "SYNC";

DPB dpb_inst_7 (
    .DOA(dpb_inst_7_douta[31:16]),
    .DOB(dpb_inst_7_doutb[31:16]),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,ada[11],ada[10]}),
    .BLKSELB({gw_gnd,adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIA(dina[31:16]),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DIB(dinb[31:16])
);

defparam dpb_inst_7.READ_MODE0 = 1'b0;
defparam dpb_inst_7.READ_MODE1 = 1'b0;
defparam dpb_inst_7.WRITE_MODE0 = 2'b00;
defparam dpb_inst_7.WRITE_MODE1 = 2'b00;
defparam dpb_inst_7.BIT_WIDTH_0 = 16;
defparam dpb_inst_7.BIT_WIDTH_1 = 16;
defparam dpb_inst_7.BLK_SEL_0 = 3'b011;
defparam dpb_inst_7.BLK_SEL_1 = 3'b011;
defparam dpb_inst_7.RESET_MODE = "SYNC";

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ada[11]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(ada[10]),
  .CLK(clka),
  .CE(cea_w)
);
DFFE dff_inst_2 (
  .Q(dff_q_2),
  .D(adb[11]),
  .CLK(clkb),
  .CE(ceb_w)
);
DFFE dff_inst_3 (
  .Q(dff_q_3),
  .D(adb[10]),
  .CLK(clkb),
  .CE(ceb_w)
);
MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(dpb_inst_0_douta[0]),
  .I1(dpb_inst_1_douta[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_1 (
  .O(mux_o_1),
  .I0(dpb_inst_2_douta[0]),
  .I1(dpb_inst_3_douta[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_2 (
  .O(douta[0]),
  .I0(mux_o_0),
  .I1(mux_o_1),
  .S0(dff_q_0)
);
MUX2 mux_inst_3 (
  .O(mux_o_3),
  .I0(dpb_inst_0_douta[1]),
  .I1(dpb_inst_1_douta[1]),
  .S0(dff_q_1)
);
MUX2 mux_inst_4 (
  .O(mux_o_4),
  .I0(dpb_inst_2_douta[1]),
  .I1(dpb_inst_3_douta[1]),
  .S0(dff_q_1)
);
MUX2 mux_inst_5 (
  .O(douta[1]),
  .I0(mux_o_3),
  .I1(mux_o_4),
  .S0(dff_q_0)
);
MUX2 mux_inst_6 (
  .O(mux_o_6),
  .I0(dpb_inst_0_douta[2]),
  .I1(dpb_inst_1_douta[2]),
  .S0(dff_q_1)
);
MUX2 mux_inst_7 (
  .O(mux_o_7),
  .I0(dpb_inst_2_douta[2]),
  .I1(dpb_inst_3_douta[2]),
  .S0(dff_q_1)
);
MUX2 mux_inst_8 (
  .O(douta[2]),
  .I0(mux_o_6),
  .I1(mux_o_7),
  .S0(dff_q_0)
);
MUX2 mux_inst_9 (
  .O(mux_o_9),
  .I0(dpb_inst_0_douta[3]),
  .I1(dpb_inst_1_douta[3]),
  .S0(dff_q_1)
);
MUX2 mux_inst_10 (
  .O(mux_o_10),
  .I0(dpb_inst_2_douta[3]),
  .I1(dpb_inst_3_douta[3]),
  .S0(dff_q_1)
);
MUX2 mux_inst_11 (
  .O(douta[3]),
  .I0(mux_o_9),
  .I1(mux_o_10),
  .S0(dff_q_0)
);
MUX2 mux_inst_12 (
  .O(mux_o_12),
  .I0(dpb_inst_0_douta[4]),
  .I1(dpb_inst_1_douta[4]),
  .S0(dff_q_1)
);
MUX2 mux_inst_13 (
  .O(mux_o_13),
  .I0(dpb_inst_2_douta[4]),
  .I1(dpb_inst_3_douta[4]),
  .S0(dff_q_1)
);
MUX2 mux_inst_14 (
  .O(douta[4]),
  .I0(mux_o_12),
  .I1(mux_o_13),
  .S0(dff_q_0)
);
MUX2 mux_inst_15 (
  .O(mux_o_15),
  .I0(dpb_inst_0_douta[5]),
  .I1(dpb_inst_1_douta[5]),
  .S0(dff_q_1)
);
MUX2 mux_inst_16 (
  .O(mux_o_16),
  .I0(dpb_inst_2_douta[5]),
  .I1(dpb_inst_3_douta[5]),
  .S0(dff_q_1)
);
MUX2 mux_inst_17 (
  .O(douta[5]),
  .I0(mux_o_15),
  .I1(mux_o_16),
  .S0(dff_q_0)
);
MUX2 mux_inst_18 (
  .O(mux_o_18),
  .I0(dpb_inst_0_douta[6]),
  .I1(dpb_inst_1_douta[6]),
  .S0(dff_q_1)
);
MUX2 mux_inst_19 (
  .O(mux_o_19),
  .I0(dpb_inst_2_douta[6]),
  .I1(dpb_inst_3_douta[6]),
  .S0(dff_q_1)
);
MUX2 mux_inst_20 (
  .O(douta[6]),
  .I0(mux_o_18),
  .I1(mux_o_19),
  .S0(dff_q_0)
);
MUX2 mux_inst_21 (
  .O(mux_o_21),
  .I0(dpb_inst_0_douta[7]),
  .I1(dpb_inst_1_douta[7]),
  .S0(dff_q_1)
);
MUX2 mux_inst_22 (
  .O(mux_o_22),
  .I0(dpb_inst_2_douta[7]),
  .I1(dpb_inst_3_douta[7]),
  .S0(dff_q_1)
);
MUX2 mux_inst_23 (
  .O(douta[7]),
  .I0(mux_o_21),
  .I1(mux_o_22),
  .S0(dff_q_0)
);
MUX2 mux_inst_24 (
  .O(mux_o_24),
  .I0(dpb_inst_0_douta[8]),
  .I1(dpb_inst_1_douta[8]),
  .S0(dff_q_1)
);
MUX2 mux_inst_25 (
  .O(mux_o_25),
  .I0(dpb_inst_2_douta[8]),
  .I1(dpb_inst_3_douta[8]),
  .S0(dff_q_1)
);
MUX2 mux_inst_26 (
  .O(douta[8]),
  .I0(mux_o_24),
  .I1(mux_o_25),
  .S0(dff_q_0)
);
MUX2 mux_inst_27 (
  .O(mux_o_27),
  .I0(dpb_inst_0_douta[9]),
  .I1(dpb_inst_1_douta[9]),
  .S0(dff_q_1)
);
MUX2 mux_inst_28 (
  .O(mux_o_28),
  .I0(dpb_inst_2_douta[9]),
  .I1(dpb_inst_3_douta[9]),
  .S0(dff_q_1)
);
MUX2 mux_inst_29 (
  .O(douta[9]),
  .I0(mux_o_27),
  .I1(mux_o_28),
  .S0(dff_q_0)
);
MUX2 mux_inst_30 (
  .O(mux_o_30),
  .I0(dpb_inst_0_douta[10]),
  .I1(dpb_inst_1_douta[10]),
  .S0(dff_q_1)
);
MUX2 mux_inst_31 (
  .O(mux_o_31),
  .I0(dpb_inst_2_douta[10]),
  .I1(dpb_inst_3_douta[10]),
  .S0(dff_q_1)
);
MUX2 mux_inst_32 (
  .O(douta[10]),
  .I0(mux_o_30),
  .I1(mux_o_31),
  .S0(dff_q_0)
);
MUX2 mux_inst_33 (
  .O(mux_o_33),
  .I0(dpb_inst_0_douta[11]),
  .I1(dpb_inst_1_douta[11]),
  .S0(dff_q_1)
);
MUX2 mux_inst_34 (
  .O(mux_o_34),
  .I0(dpb_inst_2_douta[11]),
  .I1(dpb_inst_3_douta[11]),
  .S0(dff_q_1)
);
MUX2 mux_inst_35 (
  .O(douta[11]),
  .I0(mux_o_33),
  .I1(mux_o_34),
  .S0(dff_q_0)
);
MUX2 mux_inst_36 (
  .O(mux_o_36),
  .I0(dpb_inst_0_douta[12]),
  .I1(dpb_inst_1_douta[12]),
  .S0(dff_q_1)
);
MUX2 mux_inst_37 (
  .O(mux_o_37),
  .I0(dpb_inst_2_douta[12]),
  .I1(dpb_inst_3_douta[12]),
  .S0(dff_q_1)
);
MUX2 mux_inst_38 (
  .O(douta[12]),
  .I0(mux_o_36),
  .I1(mux_o_37),
  .S0(dff_q_0)
);
MUX2 mux_inst_39 (
  .O(mux_o_39),
  .I0(dpb_inst_0_douta[13]),
  .I1(dpb_inst_1_douta[13]),
  .S0(dff_q_1)
);
MUX2 mux_inst_40 (
  .O(mux_o_40),
  .I0(dpb_inst_2_douta[13]),
  .I1(dpb_inst_3_douta[13]),
  .S0(dff_q_1)
);
MUX2 mux_inst_41 (
  .O(douta[13]),
  .I0(mux_o_39),
  .I1(mux_o_40),
  .S0(dff_q_0)
);
MUX2 mux_inst_42 (
  .O(mux_o_42),
  .I0(dpb_inst_0_douta[14]),
  .I1(dpb_inst_1_douta[14]),
  .S0(dff_q_1)
);
MUX2 mux_inst_43 (
  .O(mux_o_43),
  .I0(dpb_inst_2_douta[14]),
  .I1(dpb_inst_3_douta[14]),
  .S0(dff_q_1)
);
MUX2 mux_inst_44 (
  .O(douta[14]),
  .I0(mux_o_42),
  .I1(mux_o_43),
  .S0(dff_q_0)
);
MUX2 mux_inst_45 (
  .O(mux_o_45),
  .I0(dpb_inst_0_douta[15]),
  .I1(dpb_inst_1_douta[15]),
  .S0(dff_q_1)
);
MUX2 mux_inst_46 (
  .O(mux_o_46),
  .I0(dpb_inst_2_douta[15]),
  .I1(dpb_inst_3_douta[15]),
  .S0(dff_q_1)
);
MUX2 mux_inst_47 (
  .O(douta[15]),
  .I0(mux_o_45),
  .I1(mux_o_46),
  .S0(dff_q_0)
);
MUX2 mux_inst_48 (
  .O(mux_o_48),
  .I0(dpb_inst_4_douta[16]),
  .I1(dpb_inst_5_douta[16]),
  .S0(dff_q_1)
);
MUX2 mux_inst_49 (
  .O(mux_o_49),
  .I0(dpb_inst_6_douta[16]),
  .I1(dpb_inst_7_douta[16]),
  .S0(dff_q_1)
);
MUX2 mux_inst_50 (
  .O(douta[16]),
  .I0(mux_o_48),
  .I1(mux_o_49),
  .S0(dff_q_0)
);
MUX2 mux_inst_51 (
  .O(mux_o_51),
  .I0(dpb_inst_4_douta[17]),
  .I1(dpb_inst_5_douta[17]),
  .S0(dff_q_1)
);
MUX2 mux_inst_52 (
  .O(mux_o_52),
  .I0(dpb_inst_6_douta[17]),
  .I1(dpb_inst_7_douta[17]),
  .S0(dff_q_1)
);
MUX2 mux_inst_53 (
  .O(douta[17]),
  .I0(mux_o_51),
  .I1(mux_o_52),
  .S0(dff_q_0)
);
MUX2 mux_inst_54 (
  .O(mux_o_54),
  .I0(dpb_inst_4_douta[18]),
  .I1(dpb_inst_5_douta[18]),
  .S0(dff_q_1)
);
MUX2 mux_inst_55 (
  .O(mux_o_55),
  .I0(dpb_inst_6_douta[18]),
  .I1(dpb_inst_7_douta[18]),
  .S0(dff_q_1)
);
MUX2 mux_inst_56 (
  .O(douta[18]),
  .I0(mux_o_54),
  .I1(mux_o_55),
  .S0(dff_q_0)
);
MUX2 mux_inst_57 (
  .O(mux_o_57),
  .I0(dpb_inst_4_douta[19]),
  .I1(dpb_inst_5_douta[19]),
  .S0(dff_q_1)
);
MUX2 mux_inst_58 (
  .O(mux_o_58),
  .I0(dpb_inst_6_douta[19]),
  .I1(dpb_inst_7_douta[19]),
  .S0(dff_q_1)
);
MUX2 mux_inst_59 (
  .O(douta[19]),
  .I0(mux_o_57),
  .I1(mux_o_58),
  .S0(dff_q_0)
);
MUX2 mux_inst_60 (
  .O(mux_o_60),
  .I0(dpb_inst_4_douta[20]),
  .I1(dpb_inst_5_douta[20]),
  .S0(dff_q_1)
);
MUX2 mux_inst_61 (
  .O(mux_o_61),
  .I0(dpb_inst_6_douta[20]),
  .I1(dpb_inst_7_douta[20]),
  .S0(dff_q_1)
);
MUX2 mux_inst_62 (
  .O(douta[20]),
  .I0(mux_o_60),
  .I1(mux_o_61),
  .S0(dff_q_0)
);
MUX2 mux_inst_63 (
  .O(mux_o_63),
  .I0(dpb_inst_4_douta[21]),
  .I1(dpb_inst_5_douta[21]),
  .S0(dff_q_1)
);
MUX2 mux_inst_64 (
  .O(mux_o_64),
  .I0(dpb_inst_6_douta[21]),
  .I1(dpb_inst_7_douta[21]),
  .S0(dff_q_1)
);
MUX2 mux_inst_65 (
  .O(douta[21]),
  .I0(mux_o_63),
  .I1(mux_o_64),
  .S0(dff_q_0)
);
MUX2 mux_inst_66 (
  .O(mux_o_66),
  .I0(dpb_inst_4_douta[22]),
  .I1(dpb_inst_5_douta[22]),
  .S0(dff_q_1)
);
MUX2 mux_inst_67 (
  .O(mux_o_67),
  .I0(dpb_inst_6_douta[22]),
  .I1(dpb_inst_7_douta[22]),
  .S0(dff_q_1)
);
MUX2 mux_inst_68 (
  .O(douta[22]),
  .I0(mux_o_66),
  .I1(mux_o_67),
  .S0(dff_q_0)
);
MUX2 mux_inst_69 (
  .O(mux_o_69),
  .I0(dpb_inst_4_douta[23]),
  .I1(dpb_inst_5_douta[23]),
  .S0(dff_q_1)
);
MUX2 mux_inst_70 (
  .O(mux_o_70),
  .I0(dpb_inst_6_douta[23]),
  .I1(dpb_inst_7_douta[23]),
  .S0(dff_q_1)
);
MUX2 mux_inst_71 (
  .O(douta[23]),
  .I0(mux_o_69),
  .I1(mux_o_70),
  .S0(dff_q_0)
);
MUX2 mux_inst_72 (
  .O(mux_o_72),
  .I0(dpb_inst_4_douta[24]),
  .I1(dpb_inst_5_douta[24]),
  .S0(dff_q_1)
);
MUX2 mux_inst_73 (
  .O(mux_o_73),
  .I0(dpb_inst_6_douta[24]),
  .I1(dpb_inst_7_douta[24]),
  .S0(dff_q_1)
);
MUX2 mux_inst_74 (
  .O(douta[24]),
  .I0(mux_o_72),
  .I1(mux_o_73),
  .S0(dff_q_0)
);
MUX2 mux_inst_75 (
  .O(mux_o_75),
  .I0(dpb_inst_4_douta[25]),
  .I1(dpb_inst_5_douta[25]),
  .S0(dff_q_1)
);
MUX2 mux_inst_76 (
  .O(mux_o_76),
  .I0(dpb_inst_6_douta[25]),
  .I1(dpb_inst_7_douta[25]),
  .S0(dff_q_1)
);
MUX2 mux_inst_77 (
  .O(douta[25]),
  .I0(mux_o_75),
  .I1(mux_o_76),
  .S0(dff_q_0)
);
MUX2 mux_inst_78 (
  .O(mux_o_78),
  .I0(dpb_inst_4_douta[26]),
  .I1(dpb_inst_5_douta[26]),
  .S0(dff_q_1)
);
MUX2 mux_inst_79 (
  .O(mux_o_79),
  .I0(dpb_inst_6_douta[26]),
  .I1(dpb_inst_7_douta[26]),
  .S0(dff_q_1)
);
MUX2 mux_inst_80 (
  .O(douta[26]),
  .I0(mux_o_78),
  .I1(mux_o_79),
  .S0(dff_q_0)
);
MUX2 mux_inst_81 (
  .O(mux_o_81),
  .I0(dpb_inst_4_douta[27]),
  .I1(dpb_inst_5_douta[27]),
  .S0(dff_q_1)
);
MUX2 mux_inst_82 (
  .O(mux_o_82),
  .I0(dpb_inst_6_douta[27]),
  .I1(dpb_inst_7_douta[27]),
  .S0(dff_q_1)
);
MUX2 mux_inst_83 (
  .O(douta[27]),
  .I0(mux_o_81),
  .I1(mux_o_82),
  .S0(dff_q_0)
);
MUX2 mux_inst_84 (
  .O(mux_o_84),
  .I0(dpb_inst_4_douta[28]),
  .I1(dpb_inst_5_douta[28]),
  .S0(dff_q_1)
);
MUX2 mux_inst_85 (
  .O(mux_o_85),
  .I0(dpb_inst_6_douta[28]),
  .I1(dpb_inst_7_douta[28]),
  .S0(dff_q_1)
);
MUX2 mux_inst_86 (
  .O(douta[28]),
  .I0(mux_o_84),
  .I1(mux_o_85),
  .S0(dff_q_0)
);
MUX2 mux_inst_87 (
  .O(mux_o_87),
  .I0(dpb_inst_4_douta[29]),
  .I1(dpb_inst_5_douta[29]),
  .S0(dff_q_1)
);
MUX2 mux_inst_88 (
  .O(mux_o_88),
  .I0(dpb_inst_6_douta[29]),
  .I1(dpb_inst_7_douta[29]),
  .S0(dff_q_1)
);
MUX2 mux_inst_89 (
  .O(douta[29]),
  .I0(mux_o_87),
  .I1(mux_o_88),
  .S0(dff_q_0)
);
MUX2 mux_inst_90 (
  .O(mux_o_90),
  .I0(dpb_inst_4_douta[30]),
  .I1(dpb_inst_5_douta[30]),
  .S0(dff_q_1)
);
MUX2 mux_inst_91 (
  .O(mux_o_91),
  .I0(dpb_inst_6_douta[30]),
  .I1(dpb_inst_7_douta[30]),
  .S0(dff_q_1)
);
MUX2 mux_inst_92 (
  .O(douta[30]),
  .I0(mux_o_90),
  .I1(mux_o_91),
  .S0(dff_q_0)
);
MUX2 mux_inst_93 (
  .O(mux_o_93),
  .I0(dpb_inst_4_douta[31]),
  .I1(dpb_inst_5_douta[31]),
  .S0(dff_q_1)
);
MUX2 mux_inst_94 (
  .O(mux_o_94),
  .I0(dpb_inst_6_douta[31]),
  .I1(dpb_inst_7_douta[31]),
  .S0(dff_q_1)
);
MUX2 mux_inst_95 (
  .O(douta[31]),
  .I0(mux_o_93),
  .I1(mux_o_94),
  .S0(dff_q_0)
);
MUX2 mux_inst_96 (
  .O(mux_o_96),
  .I0(dpb_inst_0_doutb[0]),
  .I1(dpb_inst_1_doutb[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_97 (
  .O(mux_o_97),
  .I0(dpb_inst_2_doutb[0]),
  .I1(dpb_inst_3_doutb[0]),
  .S0(dff_q_3)
);
MUX2 mux_inst_98 (
  .O(doutb[0]),
  .I0(mux_o_96),
  .I1(mux_o_97),
  .S0(dff_q_2)
);
MUX2 mux_inst_99 (
  .O(mux_o_99),
  .I0(dpb_inst_0_doutb[1]),
  .I1(dpb_inst_1_doutb[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_100 (
  .O(mux_o_100),
  .I0(dpb_inst_2_doutb[1]),
  .I1(dpb_inst_3_doutb[1]),
  .S0(dff_q_3)
);
MUX2 mux_inst_101 (
  .O(doutb[1]),
  .I0(mux_o_99),
  .I1(mux_o_100),
  .S0(dff_q_2)
);
MUX2 mux_inst_102 (
  .O(mux_o_102),
  .I0(dpb_inst_0_doutb[2]),
  .I1(dpb_inst_1_doutb[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_103 (
  .O(mux_o_103),
  .I0(dpb_inst_2_doutb[2]),
  .I1(dpb_inst_3_doutb[2]),
  .S0(dff_q_3)
);
MUX2 mux_inst_104 (
  .O(doutb[2]),
  .I0(mux_o_102),
  .I1(mux_o_103),
  .S0(dff_q_2)
);
MUX2 mux_inst_105 (
  .O(mux_o_105),
  .I0(dpb_inst_0_doutb[3]),
  .I1(dpb_inst_1_doutb[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_106 (
  .O(mux_o_106),
  .I0(dpb_inst_2_doutb[3]),
  .I1(dpb_inst_3_doutb[3]),
  .S0(dff_q_3)
);
MUX2 mux_inst_107 (
  .O(doutb[3]),
  .I0(mux_o_105),
  .I1(mux_o_106),
  .S0(dff_q_2)
);
MUX2 mux_inst_108 (
  .O(mux_o_108),
  .I0(dpb_inst_0_doutb[4]),
  .I1(dpb_inst_1_doutb[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_109 (
  .O(mux_o_109),
  .I0(dpb_inst_2_doutb[4]),
  .I1(dpb_inst_3_doutb[4]),
  .S0(dff_q_3)
);
MUX2 mux_inst_110 (
  .O(doutb[4]),
  .I0(mux_o_108),
  .I1(mux_o_109),
  .S0(dff_q_2)
);
MUX2 mux_inst_111 (
  .O(mux_o_111),
  .I0(dpb_inst_0_doutb[5]),
  .I1(dpb_inst_1_doutb[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_112 (
  .O(mux_o_112),
  .I0(dpb_inst_2_doutb[5]),
  .I1(dpb_inst_3_doutb[5]),
  .S0(dff_q_3)
);
MUX2 mux_inst_113 (
  .O(doutb[5]),
  .I0(mux_o_111),
  .I1(mux_o_112),
  .S0(dff_q_2)
);
MUX2 mux_inst_114 (
  .O(mux_o_114),
  .I0(dpb_inst_0_doutb[6]),
  .I1(dpb_inst_1_doutb[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_115 (
  .O(mux_o_115),
  .I0(dpb_inst_2_doutb[6]),
  .I1(dpb_inst_3_doutb[6]),
  .S0(dff_q_3)
);
MUX2 mux_inst_116 (
  .O(doutb[6]),
  .I0(mux_o_114),
  .I1(mux_o_115),
  .S0(dff_q_2)
);
MUX2 mux_inst_117 (
  .O(mux_o_117),
  .I0(dpb_inst_0_doutb[7]),
  .I1(dpb_inst_1_doutb[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_118 (
  .O(mux_o_118),
  .I0(dpb_inst_2_doutb[7]),
  .I1(dpb_inst_3_doutb[7]),
  .S0(dff_q_3)
);
MUX2 mux_inst_119 (
  .O(doutb[7]),
  .I0(mux_o_117),
  .I1(mux_o_118),
  .S0(dff_q_2)
);
MUX2 mux_inst_120 (
  .O(mux_o_120),
  .I0(dpb_inst_0_doutb[8]),
  .I1(dpb_inst_1_doutb[8]),
  .S0(dff_q_3)
);
MUX2 mux_inst_121 (
  .O(mux_o_121),
  .I0(dpb_inst_2_doutb[8]),
  .I1(dpb_inst_3_doutb[8]),
  .S0(dff_q_3)
);
MUX2 mux_inst_122 (
  .O(doutb[8]),
  .I0(mux_o_120),
  .I1(mux_o_121),
  .S0(dff_q_2)
);
MUX2 mux_inst_123 (
  .O(mux_o_123),
  .I0(dpb_inst_0_doutb[9]),
  .I1(dpb_inst_1_doutb[9]),
  .S0(dff_q_3)
);
MUX2 mux_inst_124 (
  .O(mux_o_124),
  .I0(dpb_inst_2_doutb[9]),
  .I1(dpb_inst_3_doutb[9]),
  .S0(dff_q_3)
);
MUX2 mux_inst_125 (
  .O(doutb[9]),
  .I0(mux_o_123),
  .I1(mux_o_124),
  .S0(dff_q_2)
);
MUX2 mux_inst_126 (
  .O(mux_o_126),
  .I0(dpb_inst_0_doutb[10]),
  .I1(dpb_inst_1_doutb[10]),
  .S0(dff_q_3)
);
MUX2 mux_inst_127 (
  .O(mux_o_127),
  .I0(dpb_inst_2_doutb[10]),
  .I1(dpb_inst_3_doutb[10]),
  .S0(dff_q_3)
);
MUX2 mux_inst_128 (
  .O(doutb[10]),
  .I0(mux_o_126),
  .I1(mux_o_127),
  .S0(dff_q_2)
);
MUX2 mux_inst_129 (
  .O(mux_o_129),
  .I0(dpb_inst_0_doutb[11]),
  .I1(dpb_inst_1_doutb[11]),
  .S0(dff_q_3)
);
MUX2 mux_inst_130 (
  .O(mux_o_130),
  .I0(dpb_inst_2_doutb[11]),
  .I1(dpb_inst_3_doutb[11]),
  .S0(dff_q_3)
);
MUX2 mux_inst_131 (
  .O(doutb[11]),
  .I0(mux_o_129),
  .I1(mux_o_130),
  .S0(dff_q_2)
);
MUX2 mux_inst_132 (
  .O(mux_o_132),
  .I0(dpb_inst_0_doutb[12]),
  .I1(dpb_inst_1_doutb[12]),
  .S0(dff_q_3)
);
MUX2 mux_inst_133 (
  .O(mux_o_133),
  .I0(dpb_inst_2_doutb[12]),
  .I1(dpb_inst_3_doutb[12]),
  .S0(dff_q_3)
);
MUX2 mux_inst_134 (
  .O(doutb[12]),
  .I0(mux_o_132),
  .I1(mux_o_133),
  .S0(dff_q_2)
);
MUX2 mux_inst_135 (
  .O(mux_o_135),
  .I0(dpb_inst_0_doutb[13]),
  .I1(dpb_inst_1_doutb[13]),
  .S0(dff_q_3)
);
MUX2 mux_inst_136 (
  .O(mux_o_136),
  .I0(dpb_inst_2_doutb[13]),
  .I1(dpb_inst_3_doutb[13]),
  .S0(dff_q_3)
);
MUX2 mux_inst_137 (
  .O(doutb[13]),
  .I0(mux_o_135),
  .I1(mux_o_136),
  .S0(dff_q_2)
);
MUX2 mux_inst_138 (
  .O(mux_o_138),
  .I0(dpb_inst_0_doutb[14]),
  .I1(dpb_inst_1_doutb[14]),
  .S0(dff_q_3)
);
MUX2 mux_inst_139 (
  .O(mux_o_139),
  .I0(dpb_inst_2_doutb[14]),
  .I1(dpb_inst_3_doutb[14]),
  .S0(dff_q_3)
);
MUX2 mux_inst_140 (
  .O(doutb[14]),
  .I0(mux_o_138),
  .I1(mux_o_139),
  .S0(dff_q_2)
);
MUX2 mux_inst_141 (
  .O(mux_o_141),
  .I0(dpb_inst_0_doutb[15]),
  .I1(dpb_inst_1_doutb[15]),
  .S0(dff_q_3)
);
MUX2 mux_inst_142 (
  .O(mux_o_142),
  .I0(dpb_inst_2_doutb[15]),
  .I1(dpb_inst_3_doutb[15]),
  .S0(dff_q_3)
);
MUX2 mux_inst_143 (
  .O(doutb[15]),
  .I0(mux_o_141),
  .I1(mux_o_142),
  .S0(dff_q_2)
);
MUX2 mux_inst_144 (
  .O(mux_o_144),
  .I0(dpb_inst_4_doutb[16]),
  .I1(dpb_inst_5_doutb[16]),
  .S0(dff_q_3)
);
MUX2 mux_inst_145 (
  .O(mux_o_145),
  .I0(dpb_inst_6_doutb[16]),
  .I1(dpb_inst_7_doutb[16]),
  .S0(dff_q_3)
);
MUX2 mux_inst_146 (
  .O(doutb[16]),
  .I0(mux_o_144),
  .I1(mux_o_145),
  .S0(dff_q_2)
);
MUX2 mux_inst_147 (
  .O(mux_o_147),
  .I0(dpb_inst_4_doutb[17]),
  .I1(dpb_inst_5_doutb[17]),
  .S0(dff_q_3)
);
MUX2 mux_inst_148 (
  .O(mux_o_148),
  .I0(dpb_inst_6_doutb[17]),
  .I1(dpb_inst_7_doutb[17]),
  .S0(dff_q_3)
);
MUX2 mux_inst_149 (
  .O(doutb[17]),
  .I0(mux_o_147),
  .I1(mux_o_148),
  .S0(dff_q_2)
);
MUX2 mux_inst_150 (
  .O(mux_o_150),
  .I0(dpb_inst_4_doutb[18]),
  .I1(dpb_inst_5_doutb[18]),
  .S0(dff_q_3)
);
MUX2 mux_inst_151 (
  .O(mux_o_151),
  .I0(dpb_inst_6_doutb[18]),
  .I1(dpb_inst_7_doutb[18]),
  .S0(dff_q_3)
);
MUX2 mux_inst_152 (
  .O(doutb[18]),
  .I0(mux_o_150),
  .I1(mux_o_151),
  .S0(dff_q_2)
);
MUX2 mux_inst_153 (
  .O(mux_o_153),
  .I0(dpb_inst_4_doutb[19]),
  .I1(dpb_inst_5_doutb[19]),
  .S0(dff_q_3)
);
MUX2 mux_inst_154 (
  .O(mux_o_154),
  .I0(dpb_inst_6_doutb[19]),
  .I1(dpb_inst_7_doutb[19]),
  .S0(dff_q_3)
);
MUX2 mux_inst_155 (
  .O(doutb[19]),
  .I0(mux_o_153),
  .I1(mux_o_154),
  .S0(dff_q_2)
);
MUX2 mux_inst_156 (
  .O(mux_o_156),
  .I0(dpb_inst_4_doutb[20]),
  .I1(dpb_inst_5_doutb[20]),
  .S0(dff_q_3)
);
MUX2 mux_inst_157 (
  .O(mux_o_157),
  .I0(dpb_inst_6_doutb[20]),
  .I1(dpb_inst_7_doutb[20]),
  .S0(dff_q_3)
);
MUX2 mux_inst_158 (
  .O(doutb[20]),
  .I0(mux_o_156),
  .I1(mux_o_157),
  .S0(dff_q_2)
);
MUX2 mux_inst_159 (
  .O(mux_o_159),
  .I0(dpb_inst_4_doutb[21]),
  .I1(dpb_inst_5_doutb[21]),
  .S0(dff_q_3)
);
MUX2 mux_inst_160 (
  .O(mux_o_160),
  .I0(dpb_inst_6_doutb[21]),
  .I1(dpb_inst_7_doutb[21]),
  .S0(dff_q_3)
);
MUX2 mux_inst_161 (
  .O(doutb[21]),
  .I0(mux_o_159),
  .I1(mux_o_160),
  .S0(dff_q_2)
);
MUX2 mux_inst_162 (
  .O(mux_o_162),
  .I0(dpb_inst_4_doutb[22]),
  .I1(dpb_inst_5_doutb[22]),
  .S0(dff_q_3)
);
MUX2 mux_inst_163 (
  .O(mux_o_163),
  .I0(dpb_inst_6_doutb[22]),
  .I1(dpb_inst_7_doutb[22]),
  .S0(dff_q_3)
);
MUX2 mux_inst_164 (
  .O(doutb[22]),
  .I0(mux_o_162),
  .I1(mux_o_163),
  .S0(dff_q_2)
);
MUX2 mux_inst_165 (
  .O(mux_o_165),
  .I0(dpb_inst_4_doutb[23]),
  .I1(dpb_inst_5_doutb[23]),
  .S0(dff_q_3)
);
MUX2 mux_inst_166 (
  .O(mux_o_166),
  .I0(dpb_inst_6_doutb[23]),
  .I1(dpb_inst_7_doutb[23]),
  .S0(dff_q_3)
);
MUX2 mux_inst_167 (
  .O(doutb[23]),
  .I0(mux_o_165),
  .I1(mux_o_166),
  .S0(dff_q_2)
);
MUX2 mux_inst_168 (
  .O(mux_o_168),
  .I0(dpb_inst_4_doutb[24]),
  .I1(dpb_inst_5_doutb[24]),
  .S0(dff_q_3)
);
MUX2 mux_inst_169 (
  .O(mux_o_169),
  .I0(dpb_inst_6_doutb[24]),
  .I1(dpb_inst_7_doutb[24]),
  .S0(dff_q_3)
);
MUX2 mux_inst_170 (
  .O(doutb[24]),
  .I0(mux_o_168),
  .I1(mux_o_169),
  .S0(dff_q_2)
);
MUX2 mux_inst_171 (
  .O(mux_o_171),
  .I0(dpb_inst_4_doutb[25]),
  .I1(dpb_inst_5_doutb[25]),
  .S0(dff_q_3)
);
MUX2 mux_inst_172 (
  .O(mux_o_172),
  .I0(dpb_inst_6_doutb[25]),
  .I1(dpb_inst_7_doutb[25]),
  .S0(dff_q_3)
);
MUX2 mux_inst_173 (
  .O(doutb[25]),
  .I0(mux_o_171),
  .I1(mux_o_172),
  .S0(dff_q_2)
);
MUX2 mux_inst_174 (
  .O(mux_o_174),
  .I0(dpb_inst_4_doutb[26]),
  .I1(dpb_inst_5_doutb[26]),
  .S0(dff_q_3)
);
MUX2 mux_inst_175 (
  .O(mux_o_175),
  .I0(dpb_inst_6_doutb[26]),
  .I1(dpb_inst_7_doutb[26]),
  .S0(dff_q_3)
);
MUX2 mux_inst_176 (
  .O(doutb[26]),
  .I0(mux_o_174),
  .I1(mux_o_175),
  .S0(dff_q_2)
);
MUX2 mux_inst_177 (
  .O(mux_o_177),
  .I0(dpb_inst_4_doutb[27]),
  .I1(dpb_inst_5_doutb[27]),
  .S0(dff_q_3)
);
MUX2 mux_inst_178 (
  .O(mux_o_178),
  .I0(dpb_inst_6_doutb[27]),
  .I1(dpb_inst_7_doutb[27]),
  .S0(dff_q_3)
);
MUX2 mux_inst_179 (
  .O(doutb[27]),
  .I0(mux_o_177),
  .I1(mux_o_178),
  .S0(dff_q_2)
);
MUX2 mux_inst_180 (
  .O(mux_o_180),
  .I0(dpb_inst_4_doutb[28]),
  .I1(dpb_inst_5_doutb[28]),
  .S0(dff_q_3)
);
MUX2 mux_inst_181 (
  .O(mux_o_181),
  .I0(dpb_inst_6_doutb[28]),
  .I1(dpb_inst_7_doutb[28]),
  .S0(dff_q_3)
);
MUX2 mux_inst_182 (
  .O(doutb[28]),
  .I0(mux_o_180),
  .I1(mux_o_181),
  .S0(dff_q_2)
);
MUX2 mux_inst_183 (
  .O(mux_o_183),
  .I0(dpb_inst_4_doutb[29]),
  .I1(dpb_inst_5_doutb[29]),
  .S0(dff_q_3)
);
MUX2 mux_inst_184 (
  .O(mux_o_184),
  .I0(dpb_inst_6_doutb[29]),
  .I1(dpb_inst_7_doutb[29]),
  .S0(dff_q_3)
);
MUX2 mux_inst_185 (
  .O(doutb[29]),
  .I0(mux_o_183),
  .I1(mux_o_184),
  .S0(dff_q_2)
);
MUX2 mux_inst_186 (
  .O(mux_o_186),
  .I0(dpb_inst_4_doutb[30]),
  .I1(dpb_inst_5_doutb[30]),
  .S0(dff_q_3)
);
MUX2 mux_inst_187 (
  .O(mux_o_187),
  .I0(dpb_inst_6_doutb[30]),
  .I1(dpb_inst_7_doutb[30]),
  .S0(dff_q_3)
);
MUX2 mux_inst_188 (
  .O(doutb[30]),
  .I0(mux_o_186),
  .I1(mux_o_187),
  .S0(dff_q_2)
);
MUX2 mux_inst_189 (
  .O(mux_o_189),
  .I0(dpb_inst_4_doutb[31]),
  .I1(dpb_inst_5_doutb[31]),
  .S0(dff_q_3)
);
MUX2 mux_inst_190 (
  .O(mux_o_190),
  .I0(dpb_inst_6_doutb[31]),
  .I1(dpb_inst_7_doutb[31]),
  .S0(dff_q_3)
);
MUX2 mux_inst_191 (
  .O(doutb[31]),
  .I0(mux_o_189),
  .I1(mux_o_190),
  .S0(dff_q_2)
);
endmodule //video_mem4096x32
