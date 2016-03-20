local Unit = class("Unit", function()
	return cc.Node:create()
end)
local bt = require("core.bt.BTInit")
function Unit:ctor(size, attackRadus, attackSpeed)
	self.radius = size
	self.attackRadius = attackRadus
	self.attackSpeed = attackSpeed
	local draw = cc.DrawNode:create()
    draw:drawSolidCircle(cc.p(0,0), size, 0, 50, 1.0, 1.0, cc.c4f(0.5,0,1,1))
    draw:drawCircle(cc.p(0,0), attackRadus, 0, 50, true, 1.0, 1.0, cc.c4f(1.0, 1.0, 0.0, 0.2))
    draw:drawCircle(cc.p(0,0), attackRadus*2, 0, 50, true, 1.0, 1.0, cc.c4f(0.5, 0.5, 0.5, 0.3))
    self:addChild(draw)
    self:initBehaviorTree()

    self.allBuildings = {} 
    self.allEnemyUnits = {}
end

function Unit:initBehaviorTree()
	self.btRoot = bt.loadFromJson("src/game/test/ai_attack_unit.json", self)
	self.btRoot:activate(self)
end

-----------
-- 检查当前目标是否有效
-- 返回是否有效
function Unit:targetValid()
	local valid = false
	if self.target ~= nil then
		valid = not self.target.isDead
	end
	return valid
end

function Unit:findNearestTag(arr, radius)
	local tag, minDistance = -1, 99999
	for i,v in ipairs(arr) do
		if not v.isDead then
			local distance = cc.pGetDistance(cc.p(self:getPosition()), cc.p(v:getPosition()))
			if distance < radius and minDistance > distance then
				tag = i
				minDistance = distance
			end
		end
	end
	return tag
end

----------
-- 区域内寻找可攻击单位
-- 返回是否有可攻击单位
function Unit:findTarget()
	local tag = self:findNearestTag(self.allEnemyUnits, self.attackRadius * 2)
	if tag ~= -1 then
		self.target = self.allEnemyUnits[tag]
		self.isBuildingTarget = false
		return true
	end
	tag = self:findNearestTag(self.allBuildings, 99999)
	if tag ~= -1 then
		self.target = self.allBuildings[tag]
		self.isBuildingTarget = true
		return true
	end
	
	return false
end

----------
-- 向当前目标开火
-- 返回是否已开火完毕
function Unit:fire()
	local angle = pGetDirection(cc.p(self:getPosition()), cc.p(self.target:getPosition()))

	local distance = cc.pGetDistance(cc.p(self:getPosition()), cc.p(self.target:getPosition()))
	local node = cc.DrawNode:create()
	node:setPosition(self:getPositionX()+self.radius*math.cos(math.rad(angle)), self:getPositionY()+self.radius*math.sin(math.rad(angle)))
    node:drawSolidCircle(cc.p(0,0), 5, 0, 20, 1.0, 1.0, cc.c4f(1,0,0,0.5))
    self:getParent():addChild(node)
    node:runAction(cc.Sequence:create(
    	cc.MoveTo:create(distance/1500, cc.p(self.target:getPosition())),
    	cc.CallFunc:create(function()
    		node:removeFromParent()
    		if self.target.hurt then
    			self.target:hurt()
    		end
    	end)
    ))
	return true
end

------------
-- 向当前目标移动
-- 返回是否已走到目标
function Unit:move()
	local targetPos, targetDistance
	if self.leadingFlag and not self.leadToBuilding then
		targetPos = self.targetPos
		targetDistance = 20
	else
		targetPos = cc.p(self.target:getPosition())
		targetDistance = self.attackRadius + self.target.radius
	end
	local curPos = cc.p(self:getPosition())
	local distance = cc.pGetDistance(curPos, targetPos)
	if distance < targetDistance then
		return true
	else
		local angle = pGetDirection(curPos, targetPos)
		self:setRotation(-angle)
		self:setPosition(curPos.x+5*math.cos(math.rad(angle)), curPos.y+5*math.sin(math.rad(angle)))
		return false
	end
end

----------
-- 瞄准当前目标
-- 返回是否已瞄准完毕
function Unit:aim()
	local targetAngle = pGetDirection(cc.p(self:getPosition()), cc.p(self.target:getPosition()))
	if not self.rotating then
		self.rotating = true
		self:runAction(cc.Sequence:create(
			cc.RotateTo:create(0.2, -targetAngle), 
			cc.CallFunc:create(function()
				self.rotating = false
			end)
		))
	end
	return self.rotating
end


function Unit:leadTo(isBuilding, target)
	self.leadingFlag = true
	if isBuilding then
		self.leadToBuilding = true
		self.target = target
	else
		self.leadToBuilding = false
		self.targetPos = target
		self.target = nil
	end
end

------------
-- 单位正在行进中
function Unit:isUnitWorking()
	return true
end

-------------
-- 取得间隔时间， 当key值：
-- speed: 取得攻击间隔
function Unit:getInterval(key)
	return self.attackSpeed
end

-------------
-- 返回单位是正被控制中
function Unit:isUnderControl()
	return false
end

function Unit:targetNotValid()
	return not self:targetValid()
end

------------
-- 是否使用技能中
function Unit:isUsingSkill()
	return false
end

------------
-- 是否处于引导中
function Unit:isLeading()
	return self.leadingFlag
end

------------
-- 是否引导向建筑
function Unit:isLeadToBuilding()
	return self.leadToBuilding
end

------------
-- 是否引导向空地
function Unit:isLeadToLand()
	return not self:isLeadToBuilding()
end

-----------
-- 当前目标是否为建筑
function Unit:targetIsBuilding()
	return self.isBuildingTarget
end

----------------
-- 视野内是否有目标
function Unit:hasUnitInSight()
	local tag = self:findNearestTag(self.allEnemyUnits, self.attackRadius*2)
	return tag ~= -1
end

------------
-- 视野内是否没有目标或引导强制攻击中
function Unit:noUnitInSight()
	if self.forseAttackBuilding then
		return true
	else
		return not self:hasUnitInSight()
	end
end

------------
-- 当前目标是否为可移动单位
function Unit:targetIsUnit()
	return not self:targetIsBuilding()
end

-------------
-- 当前是否没有目标
function Unit:noTarget()
	return not self:targetValid()
end

---------------
-- 某个操作是否结束
function Unit:onFinished(operation)
	if operation == "lead" then  --引导结束
		self.leadingFlag = false
		return true
	elseif operation == "leadBuilding" then
		self.leadingFlag = false
		self.forseAttackBuilding = true
		return true
	end
end

function Unit:update(dt)
	if self.btRoot and self.btRoot:evaluate() then
        self.btRoot:tick(dt)
    end
end
return Unit