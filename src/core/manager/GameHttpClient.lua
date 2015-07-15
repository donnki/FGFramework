local http = {}

--[[
cc.XMLHTTPREQUEST_RESPONSE_STRING       = 0
cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER = 1
cc.XMLHTTPREQUEST_RESPONSE_BLOB         = 2
cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT     = 3
cc.XMLHTTPREQUEST_RESPONSE_JSON         = 4
]]

function http.doGet(url, responseCallback, responseType)
	local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = responseType and responseType or 0
    xhr:open("GET", url)

    local function onReadyStateChange()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local statusString = "Http Status Code:"..xhr.statusText
            if responseCallback then
            	responseCallback(xhr.response)
            end
        else
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        end
    end

    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end 
return http