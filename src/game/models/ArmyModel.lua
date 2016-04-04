local SoldierModel = require("game.models.SoldierModel")
local HeroModel = require("game.models.HeroModel")

-- 战斗部队模型
local ArmyModel = class("ArmyModel")

function ArmyModel:ctor(params, team, battle)
	self.battle = battle
	self.hero = HeroModel.new({}, team, battle)
	
	self.soldiers = {}

	for i=1,0 do
		local soldier = SoldierModel.new({}, team, battle)
		table.insert(self.soldiers, soldier)
	end
end

-----------
-- 重新设置部队里每个单位的队形位置
function ArmyModel:lineUp(pos)
	self.hero:setPosition(pos.x, pos.y)
end

-----------
-- 部队队单位加入战场
-- 返回加入战场的单位数目
function ArmyModel:sendToBattle(pos)
	self:lineUp(pos)
	local count = 0
	if self.hero then
		self.battle:addUnit(self.hero)
		count = count + 1
	end
	for i,unit in ipairs(self.soldiers) do
		self.battle:addUnit(unit)
		count = count + 1
	end

	self.hero = nil
	self.soldiers = nil

	return count
end

return ArmyModel