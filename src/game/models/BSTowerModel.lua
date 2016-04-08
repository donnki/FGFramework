local BSBuildingModel = require("game.models.BSBuildingModel")
local BSTowerModel = class("BSTowerModel", BSBuildingModel)

function BSTowerModel:initConfigData()
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

function BSTowerModel:initComponents()
	BSTowerModel.super.initComponents(self)
	self:addComponent("game.models.components.AttackComponent"):init(self.battle):exportMethods()
end

return BSTowerModel