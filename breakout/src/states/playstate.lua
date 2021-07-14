PlayState = class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
    self.level = params.level
    self.highScores = params.highScores
    self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed("space") then
            self.paused = false
            sounds["pause"]:play()
        else
            return
        end
    elseif love.keyboard.wasPressed("space") then
        self.paused = true
        sounds["pause"]:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 8 -- reset ball above paddle
        self.ball.dy = -self.ball.dy

        -- tweak angle of bounce based on where it hits the paddle
        --
        -- if we hit the paddle on its left side while moving left
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + (self.paddle.width / 2) - self.ball.x))
        -- else if we hit the paddle on its right side while moving right
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + (self.paddle.width / 2) - self.ball.x))
        end

        sounds["paddle-hit"]:play()
    end

    for _, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + ((brick.tier * 200) + (brick.color * 25))
            brick:hit()

            if self:checkVictory() then
                sounds["victory"]:play()
                stateMachine:change("victory", {
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    ball = self.ball,
                    highScores = self.highScores,
                })
            end

            -- check brick collisions
            --
            -- left edge
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then -- + 2 to fix corners
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8 -- reset ball outside brick
            -- right edge
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then -- + 6 to fix corners
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32 -- reset ball outside brick
            -- top edge
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8 -- reset ball outside brick
            -- bottom edge
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16 -- reset ball outside brick
            end

            -- slightly scale y velocity to speed up game
            self.ball.dy = self.ball.dy * 1.02

            -- only allow collisions with one brick at a time, for corners
            break
        end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        sounds["hurt"]:play()

        if self.health == 0 then
            stateMachine:change("game-over", {
                score = self.score,
                highScores = self.highScores,
            })
        else
            stateMachine:change("serve", {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level,
                highScores = self.highScores,
            })
        end
    end

    -- update brick particles
    for _, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end
end

function PlayState:render()
    for _, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render particles over bricks
    for _, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(fonts["large"])
        love.graphics.printf("PAUSED", 0, (VIRTUAL_HEIGHT / 2) - 16, VIRTUAL_WIDTH, "center")
    end
end

function PlayState:checkVictory()
    for _, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end
