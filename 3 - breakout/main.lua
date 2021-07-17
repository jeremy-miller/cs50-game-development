-- make print() immediately appear in Output in ZeroBrane, instead of waiting until process exits
io.stdout:setvbuf("no")

require("src/dependencies")

function love.load()
    -- for debugging in ZeroBrane
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Breakout")

    fonts = {
        ["small"] = love.graphics.newFont("assets/fonts/font.ttf", 8),
        ["medium"] = love.graphics.newFont("assets/fonts/font.ttf", 16),
        ["large"] = love.graphics.newFont("assets/fonts/font.ttf", 32),
    }
    love.graphics.setFont(fonts["small"])

    textures = {
        ["background"] = love.graphics.newImage("assets/images/background.png"),
        ["main"] = love.graphics.newImage("assets/images/breakout.png"),
        ["arrows"] = love.graphics.newImage("assets/images/arrows.png"),
        ["hearts"] = love.graphics.newImage("assets/images/hearts.png"),
        ["particle"] = love.graphics.newImage("assets/images/particle.png"),
    }

    frames = {
        ["paddles"] = GenerateQuadsPaddles(textures["main"]),
        ["balls"] = GenerateQuadsBalls(textures["main"]),
        ["bricks"] = GenerateQuadsBricks(textures["main"]),
        ["hearts"] = GenerateQuads(textures["hearts"], 10, 9),
        ['arrows'] = GenerateQuads(textures['arrows'], 24, 24),
    }

    sounds = {
        ["paddle-hit"] = love.audio.newSource("assets/sounds/paddle_hit.wav", "static"),
        ["score"] = love.audio.newSource("assets/sounds/score.wav", "static"),
        ["wall-hit"] = love.audio.newSource("assets/sounds/wall_hit.wav", "static"),
        ["confirm"] = love.audio.newSource("assets/sounds/confirm.wav", "static"),
        ["select"] = love.audio.newSource("assets/sounds/select.wav", "static"),
        ["no-select"] = love.audio.newSource("assets/sounds/no-select.wav", "static"),
        ["brick-hit-1"] = love.audio.newSource("assets/sounds/brick-hit-1.wav", "static"),
        ["brick-hit-2"] = love.audio.newSource("assets/sounds/brick-hit-2.wav", "static"),
        ["hurt"] = love.audio.newSource("assets/sounds/hurt.wav", "static"),
        ["victory"] = love.audio.newSource("assets/sounds/victory.wav", "static"),
        ["recover"] = love.audio.newSource("assets/sounds/recover.wav", "static"),
        ["high-score"] = love.audio.newSource("assets/sounds/high_score.wav", "static"),
        ["pause"] = love.audio.newSource("assets/sounds/pause.wav", "static"),

        ["music"] = love.audio.newSource("assets/sounds/music.wav", "static"),
    }

    stateMachine = StateMachine{
        ["start"] = function() return StartState() end,
        ["play"] = function() return PlayState() end,
        ["serve"] = function() return ServeState() end,
        ["game-over"] = function() return GameOverState() end,
        ["victory"] = function() return VictoryState() end,
        ["high-scores"] = function() return HighScoreState() end,
        ["enter-high-score"] = function() return EnterHighScoreState() end,
        ["paddle-select"] = function() return PaddleSelectState() end,
    }
    stateMachine:change("start", {
        highScores = loadHighScores(),
    })

    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keysPressed = {}

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            vsync = true,
            fullscreen = false,
            resizable = true,
        }
    )
end

function love.update(dt)
    stateMachine:update(dt)
    love.keyboard.keysPressed = {} -- reset keysPressed every frame
end

function love.draw()
    push:apply("start")

    local backgroundWidth = textures["background"]:getWidth()
    local backgroundHeight = textures["background"]:getHeight()
    love.graphics.draw(
        textures["background"],
        0, -- X
        0, -- Y
        0, -- rotation (none)
        -- scale on X and Y so background image always fits screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), -- X scale
        VIRTUAL_HEIGHT / (backgroundHeight - 1) -- Y scale
    )

    stateMachine:render()

    displayFPS()

    push:apply("end")
end

function displayFPS()
    love.graphics.setFont(fonts["small"])
    love.graphics.setColor(0, 1, 0, 1) -- green
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100

    -- render health left
    for i = 1, health do
        love.graphics.draw(textures["hearts"], frames["hearts"][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(textures["hearts"], frames["hearts"][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(fonts["small"])
    love.graphics.print("Score:", VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, "right")
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')
    local filename = "breakout.txt"

    if not love.filesystem.getInfo(filename) then
        -- inititialize with default scores
        local scores = ""
        for i = 10, 1, -1 do
            scores = scores .. "AAA\n"
            scores = scores .. tostring(i * 1000) .. "\n"
        end
        love.filesystem.write(filename, scores)
    end

    local name = true -- whether we're reading a name from the file or not
    local counter = 1
    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil,
        }
    end

    for line in love.filesystem.lines(filename) do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end
        name = not name
    end

    return scores
end
