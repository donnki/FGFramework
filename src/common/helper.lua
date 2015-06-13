-- 这个文件是用来放所有通用的帮助函数的


-- 返回某个目录的下的文件列表
-- 仅支持windows
DIR_ALL = 0
DIR_FILE = 1
DIR_DIRECTIORY = 2
function dir(directory, type)
    local i, t, popen = 0, {}, io.popen

    local attr = ''     -- dir /a的参数
    if(type == DIR_FILE) then attr = '-d' end
    if(type == DIR_DIRECTIORY) then attr = 'd' end

    for filename in popen('dir "'..directory..'" /b /a'..attr):lines() do --这是Windows版,自己修改dir命令的参数，此为列举目录
        i = i + 1
        t[i] = filename
    end
    return t
end

local function search(k,plist)  
    for i=1,#plist do  
        local v=plist[i][k] --   取一个基类  
        if v then return v end  
    end  
end  

function createClass(...)  
    local c={};  
    local parents={...};  
  
    setmetatable(c,{__index=function(t,k) return search(k,parents) end } );  
  
    c.__index=c;  
  
    function c:new(o)  
        o=o or {};  
        setmetatable(o,c);  
        return o;  
    end  
  
    return c;  
end 

function utfstrlen(str)
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end

function truncateUTF8String(s, n)
    local dropping = string.byte(s, n+1)
    if not dropping then return s end
    if dropping >= 128 and dropping < 192 then
        return truncateUTF8String(s, n-1)
    end
    return string.sub(s, 1, n)
end


-- string.split
string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

-- table转string
table.tostring = function(t)
  local mark = {}
  local assign = {}
  local function ser_table(tbl,parent)
    mark[tbl] = parent
    local tmp={}
    for k,v in pairs(tbl) do
      local key= type(k)=="number" and "["..k.."]" or "[".. string.format("%q", k) .."]"
      if type(v)=="table" then
        local dotkey= parent.. key
        if mark[v] then
          table.insert(assign,dotkey.."='"..mark[v] .."'")
        else
          table.insert(tmp, key.."="..ser_table(v,dotkey))
        end
      elseif type(v) == "string" then
        table.insert(tmp, key.."=".. string.format('%q', v))
      elseif type(v) == "number" or type(v) == "boolean" then
        table.insert(tmp, key.."=".. tostring(v))
      end
    end
    return "{"..table.concat(tmp,",").."}"
  end
  return ser_table(t,"ret")..table.concat(assign," ")
end

table.contains = function(tbl, obj)
    for k,v in pairs(tbl) do
        if v == obj then
            return k
        end
    end
    return nil
end

table.allKeys = function(tbl)
    local keys = {}
    for k, v in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end
-- string转table
table.loadstring = function(strData)
  return loadstring("return "..strData)()
end

-- dump table
local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next

function print_r(aTable, indent)

    if not aTable then return end
    if type(aTable) ~= "table" then return end
    if not indent then indent = 0 end -- 缩进

    -- table左花括号
    print(string.rep("    ", indent).."{")

    -- 花括号里面的内容再缩进2格
    local curTabStr = string.rep("    ", indent + 1)

    for k,v in pairs(aTable) do

        -- table类型 递归
        if type(v) == "table" then
            print(curTabStr .. k .. " = ")
            print_r(v, indent + 1)
        else

            -- 其他类型 直接打印
            print(curTabStr .. k .. " = " .. tostring(v) .. ",")
        end

    end

    -- table右花括号
    print(string.rep("    ", indent) .. "},")

end

