local RenderNode = import(".RenderNode")
local BuildingNode = class("BuildingNode", RenderNode)

function BuildingNode:ctor(model)
	BuildingNode.super.ctor(self, model)
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidCircle(cc.p(0,0), model:getValue("size"), 0, 50, 1.0, 1.0, cc.c4f(1,0,1,1))
    if  model:getValue("attackRangeMax") then
    	self.drawNode:drawCircle(cc.p(0,0), model:getValue("attackRangeMax"), 0, 50, true, 1.0, 1.0, cc.c4f(1.0, 0.0, 0.0, 0.2))
    end
    
    self:addChild(self.drawNode)
    self:setPosition(model:getPosition())
end


function BuildingNode:update()
	if self.model then
		self:setPosition(self.model:getPosition())
		self:setRotation(-self.model:getRotation())
	end
end
return BuildingNode