--
--Written by GowinSynthesis
--Product Version "GowinSynthesis V1.9.8.07"
--Tue Oct 04 19:21:38 2022

--Source file index table:
--file0 "\D:/Gowin/Gowin_V1.9.8.07/IDE/ipcore/DDR/data/ddr.v"
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gw2a;
use gw2a.components.all;

entity ddrout is
port(
  din :  in std_logic_vector(1 downto 0);
  clk :  in std_logic;
  q :  out std_logic_vector(0 downto 0));
end ddrout;
architecture beh of ddrout is
  signal \oddr_gen[0].oddr_inst_1_Q1\ : std_logic ;
  signal GND_0 : std_logic ;
  signal VCC_0 : std_logic ;
begin
\oddr_gen[0].oddr_inst\: ODDR
port map (
  Q0 => q(0),
  Q1 => \oddr_gen[0].oddr_inst_1_Q1\,
  D0 => din(0),
  D1 => din(1),
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
