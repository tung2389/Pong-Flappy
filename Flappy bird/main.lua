Class = require('lib.class')
push = require('lib.push')

require('src.objects.Bird')
require('src.objects.Pipe')
require('src.objects.PipePair')

require('src.states.BaseState')
require('src.states.TitleState')
require('src.states.CountdownState')
require('src.states.PlayState')
require('src.states.EndState')

require('src.stateMachine.StateMachine')

local WINDOW = require('src.config.window.window')
local VIRTUAL = require('src.config.window.virtual')

local BACKGROUND = require('src.config.objects.background')
local GROUND = require('src.config.objects.ground')

local SPAWN_TIME = require('src.config.objects.pipe').SPAWN_TIME

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED =  60

-- To find a suitable value, you must evaluate the background image
local BACKGROUND_LOOPING_POINT = 414
-- Can be any value (small enough so that in the screen there is always a ground) because in the ground image everywhere is the same.
local GROUND_LOOPING_POINT = GROUND.WIDTH - VIRTUAL.WIDTH - 10

scrolling = true

function love.resize(w, h)
    push:resize(w, h)
end

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    math.randomseed(os.time())

    love.window.setTitle('Flappyy Bird')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('/fonts/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL.WIDTH, VIRTUAL.HEIGHT, WINDOW.WIDTH, WINDOW.HEIGHT, {
        fullscreen = false,
        resizable = true, 
        vsync = true,
        canvas = false
    })

    sounds = {
        ['music'] = love.audio.newSource('/sound/marios_way.mp3', 'static'),
        ['jump'] = love.audio.newSource('/sound/jump.wav', 'static'),
        ['score'] = love.audio.newSource('/sound/score.wav', 'static'),
        ['hurt'] = love.audio.newSource('/sound/hurt.wav', 'static'),
        ['explosion'] = love.audio.newSource('/sound/explosion.wav', 'static')
    }

    -- Play some background music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    gStateMachine = StateMachine({
        ['title'] = function() return TitleState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState(SPAWN_TIME) end,
        ['end'] = function() return EndState() end
    })
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
    end

    gStateMachine:update(dt)
    -- Reset keypress table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(BACKGROUND.IMAGE, -backgroundScroll, 0)
    love.graphics.draw(GROUND.IMAGE, -groundScroll, VIRTUAL.HEIGHT - GROUND.HEIGHT)
    gStateMachine:render()
    push:finish()
end