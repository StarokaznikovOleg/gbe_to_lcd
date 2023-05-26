-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.corund10_lib.all;

entity eth_module is
	generic( video_hsize:integer:=1920; video_vsize:integer:=1080; dma_size:integer:=8192 );
	port(
		reset : in STD_LOGIC;
		clock: in std_logic; 
		sync_err: out std_logic; 
		
		ethip_rdy: in std_logic;
		ethip_start: out std_logic;
		ethip_pre: in std_logic;
		ethip_dv: in std_logic;
		ethip_d : in std_logic_vector(7 downto 0);
		
		ethtx_en: out std_logic;
		ethtx_d : out std_logic_vector(7 downto 0)  
		
		);
end eth_module;

architecture main of eth_module is	
	constant ethPREA : std_logic_vector(63 downto 0):=x"55555555555555d5";
	constant ethMACD : std_logic_vector(63 downto 0):=x"ffffffffffff0000";
	constant ethMACS : std_logic_vector(63 downto 0):=x"001b638445e60000";
	type state_type is (idle,ethip_packet,ethip_CRC32,ethheader_PREA,ethheader_MACD,ethheader_MACS,ethheader_Frame0,ethheader_Frame1,
	ethheader_Ydata,ethheader_Cdata,ethheader_CRC32,ethheader_PAUSE);
	signal state : state_type:=idle;	
	signal shift_txd : std_logic_vector(63 downto 0):=(others=>'0');
	signal YV_count,YH_count : integer range 0 to 2047;
	signal inttx_en,intcrc_clr,intcrc_en,intcrc_out : std_logic:='0';
	signal inttx_d : std_logic_vector(7 downto 0):=(others=>'0');
	signal crc_calc : std_logic_vector(31 downto 0):=(others=>'0');
	signal check_Vphase,check_Hphase,check_Dphase,start_video_packet,syncYCerr,inc_vcounter,inc_hcounter : boolean;	
	
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
		variable count : integer range 0 to video_hsize*2-1 :=0;
	begin
		if reset='1' then 	
			ethip_start<='0';
			YV_count<=0; 
			YH_count<=0; 
			intcrc_clr<='0';
			intcrc_en<='0';
			ethtx_en<='0';	
			inttx_en<='0';
			inttx_d<=(others=>'0');
			ethtx_d<=(others=>'0');
			count:=0;
			inc_vcounter<=false;
			inc_hcounter<=false;
			shift_txd<=(others=>'0');
			sync_err<='0';
			check_Vphase<=false;
			check_Hphase<=false;
			check_Dphase<=false;
			start_video_packet<=false;
			syncYCerr<=false;
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
			if inc_vcounter then
				if YV_count=2047 then 
					YV_count<=0; 
				else
					YV_count<=YV_count+1; 
				end if;
			end if;
			if inc_vcounter then
				YH_count<=2047; 
			elsif inc_hcounter then
				if YH_count=2047 then 
					YH_count<=0; 
				else
					YH_count<=YH_count+1; 
				end if;
			end if;
			check_Vphase<=Y_Empty='0' and C_Empty='0' and Ydata(8)='1' and conv_integer(Ydata(7 downto 6))=V_marker and Ydata(8 downto 6)=Cdata(8 downto 6);
			check_Hphase<=Y_Empty='0' and C_Empty='0' and Ydata(8)='1' and conv_integer(Ydata(7 downto 6))=H_marker and Ydata(8 downto 6)=Cdata(8 downto 6);
			check_Dphase<=Y_Empty='0' and C_Empty='0' and Ydata(8)='1' and conv_integer(Ydata(7 downto 6))=D_marker and Ydata(8 downto 6)=Cdata(8 downto 6);
			start_video_packet<=Ydata_ready='1';
			sync_err<=boolean_to_data(syncYCerr);
			case state is
				when idle =>  
					intcrc_en<='0';
					inttx_en<='0';
					inttx_d<=x"00";
					shift_txd<=ethPREA;
					if check_Vphase or check_Hphase or check_Dphase then  
						inc_vcounter<=check_Vphase;
						inc_hcounter<=check_Hphase;
						Ydata_rdreq<='1';
						Cdata_rdreq<='1';
						count:=1;
						state<=ethheader_PAUSE;
					elsif start_video_packet then 
						count:=7;
						intcrc_clr<='1';
						state<=ethheader_PREA;
					elsif ethip_rdy='1' then 
						ethip_start<='1';
						intcrc_clr<='1';
						state<=ethip_packet;
					end if;	
				
				when ethip_packet => 
					intcrc_clr<='0';
					if ethip_dv='1' then
						intcrc_en<=not ethip_pre;
						inttx_en<='1';
						inttx_d<=ethip_d; 
					else
						intcrc_en<='0';
						intcrc_out<='1';
						count:=2;  
						ethip_start<='0';
						state<=ethip_CRC32;
					end if;	
					
				when ethip_CRC32 => 
					intcrc_en<='0';
					intcrc_out<='1';
					if count=0 then	
						count:=11;  
						state<=ethheader_PAUSE;
					else	
						count:=count-1;
					end if;	
				
				when ethheader_PREA => 
					intcrc_clr<='0';
					inttx_en<='1';
					inttx_d<=shift_txd(63 downto 56);
					if count=0 then
						count:=5;
						shift_txd<=ethMACD;
						state<=ethheader_MACD;
					else	
						shift_txd<=shift_txd(55 downto 0)& x"00";
						count:=count-1;
					end if;	 
				
				when ethheader_MACD => 
					intcrc_en<='1';
					inttx_d<=shift_txd(63 downto 56);
					if count=0 then
						count:=5;
						shift_txd<=ethMACS;
						state<=ethheader_MACS;
					else	
						shift_txd<=shift_txd(55 downto 0)& x"00";
						count:=count-1;
					end if;	 
				
				when ethheader_MACS => 
					inttx_d<=shift_txd(63 downto 56);
					if count=0 then
						count:=7;  
						shift_txd<=(others=>'0');
						state<=ethheader_Frame0;
					else	
						shift_txd<=shift_txd(55 downto 0)& x"00";
						count:=count-1;
					end if;	  
				
				when ethheader_Frame0 => 
					inttx_d<=shift_txd(63 downto 56);
					if count=0 then
						count:=7;  
						shift_txd<=conv_std_logic_vector(0,16) & conv_std_logic_vector(YV_count,16) & conv_std_logic_vector(0,15) & conv_std_logic_vector(YH_count,16) & '0';
						state<=ethheader_Frame1;
					else	
						shift_txd<=shift_txd(55 downto 0)& x"00";
						count:=count-1;
					end if;	 
				
				when ethheader_Frame1 => 
					inttx_d<=shift_txd(63 downto 56);
					shift_txd<=shift_txd(55 downto 0)& x"00";
					if count=0 then
						count:=video_hsize*2-1;  
						Ydata_rdreq<='1';
						state<=ethheader_Ydata;
					else	
						count:=count-1;
					end if;	 
				
				when ethheader_Ydata => 
					inttx_d<=Ydata(7 downto 0);	 
					if count=0 then	
						count:=video_hsize-1;  
						Ydata_rdreq<='0';
						Cdata_rdreq<='1';
						state<=ethheader_Cdata;
					else
						count:=count-1;
					end if;	 
				
				when ethheader_Cdata => 
					inttx_d<=Cdata(7 downto 0);	 
					if count=0 then	
						Cdata_rdreq<='0';
						count:=3;  
						state<=ethheader_CRC32;
					else
						count:=count-1;
					end if;	 
				
				when ethheader_CRC32 => 
					intcrc_en<='0';
					intcrc_out<='1';
					if count=0 then	
						syncYCerr<=Ydata/=Cdata;
						count:=11;  
						state<=ethheader_PAUSE;
					else	
						count:=count-1;
					end if;	
				
				
				when ethheader_PAUSE => 
					inc_vcounter<=false;
					inc_hcounter<=false;
					syncYCerr<=false;
					Ydata_rdreq<='0';
					Cdata_rdreq<='0';
					intcrc_out<='0';
					inttx_en<='0';
					inttx_d<=x"00";
					if count=0 then	  
						state<=idle;
					else	
						count:=count-1;
					end if;	 
				
				when others =>	--err_cycle
				
			end case;		
		end if;
	end process main_proc; 	
	
end main;