local Toast = class("Toast", function()
	return cc.Node:create()
end)
Toast.__index = Toast

function Toast.create(title)
	local toast = Toast.new()
	local label = cc.Label:createWithSystemFont(title, "Helvetica", 24)
	label:setTag(1)
	toast:addChild(label,1)

	local bg = cc.LayerColor:create(cc.c4b(100,100,100,200))
    bg:setContentSize(label:getContentSize().width + 20, label:getContentSize().height)
    bg:setPosition(-label:getContentSize().width/2-10, -label:getContentSize().height/2)
    toast:addChild(bg,0)
    bg:setTag(2)
    toast:setPosition(SCREEN.width/2, SCREEN.height/2)
    return toast
end
function Toast.makeText(title, duration)
	if not duration then
		duration = 1
	end
	local toast = Toast.create(title)
	cc.Director:getInstance():getRunningScene():addChild(toast, 99999)

	toast:runAction(cc.Sequence:create(
		cc.DelayTime:create(duration),
		cc.CallFunc:create(function()
			toast:getChildByTag(1):runAction(cc.FadeOut:create(1))
			toast:getChildByTag(2):runAction(cc.FadeOut:create(1))
			toast:runAction(cc.Sequence:create(cc.DelayTime:create(1.1), cc.CallFunc:create(function()
				toast:removeFromParent(true)
			end)))
			
		end)
		))
end

return Toast