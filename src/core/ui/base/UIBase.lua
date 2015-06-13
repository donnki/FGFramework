
local UIBase = class("UIBase",
function()  
    local ins = cc.Layer:create() 
    -- createInstance(UIBase, ins)
    return ins;
end)
        
UIBase.__index = UIBase

function UIBase:init(...) --lua本身的数据请在这里初始化
    self:registerScriptHandler(function(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end)
end

function UIBase:clear()
    Log.d("UIBase:clear")
end

function UIBase:onEnter() -- lua引用c++的数据请在这里初始化
    Log.d("UIBase:onEnter")
end

function UIBase:onExit()
    Log.d("UIBase:onExit")
end

function UIBase:setSingleton(Singleton)
    if self.Singleton then
        assert(false,"this function Can be used only once")
    end
    self.Singleton = Singleton
end

function UIBase:getSingleton()
	Log.w("please use \"UIManager\" function \"getSingletonWndByName\"")
end

function UIBase:isSingleton()
    return self.Singleton
end

function UIBase:loadTemplate(tPath)
    if not tPath then return end
    if string.find(tPath,".ccs") or string.find(tPath,".csb") then -- 目前ccs2.x bug比较多 不建议使用
        --self.root = cc.CSLoader:createNode(tPath)
        --self.root = ccs.GUIReader:getInstance():widgetFromBinaryFile(tPath)
    elseif string.find(tPath,".ExportJson") or string.find(tPath,".json") then
        self.root = self:getTemplateByPath(tPath)
    end
    
    if not self.root then
        Log.e("not this template")
        return false
    end
    self:addChild(self.root)
    -- self:setClose()
    return true
end

function UIBase:setClose()
    local closeBtn = findNodeByName(self.root,"closeBtn")
    if closeBtn then
        local closeFunc = function()
            self:close()
        end
        closeBtn:addTouchEventListener(closeFunc)
    end
end

function UIBase:getTemplateByPath(path)
    return ccs.GUIReader:getInstance():widgetFromJsonFile(path)
end

function UIBase:hide()
    self:setVisible(false)
    self:setTouchEnabled(false)
end

function UIBase:show()
    self:setVisible(true)
    self:setTouchEnabled(true)
end

function UIBase:setControlsToList(nameList,lists) 
    -- nameList = {"proStars","nexStars"}
    -- 每个表内的name对应一个控件组, proStars,nexStars 控件数要相同的控件名放在同一个表内
    --lists 用来装载每一个组的控件
    if not nameList or not lists then return end
    local id = 1
    local str = ""
    
    for k,name in pairs(nameList) do
        id = 1
        while true do
            str = name .. id
            local obj = findNodeByName(self.root,str)
            if not obj then 
                break
            end
            obj.id = id
            lists[k][id] = obj
            id = id + 1
        end
    end
    
end

function UIBase:close()
    Log.todo("close current ui")
end
return UIBase