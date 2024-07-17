-------------------------------------------------------------------------------
-- Title       : stat_module
-- Design      : collect all statistic in txt format to memory
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.vimon10_lib.all;								    
use work.common_lib.all;
use work.bme280_lib.all;
--use work.voice_lib.all;
use work.visca_lib.all;

entity stat_module is
	generic( H_MAPTXT : integer:=256; V_MAPTXT : integer:=64 );
	port( reset,clock: in std_logic; 
		dbg: in std_logic_vector(3 downto 0); 	
		
		bme280: in type_outBME280; 
		eth_link: in std_logic_vector(1 downto 0); 
		mvk3: in type_mvk3; 
		LCD_backlight: in integer; 
		
		--STAT memory
		MAPTXT_a: out STD_LOGIC_VECTOR(13 downto 0);		
		MAPTXT_d: out STD_LOGIC_VECTOR(7 downto 0);		
		MAPTXT_wr: out STD_LOGIC	 );
	
end stat_module;

architecture main of stat_module is	
	signal eth_link_sync: std_logic_vector(1 downto 0); 
	signal detect_video_sync,voice_act: std_logic; 
	signal LCD_backlight_level: type_level; 
	signal LCD_backlight_sync: integer; 
	signal level: integer range 0 to 128; 
	signal mvk3_data : type_mvk3_data;
	signal mvk3_ena: std_logic; 
	
	type state_type is (st_ready,st_hex_read,st_boolean_read,st_level_read);
	signal state : state_type:=st_ready;	
	signal conv_start: boolean;
	signal hex_data: std_logic_vector(31 downto 0);		
	signal numb_val,dot_val: integer range 0 to 15;	
	signal code: std_logic_vector(7 downto 0);		
	signal code_oe: boolean;
	signal conv_ready: boolean; 
	signal sign: boolean; 
	
	constant max_st_count: integer:=22;
	signal st_count: integer range 0 to max_st_count-1;	
	signal char_count: integer range 0 to 15;	
	
	subtype type_H is integer range 0 to H_MAPTXT-1;	
	subtype type_V is integer range 0 to V_MAPTXT-1;	
	type type_HV is record
		v : type_V;
		h : type_H;
	end record;
	type type_array_HV is array (0 to max_st_count-1) of type_HV;
	constant conf_TXT: type_array_HV:=(
	(19,25),	--00 P(XXXX.XX)
	(20,25),	--01 T(�XXX.XX)
	(21,26),	--02 H(XXX.XXX)
	(23,48), 	--03 hw_version(XXX)
	(23,52),	--04 fw_version(XXX)
	(23,56),	--05 fw_revision(XXX)
	(23,60), 	--06 fw_test(XXX)
	(19,18), 	--07 mvk3.HEAD (�XXX)����\���
	(20,18), 	--08 mvk3.FRONT_HEAD (�XXX)����\���
	(19,59), 	--09 mvk3.link (�XXX)����\���
	(20,55), 	--10 mvk3.voice.level(XXXX�XXX)
	(21,55), 	--11 mvk3.tmp100.val(�XXX)
	(22,13), 	--12 LCD_backlight(XXXX�XXX)
	(22,01), 	--13 mvk3.visca.zoom(XXXX�XXX)
	(21,15), 	--14 LCD_backlight(XXX)
	(21,03),	--15 mvk3.visca.zoom(XXX)
	(20,37),	--16 mvk3.voice.level(XXX)
	(23,29), 	--17 mvk3.hw_version(XXX)
	(23,33),	--18 mvk3.fw_version(XXX)
	(23,37),	--19 mvk3.fw_revision(XXX)
	(23,41), 	--20 mvk3.fw_test(XXX)
	(20,47)		--21 mvk3.voice.act(XXX)
	);
	subtype type_char is STD_LOGIC_VECTOR(7 downto 0);		
	type type_array4_char is array (0 to 3) of type_char;
	constant line_on  : type_array4_char:= (x"00",x"82",x"aa",x"ab");
	constant line_off : type_array4_char:= (x"82",x"bb",x"aa",x"ab");
