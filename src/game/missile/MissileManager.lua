local MissileManager = class("MissileManager")

local instance = nil

function MissileManager:getInstance()
	if instance == nil then
		instance = MissileManager.new()
	end
	return instance
end

	
return MissileManager