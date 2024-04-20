-------------------------------------------------------------------------------
-- Title       : cmd_module
-- Design      : reseiving rs232 data from camera and store to int memory
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.ETH_lib.all;

entity cmd_module is
	generic( ref_freq:integer:=125000000; hfilter:integer:=4 );	 
	port(
		reset,clock: in std_logic; 
		key: in std_logic_vector(3 downto 0); 
		LCD_backlight : out integer range 0 to 99;
		--memory
		mem_adr: out type_cmd_mem_adr;		
		mem_data: out type_cmd_mem_data;
		mem_status,mem_wr: out STD_LOGIC		
		
		);
end cmd_module;

architecture main of cmd_module is	
	constant eth_CMD_header_len: integer:=50;
	constant eth_CMD_header_iplenght: integer:=24;
	constant eth_CMD_header_ADRiplenght: integer:=24; -- address for the fild of ip lenght.
	constant eth_CMD_header_ADRipid: integer:=26; -- address for the fild of ip id.
	constant eth_CMD_header_ADRipchecksum: integer:=32; -- address for the fild of ip checksum.
	constant eth_CMD_header_ADRudplenght: integer:=46; -- address for the fild of ip udp lenght.
	constant eth_CMD_header_ADRudpchecksum: integer:=48; -- address for the fild of ip udp checksum.
	
	constant ip_checksum_start : std_logic_vector(15 downto 0):=x"b4fd"; 
	constant ip_lenght_start : std_logic_vector(15 downto 0):=conv_std_logic_vector(28,16); 
	constant udp_checksum_start : std_logic_vector(15 downto 0):=x"f696"; 
	constant udp_lenght_start : std_logic_vector(15 downto 0):=conv_std_logic_vector(8,16); 
	
	--	constant visca_zoom : integer:=6;
	--	type type_visca_cmd_zoom is array (visca_zoom-1 downto 0) of std_logic_vector(7 downto 0);
	--	constant visca_cmd_zoom_dec :type_visca_cmd_zoom := (x"81",x"01",x"04",x"07",x"03",x"ff"); 
	--	constant visca_cmd_zoom_inc :type_visca_cmd_zoom := (x"81",x"01",x"04",x"07",x"02",x"ff"); 
	--	constant visca_cmd_zoom_stop :type_visca_cmd_zoom := (x"81",x"01",x"04",x"07",x"00",x"ff"); 
	signal t_ena : boolean;
	signal ad_cmd : std_logic_vector(2 downto 0);
	signal cmd_zoom_inc,cmd_zoom_dec,cmd_zoom_stop : std_logic_vector(7 downto 0);
	
	signal buf_number : std_logic;
	constant ADRcount_max :integer := eth_cmd_header_len+512; 
	signal ADRcount : integer range 0 to ADRcount_max;
	signal key_sync,key_done : std_logic_vector(3 downto 0);
	
	type type_key_state is (key_off,key_wait_on,key_on,key_wait_off);
	type type_array_key_state is array (3 downto 2) of type_key_state;
	signal key_state : type_array_key_state;
	
