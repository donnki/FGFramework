
--[[
    位置信息组件
]]

local Component = cc.Component
local Transform = class("Transform", Component)



function Transform:ctor()
    Transform.super.ctor(self, "Transform")
    self.position = cc.p(0,0)
    self.rotation = 0
    self.scale = cc.p(0,0)
end

function Transform:exportMethods()
    self:exportMethods_({
        "getPosition",
        "getRotation",
        "getScale",
        "setPosition",
        "setRotation",
        "setScale",
    })
    return self.target_
end

function Transform:getPosition()
    return self.position
end

function Transform:getRotation()
    return self.rotation
end

function Transform:getScale()
    return self.scale
end

function Transform:setPosition(x, y)
    self.position.x = x
    self.position.y = y
end

function Transform:setRotation(r)
    self.rotation = r
end

function Transform:setScale(x, y)
    self.scale.x = x
    self.scale.y = y
end
return Transform
