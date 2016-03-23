local BTWaitAction = class("BTWaitAction", BTAction)

function BTWaitAction:enter()
	BTAction.enter(self)
	self._duration = 0
	self._endTime = self.database:getValue(self.properties.key)
end

function BTWaitAction:exit()
	BTAction.exit(self)
	-- print(self.properties.key, " wait time: ", self._duration)
end

function BTWaitAction:execute(delta)
	self._duration = self._duration + delta
	local result = self._duration < self._endTime and BTResult.Running or BTResult.Ended
	return result
		
end
return BTWaitAction