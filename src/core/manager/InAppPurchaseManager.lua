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
    native.purchaseItem(productID, successCallback, failedCallback)
end

return InAppPurchaseManager