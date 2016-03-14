-------------------
--统一管理数据库
-------------------
local sqlite3 = require("lsqlite3")
local DBManager = class("DBManager")

DBManager.__index = DBManager
DBManager.cache = nil
function DBManager:ctor(dbFile)
    local dbFilePath
    -- print(cc.FileUtils:getInstance():getWritablePath()..dbFile:split("/")[2])
    if native.platform.isAndroid then
        dbFilePath = cc.FileUtils:getInstance():getWritablePath()..dbFile:split("/")[2]
        Log.i("~~~~~", dbFilePath)
        if not cc.FileUtils:getInstance():isFileExist(dbFilePath) then
            local asset = cc.FileUtils:getInstance():fullPathForFilename(dbFile)
            local data = io.readfile(asset)
            io.writefile(dbFilePath, data, "wb")
            Log.i("生成数据文件完成", cc.FileUtils:getInstance():isFileExist(dbFilePath))
        end
        Log.i(dbFilePath, ": ", cc.FileUtils:getInstance():isFileExist(dbFilePath))
    else
        dbFilePath = cc.FileUtils:getInstance():fullPathForFilename(dbFile)
    end
    
    if cc.FileUtils:getInstance():isFileExist(dbFilePath) then
        self.db = sqlite3.open(dbFilePath)
        self.cache = {}
        if not self.db then
            Log.e("打开数据库失败", dbFilePath)
            return
        else
            Log.i("打开数据库成功, path=", dbFilePath)
        end
    else
        Log.e("数据库文件不存在", dbFile, dbFilePath)
    end
    
end


-- 关闭数据库并删除数据库日志
function DBManager:closeDB()
    self.cache = nil
    if self.db then
        self.db:exec('VACUUM') --清除数据库日志
        self.db:close()
        self.db = nil
        Log.i("关闭数据库成功")
    end
end

-- 清空数据库缓存
function DBManager:clearCache()
    self.cache = {}
    collectgarbage("collect")
end

-- 查询队列
-- 返回 table 数组
-- sql:SQL语句
function DBManager:query(sql)
    Log.d("执行SQL查询：", sql)
    if not self.db then
        return
    end
    local vm = self.db:prepare(sql)
    if not vm then
        return nil,nil,self.db:errmsg()
    end
    local names = vm:get_names()
    local r = vm:step()
    local values = {}
    local index = 0
    while r == sqlite3.ROW do
        index = index + 1
        local temp_value = vm:get_values()
        values[index] = {}
        for i,v in ipairs(temp_value) do
            values[index][names[i]] = v
        end
        r = vm:step()
    end
    vm:finalize()
    return values,index
end

-- 根据ID从数据库指定表中查询
function DBManager:findByID(tableName, id)
    if self.cache[tableName] and self.cache[tableName][id] then
        return self.cache[tableName][id]
    else
        local results, count = self:query("select * from "..tableName.." where id='"..id.."'")
        if count == 0 then 
            Log.w("ID:"..id.."在数据库表"..tableName.."中不存在！")
        elseif count > 1 then
            Log.w("ID:"..id.."在数据库表"..tableName.."不唯一！")
        end
        if self.cache[tableName] == nil then
            self.cache[tableName] = {}
        end
        self.cache[tableName][id] = results[1]
        return results[1]
    end
end

-- 加载整张表至缓存中并返回表数据
function DBManager:loadTable(tableName)
    -- if self.cache[tableName] then
    --     return self.cache[tableName]
    -- end
    local results, count = self:query("select * from "..tableName)
    self.cache[tableName] = {}
    for i,v in ipairs(results) do
        self.cache[tableName][v.id] = v
    end
    return self.cache[tableName]
end

return DBManager