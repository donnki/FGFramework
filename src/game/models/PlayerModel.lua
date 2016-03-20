local PlayerModel = class("PlayerModel")
local ClanModel = import(".ClanModel")
function PlayerModel:ctor(playerID)
    self.id = playerID and playerID or 0
    self:load()

    
end

-------------
-- 由本地或网络加载玩家数据
function PlayerModel:load()
	-- 加载玩家数据完成后，开始加载部落数据
	
	self.clan = ClanModel.new(self)

	-- 必要的数据全部加载完成后，执行init初始化
	self:init()
end


------------
-- 初始化英雄、小兵等数据
function PlayerModel:init()
end

return PlayerModel