local BTAimAction = class("BTAimAction", BTAction)

function BTAimAction:enter()
	self.timer = 0
	self.originRotation = self.database:getRotation()
end

function BTAimAction:exit()
end

---------------
-- Action: 瞄准目标
function BTAimAction:execute(delta)
	self.timer = self.timer + delta
	if self.database and self.database:aim(self.timer, self.originRotation) then
		return BTResult.Ended
	end
	return BTResult.Running
end

return BTAimAction