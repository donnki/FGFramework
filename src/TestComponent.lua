local TestComponent = class("TestComponent" , SceneBase)
local TowerModel = require("game.models.TowerModel")
local SoldierModel = require("game.models.SoldierModel")
TestComponent.__index = TestComponent
TestComponent.name = "TestComponent"

local tmpbox = nil

function TestComponent:init(config)
    SceneBase.init(self)
    Log.d("TestComponent初始化临时测试场景")

    local player = require("game.models.PlayerModel").new()
    
    -- self.battleNode = BattleEntity.new()
    -- self:addChild(self.battleNode)
    self.battle = require("game.models.BattleModel").new(player, player)
    self.battleField = self.battle:getRenderer()
    self:addChild(self.battleField)

    local node = bt.debugDisplayTree(self.battle.defender.clan.buildings[1].btRoot)
    node:setPosition(500, 200):scale(0.55)
    self:addChild(node)
end

function TestComponent:update(dt)
    self.battle:update(dt)
end

function TestComponent:onEnter()
    local menu = cc.Menu:create()
    self:addChild(menu, 10)
    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("addRandomNode", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()

       
    end)
    menu:addChild(label)
    menu:alignItemsVertically()
    menu:setPosition(display.width*0.9, 50)


    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        local unit = SoldierModel.new({x = touch:getLocation().x, y = touch:getLocation().y})
        self.battle:addUnit(unit)

    end ,cc.Handler.EVENT_TOUCH_BEGAN )
    -- self.touchListener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- self.touchListener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.touchListener, -1)
   
end

function TestComponent:onExit()
end

-- local t = 0
-- function TestComponent:update(delta)
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
