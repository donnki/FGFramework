local BTMoveAction = class("BTMoveAction", BTAction)

---------------
-- Action: 移动
function BTMoveAction:execute(delta)
	if self.database:move() then
		return BTResult.Ended
	end
	return BTResult.Running
end
return BTMoveAction