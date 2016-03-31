local TestBattleScene = class("TestBattleScene" , SceneBase)
local Attacker = require("game.models.Attacker")
local Defender = require("game.models.Defender")
local BattleModel = require("game.models.BattleModel")
local SoldierNode = require("game.scenes.battle.view.SoldierNode")
local BuildingNode = require("game.scenes.battle.view.BuildingNode")
local SoldierModel = require("game.models.SoldierModel")

TestBattleScene.__index = TestBattleScene
TestBattleScene.name = "TestBattleScene"

TEST_SOLDIER_COUNT = 1
local tmpbox = nil
local count, timer = 0, 0
function TestBattleScene:init(config)
    SceneBase.init(self)
    Log.d("TestBattleScene初始化临时测试场景")
    
    
    self.battle = require("game.models.BattleModel").new()
    self.attacker = Attacker.new(self.battle)
    self.defender = Defender.new(self.battle)
    self.battle:init(self.attacker, self.defender)

    for i,v in ipairs(self.defender.buildings) do
        self:addChild(v:genTestRender())
    end
end

function TestBattleScene:update(dt)
    self.battle:update(dt)
end

function TestBattleScene:onEnter()
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
        if self.soldier == nil then
            local pos = touch:getLocation()
            for i=1,TEST_SOLDIER_COUNT do
                pos = cc.p(math.random(0, display.width),math.random(0, display.height))
                self.soldier = self.attacker.teams[i]
                self.soldier:setPosition(pos.x, pos.y)
                self.battle:addUnit(self.soldier)
                self:addChild(self.soldier:genTestRender())
            end
            

            self.btNode = bt.debugDisplayTree(self.soldier.ai)
            self.btNode:setPosition(500, 400):scale(0.55)
            self:addChild(self.btNode,1000)
        else
            for i=1,TEST_SOLDIER_COUNT do
                self.attacker.teams[i]:leadToPosition(touch:getLocation())
            end
            
        end
    end ,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.touchListener, -1)
   
    Engine:getEventManager():on("EventAddSoldier", function(soldier)
        self:addChild(soldier:genTestRender())
        -- self.btNode = bt.debugDisplayTree(soldier.ai)
        -- self.btNode:setPosition(500, 400):scale(0.55)
        -- self:addChild(self.btNode,1000)
    end)
    
    -- self.fsm_ = {}
    -- cc(self.fsm_)
    --     :addComponent("components.behavior.StateMachine")
    --     :exportMethods()
    -- self.fsm_ = self.fsm_:setupState({
    --     initial = "green",
    --     events = {
    --       {name = "warn", from = "green", to = "yellow"},
    --       {name = "panic", from = "green", to = "red" },
    --       {name = "calm", from = "red", to = "yellow"},
    --       {name = "clear", from = "yellow", to = "green"},
    --     },
    --     callbacks = {
    --         onbeforestart = function(event) print("[FSM] STARTING UP") end,
    --         onstart = function(event) print("[FSM] READY") end,
    --         onbeforewarn = function(event) print("[FSM] START EVENT: warn!") end,
    --         onbeforepanic = function(event) print("[FSM] START EVENT: panic!") end,
    --         onbeforecalm = function(event) print("[FSM] START EVENT: calm!") end,
    --         onbeforeclear = function(event) print("[FSM] START EVENT: clear!") end,
    --         onwarn = function(event) print("[FSM] FINISH EVENT: warn!", dump(event)) end,
    --         onpanic = function(event) print("~~~ panic!!!!") end,
    --         onchangestate = function(event) print("~~~")end,
    --     }
    -- })
    -- self.fsm_:doEvent("panic", "some msg")
    -- print(self.fsm_:canDoEvent("calm"))
end

function TestBattleScene:onExit()
end


function TestBattleScene.createWithData(data)
    local scene = TestBattleScene.new()
    scene:init(data)
    return scene
end
function TestBattleScene.create(config)
    local scene = TestBattleScene.new()
    scene:init(config)
    return scene
end
return TestBattleScene
