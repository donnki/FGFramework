local TestRecorderScene = class("TestRecorderScene" , SceneBase)

TestRecorderScene.__index = TestRecorderScene

local tmpbox = nil
local startMove = false
function TestRecorderScene:init()
    SceneBase.init(self)
    tmpbox = cc.LayerColor:create(cc.c4b(100,100,255,255));
    tmpbox:setContentSize(50,50);
    tmpbox:setPosition(display.cx,display.cy)
    self:addChild(tmpbox)

    local menu = cc.Menu:create()
    self:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Start Record", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
    	startMove = true
        Time.startRecord()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("End Record", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
    	startMove = false
        Time.endRecord()
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Play Record", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
    	tmpbox:setPosition(display.cx,display.cy)
    	startMove = true
        Time.startReplay(function()
        	startMove = false
        end)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Solve Hanoi", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        local function hanoi(level, from, path, to)
            if level == 1 then
                print(from.."->"..to)
            else
                hanoi(level-1, from, to, path)
                print(from.."->"..to)
                hanoi(level-1, path, from, to)
            end
        end

        hanoi(7, "A", "B", "C")

    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Solve Quene", "Helvetica", 60))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:registerScriptTapHandler(function()
        
        native.onStatisticEvent("testEvemt")
    end)
    menu:addChild(label)

    menu:alignItemsVertically()
end

function TestRecorderScene.create()
	local scene = TestRecorderScene.new()
    scene:init()
    return scene
end

function TestRecorderScene:update(delta)
	if startMove then
		tmpbox:setPositionX(tmpbox:getPositionX() + delta*100)
	end
end

return TestRecorderScene