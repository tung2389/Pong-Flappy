Ball = Class{}

function Ball:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    -- Speed of the ball
    self.dx = math.random(2) == 1 and math.random(80, 100) or math.random(-80, -100)
    self.dy = math.random(2) == 1 and 100 or -100
end

function Ball:collidesPaddles(paddle)
    if self.y + self.radius > paddle.y and self.y - self.radius < paddle.y + paddle.height then
        -- Collides with player1
        if paddle.x == PADDLE1.x and self.x - self.radius <= paddle.x + paddle.width then 
            return true
        elseif paddle.x == PADDLE2.x and self.x + self.radius >= paddle.x then
            return true
        end
    end
    return false
end

function Ball:move(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:handleCollisions()
    if self:collidesPaddles(player1) then
        -- Put it right back to the right border of paddle 1
        self.x = player1.x + PADDLE_WIDTH + self.radius
        -- Each time the ball hit the paddle, increase its speed by 5%
        self.dx = -self.dx * 1.05
        self.dy = self.dy * 1.05
        sounds['paddle_hit']:play()
    elseif self:collidesPaddles(player2) then
        -- Put it right back to the left border of paddle 2
        self.x = player2.x - self.radius
        self.dx = -self.dx * 1.05
        self.dy = self.dy * 1.05
        sounds['paddle_hit']:play()
    end

    -- Ball collides with top and bottom border
    if self.y + self.radius > VIRTUAL_HEIGHT then
        self.y = VIRTUAL_HEIGHT - self.radius
        -- Change sign and randomize dy speed
        self.dy = -math.random(40, 150)
        sounds['wall_hit']:play()
    elseif self.y - self.radius < 0  then
        self.y = 0 + self.radius
        self.dy = math.random(40, 150)
        sounds['wall_hit']:play()
    end

    -- Ball collides with right and left border
    if self.x + self.radius > VIRTUAL_WIDTH - MARGIN then
        self.x = VIRTUAL_WIDTH - MARGIN - self.radius
        self.dx = -self.dx
        player1:gainScore(1)
        gameStateHandler.handleOneRound(1, player1.score)
        sounds['endround']:play()
    elseif self.x - self.radius < 0 + MARGIN then
        self.x = 0 + self.radius + MARGIN
        self.dx = -self.dx  
        player2:gainScore(1)
        gameStateHandler.handleOneRound(2, player2.score)
        sounds['endround']:play()
    end
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 
    self.y = VIRTUAL_HEIGHT / 2
    self.dx = math.random(2) == 1 and math.random(80, 100) or math.random(-80, -100)
    self.dy = math.random(2) == 1 and 100 or -100
end


function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end