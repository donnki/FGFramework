--[[
    GameService登录、成就、排行榜管理
]]
local GameServiceManager = class("GameServiceManager")

local instance = nil
GameServiceManager.__index = GameServiceManager

function GameServiceManager:getInstance()
    if instance == nil then
        instance  = GameServiceManager.new()
        instance:init()
    end
    return instance
end

function GameServiceManager:init()
end

function GameServiceManager:showAchievements()
    native.showAchievements()
end

function GameServiceManager:showLeaderboards()
    native.showLeaderboards()
end

--[[
    显示排行榜, span可选值
        1：日榜
        2：周榜
        其它值：总榜
]]
function GameServiceManager:showLeaderboardByID(id, span)
    -- Log.i("showLeaderboardByID, ", id)
    native.showLeaderboardByID(id, span)
end

function GameServiceManager:submitScore(lid, score)
    -- Log.i("showLeaderboardByID, ", id)
    Log.todo("检查本地是否已是最高纪录")
    native.leaderboardSubmitScore(lid, score)
end

function GameServiceManager:unlockAchievement(achievementID)
    -- Log.i("GameServiceManager, ", achievementID)
    Log.todo("检查本地是否已解锁该成就")
    native.unlockAchievement(achievementID)
end

function GameServiceManager:showQuests()
    native.showQuests()
end


return GameServiceManager