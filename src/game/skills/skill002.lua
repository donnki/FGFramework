-- 被动技能
local skill = {}

skill.id = "skill002"

-- 触发技能的事件： 当英雄进入战场
skill.triggerEvent = BattleEvents.onHeroEnterBattle

-- 触发的条件
skill.condition = function(skillID)
	return skillID == skill.id
end

-- 技能
skill.actions = function(sender)
	print("TODO: 为施放单位加上一个攻击力提升BUFF")
    return true
end

-- 技能施放完毕后从注册列表中移除
-- skill.clearOnFinished = true

return skill