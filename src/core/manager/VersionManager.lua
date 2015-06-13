--------------------
--自动更新管理
-----------------
--自动更新的配置
local AutoUpdateConfig = {
	projectManifest = "res/project.manifest",
	localStoragePaths = "update",
}

local VersionManager = class("VersionManager")

local instance = nil
VersionManager.__index = VersionManager
VersionManager.assetsManager = nil
VersionManager.currentVersion = nil
function VersionManager:getInstance()
    if instance == nil then
    	instance  = VersionManager.new()
        instance:init()
    end
    return instance
end

function VersionManager:init()
	self.assetsManager = cc.AssetsManagerEx:create(
		AutoUpdateConfig.projectManifest, 
		cc.FileUtils:getInstance():getWritablePath()..AutoUpdateConfig.localStoragePaths)
    self.assetsManager:retain()


    if not self.assetsManager:getLocalManifest():isLoaded() then
            Log.w("本地manifest文件加载失败，停止更新")
            Engine:getEventManager():dispatchEvent("OnVersionUpdateFailed")
    else
    	local versionManifest = self.assetsManager:getLocalManifest() 
    	self.currentVersion = versionManifest:getVersion()
		Log.i("CurrentVersion: ", self.currentVersion )
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                Log.i("本地manifest文件加载失败，停止更新")
                Engine:getEventManager():dispatchEvent("OnVersionUpdateFailed")
            elseif  eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                local assetId = event:getAssetId()
                local percent = event:getPercent()
                local strInfo = ""

                if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                    strInfo = string.format("Version file: %d%%", percent)
                elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                    strInfo = string.format("Manifest file: %d%%", percent)
                else
                    strInfo = string.format("当前更新进度：%d%%", percent)
                end
                Log.d(strInfo)
                Engine:getEventManager():dispatchEvent("OnVersionUpdateProgress", percent)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                   eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                Log.w("下载manifest文件失败，停止更新")
                Engine:getEventManager():dispatchEvent("OnVersionUpdateFailed")
                
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                   eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                    Log.i("检查及更新完毕。")
                    Engine:getEventManager():dispatchEvent("OnVersionUpdateFinished")
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                    Log.w("资源文件下败失败： ", event:getAssetId(), ", ", event:getMessage())
                    Engine:getEventManager():dispatchEvent("OnVersionUpdateFailed")
            end
        end
        local listener = cc.EventListenerAssetsManagerEx:create(self.assetsManager,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
	end

	
end

function VersionManager:getCurrentVersion()
	return self.currentVersion
end

function VersionManager:checkUpdate()
	self.assetsManager:update()
end
function VersionManager:clear()
	self.assetsManager:release()
end

return VersionManager