-- 引导暴风雪技能
local skill = {}

skill.id = "skill003"
-- 事件
skill.triggerEvent = BattleEvents.onPlayerUseSkill

-- 触发的条件
skill.condition = function(skillID)
    return skillID == skill.id
end

-- 技能
skill.action = function(sender)
    print("TODO: 释放技能003，释放者进入技能引导状态")
    print("TODO: 播放技能音效")
    print("TODO: 定义：局部变量p = 施放者朝向的正前方100的坐标点")
    for i=1,4 do
        print("TODO: 选取以P为圆心，半径为100内的所有的敌方单位，执行循环：")
        print("TODO: 在P点位置播放一次暴风雪特效")
        while not WaitForSeconds(sender, 0.5) do coroutine.yield() end
        print("TODO: 对每一个单位造成50点伤害")
        while not WaitForSeconds(sender, 1.5) do coroutine.yield() end
         
    end
    while not WaitForSeconds(sender, 1) do coroutine.yield() end
    print("TODO: 释放者退出技能引导状态")
    return true
end

-- 技能施放完毕后从注册列表中移除
-- skill.clearOnFinished = true

return skill