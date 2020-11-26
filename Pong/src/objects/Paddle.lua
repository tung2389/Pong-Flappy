Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.score = 0
end

function Paddle:move(dt)
    if self.dy < 0 then
       -- Don't allow the paddle to get out of the upper border
       self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt) 
    end
end

function Paddle:gainScore(score)
    self.score = self.score + score
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end