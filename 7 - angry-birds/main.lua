require 'src/dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Angry Birds')

    Push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = true
        }
    )

    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    stateMachine:change('start')

    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    paused = false
end

function love.update(dt)
    if not paused then
        stateMachine:update(dt)

        love.keyboard.keysPressed = {}
        love.mouse.keysPressed = {}
        love.mouse.keysReleased = {}
    end
end

function love.draw()
    Push:start()
    stateMachine:render()
    Push:finish()
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    if key == 'p' then
        paused = not paused
    end

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end
