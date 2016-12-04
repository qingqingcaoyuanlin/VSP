--[[
--复制模板	
= {
	Proto_name = "",
	Protocol = Proto ("VSxxxx","Protocol for xxxx","Protocol for xxxx"),
	Port = 
}


--]]


-------------------------生产协议------------------------------------------
Produce = {
	Proto_name = "-Produce",
	Protocol = Proto ("VSProduce","Protocol for Produce","Protocol for Produce"),
	Port = 10000
}

local f_produce_cid = ProtoField.uint32("produce_cid","id号 ",base.DEC)
--出现参数1错误，不能直接使用cmd，估计是在UDP协议中已经使用了
local f_produce_cmd = ProtoField.uint8("produce_cmd","测试命令 ",base.DEC,
{
	[0] = "TEST_CONNECT",				   	--进入/退出生产测试指令
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
    [25] = "TEST_SET_COMMON_TIMEOUT",		--设置指令超时时间
	})
local f_produce_len = ProtoField.uint16("produce_len","命令长度",base.DEC)
local f_produce_code = ProtoField.string("produce_Code","客户编号")
Produce.Protocol.fields = {f_produce_cid, f_produce_cmd, f_produce_len, f_produce_code}


function Produce.Protocol.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol:append(Produce.Proto_name)
    pinfo.cols.info:append(" VSP-Produce")

	local buffer_len = buffer:len()
	local VSPTree = tree:add(Produce.Protocol, buffer(0, buffer_len), "Produce Protocol")

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

-------------------------Talkback协议----------------------------------------
Talkback = {
	Communication = {
		Proto_name = "-Communication",
		Protocol = Proto ("VSCommunication","Protocol for Talkback-Communication","Protocol for GVS Talkback-Communication"),
		Port = 8300
	},
	Audio = {
		Proto_name = "-Audio",
		Protocol = Proto ("VSAudio","Protocol for Talkback-Audio","Protocol for GVS Talkback-Audio"),
		Port = 8302
	},
	Video = {
		Proto_name = "-Video",
		Protocol = Proto ("VSVideo","Protocol for Talkback-Video","Protocol for GVS Talkback-Video"),
		Port = 8303
	},
	File = {
		Proto_name = "-File",
		Protocol = Proto ("VSFile","Protocol for Talkback-File","Protocol for GVS Talkback-File"),
		Port = 8304
	},
	
}
COM = {
	[0x0301] =  "呼叫指令",
	[0x0302] =  "挂机指令",
	[0x0303] =  "摘机指令",
	[0x0304] =  "监视请求指令",
	[0x0307] =  "户内寻呼(广播)",
	[0x0308] =  "呼叫转移指令",
	[0x0309] =  "留言同步指令",
	[0x0310] =  "通话记录上报",
	[0x0311] =  "抓拍图片上传指令",
	[0x0381] =  "呼叫应答指令", 
	[0x0382] =  "挂机应答指令",
	[0x0383] =  "摘机应答指令",
	[0x0384] =  "监视应答指令",
	[0x0388] =  "呼叫转移应答指令",
	[0x0389] =  "留言同步应答指令",
	[0x0390] =  "通话记录应答",
	[0x0391] =  "抓拍图像上传应答指令",
	[0x0350] =  "正忙",
	[0x0351] =  "握手请求指令",
	[0x0352] =  "握手应答指令",
	[0x0353] =  "户内广播请求指令",
	[0x0354] =  "户内广播应答指令",
	[0x0355] =  "请求发送视频",
	[0x0356] =  "倒计时同步请求",
	[0x0357] =  "倒计时同步请求应答",
	[0x0358] =  "呼叫拦截状态请求指令",
	[0x0359] =  "呼叫拦截状态应答指令",
	[0x035a] =  "呼叫拦截状态下的呼叫指令",
	[0x035b] =  "呼叫拦截状态下的呼叫应答指令",
	[0x035c] =  "呼叫挂起请求",
	[0x035d] =  "呼叫挂起应答",
	[0x035e] =  "呼叫恢复请求",
	[0x035f] =  "呼叫恢复应答",
	[0x0360] =  "一键转呼指令",
	[0x0361] =  "一键转呼应答指令",

}
--设备类型
DevType = {
	[0x00] = "未知设备",
	[0x01] = "测试板",
	[0x11] = "管理机",
	[0x12] = "管理机",
	[0x13] = "围墙机",
	[0x14] = "联网刷卡头",
	[0x15] = "IP摄像头",
	[0x31] = "单元管理机",
	[0x32] = "门口机",
	[0x34] = "单元刷卡头",
	[0x35] = "电梯联动模块",
	[0x61] = "室内机",
	[0x62] = "小门口机",
}
--组播类型
MulticastIPType = {
	[0x01] = "系统公共组播",   --系统功能保留的公共组播地址IP 根据功能进行分配
	[0x02] = "单元公共组播",    --单元内保留的公共组播地址IP  根据功能进行分配
	[0x03] = "每户组播",    --为每户分配的组播IP
}
--第28位功能码
FunCode = {
	[0x01] = "生产指令",
	[0x02] = "系统配置指令",
	[0x03] = "呼叫对讲指令",
	[0x04] = "门禁指令",
	[0x05] = "防区指令",
	[0x6] = "信息指令",
	[0x7] = "应用指令",
	[0x8] = "电梯指令",
	[0x10] = "户内指令",
	[0x0a] = "监控Camera指令",
	[0x20] = "文件传输指令",
}

-------------------------Talkback通信协议----------------------------------------

function Talkback.Communication.Protocol.dissector(buffer,pinfo,tree)


end
-------------------------Talkback音频协议----------------------------------------
function Talkback.Audio.Protocol.dissector(buffer,pinfo,tree)


end
-------------------------Talkback视频协议----------------------------------------
function Talkback.Video.Protocol.dissector(buffer,pinfo,tree)


end
-------------------------Talkback文件协议----------------------------------------
function Talkback.File.Protocol.dissector(buffer,pinfo,tree)


end




-------------------------以下添加端口和协议-----------------------------------
local udp_port_table = DissectorTable.get("udp.port")
udp_port_table:add(Produce.Port, Produce.Protocol)
udp_port_table:add(Talkback.Communication.Port, Talkback.Communication.Protocol)
udp_port_table:add(Talkback.Audio.Port, Talkback.Audio.Protocol)
udp_port_table:add(Talkback.Video.Port, Talkback.Video.Protocol)
udp_port_table:add(Talkback.File.Port, Talkback.File.Protocol)

