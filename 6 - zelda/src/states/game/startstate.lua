StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.draw(
        textures['background'],
        0,
        0,
        0,
        VIRTUAL_WIDTH / textures['background']:getWidth(),
        VIRTUAL_HEIGHT / textures['background']:getHeight()
    )

    love.graphics.setFont(fronts['zelda'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Legend of Zelda', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('Legend of Zelda', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fronts['zelda-small'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end
