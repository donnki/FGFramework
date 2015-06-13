local ShadowLayer = require("core.ui.widgets.UIShadowLayer")


local TipWindow = class("TipWindow",function()
    return cc.Layer:create()
end)

local Tags = {
    title = 200,
    confirm = 132,
    cancel = 131,
    image = 420,
    imageCount = 421
}

TipWindow.__index = TipWindow
TipWindow.engine  = nil

function TipWindow.ctor()
end

function TipWindow.create()
    local layer = TipWindow.new()
    layer:init()
    return layer
end

function TipWindow:setTitle(str)
    local title = self.title
    title:setScale(0.8)
    title:setString(str)
end

function TipWindow:setConfirmCallBack(callback)
    local confirmBtn = self.confirm
    confirmBtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then

            callback()
            self:removeFromParent(true)
        end
    end)
           
end

function TipWindow:setCancelCallBack(callback)
    local cancelBtn = self.cancel
    cancelBtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if callback then
                callback()
            end
            self:removeFromParent(true)
        end
    end)
end

function TipWindow:setCenterSprite(sprite)
    if sprite then
        self.image:setVisible(false)
        sprite:setPosition(self.image:getPosition())
        self:addChild(sprite)
    else
        self.image:setVisible(true)
    end
end
function TipWindow:setCountLabel(labelString)


    if labelString then
        self.imageCount:setString(labelString)
        self.iamgeCount:setVisible(true)
    end

end

function TipWindow:setTypeForOneBtn()
    self:getChildByTag(Tags.menu):getChildByTag(Tags.cancel):setVisible(false)
end

function TipWindow:init()

    self:addChild(ShadowLayer.create())
    local node = cc.CSLoader:createNode("res/UIs/Public_Prop.csb")
    node:setTag(0)
    for k,v2 in pairs(Tags) do
        self[k] = node:getChildByTag(v2)
    end
    self.image:setVisible(false)
    self.imageCount:setVisible(false)
    self:addChild(node)

    

end

return TipWindow