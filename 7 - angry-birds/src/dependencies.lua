Class = require 'lib/class'
Push = require 'lib/push'
Timer = require 'lib/timer'

require 'src/alien'
require 'src/alienlaunchmarker'
require 'src/background'
require 'src/constants'
require 'src/level'
require 'src/obstacle'
require 'src/statemachine'
require 'src/util'

require 'src/states/basestate'
require 'src/states/playstate'
require 'src/states/startstate'

textures = {
    ['blue-desert'] = love.graphics.newImage('assets/graphics/blue_desert.png'),
    ['blue-grass'] = love.graphics.newImage('assets/graphics/blue_grass.png'),
    ['blue-land'] = love.graphics.newImage('assets/graphics/blue_land.png'),
    ['blue-shroom'] = love.graphics.newImage('assets/graphics/blue_shroom.png'),
    ['colored-land'] = love.graphics.newImage('assets/graphics/colored_land.png'),
    ['colored-desert'] = love.graphics.newImage('assets/graphics/colored_desert.png'),
    ['colored-grass'] = love.graphics.newImage('assets/graphics/colored_grass.png'),
    ['colored-shroom'] = love.graphics.newImage('assets/graphics/colored_shroom.png'),

    ['aliens'] = love.graphics.newImage('assets/graphics/aliens.png'),
    ['tiles'] = love.graphics.newImage('assets/graphics/tiles.png'),
    ['wood'] = love.graphics.newImage('assets/graphics/wood.png'),
    ['arrow'] = love.graphics.newImage('assets/graphics/arrow.png')
}

frames = {
    ['aliens'] = GenerateQuads(textures['aliens'], 35, 35),
    ['tiles'] = GenerateQuads(textures['tiles'], 35, 35),
    ['wood'] = {
        love.graphics.newQuad(0, 0, 110, 35, textures['wood']:getDimensions()),
        love.graphics.newQuad(0, 35, 110, 35, textures['wood']:getDimensions()),
        love.graphics.newQuad(320, 180, 35, 110, textures['wood']:getDimensions()),
        love.graphics.newQuad(355, 355, 35, 110, textures['wood']:getDimensions())
    }
}

-- tweak circular alien quad
frames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)

sounds = {
    ['break1'] = love.audio.newSource('assets/sounds/break1.wav', 'static'),
    ['break2'] = love.audio.newSource('assets/sounds/break2.wav', 'static'),
    ['break3'] = love.audio.newSource('assets/sounds/break3.mp3', 'static'),
    ['break4'] = love.audio.newSource('assets/sounds/break4.wav', 'static'),
    ['break5'] = love.audio.newSource('assets/sounds/break5.wav', 'static'),
    ['bounce'] = love.audio.newSource('assets/sounds/bounce.wav', 'static'),
    ['kill'] = love.audio.newSource('assets/sounds/kill.wav', 'static'),
    ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static')
}

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32),
    ['huge'] = love.graphics.newFont('assets/fonts/font.ttf', 64)
}
