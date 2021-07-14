Paddle = class{}

function Paddle:init(skin)
    self.x = (VIRTUAL_WIDTH / 2) - 32
    self.y = VIRTUAL_HEIGHT - 32
    self.dx = 0
    self.width = 64
    self.height = 16
    self.skin = skin -- paddle color
    self.size = 2 -- variant of the 4 paddle sizes currently used
end

function Paddle:update(dt)
    if love.keyboard.isDown("left") then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown("right") then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        -- make sure we don't go off left side of screen
        self.x = math.max(0, self.x + (self.dx * dt))
    else
        -- make sure we don't go off right side of screen
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + (self.dx * dt))
    end
end

function Paddle:render()
    love.graphics.draw(
        textures["main"],
        -- get paddle corresponding to correct size and skin
        frames["paddles"][self.size + (4 * (self.skin - 1))],
        self.x,
        self.y
    )
end
