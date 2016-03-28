local BattleBuffAgent = class("BattleBuffAgent")

function BattleBuffAgent:ctor(relateUnit)
	self.relateUnit = relateUnit
	self.registerTable = {}
	self.coroutines = {}
end

function BattleBuffAgent:addBuff(buffID)
	local buff = require("game.buffs."..buffID)
	buff.agent = self

	if self.registerTable[buff.triggerEvent] == nil then
		self.registerTable[buff.triggerEvent] = {}
	end

	table.insert(self.registerTable[buff.triggerEvent], buff)
	if buff.onRecieve then
		buff.onRecieve(self.relateUnit)
	end
	if buff.triggerEvent == BattleEvents.none then
		self:onEvent(BattleEvents.none, self.relateUnit)
	end

end

function BattleBuffAgent:onEvent(eventID, ...)
	local registeredBuffs = self.registerTable[eventID]
	if registeredBuffs and #registeredBuffs > 0 then
		for i,v in ipairs(registeredBuffs) do
			local co = coroutine.create(v.action)
			table.insert(self.coroutines, {co, {timer=0,buff=v,target=self.relateUnit}})
		end
	end
end

function BattleBuffAgent:update(dt)
	for i,co in ipairs(self.coroutines) do

		local status, ret = coroutine.resume(co[1], co[2])
		if status and ret then
			table.remove(self.coroutines, i)
			co[2].buff.onLeave(self.relateUnit)
			local r = self.registerTable[co[2].buff.triggerEvent]
			table.removebyvalue(r, co[2].buff)
		end
	end
end

return BattleBuffAgent