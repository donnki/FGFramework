local Unit = require("game.models.UnitModel")
local Building = class("Building", Unit)

function Building:ctor(proto, clan)
	Building.super.ctor(self, proto, clan)
	self.clan = clan
	self:setPosition(proto.x, proto.y)
end

------------
-- 战斗初始化接口
function Building:initForBattle(battleModel)
	-- 单位的尺寸
	self.size = self:getValue("size")

	--aoi
	local tag = battleModel:aoiAdd(pos.x, pos.y, self.size)
	self:setTag(tag)
	
	--行为树
	self:initBehaviorTree()
end


------------
-- 取得各种数值，如攻击力、攻击间隔等
function Building:getValue(key)
	return 10
end

return Building