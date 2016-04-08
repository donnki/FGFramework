local BSSoldierModel = require("game.models.BSSoldierModel")
local BSBuildingModel = require("game.models.BSBuildingModel")
local BSTowerModel = require("game.models.BSTowerModel")
local BSDefenseCampModel = require("game.models.BSDefenseCampModel")

local BSDefender = class("BSDefender")


function BSDefender:ctor(battle)
	self.battle = battle
	self.buildings = {}
	self.soldiers = {}
	
	local tower = BSTowerModel.new({x=display.cx, y=display.cy}, TEAM.defender, self.battle)
	table.insert(self.buildings, tower)

	local camp = BSDefenseCampModel.new({x=display.width*0.8, y=display.height*0.8}, TEAM.defender, self.battle)
	table.insert(self.buildings, camp)
end

function BSDefender:addSoldier(s)
	table.insert(self.soldiers, s)
	self.battle:addUnit(s)
end

return BSDefender