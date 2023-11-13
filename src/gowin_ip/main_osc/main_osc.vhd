--Copyright (C)2014-2023 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.9 Beta-3
--Part Number: GW2AR-LV18EQ144PC8/I7
--Device: GW2AR-18
--Device Version: C
--Created Time: Mon Nov 13 17:00:42 2023

library IEEE;
use IEEE.std_logic_1164.all;

entity main_OSC is
    port (
        oscout: out std_logic
    );
end main_OSC;

architecture Behavioral of main_OSC is

    --component declaration
    component OSC
        generic (
            FREQ_DIV: in integer := 100;
            DEVICE: in string := "GW2A-18"
        );
        port (
            OSCOUT: out std_logic
        );
    end component;

begin
    osc_inst: OSC
        generic map (
            FREQ_DIV => 100,
            DEVICE => "GW2AR-18C"
        )
        port map (
            OSCOUT => oscout
        );

end Behavioral; --main_OSC
