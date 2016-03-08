local c = cc
local Label = c.Node

--[[
阴影： {"shadow": true,"shadow_color": "255,0,0,255","shadow_pos": "1,-1"}
描边： {"outline": true,"outline_color": "255,0,0,255","outline_width": 1}
发光： {"glow": true,"glow_color": "255,0,0,255"}
]]
function Label:updateWithCustumUserData()
	if self:getCustomProperty() and self:getCustomProperty() ~= "" then
		local p = json.decode(self:getCustomProperty())
		
		if p.shadow then
			local rgba = p.shadow_color:split(",")
			local pos = p.shadow_pos:split(",")
			self:enableShadow(cc.c4b(rgba[1], rgba[2], rgba[3], rgba[4]), cc.size(pos[1], pos[2]))
		end

		if p.outline then
			local rgba = p.outline_color:split(",")
			self:enableOutline(cc.c4b(rgba[1], rgba[2], rgba[3], rgba[4]), p.outline_width)
		end

		if p.glow then
			local rgba = p.glow_color:split(",")
			self:enableGlow(cc.c4b(rgba[1], rgba[2], rgba[3], rgba[4]))
		end
	end
end
