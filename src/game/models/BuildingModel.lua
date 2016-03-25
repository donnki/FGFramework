local Unit = require("game.models.UnitModel")
local Building = class("Building", Unit)

function Building:ctor(proto, clan)
	Building.super.ctor(self, proto, clan)
	local BuildingNode = require("game.scenes.battle.view.BuildingNode")
	cc(self):addComponent("game.models.components.Renderer")
		:setRenderer("game.scenes.battle.view.BuildingNode")
		:exportMethods()

	self.clan = clan
	self.id = proto.id
	self:setPosition(proto.x, proto.y)
end

------------
-- 战斗初始化接口
function Building:initForBattle(battleModel)
	-- 单位的尺寸
	self.size = self:getValue("size")
	--aoi
	battleModel:addUnit(self)
end


------------
-- 取得各种数值，如攻击力、攻击间隔等
function Building:getValue(key)
	if key == "size" then
		return 50
	elseif key == "attackRangeMax" then
		return 200
	elseif key == "attackRangeMin" then
		return 0
	elseif key == "atkCD" then 			--攻击CD
		return 1
	elseif key == "aimTime" then 		--瞄准时间
		return 0.2
	elseif key == "afterAttackDelay" then 	--攻击后摇时间
		return 0
	elseif key == "beforeAttackDelay" then  --攻击前摇时间
		return 0
	end

	return 10
end


function Building:update(dt)
	if self:isRendered() then
		self:getRenderer():setRotation(-self:getRotation())
	end
end
return Building