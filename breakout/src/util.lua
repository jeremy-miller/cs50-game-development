Util = class{}

--- Given a spritesheet (or "atlas"), as well as a width and height for the titles therein,
-- split the texture into all of the quads by simply dividing it evenly.
-- @param atlas Image: Spritesheet containing sprites.
-- @param tileWidth int: Width of each sprite in atlas.
-- @param tileHeight int: Height of each sprint in atlas.
-- @return table: Table with all sprite quads individually defined from given atlas.
function GenerateQuads(atlas, tileWidth, tileHeight)
    local numTilesWidth = atlas:getWidth() / tileWidth
    local numTilesHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local quads = {}

    for y = 0, numTilesHeight - 1 do
        for x = 0, numTilesWidth - 1 do
            quads[sheetCounter] = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end

--- Implement array slicing since Lua doesn't have it by default.
-- @param tbl table: The table to be sliced.
-- @param first int[opt=1]: Index of first item to slice.
-- @param last int[opt=#tbl]: Index of last item to slice.
-- @param step int[opt=1]: Step value.
-- @return table: Sliced table.
function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

--- Get paddle quads from give spritesheet (or "atlas"). Need special function since the paddle
-- images have varying sizes.
-- @param atlas Image: Spritesheet containing the paddle images.
-- @return table: Table with paddle quads.
function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        -- prepare x and y for next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end
