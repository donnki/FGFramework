local ClanModel = class("ClanModel")
-- local BuildingModel = import(".BuildingModel")
local Tower = import(".TowerModel")

function ClanModel:ctor(player)
	cc(self):addComponent("game.models.components.Renderer"):exportMethods()

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
	
	local id = Engine:nextTag()
	local b = Tower.new({id=id, x=display.cx, y=display.cy}, self)
	self.buildings[id] = b
end

------------
-- 初始化建筑
function ClanModel:initForBattle(battleModel)
	if self.setParent then self:setParent(battleModel) end
	for i,v in ipairs(self.buildings) do
		v:initForBattle(battleModel)
	end
end
return ClanModel