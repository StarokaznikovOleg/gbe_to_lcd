-------------------------------------------------------------------------------
-- Title       : i2c_interface
-- Design      : common
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
use IEEE.std_logic_arith.all;
library work;
use work.i2c_lib.all; 

entity i2c_interface is
	generic( ref_freq : integer:=125000000; scl_freq : integer:=5000000);
	port(
		reset,clock: in std_logic; 
		scl,sda: inout std_logic;
		ena: out boolean;
		adr: out type_mem_a_i2c;
		data: in type_mem_d_i2c;
		i2c_valid: out boolean;
		i2c_q: out type_data_i2c
		);
end i2c_interface;

architecture main of i2c_interface is	
	constant value_start: integer :=8;
	constant value_pause: integer :=2047;
	constant value_goto: integer :=2;
	constant value_shift: integer :=9;
	constant code_read: integer :=0;
	constant code_start: integer :=1;
	constant code_stop: integer :=2;
	constant code_pause: integer :=3;
	constant code_goto: integer :=4;
	constant code_check: integer :=5;
	
	subtype type_shift_i2c is std_logic_vector(value_shift-1 downto 0);
	
	function i2c_write(data:type_data_i2c) return type_shift_i2c is
		variable q : type_shift_i2c;
	begin 
		q(08 downto 01):=data;   
		q(0):='1';   
		return q; 
	end i2c_write;
	function i2c_read(shiftreg:type_shift_i2c ) return type_data_i2c is
		variable q : type_data_i2c;
	begin 
		q:=shiftreg(07 downto 00);   
		return q; 
	end i2c_read; 
	
	constant div_clk: integer :=ref_freq/scl_freq/4;
	signal en: boolean:= false; 
	signal adr_count: integer range 0 to 4095;
begin					   
	--------------------------------------------	
	ena<=en; 
	adr<=conv_std_logic_vector(adr_count,11);
	i2c_proc: process (reset,clock,en)
		type state_type is (start,wait_i2c,
		state_start,state_stop,state_pause,state_goto,state_check,
		state_write_1,state_write_2,state_write_3,
		state_read_1,state_read_2,state_read_3,
		error_state);
		variable state : state_type:=start;	
		variable shift_wrreg,shift_rdreg: type_shift_i2c;  
		variable adr_hi: std_logic_vector(3 downto 0);
		variable count: integer range 0 to value_pause; 
	begin
		if reset='1' then 	
			scl<='Z';
			sda<='Z';
			i2c_valid<=false;
			count:=0;
			adr_hi:=(others=>'0');
			shift_wrreg:=(others=>'0');
			shift_rdreg:=(others=>'0');
			state:=start; 
		elsif rising_edge(clock) and en then  
			
			case state is
				when start => 
					scl<='1';
					sda<='1';
					i2c_valid<=false;
					adr_count<=0;
					state:=wait_i2c; 
				
				when wait_i2c =>  
					i2c_valid<=false;
					adr_count<=adr_count+1;
					adr_hi:=data(3 downto 0);
					if data(8)='1' then
						case conv_integer(data(7 downto 4)) is	
							when code_start => 
								count:=value_start;
								state:=state_start; 
							
							when code_stop => 
								count:=value_start;
								state:=state_stop; 	
							
							when code_read => 
								count:=value_shift;
								state:=state_read_1; 	
							
							when code_goto => 
								count:=value_goto;
								state:=state_goto; 	
							
							when code_check => 
								count:=value_goto*2;
								state:=state_check; 	
							
							when others => 
								count:=value_pause;
								state:=state_pause; 
							
						end case;
					else  
						count:=value_shift;	
						shift_wrreg:=i2c_write(data(7 downto 0));
						state:=state_write_1; 	
					end if;
				
				when state_start => 
					case count is	
						when 3 => sda<='0';
						when 2 => scl<='0';
						when others => null;
					end case;
					if count=0 then
						state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_stop => 
					case count is	
						when 3 => scl<='1';
						when 2 => sda<='1';
						when others => null;
					end case;
					if count=0 then
						state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_pause => 
					if count=0 then
						state:=wait_i2c;
					else
						count:=count-1;
					end if;
				
				when state_goto => 
					if count=0 then
						adr_count<=conv_integer(adr_hi & data(7 downto 0));
						state:=wait_i2c;
					else
						count:=count-1;
					end if;	
				
				when state_check => 
					if count=value_goto then
						if data/=i2c_read(shift_rdreg) then  
							adr_count<=adr_count+2;	 
							state:=wait_i2c; 
						else
							adr_count<=adr_count+1;	 
						end if;
					elsif count=0 then
						adr_count<=conv_integer(adr_hi & data(7 downto 0));
						state:=wait_i2c;
					end if;
					if count/=0 then
						count:=count-1;
					end if;
				
				when state_write_1 => 
					if count=1 then
						sda<='Z';
					else 
						sda<=shift_wrreg(value_shift-1); 
					end if;
					shift_wrreg:=shift_wrreg(value_shift-2 downto 0) & '0';
					count:=count-1;
					state:=state_write_2;
				
				when state_write_2 => 
					scl<='1';
					state:=state_write_3;
				
				when state_write_3 => 
					scl<='0';
					if count=0 then	
						sda<='0';
						state:=wait_i2c; 
					else
						state:=state_write_1;
					end if;
				
				when state_read_1 => 
					sda<='Z';
					count:=count-1;
					state:=state_read_2;
				
				when state_read_2 => 
					scl<='1';
					state:=state_read_3;
				
				when state_read_3 => 
					scl<='0';
					if count=0 then	
						sda<='0';
						i2c_q<=i2c_read(shift_rdreg);
						i2c_valid<=true;
						state:=wait_i2c; 
					else
						shift_rdreg:=shift_rdreg(value_shift-2 downto 0) & sda;
						state:=state_read_1;
					end if;
				
				when others => 
					state:=start;
				
			end case;
		end if;
	end process i2c_proc; 
	
	ena_proc: process (clock) 
		variable count_en : integer range 0 to div_clk-1 :=0;
	begin
		if rising_edge(clock) then 	 
			en<=count_en=0;
			if count_en=0 then 	 
				count_en:=div_clk-1;
			else
				count_en:=count_en-1;
			end if;
		end if;
	end process ena_proc; 	  
end main; 