begin
	eth_link_sync<=eth_link;  
	
	sync_LCD_backlight_process: process (clock)
		variable LCD_backlight_false_path_sync: integer; 
	begin
		if rising_edge(clock) then
			LCD_backlight_sync<=LCD_backlight_false_path_sync;
			LCD_backlight_false_path_sync:=LCD_backlight;
		end if;
	end process sync_LCD_backlight_process; 
	---------------------------------------------------------	
	sync_mvk3 : entity work.Sync 
	generic map( regime => "spuls", inDelay => 0, outDelay => 0 )
	port map(reset => '0',
		clk_in => mvk3.clock, data_in => mvk3.ena,
		clk_out => clock, data_out => mvk3_ena);	 
	
	mvk3_sync_proc: process (reset,clock)
		variable mvk3_data_false_path_sync : type_mvk3_data;
	begin
		if reset='1'then
			mvk3_data<=clear_mvk3_data;
			mvk3_data_false_path_sync:=clear_mvk3_data;
		elsif rising_edge(clock) then
			mvk3_data<=mvk3_data_false_path_sync;
			if mvk3_ena='1' then
				mvk3_data_false_path_sync:=mvk3.data;
			end if;
		end if;
	end process mvk3_sync_proc;	
	
	--------------------------------------------	
	main_proc: process (reset,clock)
	begin
		if reset='1' then 
			MAPTXT_a<=(others=>'0');
			MAPTXT_d<=(others=>'0');
			MAPTXT_wr<='0';
			conv_start<=false;
			hex_data<=(others=>'0');
			char_count<=0;
			dot_val<=0;
			sign<=false; 
			numb_val<=0; 
			state<=st_ready;	  
		elsif rising_edge(clock)  then 	
			MAPTXT_a(13 downto 8)<=conv_std_logic_vector(conf_TXT(st_count).v,6);
			MAPTXT_a(7 downto 0)<=conv_std_logic_vector(conf_TXT(st_count).h+char_count,8);
			case state is
				when st_ready=>
					char_count<=0;
					MAPTXT_wr<='0';
					case st_count is
						when 0=>
							if dbg(3)='0' then
								conv_start<=bme280.act;
								state<=st_hex_read;
							else
								st_count<=7;
							end if;
							hex_data<=bme280.P;
							dot_val<=2;
							sign<=false; 
							numb_val<=6; 
						
						when 1=> 
							conv_start<=true;
							hex_data<=bme280.T;
							dot_val<=2;
							sign<=true; 
							numb_val<=5; 
							state<=st_hex_read;	
						
						when 2=> 
							conv_start<=true;
							hex_data<=bme280.H;
							dot_val<=2;
							sign<=false; 
							numb_val<=5; 
							state<=st_hex_read;	
						
						when 3=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(hw_version,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	
						
						when 4=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(fw_version,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	  
						
						when 5=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(fw_revision,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	  
						
						when 6=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(fw_test,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;
						
						when 7=> 
							sign<=mvk3_data.HEAD='1'; 
							state<=st_boolean_read;	  
						
						when 8=> 
							sign<=mvk3_data.FRONT_HEAD='1'; 
							state<=st_boolean_read;	  
						
						when 9=> 
							sign<=mvk3_data.link='1'; 
							state<=st_boolean_read;	  
						
						when 10=> 
							level<=mvk3_data.voice_level;
							sign<=false; 
							numb_val<=6; 
							dot_val<=15;
							state<=st_level_read;
						
						when 11=> 
							conv_start<=true;
							hex_data<=SXT(mvk3_data.tmp100.val,32);
							dot_val<=0;
							sign<=true; 
							numb_val<=4; 
							state<=st_hex_read;	 
						
						when 12=> 
							level<=LCD_backlight_sync;
							sign<=false; 
							numb_val<=6; 
							dot_val<=15;
							state<=st_level_read;
						
						when 13=> 
							level<=conv_integer(mvk3_data.zoom_level);
							sign<=false; 
							numb_val<=6; 
							dot_val<=15;
							state<=st_level_read;
						
						when 14=> 
							if dbg(3)='0' then
								conv_start<=true;
								state<=st_hex_read;
							else
								st_count<=7;
							end if;
							hex_data<=conv_std_logic_vector(LCD_backlight_sync,32);
							dot_val<=15;
							sign<=false; 
							numb_val<=3; 
						
						when 15=> 
							conv_start<=true;
							state<=st_hex_read;
							hex_data<=conv_std_logic_vector(mvk3_data.zoom_level,32);
							dot_val<=15;
							sign<=false; 
							numb_val<=3; 
						
						when 16=> 
							conv_start<=true;
							state<=st_hex_read;
							hex_data<=conv_std_logic_vector(mvk3_data.voice_level,32);
							dot_val<=15;
							sign<=false; 
							numb_val<=3; 
						
						when 17=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(mvk3_data.hw_version,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	
						
						when 18=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(mvk3_data.fw_version,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	  
						
						when 19=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(mvk3_data.fw_revision,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;	  
						
						when 20=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(mvk3_data.fw_test,32);
							sign<=false; 
							numb_val<=3; 
							dot_val<=15;
							state<=st_hex_read;
						
						when 21=> 
							sign<=data_to_boolean(mvk3_data.voice_act); 
							state<=st_boolean_read;	  
						
					end case;  
				
				when st_hex_read=>
					MAPTXT_d<=code;
					MAPTXT_wr<=boolean_to_data(code_oe);
					if not conv_ready then
						conv_start<=false;
					end if;	
					if code_oe then
						char_count<=char_count+1;
					end if;	
					if conv_ready and not conv_start then 
						st_count<=st_count+1;
						state<=st_ready;	  
					end if;	
				
				when st_boolean_read=>
					if sign then 
						MAPTXT_d<=line_on(char_count);
					else
						MAPTXT_d<=line_off(char_count);
					end if;
					MAPTXT_wr<='1';
					if char_count=3 then
						st_count<=st_count+1;
						state<=st_ready;	  
					else	
						char_count<=char_count+1;
					end if;	  
				
				when st_level_read=>
					if sign then
						MAPTXT_d<=x"d0"; -- clear bar
					elsif level>15 then
						MAPTXT_d<=x"e0";  -- full bar  
						level<=level-16;  
					else 
						sign<=true; 
						MAPTXT_d<=x"d" & conv_std_logic_vector(level,4); -- variable bar
					end if;
					MAPTXT_wr<='1';
					if char_count=7 then
						st_count<=st_count+1;
						state<=st_ready;	  
					else	
						char_count<=char_count+1;
					end if;	
				
			end case;
		end if;
	end process main_proc; 	 
	
	conv_to_chars : entity work.hex_to_dec 
	port map( reset=>reset, clock=>clock,
		start=>conv_start,
		hex_data=>hex_data,
		sign=>sign,
		numb_val=>numb_val,
		dot_val=>dot_val,
		code=>code,
		code_oe=>code_oe,
		ready=>conv_ready );
end main; 
