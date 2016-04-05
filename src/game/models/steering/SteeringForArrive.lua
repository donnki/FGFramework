local Steering = import(".Steering")
local SteeringForArrive = class("SteeringForArrive", Steering)

function SteeringForArrive:exportMethods()
    self:exportMethods_({
    	"arrive",
    })
    return self.target_
end

function SteeringForArrive:arrive(target, slowDownDistance)
	-- SteeringForArrive.super.ctor(self, target, m_vehicle)
	self.target = target	
	self.desiredVelocity = cc.p(0,0)
	self.slowDownDistance = slowDownDistance
end

function SteeringForArrive:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.target and self.m_vehicle then
		local toTarget = cc.pSub(cc.p(self.target:getPosition()), cc.p(self.gameObject:getPosition()))
		local distance = cc.pGetLength(toTarget)
		if distance > self.slowDownDistance then
			self.desiredVelocity = cc.pMul(cc.pNormalize(toTarget), self.m_vehicle.maxSpeed)
		else
			self.desiredVelocity = cc.pSub(toTarget, self.m_vehicle.velocity)
		end
		return cc.pSub(self.desiredVelocity, self.m_vehicle.velocity)
	else
		return cc.p(0,0)
	end
end
return SteeringForArrive