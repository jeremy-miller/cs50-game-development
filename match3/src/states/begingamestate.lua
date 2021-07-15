BeginGameState = class{__includes = BaseState}

function BeginGameState:init()
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 1

    -- spawn a board and place it toward the right
    self.board = Board(VIRTUAL_WIDTH - 272, 16)

    -- start our level # label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(def)
    -- grab level # from the def we're passed
    self.level = def.level

    --
    -- animate our white screen fade-in, then animate a drop-down with
    -- the level text
    --

    -- fade in
    timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    -- tween level label
    :finish(function()
        timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        -- pause for player to read level label
        :finish(function()
            timer.after(1, function()
                -- animate the label going down past the bottom edge
                timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                -- play
                :finish(function()
                    stateMachine:change('play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    timer.update(dt)
end

function BeginGameState:render()
    self.board:render()

    -- render Level # label and background rect
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
