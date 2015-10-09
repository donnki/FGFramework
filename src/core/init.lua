

----------系统--------------

require "json"
require "cocos.cocosdenshion.AudioEngine"
require "common.GlobalFunctions" 
require "common.helper"
require "common.deepcopy"

require "pb"
package.path = package.path .. ";./core/network/protobuf/?.lua;"
package.cpath = package.cpath .. ';./core/network/protobuf/?.so;'

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

if USE_ANYSDK then
	local AnySDKManager = require "core.AnySDKManager"
	SDK = AnySDKManager:getInstance()
end
-- nativeAddNotification("RunPuppyRun", "Puppy: i'm missing you~", 10, 1024)

