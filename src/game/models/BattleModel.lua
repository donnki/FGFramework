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

---------------
-- 初始化单位
function BattleModel:initUnits()
	self.units = {}

	-- 防守方的建筑单位初始化加入战场
	for i,v in ipairs(self.defender.buildings) do
		self:addUnit(v)
	end
end


-------------
-- 为战场增加单位
function BattleModel:addUnit(unit)
	local pos = unit:getPosition()
	-- print(unit.bid, pos.x, pos.y, unit:getValue("size"),  unit.team, unit.config.unitType)
	self:aoiAdd(unit.bid, pos.x, pos.y, unit:getValue("size"),  unit.team, unit.config.unitType)
	
	self.units[unit.bid] = unit

	if unit.config.unitType == UNIT_TYPE.movable then
		Engine:getEventManager():fire("EventAddSoldier", unit)
	end
	
	--注册单位特殊技能
	if unit.config.skills then
		for i,v in ipairs(unit.config.skills) do
			self.skillAgent:registerSkill(v, unit)
		end
	end
end

--------------
-- 根据ID取得单位
function BattleModel:getById(id)
	return self.units[id]
end

--------------
-- 当单位被消灭时
function BattleModel:unitDie(id)
	-- 从AOI中移除对象
	self:aoiDelete(id)
	
	if self.units[id].team == TEAM.attacker then
		self.attacker:onUnitDead()
	end

	-- 从本地保存的数组中移除对象
	self.units[id] = nil
end

function BattleModel:update()
	self.skillAgent:update()
	for i,v in pairs(self.units) do
		v:update(Time.delta)
	end
end
return BattleModel