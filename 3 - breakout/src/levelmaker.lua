LevelMaker = class{}

-- global patterns for bricks
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- per-row brick patterns
SOLID = 1     -- all colors the same in this row
ALTERNATE = 2 -- alternate colors
SKIP = 3      -- skip every other block
NONE = 4      -- no blocks this row

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)
    numCols = numCols % 0 == 0 and (numCols + 1) or numCols -- ensure odd number of columns

    local highestTier = math.min(3, math.floor(level / 5)) -- highest spawned brick color
    local highestColor = math.min(5, level % 5 + 3) -- highest color of highest tier

    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- whether we want to enable alternating colors for this row
        local alternatePattern = math.random(1, 2) == 1 and true or false

        -- choose two colors to alternate between
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false

        -- used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 and true or false

        -- solid color we'll use if we're not alternating
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            -- if skipping is turned on and we're on a skip iteration...
            if skipPattern and skipFlag then
                -- turn skipping off for the next iteration
                skipFlag = not skipFlag

                -- Lua doesn't have a continue statement, so this is the workaround
                goto continue
            else
                -- flip the flag to true on an iteration we don't use it
                skipFlag = not skipFlag
            end

            b = Brick(
                -- x coordinate
                (x - 1) -- decrement by 1 since tables are 1-indexed but coords are 0-indexed
                * 32 -- multiply by brick width
                + 8 -- screen should have 8 pixels of padding (13 cols + 16 pixels total width)
                + (13 - numCols) * 16, -- left-side padding for when there are less than 13 columns

                -- y coordinate
                y * 16 -- 16 pixels of top padding
            )

            -- if we're alternating, figure out which color/tier we're on
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            -- if not alternating and we made it here, use the solid color/tier
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)

            -- Lua's version of the 'continue' statement
            ::continue::
        end
    end

    -- in the event we didn't generate any bricks, try again
    if #bricks == 0 then
        return LevelMaker.createMap(level)
    else
        return bricks
    end
end
