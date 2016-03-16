BTResult = {
	Ended = 1,
	Running = 2,
}
BTActionStatus = {
	Ready = 1,
	Running = 2,
}

BTDebugEnabled = false

function BTLog(...)
	if BTDebugEnabled then
		print("[BTLOG] ", ...)
	end
end


BTNode = require("core.bt.BTNode")
BTAction = require("core.bt.action.BTAction")
BTPrecondition = require("core.bt.BTPrecondition")

BT_TREE_NODE = {
	BTPrecondition 		= "core.bt.composite.BTPrecondition",
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
}



function BTLoadFromJson(path, database)
	if cc.FileUtils:getInstance():isFileExist(path) then
        local data = json.decode(cc.FileUtils:getInstance():getStringFromFile(path))
        local function loadChild(key)
			if data.nodes[key] then
				local node = data.nodes[key]
				local precondition = nil
				if node.properties.precondition and node.properties.precondition ~= "" then
					if database and database[node.properties.precondition] then
						precondition = BTPrecondition.new(node.title, nil, handler(database, database[node.properties.precondition]))
					else
						Log.w("Precondition not found: ", node.properties.precondition)
					end
					
				end
				local treeNode = require(BT_TREE_NODE[node.name]).new(node.title, precondition)
				if node.children then
					for i,child in ipairs(node.children) do
						treeNode:addChild(loadChild(child))
					end
				end
				return treeNode
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