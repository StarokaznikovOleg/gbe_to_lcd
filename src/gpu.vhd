-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;
use work.common_lib.all;

entity gpu is
	port(
		reset : in STD_LOGIC;
		clock: in std_logic; 
		err: out std_logic_vector(3 downto 0); 
		no_signal: out std_logic; 
		
		O_sdrc_rst_n: out std_logic;
		O_sdrc_selfrefresh: out std_logic;
		O_sdrc_power_down: out std_logic;
		O_sdrc_wr_n: out std_logic;
		O_sdrc_rd_n: out std_logic;
		O_sdrc_addr: out std_logic_vector(20 downto 0);
		O_sdrc_data_len: out std_logic_vector(7 downto 0);
		O_sdrc_dqm: out std_logic_vector(3 downto 0);
		O_sdrc_data: out std_logic_vector(31 downto 0); 
		I_sdrc_data: in std_logic_vector(31 downto 0);
		I_sdrc_init_done: in std_logic;
		I_sdrc_busy_n: in std_logic;
		I_sdrc_rd_valid: in std_logic;
		I_sdrc_wrd_ack: in std_logic;
		
		rx_a: out std_logic_vector(11 downto 0);
		rx_wr: out std_logic;
		rx_d: out std_logic_vector(31 downto 0);
		rx_q: in std_logic_vector(31 downto 0);
		
		tx_sel: out std_logic_vector(2 downto 0);
		tx_a: out std_logic_vector(9 downto 0);
		tx_wr: out std_logic;
		tx_d: out std_logic_vector(31 downto 0);
		tx_q: in std_logic_vector(31 downto 0)
		
		);
end gpu;

architecture main of gpu is	
	constant wd_timeout : integer:=1;  --sec
	constant video_hsize : integer:=1280;
	constant video_vsize : integer:=800;
	constant mem_val : integer:=21; --value sdram address ;  
	constant Hmem_val : integer:=3; --value of memory tranzaction   !!!! log2(Hmem_len);  
	constant Smem_val : integer:=8; --value of tranzaction for one horizontal string !!!! log2(Smem_len);  	 
	
	
	constant Hmem_len : integer:=2**Hmem_val; --value of tranzaction for one horizontal string	  
	constant Smem_len : integer:=240; --2**Smem_val;	--value of memory tranzaction   
	constant err_count_max : integer:=Smem_len+256; --timeout for sdr controller
	constant adrBuff_status : integer:=0;
	constant adrBuff_start : integer:=1;
	constant status_signature : std_logic_vector(15 downto 0):=x"428F";	 -- two last bytes of macs eth packets!!!
	
	type state_type is (clstart,clstep,clcheck,rxdone,idle,rxcheck,rxstep1,rxstep2,rxstep3,txcheck,txstep1,txstep2,txdone,error);
	signal state : state_type:=clstart;
	signal count_adrrxbuf,count_adrtxbuf : integer range 0 to 2**11-1 :=0;
	signal seltxbuf: std_logic_vector(2 downto 0);
	signal count_adrmem,REQ0adrmem,REQ1adrmem : integer range 0 to 2**(mem_val-1-Smem_val)-1 :=0;
	--	signal Vcount : integer range 0 to 2047 :=0;
	signal numBufftx,numBuffrx : std_logic:='1';
	signal adrBuffmemHi,adrBufftxHi,adrBuffrxHi,numBuffmem_wr,numBuffmem_rd : std_logic:='0';
	signal txstatus_start,rxstatus_start,txstatus_tmpstart,rxstatus_tmpstart,txstatus_signature,rxstatus_signature,rxstatus_sequence,rxstatus_err: boolean;
	signal err_rxsignature,err_rxsequence,err_wrd_ack,err_read : std_logic:='0';
	signal store_rxcount : integer range 0 to 2**(Hmem_val+Smem_val) :=0;
	signal wd_clear,wd_inc: boolean;
	
	signal indexDDR : std_logic_vector(9 downto 0);	 --	number of video packet
	signal adrDDR : std_logic_vector(11 downto 0);	 --	start address of line in ddr memory
	
