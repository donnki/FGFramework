local TestMissile = class("TestMissile" , SceneBase)
TestMissile.__index = TestMissile

local function newNode()
    local drawNode = cc.DrawNode:create()
    drawNode:drawSolidCircle(cc.p(0,0), 20, 0, 50, 1.0, 1.0, cc.c4f(1,0.5,1,1))
    return drawNode
end
function TestMissile:init(config)
    SceneBase.init(self)
    Log.d("TestMissile初始化临时测试场景")

     p0 = cc.p(100,100)
     p1 = cc.p(600,980)
     p2 = cc.p(1180,100)
    
    
    
    -- node:runAction(cc.BezierTo:create(2, {p0,p1,p2}))

    self.node = newNode()
    self.node:setPosition(p0)
    self:addChild(self.node)
    
    -- self.node:runAction(cc.BezierTo:create(2, {p0,p1,p2}))
    self.node2 = newNode()
    self.node2:setPosition(p0)
    self:addChild(self.node2)
end

local timer = 0
local costTime = 2
function TestMissile:update(dt)
    
    local t = timer / costTime
    if t <= 1 then
        local px = squarebezierat(p0.x,p1.x,p2.x,t)
        local py = squarebezierat(p0.y,p1.y,p2.y,t)
        self.node2:setPosition(px,py)

        -- local px = cubebezierat(p0.x,p0.x,p1.x,p2.x,t)
        -- local py = cubebezierat(p0.y,p0.y,p1.y,p2.y,t)
        local px = p0.x + (p2.x-p0.x) * t
        local py = p0.y + p1.y * timer - 0.5 * timer * timer * p1.y
        self.node:setPosition(px, py)
    end
    timer = timer + dt
end

function TestMissile:onEnter()


    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:registerScriptHandler(function(touch, event)
        
    end ,cc.Handler.EVENT_TOUCH_BEGAN )
    -- self.touchListener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- self.touchListener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.touchListener, -1)
   
end

function TestMissile:onExit()
end


function TestMissile.createWithData(data)
    local scene = TestMissile.new()
    scene:init(data)
    return scene
end
function TestMissile.create(config)
    local scene = TestMissile.new()
    scene:init(config)
    return scene
end
return TestMissile
