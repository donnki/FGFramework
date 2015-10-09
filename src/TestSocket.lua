local net = require("framework.cc.net.init")
cc.utils = require("framework.cc.utils.init")
local crypto = require(cc.PACKAGE_NAME .. ".crypto")
require 'person_pb'
local ByteArray = cc.utils.ByteArray
local ByteArrayVarint = cc.utils.ByteArrayVarint

local TestSocket = class("TestSocket" , SceneBase)

TestSocket.__index = TestSocket
TestSocket.name = "TestSocket"
local tmpbox = nil
function TestSocket:ctor()
    self:init()
end
function TestSocket:init(config)
    SceneBase.init(self)

    Log.d("TestSocket初始化临时测试Socket场景")
    local layer = cc.Layer:create()
    layer:setSwallowsTouches(true)
    layer:setTag(1024)
    self:addChild(layer)

    tmpbox = cc.LayerColor:create(cc.c4b(100,100,255,255));
    tmpbox:setContentSize(10,10);
    tmpbox:setPosition(display.cx,display.cy)
    layer:addChild(tmpbox)


    -- local box = cc.LayerColor:create(cc.c4b(100,100,255,255));
    -- box:setContentSize( cc.size(display.width,display.height) );
    -- box:setPosition(0,0)
    -- layer:addChild(box)

    -- local t = ccs.GUIReader:getInstance():widgetFromJsonFile("res/UIs/GameOver_1.ExportJson")
    -- self:addChild(t)

    local menu = cc.Menu:create()
    layer:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Test Connect", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self:ConnectTest()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Test Send Data", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        -- self:SendDataTest()
        local str = "中文"
        print(str:utf8len())
        local _bytes = ByteArray.new(ByteArray.ENDIAN_BIG)
        _bytes:writeShort(0)
            :writeInt(99)
            -- :writeInt(str:utf8len())
            :writeStringUShort(str)

        local person= person_pb.Person()
        person.id = 1000
        person.name = "中文"
        person.email = "Alice@example.com"
        local home = person.Extensions[person_pb.Phone.phones]:add()
        home.num = "2147483647"
        home.type = person_pb.Phone.HOME

        local data = person:SerializeToString()
        _bytes:writeInt(data:len()):writeString(data)
        -- print(ByteArray.new():writeString(data):toString(16))
        print("发送的数据：", _bytes:toString(16))
        self.socket_:send(_bytes:getBytes())
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Close Connect", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self:CloseTest()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("CryptoTest", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        local str = "hellohellohellohellohellohellohellohellohellohello"
        local key = "!@#A#GAa9v"
        local encodeAES256Str = crypto.encryptAES256(str, key)
        print(ByteArray.new():writeString(encodeAES256Str):toString(16)..", "..crypto.decryptAES256(encodeAES256Str, key))
        local encodeBase64Str = crypto.encodeBase64(str)
        print(ByteArray.new():writeString(encodeBase64Str):toString(16)..", "..crypto.decodeBase64(encodeBase64Str))
        local md5Code = crypto.md5(str, true)
        print(ByteArray.new():writeString(md5Code):toString(16))
    end)
    menu:addChild(label)


    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Test Protobuf", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        

        local person= person_pb.Person()
        person.id = 1000
        person.name = "中文"
        person.email = "Alice@example.com"
        local home = person.Extensions[person_pb.Phone.phones]:add()
        home.num = "2147483647"
        home.type = person_pb.Phone.HOME

        local data = person:SerializeToString()
        local _bytes = ByteArray.new(ByteArray.ENDIAN_BIG):writeInt(#data):writeString(data)
        _bytes:setPos(1)
        local _len = _bytes:readInt()
        local _transformBytes = _bytes:readString(_len)
        print(#_transformBytes)


        local msg = person_pb.Person()
        msg:ParseFromString(_transformBytes)
        print(msg.Extensions[person_pb.Phone.phones][1].num)

    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Change Scene", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Engine:changeScene(require("game.scenes.LoadingScene"):createForNext(require("TestScene")))

    end)
    menu:addChild(label)

    menu:alignItemsVertically()

    
    self:initSocket()
    
end

function TestSocket:initSocket()
    local socket = net.SocketTCP.new()
    socket:setName("TestSocketTcp")
    socket:setTickTime(1)
    socket:setReconnTime(6)
    socket:setConnFailTime(4)

    socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.tcpData))
    socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
    socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
    socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
    socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.tcpConnectedFail))

    self.socket_ = socket
