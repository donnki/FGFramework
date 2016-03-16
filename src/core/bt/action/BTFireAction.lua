local BTFireAction = class("BTFireAction", BTAction)

---------------
-- Action: 开火
function BTFireAction:execute(delta)
	if self.database and self.database:fire() then
		return BTResult.Ended
	end
	return BTResult.Running
end
return BTFireAction