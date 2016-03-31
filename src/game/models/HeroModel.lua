local SoldierModel = require("game.models.SoldierModel")
local HeroModel = class("HeroModel", SoldierModel)

function HeroModel:initConfigData()
	self.config = {
		ai = "src/game/test/ai_attack_unit.json",
		size = 30,
		attackRange = 100,
		atkCD = 2,
		aimTime = 0.2,
		afterAttackDelay = 0,
		beforeAttackDelay = 0,
		moveSpeed = 400,
		unitType = UNIT_TYPE.movable,
	}
end

function HeroModel:isUsingSkill()
	return false
end

function HeroModel:isLeading()
	return false
end

return HeroModel