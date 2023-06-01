-- Title       : HDMI
-- Design      : RGB444_to_YCC444
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;  
use ieee.numeric_std.all; 
library work;
use work.lcd_lib.all;

entity YCC420_to_YCC444div2 is 
	port( 
		clock : in std_logic;
		YCC420 : in std_logic_vector(47 downto 0);
		YCbCr : out type_ycc_color
		);
end YCC420_to_YCC444div2;	  		 
architecture main of YCC420_to_YCC444div2 is 
	subtype type_video is std_logic_vector(7 downto 0);	
	type type_video_2array is array (1 downto 0) of type_video; 
	type type_video_2x2array is array (1 downto 0) of type_video_2array; 
	signal s0_Y :type_video_2x2array;
	signal s0_Cr,s0_Cb :type_video;
	signal s1_Y :type_video_2array;
	signal s1_Cr,s1_Cb :type_video;
	signal s2_Y,s2_Cr,s2_Cb :type_video;
	
begin 
	s0_Y(0)(0)<=YCC420(07 downto 00);
	s0_Y(0)(1)<=YCC420(15 downto 08);
	s0_Y(1)(0)<=YCC420(23 downto 16);
	s0_Y(1)(1)<=YCC420(31 downto 24);
	s0_Cr<=YCC420(39 downto 32);
	s0_Cb<=YCC420(47 downto 40);
	delay_proc: process (clock)
	begin
		if rising_edge(clock) then 
			s1_Y(0)<=conv_std_logic_vector((conv_integer(s0_Y(0)(0))+conv_integer(s0_Y(0)(1))),9)(8 downto 1);
			s1_Y(1)<=conv_std_logic_vector((conv_integer(s0_Y(1)(0))+conv_integer(s0_Y(1)(1))),9)(8 downto 1);
			s1_Cr<=s0_Cr;
			s1_Cb<=s0_Cb;
			
			s2_Y<=conv_std_logic_vector((conv_integer(s1_Y(0))+conv_integer(s1_Y(1))),9)(8 downto 1);
			s2_Cr<=s1_Cr;
			s2_Cb<=s1_Cb;
		end if;
	end process delay_proc;   
	YCbCr.Y<=s2_Y;
	YCbCr.Cr<=s2_Cr;
	YCbCr.Cb<=s2_Cb;
end;