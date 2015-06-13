--[[
    GameService登录、成就、排行榜管理
]]
local GameServiceManager = class("GameServiceManager")

local Achievements = {
    achievement_prime = "CgkIyqPyiYsDEAIQAw",
    achievement_really_bored = "CgkIyqPyiYsDEAIQBA",
    achievement_bored = "CgkIyqPyiYsDEAIQBQ",
    achievement_humble = "CgkIyqPyiYsDEAIQBg",
    achievement_arrogant = "CgkIyqPyiYsDEAIQBw",
    achievement_leet = "CgkIyqPyiYsDEAIQCA",
}
  
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
end

function GameServiceManager:showLeaderboards()
end


return GameServiceManager