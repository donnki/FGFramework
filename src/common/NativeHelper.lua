local native = {}
native.platform = {
    isMobile = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD,
    isAndroid = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID,
    isIOS = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD,
    isMac = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC,
}
local luaj = nil
local luaoc = nil
if native.platform.isAndroid then
    luaj = require "src/cocos/cocos2d/luaj"
elseif native.platform.isIOS then
    luaoc = require "src/cocos/cocos2d/luaoc"
end

function native.getUDID()
    local udid = cc.UserDefault:getInstance():getStringForKey("DeviceUdid")
    if udid and udid ~= "" and udid ~= 0 then return udid end
    if luaj then
        local className = "com/luciolagames/libfgeplugins/CommonHelper"
        local ok, _udid = luaj.callStaticMethod(className, "getUDID", {1}, "(I)Ljava/lang/String;")
        cc.UserDefault:getInstance():setStringForKey("DeviceUdid", _udid)
        return _udid
    end
    
    local udid = tostring(os.time())
    cc.UserDefault:getInstance():setStringForKey("DeviceUdid", udid)
    return udid
end

function native.addNotification(title, detail, delayTime)
    Log.i("native.addNotification")
    if luaj then
        local className = "com/luciolagames/libfgeplugins/CommonHelper"
        -- local className = "org/cocos2dx/lua/AppActivity"
        local funcName = "addNotification"
        local sig = "(Ljava/lang/String;Ljava/lang/String;I)V"
        local argv = {title, detail, delayTime}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.showAchievements()
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "showAchievements"
        local sig =  "()V"
        local argv = {}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.unlockAchievement(achievementID)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "unlockAchievement"
        local sig =  "(Ljava/lang/String;)V"
        local argv = {achievementID}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end


function native.showLeaderboards()
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "showLeaderboards"
        local sig =  "()V"
        local argv = {}
        
        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end


function native.showLeaderboardByID(lid, span)
    local timeSpan = span and span or 0
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "showLeaderboardByID"
        local sig =  "(Ljava/lang/String;I)V"
        local argv = {lid, timeSpan}
        
        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.leaderboardSubmitScore(lid, score)
    -- Log.i("native.leaderboardSubmitScore ", lid, score)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "submitLeaderboardScore"
        local sig =  "(Ljava/lang/String;I)V"
        local argv = {lid, score}
        
        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.loadLeaderboardScore(lid, callback)
    -- Log.i("native.leaderboardSubmitScore ", lid, score)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "loadLeaderboardScore"
        local sig =  "(Ljava/lang/String;I)V"
        local argv = {lid, callback}
        
        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.purchaseItem(productID, successCallback, failedCallback)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayIABPlugin"
        local funcName = "payForProduct"
        local sig = "(Ljava/lang/String;II)V"
        local argv = {productID, successCallback, failedCallback}

        luaj.callStaticMethod(className, funcName, argv, sig)
    elseif luaoc then

        luaoc.callStaticMethod("FGEPluginsIOSWapper", "payForProduct", {
            productID="com.banabala.jellyddd.sandyclockfew",
            successCallback = successCallback,
            failedCallback = failedCallback
            })
    end
end

function native.showInterstitialAD()
    Log.i("native.showInterstitialAD")
    if luaj then
        local className = "com/luciolagames/libfgeplugins/AdmobPlugin"
        local funcName = "showInterstitialAD"
        local sig = "()V"
        local argv = {}

        luaj.callStaticMethod(className, funcName, argv, sig)
    elseif luaoc then
        luaoc.callStaticMethod("AdmobPlugin", "showInterstitialAD", {
            })
    end
end

function native.showQuests()
    Log.i("native.showQuests")
    if luaj then
        local className = "com/luciolagames/libfgeplugins/GooglePlayGameServicePlugin"
        local funcName = "showQuests"
        local sig = "()V"
        local argv = {}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end

function native.onStatisticEvent(eventId, params)
    local jsonStr = "{}"
    if params then
        jsonStr = json.encode(params)
    end
    Log.i("native.onEvent, eventID: ", eventId, "params: ", jsonStr)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/TalkingGameStatisticPlugin"
        local funcName = "onStatisticEvent"
        local sig = "(Ljava/lang/String;Ljava/lang/String;)V"
        local argv = {eventId, jsonStr}

        luaj.callStaticMethod(className, funcName, argv, sig)
    elseif luaoc then
        luaoc.callStaticMethod("StatisticPlugin", "onStatisticEvent", {
            eventId=eventId,
            data = jsonStr
            })
    end
end

function native.onStatisticReward(mount, reason)
    Log.i("native.onStatisticReward, mount: ", eventId, "reason: ", jsonStr)
    if luaj then
        local className = "com/luciolagames/libfgeplugins/TalkingGameStatisticPlugin"
        local funcName = "onStatisticReward"
        local sig = "(ILjava/lang/String;)V"
        local argv = {mount, reason}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end 

function native.onStatisticMission( missionId,  state,  param)
    if not param then param = "" end
    Log.i("native.onStatisticMission, missionId: ", missionId, "state: ", state, "param: ", param)
    
    if luaj then
        local className = "com/luciolagames/libfgeplugins/TalkingGameStatisticPlugin"
        local funcName = "onStatisticMission"
        local sig = "(Ljava/lang/String;ILjava/lang/String;)V"
        local argv = {missionId, state, param}

        luaj.callStaticMethod(className, funcName, argv, sig)
    end
end 

return native