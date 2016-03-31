
--[[
    位置信息组件
]]

local Component = cc.Component
local TransformComponent = class("TransformComponent", Component)



function TransformComponent:ctor()
    TransformComponent.super.ctor(self, "TransformComponent")
    self.position = cc.p(0,0)
    self.rotation = 0
    self.scale = cc.p(0,0)
end

function TransformComponent:exportMethods()
    self:exportMethods_({
        "setPosition",
        "setRotation",
        "getPosition",
        "getRotation",
        "getViewPosition",
        "setByViewPosition",
    })
    return self.target_
end

function TransformComponent:getPosition()
    return self.position
end

function TransformComponent:getRotation()
    return self.rotation
end


function TransformComponent:setPosition(x, y)
    self.position = cc.p(x, y)
end

function TransformComponent:setRotation(r)
    self.rotation = r
end

function TransformComponent:getViewPosition()
    return cc.p(iso.ISOPixelconvertToRelative(self.position.x, self.position.y))
end

function TransformComponent:setByViewPosition(x, y)
    local pos = cc.p(iso.convertRelativeToISOPixel(x, y))
    self:setPosition(pos.x, pos.y)
end

return TransformComponent
