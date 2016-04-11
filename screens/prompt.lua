-- Mission prompt screen

_prompt = Screen.new()

prompt_timer = 3

function _prompt:init()
	globals.mission = getRandomMission(globals.level)
	globals.mission.won = false

	self.timer = prompt_timer
end

function _prompt:update(dt)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		screen_stack:pop()
	end
end

function _prompt:draw()
	love.graphics.clear(0,0,0,255)
	love.graphics.printf(string.format("LEVEL %d", globals.level), 8, 4, 48, "center")

	if self.timer * 5 % 2 == 0 then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(255,0,0,255)
	end
	love.graphics.printf(globals.mission.prompt, 8, 16, 48, "center")

	love.graphics.setColor(255,255,0,255)
	love.graphics.printf(math.ceil(self.timer), 8, 48, 48, "center")

	love.graphics.setColor(255,255,255,255)
end

function _prompt:exit()
	screen_stack[#screen_stack]:reset()

	globals.mission.init(globals.level)
end

-- Mission prompts

Missions = {
	{
		prompt = "KILL EM ALL!",
		time = 5,
		init = function(level)
			globals.aliens = {}
			for i = 1,3,1 do
				A = Alien.new(Alien.getRandomType(), 8 + (i-1)*16, 8)
				table.insert(globals.aliens, A)
			end
		end,
		victory = function()
			return #globals.aliens == 0
		end
	}
}

function getRandomMission(level)
	return Missions[math.random(#Missions)]
end

return _prompt
