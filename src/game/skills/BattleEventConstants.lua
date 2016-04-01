
BattleEvents = {
	onInterruptHeroSkill = 0,			--打断技能事件
	onPlayerUseSkill = 1,				--玩家使用技能事件
	onHeroEnterBattle = 2,				--英雄进入战场事件
	onShotTarget = 3, 					--远程攻击射出箭矢
	onHitTarget = 4, 					--攻击打到目标身上
	none = 100,
}


ss = {
	Team = {
		friend = 0,			--友军
		enemy = 1, 			--敌军
		both = -1 			--全部
	},
	Type = {
		movable = 1, 		--可移动单位
		building = 2,  		--建筑
		all = -1 			--全部
	},
}

function ss.WaitForSeconds(p, delayTime)
    p.timer = p.timer + Time.delta
    if p.timer > delayTime then
        p.timer = 0
        return true
    else
        return false
    end
end

function ss.PlayAudio(p, audiopath)
	print("TODO: 播放音效：", audiopath)
end

function ss.PlayAnimation(p, animName)
	print("TODO: 播放角色动画：", animName)
end

function ss.PlayEffect(p, animName, pos)
	print(string.format("TODO: 在(%d,%d)播放特效动画：", pos.x, pos.y), animName)
	local PointNode = require("game.scenes.battle.view.PointNode")
	local point = PointNode.new()
	point:setPosition(pos)
	p.sender:getRenderer():getParent():addChild(point)
	return point

end

function ss.GetFrontPos(p, distance)
	local pos = p.sender:getPosition()
	local rotation = p.sender:getRotation()
	local newPosX = pos.x + math.cos(math.rad(rotation))*distance
	local newPosY = pos.y - math.sin(math.rad(rotation))*distance

	
	return cc.p(newPosX, newPosY)
end

function ss.GetCircleArea(p, center, radius, team, type_)
	-- xpcall(function()
		if team ~= ss.Team.both then
			if team == ss.Team.friend then
				team = p.sender.team
			else
				team = TEAM.enemy(p.sender.team)
			end
		end
		
		local t = p.sender.battle:aoiSearchByRadius(center.x, center.y, radius, team, type_)

		local units = p.sender.battle:getGameUnits(t)
		return units
	-- end, function(err)
	-- 	print(err)
	-- 	return nil
	-- end)
	
end