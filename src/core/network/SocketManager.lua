local SocketManager = class("SocketManager")

local ByteArray = cc.utils.ByteArray
local ByteArrayVarint = cc.utils.ByteArrayVarint
local SBMessage = require("core.network.SBMessage")
local instance = nil
SocketManager.__index = SocketManager

function SocketManager:getInstance()
    if instance == nil then
    	instance  = SocketManager.new()
        instance:init()
    end
    return instance
end

function SocketManager:init()
    Log.d("SocketManager初始化网络管理器")
    local socket = net.SocketTCP.new()
    socket:setName("TestServerConnectionTcp")
    socket:setTickTime(1)
    socket:setReconnTime(6)
    socket:setConnFailTime(4)

    socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.tcpData))
    socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
    socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
    socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
    socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.tcpConnectedFail))

    self.socket = socket
    self.tbCallback = {}
end

function SocketManager:connect(server, port)
	Log.i("连接服务器:",server, "端口:",port)
    self.socket:connect(server, port, true)
end

function SocketManager:disconnect()
	if self.socket.isConnected then
        self.socket:close()
        self.socket:disconnect()
    end
end

function SocketManager:tcpData(event)
    local msg = SBMessage:parse(event.data)
    Log.d("接收协议<<<<<", msg.packetId, "，字节数：",#event.data)
    if self.tbCallback[msg.packetId] then
    	self.tbCallback[msg.packetId].callback(msg)
    	if self.tbCallback[msg.packetId].shouldRemove then
    		Log.d("移除对协议号"..msg.packetId.." 的监听")
    		self.tbCallback[msg.packetId] = nil
    	end
    else
    	Log.w("协议"..msg.packetId.."的响应未注册，将忽略此协议")
    end
end

function SocketManager:tcpClose()
    Log.d("SocketTCP close")
end

function SocketManager:tcpClosed()
    Log.d("SocketTCP closed")
end

function SocketManager:tcpConnected()
    Log.i("Socket连接成功，开始握手")
    
    local msg = SBMessage.new(0):writeString(native.getUDID())
    self:send(msg, function(responseMsg)
        responseMsg:readByte()
        local serverTime = responseMsg:readLong()
        Time.offset = os.time() - serverTime/1000
        Log.d("握手协议完成，获取到服务端系统时间：", os.date("%c",serverTime/1000))
        Engine:getEventManager():fire("NetworkShakeHandSuccess")
    end, true)
    
end

function SocketManager:tcpConnectedFail()
    Log.d("SocketTCP connect fail")
end


--------------------------------
-- 发送一个协议消息
-- @function [parent=#SocketManager] send
-- @param SBMessage 消息
-- @param callback 服务端响应该消息时的回调监听函数，可以为空
-- @param bool 是否响应完毕后除该回调监听函数 

-- end --
function SocketManager:send(msg, responseCallback, shouldRemove)
    Log.d("发送协议>>>>>",msg.packetId,"，字节数：", msg:getLen())
    if responseCallback then
    	self:register(msg.packetId, responseCallback, shouldRemove)
    end
    self.socket:send(msg:getBytes())
end

--------------------------------
-- 发送一个协议消息
-- @function [parent=#SocketManager] register
-- @param short 消息ID
-- @param callback 服务端响应该消息时的回调监听函数
-- @param bool 是否响应完毕后除该回调监听函数 

-- end --
function SocketManager:register(msgID, callback, shouldRemove)
	if self.tbCallback[msgID] then
		Log.w("协议"..msgID.."的回调已注册，将覆盖此回调")
	end
	self.tbCallback[msgID] = {callback=callback, shouldRemove=shouldRemove}
    
end

return SocketManager