local Unit = require("game.models.UnitModel")
local Soldier = class("Soldier", Unit)

function Soldier:ctor(proto)
	Soldier.super.ctor(self, proto)
	self:initComponents()
	

	self:setPosition(proto.x, proto.y)
	self.id = Engine:nextTag()
	self.hp = 11115
	self.t = 0
end

function Soldier:initComponents()
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
end

function Soldier:getValue(key)
	if key == "size" then
		return 20
	elseif key == "attackRange" then
		return 100
	elseif key == "moveSpeed" then
		return 400 			--每秒钟移动400像素
	end

	return 10
end

function Soldier:isUsingSkill()
	return false
end
function Soldier:isLeading()
	return false
end
function Soldier:initForBattle(battleModel)
	self.battleModel = battleModel
	cc(self):addComponent("game.models.components.AttackComponent"):init(battleModel):exportMethods()
	cc(self):addComponent("game.models.components.MovableComponent"):init(battleModel):exportMethods()
	self:initBehaviorTree()
	-- self:findPath(cc.p(display.cx, display.cy), 1, 50)
end


function Soldier:update(dt)
	if self:checkComponent("game.models.components.MovableComponent") 
		and self:moveByPath() then
		
	end
	
	if self:isRendered() then
		self:getRenderer():update()
	end

	if self.btRoot and self.btRoot:evaluate() then
        self.btRoot:tick(dt)
    end
end

return Soldier