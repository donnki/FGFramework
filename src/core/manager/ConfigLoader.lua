Keys = {
    player = {
        coins = "PLAYER_COINS",
        diamonds = "PLAYER_COINS",
    }

}

local ConfigLoader = class("ConfigLoader")
local instance = nil
ConfigLoader.__index = ConfigLoader

local function loadLocalValueByKey(key, hashCheck, forseEncode)
    local value = cc.UserDefault:getInstance():getStringForKey(key)
    if (isNativePlatform() and hashCheck) or forseEncode then
        local validation = tostring(nativeCyptoKeyValue(key, value))
        if validation == cc.UserDefault:getInstance():getStringForKey(key.."_hash") then
            return value
        else
            return 0
        end
    else
        if value == nil or value == "" then
            return 0
        else
            return value
        end
    end
    
end

local function saveLocalValueByKey(key, value, hashCheck, forseEncode)
    cc.UserDefault:getInstance():setStringForKey(key, value)
    if (isNativePlatform() and hashCheck) or forseEncode then
        local validation = nativeCyptoKeyValue(key, value)
        cc.UserDefault:getInstance():setStringForKey(key.."_hash", validation)
    end
end



function ConfigLoader:getInstance()
    if instance == nil then
        instance  = ConfigLoader.new()
        instance:init()
    end
    return instance
end

local _forseEncode = false
function ConfigLoader:init()
    if DEBUG_MODE then
        _forseEncode = false
    end
end

function ConfigLoader:loadValue(key, hashCheck)
    return loadLocalValueByKey(key, hashCheck, _forseEncode)
end

function ConfigLoader:saveValue(key, value, hashCheck)
    return saveLocalValueByKey(key, value, hashCheck, _forseEncode)
end


return ConfigLoader