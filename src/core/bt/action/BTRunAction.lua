local BTRunAction = class("BTRunAction", BTAction)

function BTRunAction:enter()
	self.timer = 0
end

function BTRunAction:exit()
end
---------------
-- Action: 执行函数
function BTRunAction:execute(delta)
	self.timer = self.timer + delta
	if self.database then
		local ret = handler(self.database, self.database[self.properties.operation])(self.timer)
		if ret then
			return BTResult.Ended
		end
	end
	return BTResult.Running
end
return BTRunAction