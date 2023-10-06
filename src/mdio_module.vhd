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
	constant clause22 : integer:=1;
	constant clause45 : integer:=0;
	constant OPcode_read : integer:=2;
	constant OPcode_write : integer:=1;	 
	subtype type_data_mdi is std_logic_vector(15 downto 0);
	subtype type_shift_mdi is std_logic_vector(31 downto 0);
	
	constant DEV_count : integer:=2;
	constant PHY_Status_adr : integer:=01;
	type type_dev_adr_mdi_array is array (DEV_count-1 downto 0) of integer range 0 to 31;	
	constant DEV_adr: type_dev_adr_mdi_array :=(3,1); 	   
	signal count_phy: integer range 0 to DEV_count-1; 
	
	constant PHYwr_count : integer:=6;
	type type_regwr_adr_mdi_array is array (PHYwr_count-1 downto 0) of integer range 0 to 31;	
	type type_regwr_data_mdi_array is array (PHYwr_count-1 downto 0) of type_data_mdi;	
	constant PHYwr_adr: type_regwr_adr_mdi_array :=(00,31,30,31,30,04); 	   
	constant PHYwr_data: type_regwr_data_mdi_array :=(x"9140",x"000f",x"a00f",x"000f",x"a00f",x"1001"); 	   

	
	constant PHYrd_count : integer:=16;
	type type_regrd_adr_mdi_array is array (PHYrd_count-1 downto 0) of integer range 0 to 31;	
	type type_regrd_data_mdi_array is array (PHYrd_count-1 downto 0) of type_data_mdi;	
	constant PHYrd_adr: type_regrd_adr_mdi_array :=(15,14,13,12,11,10,09,08,07,06,05,04,03,02,01,00); 	   
	
	signal count_reg: integer range 0 to 31; 
	signal mdio_access,mdio_wr,mdio_done : std_logic;
	signal mdio_phy,mdio_dev : integer range 0 to 31;
	signal mdio_data,mdio_q : type_data_mdi;
	
	
	
	type state_type is (start,
	init_s1,init_s2,init_s3,
	scan_s1,scan_s2,scan_s3);
	signal state : state_type:=start;	
	--	signal status_reg: type_data_mdi_array; 
	signal count: integer range 0 to 255; 
	signal ena: boolean:= false; 
	
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
	main_proc: process (reset,clock,ena)
	begin
		if reset='1' then 	
			count_phy<=0;
			count_reg<=0;
			mdio_dev<=0;
			mdio_phy<=0;
			mdio_data<=(others=>'0');
			mdio_access<='0';
			mdio_wr<='0';
			link<=(others=>'0');
			state<=start; 
		elsif rising_edge(clock) and ena then 
			case state is
				when start => 
					count_phy<=0;
					count_reg<=0;
					mdio_dev<=0;
					mdio_phy<=0;
					mdio_data<=(others=>'0');
					mdio_access<='0';
					mdio_wr<='0';
					link<=(others=>'0');
					state<=init_s1; 
				
				when init_s1 =>  
					if mdio_done='1' then
						state<=init_s2;
					end if;
				
				when init_s2 =>  
					mdio_dev<=DEV_adr(count_phy);
					mdio_phy<=PHYwr_adr(count_reg);
					mdio_data<=PHYwr_data(count_reg);
					mdio_access<='1';
					mdio_wr<='1';
					if mdio_done='0' then
						state<=init_s3;
					end if;
				
				when init_s3 => 
					if mdio_done='1' then
						mdio_access<='0';
						if count_reg=PHYwr_count-1 then
							count_reg<=0;
							if count_phy=DEV_count-1 then
								state<=scan_s1;
								count_phy<=0;
							else
								state<=init_s1; 
								count_phy<=count_phy+1;
							end if;
						else
							state<=init_s1; 
							count_reg<=count_reg+1;
						end if;
					end if;	
				
				when scan_s1 =>  
					if mdio_done='1' then
						state<=scan_s2;
					end if;
				
				when scan_s2 =>  
					mdio_dev<=DEV_adr(count_phy);
					mdio_phy<=PHYrd_adr(count_reg);
					mdio_access<='1';
					mdio_wr<='0';
					if mdio_done='0' then
						state<=scan_s3;
					end if;
				
				when scan_s3 => 
					if mdio_done='1' then
						mdio_access<='0'; 
						link(count_phy)<=mdio_q(2);
						state<=scan_s1; 
						if count_reg=PHYrd_count-1 then
							count_reg<=0;
							if count_phy=DEV_count-1 then
								count_phy<=0;
							else
								count_phy<=count_phy+1;
							end if;
						else
							count_reg<=count_reg+1;
						end if;
					end if;		 
				
				when others => 
					state<=start;
				
			end case;
		end if;
	end process main_proc; 	  
	
	--------------------------------------------	
	mdio_proc: process (reset,clock,ena)
		type mdio_state_type is (start,wait_mdio,pause,mdio_set,mdio_shift);
		variable mdio_state : mdio_state_type:=start;	
		variable shift_reg: type_shift_mdi;  	   
		variable count: integer range 0 to 255; 
	begin
		if reset='1' then 	
			mdc<='Z';
			mdio<='Z';
			mdio_done<='0';
			count:=64;
			shift_reg:=(others=>'0');
			mdio_state:=start; 
		elsif rising_edge(clock) and ena then 
			case mdio_state is
				when start => 
					mdc<='Z';
					mdio<='Z';	
					mdio_done<='1';
					mdio_state:=wait_mdio; 
				
				when wait_mdio => 
					mdc<='Z';
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
						mdio_q<=MDIrd_read(shift_reg);
						if mdio_access='0' then
							mdio_state:=wait_mdio; 
						end if;	
					else 
						shift_reg:=shift_reg(30 downto 0) & mdio;
						count:=count-1;
						mdio_state:=mdio_set;
					end if;	
				
				when others => 
					mdio_state:=start;
				
			end case;
		end if;
	end process mdio_proc; 
	
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
