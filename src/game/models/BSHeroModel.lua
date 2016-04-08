local BSSoldierModel = require("game.models.BSSoldierModel")
local BSHeroModel = class("BSHeroModel", BSSoldierModel)

function BSHeroModel:initConfigData()
	self.config = {
		ai = "src/game/test/ai_attack_unit.json",
		size = 20,
		attackRangeMax = 100,
		attackRangeMin = 0,
		viewRange = 200,
		atkCD = 2,
		aimTime = 0.2,
		afterAttackDelay = 0.5,
		beforeAttackDelay = 0.5,
		moveSpeed = 400,
		unitType = UNIT_TYPE.movable,
		skills = {
			"skill001",
		}
	}
end

return BSHeroModel