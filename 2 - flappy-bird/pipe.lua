Pipe = class{}

PIPE_WIDTH = 70
PIPE_HEIGHT = 288
PIPE_SCROLL_SPEED = 60

local PIPE_IMAGE = love.graphics.newImage("assets/images/pipe.png")

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        (self.orientation == "top" and self.y + PIPE_HEIGHT or self.y), -- account for flipped image
        0, -- rotation
        1, -- X scale (1 = no scaling)
        self.orientation == "top" and -1 or 1 -- Y scale (-1 = flip image)
    )
end
