Class = require("/lib/class")
push = require("/lib/push")
require("/src/objects/Ball")
require("/src/objects/Paddle")
require("/src/handlers/keyboardHandler")
gameStateHandler = require("/src/handlers/gameStateHandler")

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432 
VIRTUAL_HEIGHT = 243
 
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

BALL_RADIUS = 2

MARGIN = 5

PADDLE1 = {
    x = MARGIN,
    -- Center the paddle
    y = VIRTUAL_HEIGHT/2 - PADDLE_HEIGHT/2
}
PADDLE2 = {
    -- -PADDLE_WIDTH so that both paddle will have the same distance from borders.
    x = VIRTUAL_WIDTH - MARGIN - PADDLE_WIDTH,
    y = VIRTUAL_HEIGHT/2 - PADDLE_HEIGHT/2
}

-- When resize screen, use push:resize
function love.resize(w, h)
    push:resize(w, h)
end

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Pong game")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullsreen = true,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- randomseed makes sure that the random function always return different value
    math.randomseed(os.time())
    servingPlayer = math.random(1,2)

    ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 , 2)
    player1 = Paddle(PADDLE1.x, PADDLE1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(PADDLE2.x, PADDLE2.y, PADDLE_WIDTH, PADDLE_HEIGHT)

    finalWinner = 0
    -- Four game states: start, serve, play, end
    gameState = 'start'

    smallFont = love.graphics.newFont('/fonts/font.ttf', 8)
    largeFont = love.graphics.newFont('/fonts/font.ttf', 16)
    scoreFont = love.graphics.newFont('/fonts/font.ttf', 32)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('/sounds/paddle_hit.wav', 'static'),
        ['endround'] = love.audio.newSource('/sounds/endround.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('/sounds/wall_hit.wav', 'static')
    }
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'end' then
            gameState = 'serve'
            ball:reset()
            player1.score = 0
            player2.score = 0
            if finalWinner == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(2) == 1 and 100 or -100
        if servingPlayer == 1 then
            ball.dx = math.random(80, 100)
        else
            ball.dx = -math.random(80, 100)
        end
    end
    if gameState == 'play' then
        ball:move(dt)
        ball:handleCollisions()
    end

    handleKeyboard()

    player1:move(dt)
    player2:move(dt)
end

function love.draw()
    push:start()

    -- Suitable color for Pong game
    love.graphics.clear(40, 45, 52, 255)
    -- Reset the color from the last frame
    love.graphics.setColor(255, 255, 255)

    ball:render()
    player1:render()
    player2:render()

    gameStateHandler.displayState()
    displayScore()
    displayFPS()

    push:finish()
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 5)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 5)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end