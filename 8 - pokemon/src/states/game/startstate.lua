StartState = Class{__includes = BaseState}

function StartState:init()
    sounds['intro-music']:play()

    self.sprite = POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]].battleSpriteFront
    self.spriteX = VIRTUAL_WIDTH / 2 - 32
    self.spriteY = VIRTUAL_HEIGHT / 2 - 16

    self.tween = Timer.every(3, function()
        Timer.tween(0.2, {
            [self] = {spriteX = -64}
        })
        :finish(function()
            self.sprite = POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]].battleSpriteFront
            self.spriteX = VIRTUAL_WIDTH
            self.spriteY = VIRTUAL_HEIGHT / 2 - 16

            Timer.tween(0.2, {
                [self] = {spriteX = VIRTUAL_WIDTH / 2 - 32}
            })
        end)
    end)
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateStack:push(FadeInState({
            r = 1, g = 1, b = 1
        }, 1,
        function()
            sounds['intro-music']:stop()
            self.tween:remove()

            stateStack:pop()

            stateStack:push(PlayState())
            stateStack:push(DialogueState("" ..
                "Welcome to the world of Pokemon! To start fighting monsters with your own randomly assigned" ..
                " monster, just walk in the tall grass! If you need to heal, just press 'P' in the field! " ..
                "Good luck! (Press Enter to dismiss dialogues)"
            ))
            stateStack:push(FadeOutState({
                r = 1, g = 1, b = 1
            }, 1,
            function() end))
        end))
    end
end

function StartState:render()
    love.graphics.clear(188/255, 188/255, 188/255, 1)

    love.graphics.setColor(24/255, 24/255, 24/255, 1)
    love.graphics.setFont(fonts['large'])
    love.graphics.printf('Pokemon!', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(fonts['small'])

    love.graphics.setColor(45/255, 184/255, 45/255, 124/255)
    love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 32, 72, 24)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(textures[self.sprite], self.spriteX, self.spriteY)
end
