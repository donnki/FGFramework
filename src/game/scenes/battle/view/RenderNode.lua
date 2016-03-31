local RenderNode = class("RenderNode", function()
	return cc.Node:create()
end)

function RenderNode:ctor(model)
	self.model = model
end


return RenderNode