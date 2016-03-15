

----------系统--------------

require "json"
require "cocos.cocosdenshion.AudioEngine"
require "common.GlobalFunctions" 
require "common.helper"
require "common.deepcopy"
-- require("common.iso")

-- require "pb"
package.path = package.path .. ";./core/network/protobuf/?.lua;"
package.cpath = package.cpath .. ';./core/network/protobuf/?.so;'
net 		= 		require("framework.cc.net.init")
cc.utils 	= 		require("framework.cc.utils.init")

native 		= 		require "common.NativeHelper"
Log 		=		require "core.Logger"
Time 		= 		require "core.Time"

http 		=    	require "core.manager.GameHttpClient"



--***********UI widgets*******
Toast 		= 		require("core.ui.widgets.UIToast")
TipWindow 	= 		require("core.ui.widgets.UITipWindow")
WarnningTipView = 	require("core.ui.widgets.UIWarnningTipView")
require("core.node.LabelEx")

SBMessage = require "core.network.SBMessage"
require "core.GameEngine"
i18n 		= 		require "core.i18n"
Engine = GameEngine:getInstance()
Engine:init()

if USE_ANYSDK then
	local AnySDKManager = require "core.AnySDKManager"
	SDK = AnySDKManager:getInstance()
end
-- nativeAddNotification("RunPuppyRun", "Puppy: i'm missing you~", 10, 1024)

