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
use work.voice_lib.all;
use work.visca_lib.all;

entity stat_module is
	generic( H_MAPTXT : integer:=256; V_MAPTXT : integer:=64 );
	port( reset,clock: in std_logic; 
		
		bme280: in type_outBME280; 
		eth_link: in std_logic_vector(1 downto 0); 
		detect_video: in std_logic; 
		voice: in type_voice_level; 
		visca: in type_visca_param; 
		LCD_backlight: in integer; 
		
		--STAT memory
		MAPTXT_a: out STD_LOGIC_VECTOR(13 downto 0);		
		MAPTXT_d: out STD_LOGIC_VECTOR(7 downto 0);		
		MAPTXT_wr: out STD_LOGIC	 );
	
end stat_module;

architecture main of stat_module is	
	signal eth_link_sync: std_logic_vector(1 downto 0); 
	signal detect_video_sync,sample_sync,voice_act: std_logic; 
	signal LCD_backlight_sync: integer; 
	signal voice_level: type_level; 
	signal voice_tmp: std_logic_vector(31 downto 0); 
	
	type state_type is (st_ready,st_hex_read,st_boolean_read,st_level_read);
	signal state : state_type:=st_ready;	
	signal conv_start: boolean;
	signal hex_data: std_logic_vector(31 downto 0);		
	signal numb_val,dot_val: integer range 0 to 15;	
	signal code: std_logic_vector(7 downto 0);		
	signal code_oe: boolean;
	signal conv_ready: boolean; 
	signal sign: boolean; 
	
	constant max_st_count: integer:=14;
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
	(20,54),	--00 P(XXXX.XX)
	(21,54),	--01 T(±XXX.XX)
	(22,55),	--02 H(XXX.XXX)
	(23,49), 	--03 hw_version(XXX)
	(23,53),	--04 fw_version(XXX)
	(23,57),	--05 fw_revision(XXX)
	(23,61), 	--06 fw_test(XXX)
	(19,24), 	--07 link0 (ÕXXX)åñòü\íåò
	(20,24), 	--08 video (ÕXXX)åñòü\íåò
	(21,24), 	--09 voice (ÕXXX)åñòü\íåò
	(23,16), 	--10 backlight (ÕXXX)
	(21,28), 	--11 level
	(22,30), 	--12 
	(23,4) 	--13 
	);
	subtype type_char is STD_LOGIC_VECTOR(7 downto 0);		
	type type_array4_char is array (0 to 3) of type_char;
	constant line_on : type_array4_char:= (x"82",x"aa",x"ab",x"00");
	constant line_off : type_array4_char:= (x"82",x"bb",x"aa",x"ab");
begin
	---------------------------------------------------------	
	--	i : for i in 0 to 1 generate	
	--		sync_link_status : entity work.Sync 
	--		generic map( regime => "level", inDelay => 0, outDelay => 0 )
	--		port map(reset => '0',
	--			clk_in => clock, data_in => eth_link(i),
	--			clk_out => clock, data_out => eth_link_sync(i));
	--	end generate i;
	eth_link_sync<=eth_link;  
	
	sync_detect_video : entity work.Sync 
	generic map( regime => "level", inDelay => 0, outDelay => 0 )
	port map(reset => '0',
		clk_in => clock, data_in => detect_video,
		clk_out => clock, data_out => detect_video_sync);	
	
	sync_sample : entity work.Sync 
	generic map( regime => "spuls", inDelay => 0, outDelay => 0 )
	port map(reset => '0',
		clk_in => voice.clock, data_in => voice.ena,
		clk_out => clock, data_out => sample_sync);	 
	
	voice_sync: process (reset,clock)
		variable voice_act_false_path_sync : std_logic;
		variable voice_level_false_path_sync : type_level;
		variable voice_tmp_false_path_sync : std_logic_vector(31 downto 0);
	begin
		if reset='1'then
			voice_act<='0';
			voice_level<=(others=>'0');
			voice_tmp<=(others=>'0');
			voice_act_false_path_sync:='0';
			voice_level_false_path_sync:=(others=>'0');
			voice_tmp_false_path_sync:=(others=>'0');
		elsif rising_edge(clock) then
			voice_act<=voice_act_false_path_sync;
			voice_level<=voice_level_false_path_sync;
			voice_tmp<=voice_tmp_false_path_sync;
			if sample_sync='1' then
				voice_act_false_path_sync:=voice.act;
				voice_level_false_path_sync:=voice.level;
				voice_tmp_false_path_sync:=voice.tmp;
			end if;
		end if;
	end process voice_sync;	
	
	sync_LCD_backlight_process: process (clock)
		variable LCD_backlight_false_path_sync: integer; 
	begin
		if rising_edge(clock) then
			LCD_backlight_sync<=LCD_backlight_false_path_sync;
			LCD_backlight_false_path_sync:=LCD_backlight;
		end if;
	end process sync_LCD_backlight_process; 
	
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
							if bme280.act then
								conv_start<=true;
								state<=st_hex_read;
							else
								st_count<=st_count+3;
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
							sign<=eth_link_sync(0)='1'; 
							state<=st_boolean_read;	  
						
						when 8=> 
							sign<=detect_video_sync='1'; 
							state<=st_boolean_read;	  
						
						when 9=> 
							sign<=voice_act='1'; 
							state<=st_boolean_read;	  
						
						when 10=> 
							conv_start<=true;
							hex_data<=conv_std_logic_vector(LCD_backlight_sync,32);
							sign<=false; 
							numb_val<=2; 
							dot_val<=15;
							state<=st_hex_read;	  
						
						when 11=> 
							hex_data<=voice_level;
							sign<=false; 
							numb_val<=6; 
							dot_val<=15;
							state<=st_level_read;
							
						when 12=> 
							conv_start<=true;
							hex_data<=ext(voice_tmp(31 downto 9),32);
							sign<=false; 
							numb_val<=6; 
							dot_val<=15;
							state<=st_hex_read;	
						
						when 13=> 
							conv_start<=true;
							hex_data<=ext(visca.zoom(15 downto 8),32);
							sign<=false; 
							numb_val<=2; 
							dot_val<=15;
							state<=st_hex_read;	
						
						
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
						MAPTXT_d<=x"f0";
					else
						MAPTXT_d<=x"e" & hex_data(31 downto 28);
					end if;
					if conv_integer(hex_data(31 downto 28))/=0 then 
						sign<=true; 
					end if;
					MAPTXT_wr<='1';
					if char_count=7 then
						st_count<=st_count+1;
						state<=st_ready;	  
					else	
						char_count<=char_count+1;
					end if;	
					hex_data(31 downto 4)<=hex_data(27 downto 0);
				
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
