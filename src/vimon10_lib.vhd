library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
use work.lcd_lib.all;
use work.visca_lib.all;
use work.voice_lib.all;
use work.tmp100_lib.all; 

package vimon10_lib is  
	attribute chip_pin : string;
	--------------------------------------------------	
	----------        Versions data         ----------	
	constant hw_version:	integer :=9;
	constant fw_version:	integer :=3;
	constant fw_revision:	integer :=1;
	constant fw_test:		integer :=10;  
	--------------------------------------------------	
	
	constant V_marker : integer :=01; 
	constant H_marker : integer :=02; 
	constant D_marker : integer :=03; 
	constant ddr_burst_value:	integer :=16;  
	subtype type_Vvalue is integer range 0 to 8191;
	subtype type_Hvalue is integer range 0 to 8191;
	subtype type_Vfreq is integer range 0 to 255;	
	
	type type_crop is record
		hstart : type_Hvalue;
		vstart : type_Vvalue;
		hsize : type_Hvalue;
		vsize : type_Vvalue;
	end record;
	constant clear_crop : type_crop := (0,0,0,0);	
	type type_video_mode is record
		crop : type_crop;
		freq : type_Vfreq;
		scaling : boolean;
	end record;
	constant clear_video_mode : type_video_mode := (clear_crop,0,false);	 
	
	subtype type_level is integer range 0 to 127;	
	subtype type_version is integer range 0 to 255;	
	type type_mvk3_data is record
		hw_version: type_version;
		fw_version: type_version;
		fw_revision: type_version;
		fw_test: type_version;  
		DB: std_logic_vector(4 downto 0);
		link: std_logic;
		CAM_PWR: std_logic;
		FRONT_HEAD: std_logic;
		HEAD: std_logic;
		COLD: std_logic;
		voice_act: std_logic;
		voice_level: type_level;
		zoom_level: type_level;
		tmp100: type_tmp100;
	end record;
	constant clear_mvk3_data : type_mvk3_data := (0,0,0,0,"11111",'0','0','0','0','0','0',0,0,clear_tmp100);	
	type type_mvk3 is record
		ena : std_logic;
		clock : std_logic;
		data: type_mvk3_data;
	end record;
	constant clear_camera_parameters : type_mvk3 := ('0','0',clear_mvk3_data);	
	
	-- errors cnt
	constant len_err : integer :=9;
	constant max_cnt_err : integer :=255;
	subtype type_pulse_err is std_logic_vector(len_err-1 downto 0); 
	type type_cnt_err_array is array (len_err-1 downto 0) of integer range 0 to max_cnt_err; 	
	
	
	
end vimon10_lib;	



