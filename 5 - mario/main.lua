require("src/dependencies")

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(fonts['medium'])
    love.window.setTitle('Super Mario Bros.')
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = true,
            canvas = false,
        }
    )
    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    stateMachine:change('start')

    sounds['music']:setLooping(true)
    sounds['music']:setVolume(0.5)
    sounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    stateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    stateMachine:render()
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
