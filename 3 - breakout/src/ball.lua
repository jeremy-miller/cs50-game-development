Ball = class{}

function Ball:init(skin)
    self.width = 8
    self.height = 8
    self.dx = 0
    self.dy = 0
    self.skin = skin -- color of ball
end

function Ball:collides(target)
    -- check if left edge of either is farther right than right edge of other
    if self.x > (target.x + target.width) or target.x > (self.x + self.width) then
        return false
    end

    -- check if bottom edge of either is higher than top edge of other
    if self.y > (target.y + target.height) or target.y > (self.y + self.height) then
        return false
    end

    -- if above aren't true, they're colliding
    return true
end

function Ball:reset()
    self.x = (VIRTUAL_WIDTH / 2) - 2
    self.y = (VIRTUAL_HEIGHT / 2) - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)

    -- bounce off left wall
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        sounds["wall-hit"]:play()
    end

    -- bounce off right wall
    if self.x >= VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width
        self.dx = -self.dx
        sounds["wall-hit"]:play()
    end

    -- bounce off top wall
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        sounds["wall-hit"]:play()
    end
end

function Ball:render()
    love.graphics.draw(
        textures["main"],
        frames["balls"][self.skin],
        self.x,
        self.y
    )
end
