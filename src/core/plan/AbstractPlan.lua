local ByteArray = cc.utils.ByteArray

local Plan = class("Plan")
Plan.__index = Plan
local scheduler = cc.Director:getInstance():getScheduler()

function Plan:ctor(id, startTime, costTime, finishFunc, tickTime, tickFunc)
    self.id = id
    self.costTime = costTime        --总共需要花需的时间
    self.tickTime = tickTime and tickTime or 1 --默认tick值为1秒
    self.tickFunc = tickFunc
    self.finishFunc = finishFunc
    self:resetTimer(startTime)
    self:_init()
end

function Plan:resetTimer(startTime)
    self.stop = false  --用来标记定时器停止但不用移除的情况
    self.startTime = startTime
    -- self.timer = 0
    self.timer = os.time()-startTime
    -- print(self.timer)
    if self.tickTime == 0 then
        self.tickIndex = 0
    else
        self.tickIndex = self.timer / self.tickTime + 1
    end
end

function Plan:setCostTime(_costTime)
    self.costTime = _costTime
end

function Plan:getRemainTime()
    return self.costTime - self.timer
end

function Plan:_init() 
    
end

function Plan:_start()
    
    if self.schedulerHandle then
        scheduler:unscheduleScriptEntry(self.schedulerHandle)
        self.schedulerHandle = nil
    end

    self:onStart()
    self.schedulerHandle = scheduler:scheduleScriptFunc(function ( ... )
        self:_tick(...)
    end, self.tickTime, false)
end

function Plan:_tick(delta)
    self.timer = self.timer + delta
    if self.timer < self.costTime then
        self:onTick()
    else
        self:_stop(true)
    end
end

function Plan:_stop(finished)
    scheduler:unscheduleScriptEntry(self.schedulerHandle)
    self.schedulerHandle = nil
    if finished then
        self:onFinished()
    end
end

function Plan:_serialize()
    -- print(self.__cname, self.timer, self.costTime)
    local b = ByteArray.new(ByteArray.ENDIAN_BIG)
    b:writeStringUShort(self.__cname)
        :writeStringUShort(self.id)
        :writeDouble(self.timer)
        :writeDouble(self.costTime)
    return b:getBytes()
end

function Plan:getProgress()
    return self.timer / self.costTime 
end

function Plan:getCurTime()
    return self.timer
end

function Plan:planFinish()
    self.timer = self.costTime 
end

function Plan:onStart()
end

function Plan:onTick()
    if self.tickFunc then
        self.tickFunc(self)
    end
end

function Plan:onFinished()
    if self.finishFunc then
        return self.finishFunc(self)
    end
end

function Plan:onStop()
    self.stop = true
end

function Plan:onPause()
    
end

function Plan:onResume()
end

return Plan

