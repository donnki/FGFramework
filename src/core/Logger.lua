---------------------
--日志统一输出
--日志级别：
--DEBUG调试日志
--INFO信息日志
--WARN警告日志
--ERROR错误日志
--TODO待完成功能标记

--output目前使用console输出，后续改成错误日志输出至文件系统，并可以将日志传输至网络供查错
---------------------
require "core.ui.base.UILoggerWindow"

local Log = class("Log",{})
Log.__index = Log
local output = LoggerWindow.print

-- local output = print
--Log.printer = nil
--
--function Log.init()
--    if Log.printer == nil then
--    end
--end
--
--function Log.print(...)
--end



function Log.d(...)
    local str =  Log.format(...)
    if GameConfig.logLevel <= LogLevel.debug then
    	output("[DEBUG]: "..str)
    end
end

function Log.i(...)
    local str =  Log.format(...)
    if GameConfig.logLevel <= LogLevel.info then
        output("[INFO]: \t"..str)
    end
end

function Log.w(...)
    local str =  Log.format(...)
    if GameConfig.logLevel <= LogLevel.warn then
        output("[WARN]: \t"..str)
    end
end

function Log.e(...)
    local str =  Log.format(...)
    if GameConfig.logLevel <= LogLevel.error then
        output("[ERROR]: ".. str)
        output("[ERROR]: ".. debug.traceback())
    end
end

function Log.t(...)
    --output(serializeTable(_table))
    local str = ""
    local temp = {...}
    for _,v in pairs(temp) do
        if type(v) == "table" or type(v) == "userdata" then
            str = str .. Log.decomposeTable(v)
        else
            str = str .. tostring(v)
        end
        str = str .. " "
    end
   -- local str = Log.decomposeTable(_table)
    Log.i(str)
end

function Log.dump(table)
    Log.i(dump(table))
end

function Log.decomposeTable(_table)
  
    if not _table then 
        return "nil"
    end
    local str = "{ "
    if type(_table) == "userdata" then
        str = str .. tostring(_table) .. "}"
        return str
    end

    for k,v in pairs(_table) do
        str = str .. tostring(k) .. " = "
        if k == "class" then
            str = str .. tostring(v)
        else
        if type(v) == "table" then
            str = str .. Log.decomposeTable(v)  
        else
            str = str .. tostring(v) .. " "

        end
    end
        str = str .. ", "

    end
    str = str .. "}"
   -- num = 1
    tableList = {}
    return str
end

function Log.todo(...)
    local str =  Log.format(...)
    output("[TODO]: \t"..str)
end

function Log.format(...)

 local args = {...}
    local str = ""
    for k, v in pairs(args) do
        str = str .. " " .. tostring(v)
    end
   return str
end

return Log