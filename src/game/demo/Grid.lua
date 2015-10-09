local Grid = class("Grid" , cc.Layer)
local GridNode = require("game.demo.GridNode")

Grid.__index = Grid

local nodeSize = nil 
local SOLID_NODE_ID = 4
local GRID_SIZE = 8
function Grid:init()
    self.direction = 1

    self.grid = cc.Node:create()
    self.grid:setPosition(display.cx, display.cy)
    self:addChild(self.grid)

    self.gridBg = cc.Sprite:create("res/demo/grid_bg.png")
    self.grid:addChild(self.gridBg)

    local size = self.gridBg:getContentSize()
    nodeSize = cc.size(size.width/GRID_SIZE, size.height/GRID_SIZE)
    self.dataTable = {}
    for i=1,GRID_SIZE do
        self.dataTable[i] = {}
        for j=1,GRID_SIZE do
            self.dataTable[i][j] = nil
        end
    end
    

    self.gridNodes = cc.Node:create()
    self.gridNodes:setPosition(-size.width/2, -size.height/2)
    self.grid:addChild(self.gridNodes)

    for i=1,GRID_SIZE do
        for j=1,GRID_SIZE do
            if i<=j then
                self:addNode(math.random(1,4), i, j)
            end
        end
    end
    -- self:addNode(1, 1, 1)
    -- self:addNode(2, 2, 1)
    -- self:addNode(3, 4, 1)
    -- self:addNode(4, 5, 1)

    -- self:addNode(2, 6, 1)
    -- self:addNode(4, GRID_SIZE, 1)
    -- self:outputDataTable()
    -- self.dataTable[1][2]:setVisible(false)

    --[[
    down = 1,left = 2,up = 3,right = 4
    ]]
    
end

function Grid.create()
	local scene = Grid.new()
    scene:init()
    return scene
end

function Grid:rotate(isLeft)
    if isLeft then
        self.grid:runAction( 
            cc.Sequence:create(
                cc.RotateBy:create(0.5, 90),
                cc.CallFunc:create(function()
                    self.direction = self.direction + 1
                    if self.direction > 4 then
                        self.direction = 1
                    end
                    self:rotateDataTable(isLeft)
                end)
            )
        )
    else
        self.grid:runAction( 
            cc.Sequence:create(
                cc.RotateBy:create(0.5, -90),
                cc.CallFunc:create(function()
                    self.direction = self.direction - 1
                    if self.direction < 1 then
                        self.direction = 4
                    end
                    self:rotateDataTable(isLeft)
                end)
            )
        )
    end
end

function Grid:rotateDataTable(left)
    -- print("before rotate:")
    -- self:outputDataTable()
    local temp = {}
    for i=1,GRID_SIZE do
        temp[i] = {}
        for j=1,GRID_SIZE do
            if left then
                temp[i][j] = self.dataTable[GRID_SIZE+1-j][i]
            else
                temp[i][j] = self.dataTable[j][GRID_SIZE+1-i]
            end
            if temp[i][j] then
                temp[i][j].x = i
                temp[i][j].y = j
            end
        end
    end
    self.dataTable = temp
    -- print("after rotate:")
    self:outputDataTable()
end


function Grid:addNode(id, x,y)

    local sprite = GridNode.new(id, x, y, self)
    self:resetNodePos(sprite, x, y)
    self.gridNodes:addChild(sprite)

    self.dataTable[x][y] = sprite
end

function Grid:resetNodePos(node, x, y)
    -- print(self.direction)
    if self.direction == 1 then
        node:setPosition((y-1) * nodeSize.width + nodeSize.width/2, (GRID_SIZE-x) * nodeSize.height + nodeSize.height/2)
    elseif self.direction == 2 then
        node:setPosition((x-1) * nodeSize.width + nodeSize.width/2, (y-1) * nodeSize.height + nodeSize.height/2)
    elseif self.direction == 3 then
        node:setPosition((GRID_SIZE-y) * nodeSize.width + nodeSize.width/2, (x-1) * nodeSize.height + nodeSize.height/2)
    elseif self.direction == 4 then
        node:setPosition((GRID_SIZE-x) * nodeSize.width + nodeSize.width/2, (GRID_SIZE-y) * nodeSize.height + nodeSize.height/2)
    end
end

