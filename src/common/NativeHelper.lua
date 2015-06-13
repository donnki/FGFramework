function isNativePlatform()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    --if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
    --    return true
    --else    
        return false
    --end
end


function nativeGetUDID()
    local udid = cc.UserDefault:getInstance():getStringForKey("DeviceUdid")
    if udid and udid ~= "" and udid ~= 0 then return udid end
    if Platform.isAndroid then
        local luaj = require "src/cocos/cocos2d/luaj"
        if luaj then
            local className = "org/cocos2dx/lua/AppActivity"
            local ok, _udid = luaj.callStaticMethod(className, "getUDID", {1}, "(I)Ljava/lang/String;")
            cc.UserDefault:getInstance():setStringForKey("DeviceUdid", _udid)
            return _udid
        end
    end
    local udid = tostring(os.time())
    cc.UserDefault:getInstance():setStringForKey("DeviceUdid", udid)
    return udid
end

function nativeAddNotification(title, detail, afterSec)
    if Platform.isAndroid then
        local luaj = require "src/cocos/cocos2d/luaj"
        if luaj then
            local className = "org/cocos2dx/lua/AppActivity"
            luaj.callStaticMethod(className, "addNotificationV2", {title, detail, afterSec, 1110}, "(Ljava/lang/String;Ljava/lang/String;II)V")
        end
    end

end

function nativeShowAchievements()
    if Platform.isAndroid then
        local luaj = require "src/cocos/cocos2d/luaj"
        if luaj then
            local className = "org/cocos2dx/lua/AppActivity"
            luaj.callStaticMethod(className, "showAchievements", {}, "()V")
        end
    end
end


function nativeShowLeaderboards()
    if Platform.isAndroid then
        local luaj = require "src/cocos/cocos2d/luaj"
        if luaj then
            local className = "org/cocos2dx/lua/AppActivity"
            luaj.callStaticMethod(className, "showLeaderboards", {}, "()V")
        end
    end
end

function nativePurchaseItem(pid)
    Engine.iap:payForProduct(pid, function(response)
        Log.i("[LUA] success: ", response)
    end,
    function(response)
        Log.i("[LUA] failed: ", response)
    end)
end