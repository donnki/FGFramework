local BTAimAction = class("BTAimAction", BTAction)

---------------
-- Action: 瞄准目标
function BTAimAction:execute(delta)
	if self.database and self.database:aim() then
		return BTResult.Ended
	end
	return BTResult.Running
end

return BTAimAction