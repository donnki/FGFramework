
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/UIs/")

require "config"
require "cocos.init"
require "core.init"
require "game.GameResources"
local DataManager = require "game.GameDataModel"

local function main()
	cc.Director:getInstance():setAnimationInterval(1/60)

    Engine.dataManager = DataManager:getInstance()

	local TestScene = require("TestScene")
    Engine:changeScene(TestScene.createWithData())

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
