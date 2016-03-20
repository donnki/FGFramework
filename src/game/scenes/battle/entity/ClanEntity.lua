local TowerEntity = import(".TowerEntity")
local ClanEntity = class("ClanEntity", function()
	return cc.Node:create()
end)


function ClanEntity:ctor(model)
	self.model = model
end

function ClanEntity:init()
	for i,v in ipairs(self.model.buildings) do
		local tower = TowerEntity.new(v)
		self:addChild(tower)
	end
end

function ClanEntity:update(delta)
end

return ClanEntity