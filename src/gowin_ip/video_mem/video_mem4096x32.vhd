--Copyright (C)2014-2022 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.8.07
--Part Number: GW2AR-LV18LQ144C7/I6
--Device: GW2AR-18C
--Created Time: Thu May 25 19:03:18 2023

library IEEE;
use IEEE.std_logic_1164.all;

entity video_mem4096x32 is
    port (
        douta: out std_logic_vector(31 downto 0);
        doutb: out std_logic_vector(31 downto 0);
        clka: in std_logic;
        ocea: in std_logic;
        cea: in std_logic;
        reseta: in std_logic;
        wrea: in std_logic;
        clkb: in std_logic;
        oceb: in std_logic;
        ceb: in std_logic;
        resetb: in std_logic;
        wreb: in std_logic;
        ada: in std_logic_vector(11 downto 0);
        dina: in std_logic_vector(31 downto 0);
        adb: in std_logic_vector(11 downto 0);
        dinb: in std_logic_vector(31 downto 0)
    );
end video_mem4096x32;

architecture Behavioral of video_mem4096x32 is

    signal dpb_inst_0_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_0_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_1_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_1_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_2_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_2_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_3_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_3_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_4_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_4_doutb: std_logic_vector(31 downto 16);
    signal dpb_inst_5_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_5_doutb: std_logic_vector(31 downto 16);
    signal dpb_inst_6_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_6_doutb: std_logic_vector(31 downto 16);
    signal dpb_inst_7_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_7_doutb: std_logic_vector(31 downto 16);
    signal dff_q_0: std_logic;
    signal dff_q_1: std_logic;
    signal dff_q_2: std_logic;
    signal dff_q_3: std_logic;
    signal mux_o_0: std_logic;
    signal mux_o_1: std_logic;
    signal mux_o_3: std_logic;
    signal mux_o_4: std_logic;
    signal mux_o_6: std_logic;
    signal mux_o_7: std_logic;
    signal mux_o_9: std_logic;
    signal mux_o_10: std_logic;
    signal mux_o_12: std_logic;
    signal mux_o_13: std_logic;
    signal mux_o_15: std_logic;
    signal mux_o_16: std_logic;
    signal mux_o_18: std_logic;
    signal mux_o_19: std_logic;
    signal mux_o_21: std_logic;
    signal mux_o_22: std_logic;
    signal mux_o_24: std_logic;
    signal mux_o_25: std_logic;
    signal mux_o_27: std_logic;
    signal mux_o_28: std_logic;
    signal mux_o_30: std_logic;
    signal mux_o_31: std_logic;
    signal mux_o_33: std_logic;
    signal mux_o_34: std_logic;
    signal mux_o_36: std_logic;
    signal mux_o_37: std_logic;
    signal mux_o_39: std_logic;
    signal mux_o_40: std_logic;
    signal mux_o_42: std_logic;
    signal mux_o_43: std_logic;
    signal mux_o_45: std_logic;
    signal mux_o_46: std_logic;
    signal mux_o_48: std_logic;
    signal mux_o_49: std_logic;
    signal mux_o_51: std_logic;
    signal mux_o_52: std_logic;
    signal mux_o_54: std_logic;
    signal mux_o_55: std_logic;
    signal mux_o_57: std_logic;
    signal mux_o_58: std_logic;
    signal mux_o_60: std_logic;
    signal mux_o_61: std_logic;
    signal mux_o_63: std_logic;
    signal mux_o_64: std_logic;
    signal mux_o_66: std_logic;
    signal mux_o_67: std_logic;
    signal mux_o_69: std_logic;
    signal mux_o_70: std_logic;
    signal mux_o_72: std_logic;
    signal mux_o_73: std_logic;
    signal mux_o_75: std_logic;
    signal mux_o_76: std_logic;
    signal mux_o_78: std_logic;
    signal mux_o_79: std_logic;
    signal mux_o_81: std_logic;
    signal mux_o_82: std_logic;
    signal mux_o_84: std_logic;
    signal mux_o_85: std_logic;
    signal mux_o_87: std_logic;
    signal mux_o_88: std_logic;
    signal mux_o_90: std_logic;
    signal mux_o_91: std_logic;
    signal mux_o_93: std_logic;
    signal mux_o_94: std_logic;
    signal mux_o_96: std_logic;
    signal mux_o_97: std_logic;
    signal mux_o_99: std_logic;
    signal mux_o_100: std_logic;
    signal mux_o_102: std_logic;
    signal mux_o_103: std_logic;
    signal mux_o_105: std_logic;
    signal mux_o_106: std_logic;
    signal mux_o_108: std_logic;
    signal mux_o_109: std_logic;
    signal mux_o_111: std_logic;
    signal mux_o_112: std_logic;
    signal mux_o_114: std_logic;
    signal mux_o_115: std_logic;
    signal mux_o_117: std_logic;
    signal mux_o_118: std_logic;
    signal mux_o_120: std_logic;
    signal mux_o_121: std_logic;
    signal mux_o_123: std_logic;
    signal mux_o_124: std_logic;
    signal mux_o_126: std_logic;
    signal mux_o_127: std_logic;
    signal mux_o_129: std_logic;
    signal mux_o_130: std_logic;
    signal mux_o_132: std_logic;
    signal mux_o_133: std_logic;
    signal mux_o_135: std_logic;
    signal mux_o_136: std_logic;
    signal mux_o_138: std_logic;
    signal mux_o_139: std_logic;
    signal mux_o_141: std_logic;
    signal mux_o_142: std_logic;
    signal mux_o_144: std_logic;
    signal mux_o_145: std_logic;
    signal mux_o_147: std_logic;
    signal mux_o_148: std_logic;
    signal mux_o_150: std_logic;
    signal mux_o_151: std_logic;
    signal mux_o_153: std_logic;
    signal mux_o_154: std_logic;
    signal mux_o_156: std_logic;
    signal mux_o_157: std_logic;
    signal mux_o_159: std_logic;
    signal mux_o_160: std_logic;
    signal mux_o_162: std_logic;
    signal mux_o_163: std_logic;
    signal mux_o_165: std_logic;
    signal mux_o_166: std_logic;
    signal mux_o_168: std_logic;
    signal mux_o_169: std_logic;
    signal mux_o_171: std_logic;
    signal mux_o_172: std_logic;
    signal mux_o_174: std_logic;
    signal mux_o_175: std_logic;
    signal mux_o_177: std_logic;
    signal mux_o_178: std_logic;
    signal mux_o_180: std_logic;
    signal mux_o_181: std_logic;
    signal mux_o_183: std_logic;
    signal mux_o_184: std_logic;
    signal mux_o_186: std_logic;
    signal mux_o_187: std_logic;
    signal mux_o_189: std_logic;
    signal mux_o_190: std_logic;
    signal cea_w: std_logic;
    signal ceb_w: std_logic;
    signal gw_vcc: std_logic;
    signal gw_gnd: std_logic;
    signal dpb_inst_0_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_0_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_0_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_0_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_1_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_1_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_1_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_1_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_2_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_2_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_2_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_2_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_3_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_3_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_3_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_3_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_4_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_4_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_4_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_4_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_5_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_5_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_5_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_5_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_6_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_6_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_6_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_6_ADB_i: std_logic_vector(13 downto 0);
    signal dpb_inst_7_BLKSELA_i: std_logic_vector(2 downto 0);
    signal dpb_inst_7_BLKSELB_i: std_logic_vector(2 downto 0);
    signal dpb_inst_7_ADA_i: std_logic_vector(13 downto 0);
    signal dpb_inst_7_ADB_i: std_logic_vector(13 downto 0);

    --component declaration
    component DPB
        generic (
            READ_MODE0: in bit := '0';
            READ_MODE1: in bit := '0';
            WRITE_MODE0: in bit_vector := "00";
            WRITE_MODE1: in bit_vector := "00";
            BIT_WIDTH_0: in integer :=16;
            BIT_WIDTH_1: in integer :=16;
            BLK_SEL_0: in bit_vector := "000";
            BLK_SEL_1: in bit_vector := "000";
            RESET_MODE: in string := "SYNC";
            INIT_RAM_00: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_01: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_02: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_03: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_04: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_05: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_06: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_07: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_08: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_09: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_10: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_11: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_12: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_13: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_14: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_15: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_16: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_17: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_18: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_19: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_20: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_21: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_22: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_23: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_24: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_25: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_26: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_27: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_28: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_29: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_30: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_31: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_32: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_33: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_34: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_35: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_36: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_37: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_38: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_39: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
        );
        port (
            DOA: out std_logic_vector(15 downto 0);
            DOB: out std_logic_vector(15 downto 0);
            CLKA: in std_logic;
            OCEA: in std_logic;
            CEA: in std_logic;
            RESETA: in std_logic;
            WREA: in std_logic;
            CLKB: in std_logic;
            OCEB: in std_logic;
            CEB: in std_logic;
            RESETB: in std_logic;
            WREB: in std_logic;
            BLKSELA: in std_logic_vector(2 downto 0);
            BLKSELB: in std_logic_vector(2 downto 0);
            ADA: in std_logic_vector(13 downto 0);
            DIA: in std_logic_vector(15 downto 0);
            ADB: in std_logic_vector(13 downto 0);
            DIB: in std_logic_vector(15 downto 0)
        );
    end component;

    -- component declaration
    component DFFE
        port (
            Q: out std_logic;
            D: in std_logic;
            CLK: in std_logic;
            CE: in std_logic
        );
    end component;

    -- component declaration
    component MUX2
        port (
            O: out std_logic;
            I0: in std_logic;
            I1: in std_logic;
            S0: in std_logic
        );
    end component;

