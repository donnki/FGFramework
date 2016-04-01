--[[
	战斗模型
]]
require("game.skills.BattleEventConstants")
local BattleSkillAgent = require("game.skills.BattleSkillAgent")

local BattleModel = class("BattleModel")


function BattleModel:ctor()
	laoi = require("laoi")
	cc(self):addComponent("game.models.components.AoiComponent"):init():exportMethods()

	--初始化技能管理器
	self.skillAgent = BattleSkillAgent:sharedInstance()
	self.skillAgent:init()
end

function BattleModel:init(attacker, defender)
	self.attacker = attacker
	self.defender = defender
	self:initUnits()
end

function BattleModel:initUnits()
	self.units = {}

	-- 防守方的建筑单位初始化加入战场
	for i,v in ipairs(self.defender.buildings) do
		self:addUnit(v)
	end
end

function BattleModel:addUnit(unit)
	local pos = unit:getPosition()
	-- print(unit.bid, pos.x, pos.y, unit:getValue("size"),  unit.team, unit.config.unitType)
	self:aoiAdd(unit.bid, pos.x, pos.y, unit:getValue("size"),  unit.team, unit.config.unitType)
	
	self.units[unit.bid] = unit
	
	--注册单位特殊技能
	if unit.config.skills then
		for i,v in ipairs(unit.config.skills) do
			self.skillAgent:registerSkill(v, unit)
		end
	end
end

function BattleModel:getById(id)
	return self.units[id]
end

function BattleModel:update()
	self.skillAgent:update()
	for i,v in pairs(self.units) do
		v:update(Time.delta)
	end
end
return BattleModel