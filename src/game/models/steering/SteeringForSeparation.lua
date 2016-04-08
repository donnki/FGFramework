local Steering = import(".Steering")
local SteeringForSeparation = class("SteeringForSeparation", Steering)

function SteeringForSeparation:exportMethods()
    self:exportMethods_({
    	"arrive",
    })
    return self.target_
end

function SteeringForSeparation:start()
	self.comfortDistance = 1
	self.multiplierInsideComfortDistance = 2
end

function SteeringForSeparation:force()
	if self.m_vehicle == nil then
		self.m_vehicle = self.gameObject:getComponent("Vehicle")
	end
	if self.m_vehicle then
		local steeringForce = cc.p(0,0)
		for k,v in pairs(self.gameObject.root:aoiUnitSearch(self.gameObject:getTag(), 100)) do
			local unit = self.gameObject.root:getChildByTag(v:get_id())
			local toNeihbor = cc.pSub(cc.p(self.gameObject:getPosition()), cc.p(unit:getPosition()))
			local length = cc.pGetLength(toNeihbor)

			steeringForce = cc.pAdd(steeringForce, cc.pMul(cc.pNormalize(toNeihbor),1/length))
			if length < self.comfortDistance then
				steeringForce = cc.pMul(steeringForce, self.multiplierInsideComfortDistance)
			end
		end
		return steeringForce
	else
		return cc.p(0,0)
	end
end
return SteeringForSeparation