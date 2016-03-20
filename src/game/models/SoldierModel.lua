local Unit = require("game.models.UnitModel")
local Soldier = class("Soldier", Unit)

function Soldier:ctor(proto)
	Soldier.super.ctor(self, proto)
end

function Soldier:initComponents()
	cc(self):addComponent("game.models.components.AttackComponent"):exportMethods()
	cc(self):addComponent("game.models.components.MovableComponent"):exportMethods()
end

function Soldier:initBehaviorTree()
	local bt = require("core.bt.BTInit")
	self.btRoot = bt.loadFromJson("src/game/test/ai_attack_unit.json", self)
	self.btRoot:activate(self)
end


return Soldier