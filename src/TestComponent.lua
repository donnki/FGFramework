local TestComponent = class("TestComponent" , SceneBase)
local TowerModel = require("game.models.TowerModel")
local SoldierModel = require("game.models.SoldierModel")
local BattleModel = require("game.models.BattleModel")
local SoldierNode = require("game.scenes.battle.view.SoldierNode")
local BuildingNode = require("game.scenes.battle.view.BuildingNode")
TestComponent.__index = TestComponent
TestComponent.name = "TestComponent"

local tmpbox = nil
local count, timer = 0, 0
function TestComponent:init(config)
    SceneBase.init(self)
    Log.d("TestComponent初始化临时测试场景")
    self.battle = require("game.models.BattleModel").new()

    
end

function TestComponent:update(dt)
    self.battle:update(dt)
end

function TestComponent:onEnter()
    local menu = cc.Menu:create()
    self:addChild(menu, 10)
    
    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("test", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
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

function TestComponent:onExit()
end


function TestComponent.createWithData(data)
    local scene = TestComponent.new()
    scene:init(data)
    return scene
end
function TestComponent.create(config)
    local scene = TestComponent.new()
    scene:init(config)
    return scene
end
return TestComponent
