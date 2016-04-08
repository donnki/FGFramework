local BSUnitModel = require("game.models.BSUnitModel")
local BuildingNode = require("game.scenes.battle.view.BuildingNode")

local BSBuildingModel = class("BSBuildingModel", BSUnitModel)

function BSBuildingModel:initConfigData()
	self.config = {
		size = 50,
	}
end

function BSBuildingModel:genTestRender()
	local render = BuildingNode.new(self)
	self:bindRenderer(render)
	return render
end

return BSBuildingModel