Class = require 'lib/class'
Event = require 'lib/event'
Push = require 'lib/push'
Timer = require 'lib/timer'

require 'src/animation'
require 'src/constants'
require 'src/party'
require 'src/pokemon'
require 'src/pokemondefs'
require 'src/statemachine'
require 'src/util'

require 'src/battle/battlesprite'
require 'src/battle/opponent'

require 'src/entity/entity'
require 'src/entity/entitydefs'
require 'src/entity/npc'
require 'src/entity/player'

require 'src/gui/menu'
require 'src/gui/panel'
require 'src/gui/progressbar'
require 'src/gui/selection'
require 'src/gui/textbox'

require 'src/states/basestate'
require 'src/states/statestack'

require 'src/states/entity/entitybasestate'
require 'src/states/entity/entityidlestate'
require 'src/states/entity/entitywalkstate'
require 'src/states/entity/playeridlestate'
require 'src/states/entity/playerwalkstate'

require 'src/states/game/battlestate'
require 'src/states/game/battlemenustate'
require 'src/states/game/battlemessagestate'
require 'src/states/game/dialoguestate'
require 'src/states/game/fadeinstate'
require 'src/states/game/fadeoutstate'
require 'src/states/game/playstate'
require 'src/states/game/startstate'
require 'src/states/game/taketurnstate'

require 'src/world/level'
require 'src/world/tile'
require 'src/world/tileids'
require 'src/world/tilemap'

textures = {
    ['tiles'] = love.graphics.newImage('assets/graphics/sheet.png'),
    ['entities'] = love.graphics.newImage('assets/graphics/entities.png'),
    ['cursor'] = love.graphics.newImage('assets/graphics/cursor.png'),

    ['aardart-back'] = love.graphics.newImage('assets/graphics/pokemon/aardart-back.png'),
    ['aardart-front'] = love.graphics.newImage('assets/graphics/pokemon/aardart-front.png'),
    ['agnite-back'] = love.graphics.newImage('assets/graphics/pokemon/agnite-back.png'),
    ['agnite-front'] = love.graphics.newImage('assets/graphics/pokemon/agnite-front.png'),
    ['anoleaf-back'] = love.graphics.newImage('assets/graphics/pokemon/anoleaf-back.png'),
    ['anoleaf-front'] = love.graphics.newImage('assets/graphics/pokemon/anoleaf-front.png'),
    ['bamboon-back'] = love.graphics.newImage('assets/graphics/pokemon/bamboon-back.png'),
    ['bamboon-front'] = love.graphics.newImage('assets/graphics/pokemon/bamboon-front.png'),
    ['cardiwing-back'] = love.graphics.newImage('assets/graphics/pokemon/cardiwing-back.png'),
    ['cardiwing-front'] = love.graphics.newImage('assets/graphics/pokemon/cardiwing-front.png'),
}

frames = {
    ['tiles'] = GenerateQuads(textures['tiles'], 16, 16),
    ['entities'] = GenerateQuads(textures['entities'], 16, 16)
}

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
}

sounds = {
    ['field-music'] = love.audio.newSource('assets/sounds/field_music.wav', 'static'),
    ['battle-music'] = love.audio.newSource('assets/sounds/battle_music.mp3', 'static'),
    ['blip'] = love.audio.newSource('assets/sounds/blip.wav', 'static'),
    ['powerup'] = love.audio.newSource('assets/sounds/powerup.wav', 'static'),
    ['hit'] = love.audio.newSource('assets/sounds/hit.wav', 'static'),
    ['run'] = love.audio.newSource('assets/sounds/run.wav', 'static'),
    ['heal'] = love.audio.newSource('assets/sounds/heal.wav', 'static'),
    ['exp'] = love.audio.newSource('assets/sounds/exp.wav', 'static'),
    ['levelup'] = love.audio.newSource('assets/sounds/levelup.wav', 'static'),
    ['victory-music'] = love.audio.newSource('assets/sounds/victory.wav', 'static'),
    ['intro-music'] = love.audio.newSource('assets/sounds/intro.mp3', 'static')
}
