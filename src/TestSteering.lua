local TestSteering = class("TestSteering" , SceneBase)
TestSteering.__index = TestSteering

local function newNode()
    local drawNode = cc.DrawNode:create()
    drawNode:drawSolidCircle(cc.p(0,0), 20, 0, 50, 1.0, 1.0, cc.c4f(1,0.5,1,1))
    return drawNode
end
function TestSteering:init(config)
    SceneBase.init(self)
    Log.d("TestSteering初始化临时测试场景")

    local t = newNode()
    t:setPosition( display.cx, 100)
    self:addChild(t)

    self.target = newNode()
    self.target:setPosition(display.cx, display.height)
    cc(self.target)
    self.target:addComponent("game.models.steering.SteeringForSeek"):exportMethods():seek(t)
    self.target:addComponent("game.models.steering.AILocomotion"):exportMethods()
    self:addChild(self.target)

    self.vehicle = newNode()
    cc(self.vehicle)
    -- self.vehicle:addComponent("game.models.steering.SteeringForSeek"):exportMethods()
    self.vehicle:addComponent("game.models.steering.SteeringForPursuit"):exportMethods()
    self.vehicle:addComponent("game.models.steering.AILocomotion"):exportMethods()
    self.vehicle:setPosition(100, 100)
    self:addChild(self.vehicle)

    -- local AILocomotion = require("game.models.steering.AILocomotion")
    -- self.vehicle = AILocomotion.new()

    -- local SteeringForSeek = require("game.models.steering.SteeringForSeek")
    -- local steer = SteeringForSeek.new(target, self.vehicle)
    
    -- self.vehicle:init({steer}, node)
end

function TestSteering:update(dt)
    self.target:aiTick()
    self.vehicle:aiTick()
end

function TestSteering:onEnter()
    local menu = cc.Menu:create()
    self:addChild(menu, 10)
    
    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("test", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        -- self.target:runAction(cc.MoveBy:create(2, cc.p(-100,50)))

        self.vehicle:pursuit(self.target)
    end)
    menu:addChild(label)

    menu:alignItemsVertically()
    menu:setPosition(display.width*0.9, 150)


    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        

    end ,cc.Handler.EVENT_TOUCH_BEGAN )
    -- self.touchListener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- self.touchListener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.touchListener, -1)
   
end

function TestSteering:onExit()
end


function TestSteering.createWithData(data)
    local scene = TestSteering.new()
    scene:init(data)
    return scene
end
function TestSteering.create(config)
    local scene = TestSteering.new()
    scene:init(config)
    return scene
end
return TestSteering
