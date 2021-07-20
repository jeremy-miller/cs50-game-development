require 'src/dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Pokemon')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    Push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = true,
        }
    )

    -- this time, we are using a stack for all of our states, where the field state is the
    -- foundational state; it will have its behavior preserved between state changes because
    -- it is essentially being placed "behind" other running states as needed (like the battle
    -- state)

    stateStack = StateStack()
    stateStack:push(StartState())

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    Timer.update(dt)
    stateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()
    stateStack:render()
    Push:finish()
end

function love.resize(w, h)
    Push:resize(w, h)
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
