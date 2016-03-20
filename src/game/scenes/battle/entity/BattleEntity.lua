local ClanEntity = import(".ClanEntity")
local BattleEntity = class("BattleEntity", function()
	return cc.Node:create()
end)


function BattleEntity:ctor(model)
	self.model = model

	self.clanEntity = ClanEntity.new(self.model.defender.clan)
end


function BattleEntity:update(delta)
	self.model:update(delta)
end

return BattleEntity