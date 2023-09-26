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
	constant DEV_count : integer:=2;
	constant clause22 : integer:=1;
	constant clause45 : integer:=0;
	constant OPcode_read : integer:=2;
	constant OPcode_write : integer:=1;	 
	subtype type_data_mdi is std_logic_vector(15 downto 0);
	
	constant PHY_Ident1_adr : integer:=2;
	constant PHY_Ident1_code : type_data_mdi:=x"4f51";
	constant PHY_Status_adr : integer:=17;
	constant PHY_Status_code : type_data_mdi:=x"bc00";
	
	type state_type is (start,init_s1,init_s2,init_s3,init_s4,scan_s1,scan_s2,scan_s3,scan_s4);
	signal state : state_type:=start;	
	subtype type_shift_mdi is std_logic_vector(31 downto 0);
	signal shift_reg: type_shift_mdi;  
	signal count_phy: integer range 0 to DEV_count-1; 
	type type_data_mdi_array is array (DEV_count-1 downto 0) of type_data_mdi;	
	signal status_reg: type_data_mdi_array; 
	signal count: integer range 0 to 255; 
	signal ena: boolean:= false; 
	
	function MDIrd_set(DEV_adr:integer;PHYadr:integer ) return type_shift_mdi is
		variable q : type_shift_mdi;
	begin 
		q(31 downto 30):=conv_std_logic_vector(Clause22,2);   
		q(29 downto 28):=conv_std_logic_vector(OPcode_read,2);   
		q(27 downto 23):=conv_std_logic_vector(DEV_adr,5);   
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
			count_phy<=0;
			shift_reg<=(others=>'0');
			status_reg<=(others=>(others=>'0'));
			state<=start; 
		elsif rising_edge(clock) and ena then 
			link(0)<=boolean_to_data(status_reg(0)(15 downto 8)=PHY_Status_code(15 downto 8));
			link(1)<=boolean_to_data(status_reg(1)(15 downto 8)=PHY_Status_code(15 downto 8));
			case state is
				when start => 
					mdc<='Z';
					mdio<='Z';
					count_phy<=0;
					shift_reg<=(others=>'0');
					status_reg<=(others=>(others=>'0'));
					state<=init_s1; 
				
				when init_s1 => 
					mdc<='0';
					mdio<='Z';
					state<=init_s2;	  
				
				when init_s2 =>  
					mdc<='0';
					mdio<='Z';
					shift_reg<=MDIrd_set(DEV_address+count_phy,PHY_Ident1_adr);
					if count=0 then
						count<=32;
						state<=init_s3;
					else 
						state<=init_s1;	  
						count<=count-1;
					end if;
				
				when init_s3 => 
					mdc<='1';
					state<=init_s4;
				
				when init_s4 => 
					mdc<='0';
					if count>18 then 
						mdio<=shift_reg(31);  
					else 
						mdio<='Z';
					end if;
					shift_reg<=shift_reg(30 downto 0) & mdio;
					if count=0 then
						count<=63;
						if MDIrd_read(shift_reg)=PHY_Ident1_code then
							if count_phy=DEV_count-1 then
								state<=scan_s1; 
								count_phy<=0;
							else
								state<=init_s1; 
								count_phy<=count_phy+1;
							end if;
						else
							state<=start; 
						end if;
					else 
						count<=count-1;
						state<=init_s3;
					end if;
					
				
				when scan_s1 => 
					mdc<='0';
					mdio<='Z';
					state<=scan_s2;	  
				
				when scan_s2 =>  
					mdc<='0';
					mdio<='Z';
					shift_reg<=MDIrd_set(DEV_address+count_phy,PHY_Status_adr);
					if count=0 then
						count<=32;
						state<=scan_s3;
					else 
						state<=scan_s1;	  
						count<=count-1;
					end if;
				
				when scan_s3 => 
					mdc<='1';
					state<=scan_s4;
				
				when scan_s4 => 
					mdc<='0';
					if count>18 then 
						mdio<=shift_reg(31);  
					else 
						mdio<='Z';
					end if;
					shift_reg<=shift_reg(30 downto 0) & mdio;
					if count=0 then
						count<=63;
						status_reg(count_phy)<=MDIrd_read(shift_reg);
						state<=scan_s1; 
						if count_phy=DEV_count-1 then
							count_phy<=0;
						else
							count_phy<=count_phy+1;
						end if;
					else 
						count<=count-1;
						state<=scan_s3;
					end if;
					
					
					
				
				when others => 
					state<=init_s1;
				
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