begin
	err(0)<=err_rxsignature; 
	err(1)<=err_rxsequence; 
	err(2)<=err_wrd_ack;
	err(3)<=err_read; 
	
	O_sdrc_selfrefresh<='0';
	O_sdrc_power_down<='0';	
	O_sdrc_data_len<=conv_std_logic_vector(Smem_len-1,8);
	O_sdrc_dqm<=(others=>'0');
	O_sdrc_addr(mem_val-1)<=adrBuffmemHi;
	O_sdrc_addr(mem_val-2 downto Smem_val)<=conv_std_logic_vector(count_adrmem,mem_val-1-Smem_val);
	O_sdrc_addr(Smem_val-1 downto 0)<=conv_std_logic_vector(0,Smem_val);
	
	rx_a(11)<=adrBuffrxHi;	
	rx_a(10 downto 0)<=conv_std_logic_vector(count_adrrxbuf,11);	
	rx_wr<='0';
	rx_d<=(others=>'0');
	
	tx_a(9)<=adrBufftxHi;	
	tx_sel<=seltxbuf;	
	tx_a(8 downto 0)<=conv_std_logic_vector(count_adrtxbuf,9);	
	
	main_proc: process (reset,clock)
		variable t_count : integer range 0 to Hmem_len :=0;
		variable count : integer range 0 to Smem_len:=0;
		variable err_count : integer range 0 to err_count_max-1 :=0;
	begin
		if reset='1' then 	
			O_sdrc_rst_n<='0';
			O_sdrc_wr_n<='1';
			O_sdrc_rd_n<='1';
			adrBuffmemHi<='0';
			count_adrmem<=0;
			err_rxsignature<='0';
			err_rxsequence<='0';
			err_wrd_ack<='0';
			err_read<='0';
			adrBuffrxHi<='0';
			adrBufftxHi<='0';
			numBufftx<='1';	
			numBuffrx<='1';	
			numBuffmem_wr<='0';	
			numBuffmem_rd<='0';	
			count_adrrxbuf<=0;
			REQ0adrmem<=0;
			REQ1adrmem<=0;
			seltxbuf<="001";
			tx_d<=(others=>'0');
			tx_wr<='0';
			txstatus_start<=false;
			txstatus_tmpstart<=false;
			rxstatus_start<=false;
			rxstatus_tmpstart<=false;
			rxstatus_sequence<=false;
			rxstatus_err<=false;
			wd_inc<=false;
			wd_clear<=false;
			state<=clstart;
			store_rxcount<=0;
			count:=0;
		elsif rising_edge(clock) then 	
			txstatus_start<=txstatus_tmpstart and tx_q(2)/=numBufftx;
			rxstatus_start<=rxstatus_tmpstart and rx_q(2)/=numBuffrx;
			txstatus_tmpstart<=tx_q(2)/=numBufftx and state=idle;
			rxstatus_tmpstart<=rx_q(2)/=numBuffrx and state=idle;
			txstatus_signature<=tx_q(31 downto 16)=status_signature;
			rxstatus_signature<=rx_q(31 downto 16)=status_signature;
			rxstatus_sequence<=store_rxcount=conv_integer(rx_q(13 downto 4));
			rxstatus_err<=rx_q(3)='1';
			case state is
				when clstart => 
					O_sdrc_rst_n<='1';
					O_sdrc_wr_n<='1';
					O_sdrc_rd_n<='1';
					tx_d<=(others=>'0');
					tx_wr<='0';
					O_sdrc_data<=x"80808080";
