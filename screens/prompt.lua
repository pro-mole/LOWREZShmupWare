-- Mission prompt screen

_prompt = Screen.new()

prompt_timer = 2

function _prompt:init()
	globals.mission = getRandomMission(globals.level)
	globals.mission.win = 0

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

	if self.timer > 1 then
		love.graphics.setColor(255,255,0,255)
		love.graphics.printf("READY...", 8, 48, 48, "center")
	else
		love.graphics.setColor(0,255,0,255)
		love.graphics.printf("GO!", 8, 48, 48, "center")
	end

	love.graphics.setColor(255,255,255,255)
end

function _prompt:exit()
	screen_stack[#screen_stack]:reset()

	globals.mission:init(globals.level)
end

return _prompt
