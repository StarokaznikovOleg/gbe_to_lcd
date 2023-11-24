-------------------------------------------------------------------------------
-- Title       : mdio_interface
-- Design      : mdio
-- Author      : Starokaznikov OV.
-- Company     : Protei
-------------------------------------------------------------------------------
library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.mdio_lib.all; 

entity mdio_interface is
	generic( ref_freq : integer:=125000000; mdc_freq : integer:=5000000);
	port(
		reset,clock: in std_logic; 
		mdc,mdio: inout std_logic;
		ena: out boolean;
		adr: out type_mem_a_mdio;
		data: in type_mem_d_mdio;
		mdio_valid: out boolean;
		mdio_q: out type_data_mdio
		);
end mdio_interface;

architecture main of mdio_interface is
	
	constant div_clk: integer :=ref_freq/mdc_freq/4;
	constant value_start: integer :=8;
	constant value_pause: integer :=2047; 
	
	constant code_read: integer :=8;
	constant code_write: integer :=9;
	constant code_pause: integer :=10;
	constant code_goto: integer :=11;
	constant code_check: integer :=12;
	
	constant clause22 : integer:=1;
	constant clause45 : integer:=0;
	constant OPcode_read : integer:=2;
	constant OPcode_write : integer:=1;	 
	subtype type_data_mdi is std_logic_vector(15 downto 0);
	subtype type_shift_mdi is std_logic_vector(31 downto 0);
	
	signal mdio_access,mdio_wr,mdio_done : std_logic;
	signal mdio_phy,mdio_dev : integer range 0 to 31;
	signal mdio_data : type_data_mdi;
	signal int_mdio_q : type_data_mdio;
	signal adr_count: integer range 0 to 4095;
	
	type state_type is (st_init,st_wait,st_cmd,
	st_wr1,st_wr2,st_wr3,st_wr4,st_wr5,
	st_ch1,st_ch2,st_ch3,st_ch4,st_ch5,
	st_rd1,st_rd2,st_rd3,st_rd4,
	st_pause,st_goto,
	st_error);
	signal state : state_type;	
	signal en: boolean:= false; 
	
	function MDIwr_set(DEV_adr:integer;PHYadr:integer;PHYdata:type_data_mdi) return type_shift_mdi is
		variable q : type_shift_mdi;
	begin 
		q(31 downto 30):=conv_std_logic_vector(Clause22,2);   
		q(29 downto 28):=conv_std_logic_vector(OPcode_write,2);   
		q(27 downto 23):=conv_std_logic_vector(DEV_adr,5);   
		q(22 downto 18):=conv_std_logic_vector(PHYadr,5);   
		q(17 downto 16):="10";   
		q(15 downto 00):=PHYdata;   
		return q; 
	end MDIwr_set;
	function MDIrd_set(DEV_adr:integer;PHYadr:integer ) return type_shift_mdi is
		variable q : type_shift_mdi;
	begin 
		q(31 downto 30):=conv_std_logic_vector(Clause22,2);   
		q(29 downto 28):=conv_std_logic_vector(OPcode_read,2);   
		q(27 downto 23):=conv_std_logic_vector(DEV_adr,5);   
		q(22 downto 18):=conv_std_logic_vector(PHYadr,5);   
		q(17 downto 00):=conv_std_logic_vector(0,18);   
		return q; 
	end MDIrd_set;
	function MDIrd_read(shiftreg:type_shift_mdi ) return type_data_mdi is
		variable q : type_data_mdi;
	begin 
		q:=shiftreg(15 downto 0);   
		return q; 
	end MDIrd_read; 
	
