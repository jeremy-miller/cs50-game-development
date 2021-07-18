-- libraries
Class = require 'assets/lib/class'
Event = require 'assets/lib/event'
Push = require 'assets/lib/push'
Timer = require 'assets/lib/timer'

-- internal
require 'src/animation'
require 'src/constants'
require 'src/entity'
require 'src/entitydefs'
require 'src/gameobject'
require 'src/gameobjects'
require 'src/hitbox'
require 'src/player'
require 'src/statemachine'
require 'src/util'

require 'src/world/doorway'
require 'src/world/dungeon'
require 'src/world/room'

require 'src/states/basestate'
require 'src/states/entity/entityidlestate'
require 'src/states/entity/entitywalkstate'
require 'src/states/entity/player/playeridlestate'
require 'src/states/entity/player/playerswingswordstate'
require 'src/states/entity/player/playerwalkstate'
require 'src/states/game/gameoverstate'
require 'src/states/game/playstate'
require 'src/states/game/startstate'

textures = {
    ['tiles'] = love.graphics.newImage('assets/graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('assets/graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('assets/graphics/character_walk.png'),
    ['character-swing-sword'] = love.graphics.newImage('assets/graphics/character_swing_sword.png'),
    ['hearts'] = love.graphics.newImage('assets/graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('assets/graphics/switches.png'),
    ['entities'] = love.graphics.newImage('assets/graphics/entities.png')
}

frames = {
    ['tiles'] = GenerateQuads(textures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(textures['character-walk'], 16, 32),
    ['character-swing-sword'] = GenerateQuads(textures['character-swing-sword'], 32, 32),
    ['entities'] = GenerateQuads(textures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(textures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(textures['switches'], 16, 18)
}

fronts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('assets/fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('assets/fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('assets/fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('assets/fonts/zelda.otf', 32)
}

sounds = {
    ['music'] = love.audio.newSource('assets/sounds/music.mp3', 'static'),
    ['sword'] = love.audio.newSource('assets/sounds/sword.wav', 'static'),
    ['hit-enemy'] = love.audio.newSource('assets/sounds/hit_enemy.wav', 'static'),
    ['hit-player'] = love.audio.newSource('assets/sounds/hit_player.wav', 'static'),
    ['door'] = love.audio.newSource('assets/sounds/door.wav', 'static')
}
