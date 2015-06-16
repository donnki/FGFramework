-----------------
--游戏数据管理器
--通过其实例可以读取所有Model的数据
-----------------

local GameDataModel = class("GameDataModel")

local instance = nil
GameDataModel.__index = GameDataModel


function GameDataModel:getInstance()
    if instance == nil then
        instance = GameDataModel.new()
        instance:init()
    end
    return instance
end

function GameDataModel:init()
    Log.d("GameDataModel初始化数据管理器")
end



return GameDataModel