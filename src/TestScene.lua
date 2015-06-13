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
    end)
    menu:addChild(label)



    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Buy Item", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call nativePurchaseItem")
        nativePurchaseItem("com.banabala.runpuppyrun.diamond40")

    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show Achievement", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call nativeShowAchievements")
        nativeShowAchievements()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Show Leaderboard", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i("call nativeShowLeaderboards")
        nativeShowLeaderboards()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Native Get UDID", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        Log.i(nativeGetUDID())
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
