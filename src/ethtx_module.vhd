--------------------------------------------------------------------------------
-- Title       : ethtx_module
-- Design      : GBE ETH tx controller from some mem buffers
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.eth_lib.all;

entity ethtx_module is
	port(
		reset : in STD_LOGIC;
		clock: in std_logic; 
		
		CMD_status : in STD_LOGIC;
		CMDmem_aq : out type_cmd_mem_adr;
		CMDmem_q : in type_cmd_mem_data;
		
		ethtx_en: out std_logic;
		ethtx_d : out std_logic_vector(7 downto 0)  
		
		);
end ethtx_module;

architecture main of ethtx_module is	
	type state_type is (idle,start_CMD,send_CMD,ethheader_CRC32,ethheader_PAUSE);
	signal state : state_type;	
	signal inttx_en,intcrc_clr,intcrc_en,intcrc_out : std_logic:='0';
	signal inttx_d : std_logic_vector(7 downto 0):=(others=>'0');
	signal crc_calc : std_logic_vector(31 downto 0):=(others=>'0');
	signal ADRcount: integer range 0 to 2**(cmd_mem_adr_len-1)-1; 
	
	signal CMD_status_sync,CMD_status_store : std_logic:='0';
	signal CMD_act : boolean;
	
	
begin 
	---------------------------------------------------------	
	sync_CMD_status : entity work.Sync 
	generic map( regime => "level", inDelay => 0, outDelay => 0 )
	port map(reset => '0',
		clk_in => clock, data_in => CMD_status,
		clk_out => clock, data_out => CMD_status_sync);
	---------------------------------------------------------	
	crc32_tx : entity work.crc32 
	generic map( BusWidth=>8 )
	port map( aclr => reset, clock => clock,
		sload => intcrc_clr,
		enable => intcrc_en,
		data_in => inttx_d,
		crc_out => open,
		crc_check => open,
		crc_calc => crc_calc
		);
	---------------------------------------------------------
	CMDmem_aq<=CMD_status_store & conv_std_logic_vector(ADRcount,cmd_mem_adr_len-1);
	main_proc: process (reset,clock)
		variable count : integer range 0 to eth_min_packet_len+eth_preambule_len;
	begin
		if reset='1' then 	
			intcrc_clr<='0';
			intcrc_en<='0';
			ethtx_en<='0';	
			inttx_en<='0';
			inttx_d<=(others=>'0');
			ethtx_d<=(others=>'0');
			ADRcount<=0;
			count:=0;
			state<=idle;
		elsif rising_edge(clock) then 	
			ethtx_en<=inttx_en;	
			if intcrc_out='1' then 
				case conv_integer(conv_std_logic_vector(count,2)) is
					when 2	=> ethtx_d<=crc_calc(31 downto 24);   
					when 1	=> ethtx_d<=crc_calc(23 downto 16);   
					when 0	=> ethtx_d<=crc_calc(15 downto 8);   
					when others => ethtx_d<=crc_calc(7 downto 0);   
				end case;
			else
				ethtx_d<=inttx_d;
			end if;
			CMD_act<=CMD_status_sync/=CMD_status_store;
			
			case state is
				when idle =>  
					intcrc_en<='0';
					inttx_en<='0';
					inttx_d<=x"00";
					count:=eth_min_packet_len+eth_preambule_len-1;
					ADRcount<=0;
					if CMD_act then 
						intcrc_clr<='1';
						CMD_status_store<=CMD_status_sync;
						state<=start_CMD;
					end if;	
				
				when start_CMD => 
					intcrc_clr<='0';
					ADRcount<=ADRcount+1;
					state<=send_CMD;   
				
				when send_CMD => 
					ADRcount<=ADRcount+1;
					inttx_d<=CMDmem_q(7 downto 0);
					inttx_en<='1';
					intcrc_en<=boolean_to_data(ADRcount>eth_preambule_len);
					if CMDmem_q(8)='0' and count=0 then
						count:=3;
						state<=ethheader_CRC32;
					elsif count/=0 then 
						count:=count-1; 
					end if;	
				
				when ethheader_CRC32 => 
					ADRcount<=0;
					intcrc_en<='0';
					intcrc_out<='1';
					if count=0 then	
						count:=11;  
						state<=ethheader_PAUSE;
					else	
						count:=count-1;
					end if;	
				
				when others => --ethheader_PAUSE => 
					intcrc_out<='0';
					inttx_en<='0';
					inttx_d<=x"00";
					if count=0 then	  
						state<=idle;
					else	
						count:=count-1;
					end if;	 
				
			end case;		
		end if;
	end process main_proc; 	
	
end main;