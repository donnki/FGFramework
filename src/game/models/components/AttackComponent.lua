--[[
    攻击组件
]]
local Component = cc.Component
local AttackComponent = class("AttackComponent", Component)


function AttackComponent:ctor()
    AttackComponent.super.ctor(self, "AttackComponent")
end

function AttackComponent:exportMethods()
    self:exportMethods_({
    	"isUnderControl",
    	"isWorking",
    	"targetNotValid",
    	"targetValid",
    	"findTarget",
    	"fire",
    	"aim",
    	"isColdDown",
    	"setColddown",
    	"notColddown",
    	"isAfterAttack",
    	"setAfterAttack",
    	"notAimed",
    	"isBeforeAttack",
    	"idle",
    	"hurtTarget",
    	"notAfterAttack",
    	"isTargetInRange",
    	"findNearestTarget",
    	"getCurrentTarget",
    })
    return self.target_
end

----------
-- 初始化
function AttackComponent:init(battle)
	self.battle = battle
	self.cooling = false 		--冷却中
	self.afterAttack = false 	--攻击后摇中
	self.beforeAttack = true 	--攻击前摇中
	self.aimed = false 			--已瞄准
	self.underControl = false 	--被控制
	self.target = nil 			--锁定的目标

	--单位攻击最大半径
	self.atkRangeMax = self.gameObject:getValue("attackRangeMax")
	--单位攻击最小半径
	self.atkRangeMin = self.gameObject:getValue("attackRangeMin")
	--单位瞄准时间
	self.aimTime = self.gameObject:getValue("aimTime")
	return self
end

function AttackComponent:getCurrentTarget()
	return self.target
end

------------
-- 返回单位是否被控制（眩晕）中
function AttackComponent:isUnderControl()
	return self.underControl
end

------------
-- 返回单位是否能够行动
function AttackComponent:isWorking()
	return not self.gameObject.isDead
end

------------
-- 返回当前目标是否失效
function AttackComponent:targetNotValid()
	return not self:targetValid()
end

----------
-- 返回目标是否在攻击范围以内
function AttackComponent:isTargetInRange(target)
	local distance = cc.pGetDistance(target:getPosition(), self.gameObject:getPosition())
	local targetInRange = (distance < self.atkRangeMax + target:getValue("size")
		and distance > self.atkRangeMin - target:getValue("size"))
	
	return targetInRange
end

-----------
-- 返回当前目标是否有效，会检查：
-- 1）是否有目标
-- 2）是否已死亡
-- 3）处于隐身（无敌）中
-- 4）目标是否已离开有效攻击范围，并且不包含可移动的组件
function AttackComponent:targetValid(v)
	local target = nil
	if v == nil then 
		target = self.target 
	else
		target = self.battle:getById(v:get_id())
	end
	if target == nil then return false end
	if target.isDead then return false end
	if target.isInvisible then return false end
	if not self.gameObject:checkComponent("game.models.components.MovableComponent")  
		and not self:isTargetInRange(target) then 
		return false 
	end
	return true
end


----------
-- 区域内寻找可攻击单位
-- 返回是否有可攻击单位
function AttackComponent:findTarget()
	self.aimed = false
	local target = self.battle:findNearestInRange(
		self.gameObject.id, 
		self.atkRangeMax, 
		TEAM.enemy(self.gameObject.team),
		handler(self, self.targetValid)
	)
	if target then
		self.target = target
		return true
	end

	return false
end

-------------
-- 寻找整个地图范围内最近的单位
-- team:		留空时表示任意分组，否则根据指定team相同的分组来寻找最近的单位
-- type:		类型留空则表示无优先级，否则根据type来寻找最近的单位
function AttackComponent:getNearestTarget(team, type_)
	local target = self.battle:findNearestInAll(
		self.gameObject.id,
		team,
		type_,
		handler(self, self.targetValid)
	)
	return target
end

function AttackComponent:findNearestTarget()
	local unit = self:getNearestTarget()
	if unit then
		self.target = self.battle:getById(unit:get_id())
		return true 
	else
		return false
	end
end

----------
-- 向当前目标开火
-- 返回是否已开火完毕
function AttackComponent:fire()
	-- print("~fire")
	self.cooling = true 	--冷却标记
	self.beforeAttack = true --攻击前摇
	return true
end

-----------
-- 对单位造成伤害（或者发射出子弹，由子弹对单位造成伤害）
function AttackComponent:hurtTarget()
	-- print("~hurtTarget")
	self.beforeAttack = false
	self.afterAttack = true
    self.target:hurt()
    return true
end

------------
--是否未冷却
function AttackComponent:notColddown()
	return self.cooling
end

------------
--是否已冷却
function AttackComponent:isColdDown()
	return not self.cooling
end


------------
--设置冷却完成
function AttackComponent:setColddown()
	self.cooling = false
	self.beforeAttack = true
	return true
end

------------
--是否不处于攻击后摇中
function AttackComponent:notAfterAttack()
	return not self.afterAttack
end


------------
--是否处于攻击后摇中
function AttackComponent:isAfterAttack()
	return self.afterAttack
end

------------
--是否处于攻击前摇中
function AttackComponent:isBeforeAttack()
	return self.beforeAttack
end

------------
--设置攻击后摇完成
function AttackComponent:setAfterAttack()
	self.afterAttack = false
	return true
end

------------
-- 是否尚未瞄准完成
function AttackComponent:notAimed()
	return not self.aimed
end

--------------
-- 等待CD结束的同时调整角度，使面向当前单位
function AttackComponent:idle()
	if self.aimed then
		local angle = math.deg(cc.pToAngleSelf(cc.pSub(
			self.target:getPosition(), self.gameObject:getPosition()
		)))
		self.gameObject:setRotation(angle)
	end
	return false
end

----------
-- 瞄准当前目标
-- 返回是否已瞄准完毕
function AttackComponent:aim(timer, properties)
	if self.originRotation == nil then
		self.originRotation = self.gameObject:getRotation()
	end
	local angle = math.deg(cc.pToAngleSelf(cc.pSub(
		self.target:getPosition(), self.gameObject:getPosition()
	)))
	if self.aimTime >= timer then
		local offset = lerp((self.aimTime-timer)/self.aimTime, angle - self.originRotation, 0)
		self.gameObject:setRotation(self.originRotation + offset)

		return false
	else
		self.aimed = true
		self.gameObject:setRotation(angle)
		self.originRotation = nil
		return true
	end
end

return AttackComponent
