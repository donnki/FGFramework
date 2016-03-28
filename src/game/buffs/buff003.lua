-- 中毒buff
local buff = {}

buff.id = "buff003"

buff.triggerEvent = BattleEvents.none

-- 被附加上buff时执行的操作
buff.onRecieve = function(target)
	print("TODO: 设置玩家进入中毒状态")
end

-- buff失效时执行的操作
buff.onLeave = function(target)
	print("TODO: 设置玩家离开中毒状态")
end

-- 执行的操作
buff.action = function(sender)
	for i=1,10 do
		--延时0.5秒
		while not WaitForSeconds(sender, 0.5) do coroutine.yield() end
		print("TODO: 对buff绑定对象造成buff等级*20点伤害")
	end
	return true
end

return buff