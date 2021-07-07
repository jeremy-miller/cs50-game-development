class = require("class")
push = require("push")

require("bird")
require("pipe")
require("pipepair")

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("background.png")
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOP_POINT = 413 -- point at which we loop back to beginning of backgroun image

local ground = love.graphics.newImage("ground.png")
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60

local bird = Bird()

local pipePairs = {}

local pipeSpawnTimer = 0
local pipeSpawnMaxTime = 2

-- initialize last Y value for pipe gap placement
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Flappy Bird")

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            vsync = true,
            fullscreen = false,
            resizable = true
        }
    )

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + (BACKGROUND_SCROLL_SPEED * dt)) % BACKGROUND_LOOP_POINT
    groundScroll = (groundScroll + (GROUND_SCROLL_SPEED * dt)) % VIRTUAL_WIDTH

    pipeSpawnTimer = pipeSpawnTimer + dt
    if pipeSpawnTimer >= pipeSpawnMaxTime then
        -- Calculate Y of next PipePair based on lastY.
        -- Y should be no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length from the bottom.
        local nextGapY =
            math.max(
            -PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - PIPE_GAP_HEIGHT - PIPE_HEIGHT)
        )
        lastY = nextGapY
        table.insert(pipePairs, PipePair(nextGapY))
        pipeSpawnTimer = 0
    end

    bird:update(dt)

    for _, pair in pairs(pipePairs) do
        pair:update(dt)
    end

    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    love.keyboard.keysPressed = {} -- reset table so we only check keys pressed during this frame
end

function love.draw()
    push:start()

    -- draw images at their negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    for _, pair in pairs(pipePairs) do
        pair:render()
    end

    -- draw images at their negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())

    bird:render()

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
