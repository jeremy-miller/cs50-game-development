Brick = class{}

-- colors for particle system
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    self.inPlay = true -- whether or not this brick should be rendered

    -- particle system belonging to the brick, emitted on hit
    self.pSystem = love.graphics.newParticleSystem(textures['particle'], 64)

    -- lasts between 0.5-1 seconds seconds
    self.pSystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward
    self.pSystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform, which is clumpy; numbers
    -- are amount of standard deviation away in X and Y axis
    self.pSystem:setEmissionArea("normal", 10, 10)
end

function Brick:update(dt)
    self.pSystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(
            textures["main"],
            frames["bricks"][1 + ((self.color - 1) * 4) + self.tier],
            self.x,
            self.y
        )
    end
end

function Brick:hit()
    sounds["brick-hit-2"]:stop()
    sounds["brick-hit-2"]:play()

    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.pSystem:setColors(
        -- first color
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        55 * (self.tier + 1) / 255,  -- alpha

        -- second color
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0 -- alpha
    )
    self.pSystem:emit(64)

    -- if we're at a higher tier than the base, we need to go down a tier
    -- if we're already at the lowest tier, else just go down a color
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        -- if we're in the first tier and the base color, remove brick from play
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    if not self.inPlay then
        sounds['brick-hit-1']:stop()
        sounds['brick-hit-1']:play()
    end
end

-- Need a separate render function for our particles so it can be called after all bricks are drawn;
-- otherwise, some bricks would render over other bricks' particles.
function Brick:renderParticles()
    love.graphics.draw(self.pSystem, self.x + 16, self.y + 8)
end
