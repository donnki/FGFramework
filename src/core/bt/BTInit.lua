local bt = {}

BTResult = {
	Ended = 1,
	Running = 2,
}
BTActionStatus = {
	Ready = 1,
	Running = 2,
}

BTLogEnabled = false
BTDrawEnabled = true

function BTLog(...)
	if BTLogEnabled then
		print("[BTLOG] ", ...)
	end
end


BTNode = require("core.bt.BTNode")
BTAction = require("core.bt.action.BTAction")
BTPrecondition = require("core.bt.BTPrecondition")

BT_TREE_NODE = {
	BTCondition 		= "core.bt.condition.BTCondition",
	
	BTPrioritySelector 	= "core.bt.composite.BTPrioritySelector",
	BTSequence 			= "core.bt.composite.BTSequence",
	BTParallel 			= "core.bt.composite.BTParallel",
	BTParallelFlexible 	= "core.bt.composite.BTParallelFlexible",

	BTFireAction 		= "core.bt.action.BTFireAction",
	BTWaitAction 		= "core.bt.action.BTWaitAction",
	BTAimAction 		= "core.bt.action.BTAimAction",
	BTSearchAction 		= "core.bt.action.BTSearchAction",
	BTIdleAction 		= "core.bt.action.BTIdleAction",
	BTStunAction 		= "core.bt.action.BTStunAction",
	BTMoveAction 		= "core.bt.action.BTMoveAction",
	BTSkillAction 		= "core.bt.action.BTSkillAction",
	BTFinishedAction 	= "core.bt.action.BTFinishedAction",
}



function bt.loadFromJson(path, database)
	local index = 0
	if cc.FileUtils:getInstance():isFileExist(path) then
        local data = json.decode(cc.FileUtils:getInstance():getStringFromFile(path))
        local function loadChild(key)
			if data.nodes[key] then
				local node = data.nodes[key]
				local precondition = nil
				if node.properties.precondition and node.properties.precondition ~= "" then
					if database and database[node.properties.precondition] then
						precondition = BTPrecondition.new(node.title, nil, node.properties, handler(database, database[node.properties.precondition]))
					else
						Log.w("Precondition not found: ", node.properties.precondition)
					end
				end
				if BT_TREE_NODE[node.name] then
					local treeNode = require(BT_TREE_NODE[node.name]).new(node.title, precondition, node.properties)
					if node.children then
						for i,child in ipairs(node.children) do
							treeNode:addChild(loadChild(child))
						end
					end
					treeNode.id = index 
					index = index + 1
					treeNode.display = node.display
					return treeNode
				else
					Log.w("No BTNode: ", node.name)
				end
				
			else
				Log.e("Key: ", key , " not found!")
			end
		end 
		local root = loadChild(data.root)
		return root
    else
        Log.e("File: "..path.." not Found!")
    end
end

function bt.genDisplayTree(root, nodeRoot, drawNode, activeDrawNode)
	local node = cc.Node:create()
	node:setPosition(root.display.x, -root.display.y)
	root.display.node = node
	root.display.drawNode = activeDrawNode
	local text = root.__cname.."("..root.id..")\n"
	if root.properties and root.properties.precondition then
		text = text.."前置条件："..root.properties.precondition.."\n"
	end
	text = text..root.name
	display.newTTFLabel({text=text, size=20}):setTag(1):addTo(node)

	for i,child in ipairs(root.children) do
		bt.genDisplayTree(child, nodeRoot, drawNode, activeDrawNode)
		drawNode:drawLine(cc.p(node:getPosition()), cc.p(child.display.x, -child.display.y), cc.c4f(0,1,1,0.2))
	end
	nodeRoot:addChild(node)
end

function bt.debugDisplayTree(root)
	local nodeRoot = display.newNode()
	local drawNode = cc.DrawNode:create()
	local activeDrawNode = cc.DrawNode:create()
	nodeRoot:addChild(drawNode)
	nodeRoot:addChild(activeDrawNode)
	bt.genDisplayTree(root, nodeRoot, drawNode, activeDrawNode)
	return nodeRoot
end

return bt