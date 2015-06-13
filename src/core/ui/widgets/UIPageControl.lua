local UIPageControl = class("UIPageControl",function() 
	return cc.Node:create() 
end)
UIPageControl.__index = UIPageControl
UIPageControl.hidesForSinglePage = false
UIPageControl.numberOfPages = 0
UIPageControl.currentPage = 0
UIPageControl.fullDot = nil

function UIPageControl:create( ... )
	local instance = UIPageControl.new()
	instance:init(...)
	return instance	
end

function UIPageControl:init(...)
	self.hidesForSinglePage = false
	self.currentPage = 0
	self.numberOfPages = 0

	self.fullDot = cc.Sprite:createWithSpriteFrameName("guankafenye-dangqian.png")
	self.fullDot:retain()
end

function UIPageControl:setCurrentPage(p)
	if self.currentPage ~= p and p < self.numberOfPages then
		self.currentPage = p
		self:updateCurrentPageDisplay()
	end
end

function UIPageControl:getCurrentPage()
	return self.currentPage
end

function UIPageControl:setNumberOfPages(n)
	if n >= 0 and n ~= numberOfPages then
		self.numberOfPages = n
		self:removeAllChildren(true)
		self:setContentSize(self:sizeForNumberOfPages(n))

		for i=0,n-1 do
			local sprite = cc.Sprite:createWithSpriteFrameName("guankafenye-1.png")
			local size = sprite:getContentSize()
			sprite:setPosition(i*size.width+size.width/2, size.height/2)
			self:addChild(sprite, 1)
		end
		self:updateCurrentPageDisplay()
		self:updateVisibility()
	end
end

function UIPageControl:getNumberOfPages()
	return self.numberOfPages
end

function UIPageControl:setHidesForSinglePage(b)
	self.hidesForSinglePage = b
	self:updateVisibility()
end


function UIPageControl:getHidesForSinglePage()
	return hidesForSinglePage
end

function UIPageControl:sizeForNumberOfPages(n)
	return cc.size(n*self.fullDot:getContentSize().width, self.fullDot:getContentSize().height)
end

function UIPageControl:updateCurrentPageDisplay()
	local size = self.fullDot:getContentSize()
	self.fullDot:setPosition(self.currentPage*size.width + size.width/2, size.height/2)
	if self.fullDot:getParent() == NULL then
		self:addChild(self.fullDot, 2)
	end
end

function UIPageControl:updateVisibility()
	if self.hidesForSinglePage and self.numberOfPages == 1 then
		self:setVisible(false)
	else
		self:setVisible(true)
	end
end

return UIPageControl