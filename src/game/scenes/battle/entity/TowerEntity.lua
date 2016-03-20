local TowerEntity = class("TowerEntity", function()
	return cc.Node:create()
end)


function TowerEntity:ctor(model)
	self.model = model
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidCircle(cc.p(0,0), model.radius, 0, 50, 1.0, 1.0, cc.c4f(1,0,1,1))
    self.drawNode:drawCircle(cc.p(0,0), model.attackRadius, 0, 50, true, 1.0, 1.0, cc.c4f(1.0, 0.0, 0.0, 0.2))
    self:addChild(self.drawNode)
    self:setPosition(model:getPosition())
end


function TowerEntity:update(delta)
	self.model:update(delta)
end

return TowerEntity