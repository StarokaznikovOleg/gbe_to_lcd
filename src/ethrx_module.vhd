-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.vimon10_lib.all;
use work.visca_lib.all;
use work.voice_lib.all;
use work.tmp100_lib.all;

entity ethrx_module is
	generic( hsize:integer:=1920; vsize:integer:=1080);
	port(
		reset : in STD_LOGIC;
		clock: in std_logic; 
		err: out std_logic_vector(3 downto 0); 
		vsync: out std_logic; 
		mvk3: out type_mvk3; 
		
		ethrx_en: in std_logic;
		ethrx_d : in std_logic_vector(7 downto 0);  
		
		ethv_a : out std_logic_vector(11 downto 0);  
		ethv_wr: out std_logic;
		ethv_d : out std_logic_vector(31 downto 0)  
		
		);
end ethrx_module;

architecture main of ethrx_module is	
	constant adrBuff_status : integer:=0;
	constant adrBuff_start : integer:=1;
	constant status_signature : std_logic_vector(15 downto 0):=x"428F";
	
	constant ethPREA : std_logic_vector(39 downto 0):=x"55555555d5";
	constant ethMACD : std_logic_vector(47 downto 0):=x"ffffffffffff";
	constant ethMACS : std_logic_vector(47 downto 0):=x"001b638445e6";	
	constant ethVType : std_logic_vector(31 downto 0):=x"00000000";	
	constant ethSType : std_logic_vector(31 downto 0):=x"00000001";	
	constant ethPType : std_logic_vector(31 downto 0):=x"00000002";	
	constant ethCType : std_logic_vector(31 downto 0):=x"08004500";	 
	
	constant cmd_visca_zoom : std_logic_vector(15 downto 0):=x"9050";	
	
	constant len_Vformat : integer:=8;
	constant len_Vframe_seq : integer:=4;
	constant len_VLine_seq : integer:=4;   
	
	constant count_max : integer:=47;   
	constant count_prea : integer:=35;   
	constant count_start : integer:=33;   
	constant count_macd : integer:=26;   
	constant count_macs : integer:=20;   
	constant count_Etype : integer:=17;   
	constant count_TStamp : integer:=13;   
	constant count_FSeq : integer:=9;   
	constant count_SSeq : integer:=5;   
	constant count_vline : integer:=1;   
	
	type state_type is (ethpause,idle,ethheader,ethVdata,ethSdata,ethPdata,ethCdata,ethexit);
	signal state : state_type:=ethpause;	
	signal shift_txd : std_logic_vector(63 downto 0):=(others=>'0');
	signal intcrc_clr,intcrc_en : std_logic:='0';
	signal crc_check : std_logic_vector(31 downto 0):=(others=>'0');
	signal ok_PREA,ok_MACD,ok_MACS,ok_VType,ok_SType,ok_PType,ok_CType,visca_zoom_cmd :boolean;
	signal adrBuffHi,numBuff : std_logic:='0';
	signal adrBuff:integer range 0 to 2**11-1;
	constant max_plen_count : integer :=hsize*3-1;
	signal plen_count : integer range 0 to max_plen_count :=0;
	signal Vcount : integer range 0 to vsize :=0;	
	signal err_len,err_crc,err_frame,err_sequence : std_logic:='0';
	--	signal Fcount : integer range 0 to 255;
	signal vsync_int,vsync_delay0,vsync_delay1,int_voice : std_logic:='0';
	signal Ssync_int :boolean;
	--	signal voice_level : type_log_data;
	constant store_size :integer := 32;
	signal voice_level_acc: std_logic_vector(store_size-1 downto 0);
	signal zoom_level: std_logic_vector(15 downto 0);
	
