local BTFinishedAction = class("BTFinishedAction", BTAction)

function BTFinishedAction:execute(delta)
	if self.database:onFinished(self.properties.operation) then
		return BTResult.Ended
	end

	return BTResult.Running
end
return BTFinishedAction