local SoldierModel = require("game.models.SoldierModel")
local HeroModel = require("game.models.HeroModel")

-- 攻击方
local Attacker = class("Attacker")

function Attacker:ctor(battle)
	self.battle = battle
	self.teams = {}
	
	for i=1,TEST_SOLDIER_COUNT do
		local soldier = SoldierModel.new({}, TEAM.attacker, self.battle)
		table.insert(self.teams, soldier)
	end
	
end

return Attacker