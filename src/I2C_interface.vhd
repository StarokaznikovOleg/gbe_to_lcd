-------------------------------------------------------------------------------
-- Title       : i2c_interface
-- Design      : common
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package i2c_lib is  
	constant start : std_logic:='0';
	constant stop : std_logic:='1';
	constant OPcode_write : std_logic:='0';
	constant OPcode_read : std_logic:='1';
	constant OPcode_ack : std_logic:='0';
	constant OPcode_nack : std_logic:='0';
	subtype type_dev_i2c is integer range 0 to 127;
	subtype type_reg_i2c is std_logic_vector(7 downto 0);
	subtype type_mem_i2c is std_logic_vector(8 downto 0);
	subtype type_data_i2c is std_logic_vector(7 downto 0);
	
	constant value_start_i2c: integer :=9;
	constant value_pause_i2c: integer :=16;
	constant value_shift_i2c: integer :=9;
	constant code_i2c_read: type_data_i2c :=x"F0";
	constant code_i2c_start: type_data_i2c :=x"F1";
	constant code_i2c_stop: type_data_i2c :=x"F2";
	constant code_i2c_pause: type_data_i2c :=x"F3";
	constant code_i2c_goto: type_data_i2c :=x"F4";
	
	subtype type_shift_i2c is std_logic_vector(value_shift_i2c-1 downto 0);
	type i2c_op_type is (start_op,write_op,read_op,stop_op,error_op);
	
	function i2c_write(data:type_data_i2c) return type_shift_i2c;
	function i2c_read(shiftreg:type_shift_i2c ) return type_data_i2c;
end i2c_lib;	

package body i2c_lib is   
	function i2c_write(data:type_data_i2c) return type_shift_i2c is
		variable q : type_shift_i2c;
	begin 
		q(08 downto 01):=data;   
		q(0):=OPcode_ack;   
		return q; 
	end i2c_write;
	function i2c_read(shiftreg:type_shift_i2c ) return type_data_i2c is
		variable q : type_data_i2c;
	begin 
		q:=shiftreg(07 downto 00);   
		return q; 
	end i2c_read; 
end i2c_lib;	

library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.i2c_lib.all;

entity i2c_interface is
	generic( ref_freq : integer:=125000000; scl_freq : integer:=5000000);
	port(
		reset,clock: in std_logic; 
		scl,sda: inout std_logic;
		
		i2c_ena: out boolean;
		i2c_valid: out boolean;
		i2c_adr: out type_mem_i2c;
		i2c_mem: in type_mem_i2c;
		i2c_q: out type_data_i2c
		);
end i2c_interface;

architecture main of i2c_interface is	
	constant div_clk: integer :=ref_freq/scl_freq/4;
	signal ena: boolean:= false; 
	signal i2c_adr_count: type_mem_i2c;
begin					   
	--------------------------------------------	
	i2c_ena<=ena; 
	i2c_adr<=i2c_adr_count;
	i2c_proc: process (reset,clock,ena)
		type i2c_state_type is (start,wait_i2c,
		state_i2c_start,
		state_i2c_stop,
		state_i2c_pause,
		state_i2c_goto,
		state_i2c_write_1,state_i2c_write_2,state_i2c_write_3,
		state_i2c_read_1,state_i2c_read_2,state_i2c_read_3,
		error_state);
		variable i2c_state : i2c_state_type:=start;	
		variable shift_wrreg,shift_rdreg: type_shift_i2c;  	   
--		variable i2c_shift_q: type_data_i2c;
		variable count: integer range 0 to 255; 
	begin
		if reset='1' then 	
			scl<='Z';
			sda<='Z';
			i2c_valid<=false;
			count:=0;
			shift_wrreg:=(others=>'0');
			shift_rdreg:=(others=>'0');
			i2c_state:=start; 
		elsif rising_edge(clock) and ena then  
			
			case i2c_state is
				when start => 
					scl<='1';
					sda<='1';
					i2c_valid<=false;
					i2c_adr_count<=(others=>'0');
					i2c_state:=wait_i2c; 
				
				when wait_i2c =>  
					i2c_valid<=false;
					i2c_adr_count<=i2c_adr_count+1;
					if i2c_mem(8)='1' then
						case i2c_mem(7 downto 0) is	
							when code_i2c_start => 
								count:=value_start_i2c;
								i2c_state:=state_i2c_start; 
							
							when code_i2c_stop => 
								count:=value_start_i2c;
								i2c_state:=state_i2c_stop; 	
							
							when code_i2c_read => 
								count:=value_shift_i2c;
								i2c_state:=state_i2c_read_1; 	
							
							when code_i2c_goto => 
								count:=value_start_i2c;
								i2c_state:=state_i2c_goto; 	
							
							when others => 
								count:=value_pause_i2c;
								i2c_state:=state_i2c_pause; 
							
						end case;
					else  
						count:=value_shift_i2c;	
						shift_wrreg:=i2c_write(i2c_mem(7 downto 0));
						i2c_state:=state_i2c_write_1; 	
					end if;
				
				when state_i2c_start => 
					case count is	
						when 3 => sda<='0';
						when 2 => scl<='0';
						when others => null;
					end case;
					if count=0 then
						i2c_state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_i2c_stop => 
					case count is	
						when 3 => scl<='1';
						when 2 => sda<='1';
						when others => null;
					end case;
					if count=0 then
						i2c_state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_i2c_pause => 
					if count=0 then
						i2c_state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_i2c_goto => 
					if count=0 then
						i2c_adr_count<=i2c_mem;
						i2c_state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_i2c_write_1 => 
					if count=1 then
						sda<='Z';
					else 
						sda<=shift_wrreg(value_shift_i2c-1); 
					end if;
					shift_wrreg:=shift_wrreg(value_shift_i2c-2 downto 0) & '0';
					count:=count-1;
					i2c_state:=state_i2c_write_2;
				
				when state_i2c_write_2 => 
					scl<='1';
					i2c_state:=state_i2c_write_3;
				
				when state_i2c_write_3 => 
					scl<='0';
					if count=0 then	
						sda<='0';
						i2c_state:=wait_i2c; 
					else
						i2c_state:=state_i2c_write_1;
					end if;
				
				when state_i2c_read_1 => 
					sda<='Z';
					count:=count-1;
					i2c_state:=state_i2c_read_2;
				
				when state_i2c_read_2 => 
					scl<='1';
					i2c_state:=state_i2c_read_3;
				
				when state_i2c_read_3 => 
					scl<='0';
					if count=0 then	
						sda<='0';
						i2c_q<=i2c_read(shift_rdreg);
						i2c_valid<=true;
						i2c_state:=wait_i2c; 
					else
						shift_rdreg:=shift_rdreg(value_shift_i2c-2 downto 0) & sda;
						i2c_state:=state_i2c_read_1;
					end if;
				
				when others => 
					i2c_state:=start;
				
			end case;
		end if;
	end process i2c_proc; 
	
	ena_proc: process (clock) 
		variable count_en : integer range 0 to div_clk-1 :=0;
	begin
		if rising_edge(clock) then 	 
			ena<=count_en=0;
			if count_en=0 then 	 
				count_en:=div_clk-1;
			else
				count_en:=count_en-1;
			end if;
		end if;
	end process ena_proc; 	  
end main; 