begin
    gw_vcc <= '1';
    gw_gnd <= '0';

    cea_w <= not wrea and cea;
    ceb_w <= not wreb and ceb;
    dpb_inst_0_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_0_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_0_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_0_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_1_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_1_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_1_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_1_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_2_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_2_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_2_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_2_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_3_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_3_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_3_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_3_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_4_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_4_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_4_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_4_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_5_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_5_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_5_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_5_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_6_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_6_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_6_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_6_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_7_BLKSELA_i <= gw_gnd & ada(11) & ada(10);
    dpb_inst_7_BLKSELB_i <= gw_gnd & adb(11) & adb(10);
    dpb_inst_7_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_7_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_0: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "000",
            BLK_SEL_1 => "000"
        )
        port map (
            DOA => dpb_inst_0_douta(15 downto 0),
            DOB => dpb_inst_0_doutb(15 downto 0),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_0_BLKSELA_i,
            BLKSELB => dpb_inst_0_BLKSELB_i,
            ADA => dpb_inst_0_ADA_i,
            DIA => dina(15 downto 0),
            ADB => dpb_inst_0_ADB_i,
            DIB => dinb(15 downto 0)
        );

    dpb_inst_1: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "001",
            BLK_SEL_1 => "001"
        )
        port map (
            DOA => dpb_inst_1_douta(15 downto 0),
            DOB => dpb_inst_1_doutb(15 downto 0),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_1_BLKSELA_i,
            BLKSELB => dpb_inst_1_BLKSELB_i,
            ADA => dpb_inst_1_ADA_i,
            DIA => dina(15 downto 0),
            ADB => dpb_inst_1_ADB_i,
            DIB => dinb(15 downto 0)
        );

    dpb_inst_2: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "010",
            BLK_SEL_1 => "010"
        )
        port map (
            DOA => dpb_inst_2_douta(15 downto 0),
            DOB => dpb_inst_2_doutb(15 downto 0),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_2_BLKSELA_i,
            BLKSELB => dpb_inst_2_BLKSELB_i,
            ADA => dpb_inst_2_ADA_i,
            DIA => dina(15 downto 0),
            ADB => dpb_inst_2_ADB_i,
            DIB => dinb(15 downto 0)
        );

    dpb_inst_3: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "011",
            BLK_SEL_1 => "011"
        )
        port map (
            DOA => dpb_inst_3_douta(15 downto 0),
            DOB => dpb_inst_3_doutb(15 downto 0),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_3_BLKSELA_i,
            BLKSELB => dpb_inst_3_BLKSELB_i,
            ADA => dpb_inst_3_ADA_i,
            DIA => dina(15 downto 0),
            ADB => dpb_inst_3_ADB_i,
            DIB => dinb(15 downto 0)
        );

    dpb_inst_4: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "000",
            BLK_SEL_1 => "000"
        )
        port map (
            DOA => dpb_inst_4_douta(31 downto 16),
            DOB => dpb_inst_4_doutb(31 downto 16),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_4_BLKSELA_i,
            BLKSELB => dpb_inst_4_BLKSELB_i,
            ADA => dpb_inst_4_ADA_i,
            DIA => dina(31 downto 16),
            ADB => dpb_inst_4_ADB_i,
            DIB => dinb(31 downto 16)
        );

    dpb_inst_5: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "001",
            BLK_SEL_1 => "001"
        )
        port map (
            DOA => dpb_inst_5_douta(31 downto 16),
            DOB => dpb_inst_5_doutb(31 downto 16),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_5_BLKSELA_i,
            BLKSELB => dpb_inst_5_BLKSELB_i,
            ADA => dpb_inst_5_ADA_i,
            DIA => dina(31 downto 16),
            ADB => dpb_inst_5_ADB_i,
            DIB => dinb(31 downto 16)
        );

    dpb_inst_6: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "010",
            BLK_SEL_1 => "010"
        )
        port map (
            DOA => dpb_inst_6_douta(31 downto 16),
            DOB => dpb_inst_6_doutb(31 downto 16),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_6_BLKSELA_i,
            BLKSELB => dpb_inst_6_BLKSELB_i,
            ADA => dpb_inst_6_ADA_i,
            DIA => dina(31 downto 16),
            ADB => dpb_inst_6_ADB_i,
            DIB => dinb(31 downto 16)
        );

    dpb_inst_7: DPB
        generic map (
            READ_MODE0 => '0',
            READ_MODE1 => '0',
            WRITE_MODE0 => "00",
            WRITE_MODE1 => "00",
            BIT_WIDTH_0 => 16,
            BIT_WIDTH_1 => 16,
            RESET_MODE => "SYNC",
            BLK_SEL_0 => "011",
            BLK_SEL_1 => "011"
        )
        port map (
            DOA => dpb_inst_7_douta(31 downto 16),
            DOB => dpb_inst_7_doutb(31 downto 16),
            CLKA => clka,
            OCEA => ocea,
            CEA => cea,
            RESETA => reseta,
            WREA => wrea,
            CLKB => clkb,
            OCEB => oceb,
            CEB => ceb,
            RESETB => resetb,
            WREB => wreb,
            BLKSELA => dpb_inst_7_BLKSELA_i,
            BLKSELB => dpb_inst_7_BLKSELB_i,
            ADA => dpb_inst_7_ADA_i,
            DIA => dina(31 downto 16),
            ADB => dpb_inst_7_ADB_i,
            DIB => dinb(31 downto 16)
        );

    dff_inst_0: DFFE
        port map (
            Q => dff_q_0,
            D => ada(11),
            CLK => clka,
            CE => cea_w
        );

    dff_inst_1: DFFE
        port map (
            Q => dff_q_1,
            D => ada(10),
            CLK => clka,
            CE => cea_w
        );

    dff_inst_2: DFFE
        port map (
            Q => dff_q_2,
            D => adb(11),
            CLK => clkb,
            CE => ceb_w
        );

    dff_inst_3: DFFE
        port map (
            Q => dff_q_3,
            D => adb(10),
            CLK => clkb,
            CE => ceb_w
        );

    mux_inst_0: MUX2
        port map (
            O => mux_o_0,
            I0 => dpb_inst_0_douta(0),
            I1 => dpb_inst_1_douta(0),
            S0 => dff_q_1
        );

    mux_inst_1: MUX2
        port map (
            O => mux_o_1,
            I0 => dpb_inst_2_douta(0),
            I1 => dpb_inst_3_douta(0),
            S0 => dff_q_1
        );

    mux_inst_2: MUX2
        port map (
            O => douta(0),
            I0 => mux_o_0,
            I1 => mux_o_1,
            S0 => dff_q_0
        );

    mux_inst_3: MUX2
        port map (
            O => mux_o_3,
            I0 => dpb_inst_0_douta(1),
            I1 => dpb_inst_1_douta(1),
            S0 => dff_q_1
        );

    mux_inst_4: MUX2
        port map (
            O => mux_o_4,
            I0 => dpb_inst_2_douta(1),
            I1 => dpb_inst_3_douta(1),
            S0 => dff_q_1
        );

    mux_inst_5: MUX2
        port map (
            O => douta(1),
            I0 => mux_o_3,
            I1 => mux_o_4,
            S0 => dff_q_0
        );

    mux_inst_6: MUX2
        port map (
            O => mux_o_6,
            I0 => dpb_inst_0_douta(2),
            I1 => dpb_inst_1_douta(2),
            S0 => dff_q_1
        );

    mux_inst_7: MUX2
        port map (
            O => mux_o_7,
            I0 => dpb_inst_2_douta(2),
            I1 => dpb_inst_3_douta(2),
            S0 => dff_q_1
        );

    mux_inst_8: MUX2
        port map (
            O => douta(2),
            I0 => mux_o_6,
            I1 => mux_o_7,
            S0 => dff_q_0
        );

    mux_inst_9: MUX2
        port map (
            O => mux_o_9,
            I0 => dpb_inst_0_douta(3),
            I1 => dpb_inst_1_douta(3),
            S0 => dff_q_1
        );

    mux_inst_10: MUX2
        port map (
            O => mux_o_10,
            I0 => dpb_inst_2_douta(3),
            I1 => dpb_inst_3_douta(3),
            S0 => dff_q_1
        );

    mux_inst_11: MUX2
        port map (
            O => douta(3),
            I0 => mux_o_9,
            I1 => mux_o_10,
            S0 => dff_q_0
        );

    mux_inst_12: MUX2
        port map (
            O => mux_o_12,
            I0 => dpb_inst_0_douta(4),
            I1 => dpb_inst_1_douta(4),
            S0 => dff_q_1
        );

    mux_inst_13: MUX2
        port map (
            O => mux_o_13,
            I0 => dpb_inst_2_douta(4),
            I1 => dpb_inst_3_douta(4),
            S0 => dff_q_1
        );

    mux_inst_14: MUX2
        port map (
            O => douta(4),
            I0 => mux_o_12,
            I1 => mux_o_13,
            S0 => dff_q_0
        );

    mux_inst_15: MUX2
        port map (
            O => mux_o_15,
            I0 => dpb_inst_0_douta(5),
            I1 => dpb_inst_1_douta(5),
            S0 => dff_q_1
        );

    mux_inst_16: MUX2
        port map (
            O => mux_o_16,
            I0 => dpb_inst_2_douta(5),
            I1 => dpb_inst_3_douta(5),
            S0 => dff_q_1
        );

    mux_inst_17: MUX2
        port map (
            O => douta(5),
            I0 => mux_o_15,
            I1 => mux_o_16,
            S0 => dff_q_0
        );

    mux_inst_18: MUX2
        port map (
            O => mux_o_18,
            I0 => dpb_inst_0_douta(6),
            I1 => dpb_inst_1_douta(6),
            S0 => dff_q_1
        );

    mux_inst_19: MUX2
        port map (
            O => mux_o_19,
            I0 => dpb_inst_2_douta(6),
            I1 => dpb_inst_3_douta(6),
            S0 => dff_q_1
        );

    mux_inst_20: MUX2
        port map (
            O => douta(6),
            I0 => mux_o_18,
            I1 => mux_o_19,
            S0 => dff_q_0
        );

    mux_inst_21: MUX2
        port map (
            O => mux_o_21,
            I0 => dpb_inst_0_douta(7),
            I1 => dpb_inst_1_douta(7),
            S0 => dff_q_1
        );

    mux_inst_22: MUX2
        port map (
            O => mux_o_22,
            I0 => dpb_inst_2_douta(7),
            I1 => dpb_inst_3_douta(7),
            S0 => dff_q_1
        );

    mux_inst_23: MUX2
        port map (
            O => douta(7),
            I0 => mux_o_21,
            I1 => mux_o_22,
            S0 => dff_q_0
        );

    mux_inst_24: MUX2
        port map (
            O => mux_o_24,
            I0 => dpb_inst_0_douta(8),
            I1 => dpb_inst_1_douta(8),
            S0 => dff_q_1
        );

    mux_inst_25: MUX2
        port map (
            O => mux_o_25,
            I0 => dpb_inst_2_douta(8),
            I1 => dpb_inst_3_douta(8),
            S0 => dff_q_1
        );

    mux_inst_26: MUX2
        port map (
            O => douta(8),
            I0 => mux_o_24,
            I1 => mux_o_25,
            S0 => dff_q_0
        );

    mux_inst_27: MUX2
        port map (
            O => mux_o_27,
            I0 => dpb_inst_0_douta(9),
            I1 => dpb_inst_1_douta(9),
            S0 => dff_q_1
        );

    mux_inst_28: MUX2
        port map (
            O => mux_o_28,
            I0 => dpb_inst_2_douta(9),
            I1 => dpb_inst_3_douta(9),
            S0 => dff_q_1
        );

    mux_inst_29: MUX2
        port map (
            O => douta(9),
            I0 => mux_o_27,
            I1 => mux_o_28,
            S0 => dff_q_0
        );

    mux_inst_30: MUX2
        port map (
            O => mux_o_30,
            I0 => dpb_inst_0_douta(10),
            I1 => dpb_inst_1_douta(10),
            S0 => dff_q_1
        );

    mux_inst_31: MUX2
        port map (
            O => mux_o_31,
            I0 => dpb_inst_2_douta(10),
            I1 => dpb_inst_3_douta(10),
            S0 => dff_q_1
        );

    mux_inst_32: MUX2
        port map (
            O => douta(10),
            I0 => mux_o_30,
            I1 => mux_o_31,
            S0 => dff_q_0
        );

    mux_inst_33: MUX2
        port map (
            O => mux_o_33,
            I0 => dpb_inst_0_douta(11),
            I1 => dpb_inst_1_douta(11),
            S0 => dff_q_1
        );

    mux_inst_34: MUX2
        port map (
            O => mux_o_34,
            I0 => dpb_inst_2_douta(11),
            I1 => dpb_inst_3_douta(11),
            S0 => dff_q_1
        );

    mux_inst_35: MUX2
        port map (
            O => douta(11),
            I0 => mux_o_33,
            I1 => mux_o_34,
            S0 => dff_q_0
        );

    mux_inst_36: MUX2
        port map (
            O => mux_o_36,
            I0 => dpb_inst_0_douta(12),
            I1 => dpb_inst_1_douta(12),
            S0 => dff_q_1
        );

    mux_inst_37: MUX2
        port map (
            O => mux_o_37,
            I0 => dpb_inst_2_douta(12),
            I1 => dpb_inst_3_douta(12),
            S0 => dff_q_1
        );

    mux_inst_38: MUX2
        port map (
            O => douta(12),
            I0 => mux_o_36,
            I1 => mux_o_37,
            S0 => dff_q_0
        );

    mux_inst_39: MUX2
        port map (
            O => mux_o_39,
            I0 => dpb_inst_0_douta(13),
            I1 => dpb_inst_1_douta(13),
            S0 => dff_q_1
        );

    mux_inst_40: MUX2
        port map (
            O => mux_o_40,
            I0 => dpb_inst_2_douta(13),
            I1 => dpb_inst_3_douta(13),
            S0 => dff_q_1
        );

    mux_inst_41: MUX2
        port map (
            O => douta(13),
            I0 => mux_o_39,
            I1 => mux_o_40,
            S0 => dff_q_0
        );

    mux_inst_42: MUX2
        port map (
            O => mux_o_42,
            I0 => dpb_inst_0_douta(14),
            I1 => dpb_inst_1_douta(14),
            S0 => dff_q_1
        );

    mux_inst_43: MUX2
        port map (
            O => mux_o_43,
            I0 => dpb_inst_2_douta(14),
            I1 => dpb_inst_3_douta(14),
            S0 => dff_q_1
        );

    mux_inst_44: MUX2
        port map (
            O => douta(14),
            I0 => mux_o_42,
            I1 => mux_o_43,
            S0 => dff_q_0
        );

    mux_inst_45: MUX2
        port map (
            O => mux_o_45,
            I0 => dpb_inst_0_douta(15),
            I1 => dpb_inst_1_douta(15),
            S0 => dff_q_1
        );

    mux_inst_46: MUX2
        port map (
            O => mux_o_46,
            I0 => dpb_inst_2_douta(15),
            I1 => dpb_inst_3_douta(15),
            S0 => dff_q_1
        );

    mux_inst_47: MUX2
        port map (
            O => douta(15),
            I0 => mux_o_45,
            I1 => mux_o_46,
            S0 => dff_q_0
        );

    mux_inst_48: MUX2
        port map (
            O => mux_o_48,
            I0 => dpb_inst_4_douta(16),
            I1 => dpb_inst_5_douta(16),
            S0 => dff_q_1
        );

    mux_inst_49: MUX2
        port map (
            O => mux_o_49,
            I0 => dpb_inst_6_douta(16),
            I1 => dpb_inst_7_douta(16),
            S0 => dff_q_1
        );

    mux_inst_50: MUX2
        port map (
            O => douta(16),
            I0 => mux_o_48,
            I1 => mux_o_49,
            S0 => dff_q_0
        );

    mux_inst_51: MUX2
        port map (
            O => mux_o_51,
            I0 => dpb_inst_4_douta(17),
            I1 => dpb_inst_5_douta(17),
            S0 => dff_q_1
        );

    mux_inst_52: MUX2
        port map (
            O => mux_o_52,
            I0 => dpb_inst_6_douta(17),
            I1 => dpb_inst_7_douta(17),
            S0 => dff_q_1
        );

    mux_inst_53: MUX2
        port map (
            O => douta(17),
            I0 => mux_o_51,
            I1 => mux_o_52,
            S0 => dff_q_0
        );

    mux_inst_54: MUX2
        port map (
            O => mux_o_54,
            I0 => dpb_inst_4_douta(18),
            I1 => dpb_inst_5_douta(18),
            S0 => dff_q_1
        );

    mux_inst_55: MUX2
        port map (
            O => mux_o_55,
            I0 => dpb_inst_6_douta(18),
            I1 => dpb_inst_7_douta(18),
            S0 => dff_q_1
        );

    mux_inst_56: MUX2
        port map (
            O => douta(18),
            I0 => mux_o_54,
            I1 => mux_o_55,
            S0 => dff_q_0
        );

    mux_inst_57: MUX2
        port map (
            O => mux_o_57,
            I0 => dpb_inst_4_douta(19),
            I1 => dpb_inst_5_douta(19),
            S0 => dff_q_1
        );

    mux_inst_58: MUX2
        port map (
            O => mux_o_58,
            I0 => dpb_inst_6_douta(19),
            I1 => dpb_inst_7_douta(19),
            S0 => dff_q_1
        );

    mux_inst_59: MUX2
        port map (
            O => douta(19),
            I0 => mux_o_57,
            I1 => mux_o_58,
            S0 => dff_q_0
        );

    mux_inst_60: MUX2
        port map (
            O => mux_o_60,
            I0 => dpb_inst_4_douta(20),
            I1 => dpb_inst_5_douta(20),
            S0 => dff_q_1
        );

    mux_inst_61: MUX2
        port map (
            O => mux_o_61,
            I0 => dpb_inst_6_douta(20),
            I1 => dpb_inst_7_douta(20),
            S0 => dff_q_1
        );

    mux_inst_62: MUX2
        port map (
            O => douta(20),
            I0 => mux_o_60,
            I1 => mux_o_61,
            S0 => dff_q_0
        );

    mux_inst_63: MUX2
        port map (
            O => mux_o_63,
            I0 => dpb_inst_4_douta(21),
            I1 => dpb_inst_5_douta(21),
            S0 => dff_q_1
        );

    mux_inst_64: MUX2
        port map (
            O => mux_o_64,
            I0 => dpb_inst_6_douta(21),
            I1 => dpb_inst_7_douta(21),
            S0 => dff_q_1
        );

    mux_inst_65: MUX2
        port map (
            O => douta(21),
            I0 => mux_o_63,
            I1 => mux_o_64,
            S0 => dff_q_0
        );

    mux_inst_66: MUX2
        port map (
            O => mux_o_66,
            I0 => dpb_inst_4_douta(22),
            I1 => dpb_inst_5_douta(22),
            S0 => dff_q_1
        );

    mux_inst_67: MUX2
        port map (
            O => mux_o_67,
            I0 => dpb_inst_6_douta(22),
            I1 => dpb_inst_7_douta(22),
            S0 => dff_q_1
        );

    mux_inst_68: MUX2
        port map (
            O => douta(22),
            I0 => mux_o_66,
            I1 => mux_o_67,
            S0 => dff_q_0
        );

    mux_inst_69: MUX2
        port map (
            O => mux_o_69,
            I0 => dpb_inst_4_douta(23),
            I1 => dpb_inst_5_douta(23),
            S0 => dff_q_1
        );

    mux_inst_70: MUX2
        port map (
            O => mux_o_70,
            I0 => dpb_inst_6_douta(23),
            I1 => dpb_inst_7_douta(23),
            S0 => dff_q_1
        );

    mux_inst_71: MUX2
        port map (
            O => douta(23),
            I0 => mux_o_69,
            I1 => mux_o_70,
            S0 => dff_q_0
        );

    mux_inst_72: MUX2
        port map (
            O => mux_o_72,
            I0 => dpb_inst_4_douta(24),
            I1 => dpb_inst_5_douta(24),
            S0 => dff_q_1
        );

    mux_inst_73: MUX2
        port map (
            O => mux_o_73,
            I0 => dpb_inst_6_douta(24),
            I1 => dpb_inst_7_douta(24),
            S0 => dff_q_1
        );

    mux_inst_74: MUX2
        port map (
            O => douta(24),
            I0 => mux_o_72,
            I1 => mux_o_73,
            S0 => dff_q_0
        );

    mux_inst_75: MUX2
        port map (
            O => mux_o_75,
            I0 => dpb_inst_4_douta(25),
            I1 => dpb_inst_5_douta(25),
            S0 => dff_q_1
        );

    mux_inst_76: MUX2
        port map (
            O => mux_o_76,
            I0 => dpb_inst_6_douta(25),
            I1 => dpb_inst_7_douta(25),
            S0 => dff_q_1
        );

    mux_inst_77: MUX2
        port map (
            O => douta(25),
            I0 => mux_o_75,
            I1 => mux_o_76,
            S0 => dff_q_0
        );

    mux_inst_78: MUX2
        port map (
            O => mux_o_78,
            I0 => dpb_inst_4_douta(26),
            I1 => dpb_inst_5_douta(26),
            S0 => dff_q_1
        );

    mux_inst_79: MUX2
        port map (
            O => mux_o_79,
            I0 => dpb_inst_6_douta(26),
            I1 => dpb_inst_7_douta(26),
            S0 => dff_q_1
        );

    mux_inst_80: MUX2
        port map (
            O => douta(26),
            I0 => mux_o_78,
            I1 => mux_o_79,
            S0 => dff_q_0
        );

    mux_inst_81: MUX2
        port map (
            O => mux_o_81,
            I0 => dpb_inst_4_douta(27),
            I1 => dpb_inst_5_douta(27),
            S0 => dff_q_1
        );

    mux_inst_82: MUX2
        port map (
            O => mux_o_82,
            I0 => dpb_inst_6_douta(27),
            I1 => dpb_inst_7_douta(27),
            S0 => dff_q_1
        );

    mux_inst_83: MUX2
        port map (
            O => douta(27),
            I0 => mux_o_81,
            I1 => mux_o_82,
            S0 => dff_q_0
        );

    mux_inst_84: MUX2
        port map (
            O => mux_o_84,
            I0 => dpb_inst_4_douta(28),
            I1 => dpb_inst_5_douta(28),
            S0 => dff_q_1
        );

    mux_inst_85: MUX2
        port map (
            O => mux_o_85,
            I0 => dpb_inst_6_douta(28),
            I1 => dpb_inst_7_douta(28),
            S0 => dff_q_1
        );

    mux_inst_86: MUX2
        port map (
            O => douta(28),
            I0 => mux_o_84,
            I1 => mux_o_85,
            S0 => dff_q_0
        );

    mux_inst_87: MUX2
        port map (
            O => mux_o_87,
            I0 => dpb_inst_4_douta(29),
            I1 => dpb_inst_5_douta(29),
            S0 => dff_q_1
        );

    mux_inst_88: MUX2
        port map (
            O => mux_o_88,
            I0 => dpb_inst_6_douta(29),
            I1 => dpb_inst_7_douta(29),
            S0 => dff_q_1
        );

    mux_inst_89: MUX2
        port map (
            O => douta(29),
            I0 => mux_o_87,
            I1 => mux_o_88,
            S0 => dff_q_0
        );

    mux_inst_90: MUX2
        port map (
            O => mux_o_90,
            I0 => dpb_inst_4_douta(30),
            I1 => dpb_inst_5_douta(30),
            S0 => dff_q_1
        );

    mux_inst_91: MUX2
        port map (
            O => mux_o_91,
            I0 => dpb_inst_6_douta(30),
            I1 => dpb_inst_7_douta(30),
            S0 => dff_q_1
        );

    mux_inst_92: MUX2
        port map (
            O => douta(30),
            I0 => mux_o_90,
            I1 => mux_o_91,
            S0 => dff_q_0
        );

    mux_inst_93: MUX2
        port map (
            O => mux_o_93,
            I0 => dpb_inst_4_douta(31),
            I1 => dpb_inst_5_douta(31),
            S0 => dff_q_1
        );

    mux_inst_94: MUX2
        port map (
            O => mux_o_94,
            I0 => dpb_inst_6_douta(31),
            I1 => dpb_inst_7_douta(31),
            S0 => dff_q_1
        );

    mux_inst_95: MUX2
        port map (
            O => douta(31),
            I0 => mux_o_93,
            I1 => mux_o_94,
            S0 => dff_q_0
        );

    mux_inst_96: MUX2
        port map (
            O => mux_o_96,
            I0 => dpb_inst_0_doutb(0),
            I1 => dpb_inst_1_doutb(0),
            S0 => dff_q_3
        );

    mux_inst_97: MUX2
        port map (
            O => mux_o_97,
            I0 => dpb_inst_2_doutb(0),
            I1 => dpb_inst_3_doutb(0),
            S0 => dff_q_3
        );

    mux_inst_98: MUX2
        port map (
            O => doutb(0),
            I0 => mux_o_96,
            I1 => mux_o_97,
            S0 => dff_q_2
        );

    mux_inst_99: MUX2
        port map (
            O => mux_o_99,
            I0 => dpb_inst_0_doutb(1),
            I1 => dpb_inst_1_doutb(1),
            S0 => dff_q_3
        );

    mux_inst_100: MUX2
        port map (
            O => mux_o_100,
            I0 => dpb_inst_2_doutb(1),
            I1 => dpb_inst_3_doutb(1),
            S0 => dff_q_3
        );

    mux_inst_101: MUX2
        port map (
            O => doutb(1),
            I0 => mux_o_99,
            I1 => mux_o_100,
            S0 => dff_q_2
        );

    mux_inst_102: MUX2
        port map (
            O => mux_o_102,
            I0 => dpb_inst_0_doutb(2),
            I1 => dpb_inst_1_doutb(2),
            S0 => dff_q_3
        );

    mux_inst_103: MUX2
        port map (
            O => mux_o_103,
            I0 => dpb_inst_2_doutb(2),
            I1 => dpb_inst_3_doutb(2),
            S0 => dff_q_3
        );

    mux_inst_104: MUX2
        port map (
            O => doutb(2),
            I0 => mux_o_102,
            I1 => mux_o_103,
            S0 => dff_q_2
        );

    mux_inst_105: MUX2
        port map (
            O => mux_o_105,
            I0 => dpb_inst_0_doutb(3),
            I1 => dpb_inst_1_doutb(3),
            S0 => dff_q_3
        );

    mux_inst_106: MUX2
        port map (
            O => mux_o_106,
            I0 => dpb_inst_2_doutb(3),
            I1 => dpb_inst_3_doutb(3),
            S0 => dff_q_3
        );

    mux_inst_107: MUX2
        port map (
            O => doutb(3),
            I0 => mux_o_105,
            I1 => mux_o_106,
            S0 => dff_q_2
        );

    mux_inst_108: MUX2
        port map (
            O => mux_o_108,
            I0 => dpb_inst_0_doutb(4),
            I1 => dpb_inst_1_doutb(4),
            S0 => dff_q_3
        );

    mux_inst_109: MUX2
        port map (
            O => mux_o_109,
            I0 => dpb_inst_2_doutb(4),
            I1 => dpb_inst_3_doutb(4),
            S0 => dff_q_3
        );

    mux_inst_110: MUX2
        port map (
            O => doutb(4),
            I0 => mux_o_108,
            I1 => mux_o_109,
            S0 => dff_q_2
        );

    mux_inst_111: MUX2
        port map (
            O => mux_o_111,
            I0 => dpb_inst_0_doutb(5),
            I1 => dpb_inst_1_doutb(5),
            S0 => dff_q_3
        );

    mux_inst_112: MUX2
        port map (
            O => mux_o_112,
            I0 => dpb_inst_2_doutb(5),
            I1 => dpb_inst_3_doutb(5),
            S0 => dff_q_3
        );

    mux_inst_113: MUX2
        port map (
            O => doutb(5),
            I0 => mux_o_111,
            I1 => mux_o_112,
            S0 => dff_q_2
        );

    mux_inst_114: MUX2
        port map (
            O => mux_o_114,
            I0 => dpb_inst_0_doutb(6),
            I1 => dpb_inst_1_doutb(6),
            S0 => dff_q_3
        );

    mux_inst_115: MUX2
        port map (
            O => mux_o_115,
            I0 => dpb_inst_2_doutb(6),
            I1 => dpb_inst_3_doutb(6),
            S0 => dff_q_3
        );

    mux_inst_116: MUX2
        port map (
            O => doutb(6),
            I0 => mux_o_114,
            I1 => mux_o_115,
            S0 => dff_q_2
        );

    mux_inst_117: MUX2
        port map (
            O => mux_o_117,
            I0 => dpb_inst_0_doutb(7),
            I1 => dpb_inst_1_doutb(7),
            S0 => dff_q_3
        );

    mux_inst_118: MUX2
        port map (
            O => mux_o_118,
            I0 => dpb_inst_2_doutb(7),
            I1 => dpb_inst_3_doutb(7),
            S0 => dff_q_3
        );

    mux_inst_119: MUX2
        port map (
            O => doutb(7),
            I0 => mux_o_117,
            I1 => mux_o_118,
            S0 => dff_q_2
        );

    mux_inst_120: MUX2
        port map (
            O => mux_o_120,
            I0 => dpb_inst_0_doutb(8),
            I1 => dpb_inst_1_doutb(8),
            S0 => dff_q_3
        );

    mux_inst_121: MUX2
        port map (
            O => mux_o_121,
            I0 => dpb_inst_2_doutb(8),
            I1 => dpb_inst_3_doutb(8),
            S0 => dff_q_3
        );

    mux_inst_122: MUX2
        port map (
            O => doutb(8),
            I0 => mux_o_120,
            I1 => mux_o_121,
            S0 => dff_q_2
        );

    mux_inst_123: MUX2
        port map (
            O => mux_o_123,
            I0 => dpb_inst_0_doutb(9),
            I1 => dpb_inst_1_doutb(9),
            S0 => dff_q_3
        );

    mux_inst_124: MUX2
        port map (
            O => mux_o_124,
            I0 => dpb_inst_2_doutb(9),
            I1 => dpb_inst_3_doutb(9),
            S0 => dff_q_3
        );

    mux_inst_125: MUX2
        port map (
            O => doutb(9),
            I0 => mux_o_123,
            I1 => mux_o_124,
            S0 => dff_q_2
        );

    mux_inst_126: MUX2
        port map (
            O => mux_o_126,
            I0 => dpb_inst_0_doutb(10),
            I1 => dpb_inst_1_doutb(10),
            S0 => dff_q_3
        );

    mux_inst_127: MUX2
        port map (
            O => mux_o_127,
            I0 => dpb_inst_2_doutb(10),
            I1 => dpb_inst_3_doutb(10),
            S0 => dff_q_3
        );

    mux_inst_128: MUX2
        port map (
            O => doutb(10),
            I0 => mux_o_126,
            I1 => mux_o_127,
            S0 => dff_q_2
        );

    mux_inst_129: MUX2
        port map (
            O => mux_o_129,
            I0 => dpb_inst_0_doutb(11),
            I1 => dpb_inst_1_doutb(11),
            S0 => dff_q_3
        );

    mux_inst_130: MUX2
        port map (
            O => mux_o_130,
            I0 => dpb_inst_2_doutb(11),
            I1 => dpb_inst_3_doutb(11),
            S0 => dff_q_3
        );

    mux_inst_131: MUX2
        port map (
            O => doutb(11),
            I0 => mux_o_129,
            I1 => mux_o_130,
            S0 => dff_q_2
        );

    mux_inst_132: MUX2
        port map (
            O => mux_o_132,
            I0 => dpb_inst_0_doutb(12),
            I1 => dpb_inst_1_doutb(12),
            S0 => dff_q_3
        );

    mux_inst_133: MUX2
        port map (
            O => mux_o_133,
            I0 => dpb_inst_2_doutb(12),
            I1 => dpb_inst_3_doutb(12),
            S0 => dff_q_3
        );

    mux_inst_134: MUX2
        port map (
            O => doutb(12),
            I0 => mux_o_132,
            I1 => mux_o_133,
            S0 => dff_q_2
        );

    mux_inst_135: MUX2
        port map (
            O => mux_o_135,
            I0 => dpb_inst_0_doutb(13),
            I1 => dpb_inst_1_doutb(13),
            S0 => dff_q_3
        );

    mux_inst_136: MUX2
        port map (
            O => mux_o_136,
            I0 => dpb_inst_2_doutb(13),
            I1 => dpb_inst_3_doutb(13),
            S0 => dff_q_3
        );

    mux_inst_137: MUX2
        port map (
            O => doutb(13),
            I0 => mux_o_135,
            I1 => mux_o_136,
            S0 => dff_q_2
        );

    mux_inst_138: MUX2
        port map (
            O => mux_o_138,
            I0 => dpb_inst_0_doutb(14),
            I1 => dpb_inst_1_doutb(14),
            S0 => dff_q_3
        );

    mux_inst_139: MUX2
        port map (
            O => mux_o_139,
            I0 => dpb_inst_2_doutb(14),
            I1 => dpb_inst_3_doutb(14),
            S0 => dff_q_3
        );

    mux_inst_140: MUX2
        port map (
            O => doutb(14),
            I0 => mux_o_138,
            I1 => mux_o_139,
            S0 => dff_q_2
        );

    mux_inst_141: MUX2
        port map (
            O => mux_o_141,
            I0 => dpb_inst_0_doutb(15),
            I1 => dpb_inst_1_doutb(15),
            S0 => dff_q_3
        );

    mux_inst_142: MUX2
        port map (
            O => mux_o_142,
            I0 => dpb_inst_2_doutb(15),
            I1 => dpb_inst_3_doutb(15),
            S0 => dff_q_3
        );

    mux_inst_143: MUX2
        port map (
            O => doutb(15),
            I0 => mux_o_141,
            I1 => mux_o_142,
            S0 => dff_q_2
        );

    mux_inst_144: MUX2
        port map (
            O => mux_o_144,
            I0 => dpb_inst_4_doutb(16),
            I1 => dpb_inst_5_doutb(16),
            S0 => dff_q_3
        );

    mux_inst_145: MUX2
        port map (
            O => mux_o_145,
            I0 => dpb_inst_6_doutb(16),
            I1 => dpb_inst_7_doutb(16),
            S0 => dff_q_3
        );

    mux_inst_146: MUX2
        port map (
            O => doutb(16),
            I0 => mux_o_144,
            I1 => mux_o_145,
            S0 => dff_q_2
        );

    mux_inst_147: MUX2
        port map (
            O => mux_o_147,
            I0 => dpb_inst_4_doutb(17),
            I1 => dpb_inst_5_doutb(17),
            S0 => dff_q_3
        );

    mux_inst_148: MUX2
        port map (
            O => mux_o_148,
            I0 => dpb_inst_6_doutb(17),
            I1 => dpb_inst_7_doutb(17),
            S0 => dff_q_3
        );

    mux_inst_149: MUX2
        port map (
            O => doutb(17),
            I0 => mux_o_147,
            I1 => mux_o_148,
            S0 => dff_q_2
        );

    mux_inst_150: MUX2
        port map (
            O => mux_o_150,
            I0 => dpb_inst_4_doutb(18),
            I1 => dpb_inst_5_doutb(18),
            S0 => dff_q_3
        );

    mux_inst_151: MUX2
        port map (
            O => mux_o_151,
            I0 => dpb_inst_6_doutb(18),
            I1 => dpb_inst_7_doutb(18),
            S0 => dff_q_3
        );

    mux_inst_152: MUX2
        port map (
            O => doutb(18),
            I0 => mux_o_150,
            I1 => mux_o_151,
            S0 => dff_q_2
        );

    mux_inst_153: MUX2
        port map (
            O => mux_o_153,
            I0 => dpb_inst_4_doutb(19),
            I1 => dpb_inst_5_doutb(19),
            S0 => dff_q_3
        );

    mux_inst_154: MUX2
        port map (
            O => mux_o_154,
            I0 => dpb_inst_6_doutb(19),
            I1 => dpb_inst_7_doutb(19),
            S0 => dff_q_3
        );

    mux_inst_155: MUX2
        port map (
            O => doutb(19),
            I0 => mux_o_153,
            I1 => mux_o_154,
            S0 => dff_q_2
        );

    mux_inst_156: MUX2
        port map (
            O => mux_o_156,
            I0 => dpb_inst_4_doutb(20),
            I1 => dpb_inst_5_doutb(20),
            S0 => dff_q_3
        );

    mux_inst_157: MUX2
        port map (
            O => mux_o_157,
            I0 => dpb_inst_6_doutb(20),
            I1 => dpb_inst_7_doutb(20),
            S0 => dff_q_3
        );

    mux_inst_158: MUX2
        port map (
            O => doutb(20),
            I0 => mux_o_156,
            I1 => mux_o_157,
            S0 => dff_q_2
        );

    mux_inst_159: MUX2
        port map (
            O => mux_o_159,
            I0 => dpb_inst_4_doutb(21),
            I1 => dpb_inst_5_doutb(21),
            S0 => dff_q_3
        );

    mux_inst_160: MUX2
        port map (
            O => mux_o_160,
            I0 => dpb_inst_6_doutb(21),
            I1 => dpb_inst_7_doutb(21),
            S0 => dff_q_3
        );

    mux_inst_161: MUX2
        port map (
            O => doutb(21),
            I0 => mux_o_159,
            I1 => mux_o_160,
            S0 => dff_q_2
        );

    mux_inst_162: MUX2
        port map (
            O => mux_o_162,
            I0 => dpb_inst_4_doutb(22),
            I1 => dpb_inst_5_doutb(22),
            S0 => dff_q_3
        );

    mux_inst_163: MUX2
        port map (
            O => mux_o_163,
            I0 => dpb_inst_6_doutb(22),
            I1 => dpb_inst_7_doutb(22),
            S0 => dff_q_3
        );

    mux_inst_164: MUX2
        port map (
            O => doutb(22),
            I0 => mux_o_162,
            I1 => mux_o_163,
            S0 => dff_q_2
        );

    mux_inst_165: MUX2
        port map (
            O => mux_o_165,
            I0 => dpb_inst_4_doutb(23),
            I1 => dpb_inst_5_doutb(23),
            S0 => dff_q_3
        );

    mux_inst_166: MUX2
        port map (
            O => mux_o_166,
            I0 => dpb_inst_6_doutb(23),
            I1 => dpb_inst_7_doutb(23),
            S0 => dff_q_3
        );

    mux_inst_167: MUX2
        port map (
            O => doutb(23),
            I0 => mux_o_165,
            I1 => mux_o_166,
            S0 => dff_q_2
        );

    mux_inst_168: MUX2
        port map (
            O => mux_o_168,
            I0 => dpb_inst_4_doutb(24),
            I1 => dpb_inst_5_doutb(24),
            S0 => dff_q_3
        );

    mux_inst_169: MUX2
        port map (
            O => mux_o_169,
            I0 => dpb_inst_6_doutb(24),
            I1 => dpb_inst_7_doutb(24),
            S0 => dff_q_3
        );

    mux_inst_170: MUX2
        port map (
            O => doutb(24),
            I0 => mux_o_168,
            I1 => mux_o_169,
            S0 => dff_q_2
        );

    mux_inst_171: MUX2
        port map (
            O => mux_o_171,
            I0 => dpb_inst_4_doutb(25),
            I1 => dpb_inst_5_doutb(25),
            S0 => dff_q_3
        );

    mux_inst_172: MUX2
        port map (
            O => mux_o_172,
            I0 => dpb_inst_6_doutb(25),
            I1 => dpb_inst_7_doutb(25),
            S0 => dff_q_3
        );

    mux_inst_173: MUX2
        port map (
            O => doutb(25),
            I0 => mux_o_171,
            I1 => mux_o_172,
            S0 => dff_q_2
        );

    mux_inst_174: MUX2
        port map (
            O => mux_o_174,
            I0 => dpb_inst_4_doutb(26),
            I1 => dpb_inst_5_doutb(26),
            S0 => dff_q_3
        );

    mux_inst_175: MUX2
        port map (
            O => mux_o_175,
            I0 => dpb_inst_6_doutb(26),
            I1 => dpb_inst_7_doutb(26),
            S0 => dff_q_3
        );

    mux_inst_176: MUX2
        port map (
            O => doutb(26),
            I0 => mux_o_174,
            I1 => mux_o_175,
            S0 => dff_q_2
        );

    mux_inst_177: MUX2
        port map (
            O => mux_o_177,
            I0 => dpb_inst_4_doutb(27),
            I1 => dpb_inst_5_doutb(27),
            S0 => dff_q_3
        );

    mux_inst_178: MUX2
        port map (
            O => mux_o_178,
            I0 => dpb_inst_6_doutb(27),
            I1 => dpb_inst_7_doutb(27),
            S0 => dff_q_3
        );

    mux_inst_179: MUX2
        port map (
            O => doutb(27),
            I0 => mux_o_177,
            I1 => mux_o_178,
            S0 => dff_q_2
        );

    mux_inst_180: MUX2
        port map (
            O => mux_o_180,
            I0 => dpb_inst_4_doutb(28),
            I1 => dpb_inst_5_doutb(28),
            S0 => dff_q_3
        );

    mux_inst_181: MUX2
        port map (
            O => mux_o_181,
            I0 => dpb_inst_6_doutb(28),
            I1 => dpb_inst_7_doutb(28),
            S0 => dff_q_3
        );

    mux_inst_182: MUX2
        port map (
            O => doutb(28),
            I0 => mux_o_180,
            I1 => mux_o_181,
            S0 => dff_q_2
        );

    mux_inst_183: MUX2
        port map (
            O => mux_o_183,
            I0 => dpb_inst_4_doutb(29),
            I1 => dpb_inst_5_doutb(29),
            S0 => dff_q_3
        );

    mux_inst_184: MUX2
        port map (
            O => mux_o_184,
            I0 => dpb_inst_6_doutb(29),
            I1 => dpb_inst_7_doutb(29),
            S0 => dff_q_3
        );

    mux_inst_185: MUX2
        port map (
            O => doutb(29),
            I0 => mux_o_183,
            I1 => mux_o_184,
            S0 => dff_q_2
        );

    mux_inst_186: MUX2
        port map (
            O => mux_o_186,
            I0 => dpb_inst_4_doutb(30),
            I1 => dpb_inst_5_doutb(30),
            S0 => dff_q_3
        );

    mux_inst_187: MUX2
        port map (
            O => mux_o_187,
            I0 => dpb_inst_6_doutb(30),
            I1 => dpb_inst_7_doutb(30),
            S0 => dff_q_3
        );

    mux_inst_188: MUX2
        port map (
            O => doutb(30),
            I0 => mux_o_186,
            I1 => mux_o_187,
            S0 => dff_q_2
        );

    mux_inst_189: MUX2
        port map (
            O => mux_o_189,
            I0 => dpb_inst_4_doutb(31),
            I1 => dpb_inst_5_doutb(31),
            S0 => dff_q_3
        );

    mux_inst_190: MUX2
        port map (
            O => mux_o_190,
            I0 => dpb_inst_6_doutb(31),
            I1 => dpb_inst_7_doutb(31),
            S0 => dff_q_3
        );

    mux_inst_191: MUX2
        port map (
            O => doutb(31),
            I0 => mux_o_189,
            I1 => mux_o_190,
            S0 => dff_q_2
        );

end Behavioral; --video_mem4096x32
