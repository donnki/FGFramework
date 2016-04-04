local Steering = import(".Steering")
local SteeringForSeek = class("SteeringForSeek", Steering)

function SteeringForSeek:ctor(target, m_vehicle)
	SteeringForSeek.super.ctor(self, target, m_vehicle)
	self.m_vehicle = m_vehicle
	self.target = target	
	self.desiredVelocity = cc.p(0,0)
end

function SteeringForSeek:force()
	self.desiredVelocity = cc.pMul(
		cc.pNormalize(
			cc.pSub(
				cc.p(self.target:getPosition()), 
				cc.p(self.m_vehicle.gameObject:getPosition()))
			), self.m_vehicle.maxSpeed)
	return cc.pSub(self.desiredVelocity, self.m_vehicle.velocity)
end
return SteeringForSeek