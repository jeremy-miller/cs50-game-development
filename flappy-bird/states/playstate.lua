PlayState = class{__includes = BaseState}

local PIPE_SPAWN_MAX_TIME = 2

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.pipeSpawnTimer = 0
    self.score = 0

    -- initialize last Y value for pipe gap placement
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.pipeSpawnTimer = self.pipeSpawnTimer + dt
    if self.pipeSpawnTimer >= PIPE_SPAWN_MAX_TIME then
        -- Calculate Y of next PipePair based on lastY.
        -- Y should be no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length from the bottom.
        local nextGapY = math.max(
            -PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - PIPE_GAP_HEIGHT - PIPE_HEIGHT)
        )
        self.lastY = nextGapY
        table.insert(self.pipePairs, PipePair(nextGapY))
        self.pipeSpawnTimer = 0
    end

    for _, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds["score"]:play()
            end
        end

        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for _, pair in pairs(self.pipePairs) do
        for _, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds["explosion"]:play()
                sounds["hurt"]:play()
                stateMachine:change("score", {score = self.score})
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds["explosion"]:play()
        sounds["hurt"]:play()
        stateMachine:change("score", {score = self.score})
    end
end

function PlayState:render()
    for _, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.printf("Score: " .. tostring(self.score), 8, 8, VIRTUAL_WIDTH, "left")

    self.bird:render()
end