function dump(obj)  
    local getIndent, quoteStr, wrapKey, wrapVal, isArray, dumpObj  
    getIndent = function(level)  
        return string.rep("\t", level)  
    end  
    quoteStr = function(str)  
        str = string.gsub(str, "[%c\\\"]", {  
            ["\t"] = "\\t",  
            ["\r"] = "\\r",  
            ["\n"] = "\\n",  
            ["\""] = "\\\"",  
            ["\\"] = "\\\\",  
        })  
        return '"' .. str .. '"'  
    end  
    wrapKey = function(val)  
        if type(val) == "number" then  
            return "[" .. val .. "]"  
        elseif type(val) == "string" then  
            return "[" .. quoteStr(val) .. "]"  
        else  
            return "[" .. tostring(val) .. "]"  
        end  
    end  
    wrapVal = function(val, level)  
        if type(val) == "table" then  
            return dumpObj(val, level)  
        elseif type(val) == "number" then  
            return val  
        elseif type(val) == "string" then  
            return quoteStr(val)  
        else  
            return tostring(val)  
        end  
    end  
    local isArray = function(arr)  
        local count = 0   
        for k, v in pairs(arr) do  
            count = count + 1   
        end   
        for i = 1, count do  
            if arr[i] == nil then  
                return false  
            end   
        end   
        return true, count  
    end  
    dumpObj = function(obj, level)  
        if type(obj) ~= "table" then  
            return wrapVal(obj)  
        end  
        level = level + 1  
        local tokens = {}  
        tokens[#tokens + 1] = "{"  
        local ret, count = isArray(obj)  
        if ret then  
            for i = 1, count do  
                tokens[#tokens + 1] = getIndent(level) .. wrapVal(obj[i], level) .. ","  
            end  
        else  
            for k, v in pairs(obj) do  
                tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","  
            end  
        end  
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"  
        return table.concat(tokens, "\n")  
    end  
    return dumpObj(obj, 0)  
end  

function string.toArray(str )
    local len = string.len(str)
    local strs = {}
    for i=1,len do
        local value = string.sub(str,i,i)
        table.insert(strs,value)
    end
    return strs
end
ccdump = print_r

-- 遍历UI节点,返回指定名字的Node, 递归
--[[function findNodeByName(root, name)

    if not root.getChildByName then return nil end

    local res = ccui.Helper:seekWidgetByName(root,name)
    if res then
        return res
    else
        local children = root:getChildren()
        for _, ch in pairs(children) do
            res = findNodeByName(ch, name)
            if res then
                return res
            end
        end
    end
end]]

-- ccs的输入框功能太弱, 改成EditBox, but 不能捆绑事件, 会崩溃??, 直接加在widget上触摸顺序也有问题, 各种问题啊 输入框......
function convertInputFiledToEditBox(inputFiled)
    assert(inputFiled)

    local scaleX = inputFiled:getScaleX()
    local scaleY = inputFiled:getScaleY()
    local contentSize = cc.size(inputFiled:getContentSize().width * scaleX, inputFiled:getContentSize().height * scaleY)
    local position = cc.p(0, 0)
    -- 新建个editBox 加在inputFiled上
    
    
    local editBox =  ccui.EditBox:create(contentSize,"spritePlist/liaotianshuru.PNG")
    editBox:setPosition(position)
    editBox:setFontColor(cc.c3b(255, 255, 255))
    editBox:setFontSize(20)
    
    editBox:setTag(1)
    editBox:setLocalZOrder(10)
    editBox:setAnchorPoint(cc.p(0,0))
  
    editBox:setPlaceHolder("请输入你想说的话")

    editBox:setFontSize(20)
    editBox:setMaxLength(50)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --     self.editBox:setTouchEnabled(true)
--    editBox:setReturnType(ccui.EditBox.KeyboardReturnType.DONE)
--    editBox:setInputMode(ccui.EditBox:setInputMode(ccui.)) 
    --Handler
    --    self.editBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = pSender
        local strFmt 
        if strEventName == "began" then
            strFmt = string.format("editBox %p DidBegin !", edit)
            print(strFmt)
        elseif strEventName == "ended" then
            strFmt = string.format("editBox %p DidEnd !", edit)
            print(strFmt)
        elseif strEventName == "return" then
            strFmt = string.format("editBox %p was returned !",edit)
          
            print(strFmt)
        elseif strEventName == "changed" then
            strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
            print(strFmt)
        end
    end
    editBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
 
    
    inputFiled:addChild(editBox)
    inputFiled:setScale(1)
    inputFiled:setOpacity(0)
    inputFiled:setTouchEnabled(false)
    return editBox
end


-- 统一改成代码写的listview 
function convertListView(widget, direction, gravity)
    assert(widget)
    local size = widget:getSize()
    local listView = ccui.ListView:create()
    listView:setDirection(direction)
    listView:setGravity(gravity)
    listView:setBounceEnabled(true)
    --listView:setBackGroundImage("res/scene/17010002/SW04_lutai1.png")
    -- listView:setBackGroundImageScale9Enabled(true)
    listView:setSize(size)

    widget:addChild(listView)
    return listView
end

--继承native C++ Object的方法
function createInstance(class, obj)
    local t = tolua.getpeer(obj)
    if not t then
        t = {}
        tolua.setpeer(obj, t)
    end
    setmetatable(t, class)
    return obj
end

-- 帧转换为时间
function formatFrameTimeAbout(frameData, frameTime)
    if frameData == nil then return nil end
    local frameTime = frameTime or 0.1  --默认每帧0.1秒

    --frameData=3
    if type(frameData) == "number" then
        return frameData * frameTime
    elseif type(frameData) == "table" and #frameData > 0 then
        --数字数组
        --{2,3,4}
        if type(frameData[1]) == "number" then
            for index = 1, #frameData do
                frameData[index] = frameData[index] * frameTime
            end
            return frameData
        --table数组
        --{{3,{20,0}},{4,{10,0}}}
        elseif type(frameData[1] == "table") then
            for index = 1, #frameData do
                frameData[index][1] = frameData[index][1] * frameTime
            end
            return frameData
        end
    end

    return nil
end


-- 地图坐标的y轴<=可视坐标的y轴
local posXRatio = 1.0
local posYRatio = 0.8

-- 获取转化为地图的坐标，距离
function getMapPositionAbout(faceOffset, faceDistance)
    local mapOffset = cc.p(faceOffset.x * posXRatio, faceOffset.y * posYRatio)
    if faceDistance ~= nil then
        if cc.pGetLength(faceOffset) > 0 then
            faceDistance = faceDistance * cc.pGetLength(mapOffset) / cc.pGetLength(faceOffset)
        else
            faceDistance = 0
        end
    end
    return mapOffset, faceDistance
end

-- 获取转化为正面的坐标，距离
function getFacePositionAbout(mapOffset, mapDistance)
    local faceOffset = cc.p(mapOffset.x / posXRatio, mapOffset.y / posYRatio)
    if mapDistance ~= nil then
        mapDistance = mapDistance * cc.pGetLength(faceOffset) / cc.pGetLength(mapOffset)
    end
    return faceOffset, mapDistance
end

-- 转换为坐标
-- {10,10}转换为cc.p(10,10)
function convertToPoint(t)
    assert(type(t) == "table", "convertToPoint 参数不是table")
    return cc.p(t[1], t[2])
end

-- 在表中是否存在某值
function isExistInTable(_table, _value)
    if _value == nil then
        print("isExistInTable value is nil")
        return false
    end

    if type(_table) ~= "table" then
        print("isExistInTable _table is not a table type")
        return false
    end

    for _, v in ipairs(_table) do
        if v == _value then return true end
    end
    return false
end

-- 执行回调
function doCallback(callback, obj)
    if callback ~= nil then
        if obj ~= nil then
            callback(obj)
        else
            callback()
        end
    end
end

-- 通过表数组获取数组
-- 参数a={10, 20}, b={40, 50}，getTableByTableArray(a, b)返回{10, 20, 40, 50}
function getArrayByArrayTables(...)
    local finalTable = {}

    local args = {...}
    for _, arg in ipairs(args) do
        assert(type(arg) == "table", "getArrayByTableArray arg不是表")
        for __, v in ipairs(arg) do
            table.insert(finalTable, v)
        end
    end

    return finalTable
end

-- 网络回调返回是否正确
function isCallbackSuccess(data)
    return (data.r > 0)
end

-- 定时调用 类js中的setTimeout
-- time: 单位秒
function setTimeout(f, time)
    local inst = nil
    local function _func ()
        if inst then
            f()
            gScheduler:unscheduleScriptEntry(inst)
            inst = nil
        end
    end

    inst = gScheduler:scheduleScriptFunc(_func, time, false)
end

-- 获取全路径
function getFullPathForFilename(path)
    return cc.FileUtils:getInstance():fullPathForFilename(path)
end



-- 获取widget的rect
function getWidgetBoundingBox(widget)
    assert(widget ~= nil, "getWidgetBoundingBox widget为nil")

    local anchorPoint = cc.p(widget:getAnchorPoint())
    local position = cc.p(widget:getPosition())
    local size = widget:getSize()

    local x = position.x - anchorPoint.x * size.width
    local y = position.y - anchorPoint.y * size.height

    return cc.rect(x, y, size.width, size.height)
end

-------------------------
-- GUI 操作
-------------------------

-- 连级淡入 包括子孙
function casecadeFadeInNode(node, fadeInTime, finishCallBack)

    -- 递归主体
    local function recursionFunc(node, fadeInTime)

        if node.setOpacity then
            node:setOpacity(0)
            node:runAction(cc.FadeIn:create(fadeInTime))
        end

        local children = node:getChildren()
        for _, child in pairs(children) do
            recursionFunc(child, fadeInTime)
        end
    end
    recursionFunc(node, fadeInTime)

    -- 结束回调(粗略)
    if finishCallBack then
        node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(fadeInTime),
                cc.CallFunc:create(finishCallBack)
            )
        )
    end
