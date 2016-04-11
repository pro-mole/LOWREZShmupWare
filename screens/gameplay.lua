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

	globals.timer = globals.mission.time
	globals.player = Player.new(24, 48)
end

function _game:update(dt)
	if globals.mission.win == 0 then
		if globals.mission:victory() then
			globals.mission.win = 1
			globals.timer = 1
		elseif globals.mission:loss() then
			globals.mission.win = -1
			globals.timer = 1
		end
	end

	globals.player:update(dt)
	for i,shot in ipairs(globals.player.shots) do
		for j,alien in ipairs(globals.aliens) do
			if alien:checkCollision(shot.x, shot.y) then
				alien.life = alien.life - 1
				if alien.life <= 0 then
					alien.alive = false
				end
				shot.hit = true
			end
		end
	end

	for i,alien in ipairs(globals.aliens) do
		if alien.update ~= nil then alien:update(dt) end
		if alien.shots ~= nil then
			for i,shot in ipairs(alien.shots) do
				if not shot.hit then
					shot.y = shot.y + 32*dt
					if globals.player:checkCollision(shot.x, shot.y) then
						globals.player.alive = false
						shot.hit = true
					end
				end
			end
		end
	end

	for i = #globals.aliens,1,-1 do
		if not globals.aliens[i].alive then table.remove(globals.aliens, i) end
	end

	globals.timer = globals.timer - dt
	if globals.timer <= 0 then
		if globals.mission.win <= 0 then
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

	if globals.mission.win == 0 then
		love.graphics.setColor(128,0,0,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("fill", 1, 64-3, 62 * (globals.timer/globals.mission.time), 2)
	elseif globals.mission.win > 0 then
		love.graphics.setColor(64,255,64,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("OK!", 1, 28, 62, "center")
	elseif globals.mission.win < 0 then
		love.graphics.setColor(192,32,32,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("OH NO!", 1, 28, 62, "center")
	end
end

function _game:exit()
	globals.mission = nil
	globals.player = nil
end

return _game