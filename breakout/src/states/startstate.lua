StartState = class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1

function StartState:update(dt)
    if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
        highlighted = highlighted == 1 and 2 or 1
        sounds["paddle-hit"]:play()
    end

    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        sounds["confirm"]:play()
        if highlighted == 1 then
            stateMachine:change("play")
        end
    end

    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(fonts["large"])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(fonts["medium"])

    if highlighted == 1 then
        -- highlight "Start" in blue
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, (VIRTUAL_HEIGHT / 2) + 70, VIRTUAL_WIDTH, "center")

    -- reset color to white
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        -- highlight "High Scores" in blue
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, (VIRTUAL_HEIGHT / 2) + 90, VIRTUAL_WIDTH, "center")

    -- reset color to white
    love.graphics.setColor(1, 1, 1, 1)
end
