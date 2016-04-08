local BSUnitModel = require("game.models.BSUnitModel")
local SoldierNode = require("game.scenes.battle.view.SoldierNode")
local BSSoldierModel = class("BSSoldierModel", BSUnitModel)


function BSSoldierModel:initComponents()
	BSSoldierModel.super.initComponents(self)
	self:addComponent("game.models.components.AttackComponent"):init(self.battle):exportMethods()
	self:addComponent("game.models.components.MovableComponent"):init(self.battle):exportMethods()

end

function BSSoldierModel:initConfigData()
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
	}
end

function BSSoldierModel:genTestRender()
	local render = SoldierNode.new(self)
	self:bindRenderer(render)
	return render
end


function BSSoldierModel:isUsingSkill()
	return self.usingSkill
end

function BSSoldierModel:useSkill()
	self.usingSkill = true
	return true
end

function BSSoldierModel:onSkillFinished()
	self.usingSkill = false
end

return BSSoldierModel