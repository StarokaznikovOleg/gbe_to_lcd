library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package eth_lib is
	
	constant QinQEthType : std_logic_vector(15 downto 0) :=x"88A8";
	constant VlanEthType : std_logic_vector(15 downto 0) :=x"8100";
	constant const_IP : std_logic_vector(15 downto 0) :=x"0800";
	
	constant pdata_8value:	integer :=32;
	constant ddata_8value:	integer :=16;
	constant buffer_value:	integer :=23;
	constant IPhash1_value:	integer :=24; 
	constant IPhash2_value:	integer :=32; 
	constant SGhash_value:	integer :=8; 
	constant link_value:	integer :=13;
	constant error_value:	integer :=15;
	constant max_delay_time: integer :=500;	-- 1unit=32time/125MHz(s)	  <(2^dataAdr_value)/32
	constant min_packet_len : integer :=60; 
	constant max_packet_len : integer :=8191; 
	
	constant ProteiEthType : std_logic_vector(15 downto 0):=x"9201"; 
	constant ProteiEthType_version : std_logic_vector(7 downto 0):=x"01"; 
	constant ProteiMulticastMacDPI : std_logic_vector(47 downto 0):=x"015043000000"; 
	constant ProteiMulticastMacServer : std_logic_vector(47 downto 0):=x"015044000000"; 
	constant IntUnicastMacDefault : std_logic_vector(47 downto 0):=x"0016e6428897"; 
	
	constant ProteiEthSignature : std_logic_vector(63 downto 0):=x"0207172941536173"; 
	
	subtype logchannel_type is integer range 0 to 255;
	constant Server_logchannel : logchannel_type :=5; 
	constant clear_logchannel : logchannel_type :=0;
	
	subtype protei_property_type is std_logic_vector(31 downto 0);
	constant clear_protei_property : protei_property_type := x"00000000"; 
	
	subtype devadr_type is integer range 0 to 255;
	constant protei_devadr :devadr_type :=1;
	subtype len_type is integer range 0 to max_packet_len;
	constant clear_len : len_type:=0;
	subtype lenw_type is integer range 0 to max_packet_len/ddata_8value;
	constant clear_lenw : lenw_type:=0;
	subtype start_adr_type is std_logic_vector(buffer_value-1 downto 0);
	constant clear_start_adr : start_adr_type:= conv_std_logic_vector(0,buffer_value);
	subtype link_type is std_logic_vector(link_value-1 downto 0);
	constant clear_link : link_type:= conv_std_logic_vector(0,link_value);
	subtype address_type is std_logic_vector(31 downto 0);
	subtype intime_type is std_logic_vector(31 downto 0);
	constant clear_intime : intime_type:=(others=>'0');	
	subtype vlan_type is std_logic_vector(11 downto 0);
	constant clear_vlan : vlan_type:=(others=>'0');	
	
	function boolean_to_data_x(data:boolean) return std_logic;	
	function data_to_boolean_x(data:std_logic) return boolean;	
	
	subtype pdata_type is std_logic_vector(pdata_8value*8-1 downto 0);
	constant clear_pdata : pdata_type :=(others=>'0');
	subtype ddata_type is std_logic_vector(ddata_8value*8-1 downto 0);
	constant clear_ddata : ddata_type :=(others=>'0');
	subtype phychannel_type is integer range 0 to 15;
	constant clear_phychannel : phychannel_type :=0;
	subtype id_type is std_logic_vector(15 downto 0);
	constant clear_id : id_type := x"0000";
	subtype IPhash1_type is std_logic_vector(IPhash1_value-1 downto 0);
	constant  clear_IPhash1 : IPhash1_type := conv_std_logic_vector(0,IPhash1_value);
	subtype IPhash2_type is std_logic_vector(IPhash2_value-1 downto 0);
	constant  clear_IPhash2 : IPhash2_type := conv_std_logic_vector(0,IPhash2_value);
	subtype SGhash_type is std_logic_vector(SGhash_value-1 downto 0);
	constant  clear_SGhash : SGhash_type := conv_std_logic_vector(0,SGhash_value);
	type segment_type is (none,first,middle,last);
	subtype segment_data_type is std_logic_vector(1 downto 0);
	constant clear_segment : segment_type := none;
	subtype eth_protocol_fild_type is std_logic_vector(15 downto 0);
	constant ipEthType : eth_protocol_fild_type :=x"0800";
	constant arpEthType : eth_protocol_fild_type :=x"0806";
	subtype vlanrx_datatype is std_logic_vector(1 downto 0);
	type vlanrx_type is (none,one,two);
	constant clear_vlanrx_type : vlanrx_type := none;
	subtype vlantx_datatype is std_logic_vector(1 downto 0);
	type vlantx_type is (none,insert,delete);
	constant clear_vlantx_type : vlantx_type := none;
	type eth_protocol_type is (unknow,ip,arp,protei);
	constant clear_eth_protocol : eth_protocol_type := unknow;
	subtype eth_protocol_data_type is std_logic_vector(1 downto 0);
	subtype ip_protocol_fild_type is std_logic_vector(7 downto 0);
	constant const_IP_UDP : ip_protocol_fild_type :=x"11";
	constant const_IP_TCP : ip_protocol_fild_type :=x"06";
	constant const_IP_ICMP : ip_protocol_fild_type :=x"01";
	type IP_protocol_type is (unknow,udp,tcp,icmp);
	constant clear_ip_protocol : IP_protocol_type := unknow;
	subtype ip_protocol_data_type is std_logic_vector(1 downto 0);
	type action_type is (drop,send,copy,move);
	subtype action_data_type is std_logic_vector(1 downto 0);
	subtype mac_adr_type is std_logic_vector(47 downto 0);
	constant clear_mac_adr : mac_adr_type := x"000000000000";
	subtype dscp_type is std_logic_vector(7 downto 0);
	constant  clear_dscp : dscp_type := x"00";
	subtype queue_type is std_logic_vector(7 downto 0);
	constant  clear_queue : queue_type := x"00";
	subtype IP_adr_type is std_logic_vector(31 downto 0);
	constant clear_ip_adr : IP_adr_type := x"00000000";
	subtype IP_port_type is std_logic_vector(15 downto 0);
	constant clear_ip_port : IP_port_type := x"0000";
	subtype ip_tos_type is std_logic_vector(7 downto 0);
	constant clear_ip_tos : ip_tos_type := (others=>'0'); 
	subtype hex_character_type is std_logic_vector(3 downto 0);
	subtype count_err_type is integer range 0 to 255;
	subtype lcd_character_type is std_logic_vector(7 downto 0);
	
	type config_type is record
		mac_address : std_logic_vector(47 downto 0);
		clock : std_logic;
		inc : std_logic;
	end record;
	constant clear_config : config_type := (IntUnicastMacDefault,'0','0');	
	
	subtype stat_data_type is std_logic_vector(39 downto 0);
	constant clear_stat_data : stat_data_type :=(others=>'0');
	type stat_type is record
		byte : stat_data_type;
		packet : stat_data_type;
	end record;
	constant clear_stat : stat_type :=(clear_stat_data,clear_stat_data);
	
	type time_type is record
		intime : intime_type;
		clock : std_logic;
		inc : std_logic;
	end record;
	constant clear_time : time_type := (clear_intime,'0','0');	
	
	subtype errcode_type is integer range 0 to 31;
	constant clear_errcode : errcode_type := 0;	
	type error_type is record
		code : errcode_type;
		clock : std_logic;
		act : boolean;
	end record;
	constant clear_error : error_type := (0,'0',false);		
	type error_array_type is array (error_value-1 downto 0) of error_type;
	
	subtype prt_data_type is std_logic_vector(35 downto 0);
	type prt_type is record
		start_adr : start_adr_type;
		lenw : lenw_type;		 
	end record;
	constant clear_prt : prt_type := (clear_start_adr,clear_lenw);		
	
	subtype packet_data_type is std_logic_vector(511 downto 0);
	type packet_array_type is array (511 downto 0) of std_logic;
	constant clear_packet_data : packet_data_type := (others=>'0');
	
		subtype command_type is integer range 0 to 255;

	
	type packet_type is record
		inchannel_phy : phychannel_type;
		inchannel_log : logchannel_type;
		outchannel_phy : phychannel_type;
		outchannel_log : logchannel_type;
		intime : intime_type;
		start_adr : start_adr_type;
		len : len_type;		 
		lenw : lenw_type;		 
		mac_destination : mac_adr_type;
		mac_source : mac_adr_type;
		vlanrx : vlan_type;
		vlanrxact : vlanrx_type;
		vlantx : vlan_type;
		vlantxact : vlantx_type;
		eth_protocol : eth_protocol_type;
		segment : segment_type;
		id : id_type;
		good_packet : boolean;
		ip_broadcast : boolean;
		ip_s : ip_adr_type;
		port_s : ip_port_type;
		ip_d : ip_adr_type;
		port_d : ip_port_type;
		ip_protocol : ip_protocol_type;
		ip_tos : ip_tos_type;
		dscp : dscp_type;
		protei_module : devadr_type;
		protei_property : protei_property_type;
		protei_cmd : command_type;
		queue : queue_type;
	end record;
	constant clear_packet : packet_type := (clear_phychannel,clear_logchannel,clear_phychannel,clear_logchannel,clear_intime,clear_start_adr,clear_len,clear_lenw,clear_mac_adr,clear_mac_adr,clear_vlan,clear_vlanrx_type,clear_vlan,clear_vlantx_type,clear_eth_protocol,clear_segment,clear_id,false,false,
	clear_ip_adr,clear_ip_port,clear_ip_adr,clear_ip_port,clear_ip_protocol,clear_ip_tos,clear_dscp,0,clear_protei_property,0,clear_queue);
	
	function data_to_vlantxact(data:vlantx_datatype) return vlantx_type;
	function vlantxact_to_data(data:vlantx_type) return vlantx_datatype;
	function data_to_vlanrxact(data:vlanrx_datatype) return vlanrx_type;
	function vlanrxact_to_data(data:vlanrx_type) return vlanrx_datatype;
	function prt_to_data(data:prt_type) return prt_data_type;
	function data_to_prt(data:prt_data_type) return prt_type;
	function packet_to_data(data:packet_type) return packet_data_type;
	function data_to_packet(data:packet_data_type) return packet_type;
	function fild_to_ETHprotocol(data:eth_protocol_fild_type) return eth_protocol_type;
	function ETHprotocol_to_fild(data:eth_protocol_type) return eth_protocol_fild_type;
	function data_to_ETHprotocol(data:eth_protocol_data_type) return eth_protocol_type;
	function ETHprotocol_to_data(data:eth_protocol_type) return eth_protocol_data_type;
	function fild_to_IPprotocol(data:ip_protocol_fild_type) return ip_protocol_type;
	function IPprotocol_to_fild(data:ip_protocol_type) return ip_protocol_fild_type;
	function data_to_IPprotocol(data:ip_protocol_data_type) return ip_protocol_type;
	function IPprotocol_to_data(data:ip_protocol_type) return ip_protocol_data_type;
	function packet_to_IPhash0(init: std_logic_vector(31 downto 0); packet:packet_type) return IPhash1_type;	
	function IPhash0_to_IPhash1(init: std_logic_vector(31 downto 0); hash0:IPhash1_type) return IPhash1_type;	 
	function packet_to_IPhash2(packet:packet_type) return IPhash2_type;	
	function packet_to_SGhash(packet:packet_type) return SGhash_type;	 
	function data_to_action(data:action_data_type) return action_type;
	function action_to_data(data:action_type) return action_data_type;
	function data_to_segment(data:segment_data_type) return segment_type;
	function segment_to_data(data:segment_type) return segment_data_type;
	function hex_to_lcd(data:hex_character_type) return lcd_character_type;
	function count_to_lcd(data:count_err_type) return lcd_character_type;
	
