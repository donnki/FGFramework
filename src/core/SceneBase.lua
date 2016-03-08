----------------
--场景基类
----------------
SceneBase = class("SceneBase",function (usePhysics) --@return scene
        if usePhysics then
            local scene = cc.Scene:createWithPhysics()
            scene:setNodeEventEnabled(true)
            scene:setAutoCleanupEnabled()
            scene:getPhysicsWorld():setGravity(cc.p(0, 0))
            return scene
        else
            local scene = cc.Scene:create()
            -- scene = createInstance(SceneBase, scene)
            return scene;
        end
end)

SceneBase.__index = SceneBase
SceneBase.lastTouchPosition = nil
SceneBase.lastTouchEventListener = nil
SceneBase.uiRoot = nil
SceneBase.name = nil

function SceneBase:init()
    self:initUI()
    
    self:registerScriptHandler(function(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            if self.lastTouchEventListener then
                self:getEventDispatcher():removeEventListener(self.lastTouchEventListener)
                self.lastTouchEventListener = nil
            end
            self:onExit()
        end
    end)
end

function SceneBase:getGlobleTouchPosition()
    return self.lastTouchPosition
end

function SceneBase:addGlobalTouchPositionListener()
    if  self.lastTouchEventListener then return end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch,event) self.lastTouchPosition = touch:getLocation() return true end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(touch) self.lastTouchPosition = touch:getLocation()  end,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(function(touch) self.lastTouchPosition = touch:getLocation()  end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, -1)
    self.lastTouchEventListener = listener
end

function SceneBase:onEnter()
    Log.w(self.name, " onEnter，覆盖此方法以注册一些监听事件等")
end

function SceneBase:onExit()
    Log.w(self.name, " onExit，覆盖此方法以做必要的清理等")
end

function SceneBase:getUIRoot()
    return self.uiRoot
end

function SceneBase:addUiToRoot(key,child)
    return self.uiRoot:registerWindow(key,child)
end

function SceneBase:update( ... )
    -- body
end

function SceneBase:closeCurWnd()
    self.uiRoot:closeCurUI()
end

function SceneBase:closeAllWnd()
    self.uiRoot:closeAllUI()
end

function SceneBase:closeUIbyKey(key)
    self.uiRoot:closeUIByKey(key)
end

function SceneBase:removeUIRootByKey(key)
    self.uiRoot:removeWndByKey(key)
end

function SceneBase:removeWnd(wnd)
    self.uiRoot:removeWnd(wnd)
end

function SceneBase:initUI()
    local ui = UIRoot:create()
  --  local Tags = self.Tags
    -- Log.i("init ui ")
    -- ui:setTag(Tags.ui)
    self.uiRoot = ui
    self:addChild(ui,1)
end

function SceneBase:getName()
    return self.__cname
end

function SceneBase:getTagList()
    return self.Tags
end

function SceneBase.create(...) -- 子类重写
    --[[
    local scene = SceneBase.new()
    scene:init( ... )
    return scene
    --]]
end

function SceneBase.createWithData(data)
    Log.w("场景子类应该重写本方法，来创建一个场景的实例并返回该实例！此处返回一个空场景。")
    local scene = SceneBase.new()
    scene:init(data)
    return scene
end

function SceneBase.getExtraRes()
    Log.w("场景子类应该重写本方法，来动态加载额外的资源")
end
