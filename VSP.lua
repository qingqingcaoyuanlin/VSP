vs_proto = Proto ("VSP","Protocol for Video-Star","Protocol for Video-Star Building Intercom Sysytem")
local f_produce_cid = ProtoField.uint32("produce_cid","id号 ",base.DEC)
local f_produce_cmd = ProtoField.uint8("produce_cmd","测试命令 ",base.DEC,{[0] = "TEST_CONNECT",				   	--进入/退出生产测试指令
	[1] = "TEST_CONNECT_R",		       	--进入/退出生产测试应答指令
	[2] = "TEST_HW_VERSION",			   	--PCB硬件版本配置指令
	[3] = "TEST_HW_VERSION_R",           	--PCB硬件版本配置应答指令
	[4] = "TEST_MAC_CONFIG",			   	--MAC配置指令
	[5] = "TEST_MAC_CONFIG_R",		   	--MAC配置应答指令
	[6] = "TEST_MAC_READ",				--MAC读取指令
	[7] = "TEST_MAC_READ_R",				--MAC读取应答指令
	[8] = "TEST_PCB_VERSION",				--PCB版本读取指令
	[9] = "TEST_PCB_VERSION_R",			--PCB版本读取应答指令
	[10] = "TEST_PCB_RESET",				--PCB恢复默认设置
	[11] = "TEST_PCB_RESET_R",			--PCB恢复默认设置应答指令
	[12] = "TEST_PCB_REBOOT",				--PCB重启指令
	[13] = "TEST_PCB_REBOOT_R",			--PCB重启应答指令
	[14] = "TEST_CONTROL",				--测试指令
	[15] = "TEST_CONTROL_R",				--测试应答指令
	[16] = "TEST_HAND",					--握手指令
	[17] = "TEST_PRE_CONFIG",				--预配置指令
	[18] = "TEST_PRE_CONFIG_R",			--预配置应答指令
	[19] = "TEST_DEV_SEARCH",				--设备搜索指令	
	[20] = "TEST_DEV_SEARCH_R",			--设备搜索应答指令	
	[21] = "TEST_CUSTOM_INFO",            --请求自定义指令
    [22] = "TEST_CUSTOM_INFO_R",          --请求自定义指令应答
    [23] = "TEST_CUSTOM_COMMON",          --执行自定义指令
    [24] = "TEST_CUSTOM_REPLY",           --执行自定义指令应答
    [25] = "TEST_SET_COMMON_TIMEOUT",		--设置指令超时时间ca
	})
local f_produce_len = ProtoField.uint16("produce_len","命令长度",base.DEC)
local f_produce_code = ProtoField.string("produce_Code","客户编号")
vs_proto.fields = {f_produce_cid, f_produce_cmd, f_produce_len, f_produce_code}
--vs_proto.fields = {f_produce_cid, f_produce_len, f_produce_code}

function vs_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol:append("-VSP")
    pinfo.cols.info:append(" This is a message of VSP")

	local buffer_len = buffer:len()
	local VSPTree = tree:add(vs_proto, buffer(0, buffer_len), "Video-Star Protocol")

	local offset = 0

	local produce_cid = buffer(offset,4):le_uint()   
	VSPTree:add_le(f_produce_cid, buffer(offset,4))	
    offset = offset + 4
	
	local produce_cmd = buffer(offset,1):le_uint()
	VSPTree:add_le(f_produce_cmd, buffer(offset,1))	
	offset = offset + 1
		
	VSPTree:add_le(f_produce_len, buffer(offset,2))
	offset = offset + 2
	
	VSPTree:add(f_produce_code, buffer(offset,buffer_len - offset))
	
    return
end

local udp_port_table = DissectorTable.get("udp.port")
local port_produce = 10000
udp_port_table:add(port_produce, vs_proto)