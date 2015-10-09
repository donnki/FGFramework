local Grid = require("game.demo.Grid")
local DemoScene = class("DemoScene" , SceneBase)

DemoScene.__index = DemoScene
DemoScene.pause = true
function DemoScene:init()
	Log.i("~~~")
    SceneBase.init(self)

    self.grid = Grid.create()
    self:addChild(self.grid)
    
    local menu = cc.Menu:create()
    self:addChild(menu, 10)

    local label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("TurnLeft", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(-400,0)
    label:registerScriptTapHandler(function()
        self.grid:rotate(true)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("TurnRight", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(400,0)
    label:registerScriptTapHandler(function()
        self.grid:rotate(false)
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Pause&resume", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(0,320)
    label:registerScriptTapHandler(function()
        self.pause = not self.pause
    end)
    menu:addChild(label)

    label = cc.MenuItemLabel:create(cc.Label:createWithSystemFont("Test", "Helvetica", 30))
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(0,-320)
    label:registerScriptTapHandler(function()
        
    end)
    menu:addChild(label)
end

function DemoScene.create()
	local scene = DemoScene.new()
    scene:init()
    return scene
end

function DemoScene:update(delta)
    if not self.pause then
	   self.grid:update(delta)
    end
end

return DemoScene