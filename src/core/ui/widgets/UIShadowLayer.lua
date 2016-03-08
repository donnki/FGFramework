local ShadowLayer = class("ShadowLayer" , function () --@return scene
    return cc.Layer:create()
end)

ShadowLayer.__index = ShadowLayer


function ShadowLayer.ctor()
end


function ShadowLayer:init()
    local coverLayer = cc.LayerColor:create(cc.c4b(0,0,0,130))
    coverLayer:setContentSize(cc.size(display.width, display.height))
    self:addChild(coverLayer)

    local function onTouchBegan(touch, event)
        self:setLocalZOrder(self:getLocalZOrder()-1)
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, coverLayer)
end


function ShadowLayer.create()
    local m = ShadowLayer.new()
    m:init()
    return m
end

return ShadowLayer