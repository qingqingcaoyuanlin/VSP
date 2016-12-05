# VSP
用于wireshark里面来解析UDP的数据包
使用方法：
1.安装最新版wireshark（Lua功能默认打开），修改wireshark安装路径C:\Program Files\Wireshark下的init.lua，添加
dofile(DATA_DIR.."VSP.lua")--将VSP.lua放在默认安装路径下，或者
dofile("C:/Program Files/Wireshark/VSP.lua")--指定路径，注意路径跟windows默认的不同，
建议使用绝对路径方式（方式二）
2.根据协议修改各项功能


