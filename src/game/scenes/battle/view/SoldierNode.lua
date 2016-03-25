local RenderNode = import(".RenderNode")
local SoldierNode = class("SoldierNode", RenderNode)

function SoldierNode:ctor(model)
	SoldierNode.super.ctor(self, model)
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidCircle(cc.p(0,0), model:getValue("size"), 0, 50, 1.0, 1.0, cc.c4f(1,0.5,1,1))
    self.drawNode:drawCircle(cc.p(0,0), model:getValue("attackRange"), 0, 50, true, 1.0, 1.0, cc.c4f(1.0, 0.2, 0.0, 0.2))
    self:addChild(self.drawNode)
    self:setPosition(model:getPosition())
end


function SoldierNode:update()
	self:setPosition(self.model:getPosition())
	self:setRotation(self.model:getRotation())
	-- print(dump(self.model:getPosition()))
	-- print(self:getPositionX(), self:getPositionY())
end
return SoldierNode