local BTIdleAction = class("BTIdleAction", BTAction)

---------------
-- Action: 待机
function BTIdleAction:execute(delta)
	return BTResult.Running
end
return BTIdleAction