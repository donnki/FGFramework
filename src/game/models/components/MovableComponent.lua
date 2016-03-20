--[[
    移动组件
]]
local Component = cc.Component
local MovableComponent = class("MovableComponent", Component)


function MovableComponent:ctor()
    MovableComponent.super.ctor(self, "MovableComponent")
end

function MovableComponent:exportMethods()
    self:exportMethods_({
    })
    return self.target_
end

function MovableComponent:onBind_(gameObject)
end

return MovableComponent
