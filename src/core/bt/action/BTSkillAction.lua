local BTSkillAction = class("BTSkillAction", BTAction)

function BTSkillAction:execute(delta)
	-- if self.database and self.database:findTarget() then
	-- 	return BTResult.Ended
	-- end
	return BTResult.Running
end
return BTSkillAction