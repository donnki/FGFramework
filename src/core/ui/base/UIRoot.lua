
local UIRoot = class("UIRoot" , function () --@return scene
    return cc.Layer:create()
end)

UIRoot.__index = UIRoot

function UIRoot.ctor()
end

function UIRoot:init(config)
    self.childKeyList = {}
    self.curLayerKey = nil
    self.UiKeyList = {}
end

function UIRoot:registerWindow(key, window) 
    if not key or not window then return end
    local isExist = self.childKeyList[key]
    if isExist then
        Log.w("window is already register")
        return
    end
    self.childKeyList[key] = true
    table.insert(self.UiKeyList,key)
    window:setTag(key)
  -- window:setName(key)
  --  if window.onEnter then
  --      window:onEnter()
  --  end
    self.curLayerKey = key
    self:addChild(window)
end

function UIRoot:closeCurUI()
    self:removeWndByKey(self.curLayerKey)
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
    wnd:removeFromParent()
    
    table.remove(self.UiKeyList)
    local uiNum = #self.UiKeyList
    if uiNum > 0 then
        self.curLayerKey = self.UiKeyList[uiNum]
    end
 --   Log.i(self.curLayerKey,"UIRoot:removeWnd")
    self.childKeyList[key] = nil
end

function UIRoot:removeWndByKey(key)
    if not key then return end

    local child = self:getWndByKey(key)
    self:removeWnd(child)
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
