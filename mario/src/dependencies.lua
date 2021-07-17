-- libraries
class = require("lib/class")
push = require("lib/push")
timer = require("lib/timer") -- from knife package

-- internal
require("src/constants")
require 'src/statemachine'
require 'src/util'

-- game states
require 'src/states/basestate'
require 'src/states/game/playstate'
require 'src/states/game/startstate'

-- entity states
require 'src/states/entities/player/playerfallingstate'
require 'src/states/entities/player/playeridlestate'
require 'src/states/entities/player/playerjumpstate'
require 'src/states/entities/player/playerwalkingstate'

require 'src/states/entities/snail/snailchasingstate'
require 'src/states/entities/snail/snailidlestate'
require 'src/states/entities/snail/snailmovingstate'

-- general
require 'src/animation'
require 'src/entity'
require 'src/gameobject'
require 'src/gamelevel'
require 'src/levelmaker'
require 'src/player'
require 'src/snail'
require 'src/tile'
require 'src/tilemap'


sounds = {
    ['jump'] = love.audio.newSource('assets/sounds/jump.wav', 'static'),
    ['death'] = love.audio.newSource('assets/sounds/death.wav', 'static'),
    ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static'),
    ['powerup-reveal'] = love.audio.newSource('assets/sounds/powerup-reveal.wav', 'static'),
    ['pickup'] = love.audio.newSource('assets/sounds/pickup.wav', 'static'),
    ['empty-block'] = love.audio.newSource('assets/sounds/empty-block.wav', 'static'),
    ['kill'] = love.audio.newSource('assets/sounds/kill.wav', 'static'),
    ['kill2'] = love.audio.newSource('assets/sounds/kill2.wav', 'static')
}

textures = {
    ['tiles'] = love.graphics.newImage('assets/images/tiles.png'),
    ['toppers'] = love.graphics.newImage('assets/images/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('assets/images/bushes_and_cacti.png'),
    ['jump-blocks'] = love.graphics.newImage('assets/images/jump_blocks.png'),
    ['gems'] = love.graphics.newImage('assets/images/gems.png'),
    ['backgrounds'] = love.graphics.newImage('assets/images/backgrounds.png'),
    ['green-alien'] = love.graphics.newImage('assets/images/green_alien.png'),
    ['creatures'] = love.graphics.newImage('assets/images/creatures.png')
}

frames = {
    ['tiles'] = GenerateQuads(textures['tiles'], TILE_SIZE, TILE_SIZE),

    ['toppers'] = GenerateQuads(textures['toppers'], TILE_SIZE, TILE_SIZE),

    ['bushes'] = GenerateQuads(textures['bushes'], 16, 16),
    ['jump-blocks'] = GenerateQuads(textures['jump-blocks'], 16, 16),
    ['gems'] = GenerateQuads(textures['gems'], 16, 16),
    ['backgrounds'] = GenerateQuads(textures['backgrounds'], 256, 128),
    ['green-alien'] = GenerateQuads(textures['green-alien'], 16, 20),
    ['creatures'] = GenerateQuads(textures['creatures'], 16, 16)
}

frames['tilesets'] = GenerateTileSets(frames['tiles'],
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

frames['toppersets'] = GenerateTileSets(frames['toppers'],
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('assets/fonts/ArcadeAlternate.ttf', 32)
}
