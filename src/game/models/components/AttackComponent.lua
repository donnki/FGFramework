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
    })
    return self.target_
end

function AttackComponent:onBind_(gameObject)
	self.gameObject = gameObject
	self.cooling = false 		--冷却中
	self.afterAttack = false 	--攻击后摇中
	self.beforeAttack = true 	--攻击前摇中
	self.aimed = false 			--已瞄准
	self.underControl = false 	--被控制
	self.target = nil 			--锁定的目标
end

function AttackComponent:init(battle)
	self.battle = battle

	--单位攻击最大半径
	self.atkRangeMax = self.gameObject:getValue("attackRangeMax")
	--单位攻击最小半径
	self.atkRangeMin = self.gameObject:getValue("attackRangeMin")
	--单位瞄准时间
	self.aimTime = self.gameObject:getValue("aimTime")
	return self
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
-----------
-- 返回当前目标是否有效，会检查：
-- 1）是否有目标
-- 2）是否已死亡
-- 3）处于隐身（无敌）中
-- 4）是否已离开有效攻击范围
function AttackComponent:targetValid(target)
	if target == nil then target = self.target end
	if target == nil then return false end
	if target.isDead then return false end
	if target.isInvisible then return false end
	local distance = cc.pGetDistance(target:getPosition(), self.gameObject:getPosition())
	return (distance < self.atkRangeMax + target.size 
		and distance > self.atkRangeMin - target.size)
end

----------
-- 区域内寻找可攻击单位
-- 返回是否有可攻击单位
function AttackComponent:findTarget()
	self.aimed = false
	local target = nil
	local units = self.battle:aoiUnitSearch(self.gameObject.id, self.atkRangeMax)
	local minDistance = 999
	for i,v in pairs(units) do
		local unit = self.battle.units[v:get_id()]
		if self:targetValid(unit) then
			local distanceSQ = cc.pDistanceSQ(
				cc.p(self.gameObject:getPosition()), cc.p(unit:getPosition())
			)
			if (minDistance * minDistance) > distanceSQ then
				minDistance = distanceSQ
				target = unit
			end
		end
	end
	if target then
		self.target = target
		return true
	end

	return false
end

----------
-- 向当前目标开火
-- 返回是否已开火完毕
function AttackComponent:fire()
	print("~fire")
	self.cooling = true 	--冷却标记
	self.beforeAttack = true --攻击前摇
	return true
end

function AttackComponent:hurtTarget()
	-- print("~hurtTarget")
	self.beforeAttack = false
	self.afterAttack = true
    self.target:hurt()
    return true
end

function AttackComponent:notColddown()
	return self.cooling
end

function AttackComponent:isColdDown()
	return not self.cooling
end

function AttackComponent:setColddown()
	self.cooling = false
	self.beforeAttack = true
	return true
end

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

function AttackComponent:notAimed()
	return not self.aimed
end

function AttackComponent:idle()
	return false
end
----------
-- 瞄准当前目标
-- 返回是否已瞄准完毕
function AttackComponent:aim(timer)
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
