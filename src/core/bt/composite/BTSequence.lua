local BTSequence = class("BTSequence", BTNode)

-----------------
-- BTSequence evaluteas the current active child, or the first child (if no active child).
-- 
-- If passed the evaluation, BTSequence ticks the current active child, or the first child (if no active child available),
-- and if it's result is BTEnded, then change the active child to the next one.
function BTSequence:ctor(name, precondition)
	BTNode.ctor(self, name, precondition)
	self._activeIndex = 0
	self._activeChild = nil
end

function BTSequence:doEvaluate()
	if self._activeChild then
		local result = self._activeChild:evaluate()

		if not result then
			self._activeChild:clear()
			self._activeChild = nil
			self._activeIndex = 0
		end
		return result
	else
		return self.children[1]:evaluate()
	end
end

function BTSequence:tick(delta)
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
end
return BTSequence