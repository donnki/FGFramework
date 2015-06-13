local UIFactory = class("UIFactory")
UIFactory.__index = UIFactory

function UIFactory:init()
end
-- 按钮
function UIFactory:createButton(propertyList)
	local obj = ccui.Button:create()
	self:setProperty(obj,propertyList)
	return obj
end
-- 复选框
function UIFactory:createCheckButton(propertyList)
	local obj = ccui.CheckBox:create()
	self:setProperty(obj,propertyList)
	return obj
end
-- 图片
function UIFactory:createImage(propertyList)
	local obj = ccui.ImageView:create()
	self:setProperty(obj,propertyList)
	return obj
end
-- 滑动器
function UIFactory:createSlider(propertyList)
	local obj = ccui.Slider:create()
	self:setProperty(obj,propertyList)
	return obj
end


function UIFactory:createLoadingBar(propertyList)
	local obj = ccui.LoadingBar:create()
	self:setProperty(obj,propertyList)
	return obj
end


function UIFactory:createText(propertyList)
	local obj = ccui.Text:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createTextAtlas(propertyList)
	local obj = ccui.TextAtlas:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createTextBMFont(propertyList)
	local obj = ccui.TextBMFont:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createTextField(propertyList)
	local obj = ccui.TextField:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createLayout(propertyList)
	local obj = ccui.Layout:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createLinearLayoutParameter(propertyList)
	local obj = ccui.LinearLayoutParameter:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createScrollView(propertyList)
	local obj = ccui.ScrollView:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createPageView(propertyList)
	local obj = ccui.PageView:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createListView(propertyList)
	local obj = ccui.ListView:create()
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createWidget(TexturePath,propertyList)
	if not TexturePath then return end
	local obj = ccui.Widget:create(TexturePath)
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createRichText(TexturePath,propertyList)
	if not TexturePath then return end
	local obj = ccui.RichText:create(TexturePath)
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createHBox(propertyList)
	local obj = cc.HBox:create(TexturePath)
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:createVBox(propertyList)
	local obj = ccui.VBox:create(TexturePath)
	self:setProperty(obj,propertyList)
	return obj
end

function UIFactory:setFontPro(obj,ProList)
	if not obj then return end
	if ProList and table.getn(ProList) > 0 then
		local str = ProList.str
		local fontName = ProList.fName
		local fontSize = ProList.fSize
		local fontColor = ProList.fColor

		if str then
			obj:setString(str)
		end 
		if fontName then 
			obj:setFontName(fontName)
		end
		if fontSize then
			obj:setFontSize(fontSize)
		end
		if fontColor then
			obj:setColor(fontColor)
		end
	end
 
end

function UIFactory:setProperty(obj,propertyList) -- 设置控件的公共属性
	if not obj then return end
	if propertyList then
		local x,y = propertyList.x,propertyList.y
		
		local w,h = propertyList.w,propertyList.h
		local ax,ay = propertyList.ax,propertyList.ay
		local isEnable = propertyList.isEnable
		local eFunc = propertyList.eFunc
		-- 九妹不支持所有空间 所以这边就不设了
		if x and y then
			obj:setPosition(x,y)
		end
		if w and h then
			obj:setContentSize(w,h)
		end
		if ax and ay then 
			obj:setAnchorPoint(cc.p(ax,ay))
		end

		obj:setTouchEnabled(isEnable)
		if eFunc then
			obj:addTouchEventListener(eFunc)
		end
	end 
end

local instance 
function UIFactory:getInstance()
    if instance == nil then
        instance  = UIFactory:new()
        instance:init()
    end
    return instance
end


return UIFactory