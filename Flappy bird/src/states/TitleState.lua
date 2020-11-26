-- Inherit from BaseState
TitleState = Class{__includes = BaseState}

local VIRTUAL = require("src.config.window.virtual")

function TitleState:init() end

function TitleState:update(dt)
    if love.keyboard.wasPressed('1') then
        gStateMachine:change('countdown', {
            mode = 'easy'
        })
    elseif love.keyboard.wasPressed('2') then
        gStateMachine:change('countdown', {
            mode = 'intermediate'
        })
    elseif love.keyboard.wasPressed('3') then
        gStateMachine:change('countdown', {
            mode = 'hard'
        })
    end
end

function TitleState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', 0, 32, VIRTUAL.WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press 1 to play with EASY mode', 0, 68, VIRTUAL.WIDTH, 'center')
    love.graphics.printf('Press 2 to play with INTERMEDIATE mode', 0, 108, VIRTUAL.WIDTH, 'center')
    love.graphics.printf('Press 3 to play with HARD mode', 0, 148, VIRTUAL.WIDTH, 'center')
end