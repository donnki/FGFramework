local Steering = import(".Steering")
local SteeringForPursuit = class("SteeringForPursuit", Steering)

function SteeringForPursuit:exportMethods()
    self:exportMethods_({
    	"pursuit",
    })
    return self.target_
end

function SteeringForPursuit:pursuit(target)
	self.target = target
end

function SteeringForPursuit:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.target and self.m_vehicle then
		local targetVehicle = self.target:getComponent("Vehicle")
		local toTarget = cc.pSub(cc.p(self.target:getPosition()), cc.p(self.gameObject:getPosition()))
		local relativeDirection = cc.pDot(cc.pNormalize(self.m_vehicle.velocity), cc.pNormalize(targetVehicle.velocity))
		local angle = cc.pDot(cc.pNormalize(toTarget), cc.pNormalize(self.m_vehicle.velocity))
		local desiredVelocity = cc.p(0,0)
		if angle > 0 then
			desiredVelocity = cc.pMul(
				cc.pNormalize(
					cc.pSub(
						cc.p(self.target:getPosition()),
						cc.p(self.m_vehicle.gameObject:getPosition())
					)), self.m_vehicle.maxSpeed)
		else
			local lookaheadTime = cc.pGetLength(toTarget)/(self.m_vehicle.maxSpeed + cc.pGetLength(targetVehicle.velocity))
			desiredVelocity = cc.pSub(
				cc.pAdd(cc.p(self.target:getPosition()), cc.pMul(targetVehicle.velocity, lookaheadTime)), 
				cc.pMul(cc.pNormalize(cc.p(self.gameObject:getPosition())), self.m_vehicle.maxSpeed)
			)
		end
		local ret = cc.pSub(desiredVelocity, self.m_vehicle.velocity)
		-- print(dump(ret))
		return ret
	end
	return cc.p(0,0)
end
return SteeringForPursuit