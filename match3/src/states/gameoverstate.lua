GameOverState = class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setFont(fonts['large'])
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - 64, 64, 128, 136, 4)
    love.graphics.setColor(99/255, 155/255, 255/255, 255/255)
    love.graphics.printf('GAME OVER', (VIRTUAL_WIDTH / 2) - 64, 64, 128, 'center')
    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', (VIRTUAL_WIDTH / 2) - 64, 180, 128, 'center')
end
