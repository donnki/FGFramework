----------------
--时间管理及同步
---------------

local Time = class("Time",{})
Time.__index = Time
Time.frameCount = 0
Time.delta = 0
Time.realtimeSinceStartup = 0
Time.serverTime = 0

function Time.onUpdate(delta)
    Time.delta = delta
    Time.realtimeSinceStartup = Time.realtimeSinceStartup + delta
    Time.frameCount = Time.frameCount + 1
end

function Time.async()
end

return Time