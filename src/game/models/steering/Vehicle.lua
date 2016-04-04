local Vehicle = class("Vehicle")

function Vehicle:init(steerings, gameObject)
	self.steerings = steerings
	self.gameObject = gameObject
	self.maxSpeed = 100
	self.maxForce = 100
	self.sqrMaxSpeed = self.maxSpeed * self.maxSpeed 
	self.mass = 0.1
	self.velocity = cc.p(0,0)
	self.damping = 0.9
	self.computeInterval = 0.2
	self.steeringForce_ = cc.p(0,0)
	self.acceleration = cc.p(0,0)
	self.timer = 0
end

function Vehicle:update()
	self.timer = self.timer + Time.delta
	self.steeringForce_ = cc.p(0,0)
	if self.timer > self.computeInterval then
		for i,v in ipairs(self.steerings) do
			self.steeringForce_ = cc.pMul(v:force(),v.weight)
		end
		--限制操控力不大于maxForce
		if cc.pGetLength(self.steeringForce_) > self.maxForce then
			local angle = cc.pToAngleSelf(self.steeringForce_)
			self.steeringForce_ = cc.p(self.maxForce*math.cos(angle), self.maxForce*math.sin(angle))
		end
		self.acceleration = cc.pMul(self.steeringForce_, 1/self.mass)
		self.timer = 0
	end


end

return Vehicle