--[[
    渲染组件
]]
local Component = cc.Component
local RenderComponent = class("RenderComponent", Component)


function RenderComponent:ctor()
    RenderComponent.super.ctor(self, "RenderComponent")
end

function RenderComponent:exportMethods()
    self:exportMethods_({
    	"getRenderer",
    	"bindRenderer",
    })
    return self.target_
end

function RenderComponent:onUnbind_()
end

--绑定某个显示的node
function RenderComponent:bindRenderer(renderNode)
	self.renderer = renderNode
end

function RenderComponent:getRenderer()
	return self.renderer
end

return RenderComponent
