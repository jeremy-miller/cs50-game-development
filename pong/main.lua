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
            resizable = false,
            vsync = true
        }
    )

    local small_font_size = 8
    small_font = love.graphics.newFont("font.ttf", small_font_size)
    love.graphics.setFont(small_font) -- set default font
    local score_font_size = 32
    score_font = love.graphics.newFont("font.ttf", score_font_size)

    player1_score = 0
    player2_score = 0

    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, PADDLE_WIDTH, PADDLE_HEIGHT)

    ball = Ball(
        (VIRTUAL_WIDTH / 2) - BALL_RADIUS,  -- X position
        (VIRTUAL_HEIGHT / 2) - BALL_RADIUS, -- Y position
        BALL_RADIUS * 2,                    -- width
        BALL_RADIUS * 2                     -- height
    )

    game_state = "start"
end


-- "dt" is the number of seconds (or fraction of second) since last love.update() call.
function love.update(dt)
    if game_state == "play" then
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
        end

        -- Detect if ball hit upper screen boundary.
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
        -- Detect if ball hit lower screen boundary, accounting for ball radius.
        if ball.y >= VIRTUAL_HEIGHT - BALL_RADIUS then
            ball.y = VIRTUAL_HEIGHT - BALL_RADIUS
            ball.dy = -ball.dy
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
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(small_font)
    if game_state == "start" then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, "center")
    end

    love.graphics.setFont(score_font)
    love.graphics.print(tostring(player1_score), (VIRTUAL_WIDTH / 2) - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2_score), (VIRTUAL_WIDTH / 2) + 30, VIRTUAL_HEIGHT / 3)

    player1:render()
    player2:render()

    ball:render()

    displayFPS()

    -- End rendering on virtual screen.
    push:finish()
end


function displayFPS()
    love.graphics.setFont(small_font)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if game_state == "start" then
            game_state = "play"
        else
            game_state = "start"

            ball:reset()
        end
    end
end