begin
	--------------------------------------------
	ena<=en; 
	adr<=conv_std_logic_vector(adr_count,11);
	mdio_q<=int_mdio_q;
	main_proc: process (reset,clock,en)
		variable adr_hi: std_logic_vector(3 downto 0);
		variable count: integer range 0 to value_pause;
		variable check : boolean;
	begin
		if reset='1' then 	
			adr_count<=0;
			mdio_valid<=false;
			mdio_dev<=0;
			mdio_phy<=0;
			mdio_data<=(others=>'0');
			mdio_access<='0';
			mdio_wr<='0';
			state<=st_init;
			check:=false;
		elsif rising_edge(clock) and en then 
			case state is
				when st_init => 
					mdio_dev<=0;
					mdio_phy<=0;
					mdio_data<=(others=>'0');
					mdio_access<='0';
					mdio_wr<='0'; 
					state<=st_wait; 
					
				
				when st_wait =>  
					mdio_valid<=false;
					check:=false;
					if mdio_done='1' then
						state<=st_cmd;
					end if;
				
				when st_cmd =>  
					adr_hi:=data(3 downto 0);
					adr_count<=adr_count+1;
					case conv_integer(data(8 downto 5)) is
						when code_read => state<=st_rd1; count:=value_start;
						when code_write => state<=st_wr1; count:=value_start;
						when code_pause => state<=st_pause; count:=value_pause;
						when code_goto => state<=st_goto; count:=value_start;
						when code_check => state<=st_ch1; count:=value_start;
						when others => state<=st_error; count:=value_start;
					end case; 										   
				
				when st_wr1 =>  
					adr_count<=adr_count+1;
					mdio_dev<=conv_integer(data(4 downto 0));
					state<=st_wr2; 
				
				when st_wr2 =>  
					adr_count<=adr_count+1;
					mdio_phy<=conv_integer(data(4 downto 0));
					state<=st_wr3;	  
				
				when st_wr3 =>  
					adr_count<=adr_count+1;
					mdio_data(15 downto 8)<=data(7 downto 0);
					state<=st_wr4;		
				
				when st_wr4 =>  
					mdio_data(7 downto 0)<=data(7 downto 0);
					mdio_access<='1';
					mdio_wr<='1';
					if mdio_done='0' then
						adr_count<=adr_count+1;
						state<=st_wr5;
					end if;
				
				when st_wr5 => 
					if mdio_done='1' then
						mdio_access<='0';
						state<=st_wait; 
					end if;	
				
				when st_ch1 =>  
					adr_count<=adr_count+1;
					mdio_dev<=conv_integer(data(4 downto 0));
					state<=st_ch2; 
				
				when st_ch2 =>  
					mdio_phy<=conv_integer(data(4 downto 0));
					mdio_access<='1';
					mdio_wr<='0';
					if mdio_done='0' then
						state<=st_ch3;
					end if;	 
				
				when st_ch3 => 
					if mdio_done='1' then
						mdio_access<='0'; 
						adr_count<=adr_count+1;
						state<=st_ch4; 
					end if;
				
				when st_ch4 => 
					adr_count<=adr_count+1;
					check:=int_mdio_q(15 downto 8)=data(7 downto 0);
					state<=st_ch5; 
				
				when st_ch5 => 
					if check and int_mdio_q(7 downto 0)=data(7 downto 0) then
						adr_count<=adr_count+1;
						state<=st_goto; 
					else
						adr_count<=adr_count+2;
						state<=st_wait; 
					end if;
				
				when st_rd1 =>  
					adr_count<=adr_count+1;
					mdio_dev<=conv_integer(data(4 downto 0));
					state<=st_rd2; 
				
				when st_rd2 =>  
					mdio_phy<=conv_integer(data(4 downto 0));
					mdio_access<='1';
					mdio_wr<='0';
					if mdio_done='0' then
						state<=st_rd3;
					end if;	 
				
				when st_rd3 => 
					if mdio_done='1' then
						mdio_access<='0'; 
						mdio_valid<=true;
						adr_count<=adr_count+1;
						state<=st_wait; 
					end if;	
				
				when st_pause => 
					if count=0 then
						state<=st_wait;
					else
						count:=count-1;
					end if;
				
				when st_goto => 
					if count=0 then
						adr_count<=conv_integer(adr_hi & data(7 downto 0));
						state<=st_wait;
					else
						count:=count-1;
					end if;	
					
				
				when others => -- st_error
					adr_count<=0;
					mdio_valid<=false;
					mdio_dev<=0;
					mdio_phy<=0;
					mdio_data<=(others=>'0');
					mdio_access<='0';
					mdio_wr<='0';
					state<=st_init; 
				
			end case;
		end if;
	end process main_proc; 	  
	
	--------------------------------------------	
	mdio_proc: process (reset,clock,en)
		type mdio_state_type is (st_init,wait_mdio,pause,mdio_set,mdio_shift);
		variable mdio_state : mdio_state_type:=st_init;	
		variable shift_reg: type_shift_mdi;  	   
		variable count: integer range 0 to 255; 
	begin
		if reset='1' then 	
			mdc<='Z';
			mdio<='Z';
			mdio_done<='0';
			count:=64;
			int_mdio_q<=(others=>'0');
			shift_reg:=(others=>'0');
			mdio_state:=st_init; 
		elsif rising_edge(clock) and en then 
			case mdio_state is
				when st_init => 
					mdc<='Z';
					mdio<='Z';	
					mdio_done<='1';
					mdio_state:=wait_mdio; 
				
				when wait_mdio => 
					mdc<='0';
					mdio<='Z';
					count:=32;
					if mdio_access='1' then
						mdio_done<='0';
						if mdio_wr='1' then 
							shift_reg:=MDIwr_set(mdio_dev,mdio_phy,mdio_data);
						else
							shift_reg:=MDIrd_set(mdio_dev,mdio_phy);	 
						end if;
						mdio_state:=pause; 
					end if;
				
				when pause =>  
					mdc<='0';
					mdio<='Z';
					if count=0 then
						count:=32;
						mdio_state:=mdio_set;
					else 
						count:=count-1;
					end if;
				
				when mdio_set => 
					mdc<='1';
					mdio_state:=mdio_shift;
				
				when mdio_shift => 
					mdc<='0';
					if mdio_wr='1' or count>18 then 
						mdio<=shift_reg(31);  
					else 
						mdio<='Z';
					end if;
					if count=0 then
						mdio_done<='1';
						int_mdio_q<=MDIrd_read(shift_reg);
						if mdio_access='0' then
							mdio_state:=wait_mdio; 
						end if;	
					else 
						shift_reg:=shift_reg(30 downto 0) & mdio;
						count:=count-1;
						mdio_state:=mdio_set;
					end if;	
				
				when others => 
					mdio_state:=st_init;
				
			end case;
		end if;
	end process mdio_proc; 
	
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
