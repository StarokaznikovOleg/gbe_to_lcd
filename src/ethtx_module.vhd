-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;

entity ethtx_module is
--	generic( video_hsize:integer:=1920; video_vsize:integer:=1080; dma_size:integer:=8192 );
	port(
		reset : in STD_LOGIC;
		clock: in std_logic; 
		error: out std_logic; 
		
		ethA_rdy: in std_logic;
		ethA_start: out std_logic;
		ethA_pre: in std_logic;
		ethA_dv: in std_logic;
		ethA_d : in std_logic_vector(7 downto 0);
		
		ethB_rdy: in std_logic;
		ethB_start: out std_logic;
		ethB_pre: in std_logic;
		ethB_dv: in std_logic;
		ethB_d : in std_logic_vector(7 downto 0);
		
		ethtx_en: out std_logic;
		ethtx_d : out std_logic_vector(7 downto 0)  
		
		);
end ethtx_module;

architecture main of ethtx_module is	
	constant ethPREA : std_logic_vector(63 downto 0):=x"55555555555555d5";
	constant ethMACD : std_logic_vector(63 downto 0):=x"ffffffffffff0000";
	constant ethMACS : std_logic_vector(63 downto 0):=x"001EFA40428F0000";
	type state_type is (idle,
	ethB_packet,ethA_packet,eth_CRC32,
	--	ethheader_PREA,ethheader_MACD,ethheader_MACS,ethheader_Frame0,ethheader_Frame1,	ethheader_Ydata,ethheader_Cdata,ethheader_CRC32,
	ethheader_PAUSE);
	signal state : state_type:=idle;	
	signal shift_txd : std_logic_vector(63 downto 0):=(others=>'0');
	signal inttx_en,intcrc_clr,intcrc_en,intcrc_out : std_logic:='0';
	signal inttx_d : std_logic_vector(7 downto 0):=(others=>'0');
	signal crc_calc : std_logic_vector(31 downto 0):=(others=>'0');
	signal shift_ethA_dv,shift_ethB_dv : std_logic_vector(2 downto 0):=(others=>'0');
	
begin 
	
	ethtx_crc32 : entity work.crc32 
	generic map( BusWidth=>8 )
	port map(
		aclr => reset,
		clock => clock,
		sload => intcrc_clr,
		enable => intcrc_en,
		data_in => inttx_d,
		crc_out => open,
		crc_check => open,
		crc_calc => crc_calc
		);
	
	main_proc: process (reset,clock)
		variable count : integer range 0 to 15 :=0;
	begin
		if reset='1' then 	
			error<='0';
			ethA_start<='0';
			ethB_start<='0';
			intcrc_clr<='0';
			intcrc_en<='0';
			ethtx_en<='0';	
			inttx_en<='0';
			inttx_d<=(others=>'0');
			ethtx_d<=(others=>'0');
			shift_ethA_dv<=(others=>'0');
			shift_ethB_dv<=(others=>'0');
			count:=0;
			shift_txd<=(others=>'0');
			state<=idle;
		elsif rising_edge(clock) then 	
			ethtx_en<=inttx_en;	
			shift_ethA_dv<=shift_ethA_dv(1 downto 0) & ethA_dv;
			shift_ethB_dv<=shift_ethA_dv(1 downto 0) & ethA_dv;
			error<=boolean_to_data(shift_ethB_dv="101" or shift_ethA_dv="101");	
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
			case state is
				when idle =>  
					intcrc_en<='0';
					intcrc_clr<='1';
					inttx_en<='0';
					inttx_d<=x"00";
					shift_txd<=ethPREA;
					if ethA_rdy='1' then 
						ethA_start<='1';
						state<=ethA_packet;
					elsif ethB_rdy='1' then 
						ethB_start<='1';
						state<=ethB_packet;
					end if;	
				
				when ethA_packet => 
					intcrc_clr<='0';
					if ethA_dv='1' then
						intcrc_en<=not ethA_pre;
						inttx_en<='1';
						inttx_d<=ethA_d; 
					else
						intcrc_en<='0';
						intcrc_out<='1';
						count:=2;  
						ethA_start<='0';
						state<=eth_CRC32;
					end if;	
				
				when ethB_packet => 
					intcrc_clr<='0';
					if ethB_dv='1' then
						intcrc_en<=not ethB_pre;
						inttx_en<='1';
						inttx_d<=ethB_d; 
					else
						intcrc_en<='0';
						intcrc_out<='1';
						count:=2;  
						ethB_start<='0';
						state<=eth_CRC32;
					end if;	
				
				when eth_CRC32 => 
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