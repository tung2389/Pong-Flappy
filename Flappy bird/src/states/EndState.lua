-- Inherit from BaseState
EndState = Class{__includes = BaseState}

local VIRTUAL = require('src.config.window.virtual')

function EndState:enter(params)
    self.score = params.score
end

function EndState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end
end

function EndState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL.WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL.WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL.WIDTH, 'center')
end