local BIRD_IMAGE = love.graphics.newImage('/images/bird.png')

local props = {
    ['IMAGE'] = BIRD_IMAGE,
    ['GRAVITY'] = 20,
    ['JUMPING_DISTANCE'] = -5,
    ['WIDTH'] = BIRD_IMAGE:getWidth(),
    ['HEIGHT'] = BIRD_IMAGE:getHeight(),
    -- The player will not lose if they make a little mistake. This will make the game more interesting
    ['RELAXING_PIXELS'] = 4
}

return props