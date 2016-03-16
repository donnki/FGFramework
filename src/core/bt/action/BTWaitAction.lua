local BTWaitAction = class("BTWaitAction", BTAction)

function BTWaitAction:ctor(name, precondition)
	BTAction.ctor(self, name, precondition)
	
end

function BTWaitAction:enter()
	BTAction.enter(self)
	self._duration = 0
	self._endTime = self.database:getInterval(self.name)
end

function BTWaitAction:exit()
	BTAction.exit(self)
end

function BTWaitAction:execute(delta)
	self._duration = self._duration + delta
	local result = self._duration < self._endTime and BTResult.Running or BTResult.Ended
	return result
		
end
return BTWaitAction