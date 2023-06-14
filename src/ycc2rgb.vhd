library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.lcd_lib.all;

entity ycc2rgb is
	port (
		clock : in  std_logic;
		YCbCr : in  type_ycc_color;
		RGB   : out type_rgb_color
		);
end entity ycc2rgb;

architecture rtl of ycc2rgb is
	signal s0Y, s0Cb, s0Cr : integer range 0 to (2**8)-1;
	signal s1xY, s1rCr, s1gCb, s1gCr, s1bCb : integer range 0 to (2**18)-1;
	signal s2R, s2G, s2B : integer range -(2**19) to (2**19)-1;
	signal s3R, s3G, s3B : integer range 0 to (2**10)-1;
begin
	-- Convert unsigned YCbCr inputs to signed representation		 
	s0Y  <= conv_integer(YCbCr.Y);
	s0Cb <= conv_integer(YCbCr.Cb);
	s0Cr <= conv_integer(YCbCr.Cr); 
	conv_proc: process (clock)
	begin
		if rising_edge(clock)then 
			
			s1xY<=298*s0Y;
			s1rCr<=409*s0Cr;
			s1gCb<=100*s0Cb;
			s1gCr<=208*s0Cr; 
			s1bCb<=516*s0Cb;
			
			s2R<=s1xY+s1rCr;
			s2G<=s1xY-s1gCb-s1gCr;
			s2B<=s1xY+s1bCb;   
			
			if s2R>(255+223)*256 then s3R<=255; 
			elsif s2R<223*256  then s3R<=0; 
			else s3R<=conv_integer(conv_std_logic_vector(s2R,18)(17 downto 8)) -223;	
			end if;	  
			
			if s2G>(255-136)*256  then s3G<=255; 
			elsif s2G<-136*256  then s3G<=0; 
			else s3G<=conv_integer(conv_std_logic_vector(s2G,18)(17 downto 8)) +136;
			end if;		
			
			if s2B>(255+277)*256  then s3B<=255; 
			elsif s2B<277*256  then s3B<=0; 
			else s3B<=conv_integer(conv_std_logic_vector(s2B,18)(17 downto 8)) -277;
			end if;
			
		end if;
	end process conv_proc; 
	RGB.R <= conv_std_logic_vector(s3R,8);
	RGB.G <= conv_std_logic_vector(s3G,8);
	RGB.B <= conv_std_logic_vector(s3B,8);
	
end architecture rtl;