--[[
    GameService登录、成就、排行榜管理
]]
local InAppPurchaseManager = class("InAppPurchaseManager")


local instance = nil
InAppPurchaseManager.__index = InAppPurchaseManager

function InAppPurchaseManager:getInstance()
    if instance == nil then
        instance  = InAppPurchaseManager.new()
        instance:init()
    end
    return instance
end

function InAppPurchaseManager:init()
end

function InAppPurchaseManager:payForProduct(productID, successCallback, failedCallback)
    Log.i("InAppPurchaseManager:payForProduct")
    if Platform.isAndroid then
        local className = "org/cocos2dx/lua/GooglePlayIABPlugin"
        local funcName = "payForProduct"
        local sig = "(Ljava/lang/String;II)V"
        local argv = {productID, successCallback, failedCallback}

        local luaj = require "src/cocos/cocos2d/luaj"
        if luaj then
            luaj.callStaticMethod(className, funcName, argv, sig)
        end
    end
end

return InAppPurchaseManager