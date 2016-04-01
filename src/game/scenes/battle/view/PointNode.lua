local PointNode = class("PointNode", function()
	return cc.Node:create()
end)

function PointNode:ctor()
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidCircle(cc.p(0,0), 10, 0, 50, 1.0, 1.0, cc.c4f(0,1,1,1))
    self:addChild(self.drawNode)
end


return PointNode