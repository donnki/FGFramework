-- 被动技能
local skill002 = {}

-- 触发技能的事件： 当英雄进入战场
skill002.triggerEvent = BattleEvents.onHeroEnterBattle

-- 触发的条件
skill002.condition = function(skillID)
	return skillID == "skill002"
end

-- 技能
skill002.actions = function(sender)
	print("TODO: 为施放单位加上一个攻击力提升BUFF")
    return true
end

-- 技能施放完毕后从注册列表中移除
skill002.clearOnFinished = true

return skill002