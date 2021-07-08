StateMachine = class{}

function StateMachine:init(states)
    self.states = states or {}
    self.current = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
    }
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], "invalid stateName: " .. stateName)
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