end

-- 连级淡出 包括子孙
function casecadeFadeOutNode(node, fadeOutTime, finishCallBack)

    -- 递归主体
    local function recursionFunc(node, fadeOutTime)

        if node.setOpacity then
            node:setOpacity(255)
            node:runAction(cc.FadeOut:create(fadeOutTime))
        end

        local children = node:getChildren()
        for _, child in pairs(children) do
            recursionFunc(child, fadeOutTime)
        end
    end
    recursionFunc(node, fadeOutTime)

    -- 结束回调(粗略)
    if finishCallBack then
        node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(fadeOutTime),
                cc.CallFunc:create(finishCallBack)
            )
        )
    end
end

function getCasecadeFadeInAction(duration)

    local action = cc.Sequence:create(
                        cc.CallFunc:create(function(node) casecadeFadeInNode(node, duration) end),
                        cc.DelayTime:create(duration)
                   )
    return action

end

function getCasecadeFadeOutAction(duration)

    local action = cc.Sequence:create(
                        cc.CallFunc:create(function(node) casecadeFadeOutNode(node, duration) end),
                        cc.DelayTime:create(duration)
                   )
    return action
end

function registerRemoveAfterArmaturePlayEnd(armature)

    if not armature then return end

    local function animationEvent(armatureBack, movementType, movementId)
        if movementType == ccs.MovementEventType.complete then
            armatureBack:runAction(cc.CallFunc:create(function() armatureBack:removeFromParent() end))
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
end

