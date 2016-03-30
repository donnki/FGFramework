--[[
	战斗模型
]]
local BattleModel = class("BattleModel")

function BattleModel:ctor(attacker, defender)
	self.attacker = attacker
	self.defender = defender

	self.units = {}
	laoi = require("laoi")
	cc(self):addComponent("game.models.components.Aoi"):init():exportMethods()
	cc(self):addComponent("game.models.components.Renderer"):exportMethods()
	self:init()
end

function BattleModel:init()
	self.defender.clan:initForBattle(self)
end

function BattleModel:addUnit(unit, shouldInit, team, type_)
	if self.setParent then
		unit:setParent(self.defender.clan)
	end
	local pos = unit:getPosition()
	self:aoiAdd(unit.id, pos.x, pos.y, unit:getValue("size"),  team, type_)
	
	if self.units[unit.id] then
		Log.w("ID不唯一, 单位已存在！")
	end
	self.units[unit.id] = unit
	if shouldInit then
		unit:initForBattle(self)
	end
end

function BattleModel:getById(id)
	return self.units[id]
end

function BattleModel:update()
	for i,v in pairs(self.units) do
		v:update(Time.delta)
	end
end
return BattleModel