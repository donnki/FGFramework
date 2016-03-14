-----------------
--统一管理本地资源
-----------------
local ResourceLoader = class("ResourceLoader")

local instance = nil
ResourceLoader.__index = ResourceLoader

ResourceLoader.loadingStateString = nil
ResourceLoader.loadingPercent = 0
ResourceLoader.totalLoadResourceCount = 0 
ResourceLoader.currentLoadResourceCount = 0 
ResourceLoader.loadFinished = false
ResourceLoader.loadingTime = 0
ResourceLoader.loadedResources = nil
ResourceLoader.dynamicRes = nil
local _globalResLoaded = false

function ResourceLoader:getInstance()
    if instance == nil then
        instance  = ResourceLoader.new()
        instance:init()
    end
    return instance
end

function ResourceLoader:init()
    Log.d("ResourceLoader初始化本地资源管理器")
    self.loadedResources = {
        spriteFrames = {},              
        textures = {},                  
        armatures = {},              
        audioClips = {},
        audioEffects = {},      
    }
end

function ResourceLoader:prepareLoad(sceneName, dynamicRes)
    self.dynamicRes = dynamicRes
    self.loadingTime = 0
    self.totalLoadResourceCount = 0
    self.currentLoadResourceCount = 0
    self.loadFinished = false
    local loadResources = {
        spriteFrames = {},              
        textures = {},                  
        armatures = {},              
        audioClips = {},
        audioEffects = {},
   }
    if _globalResLoaded == false then
        for k,allRes in pairs(PreloadResources.GlobalRes) do
            for k2,res in pairs(allRes) do
                if not table.arrayContains(self.loadedResources[k], res) then
                    table.insert(loadResources[k], res)
                end
            end
        end
        _globalResLoaded = true
    end

    if PreloadResources[sceneName] then
        for k,allRes in pairs(PreloadResources[sceneName]) do
            for k2,res in pairs(allRes) do
                if not table.arrayContains(self.loadedResources[k], res) then
                    table.insert(loadResources[k], res)
                else
                    Log.d("已存在资源: "..res)
                end
            end
        end
    end

    if dynamicRes then
        for k,allRes in pairs(dynamicRes) do
            for k2,res in pairs(allRes) do
                if not table.arrayContains(self.loadedResources[k], res) then
                    table.insert(loadResources[k], res)
                else
                    Log.d("已存在资源: "..res)
                end
            end
        end
    end
    
    for k,res in pairs(loadResources) do --统计需要加载的资源数目
        self.totalLoadResourceCount = self.totalLoadResourceCount + #res
        
    end
    Log.d(sceneName, "共需要预加载"..self.totalLoadResourceCount.."个资源，现在开始加载：")

    self:startLoadingProgress()
    
    local t = os.clock()
    self:loadRes(loadResources)
    self.loadingTime = self.loadingTime + (os.clock()-t)        --同步加载资源计时
    
end

function ResourceLoader:removeAllUnusedRes()
    Log.d("释放所有未使用资源，需慎用，可能导致一些显示异常")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    -- cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    collectgarbage("collect")
    collectgarbage("collect")
end

function ResourceLoader:removeSceneRes(sceneName)
    if sceneName then
        Log.i("释放", sceneName, "已加载的资源。")
        if self.dynamicRes then
            self:unloadRes(self.dynamicRes)
            self.dynamicRes = nil
        end
        if PreloadResources[sceneName] then
            self:unloadRes(PreloadResources[sceneName])
        end
        -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        self:removeAllUnusedRes()
    end
    
end


function ResourceLoader:startLoadingProgress()
    local scheduler = cc.Director:getInstance():getScheduler()
    schedulerEntry = scheduler:scheduleScriptFunc(function(delta)
        self.loadingTime = self.loadingTime + Time.delta            --异步加载资源计时
        self.loadingPercent = self.totalLoadResourceCount > 0 and self.currentLoadResourceCount/self.totalLoadResourceCount or 1
        if self.currentLoadResourceCount == self.totalLoadResourceCount and not self.loadFinished then
            Log.d("资源加载完毕，共预加载了"..self.currentLoadResourceCount.."个资源，共耗时"..self.loadingTime.."秒。")
            self.loadFinished = true
            Engine:getEventManager():dispatchEvent("OnSceneResourceLoadFinished")
            scheduler:unscheduleScriptEntry(schedulerEntry)
            
        end
    end,0,false)
end

function ResourceLoader:loadExtra(res)
    if self.dynamicRes then
        for k,v in pairs(res) do
            if not self.dynamicRes[k] then self.dynamicRes[k] = {} end
            for k2,v2 in pairs(v) do
                table.insert(self.dynamicRes[k], v2)
            end
        end
    else
        self.dynamicRes = res
    end
    self:loadRes(res, true)
end

