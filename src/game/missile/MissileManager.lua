local MissileManager = class("MissileManager")
local Missile = import(".Missile")
local instance = nil

function MissileManager:getInstance()
	if instance == nil then
		instance = MissileManager.new()
	end
	return instance
end

function MissileManager:ctor()
	self.missiles = {}
end

function MissileManager:addMissile(from, arc, target, speed, trackTarget, onFinishedCallback)
	local missile = Missile.new(from, arc, target, speed, trackTarget, onFinishedCallback)
	table.insert(self.missiles, missile)
	return missile
end

function MissileManager:update()
	for i,v in ipairs(self.missiles) do
		if v.isFinished then
			table.remove(self.missiles, i)
		else
			v:update()
		end
	end
end
	
return MissileManager