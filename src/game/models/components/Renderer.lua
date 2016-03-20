--[[
    渲染组件
]]
local Component = cc.Component
local Renderer = class("Renderer", Component)


function Renderer:ctor()
    Renderer.super.ctor(self, "Renderer")
end

function Renderer:exportMethods()
    self:exportMethods_({
    })
    return self.target_
end

function Renderer:onBind_(gameObject)
	gameObject:initDisplay()
end
function Renderer:onUnbind_(gameObject)
end

function Renderer:update(dt)
end
return Renderer
