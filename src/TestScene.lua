local TestScene = class("TestScene" , SceneBase)
require("core.bt.BTInit")
TestScene.__index = TestScene
TestScene.name = "TestScene"
local tmpbox = nil
function TestScene:ctor()
    self:init()
end
function TestScene:init(config)
    SceneBase.init(self)

    Log.d("TestScene初始化临时测试场景")
    local layer = cc.Layer:create()
    layer:setSwallowsTouches(true)
    layer:setTag(1024)
    self:addChild(layer)

    tmpbox = cc.LayerColor:create(cc.c4b(100,100,255,255));
    tmpbox:setContentSize(10,10);
    tmpbox:setPosition(display.cx,display.cy)
    layer:addChild(tmpbox)


    local box = cc.LayerColor:create(cc.c4b(100,100,255,255));
    box:setContentSize( cc.size(display.width,display.height) );
    box:setPosition(0,0)
    layer:addChild(box)

    -- local t = ccs.GUIReader:getInstance():widgetFromJsonFile("res/UIs/GameOver_1.ExportJson")
    -- self:addChild(t)

    local menu = cc.Menu:create()
    layer:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("DoTest", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        local scene = require("TestScene").new()
        display.replaceScene(scene)
    end)
    menu:addChild(label)


    local a, b = 3, 2
    self.btRoot = BTPrioritySelector.new("test")
    

    local precondition = BTPrecondition.new("check")
    precondition.func = function() return a > b end

    local a1 = BTAction.new("a1", precondition)
    -- self.btRoot:addChild(a1)

    local a2 = BTAction.new("a2")

    local seq = BTSequence.new("seq")
    seq:addChild(a1)
    seq:addChild(a2)

    local a3 = BTAction.new("a3")
    local a4 = BTAction.new("a4")
    local par = BTParallel.new("par", nil, true)
    par:addChild(a3)
    par:addChild(a4)
    seq:addChild(par)

    local par2 = BTParallelFlexible.new(par2)
    local a5 = BTAction.new("a5")
    local a6 = BTAction.new("a6")
    par2:addChild(a5)
    par2:addChild(a6)
    seq:addChild(par2)

    self.btRoot:addChild(seq)

    self.btRoot:activate()

    menu:alignItemsVertically()

    display.newScale9Sprite("BG.png",51,60, cc.size(720,720)):pos(display.cx, display.cy):addTo(self)


    
end

function TestScene:update(dt)
    if self.btRoot:evaluate() then
        self.btRoot:tick()
    end
end
function TestScene:onEnter()
    Engine:getEventManager():on(EventConstants.AppEnterForegroundEvent, function()
        Log.i("~~~~on ", EventConstants.AppEnterForegroundEvent)
    end)

    Engine:getEventManager():on(EventConstants.AppEnterBackgroundEvent, function()
        Log.i("~~~~on ", EventConstants.AppEnterBackgroundEvent)
    end)


    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "began" then
    --         print("began")
    --     elseif event.name == "moved" then
    --         print("moved")
    --     elseif event.name == "ended" then
    --         print("end")
    --     end
    --     return true
    -- end)

    -- local listener = cc.EventListenerTouchOneByOne:create()
    -- listener:registerScriptHandler(function(touch,event) print("on touch began") return true end,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener:registerScriptHandler(function(touch)  print("on touch moved")  end,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener:registerScriptHandler(function(touch)  print("on touch end")   end,cc.Handler.EVENT_TOUCH_ENDED )
    -- local eventDispatcher = self:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithFixedPriority(listener, -1)
    -- self.lastTouchEventListener = listener
end

function TestScene:onExit()
    Engine:getEventManager():clear(EventConstants.AppEnterForegroundEvent)
    Engine:getEventManager():clear(EventConstants.AppEnterBackgroundEvent)
    print("~~~onExit")
end

-- local t = 0
-- function TestScene:update(delta)
--     -- Log.i(delta)
--     t = t + delta*2
--     if t > 2 * math.pi then
--         t = 0 
--     end
--     local x, y = tmpbox:getPosition()
--     x = 150 * math.cos(t)
--     y = 150 * math.sin(t)
--     tmpbox:setPosition(display.cx + x, display.cy + y)
-- end

function TestScene:test()
    -- local LoadingScene = require("game.scenes.LoadingScene")
    -- Engine:changeScene(LoadingScene:createForNext(require("game.scenes.TestScene")))
    -- local window = Engine:getUIManager():openSingleton("GameOverLayer")
    -- local window = Engine:getUIManager():openSingleton("MenuBgLayer")
--    local window = Engine:getUIManager():openSingleton("ShopLayer")
end

function TestScene:setupListView()
    local logger = LoggerWindow:getInstance()
    self:addChild(logger)
end

function TestScene:testFireEvent()
    EventManager:getInstance():dispatchEvent(Event.TestEvent.event1,{param="1234"})
end


function TestScene.createWithData(data)
    local scene = TestScene.new()
    scene:init(data)
    return scene
end
function TestScene.create(config)
    local scene = TestScene.new()
    scene:init(config)
    return scene
end
return TestScene
