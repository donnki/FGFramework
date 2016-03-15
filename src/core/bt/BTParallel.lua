local BTNode = require("core.bt.BTNode")
local BTParallel = class("BTParallel", BTNode)

----------------------
-- BTParallel evaluates all children, if any of them fails the evaluation, BTParallel fails.
-- 
-- BTParallel ticks all children, if 
-- 	1. ParallelFunction.And: 	ends when all children ends
-- 	2. ParallelFunction.Or: 	ends when any of the children ends
-- 
-- NOTE: Order of child node added does matter!
function BTParallel:ctor(name, precondition, isEndWhenOneEnd)
	BTNode.ctor(self, name, precondition)
	self.shouldEndWhenOneEnd = isEndWhenOneEnd
	self._results = {}
end

function BTParallel:doEvaluate()
	for k,v in ipairs(self.children) do
		if not v:evaluate() then
			return false
		end
	end
	return true
end

function BTParallel:tick()
	local endingResultCount = 0
	for i,v in ipairs(self.children) do
		if self._results[i] == BTResult.Running then
			self._results[i] = self.children[i]:tick()
		end
		if self.shouldEndWhenOneEnd then
			if self._results[i] ~= BTResult.Running then
				self:resetResults()
				return BTResult.Ended
			end
		else
			if self._results[i] ~= BTResult.Running then
				endingResultCount = endingResultCount + 1
			end
		end
	end
	if endingResultCount == #self.children then
		self:resetResults()
		return BTResult.Ended
	end
	return BTResult.Running
end

function BTParallel:clear()
	self:resetResults()
	for k,v in ipairs(self.children) do
		v:clear()
	end
end

function BTParallel:addChild(node)
	BTNode.addChild(self, node)
	table.insert(self._results, BTResult.Running)
end

function BTParallel:removeChild(node)
	local index = BTNode.removeChild(self, node)
	table.remove(self._results, index)
end

function BTParallel:resetResults()
	for i,v in ipairs(self._results) do
		self._results[i] = BTResult.Running
	end
end
return BTParallel
