--游戏中用到的常量

EventConstants = {
	AppEnterForegroundEvent = "AppEnterForegroundEvent",
	AppEnterBackgroundEvent  = "AppEnterBackgroundEvent",
}

TEAM = {
    attacker = 0,
    defender = 1,
    enemy = function(t)
        return t == TEAM.attacker and TEAM.defender or TEAM.attacker
    end
}

UNIT_TYPE = {
    movable = 1,            --可移动的单位
    building = 2,           --建筑
}