end


function TestSocket:ConnectTest()
    -- self.socket_:connect("127.0.0.1", 8080, true)
    -- self.socket_:connect("192.168.31.116", 11111, true)
    self.socket_:connect("192.168.31.136", 9123, true)
end

function TestSocket:onEnter()
end
function TestSocket:SendDataTest()
    -- print("SendDataTest")
    local msg = "ABC"
    local _bytes = ByteArray.new(ByteArray.ENDIAN_BIG):writeStringUShort(msg)
    -- print(#_bytes:getBytes())
    -- print(_bytes:toString(16))
    -- self.socket_:send(_bytes:getBytes())

    _bytes = ByteArray.new(ByteArray.ENDIAN_BIG)
    _bytes:writeUInt(0xffffffff)
    local header = {0, 0, 0, 32, 16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 8, 1, 2, 4}
    local body = {127, -128, 127, -128}
    local attachment = {1, -1, 1, -1}

    _bytes:writeInt(#header + 4 + #body + 4 + #attachment + 4)
    for i,v in ipairs(header) do
        _bytes:writeUByte(v)
    end
    _bytes:writeInt(#body + 4)

    for i,v in ipairs(body) do
        _bytes:writeUByte(v)
    end
    for i,v in ipairs(attachment) do
        _bytes:writeUByte(v)
    end
    print(_bytes:toString(16))
    self.socket_:send(_bytes:getBytes())
end

function TestSocket:CloseTest()
    if self.socket_.isConnected then
        self.socket_:close()
    end
end

function TestSocket:tcpData(event)
    -- print("SocketTCP receive data:" .. #event.data)
    -- for k,v in pairs(event) do
        -- print(k,v)
    -- end
    local _bytes = ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(event.data)
    print("接收的数据：",_bytes:toString(16))
    _bytes:setPos(1)
    
    -- print(#_transformBytes)

    local _type = _bytes:readShort()
    local _command = _bytes:readInt()
     
    local _params = _bytes:readStringUShort() --_bytes:readString(_paramLength)
    local _personLength = _bytes:readInt()
    print(_type, _command, _params,_personLength)
    local _personData = _bytes:readString(_personLength)

    local msg = person_pb.Person()
    msg:ParseFromString(_personData)
    print(msg.email)
    print(msg.Extensions[person_pb.Phone.phones][1].num)
end

function TestSocket:tcpClose()
    print("SocketTCP close")
end

function TestSocket:tcpClosed()
    print("SocketTCP closed")
end

function TestSocket:tcpConnected()
    print("SocketTCP connect success")
end

function TestSocket:tcpConnectedFail()
    print("SocketTCP connect fail")
end

function TestSocket:onExit()
    if self.socket_.isConnected then
        self.socket_:close()
        self.socket_:disconnect()
    end
    
end


-- local t = 0
-- function TestSocket:update(delta)
--     -- Log.i(delta)
--     t = t + delta*2
--     if t > 2 * math.pi then
--         t = 0 
--     end
--     local x, y = tmpbox:getPosition()
--     x = 150 * math.cos(t)
--     y = 150 * math.sin(t)
--     tmpbox:setPosition(display.cx + x, display.cy + y)
-- end

function TestSocket:test()
end



function TestSocket.createWithData(data)
    local scene = TestSocket.new()
    scene:init(data)
    return scene
end
function TestSocket.create(config)
    local scene = TestSocket.new()
    scene:init(config)
    return scene
end
return TestSocket
