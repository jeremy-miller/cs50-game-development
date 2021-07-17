function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX

    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1
            for y = (sizeY * (tilesetY - 1)) + 1, (sizeY * (tilesetY - 1)) + 1 + sizeY do
                for x = (sizeX * (tilesetX - 1)) + 1, (sizeX * (tilesetX - 1)) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[(sheetWidth * (y - 1)) + x])
                end
            end
        end
    end

    return tilesets
end
