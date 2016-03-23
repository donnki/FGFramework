local Unit = require("game.models.UnitModel")
local Soldier = class("Soldier", Unit)

function Soldier:ctor(proto)
	Soldier.super.ctor(self, proto)
	self:initComponents()

	self:setPosition(proto.x, proto.y)
	self.id = Engine:nextTag()
	self.size = 0
	self.hp = 5
	self.t = 0
end

function Soldier:initComponents()
	-- cc(self):addComponent("game.models.components.AttackComponent"):exportMethods()
	-- cc(self):addComponent("game.models.components.MovableComponent"):exportMethods()
	cc(self):addComponent("game.models.components.Renderer")
		:setRenderer("game.scenes.battle.view.SoldierNode")
		:exportMethods()
end

function Soldier:initBehaviorTree()
	local bt = require("core.bt.BTInit")
	self.btRoot = bt.loadFromJson("src/game/test/ai_attack_unit.json", self)
	self.btRoot:activate(self)
end

function Soldier:hurt()
	self.hp = self.hp - 1
	if self.hp <= 0 then
		self.isDead = true
		self:getRenderer():setVisible(false)

	end
	print("~~~~~~",self.t )
end


function Soldier:update(dt)
	self.t = self.t + dt
end
return Soldier