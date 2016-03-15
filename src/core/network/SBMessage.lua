local SBMessage = class("SBMessage")
local ByteArray = cc.utils.ByteArray

function SBMessage:ctor(packetId)
	self.packetId = packetId
	self._buf = ByteArray.new(ByteArray.ENDIAN_BIG)
end

function SBMessage:parse(data)
	local dataBuf = ByteArray.new(ByteArray.ENDIAN_BIG)
		:writeStringBytes(data)
		:setPos(1)
	local packetLength = dataBuf:readShort()
	local packetId = dataBuf:readShort()
	local message = SBMessage.new(packetId)

	message.readonly = true
	message._buf:writeStringBytes(dataBuf:readStringBytes(packetLength)):setPos(1)
	return message
end

function SBMessage:getByteArray()
	local tmp = ByteArray.new(ByteArray.ENDIAN_BIG)
	tmp:writeShort(self._buf:getLen())
		:writeShort(self.packetId)
		:writeBytes(self._buf)
	
	return tmp
	
end

function SBMessage:encryptMessage(msg, key)
	local base64Text = crypto.encodeBase64(msg:getContentBytes())

	--local encodeBase64Text = native.tripleDES(base64Text,key,true, true)
	--local finalEncodeData = crypto.decodeBase64(encodeBase64Text)
	--print("obj-c:===============\n", ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(finalEncodeData):toString(16))
	if not des3 then
		des3 = require("common.des3")
	end
	
	local encodeBase64Text = des3.enBase64(key, base64Text)
	local finalEncodeData = crypto.decodeBase64(encodeBase64Text)
	-- print("cpp:===============\n", ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(final_2):toString(16))

	local encryptMsg = SBMessage.new(msg.packetId)
	local content = ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(finalEncodeData)
	encryptMsg._buf:writeBytes(content)
	-- print(encryptMsg:getByteArray():toString(16))
	return encryptMsg
end

function SBMessage:decryptMessage(msg, key)
	local base64Text = crypto.encodeBase64(msg:getContentBytes())

	-- local encodeBase64Text = native.tripleDES(base64Text,key,false, true)
	-- local finalDecodeData = crypto.decodeBase64(encodeBase64Text)
	-- print("obj-c:===============\n", ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(finalDecodeData):toString(16))
	if not des3 then
		des3 = require("common.des3")
	end
	local encodeBase64Text = des3.deBase64(key, base64Text)
	local finalDecodeData = crypto.decodeBase64(encodeBase64Text)
	-- print("obj-c:===============\n", ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(final_2):toString(16))

	local decryptMsg = SBMessage.new(msg.packetId)
	local content = ByteArray.new(ByteArray.ENDIAN_BIG):writeStringBytes(finalDecodeData)
	decryptMsg._buf:writeBytes(content)
	decryptMsg._buf:setPos(1)
	-- print(decryptMsg:getByteArray():toString(16))
	return decryptMsg
end

function SBMessage:dumpHex()
	print(self._buf:toString(16))
end

function SBMessage:getContentBytes()
	return self._buf:getBytes()
end
function SBMessage:getBytes()
	return self:getByteArray():getBytes()
end

function SBMessage:getLen()
	return self:getByteArray():getLen()
end

function SBMessage:writeString(str)
	if self.readonly then
		Log.w("正在写只读消息！")
	end
	self._buf:writeStringUShort(str)
	return self
end

function SBMessage:writeByte(b)
	self._buf:writeByte(b)
	return self
end

function SBMessage:writeLong(l)
	self._buf:writeLong(l)
	return self
end


function SBMessage:writeBool(b)
	 self._buf:writeBool(b)
	 return self
end

function SBMessage:readRemain()
	return self._buf:getBytes(self._buf:getPos())
end

function SBMessage:readString()
	return self._buf:readStringUShort()
end

function SBMessage:readByte()
	return self._buf:readByte()
end

function SBMessage:readLong()
	return self._buf:readLong()
end

function SBMessage:readInt()
	return self._buf:readInt()
end

function SBMessage:readBool()
	return self._buf:readBool()
end

function SBMessage:writeDouble(d)
	self._buf:writeDouble(d)
	return self
end

function SBMessage:writeInt(d)
	self._buf:writeInt(d)
	return self
end

function SBMessage:readDouble()
	return self._buf:readDouble()
end



function SBMessage:writeLongLong(longNum)
	local function int_to_bytes(num,endian,signed)
	    local res={}
	    local n = math.ceil(select(2,math.frexp(num))/8) -- number of bytes to be used.
	    if signed and num < 0 then
	        num = num + 2^n
	    end
	    for k=n,1,-1 do -- 256 = 2^8 bits per char.
	        local mul=2^(8*(k-1))
	        res[k]=math.floor(num/mul)
	        num=num-res[k]*mul
	    end
	    -- assert(num==0)
	    -- if endian == ByteArray.ENDIAN_BIG then
	    --     local t={}
	    --     for k=1,n do
	    --         t[k]=res[n-k+1]
	    --     end
	    --     res=t
	    -- end
	    return res
	end
	
	local b = int_to_bytes(longNum, ByteArray.ENDIAN_BIG)
	-- print("~~~~", #b)
	for i=8,1,-1 do
		-- print(string.format("%02X", b[i]))
		if b[i] == nil then
			self:writeByte(0)
		else
			self:writeByte(b[i])
		end
	end
	return self
end

return SBMessage