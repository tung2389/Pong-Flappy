-- Inherit from BaseState
PlayState = Class{__includes = BaseState}

local VIRTUAL = require("src.config.window.virtual")
local BIRD = require("src.config.objects.bird")
local GAP_HEIGHT = require('src.config.objects.pipe').GAP_HEIGHT
local PIPE_WIDTH = require('src.config.objects.pipe').WIDTH
-- The minimum value of the height of the top pipe and the bottom pipe
local MIN_HEIGHT = 20

function PlayState:init(spawnTime)
    self.bird = Bird(VIRTUAL.WIDTH / 2 - BIRD.WIDTH / 2, VIRTUAL.HEIGHT/2 - BIRD.HEIGHT / 2)
    self.pipePairs = {}
    self.timer = 0
    self.spawnTime = spawnTime
    self.score = 0
    -- Last y value of bottom pipe
    self.lastY = math.random(GAP_HEIGHT + MIN_HEIGHT, VIRTUAL.HEIGHT - MIN_HEIGHT)
end

function PlayState:enter(params)
    self.mode = params.mode
    scrolling = true
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.spawnTime then
        if self.mode == 'easy' then
            table.insert( self.pipePairs, PipePair(VIRTUAL.WIDTH, self.lastY, GAP_HEIGHT))
            -- math.min prevents the bottom pipe from being too low
            -- math.max prevents the bottom pipe from being too hgih
            self.lastY = math.max(math.min(self.lastY + math.random( -20, 20 ), 
                                    VIRTUAL.HEIGHT - MIN_HEIGHT), GAP_HEIGHT + MIN_HEIGHT)
        
        elseif self.mode == 'intermediate' then
            local y = math.random(GAP_HEIGHT + MIN_HEIGHT, VIRTUAL.HEIGHT - MIN_HEIGHT)
            table.insert( self.pipePairs, PipePair(VIRTUAL.WIDTH, y, GAP_HEIGHT))
        elseif self.mode == 'hard' then
            -- Decrease the GAP_HEIGHT to create more challenge
            GAP_HEIGHT = 90
            local y = math.random(GAP_HEIGHT + MIN_HEIGHT, VIRTUAL.HEIGHT - MIN_HEIGHT)
            table.insert( self.pipePairs, PipePair(VIRTUAL.WIDTH, y, GAP_HEIGHT))
        end
        self.timer = 0
    end

    for key, pair in pairs(self.pipePairs) do
        if pair.scored == false then
            if self.bird.x > pair.x + PIPE_WIDTH then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        for k, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('end', {
                    score = self.score
                })
                sounds['hurt']:play()
                sounds['explosion']:play()
            end
        end
        pair:update(dt)

    end

    -- If the left-most pipePair is going out of the screen, remove it to reduce memory.
    if self.pipePairs[1] ~= nil then
        if self.pipePairs[1].remove == true then
            table.remove(self.pipePairs, 1)
        end
    end

    -- If the bird falls to the ground
    if self.bird.y > VIRTUAL.HEIGHT - BIRD.HEIGHT then
        gStateMachine:change('end', {
            score = self.score
        })
        sounds['hurt']:play()
        sounds['explosion']:play()
    end

    self.bird:update(dt)
end

function PlayState:render()
    for key, pair in pairs(self.pipePairs) do
        pair:render()
    end
    -- love.graphics.print(tostring(table.getn(self.pipePairs)), 100, 200)
    self.bird:render()

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end

function PlayState:exit()
    scrolling = false
end