begin
	sync1_key: for i in 0 to 1 generate
				sync_key_i : entity work.Sync 
				generic map( regime => "level", inDelay => 0, outDelay => 0 )
				port map(reset => '0',
					clk_in => clock, data_in => key(i),
					clk_out => clock, data_out => key_sync(i));   
	end generate;
	sync2_key: for i in 2 to 3 generate
		filter_key_i : entity work.filter 
		generic map( regime => "level", filter => 1023)
		port map( reset => '0',
			clk_in => clock, data_in => key(i),
			clk_out => clock, data_out => key_sync(i));   
		--------------------------------------------	
		rxdata_proc: process (reset,clock)   
			variable key_hf : std_logic;
			variable shift_data : std_logic_vector(hfilter-1 downto 0);
		begin
			if reset='1' then 
				key_state(i)<=key_off;
				key_hf:='0';
				shift_data:=(others=>'0');	
			elsif rising_edge(clock) then 
				if key_state(i)=key_wait_on and key_hf='1' then key_state(i)<=key_on;
				elsif key_state(i)=key_wait_off and key_hf='0' then key_state(i)<=key_off;
				elsif key_state(i)=key_on and key_done(i)='1' then key_state(i)<=key_wait_off;
				elsif key_state(i)=key_off and key_done(i)='1' then key_state(i)<=key_wait_on;
				end if;	
				if shift_data=sxt("1",hfilter) then 	--high pass filter
					key_hf:='1'; 
				elsif shift_data=ext("0",hfilter) then 
					key_hf:='0'; 
				end if;
				
				shift_data:=shift_data(hfilter-2 downto 0) & key_sync(i);	   
			end if;
		end process rxdata_proc; 	  
	end generate;
	
	visca_zoom_inc1 : entity work.visca_zoom_inc 
	port map(ad => ad_cmd, dout => cmd_zoom_inc);
	visca_zoom_dec1 : entity work.visca_zoom_dec 
	port map(ad => ad_cmd, dout => cmd_zoom_dec);
	visca_zoom_stop1 : entity work.visca_zoom_stop 
	port map(ad => ad_cmd, dout => cmd_zoom_stop);
	
	mem_status<=not buf_number;
	mem_adr(CMD_mem_adr_len-1)<=buf_number;
	mem_adr(CMD_mem_adr_len-2 downto 0)<=conv_std_logic_vector(ADRcount,CMD_mem_adr_len-1);
	
	--------------------------------------------	
	main_proc: process (reset,clock)   
		type cmd_type is (none,zoom_dec,zoom_inc,zoom_stop);
		variable cmd : cmd_type:=none;
		type state_type is (idle,cmd_start,cmd_send,
		iplenghtH,iplenghtL,ipidH,ipidL,ipchecksumH,ipchecksumL,
		udplenghtH,udplenghtL,udpchecksumH,udpchecksumL,
		pause);
		variable state : state_type;
		variable count : integer range 0 to 15;
		variable ip_checksum,ip_lenght,ip_id,udp_checksum,udp_lenght: std_logic_vector(15 downto 0);
		variable cmd_data : std_logic_vector(7 downto 0);
		variable udp_csh : boolean;
	begin
		ad_cmd<=conv_std_logic_vector(count,3);
		if reset='1' then 	
			mem_data<=(others=>'0');
			mem_wr<='0'; 
			buf_number<='0';
			ADRcount<=0;
			key_done(3 downto 2)<=(others=>'0');
			ip_checksum:=(others=>'0');
			ip_lenght:=(others=>'0');
			ip_id:=(others=>'0');
			udp_checksum:=(others=>'0');
			udp_lenght:=(others=>'0');
			udp_csh:=false;
			count:=0;
			state:=pause;  
		elsif rising_edge(clock) then 
			if cmd=zoom_inc then
				cmd_data:=cmd_zoom_inc;
			elsif cmd=zoom_dec then
				cmd_data:=cmd_zoom_dec; 
			elsif cmd=zoom_stop then
				cmd_data:=cmd_zoom_stop; 
			end if;	
			case state is
				when idle =>
					mem_data<=(others=>'0');
					mem_wr<='0'; 
					ADRcount<=eth_CMD_header_len-1; 
					ip_checksum:=ip_checksum_start - ip_id;
					ip_lenght:=ip_lenght_start;
					udp_checksum:=udp_checksum_start;
					udp_lenght:=udp_lenght_start;
					udp_csh:=false;
					if key_state(2)=key_on then
						cmd:=zoom_inc;
						key_done(2)<='1';
						count:=conv_integer(cmd_zoom_inc);
						state:=cmd_send;
					elsif key_state(3)=key_on then
						key_done(3)<='1';
						cmd:=zoom_dec;
						count:=conv_integer(cmd_zoom_dec);
						state:=cmd_send; 
					elsif key_state(2)=key_off  then
						key_done(2)<='1';
						cmd:=zoom_stop;
						count:=conv_integer(cmd_zoom_stop);
						state:=cmd_send; 
					elsif key_state(3)=key_off then
						key_done(3)<='1';
						cmd:=zoom_stop;
						count:=conv_integer(cmd_zoom_stop);
						state:=cmd_send; 
					end if;
				
				when cmd_start =>  
					key_done(3 downto 2)<=(others=>'0');
					state:=cmd_send; 
				
				when cmd_send =>  
					ADRcount<=ADRcount+1; 
					mem_wr<='1'; 
					if count=0 then 
						mem_data<='0' & x"00";
						state:=iplenghtH;
					else
						mem_data<='1' & cmd_data;
						ip_lenght:=ip_lenght+1;
						ip_checksum:=ip_checksum - 1;
						udp_lenght:=udp_lenght+1; 
						if udp_csh then
							udp_checksum:=udp_checksum - 1 - (cmd_data & x"00");	
						else
							udp_checksum:=udp_checksum - 1 - (x"00" & cmd_data);	
						end if;
						udp_csh:=not udp_csh;
						
					end if;	 
					if count/=0 then count:=count-1; end if;
				
				when iplenghtH => 
					ADRcount<=eth_cmd_header_ADRiplenght; 
					mem_data<='1' & ip_lenght(15 downto 8);
					state:=iplenghtL;
				
				when iplenghtL => 
					ADRcount<=ADRcount+1; 
					mem_data<='1' & ip_lenght(7 downto 0);
					state:=ipidH;	
				
				when ipidH => 
					ADRcount<=eth_cmd_header_ADRipid;
					mem_data<='1' & ip_id(15 downto 8);
					state:=ipidL;
				
				when ipidL => 
					ADRcount<=ADRcount+1; 
					mem_data<='1' & ip_id(7 downto 0);
					state:=ipchecksumH;
				
				when ipchecksumH => 
					ADRcount<=eth_cmd_header_ADRipchecksum;
					mem_data<='1' & ip_checksum(15 downto 8);
					state:=ipchecksumL;
				
				when ipchecksumL => 
					ADRcount<=ADRcount+1; 
					mem_data<='1' & ip_checksum(7 downto 0);
					state:=udplenghtH;
				
				when udplenghtH => 
					ADRcount<=eth_cmd_header_ADRudplenght; 
					mem_data<='1' & udp_lenght(15 downto 8);
					state:=udplenghtL;
				
				when udplenghtL => 
					ADRcount<=ADRcount+1; 
					mem_data<='1' & udp_lenght(7 downto 0);
					state:=udpchecksumH;	
				
				when udpchecksumH => 
					ADRcount<=eth_cmd_header_ADRudpchecksum;
					mem_data<='1' & udp_checksum(15 downto 8);
					state:=udpchecksumL;
				
				when udpchecksumL => 
					ADRcount<=ADRcount+1; 
					mem_data<='1' & udp_checksum(7 downto 0);
					state:=pause;
				
				when pause => 
					mem_data<=(others=>'0');
					mem_wr<='0'; 
					ADRcount<=eth_CMD_header_len-1; 
					ip_checksum:=ip_checksum_start;
					ip_lenght:=ip_lenght_start;
					ip_id:=ip_id+1;
					mem_wr<='0'; 
					buf_number<=not buf_number;
					count:=0;
					state:=idle;
				
				when others => null;
			end case;
		end if;
	end process main_proc; 
	
	backlight_proc: process (reset,clock)   
		variable count : integer range 0 to 99;
	begin
		LCD_backlight<=count;	
		if reset='1' then 	
			count:=50;
		elsif rising_edge(clock) and t_ena then 
			if key_sync(1 downto 0)="10" then
				if count/=99 then count:=count+1; end if;
			elsif key_sync(1 downto 0)="01" then
				if count/=1 then count:=count-1; end if;
			elsif key_sync(1 downto 0)="00" then
				 count:=50; 
			end if;
		end if;
	end process backlight_proc; 
	
	timer_proc: process (reset,clock)  
	constant max_count : integer :=ref_freq/10;
		variable count : integer range 0 to max_count;
	begin
		if reset='1' then 	
			count:=0;
			t_ena<=false;
		elsif rising_edge(clock) then 
			t_ena<=count=0;
			if count=max_count then
				count:=0;
			else 
				count:=count+1;
			end if;
		end if;
	end process timer_proc; 	  
	
	---------------------------------------------------------	
end main; 
