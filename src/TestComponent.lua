local TestComponent = class("TestComponent" , SceneBase)
local TowerModel = require("game.models.TowerModel")
local SoldierModel = require("game.models.SoldierModel")
require("game.skills.BattleSkillConstants")
local BattleSkillAgent = require("game.skills.BattleSkillAgent")
local BattleBuffAgent = require("game.buffs.BattleBuffAgent")
TestComponent.__index = TestComponent
TestComponent.name = "TestComponent"

local tmpbox = nil
local count, timer = 0, 0
function TestComponent:init(config)
    SceneBase.init(self)
    Log.d("TestComponent初始化临时测试场景")

    local player = require("game.models.PlayerModel").new()
    
    -- self.battleNode = BattleEntity.new()
    -- self:addChild(self.battleNode)
    self.battle = require("game.models.BattleModel").new(player, player)
    self.battleField = self.battle:getRenderer()
    self:addChild(self.battleField)


    -- local skill001 = require("game.skills.skill001")
    -- skill001.condition("asdf","~~~~~")
    print(BattleEvents.onHeroEnterBattle)
    self.skillAgent = BattleSkillAgent:sharedInstance()
    self.buffAgent = BattleBuffAgent.new(self)

    self.skillAgent:init()
    self.skillAgent:registerSkill("skill001",self)
    self.skillAgent:registerSkill("skill002",self)
    self.skillAgent:registerSkill("skill003",self)
end

function TestComponent:update(dt)
    self.battle:update(dt)
    self.skillAgent:update(dt)
    self.buffAgent:update(dt)
end

function TestComponent:onEnter()
    local menu = cc.Menu:create()
    self:addChild(menu, 10)
    
    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("释放技能", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self.skillAgent:onEvent(BattleEvents.onHeroEnterBattle, "skill002")
    end)
    menu:addChild(label)
    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("打断技能", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self.skillAgent:onEvent(BattleEvents.onInterruptHeroSkill,self, "skill003")
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("加buff", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self.buffAgent:addBuff("buff003")
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("触发BUFF事件", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        self.buffAgent:onEvent(BattleEvents.onShotTarget)
    end)
    menu:addChild(label)

    menu:alignItemsVertically()
    menu:setPosition(display.width*0.9, 150)


    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        self.unit = SoldierModel.new({x = touch:getLocation().x, y = touch:getLocation().y})
        self.battle:addUnit(self.unit, true, TEAM.attacker, UNIT_TYPE.movable)

        local node = bt.debugDisplayTree(self.unit.btRoot)
        node:setPosition(500, 400):scale(0.55)
        self:addChild(node)

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
    -- status, value = coroutine.resume(co2)  
    -- if value then
    --     print('coroutine:',status, value) 
    -- end
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
