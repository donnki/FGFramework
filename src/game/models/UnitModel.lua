local Unit = class("Unit")

function Unit:ctor(proto)
	self.proto = proto
	
	-- 单位的位置组件
	cc(self):addComponent("game.models.components.Transform"):exportMethods()

end


return Unit