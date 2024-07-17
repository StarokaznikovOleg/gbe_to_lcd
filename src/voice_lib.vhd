-------------------------------------------------------------------------------
-- Title       : nau88c_lib
-- Design      : codec lib
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package voice_lib is  
	constant max_level :integer := 32;
	constant delay_level :integer := 9;
	subtype type_level is std_logic_vector(max_level-1 downto 0);	
	type type_voice_level is record	 
		ena : std_logic;
		clock : std_logic;
		act : std_logic;
		tmp : std_logic_vector(31 downto 0);
		level : type_level;
	end record;	
	constant clear_voice_level : type_voice_level := ('0','0','0',(others=>'0'),(others=>'0'));	 
	constant max_log_data :integer := 65535;
	subtype type_log_data is integer range 0 to max_log_data;	
	type type_log_level is array (0 to max_level-1) of type_log_data;
	constant log_level: type_log_level:=(
0,
96,
194,
296,
401,
510,
623,
741,
863,
991,
1124,
1264,
1410,
1564,
1726,
1898,
2080,
2273,
2480,
2703,
2943,
3204,
3490,
3806,
4159,
4560,
5022,
5569,
6239,
7102,
8318,
10397
	);
	
end voice_lib;
