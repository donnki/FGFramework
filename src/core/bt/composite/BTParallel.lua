local BTParallel = class("BTParallel", BTNode)

----------------------
-- BTParallel evaluates all children, if any of them fails the evaluation, BTParallel fails.
-- 
-- BTParallel ticks all children, if flag
-- 	false: 	ends when all children ends
-- 	 true: 	ends when any of the children ends
-- 
-- NOTE: Order of child node added does matter!
function BTParallel:ctor(name, precondition, properties)
	BTNode.ctor(self, name, precondition, properties)
	self.shouldEndWhenOneEnd = properties.shouldEndWhenOneEnd
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

function BTParallel:tick(delta)
	self:debugSetHighlight(true)
	local endingResultCount = 0
	for i,v in ipairs(self.children) do
		if self._results[i] == BTResult.Running then
			self._results[i] = self.children[i]:tick(delta)
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
	self:debugDrawLineTo(self.children)
	return BTResult.Running
end

function BTParallel:clear()
	self:resetResults()
	for k,v in ipairs(self.children) do
		v:clear()
	end
	self:debugSetHighlight(false)
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
