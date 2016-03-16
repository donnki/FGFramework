local BTMoveAction = class("BTMoveAction", BTAction)

---------------
-- Action: 移动
function BTMoveAction:execute(delta)
	return BTResult.Running
end
return BTMoveAction