----------------------------------
-- 文件io操作, 一些类型的转换 author:焕松 
-----------------------------

-- 转换json数据为lua数据
function convertJsonToLua(path)

    local path = getFullPathForFilename(path)
    local content = cc.FileUtils:getInstance():getStringFromFile(path)
    local result = json.decode(content)
    return result
end

function encodeATableToJsonAndSaveToPath(aTable, path)

    assert(aTable)
    assert(path)

    local file = io.open(path, "w+")
    if not file then --什么情况会是not file?? 文件不存在会自动创建
        return
    end

    local jsonStr = json.encode(aTable)

    file:write(jsonStr)
    file:close()
end

function convertTableToString(aTable)

    local resultStr = "{"

    for k,v in pairs(aTable) do

        -- 拼接key--------------------------------

        -- number类型的key要加中括号
        if type(k) == "number" then
            resultStr = resultStr.."["..k.."] = "
        -- string类型的key直接加就行
        elseif type(k) == "string" then
            resultStr = resultStr.."['"..k.."'] = "
        -- 不支持其他类型的key
        else
            assert(false, "convertTableToString 不支持的key类型"..type(v))
        end

        -- 拼接value-------------------------------

        -- 表格类型, 递归
        if type(v) == "table" then
            resultStr = resultStr..convertTableToString(v)
        -- 数字
        elseif type(v) == "number" or type(v) == "boolean" then
            resultStr = resultStr..tostring(v)
        -- 字符串, 要在前后加'
        elseif type(v) == "string"  then
           resultStr = resultStr.."'"..v.."'"
        -- 其他格式, 不支持
        else
            assert(false, "convertTableToString 不支持的value类型"..type(v))
        end

        resultStr = resultStr..","
    end

    resultStr = resultStr.."}"

    return resultStr