begin 
	err(0)<=err_crc;
	err(1)<=err_frame;
	err(2)<=err_len;
	err(3)<=err_sequence; 
	
	mvk3.clock<=clock;	
	
	ethv_a(11)<=adrBuffHi;	
	ethv_a(10 downto 0)<=conv_std_logic_vector(adrBuff,11);	
	ethtx_crc32 : entity work.crc32 
	generic map( BusWidth=>8 )
	port map(
		aclr => reset,
		clock => clock,
		sload => intcrc_clr,
		enable => intcrc_en,
		data_in => ethrx_d,
		crc_out => open,
		crc_check => crc_check,
		crc_calc => open
		);
	numBuff<=conv_std_logic_vector(Vcount,1)(0);	
	main_proc: process (reset,clock)
		variable count : integer range 0 to count_max :=0;
		constant Scount_max: integer :=400;
		variable Scount : integer range 0 to Scount_max :=0;
	begin
		if reset='1' then 	
			err_len<='0';
			err_crc<='0';
			err_frame<='0';
			err_sequence<='0';
			adrBuffHi<='0';
			adrBuff<=0; 
			ethv_wr<='0';
			ethv_d<=(others=>'0'); 
			intcrc_clr<='0';
			intcrc_en<='0';
			ok_PREA<=false;
			ok_MACD<=false;
			ok_MACS<=false;
			ok_VType<=false;
			ok_SType<=false;
			ok_PType<=false;
			Vcount<=0;
			plen_count<=0;
			vsync_delay0<='0';
			vsync_delay1<='0';
			vsync_int<='0';
			voice_level_acc<=(others=>'0'); 
			count:=0;
			mvk3.ena<='0';
			state<=ethpause;
		elsif rising_edge(clock) then 	
			ok_PREA<=shift_txd(31 downto 0) & ethrx_d=ethPREA;
			ok_MACD<=shift_txd(47 downto 0)=ethMACD;
			ok_MACS<=shift_txd(47 downto 0)=ethMACS;
			vsync<=boolean_to_data(Vcount=0);
			shift_txd<=shift_txd(55 downto 0) & ethrx_d;	 
			vsync_delay0<=boolean_to_data(Vcount=0);
			vsync_delay1<=vsync_delay0;
			vsync_int<=boolean_to_data(vsync_delay0='1' and vsync_delay1='0');
			case state is
				when idle =>  
					mvk3.ena<='0';
					err_len<='0';
					err_crc<='0';
					err_sequence<='0';
					err_frame<='0';
					ethv_wr<='0';
					intcrc_en<='0';
					if ethrx_en='1' then
						count:=count_max;
						intcrc_clr<='1';
						state<=ethheader;
					end if;	 
				
				when ethheader => 
					ethv_d<=shift_txd(31 downto 0); 
					plen_count<=max_plen_count;
					adrBuffHi<=numBuff;
					adrBuff<=adrBuff_start; 
					intcrc_clr<='0';
					if ethrx_en='0' then
						state<=ethpause;
					elsif count=count_prea then	
						err_frame<='1';
						state<=ethpause;
						--					elsif count=count_macd and not ok_MACD then
						--						state<=ethpause;
						--					elsif count=count_macs and not ok_MACS then
						--						state<=ethpause;
					elsif count=count_vline then
						if ok_VType then
							state<=ethVdata;
							ethv_wr<='1';
						elsif ok_SType then
							state<=ethSdata;
						elsif ok_PType then
							state<=ethPdata;
						elsif ok_CType then
							state<=ethCdata;
						else 
							state<=ethpause;
						end if;		
					end if;		
					if count=count_Etype then
						ok_VType<=shift_txd(31 downto 0)=ethVType;
						ok_SType<=shift_txd(31 downto 0)=ethSType;
						ok_PType<=shift_txd(31 downto 0)=ethPType;
						ok_CType<=shift_txd(31 downto 0)=ethCType;
					end if;	 
					--					if count=count_FSeq then	 
					--						Fcount<=conv_integer(shift_txd(7 downto 0));
					--					end if;	 
					if ok_VType and count=count_SSeq then	 
						Vcount<=conv_integer(shift_txd(16 downto 1));
						err_sequence<=boolean_to_data(conv_integer(shift_txd(16 downto 1))/=Vcount and conv_integer(shift_txd(16 downto 1))/=0) ;
					end if;	 
					if count>count_prea and (shift_txd(31 downto 0) & ethrx_d)=ethPREA then
						intcrc_en<='1';
						count:=count_start;
					elsif count/=0 then
						count:=count-1;
					end if;	 
				
				when ethVdata => 
					if ethrx_en='1' then 
						ethv_d<=shift_txd(31 downto 0); 
					else
						ethv_d<=x"00000000"; 
					end if;
					intcrc_en<=ethrx_en;
					if count=1 then
						adrBuff<=adrBuff+1;
						ethv_wr<='1';
					else
						ethv_wr<='0';
					end if;	 
					
					if ethrx_en='0' then 
						err_len<=boolean_to_data(plen_count/=0);
						err_crc<=boolean_to_data(crc_check/=x"0000");
						if plen_count/=0 or crc_check/=x"0000" then
							state<=ethpause; 
						else
							state<=ethexit;
						end if;
					end if;	
					plen_count<=plen_count-1;
					if count=0 then
						count:=3;  
					else
						count:=count-1;
					end if;	 
				
				when ethexit => 
					adrBuffHi<='0';
					adrBuff<=adrBuff_status; 
					ethv_d(31 downto 16)<=status_signature;
					ethv_d(15)<='0';
					ethv_d(14)<='0';
					ethv_d(13 downto 4)<=conv_std_logic_vector(Vcount,10);
					ethv_d(3)<=err_len or err_crc or err_sequence;
					ethv_d(2)<=numBuff;
					ethv_d(1)<=boolean_to_data(Vcount=vsize/2-1);
					ethv_d(0)<=boolean_to_data(Vcount=0);
					ethv_wr<='1'; 
					Vcount<=Vcount+1;
					state<=idle;
				
				when ethSdata => 
					ethv_wr<='0';  
					if count=5 then 
						if voice_level_acc(31)='0' then
							if shift_txd(63)='0' then	
								voice_level_acc<=voice_level_acc + ext(shift_txd(62 downto 48),store_size); 
							elsif  shift_txd(63)='1' then	
								voice_level_acc<=voice_level_acc + ext(not shift_txd(62 downto 48),store_size); 
							end if;
						end if;
					elsif count=4 then 
						voice_level_acc<=voice_level_acc - ext(voice_level_acc(31 downto 13),store_size); 
					end if;	
					
					if count=0 then
						count:=7;  
					else
						count:=count-1;
					end if;	 
					if ethrx_en='0' then 
						state<=idle;
					end if;	
				
				when ethPdata => 
				ethv_wr<='0';  
					if count=47 then mvk3.data.hw_version<= conv_integer(shift_txd(39 downto 32)); end if;	 
					if count=47 then mvk3.data.fw_version<= conv_integer(shift_txd(31 downto 24)); end if;	 
					if count=47 then mvk3.data.fw_revision<= conv_integer(shift_txd(23 downto 16)); end if;	 
					if count=47 then mvk3.data.fw_test<= conv_integer(shift_txd(15 downto 8)); end if;	 
					if count=47 then mvk3.data.link<=shift_txd(5); end if; 
					if count=47 then mvk3.data.DB<=shift_txd(4 downto 0); end if;	
					if count=46 then mvk3.data.tmp100.act<=data_to_boolean(shift_txd(6)); end if;
					if count=46 then mvk3.data.voice_act<=shift_txd(5); end if;
					if count=46 then mvk3.data.CAM_PWR<=shift_txd(3); end if;
					if count=46 then mvk3.data.FRONT_HEAD<=shift_txd(2); end if;
					if count=46 then mvk3.data.HEAD<=shift_txd(1); end if;
					if count=46 then mvk3.data.COLD<=shift_txd(0); end if;	
					if count=45 then mvk3.data.voice_level<= conv_integer(shift_txd(7 downto 0)); end if;
					if count=43 then mvk3.data.tmp100.val<= shift_txd(15 downto 0); end if;	
					
					if count=0 then
						count:=count_max;  
					else
						count:=count-1;
					end if;	 
					if ethrx_en='0' then 
						mvk3.ena<='1';
						state<=idle;
					end if;	
				
				when ethCdata => 
					ethv_wr<='0';  
					if count=37 then  
						visca_zoom_cmd<=cmd_visca_zoom=shift_txd(15 downto 0);  
					end if;	
					if visca_zoom_cmd then
						if count=36 then  
							zoom_level(15 downto 12)<=shift_txd(3 downto 0);
						elsif count=35 then  
							zoom_level(11 downto 8)<=shift_txd(3 downto 0);
						elsif count=34 then  
							zoom_level(7 downto 4)<=shift_txd(3 downto 0);
						elsif count=33 then  
							zoom_level(3 downto 0)<=shift_txd(3 downto 0);
						end if;	
					end if;	
						if count=32 and zoom_level/=x"0000" then  zoom_level<=zoom_level-1; end if;
						if count=31 then  mvk3.data.zoom_level<=conv_integer(zoom_level(13 downto 7)); end if;
					
					if count=0 then
						count:=count_max;  
					else
						count:=count-1;
					end if;	 
					if ethrx_en='0' then 
						mvk3.ena<='1';
						state<=idle;
					end if;	
				
				when ethpause => 
					ethv_wr<='0';
					if ethrx_en='0' then 
						state<=idle;
					end if;	
				
			end case;		
		end if;
	end process main_proc; 	
	
	
end main;