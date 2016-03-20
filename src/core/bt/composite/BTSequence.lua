local BTSequence = class("BTSequence", BTNode)

-----------------
-- BTSequence evaluteas the current active child, or the first child (if no active child).
-- 
-- If passed the evaluation, BTSequence ticks the current active child, or the first child (if no active child available),
-- and if it's result is BTEnded, then change the active child to the next one.
function BTSequence:ctor(name, precondition, properties)
	BTNode.ctor(self, name, precondition, properties)
	self._activeIndex = 0
	self._activeChild = nil
end

function BTSequence:doEvaluate()
	local ret = false
	if self._activeChild then
		ret = self._activeChild:evaluate()

		if not ret then
			self._activeChild:clear()
			self._activeChild = nil
			self._activeIndex = 0
		end
	else
		ret = self.children[1]:evaluate()
	end
	return ret
end

function BTSequence:tick(delta)
	self:debugSetHighlight(true)
	if self._activeChild == nil then
		self._activeIndex = 1
		self._activeChild = self.children[1]
	end
	local result = self._activeChild:tick(delta)
	if result == BTResult.Ended then
		self._activeIndex = self._activeIndex + 1
		if self._activeIndex > #self.children then
			self._activeChild:clear()
			self._activeChild = nil
			self._activeIndex = 0
		else
			self._activeChild:clear()
			self._activeChild = self.children[self._activeIndex]
			result = BTResult.Running
		end
	end
	self:debugDrawLineTo(self.children, self._activeIndex)
	return result
end

function BTSequence:clear()
	if self._activeChild then
		self._activeChild = nil
		self._activeIndex = 0
	end

	for k,v in ipairs(self.children) do
		v:clear()
	end
	self:debugSetHighlight(false)
end
return BTSequence