--					O_sdrc_data<=x"5a5a5a5a";
					count:=Smem_len-1; 
					if I_sdrc_init_done='1' and I_sdrc_busy_n='1' then
						O_sdrc_wr_n<='0';
						state<=clstep;	
					end if;	
				
				when clstep => 
					O_sdrc_wr_n<='1';
					if count=Smem_len-4 and I_sdrc_wrd_ack='0' then 
						err_wrd_ack<='1';
						state<=error; 
					elsif count=0 then	
						count_adrmem<=count_adrmem+1;
						state<=clcheck; 
					end if;	
					if count/=0 then
						count:=count-1;
					end if;
				
				when clcheck =>   
					if count_adrmem=0 and adrBuffmemHi='1'then  -- end of clear the sdram
						state<=rxdone;
					else
						state<=clstart;
					end if;	
					if count_adrmem=0 then 
						adrBuffmemHi<='1';
					end if;	
				
				when idle =>  
					err_rxsignature<='0';
					err_wrd_ack<='0';
					err_read<='0';
					O_sdrc_rst_n<='1';
					O_sdrc_wr_n<='1';
					O_sdrc_rd_n<='1';
					seltxbuf<="001";
					adrBufftxHi<='0';
					count_adrtxbuf<=adrBuff_status;
					tx_d<=(others=>'0');
					tx_wr<='0';
					adrBuffrxHi<='0';
					count_adrrxbuf<=adrBuff_status;	 
					t_count:=Hmem_len; 
					count:=1;
					if txstatus_start then 
						indexDDR<=tx_q(13 downto 4);
						state<=txcheck;   
					elsif rxstatus_start then
						indexDDR<=rx_q(13 downto 4);
						state<=rxcheck; 
					end if;	 
				
				when rxcheck =>  
					if count=0 then
						numBuffrx<=rx_q(2);
						adrBuffmemHi<=numBuffmem_wr; 
						count_adrmem<=conv_integer(adrDDR);
						count_adrrxbuf<=adrBuff_start;	
						if not rxstatus_signature then --error signature ?
							err_rxsignature<='1';
							state<=rxdone;
						elsif rx_q(0)='1' then -- start frame
							err_rxsequence<='0';
							adrBuffrxHi<=rx_q(2);
							store_rxcount<=conv_integer(rx_q(13 downto 4))+1; 
							state<=rxstep1; 
						elsif not rxstatus_sequence or err_rxsequence='1' or rxstatus_err  then-- error sequence
							store_rxcount<=0;
							err_rxsequence<='1';
							state<=rxdone;
						else --if rxstatus_sequence then  -- all ok
							if rx_q(1)='1' then	 -- last frame	
								numBuffmem_wr<=not numBuffmem_wr;
								wd_clear<=true;
							end if;	
							adrBuffrxHi<=rx_q(2);
							store_rxcount<=conv_integer(rx_q(13 downto 4))+1; 
							state<=rxstep1; 
						end if;
					else
						count:=count-1;
					end if;
				
				when rxstep1 =>   
					wd_clear<=false;
					O_sdrc_data<=rx_q;
					if t_count=2 then  -- end of write the frame
						state<=rxdone;
					else
						state<=rxstep2;
					end if;	
					count_adrrxbuf<=count_adrrxbuf+1;
					count:=0;
				
				when rxstep2 => 
					O_sdrc_data<=rx_q;
					count:=Smem_len-1; 
					if I_sdrc_busy_n='1' then
						t_count:=t_count-1; 
						O_sdrc_wr_n<='0';
						count_adrrxbuf<=count_adrrxbuf+1;
						state<=rxstep3;	
					else
						count_adrrxbuf<=count_adrrxbuf-1;
						state<=rxstep1;	
					end if;	
				
				when rxstep3 => 
					O_sdrc_wr_n<='1';
					O_sdrc_data<=rx_q;
					if count=Smem_len-4 and I_sdrc_wrd_ack='0' then 
						err_wrd_ack<='1';
						state<=error; 
					elsif count=0 then
						count_adrmem<=count_adrmem+1;
						state<=rxstep1; 
					end if;	
					if count>1 then
						count_adrrxbuf<=count_adrrxbuf+1;
					end if;	
					if count/=0 then
						count:=count-1;
					end if;	
				
				when rxdone =>   
					O_sdrc_rst_n<='1';
					O_sdrc_wr_n<='1';
					O_sdrc_rd_n<='1';
					adrBuffrxHi<='0';
					count_adrrxbuf<=adrBuff_status;	 
					if I_sdrc_init_done='1' and I_sdrc_busy_n='1' then
						state<=idle;
						count:=2;
					end if;	
					
				
				when txcheck => 
					seltxbuf<="001";
					if count=0 then
						adrBufftxHi<=tx_q(2);
						count_adrmem<=conv_integer(adrDDR);
						numBufftx<=tx_q(2);
						count_adrtxbuf<=adrBuff_start-1;	
						if tx_q(2)='0' then
							REQ0adrmem<=conv_integer(tx_q(13 downto 4));
						else
							REQ1adrmem<=conv_integer(tx_q(13 downto 4));
						end if;
						if tx_q(0)='1' and numBuffmem_wr=numBuffmem_rd then	 
							numBuffmem_rd<=not numBuffmem_rd;
						end if;	
						wd_inc<=tx_q(0)='1';
						state<=txstep1;
					else
						count:=count-1;
					end if;	
				
				when txstep1 =>  
					adrBuffmemHi<=numBuffmem_rd; 
					wd_inc<=false;
					if t_count=1 then
						count:=Smem_len-2; 
					else
						count:=Smem_len-1; 
					end if;	 
					err_count:=err_count_max-1;
					tx_wr<='0';
					if I_sdrc_busy_n='1' then  
						if t_count=Hmem_len then
							seltxbuf<="001";
							count_adrtxbuf<=adrBuff_start;
						elsif t_count=Hmem_len-2 then
							seltxbuf<="010";
							count_adrtxbuf<=adrBuff_start;
						elsif t_count=Hmem_len-4 then
							seltxbuf<="100";
							count_adrtxbuf<=adrBuff_start;
						end if;
						t_count:=t_count-1;
						O_sdrc_rd_n<='0'; 
						state<=txstep2;
					end if;	 
				
				when txstep2 =>
					if I_sdrc_rd_valid='1' then
						count_adrtxbuf<=count_adrtxbuf+1;
					end if;
					O_sdrc_rd_n<='1'; 
					tx_d<=I_sdrc_data;
					tx_wr<=I_sdrc_rd_valid;
					if err_count=0 or (err_count=err_count_max-4 and I_sdrc_wrd_ack='0') then   
						err_read<='1';
						state<=error; 
					elsif count=0 then
						count_adrmem<=count_adrmem+1;
						if t_count=2 then
							state<=txdone; 
						else
							state<=txstep1;
						end if;
					end if;	
					if I_sdrc_rd_valid='1' and count/=0 then
						count:=count-1;
					end if;	
					if err_count/=0 then
						err_count:=err_count-1;
					end if;		
				
				when txdone =>   
					err_rxsignature<='0';
					err_wrd_ack<='0';
					err_read<='0';
					O_sdrc_rst_n<='1';
					O_sdrc_wr_n<='1';
					O_sdrc_rd_n<='1';
					seltxbuf<="001";
					count_adrtxbuf<=adrBuff_status;
					tx_d(31 downto 16)<=conv_std_logic_vector(REQ1adrmem,16);
					tx_d(15 downto 0)<=conv_std_logic_vector(REQ0adrmem,16);
					if count=1 then
						adrBufftxHi<='1';
						tx_wr<='1';	
					else
						adrBufftxHi<='0';
						tx_wr<='0';
					end if;
					if count/=2 then
						count:=count+1;
					elsif I_sdrc_init_done='1' and I_sdrc_busy_n='1' then
						state<=idle;
					end if;	
				
				when others =>	--err_cycle
					seltxbuf<="001";
					wd_inc<=false;
					wd_clear<=false;
					err_read<='0';
					tx_wr<='0';
					err_wrd_ack<='0';
					err_rxsequence<='0';
					O_sdrc_rst_n<='0';
					O_sdrc_rd_n<='1'; 
					O_sdrc_wr_n<='1';
					state<=clcheck;
					count:=2;
				
			end case;
		end if;
	end process main_proc; 	  
	
	indexDDR_table_1 : entity work.indexDDR_table 
	port map( reset=>'0',
		clk=>clock, ce=>'1', oce=>'1',
		ad=>indexDDR, dout=>adrDDR);  
	
	
	wd_proc: process (reset,clock)
		variable wd_count :integer range 0 to wd_timeout*60-1:=0;
	begin
		if reset='1' then 	
			wd_count:=0;
		elsif rising_edge(clock) then 
			no_signal<=boolean_to_data(wd_count=0);
			if wd_clear then 
				wd_count:=wd_timeout*60-1;
			elsif wd_inc and wd_count/=0 then
				wd_count:=wd_count-1;
			end if;
		end if;
	end process wd_proc; 	
	
end main;