--[[
    AOI组件
]]
import(".iso")
local laoi = require("laoi")
local Component = cc.Component
local AoiComponent = class("AoiComponent", Component)

local MAP_DIVIDE = 6 			--分割次数

function AoiComponent:ctor()
    AoiComponent.super.ctor(self, "AoiComponent")
end

function AoiComponent:exportMethods()
    self:exportMethods_({
    	"aoiAdd",
    	"aoiDelete",
    	"aoiUpdate",
    	"aoiUnitSearch",
    	"aoiSearchByRadius",
    	"aoiGetById",
    	"aoiClear",
    	"getGameUnits",
    	"findNearestInRange",
    	"findNearestInAll",
    })
    return self.target_
end

function AoiComponent:init()
	self.units = {}
    self.aoimap = laoi.new_map({1280,1280}, MAP_DIVIDE, {0, 0})
    return self
end

function AoiComponent:aoiUpdate(id, x, y)
	self.aoimap:unit_update(self.units[id], {x, y})
end

function AoiComponent:aoiUnitSearch(id, radius, team, type_)
	team = team and team or -1
	type_ = type_ and type_ or -1
	return self.aoimap:unit_search(self.units[id], radius, team, type_)
end

function AoiComponent:aoiSearchByRadius(x, y, radius, team, type_)
	team = team and team or -1
	type_ = type_ and type_ or -1
	return self.aoimap:search_circle(radius, {x, y, team, type_})
end

function AoiComponent:aoiAdd(id, x, y, size, team, type_)
	local unit = laoi.new_unit_with_userdata(id, {x, y, size, team, type_})
	self.aoimap:unit_add(unit)
	self.units[id] = unit
	return unit
end

function AoiComponent:aoiDelete(id)
	self.aoimap:unit_del_by_id(id)
	self.units[id] = nil
end

function AoiComponent:aoiGetById(id)
	for k, unit in pairs(map:get_units()) do
		if k == id then
			return unit
		end
	end
end

function AoiComponent:aoiClear()
	laoi.imeta_cache_clear()
	self.units = nil
	self.aoimap = nil

	collectgarbage("collect")
	collectgarbage("collect")
end

function AoiComponent:getGameUnits(units)
	local gameUnits = {}
	for k,v in pairs(units) do
		table.insert(gameUnits, self.gameObject:getById(v:get_id()))
	end
	return gameUnits
end

local function getMinimumUnit(pos, units, checkFunc)
	local minDistance = 10000
	local unit = nil
	for k,v in pairs(units) do
		if checkFunc(v) then
			local distance = cc.pGetDistance(pos, cc.p(v:get_pos()))
			if minDistance > distance then
				minDistance = distance
				unit = v
			end
		end
	end
	return unit
end

function AoiComponent:findNearestInRange(id, range, team, checkFunc, type_)
	local units = self:aoiUnitSearch(id, range, team, type_)
	local unit = getMinimumUnit(cc.p(self.units[id]:get_pos()), units, checkFunc)
	if unit then
		return self.gameObject:getById(unit:get_id())
	end
end

function AoiComponent:findNearestInAll(id, team, type_, checkFunc)
	team = team and team or -1
	type_ = type_ and type_ or -1
	-- print(id, self.units[id])
	local target = getMinimumUnit(
		cc.p(self.units[id]:get_pos()), self.units, 
		function(unit)
			local uTeam, uType = unit:get_team_type()
			-- print(uTeam, uType, team, type_, unit:get_id(), id )
			if unit:get_id() ~= id 
				and (team == -1 or team == uTeam) 
				and (type_ == -1 or type_ == uType)
				and checkFunc(unit) then
				return true
			else
				return false
			end
		end)
	return target
end

return AoiComponent
