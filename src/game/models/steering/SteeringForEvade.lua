local Steering = import(".Steering")
local SteeringForEvade = class("SteeringForEvade", Steering)

function SteeringForEvade:exportMethods()
    self:exportMethods_({
    	"evade",
    })
    return self.target_
end

function SteeringForEvade:evade(target)
	self.target = target	
end

function SteeringForEvade:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.target and self.m_vehicle then
		local targetVehicle = self.target:getComponent("Vehicle")
		local toTarget = cc.pSub(cc.p(self.target:getPosition()), cc.p(self.gameObject:getPosition()))
		local lookaheadTime = cc.pGetLength(toTarget)/(self.m_vehicle.maxSpeed + cc.pGetLength(targetVehicle.velocity))
		local desiredVelocity = cc.pMul(cc.pNormalize(
			cc.pSub(cc.p(self.gameObject:getPosition()), cc.pAdd(cc.p(self.target:getPosition()), cc.pMul(targetVehicle.velocity, lookaheadTime)))),
			self.m_vehicle.maxSpeed)
		return cc.pSub(desiredVelocity, self.m_vehicle.velocity)
	else
		return cc.p(0,0)
	end
end
return SteeringForEvade