end


function convertStringToTable(filePath)

    -- 拼接上return字头
    local content = filePath
    content = "return "..content

    -- 转
    local aTable = loadstring(content)()
    -- assert(aTable, "convertStringToTable, 转换失败")
    -- assert(type(aTable) == "table", "convertStringToTable 转换出来的不是table类型")
    return aTable
end

function replaceAllJsonToTableString(rootPath)

    -- 遍历查找出所有的json文件
    local jsonFilePaths = {}
    local allFileAndDirNames = dir(rootPath, DIR_ALL)

    for _,fileOrDirName in ipairs(allFileAndDirNames) do

        -- 属于文件
        if string.find(fileOrDirName, "%.") then

            -- 查找指定后缀名的文件
            local expandName = fileOrDirName:match(".+%.(%w+)$")
            if expandName == "json" then
                table.insert(jsonFilePaths, rootPath.."/"..fileOrDirName)
            end

        -- 属于文件夹, 递归遍历
        -- else
        --     self:findAllArmatureFiles(rootPath.."/"..fileOrDirName)
        end

    end

    -- 解析并替换成TableString文件
    for _,jsonFilePath in ipairs(jsonFilePaths) do

        -- 解析josn并转换为table string
        local table = convertJsonToLua(jsonFilePath)
        local tableStr = convertTableToString(table)

        -- 移除json文件
        -- os.remove(jsonFilePath)

        -- 将tableString写入同名.table文件
        local tableStrFileName = stripExtension(jsonFilePath)..".table"
        local file = io.open(tableStrFileName, "w+")
        file:write(tableStr)
        file:close()
    end
end

--获取文件名+扩展名
function stripFileName(filePath)
    return string.match(filePath, ".+/([^/]*%.%w+)$") -- *nix system  
    --return string.match(filename, ".+\\([^\\]*%.%w+)$") --*nix system  
end

-- 获取文件名
function stripFileNameExcepExtension(filePath)
    return filePath:match(".+/(.+)%.%a+$")
end

--去除扩展名  
function stripExtension(filePath)
    local idx = filePath:match(".+()%.%w+$")
    if(idx) then
        return filePath:sub(1, idx-1)
    else
        return filePath
    end
end

--获取扩展名  
function getExtension(filePath)
    return filePath:match(".+%.(%w+)$")
end

function getStringFromFilePath(filePath)
    local fullPath = getFullPathForFilename(filePath)
    local content = cc.FileUtils:getInstance():getStringFromFile(fullPath)
    return content
end

-- 
-- ?? -----------------------------------------------------
-- 

-- 取当前系统时间
function getSystemTime()
    -- TODO 需要定时同步服务器时间,暂时先使用客户端自身的时间值
    return os.time()
end

--判断表里面是否有元素
function isTableEmpty(t)

    for k,v in pairs(t) do
        return false
    end
    return true
end

--[[
table.deepcopy = function(t)

    local newT = {}
    for i,v in pairs(t) do
        if type(v) == "table" then
            local T = table.deepcopy(v)
            newT[i] = T
        else
            local x = v
            newT[i] = x
        end
    end
    return newT
end
]]

