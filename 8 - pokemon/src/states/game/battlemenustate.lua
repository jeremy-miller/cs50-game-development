BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState)
    self.battleState = battleState

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        items = {
            {
                text = 'Fight',
                onSelect = function()
                    stateStack:pop()
                    stateStack:push(TakeTurnState(self.battleState))
                end
            },
            {
                text = 'Run',
                onSelect = function()
                    sounds['run']:play()

                    -- pop battle menu
                    stateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    stateStack:push(BattleMessageState('You fled successfully!', function() end), false)
                    Timer.after(0.5, function()
                        stateStack:push(FadeInState({
                            r = 1, g = 1, b = 1
                        }, 1,

                        -- pop message and battle state and add a fade to blend in the field
                        function()
                            -- resume field music
                            sounds['field-music']:play()

                            -- pop message state
                            stateStack:pop()

                            -- pop battle state
                            stateStack:pop()

                            stateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            }
        }
    }
end

function BattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function BattleMenuState:render()
    self.battleMenu:render()
end
