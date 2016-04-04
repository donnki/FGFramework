local Steering = class("Steering")

function Steering:ctor()
	self.weight = 1
end

function Steering:force()
	return cc.p(0,0)
end

return Steering