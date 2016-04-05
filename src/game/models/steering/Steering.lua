local Component = cc.Component
local Steering = class("Steering", Component)

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