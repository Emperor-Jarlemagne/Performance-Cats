Bird =  Class{}

local GRAVITY = 20

function Bird:init()
    --image for the bird sprite (player character)
    self.image = love.graphics.newImage('bird.png')
    --sets size of the bird 
    --In this case Love dynamically sets size from the image file using the "getwidth/height" function
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    --sets placement of the image on the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width /2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    --y velocity; gravity
    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and references
    global pipe width and height values
]]

function Bird:collides(pipe)
    --the 2's are left and top offsets
    --the 4's are right and bottom offsets
    --both offsets are used to shrink the bounding border of the player
    --a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) (self.height - 4) >= pipe.y and self.y <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end
    return false
end

function Bird:update(dt)
    --apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end
    --apply current velocity to y position
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end