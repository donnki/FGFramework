local Steering = import(".Steering")
local SteeringForCollisionAvoidance = class("SteeringForCollisionAvoidance", Steering)

function SteeringForCollisionAvoidance:exportMethods()
    self:exportMethods_({
    	"arrive",
    })
    return self.target_
end

function SteeringForCollisionAvoidance:arrive()
end

function SteeringForCollisionAvoidance:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.m_vehicle then
		-- TODO
	else
		return cc.p(0,0)
	end
end
return SteeringForCollisionAvoidance