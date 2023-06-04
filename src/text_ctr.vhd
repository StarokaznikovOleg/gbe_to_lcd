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
	subtype type_vadr is std_logic_vector(5 downto 0);
	subtype type_hadr is std_logic_vector(7 downto 0);
	subtype type_char is std_logic_vector(7 downto 0);
	type array5_char_type is array (4 downto 0) of type_char;
	
	constant line_on : array5_char_type :=(x"00",x"6f",x"6e",x"00",x"00");
	constant line_off : array5_char_type :=(x"00",x"6f",x"66",x"66",x"00");	 
	
	constant Parameters : type_vadr :=conv_std_logic_vector(21,6);
	constant hadrLink0 : type_hadr :=conv_std_logic_vector(22,8);
	constant hadrLink1 : type_hadr :=conv_std_logic_vector(28,8);
	constant hadrPower : type_hadr :=conv_std_logic_vector(34,8);
	constant hadrVideo : type_hadr :=conv_std_logic_vector(40,8);
	
	type state_type is (idle,stlink0,stlink1,stpower,stvideo);
	signal state : state_type:=idle;	
	signal vadr : type_vadr;
	signal hadr : type_hadr;   
	signal shiftdata: array5_char_type;
	
	
begin 
	map_adr<=Parameters & hadr;
	map_dout<=shiftdata(4);
	--------------------------------------------	
	main: process (reset,clock)  
		variable count: integer range 0 to 255;
	begin
		if reset='1' then 	
			state<=idle;
		elsif rising_edge(clock)then 
			case state is
				when idle => 
					map_wr<='0';
					count:=4;
					state<=stLink0;
				
				when stLink0 => 
					map_wr<='1';
					if count=4 then	
						if link0='1' then
							shiftdata<=line_on;
						else
							shiftdata<=line_off;
						end if;
						hadr<=hadrLink0;
					else 
						hadr<=hadr+1;
						shiftdata<=(shiftdata(3),shiftdata(2),shiftdata(1),shiftdata(0),x"00");
					end if;
					if count=0 then
						count:=4;
						state<=stLink1;
					else
						count:=count-1;
					end if;	
				
				when stLink1 => 
					map_wr<='1';
					if count=4 then
						if link1='1' then
							shiftdata<=line_on;
						else
							shiftdata<=line_off;
						end if;
						hadr<=hadrLink1; 
					else 
						hadr<=hadr+1;
						shiftdata<=(shiftdata(3),shiftdata(2),shiftdata(1),shiftdata(0),x"00");
					end if;
					if count=0 then
						count:=4;
						state<=stPower;
					else
						count:=count-1;
					end if;
					
				when stPower => 
					map_wr<='1';
					if count=4 then
						hadr<=hadrPower; 
						if power='1' then
							shiftdata<=line_on;
						else
							shiftdata<=line_off;
						end if;
					else 
						hadr<=hadr+1;
						shiftdata<=(shiftdata(3),shiftdata(2),shiftdata(1),shiftdata(0),x"00");
					end if;
					if count=0 then
						count:=4;
						state<=stVideo;
					else
						count:=count-1;
					end if;
						
				when stVideo => 
					map_wr<='1';
					if count=4 then
						hadr<=hadrVideo; 
						if power='1' then
							shiftdata<=line_on;
						else
							shiftdata<=line_off;
						end if;
					else 
						hadr<=hadr+1;
						shiftdata<=(shiftdata(3),shiftdata(2),shiftdata(1),shiftdata(0),x"00");
					end if;
					if count=0 then
						count:=4;
						state<=idle;
					else
						count:=count-1;
					end if;
			
				when others => 
					state<=idle;
				
			end case;
		end if;
	end process main; 
	
end main;