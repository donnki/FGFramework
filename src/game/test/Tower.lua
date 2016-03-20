local Tower = class("Tower", function()
	return cc.Node:create()
end)

local bt = require("core.bt.BTInit")

function Tower:ctor(size, attackRadus, attackSpeed)
	self.radius = size
	self.attackRadius = attackRadus

	self.attackSpeed = attackSpeed
	self.drawNode = cc.DrawNode:create()
    self.drawNode:drawSolidCircle(cc.p(0,0), size, 0, 50, 1.0, 1.0, cc.c4f(1,0,1,1))
    self.drawNode:drawCircle(cc.p(0,0), attackRadus, 0, 50, true, 1.0, 1.0, cc.c4f(1.0, 0.0, 0.0, 0.2))
    self:addChild(self.drawNode)

    self:initBehaviorTree()
    self.hp = 5
    self.allEnemies = {} 
end

function Tower:initBehaviorTree()
	self.btRoot = bt.loadFromJson("src/game/test/ai_tower.json", self)
	self.btRoot:activate(self)

end

function Tower:onEnter()
end

function Tower:getInterval(key)
	return self.attackSpeed
end

function Tower:isUnderControl()
	return false
end

function Tower:isWorking()
	return not self.isDead
end

function Tower:targetNotValid()
	return not self:targetValid()
end
-----------
-- 检查当前目标是否有效
-- 返回是否有效
function Tower:targetValid()
	local valid = false
	if self.target ~= nil then
		local distance = cc.pGetDistance(cc.p(self:getPosition()), cc.p(self.target:getPosition()))
		if distance < self.attackRadius then
			valid = true
		else
			self.taret = nil
		end
	end
	return valid
end

function Tower:hurt()
	self.hp = self.hp - 1
	if self.hp <= 0 then
		self:onDead()
	end
end

function Tower:onDead()
	self.isDead = true
	self.drawNode:clear()
end
----------
-- 区域内寻找可攻击单位
-- 返回是否有可攻击单位
function Tower:findTarget()
	local tag, minDistance = -1, 99999
	for i,v in ipairs(self.allEnemies) do
		local distance = cc.pGetDistance(cc.p(self:getPosition()), cc.p(v:getPosition()))
		if distance < self.attackRadius and minDistance > distance then
			tag = i
			minDistance = distance
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
function Tower:fire()
	local angle = self:getAngle()

	local distance = cc.pGetDistance(cc.p(self:getPosition()), cc.p(self.target:getPosition()))
	local node = cc.DrawNode:create()
	node:setPosition(self:getPositionX()+self.radius*math.cos(math.rad(angle)), self:getPositionY()+self.radius*math.sin(math.rad(angle)))
    node:drawSolidCircle(cc.p(0,0), 5, 0, 20, 1.0, 1.0, cc.c4f(1,1,1,0.5))
    self:getParent():addChild(node)
    node:runAction(cc.Sequence:create(
    	cc.MoveTo:create(distance/1500, cc.p(self.target:getPosition())),
    	cc.CallFunc:create(function()
    		node:removeFromParent()
    	end)
    ))
	return true
end

----------
-- 瞄准当前目标
-- 返回是否已瞄准完毕
function Tower:aim()

	local targetAngle = self:getAngle()
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

function Tower:getAngle()
	local x, y = self:getPosition()
	local tx, ty = self.target:getPosition()
    local flag = tx < x and 1 or -1
    local angle = math.atan((y-ty)/(x-tx))
    if flag > 0 then 
    	angle = math.deg(angle) - 180
    else
    	angle = math.deg(angle)
    end
    return angle
end

function Tower:update(dt)
    if self.activeDrawNode then
    	self.activeDrawNode:clear()
    end
	if self.btRoot and self.btRoot:evaluate() then
        self.btRoot:tick(dt)
    end
end
return Tower