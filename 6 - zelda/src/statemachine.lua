StateMachine = Class{}

function StateMachine:init(states)
	self.states = states -- [name] -> [function that returns states]
	self.current = {
		render = function() end,
		update = function() end,
		processAI = function() end,
		enter = function() end,
		exit = function() end
	}
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end

--[[
	Used for states that can be controlled by the AI to influence update logic. By having this and
	not just bundling the decision-making into :update, we allow ourselves to reuse states between
	the player and agents in our game, rather than create a separate state for each (or at least
	allow the player to use the base state and then call its own inherited version of that state to
	save on code) See how PlayerWalkState calls EntityWalkState.update within :update for an example.
]]
function StateMachine:processAI(params, dt)
	self.current:processAI(params, dt)
end
