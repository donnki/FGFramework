--[[
    渲染组件
]]
local Component = cc.Component
local Renderer = class("Renderer", Component)


function Renderer:ctor()
    Renderer.super.ctor(self, "Renderer")
    self.children = {}
end

function Renderer:exportMethods()
    self:exportMethods_({
    	"getRenderer",
    	"setRenderer",
    	"setParent",
    	"addChild",
    	"isRendered",
    })
    return self.target_
end

function Renderer:onBind_(gameObject)
	self.gameObject = gameObject
end

function Renderer:onUnbind_()
end

function Renderer:addChild(child)
	table.insert(self.children, child)
	return self
end

function Renderer:setRenderer(renderClassPath)
	self.classpath = renderClassPath
	return self
end

function Renderer:isRendered()
	return self.rendered
end

function Renderer:setParent(parent)
	parent:addChild(self)
	if parent:isRendered() then
		parent:getRenderer():addChild(self:getRenderer())
	end
	return self
end

function Renderer:getRenderer()
	if not self.displayNode then

		if self.classpath then
			self.displayNode = require(self.classpath).new(self.gameObject)
		else
			self.displayNode = cc.Node:create()
		end

		if #self.children > 0 then
			for i,child in ipairs(self.children) do
				self.displayNode:addChild(child:getRenderer())
			end
		end
		self.rendered = true
	end
	return self.displayNode
end

return Renderer
