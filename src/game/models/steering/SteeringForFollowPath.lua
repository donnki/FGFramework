local Steering = import(".Steering")
local SteeringForFollowPath = class("SteeringForFollowPath", Steering)

function SteeringForFollowPath:exportMethods()
    self:exportMethods_({
    	"followPath",
    })
    return self.target_
end

function SteeringForFollowPath:followPath(path)
	self.currentNode = 1
	self.startFollow = true
	self.path = path
	self.targetPos = self.path[self.currentNode]
	self.slowDownDistance = 100
	self.arriveDistance = 150
end

function SteeringForFollowPath:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.m_vehicle and self.startFollow then
		local desiredVelocity = cc.p(0,0)
		local force = cc.p(0,0)
		local dist = cc.pSub(self.targetPos, cc.p(self.gameObject:getPosition()))

		if self.currentNode == #self.path then
			if cc.pGetLength(dist) > self.slowDownDistance then
				desiredVelocity = cc.pMul(cc.pNormalize(dist), self.m_vehicle.maxSpeed)
			else
				desiredVelocity = cc.pSub(dist, self.m_vehicle.velocity)
			end
			force = cc.pSub(desiredVelocity, self.m_vehicle.velocity)
		else
			if cc.pGetLength(dist) < self.arriveDistance then
				self.currentNode = self.currentNode + 1
				self.targetPos = self.path[self.currentNode]
			end
			desiredVelocity = cc.pMul(cc.pNormalize(dist), self.m_vehicle.maxSpeed)
			force = cc.pSub(desiredVelocity, self.m_vehicle.velocity)
		end
		return force
	else
		return cc.p(0,0)
	end
end
return SteeringForFollowPath