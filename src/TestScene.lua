local TestScene = class("TestScene" , SceneBase)

TestScene.__index = TestScene
TestScene.name = "TestScene"


function TestScene:init(config)
    SceneBase.init(self)

    Log.d("TestScene初始化临时测试场景")
    local layer = cc.Layer:create()
    layer:setTag(1024)
    self:addChild(layer)


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
                Log.i(successResponse)
            end, 
            function(failedResponse)
                Log.i(failedResponse)
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