end eth_lib;	

package body eth_lib is
	function boolean_to_data_x(data:boolean) return std_logic is
	begin 
		if data then return '1';
		else return '0';
		end if;
	end boolean_to_data_x;
	function data_to_boolean_x(data:std_logic) return boolean is
	begin 
		return data='1';																	  
	end data_to_boolean_x;  
	
	function prt_to_data(data:prt_type) return prt_data_type is
		variable q : prt_data_type;
	begin 
		q(35 downto 10):=ext(data.start_adr,26); --26
		q(9 downto 0):=conv_std_logic_vector(data.lenw,10); --10   
		
		return q;
	end prt_to_data;
	function data_to_prt(data:prt_data_type) return prt_type is
		variable q : prt_type;
	begin 
		q.start_adr:=data(buffer_value+10-1 downto 10);
		q.lenw:=conv_integer(data(9 downto 0));
		return	q;
	end data_to_prt;
	
	function packet_to_data(data:packet_type) return packet_data_type is
		variable q : packet_data_type;
	begin 
		q(511 downto 510):=(others=>'0');	
		q(509 downto 478):=ext(data.start_adr,32); --16
		q(477 downto 476):="00";	
		q(475 downto 468):=(others=>'0');	
		q(467 downto 460):=data.ip_tos;	
		q(459 downto 458):=IPprotocol_to_data(data.ip_protocol);	
		q(457 downto 394):=ProteiEthSignature;
		q(393 downto 378):=data.id;	
		q(377 downto 376):=segment_to_data(data.segment);	
		q(375 downto 364):=data.vlanrx;	
		q(363 downto 352):=data.vlantx;	
		q(351 downto 304):=data.mac_source;	
		q(303 downto 256):=data.mac_destination;	
		q(255 downto 224):=data.intime;	--32
		q(223 downto 218):=conv_std_logic_vector(data.outchannel_log,6); --4
		q(217 downto 212):=conv_std_logic_vector(data.inchannel_log,6); --4
		q(211 downto 208):=conv_std_logic_vector(data.inchannel_phy,4); --4
		q(207 downto 176):=data.protei_property; --32
		q(175 downto 144):=data.ip_s;	 --32
		q(143 downto 128):=data.port_s;	--16
		q(127 downto 96):=data.ip_d;   --32
		q(95 downto 80):=data.port_d;  --16
		q(79 downto 74):=(others=>'0');
		q(73 downto 72):=ETHprotocol_to_data(data.eth_protocol);	
		q(71 downto 65):=data.queue(6 downto 0); --8
		q(64 downto 59):=data.dscp(5 downto 0); --6
		q(58 downto 51):=conv_std_logic_vector(data.protei_module,8); --8
		q(50 downto 40):=(others=>'0');
		q(39 downto 32):=conv_std_logic_vector(data.protei_cmd,8); -- 8
		q(31 downto 30):=vlanrxact_to_data(data.vlanrxact);	
		q(29 downto 28):=vlantxact_to_data(data.vlantxact);	
		q(27):=boolean_to_data_x(data.good_packet);
		q(26):=boolean_to_data_x(data.ip_broadcast);
		q(25 downto 22):=conv_std_logic_vector(data.outchannel_phy,4); --4
		q(21 downto 13):=conv_std_logic_vector(data.lenw,9); --9   
		q(12 downto 0):=conv_std_logic_vector(data.len,13); --13   
		
		return q;
	end packet_to_data;
	function data_to_packet(data:packet_data_type) return packet_type is
		variable q : packet_type;
	begin 
		q.start_adr:=data(buffer_value+478-1 downto 478);
		q.ip_tos:=data(467 downto 460);
		q.ip_protocol:=data_to_IPprotocol(data(459 downto 458));
		q.id:=data(393 downto 378);
		q.segment:=data_to_segment(data(377 downto 376));
		q.vlanrx:=data(375 downto 364);
		q.vlantx:=data(363 downto 352);
		q.mac_source:=data(351 downto 304);
		q.mac_destination:=data(303 downto 256);
		q.intime:=data(255 downto 224);
		q.outchannel_log:=conv_integer(data(223 downto 218)); 
		q.inchannel_log:=conv_integer(data(217 downto 212)); 
		q.inchannel_phy:=conv_integer(data(211 downto 208)); 
		q.protei_property:=data(207 downto 176); 
		q.ip_s:=data(175 downto 144);
		q.port_s:=data(143 downto 128);
		q.ip_d:=data(127 downto 96);
		q.port_d:=data(95 downto 80); 
		q.eth_protocol:=data_to_ETHprotocol(data(73 downto 72));
		q.queue:=ext(data(71 downto 65),8); 
		q.dscp:=ext(data(64 downto 59),8); 
		q.protei_module:=conv_integer(data(58 downto 51)); 
		q.protei_cmd:=conv_integer(data(39 downto 32)); 
		q.vlanrxact:=data_to_vlanrxact(data(31 downto 30));
		q.vlantxact:=data_to_vlantxact(data(29 downto 28));
		q.good_packet:=data_to_boolean_x(data(27));
		q.ip_broadcast:=data_to_boolean_x(data(26));
		q.outchannel_phy:=conv_integer(data(25 downto 22)); 
		q.lenw:=conv_integer(data(21 downto 13));
		q.len:=conv_integer(data(12 downto 0));
		return	q;
	end data_to_packet;
