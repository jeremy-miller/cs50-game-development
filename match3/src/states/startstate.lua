StartState = class{__includes = BaseState}

local positions = {}

function StartState:init()
    self.currentMenuItem = 1

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    self.colorTimer = timer.every(0.075, function()
        self.colors[0] = self.colors[6] -- ensure colors[0] exists for loop below

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, frames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate our full-screen transition rectangle
    self.transitionAlpha = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pauseInput = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.pauseInput then
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            sounds['select']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then
                timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function()
                    -- remove color timer since we're leaving this state
                    self.colorTimer:remove()

                    stateMachine:change('begin-game', {
                        level = 1
                    })
                end)
            else
                love.event.quit()
            end

            -- turn off input during transition
            self.pauseInput = true
        end
    end

    timer.update(dt)
end

function StartState:render()
    for y = 1, 8 do
        for x = 1, 8 do
            -- drop shadow
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.draw(
                textures['main'],
                positions[((y - 1) * x) + x],
                ((x - 1) * 32) + 128 + 3,
                ((y - 1) * 32) + 16 + 3
            )
            -- tile
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(
                textures['main'],
                positions[((y - 1) * x) + x],
                ((x - 1) * 32) + 128,
                ((y - 1) * 32) + 16)
        end
    end

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawMatch3Text()
    self:drawOptions()

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawMatch3Text()
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, (VIRTUAL_HEIGHT / 2) - 60 - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(fonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 - 60)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, (VIRTUAL_HEIGHT / 2) - 60, VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

-- draw "Start" and "Quit Game" over semi-transparent rectangles
function StartState:drawOptions()
    -- draw rect behind start and quit game text
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - 76, (VIRTUAL_HEIGHT / 2) + 12, 150, 58, 6)

    love.graphics.setFont(fonts['medium'])
    self:drawTextShadow('Start', (VIRTUAL_HEIGHT / 2) + 12 + 8)
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    love.graphics.printf('Start', 0, (VIRTUAL_HEIGHT / 2) + 12 + 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(fonts['medium'])
    self:drawTextShadow('Quit Game', (VIRTUAL_HEIGHT / 2) + 12 + 33)
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    love.graphics.printf('Quit Game', 0, (VIRTUAL_HEIGHT / 2) + 12 + 33, VIRTUAL_WIDTH, 'center')
end

-- draw same text multiple times for thicker shadown
function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end
