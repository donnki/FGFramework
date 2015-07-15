

----------系统--------------

require "json"
require "cocos.cocosdenshion.AudioEngine"
require "common.GlobalFunctions" 
require "common.helper"
require "common.deepcopy"

native 		= 		require "common.NativeHelper"
Log 		=		require "core.Logger"
Time 		= 		require "core.Time"
i18n 		= 		require "core.i18n"
http 		=    	require "core.manager.GameHttpClient"

--***********UI widgets*******
Toast 		= 		require("core.ui.widgets.UIToast")
TipWindow 	= 		require("core.ui.widgets.UITipWindow")



require "core.GameEngine"

Engine = GameEngine:getInstance()
Engine:init()

local AnySDKManager = require "core.AnySDKManager"
SDK = AnySDKManager:getInstance()

-- nativeAddNotification("RunPuppyRun", "Puppy: i'm missing you~", 10, 1024)

