local TestBattleScene = class("TestBattleScene" , SceneBase)
local BSAttacker = require("game.models.BSAttacker")
local BSDefender = require("game.models.BSDefender")
local BattleModel = require("game.models.BattleModel")
local SoldierNode = require("game.scenes.battle.view.SoldierNode")
local BuildingNode = require("game.scenes.battle.view.BuildingNode")
local BSSoldierModel = require("game.models.BSSoldierModel")

TestBattleScene.__index = TestBattleScene
TestBattleScene.name = "TestBattleScene"

TEST_SOLDIER_COUNT = 2
local tmpbox = nil
local count, timer = 0, 0
function TestBattleScene:init(config)
    SceneBase.init(self)
    Log.d("TestBattleScene初始化临时测试场景")
    
    
    self.battle = require("game.models.BattleModel").new()
    self.attacker = BSAttacker.new(self.battle)
    self.defender = BSDefender.new(self.battle)
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
    
    local selectedIndex = 1
    for k,v in pairs(self.attacker.reserveArmy) do
        local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Army"..k, "Helvetica", 30))
        label:setTag(k)
        label:setAnchorPoint(cc.p(0.5, 0.5))
        label:registerScriptTapHandler(function()
            selectedIndex = k
        end)
        menu:addChild(label)
    end
    menu:alignItemsHorizontallyWithPadding(60)
    menu:setPosition(150, 70)

    local box = cc.LayerColor:create(cc.c4b(100,100,100,100));
    box:setContentSize( cc.size(display.width, display.height*0.2) );
    box:setPosition(0, 0)
    self:addChild(box)

    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        local pos = touch:getLocation()
        if cc.rectContainsPoint(box:getBoundingBox(), pos) then
            return 
        end

        if selectedIndex ~= -1 then
            menu:getChildByTag(selectedIndex):setEnabled(false)
            self.attacker:armyToBattle(selectedIndex, pos)

            -- self.btNode = bt.debugDisplayTree(self.soldier.ai)
            -- self.btNode:setPosition(500, 400):scale(0.55)
            -- self:addChild(self.btNode,1000)
        else
            -- for i=1,TEST_SOLDIER_COUNT do
            --     self.attacker.teams[i]:leadToPosition(touch:getLocation())
            -- end
            
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
    
    self.fsm_ = {}
    cc(self.fsm_)
        :addComponent("components.behavior.StateMachine")
        :exportMethods()
    self.fsm_ = self.fsm_:setupState({
        initial = "green",
        events = {
          {name = "warn", from = "green", to = "yellow"},
          {name = "panic", from = "green", to = "red" },
          {name = "calm", from = "red", to = "yellow"},
          {name = "clear", from = "yellow", to = "green"},
        },
        callbacks = {
            onbeforestart = function(event) print("[FSM] STARTING UP") end,
            onstart = function(event) print("[FSM] READY") end,
            onbeforewarn = function(event) print("[FSM] START EVENT: warn!") end,
            onbeforepanic = function(event) print("[FSM] START EVENT: panic!") end,
            onbeforecalm = function(event) print("[FSM] START EVENT: calm!") end,
            onbeforeclear = function(event) print("[FSM] START EVENT: clear!") end,
            onwarn = function(event) print("[FSM] FINISH EVENT: warn!", dump(event)) end,
            onpanic = function(event) print("~~~ panic!!!!") end,
            onchangestate = function(event) print("~~~")end,
        }
    })
    self.fsm_:doEvent("panic", "some msg")
    print(self.fsm_:canDoEvent("panic"))
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
