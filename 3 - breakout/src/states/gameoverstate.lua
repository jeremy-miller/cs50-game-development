GameOverState = class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        local highScore = false
        local highScoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            sounds["high-score"]:play()
            stateMachine:change("enter-high-score", {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex,
            })
        else
            stateMachine:change("start", {
                highScores = self.highScores,
            })
        end
    end

    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(fonts["large"])
    love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(fonts["medium"])
    love.graphics.printf("Final Score: " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
    love.graphics.printf("Press Enter!", 0, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 4), VIRTUAL_WIDTH, "center")
end
