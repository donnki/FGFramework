local UnitModel = class("UnitModel")
local BattleBuffAgent = require("game.buffs.BattleBuffAgent")


function UnitModel:ctor(proto, team, battle)
	-- 单位的原始数据，包括ID、坐标等
	self.proto = proto

	-- 单位所属的队伍
	self.team = team 

	-- 战场的引用
	self.battle = battle
	
	-- 战场上的唯一ID
	self.bid = Engine:nextTag()

	-- 初始化读取配置信息
	self:initConfigData()

	-- 初始化各个组件
	self:initComponents()

	--初始化AI（如果有的话）
	if self.config.ai then
		self:initAI(self.config.ai)
	end

	-- 初始化BUFF管理器
	self.buffAgent = BattleBuffAgent.new(self)

	if self.proto.x and self.proto.y then
		self:setPosition(self.proto.x, self.proto.y)
	end
end

------------
-- 初始化读取配置信息
function UnitModel:initConfigData()
	self.config = {}
end

------------
-- 初始化单位的各个组件
function UnitModel:initComponents()
	--位置组件
	cc(self):addComponent("game.models.components.TransformComponent"):exportMethods()

	--渲染组件
	cc(self):addComponent("game.models.components.RenderComponent"):exportMethods()
end

------------
-- 初始化AI行为树
function UnitModel:initAI(aiconfig)
	local bt = require("core.bt.BTInit")
	self.ai = bt.loadFromJson(aiconfig, self)
	self.ai:activate(self)
end

------------
-- 执行开火
function UnitModel:doFire()
end

function UnitModel:hurt(damage)
	print("TODO: on hurt", self.__cname)
end

function UnitModel:update(dt)
	if self.ai and self.ai:evaluate() then
        self.ai:tick(dt)
    end
    if self:getRenderer() then
    	self:getRenderer():update(dt)
	end
end

function UnitModel:getValue(key)
	return self.config[key]
end

return UnitModel