function ResourceLoader:loadRes(res, sync)
    if res.spriteFrames then
        for k,v in pairs(res.spriteFrames) do
            if sync then
                cc.Director:getInstance():getTextureCache():addImage(v[2])
                cc.SpriteFrameCache:getInstance():addSpriteFrames(v[1]) 
                self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                table.insert(self.loadedResources.spriteFrames, v[1])
            else
                if type(v) == "table" then
                    cc.Director:getInstance():getTextureCache():addImageAsync(v[2],function(texture)
                        cc.SpriteFrameCache:getInstance():addSpriteFrames(v[1]) 
                        self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                        self.loadingStateString = "Loading SpriteFrame: "..v[1]..", Texture: "..v[2]
                        Log.d(self.loadingStateString)
                        table.insert(self.loadedResources.spriteFrames, v[1])
                    end)
                elseif type(v) == "string" then
                    self.loadingStateString = "Loading SpriteFrame: "..v
                    cc.SpriteFrameCache:getInstance():addSpriteFrames(v) 
                    self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                    Log.d(self.loadingStateString)
                    table.insert(self.loadedResources.spriteFrames, v)
                end
            end
        end
    end

    if res.textures then
        for k,texturePath in pairs(res.textures) do
            if sync then
                cc.Director:getInstance():getTextureCache():addImage(texturePath)
                self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                table.insert(self.loadedResources.textures, texturePath)
            else
                cc.Director:getInstance():getTextureCache():addImageAsync(texturePath,function()
                    self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                    self.loadingStateString = "Loading Texture: "..texturePath
                    table.insert(self.loadedResources.textures, texturePath)
                    Log.d(self.loadingStateString)
                end)
            end
        end
    end

    if res.armatures then
        for k,path in pairs(res.armatures) do
            if sync then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
                self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                table.insert(self.loadedResources.armatures, path)
            else
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(path, function()
                    self.currentLoadResourceCount = self.currentLoadResourceCount + 1
                    self.loadingStateString = "Loading Armature:  "..path
                    table.insert(self.loadedResources.armatures, path)
                    Log.d(self.loadingStateString)
                end)
            end
            
        end
    end

    if res.audioClips then
        for k,path in pairs(res.audioClips) do
            self.loadingStateString = "Loading Music: "..path
            Log.d(self.loadingStateString)
            AudioEngine.preloadMusic(path)
            self.currentLoadResourceCount = self.currentLoadResourceCount + 1
            table.insert(self.loadedResources.audioClips, path)

        end
    end

    if res.audioEffects then
        for k,path in pairs(res.audioEffects) do
            self.loadingStateString = "Loading Effects: "..path
            Log.d(self.loadingStateString)
            AudioEngine.preloadEffect(path)
            self.currentLoadResourceCount = self.currentLoadResourceCount + 1
            table.insert(self.loadedResources.audioEffects, path)
        end
    end

    if res.extraLoadingHandler then
    end
end

function ResourceLoader:unloadRes(res)
    if res.spriteFrames then
        for k,v in pairs(res.spriteFrames) do
            if type(v) == "table" then
                -- cc.Director:getInstance():getTextureCache():removeTextureForKey(v[2])
                cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v[1])
                table.remove(self.loadedResources.spriteFrames, table.arrayContains(self.loadedResources.spriteFrames,v[1]))

            elseif type(v) == "string" then
                cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v)
                table.remove(self.loadedResources.spriteFrames, table.arrayContains(self.loadedResources.spriteFrames,v))
            end
            Log.d("Remove: ", dump(v))
        end
    end

    if res.textures then
        for k,texturePath in pairs(res.textures) do
            cc.Director:getInstance():getTextureCache():removeTextureForKey(texturePath)
            table.remove(self.loadedResources.textures, table.arrayContains(self.loadedResources.textures,texturePath))
            Log.d("Remove: ", texturePath)
        end
    end

    if res.armatures then
        for k,path in pairs(res.armatures) do
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(path)
            table.remove(self.loadedResources.armatures, table.arrayContains(self.loadedResources.armatures,path))
            Log.d("Remove armatures: ", path)
        end
    end

    if res.audioEffects then
        for k,path in pairs(res.audioEffects) do
            AudioEngine.unloadEffect(path)
            table.remove(self.loadedResources.audioEffects, table.arrayContains(self.loadedResources.audioEffects,path))
            Log.d("Remove: ", path)
        end
    end
    
end

function ResourceLoader:loadJsonConfig(path)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == targetPlatform then
    elseif cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
    end

    if cc.FileUtils:getInstance():isFileExist(path) then
        return json.decode(cc.FileUtils:getInstance():getStringFromFile(path))
    else
        Log.e("File: "..path.." not Found!")
    end
end

function ResourceLoader:saveTextToFile(filename, text)
    local path = cc.FileUtils:getInstance():getWritablePath()..filename
    local file, err = io.open(path, "wb")
    if file then
        file:write(text)
        file:flush()
        -- file.close()
    end
end

return ResourceLoader