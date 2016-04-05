local Steering = import(".Steering")
local SteeringForFlee = class("SteeringForFlee", Steering)

function SteeringForFlee:exportMethods()
    self:exportMethods_({
    	"flee",
    })
    return self.target_
end

function SteeringForFlee:flee(target, fearDistance)
	-- SteeringForFlee.super.ctor(self, target, m_vehicle)
	self.target = target
	self.fearDistance = fearDistance
	self.desiredVelocity = cc.p(0,0)
end

function SteeringForFlee:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.target and self.m_vehicle then
		if cc.pGetDistance(cc.p(self.target:getPosition()), cc.p(self.gameObject:getPosition())) < self.fearDistance then
			self.desiredVelocity = cc.pMul(
				cc.pNormalize(
					cc.pSub(
						cc.p(self.m_vehicle.gameObject:getPosition()),
						cc.p(self.target:getPosition())
					)), self.m_vehicle.maxSpeed)
			return cc.pSub(self.desiredVelocity, self.m_vehicle.velocity)
		end
	end
	return cc.p(0,0)
end
return SteeringForFlee