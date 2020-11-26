-- Inherit from BaseState
CountdownState = Class{__includes = BaseState}

local VIRTUAL = require("src.config.window.virtual")

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:enter(params)
    self.mode = params.mode
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        self.timer =  self.timer % 1
        self.count = self.count - 1
        if self.count == 0 then
            gStateMachine:change('play', {
                mode = self.mode
            })
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL.WIDTH, 'center')
end

