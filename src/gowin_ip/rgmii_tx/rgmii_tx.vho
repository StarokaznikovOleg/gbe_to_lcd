--
--Written by GowinSynthesis
--Product Version "GowinSynthesis V1.9.8.07"
--Fri Aug 19 23:09:42 2022

--Source file index table:
--file0 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/DDR/data/ddr.v"
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gw2a;
use gw2a.components.all;

entity rgmii_tx is
port(
  din :  in std_logic_vector(9 downto 0);
  clk :  in std_logic;
  q :  out std_logic_vector(4 downto 0));
end rgmii_tx;
architecture beh of rgmii_tx is
  signal \oddr_gen[0].oddr_inst_1_Q1\ : std_logic ;
  signal \oddr_gen[1].oddr_inst_1_Q1\ : std_logic ;
  signal \oddr_gen[2].oddr_inst_1_Q1\ : std_logic ;
  signal \oddr_gen[3].oddr_inst_1_Q1\ : std_logic ;
  signal \oddr_gen[4].oddr_inst_1_Q1\ : std_logic ;
  signal GND_0 : std_logic ;
  signal VCC_0 : std_logic ;
begin
\oddr_gen[0].oddr_inst\: ODDR
port map (
  Q0 => q(0),
  Q1 => \oddr_gen[0].oddr_inst_1_Q1\,
  D0 => din(0),
  D1 => din(5),
  TX => GND_0,
  CLK => clk);
\oddr_gen[1].oddr_inst\: ODDR
port map (
  Q0 => q(1),
  Q1 => \oddr_gen[1].oddr_inst_1_Q1\,
  D0 => din(1),
  D1 => din(6),
  TX => GND_0,
  CLK => clk);
\oddr_gen[2].oddr_inst\: ODDR
port map (
  Q0 => q(2),
  Q1 => \oddr_gen[2].oddr_inst_1_Q1\,
  D0 => din(2),
  D1 => din(7),
  TX => GND_0,
  CLK => clk);
\oddr_gen[3].oddr_inst\: ODDR
port map (
  Q0 => q(3),
  Q1 => \oddr_gen[3].oddr_inst_1_Q1\,
  D0 => din(3),
  D1 => din(8),
  TX => GND_0,
  CLK => clk);
\oddr_gen[4].oddr_inst\: ODDR
port map (
  Q0 => q(4),
  Q1 => \oddr_gen[4].oddr_inst_1_Q1\,
  D0 => din(4),
  D1 => din(9),
  TX => GND_0,
  CLK => clk);
GND_s0: GND
port map (
  G => GND_0);
VCC_s0: VCC
port map (
  V => VCC_0);
GSR_0: GSR
port map (
  GSRI => VCC_0);
end beh;
