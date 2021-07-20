PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.level = Level()

    sounds['field-music']:setLooping(true)
    sounds['field-music']:play()

    self.dialogueOpened = false
end

function PlayState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then
        -- heal player pokemon
        sounds['heal']:play()
        self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP

        -- show a dialogue for it, allowing us to do so again when closed
        stateStack:push(DialogueState('Your Pokemon has been healed!',

        function()
            self.dialogueOpened = false
        end))
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end