--------------------------------------------------------------------------------
-- Title       : ethtx_module
-- Design      : GBE ETH tx controller from some mem buffers
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package ETH_lib is  
	
	constant max_ethErrors : integer :=2; 	  
	subtype type_ethErr is std_logic_vector(max_ethErrors-1 downto 0);	 
	type type_ethErrors is record
		clk : type_ethErr;
		err : type_ethErr;
	end record;
	constant clear_ethErrors : type_ethErrors := ((others=>'0'),(others=>'0'));	
	
	constant eth_preambule_len : integer:=8; --x"55 55 55 55 55 55 55 d5"
	constant eth_min_packet_len : integer:=60; 
	
	
	-- CMD settings
	constant eth_CMD_header_len: integer:=50;
	constant eth_CMD_header_iplenght: integer:=24;
	constant eth_CMD_header_ADRiplenght: integer:=24; -- address for the fild of ip lenght.
	constant eth_CMD_header_ADRipid: integer:=26; -- address for the fild of ip id.
	constant eth_CMD_header_ADRipchecksum: integer:=32; -- address for the fild of ip checksum.
	constant eth_CMD_header_ADRudplenght: integer:=46; -- address for the fild of ip udp lenght.
	constant eth_CMD_header_ADRudpchecksum: integer:=48; -- address for the fild of ip udp checksum.
	constant CMD_mem_adr_len: integer:=11;
	constant CMD_mem_data_len: integer:=9;
	subtype type_CMD_mem_adr is std_logic_vector(CMD_mem_adr_len-1 downto 0);
	subtype type_CMD_mem_data is std_logic_vector(CMD_mem_data_len-1 downto 0);
	
end ETH_lib;	

