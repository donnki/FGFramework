BTResult = {
	Ended = 1,
	Running = 2,
}
BTActionStatus = {
	Ready = 1,
	Running = 2,
}

BTDebugEnabled = true

function BTLog(...)
	print("[BTLOG] ", ...)
end

BTAction = require("core.bt.BTAction")
BTNode = require("core.bt.BTNode")
BTPrecondition = require("core.bt.BTPrecondition")
BTPrioritySelector = require("core.bt.BTPrioritySelector")
BTSequence = require("core.bt.BTSequence")
BTParallel = require("core.bt.BTParallel")
BTParallelFlexible = require("core.bt.BTParallelFlexible")