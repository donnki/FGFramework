local Missile = class("Missile")

-- fixed speed missile
-- accelerating missile
-- fixed time missile

function Missile:ctor(from, arc, target, speed, trackTarget, onFinishedCallback)
	cc(self)
	self:addComponent("game.models.components.TransformComponent"):exportMethods()
	self:addComponent("game.models.components.RenderComponent"):exportMethods()

	self.from = from
	self.arc = arc
	self.target = target
	self.speed = speed
	self.trackTarget = trackTarget
	self.onFinishedCallback = onFinishedCallback

	self:calculateControlPoint()
    self.needTime_ = self.originDistance_ / self.speed
    self.timer = 0

    self:setPosition(self.from)
    self.isFinished = false
end

function Missile:update()
	if not self.isFinished then
		local t = self.timer / self.needTime_
		if t <=1 then
			if self.trackTarget then
				self:calculateControlPoint()
			end
			local px = squarebezierat(self.from.x, self.controlPoint.x, self.to.x, t)
	        local py = squarebezierat(self.from.y, self.controlPoint.y, self.to.y, t)
	        local prePos = self:getPosition()
	        self:setPosition(px, py)
	        self:setRotation(-math.deg(cc.pToAngleSelf(
	        		cc.pSub(self:getPosition(),prePos))))
		else
			self.isFinished = true
			if self.onFinishedCallback then
				self.onFinishedCallback(self.target)
			end
			if self:getRenderer() then
				self:getRenderer():removeFromParent()
				self:unbindRenderer()
			end
		end
		self.timer = self.timer + Time.delta
		if self:getRenderer() then
			self:getRenderer():update()
		end
	end
	
end

function Missile:processMovementComplete()
end

function Missile:calculateControlPoint()
	self.to = cc.p(self.target:getPosition())
	self.originDistance_ = cc.pGetDistance(self.from, self.to)

    self.controlPoint = cc.p((self.from.x+self.to.x)/2,(self.from.y+self.to.y)/2+self.originDistance_*self.arc)
end

function Missile:genTestRender()
	local StickNode = require("game.scenes.battle.view.StickNode")
	local node = StickNode.new(self, 100,5)
	node:setPosition(self:getPosition())
	self:bindRenderer(node)
	return node
end

return Missile