class = require("lib/class")
push = require("lib/push")

require("bird")
require("pipe")
require("pipepair")
require("statemachine")
require("states/basestate")
require("states/countdownstate")
require("states/playstate")
require("states/scorestate")
require("states/titlescreenstate")

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("assets/images/background.png")
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOP_POINT = 413 -- point at which we loop back to beginning of backgroun image

local ground = love.graphics.newImage("assets/images/ground.png")
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Flappy Bird")

    smallFont = love.graphics.newFont("assets/fonts/font.ttf", 8)
    mediumFont = love.graphics.newFont("assets/fonts/flappy.ttf", 14)
    flappyFont = love.graphics.newFont("assets/fonts/flappy.ttf", 28)
    hugeFont = love.graphics.newFont("assets/fonts/flappy.ttf", 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ["jump"] = love.audio.newSource("assets/sounds/jump.wav", "static"),
        ["explosion"] = love.audio.newSource("assets/sounds/explosion.wav", "static"),
        ["hurt"] = love.audio.newSource("assets/sounds/hurt.wav", "static"),
        ["score"] = love.audio.newSource("assets/sounds/score.wav", "static"),
        ["music"] = love.audio.newSource("assets/sounds/marios_way.mp3", "static"),
    }
    sounds["music"]:setLooping(true)
    sounds["music"]:play()

    stateMachine = StateMachine {
        ["title"] = function() return TitleScreenState() end,
        ["countdown"] = function() return CountdownState() end,
        ["play"] = function() return PlayState() end,
        ["score"] = function() return ScoreState() end,
    }
    stateMachine:change("title")

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
    stateMachine:update(dt)
    love.keyboard.keysPressed = {} -- reset table so we only check keys pressed during this frame
end

function love.draw()
    push:start()

    -- draw images at their negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    stateMachine:render()

    -- draw images at their negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())

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
