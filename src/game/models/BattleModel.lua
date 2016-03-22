--[[
	战斗模型
]]
local BattleModel = class("BattleModel")

function BattleModel:ctor(attacker, defender)
	self.attacker = attacker
	self.defender = defender

	self.units = {}
	laoi = require("laoi")
	cc(self):addComponent("game.models.components.Aoi"):exportMethods()
	cc(self):addComponent("game.models.components.Renderer"):exportMethods()
	self:init()
end

function BattleModel:init()
	self.defender.clan:initForBattle(self)
end

function BattleModel:addUnit(unit)
	if self.setParent then
		unit:setParent(self.defender.clan)
	end

	local pos = unit:getPosition()
	self:aoiAdd(unit.id, pos.x, pos.y, unit.size)
	
	if self.units[unit.id] then
		Log.w("ID不唯一, 单位已存在！")
	end
	self.units[unit.id] = unit

	
end

function BattleModel:update()
	for i,v in pairs(self.units) do
		v:update(Time.delta)
	end
end
return BattleModel