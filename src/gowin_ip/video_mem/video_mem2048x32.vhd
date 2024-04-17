--Copyright (C)2014-2022 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.8.07
--Part Number: GW2AR-LV18LQ144C7/I6
--Device: GW2AR-18C
--Created Time: Thu May 25 11:00:38 2023

library IEEE;
use IEEE.std_logic_1164.all;

entity video_mem2048x32 is
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
        ada: in std_logic_vector(10 downto 0);
        dina: in std_logic_vector(31 downto 0);
        adb: in std_logic_vector(10 downto 0);
        dinb: in std_logic_vector(31 downto 0)
    );
end video_mem2048x32;

architecture Behavioral of video_mem2048x32 is

    signal dpb_inst_0_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_0_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_1_douta: std_logic_vector(15 downto 0);
    signal dpb_inst_1_doutb: std_logic_vector(15 downto 0);
    signal dpb_inst_2_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_2_doutb: std_logic_vector(31 downto 16);
    signal dpb_inst_3_douta: std_logic_vector(31 downto 16);
    signal dpb_inst_3_doutb: std_logic_vector(31 downto 16);
    signal dff_q_0: std_logic;
    signal dff_q_1: std_logic;
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
    dpb_inst_0_BLKSELA_i <= gw_gnd & gw_gnd & ada(10);
    dpb_inst_0_BLKSELB_i <= gw_gnd & gw_gnd & adb(10);
    dpb_inst_0_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_0_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_1_BLKSELA_i <= gw_gnd & gw_gnd & ada(10);
    dpb_inst_1_BLKSELB_i <= gw_gnd & gw_gnd & adb(10);
    dpb_inst_1_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_1_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_2_BLKSELA_i <= gw_gnd & gw_gnd & ada(10);
    dpb_inst_2_BLKSELB_i <= gw_gnd & gw_gnd & adb(10);
    dpb_inst_2_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_2_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_3_BLKSELA_i <= gw_gnd & gw_gnd & ada(10);
    dpb_inst_3_BLKSELB_i <= gw_gnd & gw_gnd & adb(10);
    dpb_inst_3_ADA_i <= ada(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
    dpb_inst_3_ADB_i <= adb(9 downto 0) & gw_gnd & gw_gnd & gw_vcc & gw_vcc;
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
            BLK_SEL_0 => "000",
            BLK_SEL_1 => "000"
        )
        port map (
            DOA => dpb_inst_2_douta(31 downto 16),
            DOB => dpb_inst_2_doutb(31 downto 16),
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
            DIA => dina(31 downto 16),
            ADB => dpb_inst_2_ADB_i,
            DIB => dinb(31 downto 16)
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
            BLK_SEL_0 => "001",
            BLK_SEL_1 => "001"
        )
        port map (
            DOA => dpb_inst_3_douta(31 downto 16),
            DOB => dpb_inst_3_doutb(31 downto 16),
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
            DIA => dina(31 downto 16),
            ADB => dpb_inst_3_ADB_i,
            DIB => dinb(31 downto 16)
        );

    dff_inst_0: DFFE
        port map (
            Q => dff_q_0,
            D => ada(10),
            CLK => clka,
            CE => cea_w
        );

    dff_inst_1: DFFE
        port map (
            Q => dff_q_1,
            D => adb(10),
            CLK => clkb,
            CE => ceb_w
        );

    mux_inst_0: MUX2
        port map (
            O => douta(0),
            I0 => dpb_inst_0_douta(0),
            I1 => dpb_inst_1_douta(0),
            S0 => dff_q_0
        );

    mux_inst_1: MUX2
        port map (
            O => douta(1),
            I0 => dpb_inst_0_douta(1),
            I1 => dpb_inst_1_douta(1),
            S0 => dff_q_0
        );

    mux_inst_2: MUX2
        port map (
            O => douta(2),
            I0 => dpb_inst_0_douta(2),
            I1 => dpb_inst_1_douta(2),
            S0 => dff_q_0
        );

    mux_inst_3: MUX2
        port map (
            O => douta(3),
            I0 => dpb_inst_0_douta(3),
            I1 => dpb_inst_1_douta(3),
            S0 => dff_q_0
        );

    mux_inst_4: MUX2
        port map (
            O => douta(4),
            I0 => dpb_inst_0_douta(4),
            I1 => dpb_inst_1_douta(4),
            S0 => dff_q_0
        );

    mux_inst_5: MUX2
        port map (
            O => douta(5),
            I0 => dpb_inst_0_douta(5),
            I1 => dpb_inst_1_douta(5),
            S0 => dff_q_0
        );

    mux_inst_6: MUX2
        port map (
            O => douta(6),
            I0 => dpb_inst_0_douta(6),
            I1 => dpb_inst_1_douta(6),
            S0 => dff_q_0
        );

    mux_inst_7: MUX2
        port map (
            O => douta(7),
            I0 => dpb_inst_0_douta(7),
            I1 => dpb_inst_1_douta(7),
            S0 => dff_q_0
        );

    mux_inst_8: MUX2
        port map (
            O => douta(8),
            I0 => dpb_inst_0_douta(8),
            I1 => dpb_inst_1_douta(8),
            S0 => dff_q_0
        );

    mux_inst_9: MUX2
        port map (
            O => douta(9),
            I0 => dpb_inst_0_douta(9),
            I1 => dpb_inst_1_douta(9),
            S0 => dff_q_0
        );

    mux_inst_10: MUX2
        port map (
            O => douta(10),
            I0 => dpb_inst_0_douta(10),
            I1 => dpb_inst_1_douta(10),
            S0 => dff_q_0
        );

    mux_inst_11: MUX2
        port map (
            O => douta(11),
            I0 => dpb_inst_0_douta(11),
            I1 => dpb_inst_1_douta(11),
            S0 => dff_q_0
        );

    mux_inst_12: MUX2
        port map (
            O => douta(12),
            I0 => dpb_inst_0_douta(12),
            I1 => dpb_inst_1_douta(12),
            S0 => dff_q_0
        );

    mux_inst_13: MUX2
        port map (
            O => douta(13),
            I0 => dpb_inst_0_douta(13),
            I1 => dpb_inst_1_douta(13),
            S0 => dff_q_0
        );

    mux_inst_14: MUX2
        port map (
            O => douta(14),
            I0 => dpb_inst_0_douta(14),
            I1 => dpb_inst_1_douta(14),
            S0 => dff_q_0
        );

    mux_inst_15: MUX2
        port map (
            O => douta(15),
            I0 => dpb_inst_0_douta(15),
            I1 => dpb_inst_1_douta(15),
            S0 => dff_q_0
        );

    mux_inst_16: MUX2
        port map (
            O => douta(16),
            I0 => dpb_inst_2_douta(16),
            I1 => dpb_inst_3_douta(16),
            S0 => dff_q_0
        );

    mux_inst_17: MUX2
        port map (
            O => douta(17),
            I0 => dpb_inst_2_douta(17),
            I1 => dpb_inst_3_douta(17),
            S0 => dff_q_0
        );

    mux_inst_18: MUX2
        port map (
            O => douta(18),
            I0 => dpb_inst_2_douta(18),
            I1 => dpb_inst_3_douta(18),
            S0 => dff_q_0
        );

    mux_inst_19: MUX2
        port map (
            O => douta(19),
            I0 => dpb_inst_2_douta(19),
            I1 => dpb_inst_3_douta(19),
            S0 => dff_q_0
        );

    mux_inst_20: MUX2
        port map (
            O => douta(20),
            I0 => dpb_inst_2_douta(20),
            I1 => dpb_inst_3_douta(20),
            S0 => dff_q_0
        );

    mux_inst_21: MUX2
        port map (
            O => douta(21),
            I0 => dpb_inst_2_douta(21),
            I1 => dpb_inst_3_douta(21),
            S0 => dff_q_0
        );

    mux_inst_22: MUX2
        port map (
            O => douta(22),
            I0 => dpb_inst_2_douta(22),
            I1 => dpb_inst_3_douta(22),
            S0 => dff_q_0
        );

    mux_inst_23: MUX2
        port map (
            O => douta(23),
            I0 => dpb_inst_2_douta(23),
            I1 => dpb_inst_3_douta(23),
            S0 => dff_q_0
        );

    mux_inst_24: MUX2
        port map (
            O => douta(24),
            I0 => dpb_inst_2_douta(24),
            I1 => dpb_inst_3_douta(24),
            S0 => dff_q_0
        );

    mux_inst_25: MUX2
        port map (
            O => douta(25),
            I0 => dpb_inst_2_douta(25),
            I1 => dpb_inst_3_douta(25),
            S0 => dff_q_0
        );

    mux_inst_26: MUX2
        port map (
            O => douta(26),
            I0 => dpb_inst_2_douta(26),
            I1 => dpb_inst_3_douta(26),
            S0 => dff_q_0
        );

    mux_inst_27: MUX2
        port map (
            O => douta(27),
            I0 => dpb_inst_2_douta(27),
            I1 => dpb_inst_3_douta(27),
            S0 => dff_q_0
        );

    mux_inst_28: MUX2
        port map (
            O => douta(28),
            I0 => dpb_inst_2_douta(28),
            I1 => dpb_inst_3_douta(28),
            S0 => dff_q_0
        );

    mux_inst_29: MUX2
        port map (
            O => douta(29),
            I0 => dpb_inst_2_douta(29),
            I1 => dpb_inst_3_douta(29),
            S0 => dff_q_0
        );

    mux_inst_30: MUX2
        port map (
            O => douta(30),
            I0 => dpb_inst_2_douta(30),
            I1 => dpb_inst_3_douta(30),
            S0 => dff_q_0
        );

    mux_inst_31: MUX2
        port map (
            O => douta(31),
            I0 => dpb_inst_2_douta(31),
            I1 => dpb_inst_3_douta(31),
            S0 => dff_q_0
        );

    mux_inst_32: MUX2
        port map (
            O => doutb(0),
            I0 => dpb_inst_0_doutb(0),
            I1 => dpb_inst_1_doutb(0),
            S0 => dff_q_1
        );

    mux_inst_33: MUX2
        port map (
            O => doutb(1),
            I0 => dpb_inst_0_doutb(1),
            I1 => dpb_inst_1_doutb(1),
            S0 => dff_q_1
        );

    mux_inst_34: MUX2
        port map (
            O => doutb(2),
            I0 => dpb_inst_0_doutb(2),
            I1 => dpb_inst_1_doutb(2),
            S0 => dff_q_1
        );

    mux_inst_35: MUX2
        port map (
            O => doutb(3),
            I0 => dpb_inst_0_doutb(3),
            I1 => dpb_inst_1_doutb(3),
            S0 => dff_q_1
        );

    mux_inst_36: MUX2
        port map (
            O => doutb(4),
            I0 => dpb_inst_0_doutb(4),
            I1 => dpb_inst_1_doutb(4),
            S0 => dff_q_1
        );

    mux_inst_37: MUX2
        port map (
            O => doutb(5),
            I0 => dpb_inst_0_doutb(5),
            I1 => dpb_inst_1_doutb(5),
            S0 => dff_q_1
        );

    mux_inst_38: MUX2
        port map (
            O => doutb(6),
            I0 => dpb_inst_0_doutb(6),
            I1 => dpb_inst_1_doutb(6),
            S0 => dff_q_1
        );

    mux_inst_39: MUX2
        port map (
            O => doutb(7),
            I0 => dpb_inst_0_doutb(7),
            I1 => dpb_inst_1_doutb(7),
            S0 => dff_q_1
        );

    mux_inst_40: MUX2
        port map (
            O => doutb(8),
            I0 => dpb_inst_0_doutb(8),
            I1 => dpb_inst_1_doutb(8),
            S0 => dff_q_1
        );

    mux_inst_41: MUX2
        port map (
            O => doutb(9),
            I0 => dpb_inst_0_doutb(9),
            I1 => dpb_inst_1_doutb(9),
            S0 => dff_q_1
        );

    mux_inst_42: MUX2
        port map (
            O => doutb(10),
            I0 => dpb_inst_0_doutb(10),
            I1 => dpb_inst_1_doutb(10),
            S0 => dff_q_1
        );

    mux_inst_43: MUX2
        port map (
            O => doutb(11),
            I0 => dpb_inst_0_doutb(11),
            I1 => dpb_inst_1_doutb(11),
            S0 => dff_q_1
        );

    mux_inst_44: MUX2
        port map (
            O => doutb(12),
            I0 => dpb_inst_0_doutb(12),
            I1 => dpb_inst_1_doutb(12),
            S0 => dff_q_1
        );

    mux_inst_45: MUX2
        port map (
            O => doutb(13),
            I0 => dpb_inst_0_doutb(13),
            I1 => dpb_inst_1_doutb(13),
            S0 => dff_q_1
        );

    mux_inst_46: MUX2
        port map (
            O => doutb(14),
            I0 => dpb_inst_0_doutb(14),
            I1 => dpb_inst_1_doutb(14),
            S0 => dff_q_1
        );

    mux_inst_47: MUX2
        port map (
            O => doutb(15),
            I0 => dpb_inst_0_doutb(15),
            I1 => dpb_inst_1_doutb(15),
            S0 => dff_q_1
        );

    mux_inst_48: MUX2
        port map (
            O => doutb(16),
            I0 => dpb_inst_2_doutb(16),
            I1 => dpb_inst_3_doutb(16),
            S0 => dff_q_1
        );

    mux_inst_49: MUX2
        port map (
            O => doutb(17),
            I0 => dpb_inst_2_doutb(17),
            I1 => dpb_inst_3_doutb(17),
            S0 => dff_q_1
        );

    mux_inst_50: MUX2
        port map (
            O => doutb(18),
            I0 => dpb_inst_2_doutb(18),
            I1 => dpb_inst_3_doutb(18),
            S0 => dff_q_1
        );

    mux_inst_51: MUX2
        port map (
            O => doutb(19),
            I0 => dpb_inst_2_doutb(19),
            I1 => dpb_inst_3_doutb(19),
            S0 => dff_q_1
        );

    mux_inst_52: MUX2
        port map (
            O => doutb(20),
            I0 => dpb_inst_2_doutb(20),
            I1 => dpb_inst_3_doutb(20),
            S0 => dff_q_1
        );

    mux_inst_53: MUX2
        port map (
            O => doutb(21),
            I0 => dpb_inst_2_doutb(21),
            I1 => dpb_inst_3_doutb(21),
            S0 => dff_q_1
        );

    mux_inst_54: MUX2
        port map (
            O => doutb(22),
            I0 => dpb_inst_2_doutb(22),
            I1 => dpb_inst_3_doutb(22),
            S0 => dff_q_1
        );

    mux_inst_55: MUX2
        port map (
            O => doutb(23),
            I0 => dpb_inst_2_doutb(23),
            I1 => dpb_inst_3_doutb(23),
            S0 => dff_q_1
        );

    mux_inst_56: MUX2
        port map (
            O => doutb(24),
            I0 => dpb_inst_2_doutb(24),
            I1 => dpb_inst_3_doutb(24),
            S0 => dff_q_1
        );

    mux_inst_57: MUX2
        port map (
            O => doutb(25),
            I0 => dpb_inst_2_doutb(25),
            I1 => dpb_inst_3_doutb(25),
            S0 => dff_q_1
        );

    mux_inst_58: MUX2
        port map (
            O => doutb(26),
            I0 => dpb_inst_2_doutb(26),
            I1 => dpb_inst_3_doutb(26),
            S0 => dff_q_1
        );

    mux_inst_59: MUX2
        port map (
            O => doutb(27),
            I0 => dpb_inst_2_doutb(27),
            I1 => dpb_inst_3_doutb(27),
            S0 => dff_q_1
        );

    mux_inst_60: MUX2
        port map (
            O => doutb(28),
            I0 => dpb_inst_2_doutb(28),
            I1 => dpb_inst_3_doutb(28),
            S0 => dff_q_1
        );

    mux_inst_61: MUX2
        port map (
            O => doutb(29),
            I0 => dpb_inst_2_doutb(29),
            I1 => dpb_inst_3_doutb(29),
            S0 => dff_q_1
        );

    mux_inst_62: MUX2
        port map (
            O => doutb(30),
            I0 => dpb_inst_2_doutb(30),
            I1 => dpb_inst_3_doutb(30),
            S0 => dff_q_1
        );

    mux_inst_63: MUX2
        port map (
            O => doutb(31),
            I0 => dpb_inst_2_doutb(31),
            I1 => dpb_inst_3_doutb(31),
            S0 => dff_q_1
        );

end Behavioral; --video_mem2048x32
