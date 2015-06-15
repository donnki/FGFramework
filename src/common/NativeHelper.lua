local native = {}
native.platform = {
    isMobile = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD,
    isAndroid = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID,
    isIOS = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD,
    isMac = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC,
}
local luaj = nil
if native.platform.isAndroid then
    luaj = require "src/cocos/cocos2d/luaj"
elseif native.platform.isIOS then
end

function native.getUDID()
    local udid = cc.UserDefault:getInstance():getStringForKey("DeviceUdid")
    if udid and udid ~= "" and udid ~= 0 then return udid end
    if luaj then
        local className = "com/luciolagames/cocos2dx/utils/CommonHelper"
        local ok, _udid = luaj.callStaticMethod(className, "getUDID", {1}, "(I)Ljava/lang/String;")
        cc.UserDefault:getInstance():setStringForKey("DeviceUdid", _udid)
        return _udid
    end
    
    local udid = tostring(os.time())
    cc.UserDefault:getInstance():setStringForKey("DeviceUdid", udid)
    return udid
end

function native.addNotification(title, detail, afterSec)
    if luaj then
        local className = "com/luciolagames/cocos2dx/utils/CommonHelper"
        local funcName = "addNotificationV2"
        local sig =  "(Ljava/lang/String;Ljava/lang/String;II)V"
        local argv = {title, detail, afterSec, 1110}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.showAchievements()
    if luaj then
        local className = "com/luciolagames/cocos2dx/utils/GooglePlayGameServicePlugin"
        local funcName = "showAchievements"
        local sig =  "()V"
        local argv = {}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end


function native.showLeaderboards()
    if luaj then
        local className = "com/luciolagames/cocos2dx/utils/GooglePlayGameServicePlugin"
        local funcName = "showLeaderboards"
        local sig =  "()V"
        local argv = {}
        
        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.purchaseItem(productID, successCallback, failedCallback)
    if luaj then
        local className = "com/luciolagames/cocos2dx/utils/GooglePlayIABPlugin"
        local funcName = "payForProduct"
        local sig = "(Ljava/lang/String;II)V"
        local argv = {productID, successCallback, failedCallback}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end


return native