library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;   
use work.lcd_lib.all;
package vimon10_lib is  
	attribute chip_pin : string;
	--------------------------------------------------	
	----------        Versions data         ----------	
	constant hw_version:	integer :=9;
	constant fw_version:	integer :=3;
	constant fw_revision:	integer :=1;
	constant fw_test:		integer :=1;  
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
	
	
	-- errors cnt
	constant len_err : integer :=9;
--	constant len_lockerr : integer :=5;
	constant max_cnt_err : integer :=255;
	subtype type_pulse_err is std_logic_vector(len_err-1 downto 0); 
	type type_cnt_err_array is array (len_err-1 downto 0) of integer range 0 to max_cnt_err; 
	
end vimon10_lib;	



