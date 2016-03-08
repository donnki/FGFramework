local WarnningTipView = class("WarnningTipView", function ( ... )
	return cc.Node:create()
end)
local instance
local FADE_OUT_TIME = 2.0
function WarnningTipView:ctor(_pos)
	self:setNodeEventEnabled(true)
	if not _pos then
		self:setPosition(display.cx,display.height*0.75)
	end
	self.messageList = {}
end

function WarnningTipView:onEnter()
end
function WarnningTipView:onExit()
	instance = nil
end
function WarnningTipView:getInstance()
	if not instance then
		instance = self.new()
		Engine.scene:addChild(instance, 99998)
	end
	return instance
end
function WarnningTipView:addMessage(_str)
	local _newLabel = ccui.Text:create()
	_newLabel:setColor(cc.c3b(255,0,0))
	_newLabel:setFontSize(26)
	_newLabel:setString(_str)
	_newLabel:runAction(cc.Sequence:create(cc.FadeOut:create(FADE_OUT_TIME),cc.CallFunc:create(function ( ... )
		self:removeMessage(_newLabel)
	end)))
	local _index = 1
 	for i=1,#self.messageList do
 		self.messageList[_index]:setPosition(self.messageList[_index]:getPositionX(),self.messageList[_index]:getPositionY()+30)
 		-- if self.messageList[_index]:getPositionY() > 60 then
 		-- 	self:removeMessage(self.messageList[_index])
 		-- 	_index = _index - 1
 		-- end
 		_index = _index + 1
 	end
 	self:addChild(_newLabel)
	table.insert(self.messageList,_newLabel)	
end
function WarnningTipView:removeMessage(_newLabel)
	if _newLabel then
		_newLabel:removeFromParent()
		table.remove(self.messageList,1)
		_newLabel = nil
	end
end
return WarnningTipView