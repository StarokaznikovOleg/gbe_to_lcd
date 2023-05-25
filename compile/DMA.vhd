-------------------------------------------------------------------------------
--
-- Title       : DMA
-- Design      : vimon10gw
-- Author      : starokaznikov
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : D:\Projects\VIMON\compile\DMA.vhd
-- Generated   : Tue May 16 21:09:34 2023
-- From        : D:\Projects\VIMON\src\DMA.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.vimon10_lib.all;

entity DMA is
  port(
       avl_clk : in STD_LOGIC;
       avl_readdatavalid : in STD_LOGIC;
       avl_waitrequest : in STD_LOGIC;
       reset : in STD_LOGIC;
       spi_csn : in STD_LOGIC;
       spi_mosi : in STD_LOGIC;
       spi_ref : in STD_LOGIC;
       spi_sck : in STD_LOGIC;
       avl_readdata : in STD_LOGIC_VECTOR(31 downto 0);
       avl_clear : out STD_LOGIC;
       avl_read : out STD_LOGIC;
       avl_write : out STD_LOGIC;
       spi_miso : out STD_LOGIC;
       avl_address : out STD_LOGIC_VECTOR(31 downto 0);
       avl_burstcount : out STD_LOGIC_VECTOR(6 downto 0);
       avl_byteenable : out STD_LOGIC_VECTOR(3 downto 0);
       avl_writedata : out STD_LOGIC_VECTOR(31 downto 0)
  );
end DMA;

architecture DMA of DMA is

---- Component declarations -----

component dma_mm
  port (
       avl_readdata : in STD_LOGIC_VECTOR(31 downto 0);
       avl_readdatavalid : in STD_LOGIC;
       avl_waitrequest : in STD_LOGIC;
       clear : in STD_LOGIC;
       clock : in STD_LOGIC;
       mem_q : in STD_LOGIC_VECTOR(31 downto 0);
       mem_req : in STD_LOGIC_VECTOR(3 downto 0);
       reset : in STD_LOGIC;
       avl_address : out STD_LOGIC_VECTOR(31 downto 0);
       avl_burstcount : out STD_LOGIC_VECTOR(6 downto 0);
       avl_byteenable : out STD_LOGIC_VECTOR(3 downto 0);
       avl_read : out STD_LOGIC;
       avl_write : out STD_LOGIC;
       avl_writedata : out STD_LOGIC_VECTOR(31 downto 0);
       mem_adr : out STD_LOGIC_VECTOR(9 downto 0);
       mem_clk : out STD_LOGIC;
       mem_data : out STD_LOGIC_VECTOR(31 downto 0);
       mem_done : out STD_LOGIC_VECTOR(3 downto 0);
       mem_wr : out STD_LOGIC
  );
end component;
component spi_mm
  port (
       clock : in STD_LOGIC;
       csn : in STD_LOGIC;
       mem_done : in STD_LOGIC_VECTOR(3 downto 0);
       mem_q : in STD_LOGIC_VECTOR(31 downto 0);
       mosi : in STD_LOGIC;
       reset : in STD_LOGIC;
       sck : in STD_LOGIC;
       clear : out STD_LOGIC;
       mem_adr : out STD_LOGIC_VECTOR(9 downto 0);
       mem_clk : out STD_LOGIC;
       mem_data : out STD_LOGIC_VECTOR(31 downto 0);
       mem_req : out STD_LOGIC_VECTOR(3 downto 0);
       mem_wr : out STD_LOGIC;
       miso : out STD_LOGIC
  );
end component;
component Sync
  generic(
       inDelay : INTEGER := 0;
       outDelay : INTEGER := 0;
       regime : STRING := "blank"
  );
  port (
       clk_in : in STD_LOGIC;
       clk_out : in STD_LOGIC;
       data_in : in STD_LOGIC;
       reset : in STD_LOGIC;
       data_out : out STD_LOGIC
  );
end component;
component dma_mem
  port (
       ada : in STD_LOGIC_VECTOR(9 downto 0);
       adb : in STD_LOGIC_VECTOR(9 downto 0);
       cea : in STD_LOGIC;
       ceb : in STD_LOGIC;
       clka : in STD_LOGIC;
       clkb : in STD_LOGIC;
       dina : in STD_LOGIC_VECTOR(31 downto 0);
       dinb : in STD_LOGIC_VECTOR(31 downto 0);
       ocea : in STD_LOGIC;
       oceb : in STD_LOGIC;
       reseta : in STD_LOGIC;
       resetb : in STD_LOGIC;
       wrea : in STD_LOGIC;
       wreb : in STD_LOGIC;
       douta : out STD_LOGIC_VECTOR(31 downto 0);
       doutb : out STD_LOGIC_VECTOR(31 downto 0)
  );
end component;

----     Constants     -----
constant VCC_CONSTANT   : STD_LOGIC := '1';