---------------------------------------------------
-- 线段，矩形相交处理
---------------------------------------------------

-- 获取平行线相交
local function getParallelIntersect(pt1, pt2, pt3, pt4)
    local A1 = (pt1.x == pt2.x) and pt1.x or pt1.y
    local B1 = (pt3.x == pt4.x) and pt3.x or pt3.y

    if A1 == B1 then
        local P1 = (pt1.x == pt2.x) and pt1.y or pt1.x
        local P2 = (pt1.x == pt2.x) and pt2.y or pt2.x
        local P3 = (pt3.x == pt4.x) and pt3.y or pt3.x
        local P4 = (pt3.x == pt4.x) and pt4.y or pt4.x

        if math.min(P1, P2) > math.max(P3, P4) or
            math.min(P3, P4) > math.max(P1, P2) then
            return false, nil
        end

        if P1 >= math.min(P3, P4) and P1 <= math.max(P3, P4) then
            return true, pt1
        end

        local point         = nil
        local distance      = nil
        local tempDistance  = nil

        tempDistance = math.abs(P1 - P2)
        if distance == nil or tempDistance < distance then
            distance    = tempDistance
            point       = pt2
        end

        tempDistance = math.abs(P1 - P3)
        if distance == nil or tempDistance < distance then
            distance    = tempDistance
            point       = pt3
        end

        tempDistance = math.abs(P1 - P4)
        if distance == nil or tempDistance < distance then
            distance    = tempDistance
            point       = pt4
        end

        return true, point
    end

    return false, nil
end

-- 获取垂直线相交
local function getVerticalIntersect(pt1, pt2, pt3, pt4)
    -- 线段一纵向，线段二横向
    if pt1.x == pt2.x then

        local X, Y = pt1.x, pt3.y
        if Y >= math.min(pt1.y, pt2.y) and Y <= math.max(pt1.y, pt2.y) and
            X >= math.min(pt3.x, pt4.x) and X <= math.max(pt3.x, pt4.x) then

            return true, cc.p(X, Y)
        end

    -- 线段一横向，线段二纵向
    else

        local X, Y = pt3.x, pt1.y
        if Y >= math.min(pt3.y, pt4.y) and Y <= math.max(pt3.y, pt4.y) and
            X >= math.min(pt1.x, pt2.x) and X <= math.max(pt1.x, pt2.x) then

            return true, cc.p(X, Y)
        end

    end

    return false, nil
end

-- 获取非垂直相交
local function getNormalIntersect(pt1, pt2, pt3, pt4)
    -- 线段二是否为纵线
    if pt3.x == pt4.x then
        local X = pt3.x
        local Y = (X - pt1.x) / (pt2.x - pt1.x) * (pt2.y - pt1.y) + pt1.y

        if Y >= math.min(pt3.y, pt4.y) and Y <= math.max(pt3.y, pt4.y) then
            return true, cc.p(X, Y)
        end

    -- 线段二是否为横线
    else
        local Y = pt3.y
        local X = (Y - pt1.y) / (pt2.y - pt1.y) * (pt2.x - pt1.x) + pt1.x

        if X >= math.min(pt3.x, pt4.x) and X <= math.max(pt3.x, pt4.x) then
            return true, cc.p(X, Y)
        end
    end

    return false, nil
end

-- 线段与线段相交
-- 线段一(pt1, pt2)
-- 线段二(pt3, pt4, 只能是纵线或者横线)
function isVHSegmentIntersect(pt1, pt2, pt3, pt4)
    -- 长度为0
    if pt1.x == pt2.x and pt1.y == pt2.y then return false, nil end
    if pt3.x == pt4.x and pt3.y == pt4.y then return false, nil end

    assert(pt3.x == pt4.x or pt3.y == pt4.y, "线段二不是纵线和横线")

    -- 线段二是否为纵线
    local isSegmentV = (pt3.x == pt4.x)

    -- 线段一为横线
    if pt1.y == pt2.y then
        if isSegmentV then
            return getVerticalIntersect(pt1, pt2, pt3, pt4)
        else
            return getParallelIntersect(pt1, pt2, pt3, pt4)
        end

    -- 线段一为纵线
    elseif pt1.x == pt2.x then
        if isSegmentV then
            return getParallelIntersect(pt1, pt2, pt3, pt4)
        else
            return getVerticalIntersect(pt1, pt2, pt3, pt4)
        end

    -- 线段一为斜线
    else
        return getNormalIntersect(pt1, pt2, pt3, pt4)
    end
