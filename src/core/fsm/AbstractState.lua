
local AbstractState = class("AbstractState")

AbstractState.root = nil
AbstractState.id = nil
AbstractState.preState = nil

function AbstractState:onEnterState(preState, param)
    Log.w("TODO: AbstractState.onEnterState() should be override: ", self.__cname)
end

function AbstractState:onExitState(nextState)
    Log.w("TODO: AbstractState.onExitState() should be override: ", self.__cname)
end

function AbstractState:onUpdate(delta)
    Log.w("TODO: AbstractState.onUpdate() should be override: ", self.__cname)
end

function AbstractState:onCheckValidation()
    Log.w("TODO: AbstractState.init() should be override: ", self.__cname)
    return false
end

function AbstractState:init() 
    Log.i("TODO: AbstractState.init() should be override: ", self.__cname)
end

function AbstractState:ctor(root, id)
    self.root = root
    self.id = id
    self:init()
end

function AbstractState:clear(params) --清除必要清除的变量，重新初始化新的变量
    
end

function AbstractState:getRoot()
    return self.root
end


return AbstractState