---- Signal declarations used on the diagram ----

signal clocka : STD_LOGIC;
signal clockb : STD_LOGIC;
signal ireset : STD_LOGIC;
signal mema_clear : STD_LOGIC;
signal memb_clear : STD_LOGIC;
signal VCC : STD_LOGIC;
signal wren_a : STD_LOGIC;
signal wren_b : STD_LOGIC;
signal address_a : STD_LOGIC_VECTOR (9 downto 0);
signal address_b : STD_LOGIC_VECTOR (9 downto 0);
signal data_a : STD_LOGIC_VECTOR (31 downto 0);
signal data_b : STD_LOGIC_VECTOR (31 downto 0);
signal mema_done : STD_LOGIC_VECTOR (3 downto 0);
signal mema_req : STD_LOGIC_VECTOR (3 downto 0);
signal memb_done : STD_LOGIC_VECTOR (3 downto 0);
signal memb_req : STD_LOGIC_VECTOR (3 downto 0);
signal q_a : STD_LOGIC_VECTOR (31 downto 0);
signal q_b : STD_LOGIC_VECTOR (31 downto 0);

begin

----  Component instantiations  ----

U1 : spi_mm
  port map(
       clear => mema_clear,
       clock => spi_ref,
       csn => spi_csn,
       mem_adr => address_a,
       mem_clk => clocka,
       mem_data => data_a,
       mem_done => mema_done,
       mem_q => q_a,
       mem_req => mema_req,
       mem_wr => wren_a,
       miso => spi_miso,
       mosi => spi_mosi,
       reset => reset,
       sck => spi_sck
  );

U2 : dma_mem
  port map(
       ada => address_a,
       adb => address_b,
       cea => VCC,
       ceb => VCC,
       clka => clocka,
       clkb => clockb,
       dina => data_a,
       dinb => data_b,
       douta => q_a,
       doutb => q_b,
       ocea => VCC,
       oceb => VCC,
       reseta => reset,
       resetb => reset,
       wrea => wren_a,
       wreb => wren_b
  );

U3 : dma_mm
  port map(
       avl_address => avl_address,
       avl_burstcount => avl_burstcount,
       avl_byteenable => avl_byteenable,
       avl_read => avl_read,
       avl_readdata => avl_readdata,
       avl_readdatavalid => avl_readdatavalid,
       avl_waitrequest => avl_waitrequest,
       avl_write => avl_write,
       avl_writedata => avl_writedata,
       clear => memb_clear,
       clock => avl_clk,
       mem_adr => address_b,
       mem_clk => clockb,
       mem_data => data_b,
       mem_done => memb_done,
       mem_q => q_b,
       mem_req => memb_req,
       mem_wr => wren_b,
       reset => ireset
  );

U4 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "spuls"
  )
  port map(
       clk_in => clocka,
       clk_out => clockb,
       data_in => mema_clear,
       data_out => memb_clear,
       reset => reset
  );

U5_ARRAY0 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "spuls"
  )
  port map(
       clk_in => clocka,
       clk_out => clockb,
       data_in => mema_req(3),
       data_out => memb_req(3),
       reset => reset
  );

U5_ARRAY1 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "spuls"
  )
  port map(
       clk_in => clocka,
       clk_out => clockb,
       data_in => mema_req(2),
       data_out => memb_req(2),
       reset => reset
  );

U5_ARRAY2 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "spuls"
  )
  port map(
       clk_in => clocka,
       clk_out => clockb,
       data_in => mema_req(1),
       data_out => memb_req(1),
       reset => reset
  );

U5_ARRAY3 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "spuls"
  )
  port map(
       clk_in => clocka,
       clk_out => clockb,
       data_in => mema_req(0),
       data_out => memb_req(0),
       reset => reset
  );

U6_ARRAY0 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "level"
  )
  port map(
       clk_in => clockb,
       clk_out => clocka,
       data_in => memb_done(3),
       data_out => mema_done(3),
       reset => reset
  );

U6_ARRAY1 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "level"
  )
  port map(
       clk_in => clockb,
       clk_out => clocka,
       data_in => memb_done(2),
       data_out => mema_done(2),
       reset => reset
  );

U6_ARRAY2 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "level"
  )
  port map(
       clk_in => clockb,
       clk_out => clocka,
       data_in => memb_done(1),
       data_out => mema_done(1),
       reset => reset
  );

U6_ARRAY3 : Sync
  generic map (
       inDelay => 0,
       outDelay => 0,
       regime => "level"
  )
  port map(
       clk_in => clockb,
       clk_out => clocka,
       data_in => memb_done(0),
       data_out => mema_done(0),
       reset => reset
  );


---- Power , ground assignment ----

VCC <= VCC_CONSTANT;

---- Terminal assignment ----

    -- Output\buffer terminals
	avl_clear <= memb_clear;


end DMA;
