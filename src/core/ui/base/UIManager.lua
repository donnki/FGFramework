-----------------
--UI管理器
-----------------

local UIManager = class("UIManager")

local instance = nil
UIManager.__index = UIManager
function UIManager:getInstance()
    if instance == nil then
        instance = UIManager.new()
        instance:init()
    end
    return instance
end

function UIManager:init()
    Log.d("UIManager初始化UI管理器")
    --self.UIWndList = {}
    self.SingletonPool = {}
    
end

function UIManager:open(key,...)
	if not key then return end
		
	local classTable = AllRegisterWnd[key]
	if not classTable then
		Log.e("该窗口没有在AllRegisterWnd中注册！")
		return
	end
	local className = classTable.className	
	if classTable.classPath then
		className = require(classTable.classPath)
	end

	if not className then
        Log.i(string.format("className(%s) is nil", key))
	   return
	end
	Log.d("创建"..key.."窗口对象")
	obj = className:new()
	obj:init(...)
	local templatePath = classTable.templatePath
	if classTable.templatePath then
		obj:loadTemplate(templatePath, classTable.subviews) 
	end
	local tag = classTable.tag
	local curScene = Engine.scene
	local ret = curScene:addUiToRoot(tag,obj)
	return obj, ret
end

function UIManager:openSingleton(key,...)
	if not key then return end
	local obj = self.SingletonPool[key]
	if obj then
		local classTable = AllRegisterWnd[key]
		local tag = classTable.tag
		local curScene = Engine.scene
		if curScene:getUIRoot():getChildByTag(tag) then
			obj:show()
		else
			curScene:addUiToRoot(tag,obj)
		end
	else
		obj = self:open(key,...)
		if not obj then return end
		obj:retain()
		obj:setSingleton(true)
		self.SingletonPool[key] = obj
	end
	return obj
end

function UIManager:openModal(key, ...)
	local wnd, ret = self:open(key, ...)
	local layer = require("core.ui.widgets.UIShadowLayer").create():scale(1.5)
    wnd:addChild(layer,-1,999)
    wnd:show()
	return wnd
end

function UIManager:createWnd(className,templatePath,isSingleton,...)

	if not className then return end
	local obj = self.SingletonPool[className]
	if obj then
		return obj
	end

	obj = className.new()
	obj:init(...)
	obj:loadTemplate(templatePath)

	if isSingleton then
		obj:retain()
		obj:setSingleton(isSingleton)
		self.SingletonPool[className] = obj
	end
	return obj
end

function UIManager:closeCurUI()
	Engine:getCurScene():closeCurWnd()
end

function UIManager:closeAllUI()
	Engine:getCurScene():closeAllWnd()
end

function UIManager:closeUIByKey(key)
	Engine:getCurScene():closeUIByKey(key)
end

function UIManager:getSingletonWndByName(className)
	if not className then return end
	return self.SingletonPool[className]
end

function UIManager:removeSingletonUIByName(className)
	if not className then return end
	local wnd = self.SingletonPool[className]
	if wnd then
		wnd:clear()
		wnd:release()
	end
	wnd = nil
end

function UIManager:clear()
	for k,wnd in pairs(self.SingletonPool) do
		wnd:clear()
		wnd:release()
	end
	self.SingletonPool = {}
end


return UIManager