local LoadingScene = class("LoadingScene" , SceneBase)

LoadingScene.__index = LoadingScene

LoadingScene.SceneClass = nil
LoadingScene.nextSceneParams = nil

LoadingScene.loadingStateLabel = nil
LoadingScene.progressBar = nil
LoadingScene.updateProgresBar = nil
LoadingScene.updateStateLabel = nil

local _checkUpdateFlag = false

function LoadingScene:createForNext(SceneClass, extraLoadingHandler, ertraData, ...)
    local node = LoadingScene.new()
    node.SceneClass = SceneClass
    node.extraLoadingHandler = extraLoadingHandler
    node.extraLoadingData = ertraData
    node.nextSceneParams = {...}
    node:init()
    return node
end

local Tags = {
    progressBar = 17,
    loadingStateLabel = 23,
    tipsLabel = 20
}

function LoadingScene:init()
    SceneBase.init(self)
    self.rootview = cc.CSLoader:createNode("res/UIs/Loading.csb")
    self:addChild(self.rootview)
    self.rootview:setContentSize(display.width,display.height)
    ccui.Helper:doLayout(self.rootview)

    local loadingGroup = self.rootview:getChildByTag(1681)
    self.progressBar = loadingGroup:getChildByTag(1673)
    self.progressBar:setPercent(0)
    self.loadingStateLabel = self.rootview:getChildByTag(23)
    self.loadingStateLabel:setVisible(DEBUG_MODE)
    self.tipsLabel = loadingGroup:getChildByTag(1674)
    -- self.tipsLabel:enableOutline(c3b("0x004f05"), 2)

end


function LoadingScene:onEnter()
    --资源加载完毕时的事件
    Engine:getEventManager():registerEventHandler("OnSceneResourceLoadFinished", function()
        
        self.loadingStateLabel:setString(Engine:getResourceLoader().loadingStateString)
        if self.extraLoadingHandler then
            self.extraLoadingHandler(self.extraLoadingData)
        end
        local scene = self.SceneClass.createWithData(self.nextSceneParams)
        Engine:changeScene(scene)
    end)

    if _checkUpdateFlag == false then  

        _checkUpdateFlag = true
        --更新进度改变的事件
        Engine:getEventManager():registerEventHandler("OnVersionUpdateProgress", function(progress)
            if self.updateProgresBar then
                self.updateProgresBar:setPercent(progress)
                self.updateStateLabel:setString("更新进度:"..progress.."%")
            end
        end)

        Engine:getEventManager():registerEventHandler("OnVersionUpdateFailed", function()
            Log.i("连接更新服务器失败，直接加载资源")
            if self.updateProgresBar then
                self.updateProgresBar:setPercent(0)
            end
            Engine:getResourceLoader():prepareLoad(self.SceneClass.__cname)
        end)

        

        --检查及更新的事件
        Engine:getEventManager():registerEventHandler("OnVersionUpdateFinished", function()
            self.loadingStateLabel:setString(Engine:getResourceLoader().loadingStateString)
            if self.updateProgresBar then
                self.updateProgresBar:setPercent(100)
                self.updateStateLabel:setString("检查更新完毕")
            end
            Engine:getResourceLoader():prepareLoad(self.SceneClass:getName())
        end)
        Engine:getVersionManager():checkUpdate()
    else
        Engine:getResourceLoader():prepareLoad(self.SceneClass.__cname)
    end
end


function LoadingScene:update()
    self.loadingStateLabel:setString(Engine:getResourceLoader().loadingStateString)
    self.progressBar:setPercent(Engine:getResourceLoader().loadingPercent*100)
end

function LoadingScene:onExit()
    Engine:getEventManager():removeEventHandler("OnSceneResourceLoadFinished")
end

return LoadingScene