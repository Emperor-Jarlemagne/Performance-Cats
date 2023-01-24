
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

--initialize our last recorded Y value for a gap placement to base other gaps on
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --this gives the spawn rate of the first pipe sprite
    self.Timer = self.Timer + dt

    --spawn new pipe pair every 1.5 seconds
    if self.Timer > 2 then 
        --modify last Y coordinate we placed so  pipe wont be so far apaert
        --no higher than 10 pixels below the top edge of the screen
        -- and no lower than a gap lenght (90px) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        --add a new pipe pair at the end of the screen
        table.insert(pipePairs, PipePair(y))
        -- resets spawn timer, so that the frames arent cloggged with pipe sprites
        self.Timer = 0
    end

        -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end
    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    --update the bird for input and gravity
    bird:update(dt)

    --for every pipe pair in the scene
    for k, pair in pairs(pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then 
                gStateMachine:change('title')
            end
        end
    end
        --check to see if bird collided with pipe ('l' in this case means EVERY)
    for l, pipe in pairs(pair.pipes) do 
        if bird:collides(pipe) then
                --pause game to show collision
            scrolling = false
        end
    end
--reset if we hit the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('title')
    end
end

        --remove any flagged pipes
        --we need this second loop, rather than deleting the previous loop
        --modifying the table in place without explicit keys will result in skipping
        --next pipe since all implicit keys (numerical indices are automatically
        -- down after a table removal
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end
