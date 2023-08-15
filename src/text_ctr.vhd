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
	type array8_char_type is array (7 downto 0) of type_char;
	
	
	constant vadrVersion : type_vadr :=conv_std_logic_vector(23,6);
	constant hadrVersion : type_hadr :=conv_std_logic_vector(3,8);	  
	constant hwv0 : type_char := conv_std_logic_vector(((hw_version/100) mod 10)+48,8);
	constant hwv1 : type_char := conv_std_logic_vector(((hw_version/10) mod 10)+48,8);
	constant hwv2 : type_char := conv_std_logic_vector((hw_version mod 10)+48,8);
	constant fwv0 : type_char := conv_std_logic_vector(((fw_version/100) mod 10)+48,8);
	constant fwv1 : type_char := conv_std_logic_vector((fw_version/10 mod 10)+48,8);
	constant fwv2 : type_char := conv_std_logic_vector((fw_version mod 10)+48,8);
	constant fwr0 : type_char := conv_std_logic_vector(((fw_revision/100) mod 10)+48,8);
	constant fwr1 : type_char := conv_std_logic_vector(((fw_revision/10) mod 10)+48,8);
	constant fwr2 : type_char := conv_std_logic_vector((fw_revision mod 10)+48,8);
	constant fwt0 : type_char := conv_std_logic_vector(((fw_test/100) mod 10)+48,8);
	constant fwt1 : type_char := conv_std_logic_vector(((fw_test/10) mod 10)+48,8);
	constant fwt2 : type_char := conv_std_logic_vector((fw_test mod 10)+48,8);
	
	constant ParamLine : type_vadr :=conv_std_logic_vector(21,6);
	constant hadrLink0 : type_hadr :=conv_std_logic_vector(22,8);
	constant hadrLink1 : type_hadr :=conv_std_logic_vector(28,8);
	constant hadrPower : type_hadr :=conv_std_logic_vector(34,8);
	constant hadrVideo : type_hadr :=conv_std_logic_vector(40,8);
	constant line_on : array5_char_type :=(x"00",x"6f",x"6e",x"00",x"00");
	constant line_off : array5_char_type :=(x"00",x"6f",x"66",x"66",x"00");	
	
	type state_type is (idle,stLink0,stLink1,stPower,stVideo,stVersion);
	signal state : state_type:=idle;	
	signal vadr : type_vadr;
	signal hadr : type_hadr;   
	signal shiftChars: array5_char_type;
	
	
begin 
	map_adr<=vadr & hadr;
	map_dout<=shiftChars(4);
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
					vadr<=ParamLine;
					map_wr<='1';
					if count=4 then	
						hadr<=hadrLink0;
						if link0='1' then
							shiftChars<=line_on;
						else
							shiftChars<=line_off;
						end if;
					else 
						hadr<=hadr+1;
						shiftChars<=(shiftChars(3),shiftChars(2),shiftChars(1),shiftChars(0),x"00");
					end if;
					if count=0 then
						count:=4;
						state<=stLink1;
					else
						count:=count-1;
					end if;	
				
				when stLink1 => 
					vadr<=ParamLine;
					map_wr<='1';
					if count=4 then
						hadr<=hadrLink1; 
						if link1='1' then
							shiftChars<=line_on;
						else
							shiftChars<=line_off;
						end if;
					else 
						shiftChars<=(shiftChars(3),shiftChars(2),shiftChars(1),shiftChars(0),x"00");
						hadr<=hadr+1;
					end if;
					if count=0 then
						count:=4;
						state<=stPower;
					else
						count:=count-1;
					end if;
				
				when stPower => 
					vadr<=ParamLine;
					map_wr<='1';
					if count=4 then
						hadr<=hadrPower; 
						if power='1' then
							shiftChars<=line_on;
						else
							shiftChars<=line_off;
						end if;
					else 
						shiftChars<=(shiftChars(3),shiftChars(2),shiftChars(1),shiftChars(0),x"00");
						hadr<=hadr+1;
					end if;
					if count=0 then
						count:=4;
						state<=stVideo;
					else
						count:=count-1;
					end if;
				
				when stVideo => 
					vadr<=ParamLine;
					map_wr<='1';
					if count=4 then
						hadr<=hadrVideo; 
						if video='1' then
							shiftChars<=line_on;
						else
							shiftChars<=line_off;
						end if;
					else 
						hadr<=hadr+1;
						shiftChars<=(shiftChars(3),shiftChars(2),shiftChars(1),shiftChars(0),x"00");
					end if;
					if count=0 then
						count:=14;
						state<=stVersion;
					else
						count:=count-1;
					end if;
				
				when stVersion => 
					vadr<=vadrVersion;
					map_wr<='1';
					if count=14 then
						hadr<=hadrVersion; 
						shiftChars<=(hwv0,hwv1,hwv2,x"00",x"00");
					elsif count=10 then
						hadr<=hadr+1;
						shiftChars<=(fwv0,fwv1,fwv2,x"00",x"00");
					elsif count=6 then
						hadr<=hadr+1;
						shiftChars<=(fwr0,fwr1,fwr2,x"00",x"00");
					elsif count=2 then
						hadr<=hadr+1;
						shiftChars<=(fwt0,fwt1,fwt2,x"00",x"00");
					else 
						hadr<=hadr+1;
						shiftChars<=(shiftChars(3),shiftChars(2),shiftChars(1),shiftChars(0),x"00");
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