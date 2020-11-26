local PIPE = require('src.config.objects.pipe')

PipePair = Class{}

function PipePair:init(x, bottom_pipe_y, GAP_HEIGHT)
    self.x = x
    self.y = bottom_pipe_y
    self.GAP_HEIGHT = GAP_HEIGHT
    self.pipes = {
        ['bottom'] = Pipe(self.x, self.y, 'bottom'),
        -- self.y - self.GAP_HEIGHT - PIPE.HEIGHT is the y-coordinate of the top-left corner of the top pipe
        ['top'] = Pipe(self.x, self.y - self.GAP_HEIGHT - PIPE.HEIGHT, 'top')
    }
    self.scored = false
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE.WIDTH  then
        self.x = self.x - PIPE.SPEED * dt
        for type, pipe in pairs(self.pipes) do
            pipe.x = self.x
        end
    else
        self.remove = true
    end
end

function PipePair:render()
    for type, pipe in pairs(self.pipes) do
        pipe:render()
    end
end