local background = love.graphics.newImage('/images/background.png')

local BACKGROUND_WIDTH = background:getWidth()
local BACKGROUND_HEIGHT = background:getHeight()

props = {
    ['IMAGE'] = background,
    ['WIDTH'] = BACKGROUND_WIDTH,
    ['HEIGHT'] = BACKGROUND_HEIGHT,
}

return props