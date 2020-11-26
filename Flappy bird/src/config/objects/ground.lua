local ground = love.graphics.newImage('/images/ground.png')

local GROUND_WIDTH = ground:getWidth()
local GROUND_HEIGHT = ground:getHeight()

props = {
    ['IMAGE'] = ground,
    ['WIDTH'] = GROUND_WIDTH,
    ['HEIGHT'] = GROUND_HEIGHT,
}

return props