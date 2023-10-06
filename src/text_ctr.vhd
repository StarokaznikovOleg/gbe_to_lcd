-------------------------------------------------------------------------------
-- Title       : logo generator
-- Design      : gen_logo
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity text_ctr is
	port(
		reset,clock: in std_logic; 
		map_adr : out std_logic_vector(13 downto 0);
		map_wr : out std_logic;
		map_dout : out std_logic_vector(7 downto 0);
		
		link0,link1,power,video: in std_logic 
		);
end text_ctr;

architecture main of text_ctr is			 
	constant startLine : integer :=19;
	constant maxRow : integer :=5;
	constant maxCol : integer :=64;
	constant msg_test0 : integer:=0;
	constant msg_test1 : integer:=1;
	constant msg_test2 : integer:=2;
	constant msg_test3 : integer:=3;
	constant msg_test4 : integer:=4;   
	
	subtype type_message is integer range 0 to 31;
	type type_message_array is array (0 to maxRow-1) of type_message;	
	
	type state_type is (idle,st_update);
	signal state : state_type:=idle;	
	signal row_count : integer range 0 to maxRow-1;
	
	signal text_adr: std_logic_vector(10 downto 0);
	signal text_dout: std_logic_vector(7 downto 0);
	signal message: type_message; 
	signal message_line: type_message_array; 
	signal col_count: integer range 0 to maxCol-1;
begin
	text_adr(10 downto 6)<=conv_std_logic_vector(message,5);
	text_adr(5 downto 0)<=conv_std_logic_vector(col_count,6);
	map_adr(13 downto 8)<=conv_std_logic_vector(startLine+row_count,6);
	map_adr(7 downto 0)<=conv_std_logic_vector(col_count-1,8);
	map_dout<=text_dout;
	--------------------------------------------	
	main: process (reset,clock)  
	begin
		if reset='1' then 	
			map_wr<='0';
			col_count<=0;
			row_count<=0;
			message<=0;
			map_wr<='0';
			message_line<=(others=>0);
		elsif rising_edge(clock)then 
			if link0='1' then	
				message_line(0)<=1;
			else
				message_line(0)<=0;
			end if;
			if link1='1' then	
				message_line(1)<=2;
			else
				message_line(1)<=0;
			end if;
			if power='1' then	
				message_line(2)<=3;
			else
				message_line(2)<=0;
			end if;
			if video='1' then	
				message_line(3)<=3;
			else
				message_line(3)<=0;
			end if;
			message_line(4)<=4;
			case state is
				when idle => 
					map_wr<='0';
					col_count<=0;
					row_count<=0;
					message<=message_line(0);
					map_wr<='0';
					state<=st_update;
				
				when st_update => 
					map_wr<='1';
					if col_count=63 then
						if row_count=4 then
							state<=idle;
						else
							row_count<=row_count+1;
							message<=message_line(row_count+1);
						end if;
						col_count<=0;
					else
						col_count<=col_count+1;
					end if;	
				
				when others => 
					state<=idle;
				
			end case;
		end if;
	end process main; 	
	
	table_TEXT1 : entity work.table_TEXT 	 
	port map(
		reset => '0',
		ce => '1',
		oce => '1',
		clk => clock,
		ad => text_adr,
		dout => text_dout
		);	
end main;