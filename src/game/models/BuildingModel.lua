local UnitModel = require("game.models.UnitModel")
local BuildingNode = require("game.scenes.battle.view.BuildingNode")

local BuildingModel = class("BuildingModel", UnitModel)

function BuildingModel:initConfigData()
	self.config = {
		size = 50,
	}
end

function BuildingModel:genTestRender()
	local render = BuildingNode.new(self)
	self:bindRenderer(render)
	return render
end

return BuildingModel