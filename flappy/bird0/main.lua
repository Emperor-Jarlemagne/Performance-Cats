push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'
--all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenStateS'

--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
--virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
--variables to keep track of the speed at which both images scroll
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- Variables written in caps are ones that DO NOT CHANGE / is CONSTANT
-- This will set scroll speead
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local GROUND_LOOPING_POINT = 514

--bird sprite! It's us!
local bird = Bird()

--table for spawning pipe pairs
local pipePairs = {}

local pipes = {}

--scrolling variable to pause game when pipe collision happens
local scrolling = true

function love.load()
    -- Initializes the "nearest neighbour" filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    --app window title
    love.window.setTitle('Fifty Bird')

    --initialize our retro text fonts (size of fonts is the number after the font style)
    smallFont = love.graphics.newFont('font.tff', 8)
    mediumFont = love.graphics.newFont('flappy.tff', 14)
    flappyFont = love.graphics.newFont('flappy.tff', 28)
    hugeFont = love.graphics.newFont('flappy.tff', 56)
    love.graphics.setFont(flappyFont)

    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    -- intialize the State Machine with all state-returning functionss (global function denoted with lower case 'g')
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }
    gStateMachine:change('title')

    --intialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

--This is the function to assign actions to keys
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then
    -- scroll background by preset speed muliply by 'delta time', looping back to 0 
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
    % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed, looping back after the screen width is hit
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
    % VIRTUAL_WIDTH

    --now we just update the state machine, which defers to the right state
    gStateMachine:update(dt)

    --reset input table
    love.keyboard.keysPressed = {}
end

--render function
function love.draw()
    push:start()
    --draws the image, and sets the position (0,0 is top left)
    love.graphics.draw(background, -backgroundScroll, 0)
--[[
    --creates proper render order (that way pipes appear on the ground, rather than in front of)
    for k, pipe in pairs(pipes) do
        pipe:render()
    end
]]
    gStateMachine:render()
    --draws the ground and set position at bottom ( 16 is the height of the image)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  --  bird:render()

    push:finish()
end