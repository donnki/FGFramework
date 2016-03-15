local BTNode = require("core.bt.BTNode")
local BTPrioritySelector = class("BTPrioritySelector", BTNode)

function BTPrioritySelector:ctor(name)
	BTNode.ctor(self, name)
	self._activeChild = nil
end

function BTPrioritySelector:doEvaluate()
	for k,v in ipairs(self.children) do
		if v:evaluate() then
			if self._activeChild ~= nil and self._activeChild ~= v then
				self._activeChild:clear()
			end
			self._activeChild = v

			return true
		end
	end
	
	if self._activeChild then
		self._activeChild:clear()
		self._activeChild = nil
	end
	return false
end

function BTPrioritySelector:clear()
	if self._activeChild then
		self._activeChild:clear()
		self._activeChild = nil
	end
end

function BTPrioritySelector:tick(delta)
	if not self._activeChild then
		return BTResult.Ended
	end
	local result = self._activeChild:tick(delta)
	if result ~= BTResult.Running then
		self._activeChild:clear()
		self._activeChild = nil
	end
	return result
end

return BTPrioritySelector