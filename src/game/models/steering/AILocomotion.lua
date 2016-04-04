local Vehicle = import(".Vehicle")

local AILocomotion = class("AILocomotion", Vehicle)

function AILocomotion:init(steerings, gameObject)
	self.moveDistance = cc.p(0,0)
	AILocomotion.super.init(self, steerings, gameObject)
end

function AILocomotion:update()
	AILocomotion.super.update(self)
	self.velocity = cc.pAdd(self.velocity, cc.pMul(self.acceleration, Time.delta))

	if cc.pLengthSQ(self.velocity) > self.sqrMaxSpeed then
		self.velocity = cc.pMul(cc.pNormalize(self.velocity), self.maxSpeed)
	end

	self.moveDistance = cc.pMul(self.velocity, Time.delta)
	if self.gameObject then
		local newPos = cc.pAdd(cc.p(self.gameObject:getPosition()), self.moveDistance)
		self.gameObject:setPosition(newPos.x, newPos.y)
	end
end

return AILocomotion