end

-- 快速判断线段矩形不相交
function isSegmentRectNotIntersectSoon(pt1, pt2, rect)
    if (pt1.x < rect.x and pt2.x < rect.x) or
        (pt1.x > rect.x + rect.width and pt2.x > rect.x + rect.width) then
        return true
    end

    if (pt1.y < rect.y and pt2.y < rect.y) or
        (pt1.y > rect.y + rect.height and pt2.y > rect.y + rect.height) then
        return true
    end

    return false
end

-- 快速判断两线段不相交
function isSegmentsNotIntersectSoon(pt1, pt2, pt3, pt4)
    return (math.min(pt1.x, pt2.x) > math.max(pt3.x, pt4.x) or
            math.min(pt1.y, pt2.y) > math.max(pt3.y, pt4.y) or
            math.max(pt1.x, pt2.x) < math.min(pt3.x, pt4.x) or
            math.max(pt1.y, pt2.y) < math.min(pt3.y, pt4.y))
end

-- 线段矩形相交
-- pt1为线段开始点，pt2为线段结束点
-- isLatelyPoint为true，返回最近相交点
function isSegmentRectIntersect(pt1, pt2, rect, isLatelyPoint)
    local isFinalIntersect  = nil
    local finalPoint        = nil
    local isIntersect       = nil
    local point             = nil

    local isExistResult     = false

    local function intersectAbout(p1, p2)
        -- 快速判断不相交
        if not isSegmentsNotIntersectSoon(pt1, pt2, p1, p2) then
            isIntersect, point = isVHSegmentIntersect(pt1, pt2, p1, p2)

            isFinalIntersect   = isFinalIntersect or isIntersect
            finalPoint         = finalPoint or point

            if isIntersect then
                -- 最近点
                if isLatelyPoint then
                    if cc.pGetDistance(point, pt1) < cc.pGetDistance(finalPoint, pt1) then
                        finalPoint = point
                    end

                -- 最远点
                elseif isLatelyPoint == false then
                    if cc.pGetDistance(point, pt1) > cc.pGetDistance(finalPoint, pt1) then
                        finalPoint = point
                    end

                -- 任意点
                else
                    isExistResult = true
                end
            end
        end
    end

    local P1, P2 = nil, nil
    local x, y, width, height = rect.x, rect.y, rect.width, rect.height

    P1, P2 = cc.p(x, y), cc.p(x, y + height)
    intersectAbout(P1, P2)

    if isExistResult then return isFinalIntersect, finalPoint end

    P1, P2 = cc.p(x, y), cc.p(x + width, y)
    intersectAbout(P1, P2)

    if isExistResult then return isFinalIntersect, finalPoint end

    P1, P2 = cc.p(x, y + height), cc.p(x + width, y + height)
    intersectAbout(P1, P2)

    if isExistResult then return isFinalIntersect, finalPoint end

    P1, P2 = cc.p(x + width, y), cc.p(x + width, y + height)
    intersectAbout(P1, P2)

    return isFinalIntersect, finalPoint
end

-- 是否点在rect上（这里指得是rect上的四条边）
function isRectSegmentsContainPoint(rect, pt)
    if (pt.x == rect.x or pt.x == rect.x + rect.width) and
        (pt.y >= rect.y and pt.y <= rect.y + rect.height) then
        return true
    end
    if (pt.y == rect.y or pt.y == rect.y + rect.height) and
        (pt.x >= rect.x and pt.x <= rect.x + rect.width) then
        return true
    end
    return false
end

