
local UIBase = class("UIBase",
function()  
    local ins = cc.Layer:create() 
    -- createInstance(UIBase, ins)
    return ins;
end)

UIBase.__index = UIBase

-- local changeColorShader = require("ChangeColorShader")

function UIBase:init(...) --lua本身的数据请在这里初始化
    self:registerScriptHandler(function(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end)
end

function UIBase:setModal(isModal) -- 设置是不是模块框
    self._modal = isModal
    self.root:setSwallowTouches(not self._modal)
end

function UIBase:getModal()
    return self._modal
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

function UIBase:loadTemplate(tPath, subviews)
    if not tPath then return end

    if string.find(tPath,".ccs") or string.find(tPath,".csb") then -- 目前ccs2.x bug比较多 不建议使用
        self.root = cc.CSLoader:createNode(tPath)
        --self.root = ccs.GUIReader:getInstance():widgetFromBinaryFile(tPath)
    elseif string.find(tPath,".ExportJson") or string.find(tPath,".json") then
        self.root = self:getTemplateByPath(tPath)
    end
    if not self.root then
        Log.e("not this template")
        return false
    end
    -- self.root:setContentSize(display.width,display.height)
    -- ccui.Helper:doLayout(self.root)

    self:addChild(self.root)

    self.root:setPositionY(display.height/2-750/2)
    -- self:setClose()
    if subviews and #subviews > 0 then
        self.subviews = {}
        for i,v in ipairs(subviews) do
            self.subviews[v] = self.root:getChildByName(v)
            if self.subviews[v] == nil then
                Log.w("UI template not found: ", v)
            end
        end
         -- if self.initSubviews then
            self:initSubviews()
        -- end
    end
   
    return true
end

function UIBase:initSubviews()
    Log.w("子类需要覆盖initSubviews，以进行初始化监听事件等")
end

-- 测试用，清除灰色层,子类shopUI覆盖
function UIBase:setOpacity1()

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

-- 连级淡入 包括子孙
function UIBase:mFadeInAll(node, fadeInTime, finishCallBack)

    -- 递归主体
    local function recursionFunc(node, fadeInTime)
        if node.setOpacity and 255 == node:getOpacity() then
            node:setOpacity(0)
            node:runAction(cc.FadeIn:create(fadeInTime))
        end
        
        if node.setBright then
            local vi = node:isVisible()
            node:setVisible(false)
            node:runAction(cc.Sequence:create(cc.DelayTime:create(fadeInTime),
                cc.CallFunc:create(function ()
                    node:setVisible(vi)
                end)
                ))
        end

        local children = node:getChildren()
        for _, child in pairs(children) do
            recursionFunc(child, fadeInTime)
        end
    end
    recursionFunc(node, fadeInTime)

    if finishCallBack then
        node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(fadeInTime),
                cc.CallFunc:create(finishCallBack)
            )
        )
    end
end

function UIBase:mFadeOutAll(node, fadeOutTime, finishCallBack)

    -- 递归主体
    local function recursionFunc(node, fadeOutTime)
        if node.setOpacity then
            node:runAction(cc.FadeOut:create(fadeOutTime))
        end
        if node.setBright then
            node:setVisible(false)
        end

        local children = node:getChildren()
        for _, child in pairs(children) do
            recursionFunc(child, fadeOutTime)
        end
    end
    recursionFunc(node, fadeOutTime)

    if finishCallBack then
        node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(fadeOutTime),
                cc.CallFunc:create(finishCallBack)
            )
        )
    end
end

function UIBase:hide(func)
    self:runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(0.0833, 1.08),
            cc.ScaleTo:create(0.1667, 0.75),
            cc.CallFunc:create(function ()
                self:setVisible(false)
                self:setTouchEnabled(false)
            end),
            cc.CallFunc:create(func)))

    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.0833),
            cc.CallFunc:create(function ()
                self:mFadeOutAll(self, 0.1667)
            end)
        ))
end

function UIBase:show()
    self:setVisible(true)
    self:setTouchEnabled(true)
    self:setScale(0.75)
    
    self:runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(0.1667, 1.08), --10/60
            cc.ScaleTo:create(0.1333, 0.95), --8/60
            cc.ScaleTo:create(0.0833, 1))) --5/60

    self:mFadeInAll(self, 0.1667)
end

function UIBase:show_old()
    self:setVisible(true)
    self:setTouchEnabled(true)
    -- self:setScale(0.95)
    
    self:runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(3/60, 1.05),
            cc.ScaleTo:create(3/60, 1)))

    self:setOpacity1()
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