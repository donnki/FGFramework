local TestScene = class("TestScene" , SceneBase)

TestScene.__index = TestScene
TestScene.name = "TestScene"
local tmpbox = nil

function TestScene:init(config)
    SceneBase.init(self)

    Log.d("TestScene初始化临时测试场景")
    local layer = cc.Layer:create()
    layer:setTag(1024)
    self:addChild(layer)

    tmpbox = cc.LayerColor:create(cc.c4b(100,100,255,255));
    tmpbox:setContentSize(10,10);
    tmpbox:setPosition(display.cx,display.cy)
    layer:addChild(tmpbox)


    local box = cc.LayerColor:create(cc.c4b(100,100,150,100));
    box:setContentSize( cc.size(display.width,display.height) );
    box:setPosition(0,0)
    layer:addChild(box)

    -- local t = ccs.GUIReader:getInstance():widgetFromJsonFile("res/UIs/GameOver_1.ExportJson")
    -- self:addChild(t)

    local menu = cc.Menu:create()
    layer:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show AD", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        native.showInterstitialAD()
    end)
    menu:addChild(label)



    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Buy Item", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("11call nativePurchaseItem")
        Engine.iap:payForProduct(
            "com.banabala.runpuppyrun.diamond40", 
            function(successResponse)
                Log.t(successResponse)
            end, 
            function(failedResponse)
                Log.t(failedResponse)
            end
        )

    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show Achievement", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("11call nativeShowAchievements")
        Engine.service:showAchievements()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Unlock Achievement", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()

        Log.i("unlock achievement: achievement_prime")
        Engine.service:unlockAchievement(Achievements.achievement_prime)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show Leaderboard", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call nativeShowLeaderboards")
        Engine.service:showLeaderboards()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show Quest", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call showQuests")
        Engine.service:showQuests()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("HTTP doGet", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        http.doGet("http://img3.douban.com/icon/ul3811658-63.jpg", function(response)
            local fileData = response
            local fullFileName = cc.FileUtils:getInstance():getWritablePath() .. "/ul3811658-63.jpg"
            local file = io.open(fullFileName,"wb")
            file:write(fileData)
            file:close()
            local texture2d = cc.Director:getInstance():getTextureCache():addImage(fullFileName)
            local sprite = cc.Sprite:createWithTexture(texture2d)
            sprite:setPosition(display.cx,display.cy)
            self:addChild(sprite)
        end, 0)
    end)
    menu:addChild(label)


    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native addNotification", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call addNotification")
        native.addNotification("Hello", "Hi there", 3)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native statisticEvent", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
       
        native.onStatisticEvent("TestEvent", {a=1234})
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native showLeaderboardByID", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call showLeaderboardByID")
        Engine.service:showLeaderboardByID(Leaderboards.leaderboard_hard)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native submitScore", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call submitScore")
        Engine.service:submitScore(Leaderboards.leaderboard_hard, 2501)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native loadLeaderboardScore", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        native.loadLeaderboardScore(Leaderboards.leaderboard_hard, function(response)
            Log.i(response)
        end)
    end)
    menu:addChild(label)

    menu:alignItemsVertically()

    

end

function TestScene:onEnter()
end

function TestScene:onExit()
end

local t = 0
function TestScene:update(delta)
    -- Log.i(delta)
    t = t + delta*2
    if t > 2 * math.pi then
        t = 0 
    end
    local x, y = tmpbox:getPosition()
    x = 150 * math.cos(t)
    y = 150 * math.sin(t)
    tmpbox:setPosition(display.cx + x, display.cy + y)
end

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