---------------------------------	
	function data_to_vlantxact(data:vlantx_datatype) return vlantx_type is
	begin 
		if data="01" then return insert;
		elsif data="10" then return delete;
		else return none; end if;
	end data_to_vlantxact;
	function vlantxact_to_data(data:vlantx_type) return vlantx_datatype is
	begin 
		if data=insert then return "01";
		elsif data=delete then return "10";
		else return "00"; end if;
	end vlantxact_to_data;	
	function data_to_vlanrxact(data:vlanrx_datatype) return vlanrx_type is
	begin 
		if data="01" then return one;
		elsif data="10" then return two;
		else return none; end if;
	end data_to_vlanrxact;
	function vlanrxact_to_data(data:vlanrx_type) return vlanrx_datatype is
	begin 
		if data=one then return "01";
		elsif data=two then return "10";
		else return "00"; end if;
	end vlanrxact_to_data;	
---------------------------------	
	function fild_to_ETHprotocol(data:eth_protocol_fild_type) return eth_protocol_type is
	begin 
		if data=ProteiEthType then return protei;
		elsif data=ipEthType then return ip;
		elsif data=arpEthType then return arp;
		else return unknow; end if;
	end fild_to_ETHprotocol;
	function ETHprotocol_to_fild(data:eth_protocol_type) return eth_protocol_fild_type is
	begin 
		if data=protei then return ProteiEthType;
		elsif data=ip then return ipEthType;
		elsif data=arp then return arpEthType;
		else return x"0000"; end if;
	end ETHprotocol_to_fild;
	function data_to_ETHprotocol(data:eth_protocol_data_type) return eth_protocol_type is
	begin 
		if data="01" then return protei;
		elsif data="10" then return ip;
		elsif data="11" then return arp;
		else return unknow; end if;
	end data_to_ETHprotocol;
	function ETHprotocol_to_data(data:eth_protocol_type) return eth_protocol_data_type is
	begin 
		if data=protei then return "01";
		elsif data=ip then return "10";
		elsif data=arp then return "11";
		else return "00"; end if;
	end ETHprotocol_to_data;	
	
	function fild_to_IPprotocol(data:ip_protocol_fild_type) return ip_protocol_type is
	begin 
		if data=const_IP_UDP then return udp;
		elsif data=const_IP_TCP then return tcp;
		elsif data=const_IP_ICMP then return icmp;
		else return unknow; end if;
	end fild_to_IPprotocol;
	function IPprotocol_to_fild(data:ip_protocol_type) return ip_protocol_fild_type is
	begin 
		if data=udp then return const_IP_UDP;
		elsif data=tcp then return const_IP_TCP;
		elsif data=icmp then return const_IP_ICMP;
		else return x"00"; end if;
	end IPprotocol_to_fild;
	function data_to_IPprotocol(data:ip_protocol_data_type) return ip_protocol_type is
	begin 
		if data="01" then return udp;
		elsif data="10" then return tcp;
		elsif data="11" then return icmp;
		else return unknow; end if;
	end data_to_IPprotocol;
	function IPprotocol_to_data(data:ip_protocol_type) return ip_protocol_data_type is
	begin 
		if data=udp then return "01";
		elsif data=tcp then return "10";
		elsif data=icmp then return "11";
		else return "00"; end if;
	end IPprotocol_to_data;	
	
	function packet_to_IPhash0(init: std_logic_vector(31 downto 0); packet:packet_type) return IPhash1_type is	 
		constant data_value : Integer :=102;
		constant s_poly : std_logic_vector(31 downto 0):=x"04C11DB7";
		variable data: std_logic_vector(data_value-1 downto 0);
		type my_array is array (data_value downto 0) of std_logic_vector(IPhash1_value-1 downto 0);
		variable R 	: my_array;	  
	begin 
		data:=packet.ip_s & packet.ip_d & packet.port_s & packet.port_d & conv_std_logic_vector(packet.inchannel_phy,4) & IPprotocol_to_data(packet.ip_protocol);
		R(0)(IPhash1_value-1 downto 0):= init(IPhash1_value-1 downto 0);
		n: for n in 1 to data_value loop	
			k: for k in 1 to IPhash1_value-1 loop	
				R(n)(k):=R(n-1)(k-1) xor (s_poly(k) and (R(n-1)(IPhash1_value-1) xor data(n-1)));
			end loop k;
			R(n)(0):=s_poly(0) and R(n-1)(IPhash1_value-1);
		end loop n;	
		return R(data_value)(IPhash1_value-1 downto 0);
	end packet_to_IPhash0;	
	
	function IPhash0_to_IPhash1(init: std_logic_vector(31 downto 0); hash0:IPhash1_type) return IPhash1_type is	 
		constant data_value : Integer :=IPhash1_value;
		constant s_poly : std_logic_vector(31 downto 0):=x"377304e9";
		variable data: std_logic_vector(data_value-1 downto 0);
		type my_array is array (data_value downto 0) of std_logic_vector(IPhash1_value-1 downto 0);
		variable R 	: my_array;	  
	begin 
		data:=hash0;
		R(0)(IPhash1_value-1 downto 0):= init(IPhash1_value-1 downto 0); 
		n: for n in 1 to data_value loop	
			k: for k in 1 to IPhash1_value-1 loop	
				R(n)(k):=R(n-1)(k-1) xor (s_poly(k) and (R(n-1)(IPhash1_value-1) xor data(n-1)));
			end loop k;
			R(n)(0):=s_poly(0) and R(n-1)(IPhash1_value-1);
		end loop n;	
		return R(data_value)(IPhash1_value-1 downto 0);
	end IPhash0_to_IPhash1;
	
	function packet_to_IPhash2(packet:packet_type) return IPhash2_type is	 
		constant data_value : Integer :=102;
		constant s_init : std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFFFF";
		constant s_poly : std_logic_vector(63 downto 0):=x"8127043009c04496";
		variable data: std_logic_vector(data_value-1 downto 0);
		type my_array is array (data_value downto 0) of std_logic_vector(IPhash2_value-1 downto 0);
		variable R 	: my_array;	  
	begin 
		data:=packet.ip_s & packet.ip_d & packet.port_s & packet.port_d & Conv_std_logic_vector(packet.inchannel_phy,4) & IPprotocol_to_data(packet.ip_protocol);
		R(0)(IPhash2_value-1 downto 0):=s_init(IPhash2_value-1 downto 0); 
		n: for n in 1 to data_value loop	
			k: for k in 1 to IPhash2_value-1 loop	
				R(n)(k):=R(n-1)(k-1) xor (s_poly(k) and (R(n-1)(IPhash2_value-1) xor data(n-1)));
			end loop k;
			R(n)(0):=s_poly(0) and R(n-1)(IPhash2_value-1);
		end loop n;	
		return R(data_value)(IPhash2_value-1 downto 0);
	end packet_to_IPhash2;
	
	function packet_to_SGhash(packet:packet_type) return SGhash_type is	 
		constant data_value : Integer :=86;
		constant s_init : std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFFFF";
		constant s_poly : std_logic_vector(63 downto 0):=x"ca4eae2102038e61";
		variable data: std_logic_vector(data_value/2-1 downto 0);
		variable dataX: std_logic_vector(data_value-1 downto 0);
		type my_array is array (data_value downto 0) of std_logic_vector(SGhash_value-1 downto 0);
		variable R 	: my_array;	  
	begin 
		dataX:=packet.ip_s & packet.ip_d & conv_std_logic_vector(packet.inchannel_phy,4) & IPprotocol_to_data(packet.ip_protocol) & packet.id;
		data:=dataX(data_value-1 downto data_value/2) xor dataX(data_value/2-1 downto 0) ;
		R(0)(SGhash_value-1 downto 0):=s_init(SGhash_value-1 downto 0); 
		n: for n in 1 to data_value/2 loop	
			k: for k in 1 to SGhash_value-1 loop	
				R(n)(k):=R(n-1)(k-1) xor (s_poly(k) and (R(n-1)(SGhash_value-1) xor data(n-1)));
			end loop k;
			R(n)(0):=s_poly(0) and R(n-1)(SGhash_value-1);
		end loop n;	
		return R(data_value/2)(SGhash_value-1 downto 0);
	end packet_to_SGhash;	
	function data_to_action(data:action_data_type) return action_type is
	begin 
		if data="01" then return send;
		elsif data="11" then return copy;
		elsif data="10" then return move;
		else return drop; end if;
	end data_to_action;
	function action_to_data(data:action_type) return action_data_type is
	begin 
		if data=copy then return "11";
		elsif data=send then return "01";
		elsif data=move then return "10";
		else return "00"; end if;
	end action_to_data;
	function data_to_segment(data:segment_data_type) return segment_type is
	begin 
		if data="01" then return first;
		elsif data="11" then return middle;
		elsif data="10" then return last;
		else return none; end if;
	end data_to_segment;
	function segment_to_data(data:segment_type) return segment_data_type is
	begin 
		if data=first then return "01";
		elsif data=middle then return "11";
		elsif data=last then return "10";
		else return "00"; end if;
	end segment_to_data;
	
	function hex_to_lcd(data:hex_character_type) return lcd_character_type is
	begin  
		if conv_integer(data)<10 then
			return "0011" & data; -- 0-9
		else
			return "0100" & (data-9);  -- a-f
		end if;
	end hex_to_lcd;  
	
	function count_to_lcd(data:count_err_type) return lcd_character_type is
	begin  
		if data>15 then
			return "001" & conv_std_logic_vector(data,1) & "1101"; -- overflow -=
		elsif data<10 then
			return "0011" & conv_std_logic_vector(data,4); -- 0-9
		else
			return "0100" & conv_std_logic_vector((data-9),4);  -- a-f
		end if;
	end count_to_lcd; 
	
	
	
end eth_lib;																