-- 是否点在rect内
-- isContainSegment为true，即包括边界，默认为true
function isRectContainPoint(rect, pt, isContainSegment)
    if isContainSegment == nil then isContainSegment = true end

    if isContainSegment then
        return (pt.x >= rect.x and
                pt.x <= rect.x + rect.width and
                pt.y >= rect.y and
                pt.y <= rect.y + rect.height)
    else
        return (pt.x > rect.x and
                pt.x < rect.x + rect.width and
                pt.y > rect.y and
                pt.y < rect.y + rect.height)
    end
end

-- 秒数 -> 天,时,分,秒
function formatTime(sec)

    local secondsPerMinute = 60
    local minutesPerHour   = 60
    local hoursPerDay      = 24
    local secondsPerHour   = secondsPerMinute * minutesPerHour
    local secondsPerDay    = secondsPerHour   * hoursPerDay

    local days    = math.floor(sec / secondsPerDay)
    local hours   = math.floor((sec - days*secondsPerDay) / secondsPerHour)
    local minutes = math.floor((sec - days*secondsPerDay - hours*secondsPerHour) / secondsPerMinute)
    local seconds = math.floor(sec - days*secondsPerDay - hours*secondsPerHour - minutes*secondsPerMinute)

    --local time = string.format("%02d:%02d:%02d", days, hours, minutes)
    --local time = days .. "天" .. hours .. "时" .. minutes .. "分"

    return days, hours, minutes, seconds
end

-- table转string，如果为nil，返回nil
function getStringWithTable(t)
    return t ~= nil and table.tostring(t) or "nil"
end


function removeSelfByAction( node )
    if node then 
        local action = cc.CallFunc:create(function() 
                node:removeFromParent() 
                node = nil 
                end)
        node:runAction(action)
    end 
end

-- 得到替换的*字符串
local function getBeReplacedStr(str)

    print("str = ",str)

    local beReplacedStr = ""
    for i=1, string.len(str) do
        beReplacedStr = beReplacedStr.."*"
    end
    
    return beReplacedStr
end

-- 屏蔽字库
function getScreeningMsg(msg)
    
    local isExistScreenChar = false
    for _, typeTB in ipairs(TB_screening) do
        
        for i, screeningStr in ipairs(typeTB.screening) do
            
            local isExist = string.find(msg, screeningStr) 
            if isExist ~= nil then
                isExistScreenChar = true
                local beReplacedStr = getBeReplacedStr(screeningStr)
                msg = string.gsub(msg, screeningStr, beReplacedStr) 
            end
        end
    end

    return isExistScreenChar, msg
end

-- 打印错误码
function printErrorCode(id)

    local str = msgno.get_content(id)

    print("printErrorCode: " .. id .. ", " .. tostring(str))

    if str then
        local tab = { {str, cc.c3b(255,255,255)} }
        TipsMgr:showRoleTips(tab, 2.2)
    end
end

function log( ... )
    local temp = {...}
    local str = "print:"
    for k, v in pairs(temp) do
        str = str .. " " .. tostring(v)
    end
    print(str)
end

--Create an class.
function ImproveClass(classname, super)
    local superType = type(super)
    -- print("---------superType:"..superType.."---------classname:"..classname)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            -- instance:ctor(...)
            cls.ctor(instance, ...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            -- instance:ctor(...)
            cls.ctor(instance, ...)
            return instance
        end
    end

    return cls
end

function rotatePoint(vec, pnt, angle)
    local _p =  cc.p(0,0);
    local _cosa = math.cos(angle);
    local _sina = math.sin(angle);

    local _dx = vec.x - pnt.x;
    local _dy = vec.y - pnt.y;

    _p.x = _cosa * _dx - _sina * _dy + pnt.x;
    _p.y = _sina * _dx + _cosa * _dy + pnt.y;

    return _p;
end

function modle(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end

-- vec1 在vec2上面的投影
function vecShadown(vec1, vec2)
    local cosa = cc.pDot(vec1, vec2);
    return cosa / modle(vec1);
end
