StateMachine =  Class{}

function StateMachine:init(states)
    -- Default method of each state
    self.empty = {
        enter = function() end,
        update = function() end,
        render = function() end,
        exit = function() end
    }
    self.states = states or {}
    -- Current state
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], 'state does not exist')
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

