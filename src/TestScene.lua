local TestScene = class("TestScene" , SceneBase)
local bt = require("core.bt.BTInit")
local Tower = require("game.test.Tower")
local Unit = require("game.test.Unit")
TestScene.__index = TestScene
TestScene.name = "TestScene"
local tmpbox = nil

function TestScene:init(config)
    SceneBase.init(self)

    Log.d("TestScene初始化临时测试场景")
 
    self.tower = Tower.new(50,300, 1):pos(display.cx, display.cy):addTo(self)
    self.tower2 = Tower.new(50,300, 1):pos(display.width*0.9, display.height*0.8):addTo(self)

    self.unit = Unit.new(20,100, 1):pos(0, 0):addTo(self)
    table.insert(self.tower.allEnemies, self.unit)
    table.insert(self.tower2.allEnemies, self.unit)
    table.insert(self.unit.allBuildings, self.tower)
    table.insert(self.unit.allBuildings, self.tower2)


    local node = cc.DrawNode:create()
    node:setPosition(300,500)
    node:drawSolidCircle(cc.p(0,0), 15, 0, 50, 1.0, 1.0, cc.c4f(0,0,1,0.5))
    node.radius = 15
    self:addChild(node)
    table.insert(self.unit.allEnemyUnits, node)

    local menu = cc.Menu:create()
    self:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("addRandomNode", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()

       
    end)
    menu:addChild(label)
    menu:alignItemsVertically()
    menu:setPosition(display.width*0.9, 50)
    local node = bt.debugDisplayTree(self.unit.btRoot)
    node:setPosition(300, display.cy+100):scale(0.5)
    self:addChild(node)
end

function TestScene:update(dt)

    if self.tower then
        self.tower:update(dt)
    end
    if self.tower2 then
        self.tower2:update(dt)
    end
    if self.unit then
        self.unit:update(dt)
    end
end

function TestScene:onEnter()
    Engine:getEventManager():on(EventConstants.AppEnterForegroundEvent, function()
        Log.i("~~~~on ", EventConstants.AppEnterForegroundEvent)
    end)

    Engine:getEventManager():on(EventConstants.AppEnterBackgroundEvent, function()
        Log.i("~~~~on ", EventConstants.AppEnterBackgroundEvent)
    end)

    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        
        local distance = cc.pGetDistance(touch:getLocation(), cc.p(self.tower:getPosition()))
        local distance2 = cc.pGetDistance(touch:getLocation(), cc.p(self.tower2:getPosition()))
        if distance < self.tower.radius then
            self.unit:leadTo(true, self.tower)
        elseif distance2 < self.tower2.radius then
            self.unit:leadTo(true, self.tower2)
        else
            self.unit:leadTo(false, touch:getLocation())
        end

    end ,cc.Handler.EVENT_TOUCH_BEGAN )
    -- self.touchListener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- self.touchListener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.touchListener, -1)
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
