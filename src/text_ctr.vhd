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
	subtype type_line is std_logic_vector(5 downto 0);
	subtype type_hadr is std_logic_vector(7 downto 0);
	subtype type_char is std_logic_vector(7 downto 0);
	
	constant ParamLine1 : type_line :=conv_std_logic_vector(19,6);
	constant ParamLine2 : type_line :=conv_std_logic_vector(20,6);
	constant ParamLine3 : type_line :=conv_std_logic_vector(21,6);
	
	type state_type is (idle,st_Lparam1,st_Lparam2);
	signal state : state_type:=idle;	
	signal line_sel : type_line;
	
	signal text_adr: std_logic_vector(10 downto 0);
	signal text_dout: type_char;
	signal message: integer range 0 to 31; 
	constant message_test0 : integer:=0;
	constant message_test1 : integer:=1;
	constant message_test2 : integer:=2;
	constant message_test3 : integer:=3;
	constant message_test4 : integer:=4;
	signal col_count: integer range 0 to 255;
begin
	text_adr(10 downto 6)<=conv_std_logic_vector(message,5);
	text_adr(5 downto 0)<=conv_std_logic_vector(col_count,6);
	map_adr(13 downto 8)<=line_sel;
	map_adr(7 downto 0)<=conv_std_logic_vector(col_count-1,8);
	map_dout<=text_dout;
	--------------------------------------------	
	main: process (reset,clock)  
	begin
		if reset='1' then 	
			state<=idle;
		elsif rising_edge(clock)then 
			case state is
				when idle => 
					map_wr<='0';
					col_count<=0;
					state<=st_Lparam1;
				
				when st_Lparam1 => 
					line_sel<=ParamLine1;
					if link0='1' then
						message<=message_test1;
					else
						message<=message_test2;
					end if;
					if col_count>1 and col_count<62 then	
						map_wr<='1';
					end if;
					if col_count=63 then
						col_count<=0;
						state<=st_Lparam2;
					else
						col_count<=col_count+1;
					end if;	
				
				when st_Lparam2 => 
					line_sel<=ParamLine2;
					if link0='1' then
						message<=message_test3;
					else
						message<=message_test4;
					end if;
					if col_count>1 and col_count<62 then	
						map_wr<='1';
					end if;
					if col_count=63 then
						col_count<=0;
						state<=idle;
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