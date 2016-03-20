local TestComponent = class("TestComponent" , SceneBase)
local TowerModel = require("game.models.TowerModel")
local TowerEntity = require("game.scenes.battle.entity.TowerEntity")
local BattleEntity = require("game.scenes.battle.entity.BattleEntity")
TestComponent.__index = TestComponent
TestComponent.name = "TestComponent"

local tmpbox = nil

function TestComponent:init(config)
    SceneBase.init(self)
    Log.d("TestComponent初始化临时测试场景")

    local player = require("game.models.PlayerModel").new()
    
    self.battleNode = BattleEntity.new(require("game.models.BattleModel").new(player, player))
    self:addChild(self.battleNode)

    
end

function TestComponent:update(dt)
    self.battleNode:update(dt)
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
