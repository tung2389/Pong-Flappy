local PIPE_IMAGE = love.graphics.newImage('/images/pipe.png')

local props = {
    ['IMAGE'] = PIPE_IMAGE,
    ['WIDTH'] = PIPE_IMAGE:getWidth(),
    ['HEIGHT'] = PIPE_IMAGE:getHeight(),
    ['GAP_HEIGHT'] = 120,
    ['SPEED'] = 60,
    ['SPAWN_TIME'] = 2
}

return props