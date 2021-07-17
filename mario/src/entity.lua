Entity = class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.dx = 0
    self.dy = 0
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    self.stateMachine = def.stateMachine
    self.direction = 'left'
    self.map = def.map -- reference to tile map so we can check collisions
    self.level = def.level -- reference to level for tests against other entities + objects
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

-- AABB collision detection
function Entity:collides(entity)
    return not (
        self.x > entity.x + entity.width or entity.x > self.x + self.width or
        self.y > entity.y + entity.height or entity.y > self.y + self.height
    )
end

function Entity:render()
    love.graphics.draw(
        textures[self.texture],
        frames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8,
        math.floor(self.y) + 10,
        0,
        self.direction == 'right' and 1 or -1, -- whether or not to flip sprite
        1,
        8,
        10
    )
end
