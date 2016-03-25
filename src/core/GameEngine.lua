local EventManager = require("core.manager.EventManager")
local SoundManager = require("core.manager.SoundManager")
local ResourceLoader = require("core.manager.ResourceLoader")
local VersionManager = require ("core.manager.VersionManager")
local ConfigLoader = require("core.manager.ConfigLoader")
local SocketManager = require("core.network.SocketManager")
local GameServiceManager = require("core.manager.GameServiceManager")
local InAppPurchaseManager = require("core.manager.InAppPurchaseManager")
local DBManager = require("core.manager.DBManager")

PlanScheduler = require("core.plan.PlanScheduler")

UIFactory = require("core.ui.base.UIFactory")
UIRoot = require("core.ui.base.UIRoot")
UIBase = require("core.ui.base.UIBase")


local UIManager = require("core.ui.base.UIManager")


require("core.SceneBase")

-- local BattleScene = require("src/game/scenes/battle/BattleScene")

GameEngine = class("GameEngine")

GameEngine.__index = GameEngine
GameEngine.eventManager = nil
GameEngine.resourceManager = nil
GameEngine.soundManager = nil
GameEngine.UIManager = nil
GameEngine.UIFactory = nil
GameEngine.dataManager = nil
GameEngine.versionManager = nil
GameEngine.socket = nil
GameEngine.service = nil
GameEngine.iap = nil

GameEngine.runningScene = nil
GameEngine.preScene = nil
local engine = nil
local tagIndex = 0
function GameEngine:getInstance()
    if engine == nil then
        engine = GameEngine.new()
    end
    return engine
end

function GameEngine:init()
    if DEBUG_MODE then
        LoggerWindow:getInstance()
    end
    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end
    self.scene = nil
    self.configLoader = ConfigLoader:getInstance()
    self.eventManager = EventManager:getInstance()
    self.resourceManager = ResourceLoader:getInstance()
    self.UIManager = UIManager:getInstance()
    self.soundManager = SoundManager:getInstance()
    self.UIFactory = UIFactory:getInstance()
    self.service = GameServiceManager:getInstance()
    self.iap = InAppPurchaseManager:getInstance()
    self.socket = SocketManager:getInstance()
    self.db = DBManager.new(DB_FILE_PATH)
    -- local result,val = self.db:query("select * from SoldiersData where id='211401'")
    -- print(dump(result))
    self:scheduleMainLoop()
    
    PlanScheduler:getInstance():start()


end


function GameEngine:scheduleMainLoop()
    Log.d("GameEngine启动游戏主循环")
    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:scheduleScriptFunc(function(delta)
        Time.onUpdate(delta)        
        local scene = cc.Director:getInstance():getRunningScene()
        if scene ~= nil and scene.update ~= nil then 
            scene:update(Time.delta, delta)
        end
    end,0,false)
end


-----------------
--游戏场景
-----------------
--[[
function GameEngine:changeScene(param)
    local _scene = TB_Scene[param]
    
    Log.d("GameEngine即将切换至"..sceneTag.."场景")
    self.runningScene = sceneTag
if _scene.type == SceneTag.battle then
        self.eventManager:reset()
        self.resourceManager:clear()
        cc.Director:getInstance():replaceScene(BattleScene.create(param))
    elseif sceneTag == SceneTag.login then
    
    end
    Log.d("GameEngine切换场景"..sceneTag.."完毕")
    
end

--]]

function GameEngine:runWithScene(scene)
    if not scene then return end
    Log.i("GameEngine:runWithScene")
    self.scene = scene
    cc.Director:getInstance():runWithScene(scene)
end


function GameEngine:changeScene(scene)
    if not scene and self.scene == scene then return end
    self.preSceneName = self.scene and self.scene:getName() or nil
    -- tagIndex = 0
    self.scene = scene
    if DEBUG_MODE then
        LoggerWindow:getInstance():removeFromParent()
        self.scene:addChild(LoggerWindow:getInstance(), 99999)
    end 
    PlanScheduler:getInstance():removeAllPlan()
    cc.Director:getInstance():replaceScene(scene)
    Log.i("GameEngine已切换至" ,scene:getName() ,"场景")
    --Log.d("GameEngine切换场景" ,scene:getName() ,"完毕")
    -- self:removeSceneRes(self.preSceneName)
end

function GameEngine:pushScene(scene)
    if not scene and self.scene == scene then return end
    Log.i("GameEngine即将切换至" ,scene:getName() ,"场景")
    self.preSceneName = self.scene and self.scene:getName() or nil
    self.preScene = self.scene
    self.scene = scene
    if DEBUG_MODE then
        LoggerWindow:getInstance():removeFromParent()
        self.scene:addChild(LoggerWindow:getInstance(), 99999)
    end 

    cc.Director:getInstance():pushScene(scene)
    -- self:removeSceneRes(self.preSceneName)
end

function GameEngine:popScene()
    if DEBUG_MODE then
        LoggerWindow:getInstance():removeFromParent()
    end 
    self.preSceneName = self.scene and self.scene:getName() or nil
    Log.i("GameEngine即将Pop至前一场景")
    cc.Director:getInstance():popScene()
    self.scene = self.preScene
    Log.i("GameEngine即将切换至" ,self.scene:getName(),"场景")
    if DEBUG_MODE then
        self.scene:addChild(LoggerWindow:getInstance(), 99999)
    end
    -- self:removeSceneRes(self.preSceneName)
end

function GameEngine:removeSceneRes(sceneName)
    self.resourceManager:removeSceneRes(sceneName)
end

function GameEngine:changeSceneById(sceneId)
    self.SceneMgr(sceneId);
end

function GameEngine:getVersionManager()
    if not self.versionManager then
        self.versionManager = VersionManager:getInstance()
    end
    return self.versionManager
end
function GameEngine:getEventManager()
    return self.eventManager
end

function GameEngine:getUIFactory()
    return self.UIFactory
end
function GameEngine:getDataManager()
    if not self.dataManager then
        Log.w("Engine Data Manager not initicialize yet.")
    end
    return self.dataManager
end

function GameEngine:getResourceLoader()
    return self.resourceManager
end

function GameEngine:getConfigLoader()
    return self.configLoader
end


function GameEngine:getUIManager()
    return self.UIManager
end

function GameEngine:getSoundManager()
    return self.soundManager
end

function GameEngine:getUIControlMgr()
    return self.UIControl
end

function GameEngine:getNetworkManager()
    return self.networkManager
end

function GameEngine:getCurScene()
   -- return cc.Director:getInstance():getRunningScene()
   return self.scene
end

function GameEngine:battleScene()

end

function GameEngine:nextTag()
    tagIndex = tagIndex + 1
    return tagIndex
end

function GameEngine:resetTagIndex()
    tagIndex = 0
end

-----------------
--游戏控制
-----------------


function GameEngine:start()
end

function GameEngine:restart()
end

function GameEngine:pauseGame()
end

function GameEngine:resumeGame()
end
