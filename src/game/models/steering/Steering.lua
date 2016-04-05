local Component = cc.Component
local Steering = class("Steering", Component)

-------------
-- Steering基类，其子类包括：
-- Seek: 靠近
-- Flee: 离开
-- Arrive: 抵达
-- Pursuit: 追逐
-- Evade: 逃避	
function Steering:ctor()
	Steering.super.ctor(self, "Steering")
	
end

function Steering:onBind_()
	self.weight = 1
end

function Steering:force()
	return cc.p(0,0)
end

return Steering