-- 喷火男技能
local skill = {}

-- 技能ID
skill.id = "skill001"

-- 事件
skill.triggerEvent = BattleEvents.onPlayerUseSkill

-- 触发的条件
skill.condition = function(skillID)
    return skillID == skill.id
end

-- 技能施法总时间
skill.totalTime = 1

-- 技能
skill.action = function(p)
    -- 播放技能音效
    ss.PlayAudio(p, "res/JasonSkill.mp3")

    -- 当前施放者播放动画
    ss.PlayAnimation(p, "use_skill_animation")

    -- 定义：局部变量p = 施放者朝向的正前方200的坐标点
    local pos = ss.GetFrontPos(p, 200)

    -- 延时0.2秒
    ss.WaitForSeconds(p, 0.5)

    -- 在p点位置播放“烈焰”的动画特效
    local effect = ss.PlayEffect(p, "firework", pos)
    
    -- 定义局部变量：units=以P为圆心，半径为200内的所有的“敌方”“全部”单位：
    local units = ss.GetCircleArea(p, pos, 50, ss.Team.enemy, ss.Type.all)
    
    -- 对每一个单位瞬间造成100点伤害
    for i,v in ipairs(units) do
        v:hurt(100)
    end

    for i=1,4 do
        -- 延时0.3秒
        ss.WaitForSeconds(p, 0.3) --while not ss.WaitForSeconds(p, 0.3) do coroutine.yield() end

        -- 重新获取同样区域内的敌方全部单位
        local units = ss.GetCircleArea(p, pos, 50, ss.Team.enemy, ss.Type.all)
        
        -- 瞬间造成100点伤害
        for i,v in ipairs(units) do
            v:hurt(50)
        end
         
    end
    -- 延时0.5秒
    ss.WaitForSeconds(p, 0.5)
    
    -- 移除“烈焰”特效"
    effect:removeFromParent()

    return true
end

-- 技能施放完毕后从注册列表中移除
-- skill.clearOnFinished = true

return skill