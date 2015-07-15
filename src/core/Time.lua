----------------
--时间管理及同步
---------------

local Time = class("Time",{})
Time.__index = Time
Time.frameCount = 0
Time.delta = 0
Time.realtimeSinceStartup = 0
Time.serverTime = 0

local recording = false
local recordTime = 0
local replaying = false
local frames = nil
local replayingIndex = 0
local replayingRecordTime = 0
local replayingRealTime = 0

local framesCount = 0
local endReplayCallback = nil
function Time.onUpdate(delta)
	Time.realtimeSinceStartup = Time.realtimeSinceStartup + delta
	Time.frameCount = Time.frameCount + 1
    Time.delta = delta

	if replaying then
		replayingIndex = replayingIndex + 1
		if replayingIndex > framesCount then
			Time.endReplay()
		else
			replayingRealTime = replayingRealTime + delta
			replayingRecordTime = replayingRecordTime + frames[replayingIndex]
		end
	elseif recording then
		recordTime = recordTime + delta
    	table.insert(frames, delta)
    end
end

function Time.async()
end

function Time.startRecord()
	recording = true
	recordTime = 0 
	frames = {}
end

function Time.endRecord()
	recording = false
end

local actions = {}

function Time.fireAction(key)
	table.insert(actions, {key, recordTime})
end

function Time.startReplay(callback)
	endReplayCallback = callback

	replaying = true
	replayingIndex = 0
	replayingRecordTime = 0
	replayingRealTime = 0
	framesCount = #frames
end

function Time.endReplay()
	replaying = false
	Log.i("End Replay")
	if endReplayCallback ~= nil then
		endReplayCallback()
		
	end
end

return Time