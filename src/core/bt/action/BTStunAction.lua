local BTStunAction = class("BTStunAction", BTAction)

---------------
-- Action: 控制&眩晕
function BTStunAction:execute(delta)

	return BTResult.Running
end
return BTStunAction