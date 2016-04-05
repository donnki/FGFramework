
local Registry = import(".Registry")

local GameObject = {}

function GameObject.extend(target)
    target.components_ = {}

    function target:checkComponent(name)
        return self.components_[name] ~= nil
    end

    function target:addComponent(name)
        local component = Registry.newObject(name)
        self.components_[name] = component
        component:bind_(self)
        return component
    end

    function target:removeComponent(name)
        local component = self.components_[name]
        if component then component:unbind_() end
        self.components_[name] = nil
    end

    function target:getComponent(name)
        for k,v in pairs(self.components_) do
            if k:ends(name) or v.super.__cname == name then
                return v
            end
        end
        -- return self.components_[name]
    end

    function target:getComponents(name)
        local tb = {}
        for k,v in pairs(self.components_) do
            if k:ends(name) or v.super.__cname == name then
                table.insert(tb, v)
            end
        end
        return tb
    end

    function target:dumpComponents()
        for k,v in pairs(self.components_) do
            print(k, v.super.__cname)
        end
    end

    return target
end

return GameObject
