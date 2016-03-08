local i18n = {}

local currentLanguageType = cc.Application:getInstance():getCurrentLanguage()
local LANGUAGE = "zh_cn"
if currentLanguageType == cc.LANGUAGE_ENGLISH then
    LANGUAGE = "en_US"
elseif currentLanguageType == cc.LANGUAGE_CHINESE then
    LANGUAGE = "zh_cn"
end
local Languages = nil

function i18n.getLocalString(sid)
	local result = Engine.db:findByID("i18n", sid)
	if result[LANGUAGE] then
		return result[LANGUAGE]
	else
		return sid
	end
end
return i18n