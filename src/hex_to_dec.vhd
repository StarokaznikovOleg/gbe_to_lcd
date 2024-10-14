-------------------------------------------------------------------------------
-- Title       : hex_to_dec
-- Design      : converter std_logic_vector to asci digital with sign and dot
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;

entity hex_to_dec is
	port( reset,clock: in std_logic; 
		start: in boolean;
		sign: in boolean;
		hex_data: in std_logic_vector(31 downto 0);		
		numb_val: in integer range 0 to 7;	
		dot_val: in integer range 0 to 7;	--hex_data/(10**dot_numb)	
		code: out std_logic_vector(7 downto 0);		
		code_oe: out boolean;
		ready: out boolean );
	
end hex_to_dec;

architecture main of hex_to_dec is	
	subtype  type_char is std_logic_vector(7 downto 0); 
	
	constant char_plus: type_char:=x"2b";   
	constant char_minus: type_char:=x"2d";   
	constant char_dot: type_char:=x"2e";   
	
	type state_type is (st_ready,st_sign,st_dig,st_stop,
	st_dig0,st_dig1,st_dig2,st_dig3,st_dig4,st_dig5);
	signal state : state_type;	
	signal int_hex_data : std_logic_vector(31 downto 0);
	signal int_numb_val,int_dot_val: integer range 0 to 15;
	signal inc_count: integer range 0 to 9;
	
begin
	--------------------------------------------	
	main_proc: process (reset,clock)
	begin
		if reset='1' then 
			int_hex_data<=(others=>'0');
			int_numb_val<=0;
			int_dot_val<=0;
			code<=(others=>'0');
			code_oe<=false;
			ready<=false;
			inc_count<=0;	
			state<=st_stop;
		elsif rising_edge(clock)  then 	
			case state is
				when st_ready => 
					code<=(others=>'0');
					code_oe<=false;
					if start then
						int_hex_data<=hex_data;	
						int_dot_val<=dot_val;	
						int_numb_val<=numb_val;	
						ready<=false;
						if sign then
							state<=st_sign;	
						else 
							state<=st_dig;
						end if;
					else
						ready<=true;
					end if;
				
				when st_sign => 
					if int_hex_data(31)='0' then
						code<=char_plus;
					else
						code<=char_minus;
						int_hex_data<=not int_hex_data;
					end if;	
--					int_hex_data(31)<='0'; 
					code_oe<=true;
					inc_count<=0;	
					state<=st_dig;
				
				when st_dig => 
					code_oe<=false;
					if int_numb_val=6 then
						state<=st_dig5;
					elsif int_numb_val=5 then
						state<=st_dig4;
					elsif int_numb_val=4 then
						state<=st_dig3;
					elsif int_numb_val=3 then
						state<=st_dig2;
					else
						state<=st_dig1;
					end if;
				
				when st_dig5 => 
					if 	int_dot_val=5 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					elsif conv_integer(int_hex_data)>100000 then
						int_hex_data<=int_hex_data-100000;
						inc_count<=inc_count+1;	
						code<=(others=>'0');
						code_oe<=false;
					else
						code<=x"3" & conv_std_logic_vector(inc_count,4);
						code_oe<=true;
						inc_count<=0;
						state<=st_dig4;
					end if;	
				
				when st_dig4 => 
					if 	int_dot_val=4 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					elsif conv_integer(int_hex_data)>=10000 then
						int_hex_data<=int_hex_data-10000;
						inc_count<=inc_count+1;	
						code<=(others=>'0');
						code_oe<=false;
					else
						code<=x"3" & conv_std_logic_vector(inc_count,4);
						code_oe<=true;
						inc_count<=0;
						int_dot_val<=int_dot_val-1;
						state<=st_dig3;
					end if;
				
				when st_dig3 => 
					if 	int_dot_val=3 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					elsif conv_integer(int_hex_data(13 downto 0))>=1000 then
						int_hex_data(13 downto 0)<=int_hex_data(13 downto 0)-conv_std_logic_vector(1000,14);
						inc_count<=inc_count+1;	
						code<=(others=>'0');
						code_oe<=false;
					else
						code<=x"3" & conv_std_logic_vector(inc_count,4);
						code_oe<=true;
						inc_count<=0;	
						state<=st_dig2;
					end if;
				
				when st_dig2 => 
					if 	int_dot_val=2 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					elsif conv_integer(int_hex_data(9 downto 0))>=100 then
						int_hex_data(9 downto 0)<=int_hex_data(9 downto 0)-conv_std_logic_vector(100,10);
						inc_count<=inc_count+1;	
						code<=(others=>'0');
						code_oe<=false;
					else
						code<=x"3" & conv_std_logic_vector(inc_count,4);
						code_oe<=true;
						inc_count<=0;	
						state<=st_dig1;
					end if;
				
				when st_dig1 => 
					if 	int_dot_val=1 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					elsif conv_integer(int_hex_data(6 downto 0))>=10 then
						int_hex_data(6 downto 0)<=int_hex_data(6 downto 0)-conv_std_logic_vector(10,7);
						inc_count<=inc_count+1;	
						code<=(others=>'0');
						code_oe<=false;
					else
						code<=x"3" & conv_std_logic_vector(inc_count,4);
						code_oe<=true;
						inc_count<=0;	
						state<=st_dig0;
					end if;
				
				when st_dig0 => 
					if 	int_dot_val=0 then
						int_dot_val<=15;
						code<=char_dot;
						code_oe<=true;
					else
						code<=x"3" & int_hex_data(3 downto 0);
						code_oe<=true;
						inc_count<=0;	
						state<=st_stop;
					end if;	
				
				when st_stop => 
					code<=(others=>'0');
					code_oe<=false;
					if 	not start then
						state<=st_ready;
					end if;	
				
			end case;
		end if;
	end process main_proc; 
end main; 
