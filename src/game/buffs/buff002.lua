-- 每发出三次攻击后，第四次攻击必定产生暴击
local buff = {}

buff.id = "buff002"

buff.triggerEvent = BattleEvents.onShotTarget

-- 被附加上buff时执行的操作
buff.onRecieve = function(target)
	target.shotTimes = 0
	print("TODO: 加上BUFF")
end

-- buff失效时执行的操作
buff.onLeave = function(target)
	print("TODO: 移除BUFF")
end

-- 每次tick时执行的操作
buff.action = function(params)
	-- 增加单位的攻击数次累加器
	params.target.shotTimes = params.target.shotTimes + 1

	-- 如果攻击次数能被4整除
	if params.target.shotTimes % 4 == 0 then
		print("TODO: 临时调整目标本次攻击的攻击力，并将射出的子弹形状改成另外形态")
	end
end

return buff