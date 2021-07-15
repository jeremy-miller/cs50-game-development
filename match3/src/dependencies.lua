-- third party
class = require("lib/class")
push = require("lib/push")
timer = require("lib/timer") -- from knife

-- internal
require("src/board")
require("src/constants")
require("src/statemachine")
require("src/tile")
require("src/util")
require("src/states/basestate")
require("src/states/begingamestate")
require("src/states/gameoverstate")
require("src/states/playstate")
require("src/states/startstate")


sounds = {
    ['music'] = love.audio.newSource('assets/sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('assets/sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('assets/sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('assets/sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('assets/sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('assets/sounds/next-level.wav', 'static')
}

textures = {
    ['main'] = love.graphics.newImage('assets/images/match3.png'),
    ['background'] = love.graphics.newImage('assets/images/background.png')
}

frames = {
    ['tiles'] = GenerateTileQuads(textures['main'])
}

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
}
