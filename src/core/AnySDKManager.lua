require "anysdkConst"

local AnySDKManager = class("AnySDKManager")
AnySDKManager.__index = AnySDKManager
local instance = nil
local appKey = "A72B77D8-9763-D544-0B97-F7BD32B5E4B9"
local appSecret = "c8d247834cf2c54fe9531a150bd33072"
local privateKey = "AE45787B84EA5E4974788C0B3D309520"
local oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"

AnySDKManager.ready = false
AnySDKManager.udid = nil
AnySDKManager.channelID = 0
local SessionOrder_ID = nil
function AnySDKManager:getInstance()
    if instance == nil then
        instance = AnySDKManager.new()
        instance:init()

    end
    return instance
end

function AnySDKManager:init()
    if AgentManager ~= nil then
        Log.i("初始化AnySDK")
        self.udid = nativeGetUDID()
        self.channelID = AgentManager:getInstance():getChannelId()
        self.agent = AgentManager:getInstance()
        self.agent:init(appKey,appSecret,privateKey,oauthLoginServer)
        self.agent:loadALLPlugin()

        self:initStatistic()    --初始化统计
        self:initIAP()          --初始化内购iAP
        self:initAD()           --初始化广告

        self.ready = true
    else
        Log.w("未接入AnySDK")
        self.ready = false
    end
end


function AnySDKManager:initStatistic()
    Log.i("初始化统计平台")
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    analytics_plugin:startSession()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("setAccount")) then
        local udid = nativeGetUDID()
        local paramMap = {
            Account_Id = self.udid,
            Account_Name = self.udid,
            Account_Type = string.format(AccountType.ANONYMOUS),
            Account_Level = "1",
            Account_Age = "20",
            Account_Operate = string.format(AccountOperate.LOGIN),
            Account_Gender = string.format(AccountGender.MALE),
            Server_Id = "1"
        }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("setAccount", data);
    end
end

function AnySDKManager:initIAP()
    Log.i("初始化内购系统")
    local iap_plugin_maps = self.agent:getIAPPlugin()
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    for key, value in pairs(iap_plugin_maps) do
        value:setResultListener(function(code, msg, info )
            Log.t("On Pay result, code: ", code, ", info: ", info)
            if code == "kPaySuccess" then
                if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeOnlySuccess")) then
                    local paramMap = {
                        Order_Id = SessionOrder_ID,
                        Product_Name = info.Product_Name,
                        Currency_Amount = tostring(info.Product_Price),
                        Currency_Type = "USD",
                        Payment_Type = AgentManager:getInstance():getChannelId(),
                        Virtual_Currency_Amount = info.Product_Count
                    }
                    local data = PluginParam:create(paramMap);
                    analytics_plugin:callFuncWithParam("onChargeOnlySuccess",data);
                end

                Engine:getDataManager().player:addCurrency("diamonds", info.Product_Count)
                -- Toast.makeText("Buy Item".. info.Product_Id.." Success. ")
            elseif code =="kPayCancel" then
                if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeFail")) then
                    local param = {
                        Order_Id = SessionOrder_ID,
                        Fail_Reason = "UserCancled, "..dump(info)
                    }
                    local data = PluginParam:create();
                    analytics_plugin :callFuncWithParam("onChargeFail",data);
                end
                -- Toast.makeText("User Cancled.")
            elseif code == "kPayFail" then
                if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeFail")) then
                    local param = {
                        Order_Id = SessionOrder_ID,
                        Fail_Reason = "PayFailed, "..dump(info)
                    }
                    local data = PluginParam:create();
                    analytics_plugin :callFuncWithParam("onChargeFail",data);
                end
                -- Toast.makeText("Pay Failed .")
            elseif code == "kPayNetworkError" then
                if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeFail")) then
                    local param = {
                        Order_Id = SessionOrder_ID,
                        Fail_Reason = "Network Error, "..dump(info)
                    }
                    local data = PluginParam:create();
                    analytics_plugin :callFuncWithParam("onChargeFail",data);
                end
                -- Toast.makeText("NetworkError.")
            elseif code == "kPayProductionInforIncomplete" then
                if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeFail")) then
                    local param = {
                        Order_Id = SessionOrder_ID,
                        Fail_Reason = "PayProductionInforIncomplete, "..dump(info)
                    }
                    local data = PluginParam:create();
                    analytics_plugin :callFuncWithParam("onChargeFail",data);
                end
                -- Toast.makeText("PayProductionInforIncomplete")
            else
                -- Toast.makeText("UnknownError")
            end
        end)
    end
end

function AnySDKManager:initAD()
    Log.i("初始化广告平台")
    local ads_plugin = AgentManager:getInstance():getAdsPlugin();
    ads_plugin:setAdsListener(function(code, msg)
        if code == AdsResultCode.kAdsReceived then
            AD_LOADED = true
        elseif code == AdsResultCode.kNetworkError then
            self:onEvent("ad_load_error_network")
            AD_LOADED = false
        elseif code == AdsResultCode.kUnknownError then
            self:onEvent("ad_load_error_unknown")
            AD_LOADED = false
        elseif code == AdsResultCode.kAdsShown then
            self:onEvent("ad_showed_success")
        end
    end)
    ads_plugin:preloadAds(AdsType.AD_TYPE_FULLSCREEN)
end

