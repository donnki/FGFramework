local RenderNode = import(".RenderNode")
local StickNode = class("StickNode", RenderNode)

function StickNode:ctor(model, width, height)
	StickNode.super.ctor(self, model)
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidRect(cc.p(-width/2,-height/2), cc.p(width/2, height/2), cc.c4f(1,0.5,1,1))
    self:addChild(self.drawNode)
end

function StickNode:update()
	if self.model then
		self:setPosition(self.model:getPosition())
		self:setRotation(self.model:getRotation())

	end
end
return StickNode