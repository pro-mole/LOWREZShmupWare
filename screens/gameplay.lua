-- Main game

local _game = Screen.new()

function _game:init()
	globals.level = 1
	globals.mission = {}
	globals.actors = {}

	screen_stack:push(screen_prompt)
end

function _game:reset()
	self.actors = {}

	self.timer = globals.mission.time
	globals.player = Player.new(24, 48)
end

function _game:update(dt)
	if not globals.mission.won and globals.mission.victory() then
		globals.mission.won = true
		self.timer = 1
	end

	globals.player:update(dt)
	for i,alien in ipairs(globals.aliens) do
		if alien.update ~= nil then alien:update(dt) end
	end

	for i = #globals.aliens,1,-1 do
		if not globals.aliens[i].alive then table.remove(globals.aliens, i) end
	end

	self.timer = self.timer - dt
	if self.timer <= 0 then
		if not globals.mission.won then
			screen_stack:pop()
		else
			globals.level = globals.level + 1
			screen_stack:push(screen_prompt)
		end
	end
end

function _game:keypressed(key)
	if key == "escape" then
		screen_stack:push(screen_pause)
	end

	globals.player:keypressed(key)
end

function _game:draw()
	love.graphics.clear(0, 0, 0, 255)

	globals.player:draw()
	for i,alien in ipairs(globals.aliens) do
		alien:draw()
	end

	if not globals.mission.won then
		love.graphics.setColor(128,0,0,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("fill", 1, 64-3, 62 * (self.timer/globals.mission.time), 2)
	else
		love.graphics.setColor(64,255,64,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("OK!", 1, 28, 62, "center")
	end
end

function _game:exit()
	globals.mission = nil
	globals.player = nil
end

return _game