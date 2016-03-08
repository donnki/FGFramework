local FSM = class("FSM")

FSM.__index = FSM
FSM.root = nil
FSM.curState = nil
FSM.preState = nil
FSM.stateTable = nil

function FSM:ctor(root, states)
    self.root = root
    self.stateTable = {}
    self:init(root, states)

end

function FSM:init(root, stateTable)
    -- Log.w("TODO: FSM.init() should be override")
    -- local baseUrl = "game.scenes.battle.entity.fsm"
    -- local SoldierStateMove = require(baseUrl..".SoldierStateMove")
        
    -- self.stateTable = {
    --     enStateMove = SoldierStateMove.createWithSoldier(hero),
    -- }
    if stateTable then
        for k,v in pairs(stateTable) do
            local state = require(v).new(self.root, k)
            self.stateTable[k] = state
        end
    end
end

function FSM:addState(key, classpath)
    self.stateTable[key] = require(classpath).new(self.root, key)
end

function FSM:updateFrame(delta)
    if self.curState ~= nil then
        if self.curState:onCheckValidation() then
            self.curState:onUpdate(delta)
        end
    end
end

function FSM:popState()
    if self.preState ~= nil then
        self:changeState(self.preState.id)
    end
end

function FSM:clearState()
    if self.curState then
        self.curState:onExitState()
        self.curState = nil
    end
end

function FSM:changeState(state,params)
    if self.curState ~= nil and self.curState.id == state then
        self.curState:clear(params) -- 清除必要清除的变量，重新初始化新的变量
        return
    end
    local preStateID = nil
    self.preState = self.curState
    if self.preState ~= nil then
        preStateID = self.preState.id
        self.preState:onExitState(state)
    end
    self.curState = self.stateTable[state]
    self.curState:onEnterState(preStateID,params)
end


return FSM