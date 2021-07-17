Bird = class{}

local GRAVITY = 20
local ANTI_GRAVITY = -5

function Bird:init()
    self.image = love.graphics.newImage("assets/images/bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (self.height / 2)
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + (GRAVITY * dt)
    self.y = self.y + self.dy

    if love.keyboard.wasPressed("space") then
        self.dy = ANTI_GRAVITY
        sounds["jump"]:play()
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    -- Offsets to shrink bounding box of bird to give some leway in collision detection.
    local topOffset = 2
    local leftOffset = 2
    local bottomOffset = 4 -- offset topOffset, as well as add 2 pixels of offset on bottom side
    local rightOffset = 4 -- offset leftOffset, as well as add 2 pixels of offset on right side

    if (self.x + leftOffset) + (self.width - rightOffset) >= pipe.x and (self.x + leftOffset) <= (pipe.x + PIPE_WIDTH) then
        if (self.y + topOffset) + (self.height - bottomOffset) >= pipe.y and (self.y + topOffset) <= (pipe.y + PIPE_HEIGHT) then
            return true
        end
    end

    return false
end
