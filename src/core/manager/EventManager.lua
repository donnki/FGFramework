-------------------
--统一管理Custom事件
-------------------

local EventManager = class("EventManager")

local instance = nil
EventManager.__index = EventManager
EventManager.eventDispatcher = nil

function EventManager:getInstance()
    if instance == nil then
    	instance  = EventManager.new()
        instance:init()
    end
    return instance
end

function EventManager:init()
    Log.d("EventManager初始化事件管理器")
    self.eventList = {}
    self.eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    self.on = self.registerEventHandler
    self.fire = self.dispatchEvent
    self.clear = self.removeEventHandler
end

function EventManager:registerEventHandler(eventType, handler, sender)
    Log.d("EventManager注册["..eventType.."]事件监听")
    local listener = cc.EventListenerCustom:create(tostring(eventType),function(event)
        local param = event.userdata

        Log.d("EventManager捕获["..eventType.."]事件")
        handler(param,sender)
    end)
    local key = tostring(eventType)
    if sender then
        key = key.."@"..tostring(sender):split(" ")[2]
    end
    if self.eventList[key] then
        Log.w("已注册相同事件：", key)
    end
    self.eventList[key] = listener
    self.eventDispatcher:addEventListenerWithFixedPriority(listener,1)
end

function EventManager:removeEventHandler(name,sender)
    if not name then return end
    local key = tostring(name)
    if sender then
        key = key.."@"..tostring(sender):split(" ")[2]
    end
    local listener = self.eventList[key]
    if listener then
        Log.d("EventManager移除事件" .. key)
        self.eventDispatcher:removeEventListener(listener)
        self.eventList[key] = nil
    else
        Log.w("事件："..key.."不存在")
    end
end

function EventManager:clear()
    for name,listener in pairs(self.eventList) do
        self.eventDispatcher:removeEventListener(listener)
    end
    self.eventList = {}
    Log.d("EventManager移除当前所有事件")
end

function EventManager:dispatchEvent(eventType, param)
    Log.d("EventManager分发["..eventType.."]事件")
    local event = cc.EventCustom:new(eventType)
    event.userdata = param
    self.eventDispatcher:dispatchEvent(event)
end


return EventManager