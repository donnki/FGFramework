local BTPrioritySelector = class("BTPrioritySelector", BTNode)

-----------------
-- BTPrioritySelector selects the first sussessfully evaluated child as the active child.
function BTPrioritySelector:ctor(name, precondition, properties)
	BTNode.ctor(self, name,  precondition, properties)
	self._activeChild = nil
end

function BTPrioritySelector:doEvaluate()
	self:debugClearDrawNode()
	for k,v in ipairs(self.children) do
		if v:evaluate() then
			if self._activeChild ~= nil and self._activeChild ~= v then
				self._activeChild:clear()
			end
			self._activeChild = v

			self:debugSetHighlight(true)
			self:debugDrawLineTo({v})
			return true
		end
	end

	if self._activeChild then
		self._activeChild:clear()
		self._activeChild = nil
	end
	self:debugSetHighlight(false)
	return false
end

function BTPrioritySelector:clear()
	if self._activeChild then
		self._activeChild:clear()
		self._activeChild = nil
	end
	self:debugSetHighlight(false)
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