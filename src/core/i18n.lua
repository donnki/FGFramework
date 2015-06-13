local currentLanguageType = cc.Application:getInstance():getCurrentLanguage()
local LANGUAGE = "zh_cn"
if currentLanguageType == cc.LANGUAGE_ENGLISH then
    LANGUAGE = "en"
elseif currentLanguageType == cc.LANGUAGE_CHINESE then
    LANGUAGE = "zh_cn"
end
LANGUAGE = "en"

local Languages = nil

function getLocalString(sid)

	if not Languages then
		Languages = require("game.data.Language")
	end
	if Languages[sid] then
		Log.dump(Languages[sid])
		return Languages[sid][LANGUAGE]
	else
		Log.w("No localString, return: ", sid)
		return sid
	end
end
