Snail = class{__includes = Entity}

function Snail:init(def)
    Entity.init(self, def)
end

function Snail:render()
    love.graphics.draw(
        textures[self.texture],
        frames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8,
        math.floor(self.y) + 8,
        0,
        self.direction == 'left' and 1 or -1, -- flip sprite
        1,
        8,
        10
    )
end
