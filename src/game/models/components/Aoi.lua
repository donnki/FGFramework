--[[
    AOI组件
]]
local laoi = require("laoi")
local Component = cc.Component
local Aoi = class("Aoi", Component)

local MAP_DIVIDE = 6 			--分割次数

function Aoi:ctor()
    Aoi.super.ctor(self, "Aoi")
    self.idGen = 0 
    self.units = {}
end

function Aoi:exportMethods()
    self:exportMethods_({
    	"aoiAdd",
    	"aoiDelete",
    	"aoiUpdate",
    	"aoiUnitSearch",
    	"aoiSearchByRadius",
    	"aoiGetById",
    	"aoiClear",
    })
    return self.target_
end

function Aoi:onBind_(gameObject)
	self.gameObject = gameObject
	self.aoimap = laoi.new_map({1280,1280}, MAP_DIVIDE, {0, 0})
end

function Aoi:aoiUpdate(tag, x, y)
	self.aoimap:unit_update(self.units[tag], {x, y})
end

function Aoi:aoiUnitSearch(tag, radius)
	return self.aoimap:unit_search(self.units[tag], radius)
end

function Aoi:aoiSearchByRadius(x, y, radius)
	return self.aoimap:search_circle(radius, {x, y})
end

function Aoi:aoiAdd(x, y, size)
	self.idGen = self.idGen + 1
	local unit = laoi.new_unit_with_radius(self.idGen, {x, y, size})
	self.aoimap:unit_add(unit)
	self.units[self.idGen] = unit
	return self.idGen
end

function Aoi:aoiDelete(id)
	self.aoimap:unit_del_by_id(id)
end

function Aoi:aoiGetById(id)
	for k, unit in pairs(map:get_units()) do
		if k == id then
			return unit
		end
	end
end

function Aoi:aoiClear()
	laoi.imeta_cache_clear()
	self.units = nil
	self.aoimap = nil

	collectgarbage("collect")
	collectgarbage("collect")
end
return Aoi
