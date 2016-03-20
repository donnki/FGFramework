local BTParallelFlexible = class("BTParallelFlexible", BTNode)

------------------
-- BTParallelFlexible evaluates all children, if all children fails evaluation, it fails. 
-- Any child passes the evaluation will be regarded as active.
-- 
-- BTParallelFlexible ticks all active children, if all children ends, it ends.
-- 
-- NOTE: Order of child node added does matter!
function BTParallelFlexible:ctor(name, precondition, properties)
	BTNode.ctor(self, name, precondition, properties)
	
	self._activeList = {}
end

function BTParallelFlexible:doEvaluate()
	local numActiveChildren = 0
	for i,child in ipairs(self.children) do
		if child:evaluate() then
			self._activeList[i] = true
			numActiveChildren = numActiveChildren + 1
		else
			self._activeList[i] = false
		end
	end
	if numActiveChildren == 0 then
		return false
	end
	return true
end

function BTParallelFlexible:tick(delta)
	self:debugSetHighlight(true)
	local numActiveChildren = 0
	for i,child in ipairs(self.children) do
		local active = self._activeList[i]
		if active then
			local result = child:tick(delta)
			if result == BTResult.Running then
				numActiveChildren = numActiveChildren + 1
			end
		end
	end
	if numActiveChildren == 0 then
		return BTResult.Ended
	end
	self:debugDrawLineTo(self.children)
	return BTResult.Running
end

function BTParallelFlexible:clear()
	for k,v in ipairs(self.children) do
		v:clear()
	end
	self:debugSetHighlight(false)
end

function BTParallelFlexible:addChild(node)
	BTNode.addChild(self, node)
	table.insert(self._activeList, false)
end

function BTParallelFlexible:removeChild(node)
	local index = BTNode.removeChild(self, node)
	table.remove(self._activeList, index)
end

return BTParallelFlexible
