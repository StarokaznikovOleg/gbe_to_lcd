-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity lcd_ind is
	generic( hsize:integer:=1280; hblank:integer:=160; vsize:integer:=800; vblank:integer:=2;hstart:integer:=800; vstart:integer:=2; size:integer:=16;
		err_color:type_rgb_color:=rgb_red; mask_color:type_rgb_color:=rgb_yellow;
		level:integer:=3; pulse:integer:=3);
	port(
		pclk: in std_logic; 
		Hcount : in integer range 0 to hblank+hsize-1 :=0;	
		Vcount :  in integer range 0 to vblank+vsize-1 :=0;	
		ind_clk,ind_data: in std_logic_vector(level+pulse-1 downto 0):=(others=>'0'); 
		act: out boolean; 
		pixel :out type_rgb_color
		
		);
end lcd_ind;

architecture main of lcd_ind is	  	
	signal ind_act,mask_act,ind_sync: std_logic_vector(level+pulse-1 downto 0):=(others=>'0'); 
	signal frame : boolean :=false;
	
begin 
	a: if level>0 generate 
		b : for k in 0 to level-1 generate	
			err_x : entity work.sync 
			generic map(regime=>"level", inDelay=>0, outDelay=>0)
			port map(
				reset => '0',
				clk_in => ind_clk(k), 	data_in => ind_data(k),
				clk_out => pclk, 		data_out => ind_sync(k)
				);	
		end generate b;
	end generate a;
	c: if pulse>0 generate 
		d : for l in level to level+pulse-1 generate	
			err_x : entity work.sync 
			generic map(regime=>"spuls", inDelay=>0, outDelay=>0)
			port map(
				reset => '0',
				clk_in => ind_clk(l), 	data_in => ind_data(l),
				clk_out => pclk, 		data_out => ind_sync(l)
				);	
		end generate d;
	end generate c;
	e: for m in 0 to level+pulse-1 generate	
		stabile_pulse_err_proc: process (pclk)
			variable count_timer : integer range 0 to 120:=0;
			variable err_sign : std_logic:='0';
		begin
			if rising_edge(pclk) then 
				if (Vcount=vblank+vstart or Vcount=vblank+vstart+size-1) and Hcount>=hblank+hstart and Hcount<hblank+hstart+size*(m+1) then
					mask_act(m)<='1';
				elsif Vcount>vblank+vstart and Vcount<vblank+vstart+size then
					if Hcount=hblank+hstart+size*m+0 then
						mask_act(m)<='1';
					elsif  Hcount=hblank+hstart+size*m+1 then
						mask_act(m)<='0';
						ind_act(m)<=err_sign;
					elsif Hcount=hblank+hstart+size*m+size-1 then
						mask_act(m)<='1';
						ind_act(m)<='0';
					elsif Hcount=hblank+hstart+size*m+size then
						mask_act(m)<='0';
					end if;
				else
					mask_act(m)<='0';
					ind_act(m)<='0';
				end if;
				if ind_sync(m)='1' and count_timer=0 then
					count_timer:=120;
				elsif frame then   
					err_sign:=boolean_to_data(count_timer>60); 
					if count_timer/=0 then
						count_timer:=count_timer-1;
					end if;
				end if;
			end if;
		end process stabile_pulse_err_proc;  
	end generate e;
	
	position_err: process (pclk)
	begin
		if rising_edge(pclk)then 
			frame<=Vcount=0 and hcount=0;
			if conv_integer(ind_act)/=0 then
				act<=true;
				pixel<=err_color;
			elsif conv_integer(mask_act)/=0 then
				act<=true;
				pixel<=mask_color; 
			else
				act<=false;
				pixel<=rgb_black; 
			end if;
		end if;
	end process position_err; 
	
end main; 
