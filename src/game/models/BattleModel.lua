--[[
	战斗模型
]]
local BattleModel = class("BattleModel")

function BattleModel:ctor(attacker, defender)
	self.attacker = attacker
	self.defender = defender

	laoi = require("laoi")
	cc(self):addComponent("game.models.components.Aoi"):exportMethods()

	self:init()
end

function BattleModel:init()
	self.defender.clan:initForBattle(self)
end


function BattleModel:update()
end
return BattleModel