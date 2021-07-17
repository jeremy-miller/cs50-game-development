Tile = class{}

function Tile:init(x, y, color, variety)
    -- position of tile within board array
    self.gridX = x
    self.gridY = y

    -- coordinates of tile
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.variety = variety
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(
        textures['main'],
        frames['tiles'][self.color][self.variety],
        self.x + x + 2,
        self.y + y + 2
    )

    -- draw tile
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        textures['main'],
        frames['tiles'][self.color][self.variety],
        self.x + x,
        self.y + y
    )
end
