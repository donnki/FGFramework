local SkillBase = class("SkillBase")

function SkillBase:ctor()
	self.timer = 0
end

function SkillBase:WaitForSeconds(delayTime)
    self.timer = self.timer + Time.delta
    if self.timer > delayTime then
        self.timer = 0
        return true
    else
        return false
    end
end

return SkillBase