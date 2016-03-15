local BTNode = class("BTNode")

function BTNode:ctor(name, precondition)
	self.name = name
	self.precondition = precondition
	self.children = {}
	self.interval = 0
	self.lastTimeEvaluated = 0
	self.activated = false
	self.database = nil
end

function BTNode:activate(database)
	if self.activated then
		return
	end
	self.database = database
	if self.precondition then
		self.precondition:activate(database)
	end
	-- print("~~", self.__cname, #self.children)
	if #self.children > 0 then
		for k,child in ipairs(self.children) do

			child:activate(database)
		end
	end
	self.activated = true
end

function BTNode:doEvaluate()
	return true
end

function BTNode:evaluate()
	local coolDownOK = self:_checkTimer()
	return self.activated and coolDownOK and 
		(self.precondition == nil or self.precondition:check()) and self:doEvaluate()
end

function BTNode:tick(delta)
	return BTResult.Ended
end

function BTNode:clear()
end

function BTNode:addChild(node)
	if node then
		table.insert(self.children, node)
	end
end

function BTNode:removeChild(node)
	if node then
		for k,v in ipairs(self.children) do
			if v == node then
				table.remove(self.children, k)
				return v
			end
		end
	end
end

function BTNode:_checkTimer()
	return true
end
return BTNode