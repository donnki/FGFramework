local SoldierModel = require("game.models.SoldierModel")
local BuildingModel = require("game.models.BuildingModel")
local TowerModel = require("game.models.TowerModel")
local DefenseCampModel = require("game.models.DefenseCampModel")

local Defender = class("Defender")


function Defender:ctor(battle)
	self.battle = battle
	self.buildings = {}
	self.soldiers = {}
	
	local tower = TowerModel.new({x=display.cx, y=display.cy}, TEAM.defender, self.battle)
	table.insert(self.buildings, tower)

	local camp = DefenseCampModel.new({x=display.width*0.8, y=display.height*0.8}, TEAM.defender, self.battle)
	table.insert(self.buildings, camp)
end

function Defender:addSoldier(s)
	table.insert(self.soldiers, s)
	self.battle:addUnit(s)
	Engine:getEventManager():fire("EventAddSoldier", s)
end

return Defender