local BattleSkillAgent = class("BattleSkillAgent")

local instance = nil

function BattleSkillAgent:sharedInstance()
	if instance == nil then
		instance = BattleSkillAgent.new()
	end
	return instance
end

function BattleSkillAgent:init(battle)
	self.battle = battle
	self.registerTable = {}
	self.coroutines = {}
end

function BattleSkillAgent:clear()
	self.battle = nil
	self.registerTable = nil
	self.coroutines = nil
end

function BattleSkillAgent:registerSkill(skillID, relateObject)
	local skill = require("game.skills."..skillID)
	skill.agent = self
	
	if self.registerTable[skill.triggerEvent] == nil then
		self.registerTable[skill.triggerEvent] = {}
	end
	table.insert(self.registerTable[skill.triggerEvent], {skill, relateObject})
	
end

function BattleSkillAgent:onEvent(eventID, ...)
	if eventID == 0 then 		--打断正在执行的技能
		local p = {...}
		local relateObject = p[1] 	--第二个参数为技能关联的对象
		local skillID = p[2]		--第三个参数为要打断的技能

		for i,v in ipairs(self.coroutines) do
			if v[2].sender == relateObject and v[2].skill.id == skillID then
				table.remove(self.coroutines, i)
			end
		end
	else
		local registeredSkills = self.registerTable[eventID]
		if registeredSkills and #registeredSkills > 0 then
			for i,v in ipairs(registeredSkills) do
				if v[1].condition(...) then
					local co = coroutine.create(v[1].actions)
					table.insert(self.coroutines, {co, {timer=0, skill=v[1], sender=v[2]}})
				end
			end
		end
	end
	
end


function BattleSkillAgent:update(dt)
	for i,co in ipairs(self.coroutines) do
		local status, ret = coroutine.resume(co[1], co[2])
		if ret then
			table.remove(self.coroutines, i)
			if co[2].skill.clearOnFinished then 		--从技能注册列表中移除对象
				local r = self.registerTable[co[2].skill.triggerEvent]
				for i2,v in ipairs(r) do
					if v[2] == co[2].sender then
						table.remove(r, i2)
					end
				end
			end
		end
	end
end


function WaitForSeconds(sender, delayTime)
    sender.timer = sender.timer + Time.delta
    if sender.timer > delayTime then
        sender.timer = 0
        return true
    else
        return false
    end
end

return BattleSkillAgent