local BIRD = require("src.config.objects.bird")
local PIPE = require("src.config.objects.pipe")

Bird = Class{}

function Bird:init(x, y)
    self.image = BIRD.IMAGE
    self.x = x
    self.y = y
    self.width = BIRD.WIDTH
    self.height = BIRD.HEIGHT
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + BIRD.GRAVITY * dt
    if love.keyboard.wasPressed('enter') 
        or love.keyboard.wasPressed('return') 
        or love.keyboard.wasPressed('space')
        or love.mouse.wasPressed(1) 
    then
        self.dy = BIRD.JUMPING_DISTANCE
        sounds['jump']:play()
    end
    -- Math.max prevent the bird from going out of the upper border
    self.y = math.max(self.y + self.dy, 0)
end

function Bird:collides(pipe)
    if self.x + BIRD.RELAXING_PIXELS > pipe.x + PIPE.WIDTH
        or self.x + self.width < pipe.x + BIRD.RELAXING_PIXELS
        or self.y + BIRD.RELAXING_PIXELS > pipe.y + PIPE.HEIGHT
        or self.y + self.height < pipe.y + BIRD.RELAXING_PIXELS
    then
        return false
    end
    return true
end

function Bird:render()
    love.graphics.draw(BIRD.IMAGE, self.x, self.y)
end

