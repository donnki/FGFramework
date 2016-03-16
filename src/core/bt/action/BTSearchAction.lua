local BTSearchAction = class("BTSearchAction", BTAction)

function BTSearchAction:execute(delta)
	if self.database and self.database:findTarget() then
		return BTResult.Ended
	end
	return BTResult.Running
end
return BTSearchAction