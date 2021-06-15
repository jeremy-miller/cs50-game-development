Ball = class{}


function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end


function Ball:reset()
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (self.width / 2)
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

--- Determines whether the ball has collided with the given paddle.
-- Axis-aligned bounding box (AABB) collision detection.
-- @param paddle Paddle: Paddle object checking for collision with.
-- @return bool: true if collision, false otherwise
function Ball:collides(paddle)
    -- Check if left edge of either is farther to the right than the right edge of the other.
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Check if bottom edge of either is higher than the top edge of the other.
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- They're overlapping
    return true
end


function Ball:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
end


function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
