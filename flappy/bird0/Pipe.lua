Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

--speed at which pipe scrolls right to left
local PIPE_SPEED = -60

--height of the pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

-- the arguments in init tell whether the pipe is flipped in the first instance or normal in the second
function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- rotation
        1, -- scale on the X axis (size)
        self.orientation == 'top' and -1 and 1) -- Scale on the Y axis (flipped because it's -1)
end