local BuildingModel = require("game.models.BuildingModel")
local TowerModel = class("TowerModel", BuildingModel)
------------
-- 战斗初始化接口
function TowerModel:initForBattle(battleModel)
	BuildingModel.initForBattle(self, battleModel)

	-- 防御塔有攻击组件
	cc(self):addComponent("game.models.components.AttackComponent"):init(battleModel):exportMethods()
	self:initBehaviorTree()
end

---------------
-- 初始化行为树
function TowerModel:initBehaviorTree()
	self.btRoot = bt.loadFromJson("src/game/test/ai_tower.json", self)
	self.btRoot:activate(self)
end


function TowerModel:update(dt)
	BuildingModel.update(self,dt)
	-- self.btRoot:debugClearDrawNode()
	if self.btRoot and self.btRoot:evaluate() then
        self.btRoot:tick(dt)
    end
end

function TowerModel:hurt()
	print("~~~~~tower hurt")
end

return TowerModel