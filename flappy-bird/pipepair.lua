PipePair = class {}

PIPE_GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("bottom", self.y + PIPE_GAP_HEIGHT + PIPE_HEIGHT)
    }
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - (PIPE_SCROLL_SPEED * dt)
        self.pipes["upper"].x = self.x
        self.pipes["lower"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for _, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
