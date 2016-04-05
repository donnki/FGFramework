local Steering = import(".Steering")
local SteeringForWander = class("SteeringForWander", Steering)

function SteeringForWander:exportMethods()
    self:exportMethods_({
    	"wander",
    })
    return self.target_
end

function SteeringForWander:wander(radius, distance, jitter)
	-- SteeringForWander.super.ctor(self, target, m_vehicle)
	self.wanderRadius = radius
	self.wanderDistance = distance 
	self.wanderJitter = jitter
	self.startWander = true
	self.circleTarget = cc.p(self.wanderRadius*0.5, self.wanderRadius*0.5)
end

function SteeringForWander:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.m_vehicle and self.startWander then
		local randomDisplacement = cc.p(
			(math.random()-0.5)*2*self.wanderJitter,
		 	(math.random()-0.5)*2*self.wanderJitter)

		self.circleTarget = cc.pAdd(self.circleTarget, randomDisplacement)
		self.circleTarget = cc.pMul(cc.pNormalize(self.circleTarget), self.wanderRadius)
		
		local wanderTarget = cc.pAdd(cc.pAdd(cc.pMul(cc.pNormalize(self.m_vehicle.velocity),self.wanderDistance), self.circleTarget), cc.p(self.gameObject:getPosition()))
		local desiredVelocity = cc.pMul(cc.pNormalize(cc.pSub(wanderTarget, cc.p(self.gameObject:getPosition()))), self.m_vehicle.maxSpeed)
		return cc.pSub(desiredVelocity, self.m_vehicle.velocity)
	else
		return cc.p(0,0)
	end
end
return SteeringForWander