local BuildingModel = require("game.models.BuildingModel")
local TowerModel = class("TowerModel", BuildingModel)

function TowerModel:initConfigData()
	self.config = {
		ai = "src/game/test/ai_tower.json",
		size = 50,
		attackRangeMax = 200,
		attackRangeMin = 0,
		atkCD = 5,
		aimTime = 0.2,
		afterAttackDelay = 1,
		beforeAttackDelay = 1,
		unitType = UNIT_TYPE.building
	}
end

function TowerModel:initComponents()
	TowerModel.super.initComponents(self)
	cc(self):addComponent("game.models.components.AttackComponent"):init(self.battle):exportMethods()
end

return TowerModel