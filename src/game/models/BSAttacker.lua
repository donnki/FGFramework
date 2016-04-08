local BSArmyModel = require("game.models.BSArmyModel")

-- 攻击方
local BSAttacker = class("BSAttacker")

function BSAttacker:ctor(battle)
	self.battle = battle
	self.reserveArmy = {} 		--备用军队
	self.battleUnitCount = 0 	--战场上的所属单位数目
	self.commanderPoint = 0 	--指挥点数
	
	for i=1,TEST_SOLDIER_COUNT do
		self:addReserveArmy(i)
	end
end

----------
-- 增加备用军队
function BSAttacker:addReserveArmy(key)
	local army = BSArmyModel.new({}, TEAM.attacker, self.battle)
	self.reserveArmy[key] = army
end

----------
-- 将指定备用军队加入战场
function BSAttacker:armyToBattle(armyKey, pos)
	local army = self.reserveArmy[armyKey]
	if army then
		local unitNum = army:sendToBattle(pos)
		self.battleUnitCount = self.battleUnitCount + unitNum

		self.reserveArmy[armyKey] = nil
		return true
	else
		return false
	end
end

----------
-- 当有单位死亡
function BSAttacker:onUnitDead()
	self.battleUnitCount = self.battleUnitCount - 1
end
return BSAttacker