local ClanModel = class("ClanModel")
-- local BuildingModel = import(".BuildingModel")
local Tower = import(".TowerModel")

function ClanModel:ctor(player)
	self.player = player
	self:load()
end

-------------
-- 由本地或网络加载部落数据
function ClanModel:load()
	-- 必要的数据全部加载完成后，执行init初始化
	self:init()

end


------------
-- 初始化建筑等数据
function ClanModel:init()
	self:initBuildings()
end


------------
-- 初始化建筑
function ClanModel:initBuildings()
	self.buildings = {}

	local b = Tower.new({x=display.cx, y=display.cy})
	table.insert(self.buildings, b)
end

------------
-- 初始化建筑
function ClanModel:initForBattle(battleModel)
	for i,v in ipairs(self.buildings) do
		v:initForBattle(battleModel)
	end
end
return ClanModel