
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/UIs/")

require "config"
require "cocos.init"
require "framework.init"
require "core.init"
require "game.GameConfig"
require "game.GameResources"
local DataManager = require "game.GameDataModel"

local function main()
	cc.Director:getInstance():setAnimationInterval(1/60)

    Engine.dataManager = DataManager:getInstance()

    -- local DemoScene = require("game.demo.DemoScene")
    -- Engine:changeScene(DemoScene.create())

	local TestScene = require("TestScene")
    Engine:changeScene(TestScene.createWithData())

    -- local TestRecorderScene = require("TestRecorderScene")
    -- Engine:changeScene(TestRecorderScene.create())


    -- local gate = cc.WebSocket:create("ws://localhost:3014")
    
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
