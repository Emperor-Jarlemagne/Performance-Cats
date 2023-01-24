PipePair = Class{}

--size of gap between pipes
local GAP_HEIGHT = 90

function PipePair:init(y)
    --initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    --y value is the topmost pipe; gap is a vertical shift of the second
    self.y = Y
    --instantiate two pipes that belong to this pair
    self.pipes =  {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    
    --whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function PipePair:update(dt)
    -- remove pipe from the scene if its beyond the left edge of the screen
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end    

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
