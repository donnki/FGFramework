-------------------
--统一管理倒计时任务
-------------------
local PlanScheduler = class("PlanScheduler")

PlanScheduler.__index = PlanScheduler
PlanScheduler.plans = nil
local scheduler = cc.Director:getInstance():getScheduler()
function PlanScheduler:getInstance()
    if instance == nil then
        instance = PlanScheduler.new()
    end
    return instance
end

function PlanScheduler:ctor()
	self.plans = {}
end

function PlanScheduler:schedulePlan(plan)
	table.insert(self.plans, plan)
	plan:onStart()
end

function PlanScheduler:start()
	if self.schedulerHandle then
        scheduler:unscheduleScriptEntry(self.schedulerHandle)
        self.schedulerHandle = nil
    end

	self.schedulerHandle = scheduler:scheduleScriptFunc(function ( ... )
        self:update(...)
    end, 0, false)
end

function PlanScheduler:pause()
	scheduler:unscheduleScriptEntry(self.schedulerHandle)
    self.schedulerHandle = nil

    
end

function PlanScheduler:removePlan(plan)
	table.removeValue(self.plans, plan)
end

function PlanScheduler:removeAllPlan()
	for k,v in pairs(self.plans) do
    	v:onPause()
    end
    self.plans = {}
end

function PlanScheduler:update(delta)
	for k,plan in pairs(self.plans) do
		if not plan.stop then
			plan.timer = plan.timer + delta
			if plan.timer >= plan.costTime then
				if plan:onFinished() then
					plan:onStop()
				else
					self.plans[k] = nil
				end
			else
				if plan.timer > plan.tickIndex*plan.tickTime then
					plan.tickIndex = plan.tickIndex + 1
					plan:onTick()
				end
			end
		end
	end
end

return PlanScheduler