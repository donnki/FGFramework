local BSTowerModel = require("game.models.BSTowerModel")
local BSSoldierModel = require("game.models.BSSoldierModel")

local BSDefenseCampModel = class("BSDefenseCampModel", BSTowerModel)


function BSDefenseCampModel:doFire()
	local pos = self:getPosition()
	local soldier = BSSoldierModel.new({x=pos.x, y = pos.y}, TEAM.defender, self.battle)
	self.battle.defender:addSoldier(soldier)
end

return BSDefenseCampModel