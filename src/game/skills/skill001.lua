-- 喷火男技能
local skill001 = {}

-- 事件
skill001.triggerEvent = BattleEvents.onPlayerUseSkill

-- 触发的条件
skill001.condition = function(skillID)
    return skillID == "skill001"
end

-- 技能
skill001.actions = function(sender)
    print("TODO: 播放技能音效")
    print("TODO: 定义：局部变量p = 施放者朝向的正前方200的坐标点")
    print("TODO: 在p点位置播放“烈焰”的动画特效")
    print("TODO: 选取以P为圆心，半径为200内的所有的“敌方”单位，执行循环：")
    print("TODO: 对每一个单位瞬间造成100点伤害")
    for i=1,4 do
        while not WaitForSeconds(sender, 0.1) do coroutine.yield() end
        print("TODO: 选取以P为圆心，半径为200内的所有的敌方单位，执行循环：")
        print("TODO: 对每一个单位造成50点伤害")
         
    end
    while not WaitForSeconds(sender, 0.5) do coroutine.yield() end
    print("TODO: 移除“烈焰”特效")
    return true
end

-- 技能施放完毕后从注册列表中移除
skill001.clearOnFinished = true

return skill001