function Grid:checkNodes()
    for j=1,GRID_SIZE do
        local i = GRID_SIZE
        local curID = 0
        local curNodes = {}
        while i > 0 do
            if self.dataTable[i][j] ~= nil and curID~=SOLID_NODE_ID and not self.dataTable[i][j].falling and (curID == 0 or self.dataTable[i][j].id == curID) then
                curID = self.dataTable[i][j].id
                table.insert(curNodes, self.dataTable[i][j])
            else
                if #curNodes >= 3 then
                    for k,v in pairs(curNodes) do
                        self.dataTable[v.x][v.y] = nil
                        v:setVisible(false)
                    end
                end
                curNodes = {}
                curID = 0
            end
            i = i - 1
        end

        local i = 1
        local curID = 0
        local curNodes = {}
        while i <= GRID_SIZE do
            if self.dataTable[i][j] ~= nil and curID~=SOLID_NODE_ID and not self.dataTable[i][j].falling and (curID == 0 or self.dataTable[i][j].id == curID) then
                curID = self.dataTable[i][j].id
                table.insert(curNodes, self.dataTable[i][j])
            else
                if #curNodes >= 3 then
                    for k,v in pairs(curNodes) do
                        self.dataTable[v.x][v.y] = nil
                        v:setVisible(false)
                    end
                end
                curNodes = {}
                curID = 0
            end
            i = i + 1
        end
    end

    for i=1,GRID_SIZE do
        local j = GRID_SIZE
        local curID = 0
        local curNodes = {}
        while j > 0 do
            if self.dataTable[i][j] ~= nil and curID~=SOLID_NODE_ID and not self.dataTable[i][j].falling  and (curID == 0 or self.dataTable[i][j].id == curID) then
                curID = self.dataTable[i][j].id
                table.insert(curNodes, self.dataTable[i][j])
            else
                if #curNodes >= 3 then
                    for k,v in pairs(curNodes) do
                        self.dataTable[v.x][v.y] = nil
                        v:setVisible(false)
                    end
                end
                curNodes = {}
                curID = 0
            end
            j = j - 1
        end

        local j = 0
        local curID = 0
        local curNodes = {}
        while j <= GRID_SIZE do
            if self.dataTable[i][j] ~= nil and curID~=SOLID_NODE_ID and not self.dataTable[i][j].falling  and (curID == 0 or self.dataTable[i][j].id == curID) then
                curID = self.dataTable[i][j].id
                table.insert(curNodes, self.dataTable[i][j])
            else
                if #curNodes >= 3 then
                    for k,v in pairs(curNodes) do
                        self.dataTable[v.x][v.y] = nil
                        v:setVisible(false)
                    end
                end
                curNodes = {}
                curID = 0
            end
            j = j + 1
        end
    end
end


function Grid:outputDataTable()
    for i=1,GRID_SIZE do
        for j=1,GRID_SIZE do
            id = self.dataTable[i][j] == nil and 0 or self.dataTable[i][j].id
            io.write(id..", ")
        end
        io.write("\n")
    end
    io.write("---------\n")
    io.flush()
end

function Grid:convertPos(pos)
    local newPos = 0
    if self.direction == 1 then
        newPos = GRID_SIZE - math.floor((pos+nodeSize.height/2)/nodeSize.height)
    elseif self.direction == 2 then
        newPos = math.floor((pos+nodeSize.width/2)/nodeSize.width)
    elseif self.direction == 3 then
        newPos = math.floor((pos+nodeSize.height/2)/nodeSize.height)
    elseif self.direction == 4 then
        newPos = GRID_SIZE-math.floor((pos+nodeSize.width/2)/nodeSize.width)
    end
    return newPos
end

function Grid:update(delta)

    for j=1,GRID_SIZE do
        local zeroIndex = GRID_SIZE + 1
        local hasSolidNode = false
        for i=GRID_SIZE,1,-1 do
            local node = self.dataTable[i][j]
            if node ~= nil then
                if node.id ~= SOLID_NODE_ID then
                    zeroIndex = zeroIndex - 1
                    if i < zeroIndex then
                        node:shouldFallTo(zeroIndex , j)
                    end
                else
                    zeroIndex = i
                end 
            end
        end
    end

    local notCheck = false
    for k,v in pairs(self.gridNodes:getChildren()) do
        if v:isVisible() then
            if v.id ~= SOLID_NODE_ID then
                v:update(delta)
            end
        else
            v:removeFromParent()
        end
    end
end

return Grid