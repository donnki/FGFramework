-- 吸血buff
local buff = {}

buff.id = "buff001"

buff.triggerEvent = BattleEvents.onHitTarget

-- 执行的操作
buff.action = function()
	print("TODO: buff拥有者的HP恢复‘buff等级*伤害数值’点")
end
return buff