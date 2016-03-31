local TowerModel = require("game.models.TowerModel")
local SoldierModel = require("game.models.SoldierModel")

local DefenseCampModel = class("DefenseCampModel", TowerModel)


function DefenseCampModel:doFire()
	local pos = self:getPosition()
	local soldier = SoldierModel.new({x=pos.x, y = pos.y}, TEAM.defender, self.battle)
	self.battle.defender:addSoldier(soldier)
end

return DefenseCampModel