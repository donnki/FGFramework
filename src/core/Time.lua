----------------
--时间管理及同步
---------------

local Time = class("Time",{})
Time.__index = Time
Time.frameCount = 0
Time.delta = 0
Time.realtimeSinceStartup = 0
Time.offset = 0


local framesCount = 0
local endReplayCallback = nil
function Time.onUpdate(delta)
	Time.realtimeSinceStartup = Time.realtimeSinceStartup + delta
	Time.frameCount = Time.frameCount + 1
    Time.delta = delta

end

function Time.async()
end


return Time