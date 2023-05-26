--Copyright (C)2014-2022 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.8.07
--Part Number: GW2AR-LV18LQ144C7/I6
--Device: GW2AR-18C
--Created Time: Fri Oct 21 16:26:48 2022

library IEEE;
use IEEE.std_logic_1164.all;

entity lcd_clkdiv is
    port (
        clkout: out std_logic;
        hclkin: in std_logic;
        resetn: in std_logic
    );
end lcd_clkdiv;

architecture Behavioral of lcd_clkdiv is

    signal gw_gnd: std_logic;

    --component declaration
    component CLKDIV
        generic (
            DIV_MODE : STRING := "2";
            GSREN: in string := "false"
        );
        port (
            CLKOUT: out std_logic;
            HCLKIN: in std_logic;
            RESETN: in std_logic;
            CALIB: in std_logic
        );
    end component;

begin
    gw_gnd <= '0';

    clkdiv_inst: CLKDIV
        generic map (
            DIV_MODE => "3.5",
            GSREN => "false"
        )
        port map (
            CLKOUT => clkout,
            HCLKIN => hclkin,
            RESETN => resetn,
            CALIB => gw_gnd
        );

end Behavioral; --lcd_clkdiv
