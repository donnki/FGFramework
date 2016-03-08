
local UIRoot = class("UIRoot" , function () --@return scene
    return cc.Layer:create()
end)
UIRoot.LocalZOrder = 0
UIRoot.__index = UIRoot

function UIRoot.ctor()
end

function UIRoot:init(config)
    self.childKeyList = {}
    self.curLayerKey = nil
    self.UiKeyList = {}
end

function UIRoot:registerWindow(key, window) 
    if not key or not window then return false end
    local isExist = self.childKeyList[key]
    if isExist then
        Log.w(key.."   window is already register")
        return false
    end
    self.childKeyList[key] = true
    table.insert(self.UiKeyList,key)
    window:setTag(key)
  -- window:setName(key)
  --  if window.onEnter then
  --      window:onEnter()
  --  end
    self.curLayerKey = key
    self:addChild(window,self.LocalZOrder)
    self.LocalZOrder = self.LocalZOrder + 1
    return true
end

function UIRoot:closeCurUI()
    self:removeWndByKey(self.curLayerKey)
end

function UIRoot:closeAllUI()
    for k,v in pairs(self:getChildren()) do
        self:removeWnd(v)
    end
    self.LocalZOrder = 0
end

function UIRoot:closeUIByKey(key)
    self:removeWndByKey(key)
end

function UIRoot:displayWindow(key)
    if not key then return end
    local window = self:getWndByKey(key)
    if window ~= nil then 
        window:show()
    end
end

function UIRoot:getWndByKey(key)
    if not key then return end
    return self:getChildByTag(key)
end

function UIRoot:callWndFuncByKey(wndKey,funcName,...)
    if not wndKey or not funcName then return end
    local wnd = self:getWndByKey(wndKey)
    if wnd then 
        wnd[funcName](wnd,...)
    end
end

function UIRoot:wndSetNewParentByKey(key,newParent)
    if not key or not newParent then return end
    local wnd = self:getWndByKey(key)
    if wnd then
        wnd:retain()
        wnd:removeFromParent()
        newParent:addChild(wnd)
        wnd:release()
    end
end

function UIRoot:removeWnd(wnd)
    if not wnd then return end
    local key = wnd:getTag()
  --  wnd:onExit()
    if not wnd:isSingleton() then
        wnd:clear()
    end
    wnd:hide(function ()
        wnd:removeFromParent()
    end)
    -- wnd:removeFromParent()
    
    table.remove(self.UiKeyList)
    local uiNum = #self.UiKeyList
    if uiNum > 0 then
        self.curLayerKey = self.UiKeyList[uiNum]
    end
   -- Log.i(key,"UIRoot:removeWnd")
    self.childKeyList[key] = nil
end

function UIRoot:removeWndByKey(key)
    if not key then return end

    local child = self:getWndByKey(key)
    self:removeWnd(child)
    self.LocalZOrder = self.LocalZOrder -1
end

function UIRoot:clear()
    for key,_ in pairs(self.childKeyList) do
        self:removeWndByKey(key)
    end
    self.childKeyList = {}
    self.UiKeyList = {}

end

function UIRoot.create(config)
    local scene = UIRoot.new()
    scene:init(config)
    return scene
end
return UIRoot
