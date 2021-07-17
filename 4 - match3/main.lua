require("src/dependencies")

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Match 3')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            vsync = true,
            fullscreen = false,
            resizable = true,
            canvas = true
        }
    )
    sounds['music']:setLooping(true)
    sounds['music']:play()

    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    stateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    -- scroll background, used across all states
    backgroundX = backgroundX - (BACKGROUND_SCROLL_SPEED * dt)

    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + (VIRTUAL_WIDTH - 4) + 51 then
        backgroundX = 0
    end

    stateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(textures['background'], backgroundX, 0)

    stateMachine:render()

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
