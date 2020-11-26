Pipe = Class{}

local PIPE_IMAGE = require("src.config.objects.pipe").IMAGE
local PIPE_HEIGHT = require("src.config.objects.pipe").HEIGHT

function Pipe:init(x, y, type)
    self.image = PIPE_IMAGE
    self.x = x
    self.y = y
    self.type = type
end

function Pipe:render()
    if self.type == 'bottom' then
        love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    elseif self.type == 'top' then
        -- Flip the image with respect to its upper edge. We must + PIPE_HEIGHT because we will flip the image
        -- with respect to its upper edge and  self.y + PIPE_HEIGHT will move the top-left corner to correct
        -- position
        love.graphics.draw(PIPE_IMAGE, self.x, self.y + PIPE_HEIGHT, 0, 1, -1)
    end
end