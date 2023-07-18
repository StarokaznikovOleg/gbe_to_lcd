-------------------------------------------------------------------------------
-- Title       : mdio_module
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
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity mdio_module is
	port(
		reset,clock: in std_logic; 
		mdc,mdio: inout std_logic;
		
		link: out std_logic_vector(1 downto 0) 
		);
end mdio_module;

architecture main of mdio_module is			 
	constant DEV_address : integer:=0;
	constant clause22 : integer:=1;
	constant clause45 : integer:=0;
	constant OPcode_read : integer:=2;
	constant OPcode_write : integer:=1;	 
	
	constant PHY_Ident1_adr : integer:=2;
	constant PHY_Ident2_adr : integer:=3;
	
	type state_type is (start,init0,init1,idle1,idle2,check1,check2);
	signal state : state_type:=start;	
	subtype type_shift_mdi is std_logic_vector(31 downto 0);
	subtype type_data_mdi is std_logic_vector(15 downto 0);
	signal shift_reg: type_shift_mdi; 
	signal status_reg0,status_reg1: type_data_mdi; 
	signal count: integer range 0 to 255; 
	signal ena: boolean:= false; 
	
	function MDIrd_set(PHYadr:integer ) return type_shift_mdi is
		variable q : type_shift_mdi;
	begin 
		q(31 downto 30):=conv_std_logic_vector(Clause22,2);   
		q(29 downto 28):=conv_std_logic_vector(OPcode_read,2);   
		q(27 downto 23):=conv_std_logic_vector(DEV_address,5);   
		q(22 downto 18):=conv_std_logic_vector(PHYadr,5);   
		q(17 downto 0):=conv_std_logic_vector(0,18);   
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
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			mdc<='Z';
			mdio<='Z';
			shift_reg<=(others=>'0');
			status_reg0<=(others=>'0');
			status_reg1<=(others=>'0');
			state<=start; 
		elsif rising_edge(clock) and ena then 
			link(0)<=boolean_to_data(status_reg0=x"0141");
			link(1)<=boolean_to_data(status_reg1=x"0141");
			case state is
				when start => 
					state<=idle1; 
				
				when idle1 => 
					mdc<='0';
					mdio<='Z';
					state<=idle2;	  
				
				when idle2 =>  
					mdc<='0';
					mdio<='Z';
					shift_reg<=MDIrd_set(PHY_Ident1_adr);
					if count=0 then
						count<=32;
						state<=check1;
					else 
						state<=idle1;	  
						count<=count-1;
					end if;
				
				when check1 => 
					mdc<='1';
					state<=check2;
				
				when check2 => 
					mdc<='0';
					if count>18 then 
						mdio<=shift_reg(31);  
					else 
						mdio<='Z';
					end if;
					shift_reg<=shift_reg(30 downto 0) & mdio;
					if count=0 then
						count<=63;
						status_reg0<=MDIrd_read(shift_reg);
						status_reg1<=MDIrd_read(shift_reg);
						state<=idle1;
					else 
						count<=count-1;
						state<=check1;
					end if;
				
				when others => 
					state<=idle1;
				
			end case;
		end if;
	end process main_proc; 	  
	
	ena_proc: process (clock) 
		variable count_en : integer range 0 to 63 :=0;
	begin
		if rising_edge(clock) then 	 
			ena<=count_en=0;
			if count_en=0 then 	 
				count_en:=25;
			else
				count_en:=count_en-1;
			end if;
		end if;
	end process ena_proc; 	  
end main; 
