Platform = {
	isAndroid = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID,
	isIOS = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD,
	isMac = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC,
}

----------系统--------------
require "json"
require "cocos.cocosdenshion.AudioEngine"
require "common.GlobalFunctions" 
require "common.NativeHelper"
require "common.helper"
require "common.deepcopy"
Log = require "core.Logger"
Time = require "core.Time"

Toast = require("core.ui.widgets.UIToast")
TipWindow = require("core.ui.widgets.UITipWindow")

require "core.i18n"

require "core.GameEngine"

Engine = GameEngine:getInstance()
Engine:init()

local AnySDKManager = require "core.AnySDKManager"
SDK = AnySDKManager:getInstance()

-- nativeAddNotification("RunPuppyRun", "Puppy: i'm missing you~", 10, 1024)

