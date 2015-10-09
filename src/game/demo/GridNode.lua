local GridNode = class("GridNode", cc.Node)

local GRAVITY = 2000

function GridNode:ctor(id, x, y, root)
	self.id = id
	self.x = x
	self.y = y
	self.root = root
	local sprite = cc.Sprite:create("res/demo/node"..id..".png")
	self:addChild(sprite)
end

function GridNode:shouldFallTo(targetX, targetY)
	self.targetX = targetX
	self.targetY = targetY
	self.root.dataTable[self.x][self.y] = nil
	if not self.falling then
		self.falling = true
		self.fellSpeed = 20
	end
end

function GridNode:fallEnd()
	-- self.root:outputDataTable()
	self.falling = false
	print(string.format("end, id=%d from(%d,%d) to (%d, %d)", self.id, self.x,  self.y, self.targetX, self.targetY))
	
	self.x = self.targetX
	self.y = self.targetY
	self.targetX , self.targetY = 0, 0

	self.root.dataTable[self.x][self.y] = self
	
	-- self:setPositionY((9-x-1) * nodeSize.height + nodeSize.height/2)
	self.root:resetNodePos(self, self.x, self.y)
	self.root:checkNodes()
	
	-- self.root:outputDataTable()
end

function GridNode:update(delta)
	if self.falling then

		local dist = self.fellSpeed * delta + GRAVITY * delta * delta / 2

		self.fellSpeed = self.fellSpeed + GRAVITY * delta

		if self.root.direction == 1 then
			local positionY = self:getPositionY() - dist

			local curPosX = self.root:convertPos(positionY)

			if curPosX < self.targetX then
				self:setPositionY(positionY)
			else
				self:fallEnd()
			end
		elseif self.root.direction == 3 then
			local positionY = self:getPositionY() + dist

			local curPosX = self.root:convertPos(positionY)
			if curPosX < self.targetX then
				self:setPositionY(positionY)
			else
				self:fallEnd()
			end
		elseif self.root.direction == 2 then
			local positionX = self:getPositionX() + dist

			local curPosX = self.root:convertPos(positionX)
			if curPosX < self.targetX then
				self:setPositionX(positionX)
			else
				self:fallEnd()
			end
		elseif self.root.direction == 4 then
			local positionX = self:getPositionX() - dist

			local curPosX = self.root:convertPos(positionX)
			if curPosX < self.targetX then
				self:setPositionX(positionX)
			else
				self:fallEnd()
			end
		end
	end
end
return GridNode