local BTNode = require("core.bt.BTNode")
local BTAction = class("BTAction", BTNode)

function BTAction:ctor(name, precondition)
	BTNode.ctor(self, name, precondition)
	self._status = BTActionStatus.Ready
end

function BTAction:enter()
	BTLog("On enter action: ", self.name)
end

function BTAction:exit()
	BTLog("On exit action: ", self.name)
end

function BTAction:execute(delta)
	return BTResult.Ended
end

function BTAction:clear()
	if self._status ~=  BTActionStatus.Ready then
		self:exit()
		self._status = BTActionStatus.Ready
	end
end

function BTAction:tick(delta)
	local result = BTResult.Ended
	if self._status == BTActionStatus.Ready then
		self:enter()
		self._status = BTActionStatus.Running
	end
	if self._status == BTActionStatus.Running then
		result = self:execute(delta)
		if result ~= BTResult.Running then
			self:exit()
			self._status = BTActionStatus.Ready
		end
	end
	return result
end

function BTAction:addChild(node)
	BTLog("ERROR: BTAction: Cannot add a node into BTAction..")
end

function BTAction:removeChild(node)
	BTLog("ERROR: BTAction: Cannot remove a node into BTAction.")
end
return BTAction