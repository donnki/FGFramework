--[[
    移动组件
]]
local Component = cc.Component
local MovableComponent = class("MovableComponent", Component)


function MovableComponent:ctor()
    MovableComponent.super.ctor(self, "MovableComponent")
end

function MovableComponent:exportMethods()
    self:exportMethods_({
    	"moveTo",
    	"moveByPath",
    	"findPath",
    	"move",
    })
    return self.target_
end

function MovableComponent:init(battleModel)
	self.moveSpeed_ = self.gameObject:getValue("moveSpeed")
	self.attackRange_ = self.gameObject:getValue("attackRange")
	self.pathIndex_ = 0
	return self
end

---------------
-- 移动单位至指定位置点
-- @return：是否已抵达目标位置
function MovableComponent:moveTo(pos)
	if self.originPos_ == nil then
		self.originPos_ = self.gameObject:getPosition()
		self.finalPos_ = self.finalPos_ and self.finalPos_ or pos
		self.costTime_ = cc.pGetDistance(self.originPos_, pos) / self.moveSpeed_
		self.timer_ = 0
		local angle = math.deg(cc.pToAngleSelf(cc.pSub(pos, self.originPos_)))
		self.gameObject:setRotation(-angle)
	end

	self.timer_ = self.timer_ + Time.delta
	if self.timer_ <= self.costTime_ then
		local t = self.timer_/self.costTime_
		local newPos = cc.pLerp(self.originPos_, pos, t)
		
		if self.mode_ == 1 then 		-- 优化： 应该只需要计算最后一个路径点
			local distance = cc.pGetDistance(newPos, self.finalPos_)
			if distance  < self.attackRange_ + self.radius_ - 10 then
				self.pathIndex_ = 0
				self.path_ = nil
				return true
			end
		end
		self.gameObject:setPosition(newPos.x, newPos.y)
		return false
	else
		self.originPos_ = nil
		return true
	end
end

-----------------
-- 根据路径移动单位
-- @return：是否已抵达目标位置
function MovableComponent:moveByPath()
	if self.pathIndex_ > 0 and self.path_ and #self.path_ >= self.pathIndex_ then
		if self:moveTo(self.path_[self.pathIndex_]) then
			self.pathIndex_ = self.pathIndex_ + 1
		end
		return false
	else
		self.pathIndex_ = 0
		return true
	end
end

function MovableComponent:move()
	return self:moveByPath()
end
--------------
-- 寻找到指定位置点的路径
-- @param pos: 终点的坐标
-- @param mode: 值为0或空时，终点为精确坐标点；值为1时，终点为单位可攻击到的范围
-- @param radius: 目标的半径，仅当mode值为1时有效
function MovableComponent:findTargetPath(pos, mode, radius)
	self.finalPos_ = pos
	self.mode_ = mode and mode or 0
	self.radius_ = radius and radius or 0
	self.path_ = {pos}
	self.pathIndex_ = 1
end

function MovableComponent:findPath()
	local target = self.gameObject:getCurrentTarget()
	if target then
		self:findTargetPath(cc.p(target:getPosition()), 1, target:getValue("size"))
		return true
	else

	end
	
end

return MovableComponent
