
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

LogLevel = {
    debug = 1,
    info = 2,
    warn = 3,
    error = 4,
}

DEBUG_MODE = true

DEBUG_SHOW_COLLISION_RECT = false

GAME_SPEED = 1

GameConfig = {
    logLevel = 1
}
ITEM_BOX_SPLIT               = 1                --自动切分地图块数
FRAME_PER_COLLISION_CHECK    = 1                --每隔多少帧检测一次碰撞

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.7 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}
