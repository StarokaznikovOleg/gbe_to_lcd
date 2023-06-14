-------------------------------------------------------------------------------
-- Title       : text generator
-- Design      : gen_txt
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
--use work.vimon10_lib.all;
use work.lcd_lib.all;

entity gen_txt is
	generic( hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=23; 
		text_color:type_rgb_color:=white);
	port(
		clock: in std_logic; 
		Vcount,Hcount: in integer; 
		act: out boolean; 
		pixel :out type_rgb_color;
		
		map_adr : in std_logic_vector(13 downto 0);
		map_clk,map_wr : in std_logic;
		map_din : in std_logic_vector(7 downto 0)
		);
end gen_txt;

architecture main of gen_txt is			 
	constant v_min : integer :=0;
	constant v_max : integer :=vsize;
	constant h_min : integer :=hblank;
	constant h_max : integer :=hsize+hblank;	 
	
	constant delay_map : integer :=4;
	constant delay_font : integer :=1;
	
	signal frame,vact,hact,FONToce: boolean; 	 
	
	signal int_vcount: integer range 0 to vsize:= 0; 
	signal int_hcount: integer range 0 to hsize:= 0;  
	
	signal MAPaddress: std_logic_vector(13 downto 0); 
	signal MAPdata: std_logic_vector(7 downto 0); 
	signal FONTaddress: std_logic_vector(16 downto 0); 
	signal int_act: std_logic_vector(0 downto 0); 
	
begin 
	--------------------------------------------	
	pixel<=text_color;
	xy_counters: process (clock)
	begin
		if rising_edge(clock)then 
			act<=int_act="1" and FONToce;
			vact<=Vcount>=v_min and Vcount<v_max;
			hact<=Hcount>=h_min-delay_map and Hcount<h_max-delay_map;					
			FONToce<=Hcount>=h_min-delay_map+2 and Hcount<h_max-delay_map+2;
			if hcount=0 then  
				int_hcount<=0;
			elsif hact then	
				int_hcount<=int_hcount+1;
			end if;
			if Vcount=vsize+vblank-1 and hcount=0 then  
				int_vcount<=0;
			elsif  hcount=0 then	
				int_vcount<=int_vcount+1;
			end if;
		end if;
	end process xy_counters; 
	--------------------------------------------		
	MAPaddress(13 downto 8)<=conv_std_logic_vector(int_vcount,14)(10 downto 5);
	MAPaddress(7 downto 0)<=conv_std_logic_vector(int_hcount,17)(11 downto 4);
	table_MAP1 : entity work.table_MAP 
	port map(
		reseta => '0',
		clka => map_clk,
		cea => map_wr,
		ada => map_adr,
		din => map_din,
		resetb => '0',
		clkb => clock,
		ceb => '1',
		oce => '1',
		adb => MAPaddress,
		dout => MAPdata
		);	   
	FONTaddress(16 downto 12)<=conv_std_logic_vector(int_vcount,14)(4 downto 0);
	FONTaddress(11 downto 4)<=MAPdata;
	FONTaddress(3 downto 0)<=conv_std_logic_vector(int_hcount-delay_font,17)(3 downto 0);
	table_FONT1 : entity work.table_FONT 	 
	port map(
		reset => '0',
		clk => clock,
		ad => FONTaddress,
		oce => '1',
		ce => '1',
		dout => int_act
		);
end main;