TakeTurnState = Class{__includes = BaseState}

function TakeTurnState:init(battleState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]

    self.playerSprite = self.battleState.playerSprite
    self.opponentSprite = self.battleState.opponentSprite

    -- figure out which pokemon is faster, as they get to attack first
    if self.playerPokemon.speed > self.opponentPokemon.speed then
        self.firstPokemon = self.playerPokemon
        self.secondPokemon = self.opponentPokemon
        self.firstSprite = self.playerSprite
        self.secondSprite = self.opponentSprite
        self.firstBar = self.battleState.playerHealthBar
        self.secondBar = self.battleState.opponentHealthBar
    else
        self.firstPokemon = self.opponentPokemon
        self.secondPokemon = self.playerPokemon
        self.firstSprite = self.opponentSprite
        self.secondSprite = self.playerSprite
        self.firstBar = self.battleState.opponentHealthBar
        self.secondBar = self.battleState.playerHealthBar
    end
end

function TakeTurnState:enter(params)
    self:attack(self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar,

    function()

        -- remove the message
        stateStack:pop()

        -- check to see whether the player or enemy died
        if self:checkDeaths() then
            stateStack:pop()
            return
        end

        self:attack(self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar,

        function()

            -- remove the message
            stateStack:pop()

            -- check to see whether the player or enemy died
            if self:checkDeaths() then
                stateStack:pop()
                return
            end

            -- remove the last attack state from the stack
            stateStack:pop()
            stateStack:push(BattleMenuState(self.battleState))
        end)
    end)
end

function TakeTurnState:attack(attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, onEnd)
    -- first, push a message saying who's attacking, then flash the attacker
    -- this message is not allowed to take input at first, so it stays on the stack
    -- during the animation
    stateStack:push(BattleMessageState(attacker.name .. ' attacks ' .. defender.name .. '!', function() end, false))

    -- pause for half a second, then play attack animation
    Timer.after(0.5, function()

        -- attack sound
        sounds['powerup']:stop()
        sounds['powerup']:play()

        -- blink the attacker sprite three times (turn on and off blinking 6 times)
        Timer.every(0.1, function()
            attackerSprite.blinking = not attackerSprite.blinking
        end)
        :limit(6)
        :finish(function()
            -- after finishing the blink, play a hit sound and flash the opacity of
            -- the defender a few times
            sounds['hit']:stop()
            sounds['hit']:play()

            Timer.every(0.1, function()
                defenderSprite.opacity = defenderSprite.opacity == 64/255 and 1 or 64/255
            end)
            :limit(6)
            :finish(function()
                -- shrink the defender's health bar over half a second, doing at least 1 dmg
                local dmg = math.max(1, attacker.attack - defender.defense)

                Timer.tween(0.5, {
                    [defenderBar] = {value = defender.currentHP - dmg}
                })
                :finish(function()
                    defender.currentHP = defender.currentHP - dmg
                    onEnd()
                end)
            end)
        end)
    end)
end

function TakeTurnState:checkDeaths()
    if self.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

function TakeTurnState:faint()
    -- drop player sprite down below the window
    Timer.tween(0.2, {
        [self.playerSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- when finished, push a loss message
        stateStack:push(BattleMessageState('You fainted!',
        function()
            -- fade in black
            stateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                -- restore player pokemon to full health
                self.playerPokemon.currentHP = self.playerPokemon.HP

                -- resume field music
                sounds['battle-music']:stop()
                sounds['field-music']:play()

                -- pop off the battle state and back into the field
                stateStack:pop()
                stateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1, function()
                    stateStack:push(DialogueState('Your Pokemon has been fully restored; try again!'))
                end))
            end))
        end))
    end)
end

function TakeTurnState:victory()
    -- drop enemy sprite down below the window
    Timer.tween(0.2, {
        [self.opponentSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- play victory music
        sounds['battle-music']:stop()

        sounds['victory-music']:setLooping(true)
        sounds['victory-music']:play()

        -- when finished, push a victory message
        stateStack:push(BattleMessageState('Victory!',
        function()
            -- sum all IVs and multiply by level to get exp amount
            local exp = (
                self.opponentPokemon.HPIV +
                self.opponentPokemon.attackIV +
                self.opponentPokemon.defenseIV +
                self.opponentPokemon.speedIV
            ) * self.opponentPokemon.level

            stateStack:push(BattleMessageState('You earned ' .. tostring(exp) .. ' experience points!', function() end, false))

            Timer.after(1.5, function()
                sounds['exp']:play()

                -- animate the exp filling up
                Timer.tween(0.5, {
                    [self.battleState.playerExpBar] = {value = math.min(self.playerPokemon.currentExp + exp, self.playerPokemon.expToLevel)}
                })
                :finish(function()
                    -- pop exp message off
                    stateStack:pop()

                    self.playerPokemon.currentExp = self.playerPokemon.currentExp + exp

                    -- level up if we've gone over the needed amount
                    if self.playerPokemon.currentExp > self.playerPokemon.expToLevel then

                        sounds['levelup']:play()

                        -- set our exp to whatever the overlap is
                        self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel
                        self.playerPokemon:levelUp()

                        stateStack:push(BattleMessageState('Congratulations! Level Up!',
                        function()
                            self:fadeOutWhite()
                        end))
                    else
                        self:fadeOutWhite()
                    end
                end)
            end)
        end))
    end)
end

function TakeTurnState:fadeOutWhite()
    -- fade in
    stateStack:push(FadeInState({
        r = 1, g = 1, b = 1
    }, 1,
    function()
        -- resume field music
        sounds['victory-music']:stop()
        sounds['field-music']:play()

        -- pop off the battle state
        stateStack:pop()
        stateStack:push(FadeOutState({
            r = 1, g = 1, b = 1
        }, 1, function() end))
    end))
end
