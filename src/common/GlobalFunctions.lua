function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function lerp(t, from, to)
    return (1 - t) * from + t * to
end

function pGetDirection(from, to)
    local x, y = from.x, from.y
    local tx, ty = to.x, to.y
    local flag = tx < x and 1 or -1
    local angle = math.atan((y-ty)/(x-tx))
    if flag > 0 then 
        angle = math.deg(angle) - 180
    else
        angle = math.deg(angle)
    end
    return angle
end

function table.arrayContains(tab, val)
    for k,v in pairs(tab) do
        if v == val then
            return k
        end
    end
    return nil
end

function table.insertUnexistValue(array, value)
    if not table.arrayContains(array,value) then
        table.insert(array, value)
    end
end

function table.removeValue(array, value, removeadll)
    local deleteNum,i,max=0,1,#array
    while i<=max do
        if array[i] == value then
            table.remove(array,i)
            deleteNum = deleteNum+1 
            i = i-1
            max = max-1
            if not removeadll then break end
        end
        i= i+1
    end
    --  返回删除次数
    return deleteNum
end

function table.shuffle(array)
    local n, random, j = table.getn(array), math.random
    for i=1, n do
        j,k = random(n), random(n)
        array[j],array[k] = array[k],array[j]
    end
    return array
end

function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

function nodeBoundBoxFromLocalToGlobal(node, scale)
    if not scale then scale = 1 end
    local rect = node:getBoundingBox()
    local pos = node:convertToWorldSpace(cc.p(0,0))
    rect.x = pos.x
    rect.y = pos.y
    rect.width = rect.width * scale
    rect.height = rect.height * scale
    return rect
end

function focusTo(node, position, scale, duration, easeRate, onStart, onFinished)
    local newAnchor = cc.p(position.x/SCREEN.width, position.y/SCREEN.height)
    if easeRate == nil then
    	easeRate = 1
    end
    
    local oldAnchor = node:getAnchorPoint()
    local updateTime = 0
    node:scheduleUpdateWithPriorityLua(function(delta)
        updateTime = updateTime + delta
        if updateTime <= duration then
            node:setAnchorPoint(cc.pLerp(oldAnchor,newAnchor,updateTime/duration))
        else
            node:unscheduleUpdate()
        end
    end,0)
    
    node:runAction(
        cc.Sequence:create(
            cc.CallFunc:create(function()
                if onStart ~= nil then
                    onStart()
                end
                
            end),
            cc.Spawn:create(
                cc.EaseOut:create(cc.ScaleTo:create(duration, scale), easeRate),
                cc.EaseOut:create(cc.MoveTo:create(duration,cc.p(SCREEN.width/2-position.x, SCREEN.height/2-position.y)), 1)
            ),
            cc.CallFunc:create(function()
                if onFinished ~= nil then
                    onFinished()
                end
            end)
        )
    )
end


function colorString24B(colorStr)
    if not colorStr then
        return
    end
    if type(colorStr) == "number" then
        Log.e("colorStr type is not string")
        return
    end
    local r = getStringForPos(colorStr,3,4) 
    local g = getStringForPos(colorStr,5,6)
    local b = getStringForPos(colorStr,7,8)
    local a = getStringForPos(colorStr,9,10)
    return cc.c4b(tonumber("0x" .. r),tonumber("0x" .. g),tonumber("0x" .. b),tonumber("0x" .. a))
end

function c3b(c)
    return colorString24B(tostring(c).."ff")
end

function getStringForPos(str,sPos,ePos)
    return string.sub(str,sPos,ePos)
end

function string.startWith(str, Start)
    return string.sub(str,1,string.len(Start))==Start
end

function stringSplit(str, ch)  
    if not ch then
        ch = ',';
    end    
    local _tab = {};  
    while (true) do          
        local pos = string.find(str, ch);    
        if (not pos) then              
            local size_t = table.getn(_tab)  
        table.insert(_tab,size_t+1,str);  
        break;    
        end  

        local sub_str = string.sub(str, 1, pos - 1);                
        local size_t = table.getn(_tab)  
        table.insert(_tab,size_t+1,sub_str);  
        local t = string.len(str);  
        str = string.sub(str, pos + 1, t);     
    end      
    return _tab;  
end  


-- 遍历UI节点,返回指定名字的Node, 递归
function findNodeByName(root, name)
    local widget = ccui.Helper:seekWidgetByName(root,name)
    if widget == nil then
        Log.w("widget: "..name.."not found!")
    end
    return widget
end

function saveTexturePackerResToImages(plist)
    if cc.FileUtils:getInstance():isFileExist(plist) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
        local map = cc.FileUtils:getInstance():getValueMapFromFile(plist)
        for k,v in pairs(map.frames) do
            local sprite = cc.Sprite:createWithSpriteFrameName(k)
            sprite:setAnchorPoint(0,0)
            
            local tex = cc.RenderTexture:create(
                sprite:getContentSize().width, 
                sprite:getContentSize().height, 
                cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
            )

            tex:beginWithClear(1,1,1,0)
            sprite:visit()
            tex:endToLua()
            
            if string.find(k, "/") then
                local t = string.split(k,"/")
                k = t[#t]
            end
            print("save file: ".. k)
            tex:saveToFile( k, cc.IMAGE_FORMAT_PNG)
            
            
        end
    else
        print(plist.." NOT EXISTS")
    end

end

function objectPooling()

end