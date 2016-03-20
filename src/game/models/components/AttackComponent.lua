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
    })
    return self.target_
end

function AttackComponent:onBind_(gameObject)
	self.gameObject = gameObject
end

function AttackComponent:init(battle)
	self.battle = battle

	--单位攻击最大半径
	self.atkRangeMax = self.gameObject:getValue("attackRangeMax")
	--单位攻击最小半径
	self.atkRangeMin = self.gameObject:getValue("attackRangeMin")
	return self
end

------------
-- 返回单位是否被控制（眩晕）中
function AttackComponent:isUnderControl()
	return false
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
	local minDistance = 99999
	local target
	local units = self.battle:aoiUnitSearch(self.gameObject:getTag(), self.atkRangeMax)
	for i,v in ipairs(units) do
		
		if self:targetValid(v) then
			local distanceSQ = cc.pDistanceSQ(cc.p(self:getPosition()), cc.p(v:getPosition()))
			if minDistance*minDistance > distanceSQ then
				minDistance = distance
				target = 
			end
		end
	end
	if tag ~= -1 then
		self.target = self.allEnemies[tag]
		return true
	end
	return false
end

----------
-- 向当前目标开火
-- 返回是否已开火完毕
function AttackComponent:fire()
	return true
end

----------
-- 瞄准当前目标
-- 返回是否已瞄准完毕
function AttackComponent:aim()

	return false
end

return AttackComponent
