LoggerWindow = class("LoggerWindow",function()return cc.Layer:create()end)
LoggerWindow.__index = LoggerWindow
LoggerWindow.logListView = nil
LoggerWindow.toggleButton = nil
local instance = nil
local showed = false
local loggerWidth = display.width/2
function LoggerWindow:getInstance()
    if instance == nil then
        instance = LoggerWindow.new()
        instance:init()
        instance:retain()
    end
    return instance
end

function LoggerWindow.show()
    -- instance.logListView:getParent():runAction(cc.EaseOut:create(cc.MoveTo:create(0.5, cc.p(0,0)),5))
    instance.logListView:getParent():setPosition(0,0)
end

function LoggerWindow.hide()
    -- instance.logListView:getParent():runAction(cc.EaseOut:create(cc.MoveTo:create(0.5, cc.p(-loggerWidth,0)), 5))
    instance.logListView:getParent():setPosition(-loggerWidth,0)
end

function LoggerWindow.clearAll()
    instance.logListView:removeAllChildren()
    LoggerWindow.print("===============系统日志==============")
end

function LoggerWindow.print(str)
    print(str)
    if not DEBUG_MODE then
        return
    end
    local tmpText = ccui.Text:create()
    tmpText:setString(str)
    tmpText:setFontSize(16) 
    if string.sub(str,1,string.len("[DEBUG]")) == "[DEBUG]" then
        --tmpText:setColor(cc.c3b(159, 168, 176))  
    elseif string.sub(str,1,string.len("[TODO]")) == "[TODO]" then
        tmpText:setColor(cc.c3b(255, 168, 255))  
    elseif string.sub(str,1,string.len("[ERROR]")) == "[ERROR]" then
        tmpText:setColor(cc.c3b(255, 0, 0))  
    elseif string.sub(str,1,string.len("[WARN]")) == "[WARN]" then
        tmpText:setColor(cc.c3b(255, 255, 113))  
    elseif string.sub(str,1,string.len("[INFO]")) == "[INFO]" then
        tmpText:setColor(cc.c3b(124, 255, 0))  
    end

    local custom_item = ccui.Layout:create()
    custom_item:setContentSize(tmpText:getContentSize())
    tmpText:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
    custom_item:addChild(tmpText)

    if instance ~= nil then
        instance.logListView:insertCustomItem(custom_item, instance.logListView:getChildrenCount ())

        instance.logListView:scrollToBottom(0.1,true)
    end 
end

function LoggerWindow:scrollToBottom()
    self.logListView:scrollToBottom(0.1,true)
end

function LoggerWindow:init()
    print("Logger init")
    local box = cc.LayerColor:create(cc.c4b(100,100,100,100));
    box:setContentSize( cc.size(loggerWidth, display.height) );
    box:setPosition(-loggerWidth,0)
    self:addChild(box)
    
    local listView = ccui.ListView:create()
    listView:setSwallowTouches(false)
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(cc.size(loggerWidth-20, display.height-20))
    listView:setPosition(10,10)
    -- local function listViewEvent(sender, eventType)
    --     if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
    --         print("select child index = ",sender:getCurSelectedIndex())
    --     end
    -- end

    -- local function scrollViewEvent(sender, evenType)
    --     if evenType == ccui.ScrollviewEventType.scrollToBottom then
    --         print("SCROLL_TO_BOTTOM")
    --     elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
    --         print("SCROLL_TO_TOP")
    --     end
    -- end
    -- listView:addEventListener(listViewEvent)
    -- listView:addScrollViewEventListener(scrollViewEvent)

    -- local tmpText = ccui.Text:create()
    -- tmpText:setString("~~")
    -- tmpText:setFontSize(12) 
    -- local custom_item = ccui.Layout:create()
    -- custom_item:setContentSize(tmpText:getContentSize())
    -- tmpText:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
    -- custom_item:addChild(tmpText)
    -- listView:setItemModel(custom_item)

    listView:setItemsMargin(5.0)
    box:addChild(listView)
    self.logListView = listView
    for i=1,1 do
    LoggerWindow.print("===============系统日志==============")
    end

    
    local textButton = ccui.Button:create()
    textButton:setTouchEnabled(true)
    textButton:setTitleFontSize(30)
    textButton:setTitleText(">>>")
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if showed == true then
                showed = false
                instance.hide()
                sender:setTitleText(">>>")
            else
                showed = true
                instance.show()
                sender:setTitleText("<<<")
            end
        end
    end)
    textButton:setPosition(loggerWidth, display.height/2)

    box:addChild(textButton)

    textButton = ccui.Button:create()
    textButton:setAnchorPoint(1,0.5)
    textButton:setTouchEnabled(true)
    textButton:setTitleFontSize(20)
    textButton:setTitleText("清空当前日志")
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            instance.clearAll()
        end
    end)
    textButton:setPosition(loggerWidth, 20)
    box:addChild(textButton)

    textButton = ccui.Button:create()
    textButton:setAnchorPoint(1,0.5)
    textButton:setTouchEnabled(true)
    textButton:setTitleFontSize(20)
    textButton:setTitleText("打印内存信息")
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local sharedTextureCache = cc.Director:getInstance():getTextureCache()

            local function showMemoryUsage()
                print("---------------------------------------------------")
                print(string.format("LUA VM MEMORY USED: %0.2f KB", collectgarbage("count")))
                print(sharedTextureCache:getCachedTextureInfo(),"--------------------------------------------------------------")

            end
            showMemoryUsage()
        end
    end)
    textButton:setPosition(loggerWidth-150, 20)
    box:addChild(textButton)

    textButton = ccui.Button:create()
    textButton:setAnchorPoint(1,0.5)
    textButton:setTouchEnabled(true)
    textButton:setTitleFontSize(20)
    textButton:setTitleText("显示FPS")
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if not cc.Director:getInstance():isDisplayStats() then
                cc.Director:getInstance():setDisplayStats(true)
                sender:setTitleText("隐藏FPS")
            else
                cc.Director:getInstance():setDisplayStats(false)
                sender:setTitleText("显示FPS")
            end
        end
    end)
    textButton:setPosition(loggerWidth-300, 20)
    box:addChild(textButton)

    self:registerScriptHandler(function(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end)
end

function LoggerWindow:onEnter()
    self:scrollToBottom()
end

function LoggerWindow:onExit()
end

