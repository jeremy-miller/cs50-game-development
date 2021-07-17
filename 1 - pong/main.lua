-- make print() immediately appear in Output, instead of waiting until process exits
io.stdout:setvbuf("no")

push = require("push")
class = require("class")

require("ball")
require("paddle")

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

BALL_RADIUS = 2

WINNING_SCORE = 10

function love.load()
    math.randomseed(os.time())

    love.window.setTitle("Pong!")

    -- Use "nearest-neighbor" filtering to preserve pixel aesthetic.
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Create virtual screen with actual window, maintaining virtual resolution regardless of
    -- actual window size.
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = true,
            vsync = true
        }
    )

    local small_font_size = 8
    small_font = love.graphics.newFont("font.ttf", small_font_size)
    love.graphics.setFont(small_font) -- set default font
    local large_font_size = 16
    large_font = love.graphics.newFont("font.ttf", large_font_size)
    local score_font_size = 32
    score_font = love.graphics.newFont("font.ttf", score_font_size)

    sounds = {
        paddle_hit = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        score = love.audio.newSource("sounds/score.wav", "static"),
        wall_hit = love.audio.newSource("sounds/wall_hit.wav", "static")
    }

    player1_score = 0
    player2_score = 0

    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, PADDLE_WIDTH, PADDLE_HEIGHT)

    servingPlayer = 1

    ball =
        Ball(
        (VIRTUAL_WIDTH / 2) - BALL_RADIUS, -- X position
        (VIRTUAL_HEIGHT / 2) - BALL_RADIUS, -- Y position
        BALL_RADIUS * 2, -- width
        BALL_RADIUS * 2 -- height
    )

    game_state = "start"
end

-- Resize game window
function love.resize(w, h)
    push:resize(w, h)
end

-- "dt" is the number of seconds (or fraction of second) since last love.update() call.
function love.update(dt)
    -- Initialize ball's velocity towards player who last scored.
    if game_state == "serve" then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else -- servingPlayer == 2
            ball.dx = -math.random(140, 200)
        end
    elseif game_state == "play" then
        -- Ball/paddle collision detection
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03 -- increase velocity a bit
            ball.x = player1.x + PADDLE_WIDTH -- make sure ball is outside paddle

            -- Randomize ball's Y velocity (to keep game interesting), but keep same direction.
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds.paddle_hit:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03 -- increase velocity a bit
            ball.x = player2.x - (BALL_RADIUS * 2) -- make sure ball is outside paddle

            -- Randomize ball's Y velocity (to keep game interesting), but keep same direction.
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds.paddle_hit:play()
        end

        -- Detect if ball hit upper screen boundary.
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds.wall_hit:play()
        end
        -- Detect if ball hit lower screen boundary, accounting for ball radius.
        if ball.y >= VIRTUAL_HEIGHT - BALL_RADIUS then
            ball.y = VIRTUAL_HEIGHT - BALL_RADIUS
            ball.dy = -ball.dy
            sounds.wall_hit:play()
        end

        -- Scoring
        if ball.x < 0 then
            player2_score = player2_score + 1
            sounds.score:play()
            if player2_score >= WINNING_SCORE then
                winningPlayer = 2
                game_state = "done"
            else
                servingPlayer = 1
                ball:reset()
                game_state = "serve"
            end
        elseif ball.x > VIRTUAL_WIDTH then
            player1_score = player1_score + 1
            sounds.score:play()
            if player1_score >= WINNING_SCORE then
                winningPlayer = 1
                game_state = "done"
            else
                servingPlayer = 2
                ball:reset()
                game_state = "serve"
            end
        end
    end

    -- Player 1 movement
    if love.keyboard.isDown("w") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 movement
    if love.keyboard.isDown("up") then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if game_state == "play" then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    -- Begin rendering on virtual screen.
    push:start()

    -- Clear screen with grey color.
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    displayScore()

    if game_state == "start" then
        love.graphics.setFont(small_font)
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to begin", 0, 20, VIRTUAL_WIDTH, "center")
    elseif game_state == "serve" then
        love.graphics.setFont(small_font)
        local text = "Player " .. tostring(servingPlayer) .. "'s serve!"
        love.graphics.printf(text, 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to serve", 0, 20, VIRTUAL_WIDTH, "center")
    elseif game_state == "play" then
        -- no UI to display
    elseif game_state == "done" then
        love.graphics.setFont(large_font)
        local text = "Player " .. tostring(winningPlayer) .. " wins!"
        love.graphics.printf(text, 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(small_font)
        love.graphics.printf("Press Enter to restart", 0, 30, VIRTUAL_WIDTH, "center")
    end

    player1:render()
    player2:render()

    ball:render()

    displayFPS()

    -- End rendering on virtual screen.
    push:finish()
end

function displayScore()
    love.graphics.setFont(score_font)
    love.graphics.print(tostring(player1_score), (VIRTUAL_WIDTH / 2) - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2_score), (VIRTUAL_WIDTH / 2) + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    love.graphics.setFont(small_font)
    love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255) -- reset color to white
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if game_state == "start" then
            game_state = "serve"
        elseif game_state == "serve" then
            game_state = "play"
        elseif game_state == "done" then
            game_state = "serve"
            ball:reset()
            player1_score = 0
            player2_score = 0
            -- Let losing player serve first.
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end
