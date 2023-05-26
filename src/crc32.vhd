--------------------------------------------------------------------------------------
-- Revision Updated:
-- 	Version = 0000 - Initial draft.
--------------------------------------------------------------------------------------
-- CRC8:	if	CRCWidth = 8 	generate 	   -- ATM set
--			init  <= x"FF";
--			poly  <= x"07";
--			calc  <= x"84";
--			check <= x"95";
--		end generate CRC8;	
--
--CRC32:	if	CRCWidth = 32 	generate 		-- ETHERNET	set
--			init  <= x"FFFFFFFF";
--			poly  <= x"04C11DB7";
--			calc  <= x"FFFFFFFF";
--			check <= x"C704DD7B";
--		end generate CRC32;	
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity crc32 is  		
	generic (BusWidth:Integer :=8); 
	port (
		aclr 		: in std_logic:='0';  							-- reset of crc_nibble
		clock 		: in std_logic;     							-- main clock
		sload 		: in std_logic:='0';				 			-- sload a init state of crc_nibble
		enable 		: in std_logic:='1';			  				-- enable for crc_nibble calculate 
		data_in   	: in std_logic_vector(BusWidth-1 downto 0):=(others=>'0');		-- value for crc_nibble calculate 
		crc_out 	: out std_logic_vector(31 downto 0);	-- current state of crc_nibble
		crc_check 	: out std_logic_vector(31 downto 0);	-- output for crc checking ?(crc_check[]==gnd)
		crc_calc  	: out std_logic_vector(31 downto 0)  	-- output for write crc to packet end.
		); 
end entity;

architecture main of crc32 is 
	
	constant CRCWidth	: Integer:=32;
	constant data_value	: integer:= CRCWidth / BusWidth;
	
	constant s_init  : std_logic_vector(CRCWidth-1 downto 0):=x"FFFFFFFF";
	constant s_poly  : std_logic_vector(CRCWidth-1 downto 0):=x"04C11DB7";
	constant s_calc  : std_logic_vector(CRCWidth-1 downto 0):=x"FFFFFFFF";
	constant s_check : std_logic_vector(CRCWidth-1 downto 0):=x"C704DD7B";  
	
	signal reg : std_logic_vector(CRCWidth-1 downto 0); 
	type my_array is array (BusWidth downto 0) of std_logic_vector(CRCWidth-1 downto 0);
	signal R : my_array;	  
begin		 
	
	R(0)(CRCWidth-1 downto 0)<=reg; 
	n : for n in 1 to BusWidth generate	
		k : for k in 1 to CRCWidth-1 generate	
			R(n)(k)<=R(n-1)(k-1) xor (s_poly(k) and ( R(n-1)(CRCWidth-1) xor data_in(n-1) ));
		end generate k;
		R(n)(0)<=s_poly(0) and (R(n-1)(CRCWidth-1) xor data_in(n-1));
	end generate n;
	
	process(clock, aclr)
	begin
		if aclr='1' then
			reg<=s_init;	
		elsif rising_edge(clock) then
			if (sload='1') then  
				reg<=s_init;	
			elsif (enable='1') then  
				reg<=R(BusWidth)(CRCWidth-1 downto 0);	
			end if;		
		end if;
	end process; 
	
	crc_out<=reg;  
	-- output inversion for Ethernet packets
	i : for i in 0 to data_value-1 generate	  --0,1,2,3
		j : for j in 0 to BusWidth-1 generate -- 0:7,8:15,16:23,24:31	
			crc_calc(i*BusWidth+j)<=reg((i+1)*BusWidth-1-j) xor s_calc((i+1)*BusWidth-1-j);
			crc_check(i*BusWidth+j)<=reg((i+1)*BusWidth-1-j) xor s_check((i+1)*BusWidth-1-j);
		end generate j;
	end generate i;
end architecture;	