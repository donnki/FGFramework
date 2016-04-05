local Steering = import(".Steering")
local SteeringForSeek = class("SteeringForSeek", Steering)

function SteeringForSeek:exportMethods()
    self:exportMethods_({
    	"seek",
    })
    return self.target_
end

function SteeringForSeek:seek(target)
	-- SteeringForSeek.super.ctor(self, target, m_vehicle)
	self.target = target	
	self.desiredVelocity = cc.p(0,0)
end

function SteeringForSeek:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.target and self.m_vehicle then
		self.desiredVelocity = cc.pMul(
			cc.pNormalize(
				cc.pSub(
					cc.p(self.target:getPosition()), 
					cc.p(self.m_vehicle.gameObject:getPosition()))
				), self.m_vehicle.maxSpeed)
		return cc.pSub(self.desiredVelocity, self.m_vehicle.velocity)
	else
		return cc.p(0,0)
	end
end
return SteeringForSeek