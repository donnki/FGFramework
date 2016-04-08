--[[
	战斗模型
]]
require("game.skills.BattleEventConstants")
local BattleSkillAgent = require("game.skills.BattleSkillAgent")

local BattleModel = class("BattleModel")

--是否开启物理引擎（处理碰撞、重叠的问题）
USE_PHYSICS = false

function BattleModel:ctor()
	laoi = require("laoi")
	cc(self):addComponent("game.models.components.AoiComponent"):init():exportMethods()

	--初始化技能管理器
	self.skillAgent = BattleSkillAgent:sharedInstance()
	self.skillAgent:init()

	if USE_PHYSICS then
		self:initPhysicsWorld()
	end
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

	if USE_PHYSICS then
		self:addPhysicUnit(unit)
	end

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

	if self.units[id].physicBody then
		self.physicWorld:DestroyBody(self.units[id].physicBody)
		self.units[id].physicBody = nil
	end

	-- 从本地保存的数组中移除对象
	self.units[id] = nil
end

function BattleModel:start()
	self.ready = true
	self.started = true
	self.timer = BATTLE_TIME
	
	if self.defender.isPvePlayer then
		local tData = pveData:getDataById(self.model.defender.id)
		self.timer = tData.limitedTime
	end
	Engine:getEventManager():fire("EventStartBattle")
end


function BattleModel:update()
	self.skillAgent:update()
	for i,v in pairs(self.units) do
		v:update(Time.delta)
	end
	
	if USE_PHYSICS then
		self:physicTick()
	end
end

---------------使用物理引擎相关函数--------------

--------------------
-- 初始化物理引擎
function BattleModel:initPhysicsWorld()
	local gravity = b2Vec2(0.0, 0.0)
	self.physicWorld = b2World:new_local(gravity)
	PTM_RATIO = 32
end

--------------
-- 物理引擎tick
function BattleModel:physicTick()
	for i,v in pairs(self.units) do
		v.physicBody:SetTransform(b2Vec2(v:getPosition().x/PTM_RATIO, v:getPosition().y/PTM_RATIO), 0)
	end
	self.physicWorld:Step(Time.delta, 10, 10)
	for i,v in pairs(self.units) do
		v:setPosition(v.physicBody:GetPosition().x*PTM_RATIO, v.physicBody:GetPosition().y*PTM_RATIO)
	end
end

--------------
-- 增加关联的刚体
function BattleModel:addPhysicUnit(unit)
	local pos = unit:getPosition()
	local bodyDef = b2BodyDef:new_local()
	if unit.config.unitType == UNIT_TYPE.building then
		bodyDef.type = b2_staticBody
	else
		bodyDef.type = b2_dynamicBody
	end
	bodyDef.position:Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO)
	local _body = self.physicWorld:CreateBody(bodyDef)

	local circle = b2CircleShape:new_local()
	circle.m_radius = unit:getValue("size")/PTM_RATIO

	shapeDef = b2FixtureDef:new_local()
	shapeDef.shape = circle
	shapeDef.density = 1.0
	shapeDef.friction = 0.2
	shapeDef.restitution = 0.8
	_body:CreateFixture(shapeDef)
	
	unit.physicBody = _body
end
return BattleModel