function AnySDKManager:showAD()
    if not self.ready then return end
    if AD_LOADED then
        AgentManager:getInstance():getAdsPlugin():showAds(AdsType.AD_TYPE_FULLSCREEN)
    else
        Log.i("AD not loaded yet! ")
    end
end

function AnySDKManager:onEvent(eventID, param)
    -- Log.t("Log Event: ", eventID, param)
    if not self.ready then return end
    if param then
        AgentManager:getInstance():getAnalyticsPlugin():logEvent(eventID, param)
    else
        AgentManager:getInstance():getAnalyticsPlugin():logEvent(eventID)
    end
end

function AnySDKManager:onPurchase(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("onPurchase")) then
        -- local paramMap = {
        --  Item_Id = "123456",
        --  Item_Type = "test",
        --  Item_Count = string.format(2),
        --  Vitural_Currency = "1",
        --  Currency_Type = agent:getChannelId()
        -- }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("onPurchase",data);
        Log.i("Statistic onPurchase")
    else
        Log.w("Current AnalyticsPlugin Not Support onPurchase")
    end
end

function AnySDKManager:onUse(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("onUse")) then
        -- local paramMap = {
        -- Item_Id = "123456",
        -- Item_Type = "test",
        -- Item_Count = "2",
        -- Use_Reason = "1"
        -- }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("onUse",data);
    else
        Log.w("Current AnalyticsPlugin Not Support onUse")
    end
end

--[[
参数  是否必传    参数说明
IsCoin  Y   是否为游戏币统计(1为是，0为否)
Item_Id Y   物品标示符
Item_Type   Y   物品类型
Item_Count  Y   物品数量
Item_Price  Y   物品价格
Use_Reason  Y   用途说明
Coin_Num    Y   游戏币数量(游戏币统计必传)
Event_Type  Y   事件类型(后台定义)
]]
function AnySDKManager:onReward(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("onReward")) then
        -- local paramMap = {
        -- Item_Id = "123456",
        -- Item_Type = "test",
        -- Item_Count = "2",
        -- Use_Reason = "1"
        -- }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("onReward",data);
    end
end

function AnySDKManager:onStartLevel(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("startLevel")) then
        -- local paramMap = {
        --     Level_Id = "123456",
        --     Seq_Num = "1"
        --  }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("startLevel", data);
    end
end

function AnySDKManager:onFinishLevel(levelID)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("finishLevel")) then
        local data = PluginParam:create(levelID);
        analytics_plugin:callFuncWithParam("finishLevel",data);
    end
end

function AnySDKManager:onFailedLevel(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("failLevel")) then
        -- local paramMap = {
        -- Level_Id = "123456",
        -- Fail_Reason = "test"
        -- }
        local data = PluginParam:create(paramMap)
        analytics_plugin:callFuncWithParam("failLevel",data)
    end
end

function AnySDKManager:onStartTask(paramMap)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("startTask")) then
        -- local paramMap  ={
        -- Task_Id = "123456",
        -- Task_Type = string.format(TaskType.GUIDE_LINE)
        -- }
        local data = PluginParam:create(paramMap);
        analytics_plugin:callFuncWithParam("startTask",data);
    end
end

function AnySDKManager:onFinishTask(taskID)
    if not self.ready then return end
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
     if(analytics_plugin and analytics_plugin:isFunctionSupported("finishTask")) then
        local data = PluginParam:create(taskID);
        analytics_plugin:callFuncWithParam("finishTask",data);
    end
end


    

function AnySDKManager:buyItem(info)
    if not self.ready then return end
    Log.t("准备游戏内购买：", info)
    SessionOrder_ID = self.udid..os.time()
    --购买统计
    local analytics_plugin = AgentManager:getInstance():getAnalyticsPlugin()
    if(analytics_plugin and analytics_plugin:isFunctionSupported("onChargeRequest")) then
        local paramMap = {
            Order_Id = SessionOrder_ID,
            Product_Name = info.Product_Name,
            Currency_Amount = tostring(info.Product_Price),
            Currency_Type = "USD",
            Payment_Type = AgentManager:getInstance():getChannelId(),
            Virtual_Currency_Amount = info.Product_Count,
        }
        local data = PluginParam:create(paramMap)
        analytics_plugin:callFuncWithParam("onChargeRequest",data)
    end

    local iap_plugin_maps = AgentManager:getInstance():getIAPPlugin()
    for key, value in pairs(iap_plugin_maps) do
        
        value:payForProduct(info)
    end
end

function AnySDKManager:endSession()
    if not self.ready then return end
    AgentManager:getInstance():getAnalyticsPlugin():stopSession()
    AgentManager:endManager()
end

function AnySDKManager:callTestIAP()
    Log.i("test iap")
    if not self.ready then return end
	local info = {
       Product_Price="1", 
       Product_Id="com.banabala.runpuppyrun.diamond100",  
       Product_Name="gold",  
       Server_Id="13",  
       Product_Count="1",  
       Role_Id=self.udid,  
       Role_Name=self.udid,
       Role_Grade="50",
       Role_Balance="1"
    }
    if cc.PLATFORM_OS_ANDROID == cc.Application:getInstance():getTargetPlatform() then
		local iap_plugin_maps = AgentManager:getInstance():getIAPPlugin()
        for key, value in pairs(iap_plugin_maps) do
            value:payForProduct(info)
        end
	end
end



return AnySDKManager
