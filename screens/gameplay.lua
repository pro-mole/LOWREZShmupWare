-- Main game

local _game = Screen.new()
_game.bg_sprite = love.graphics.newQuad(0, 256-64, 64, 64, 256, 256)

function _game:init()
	globals.level = 1
	globals.mission = {}
	globals.aliens = {}

	love.audio.stop()
	globals.bgm.gameplay:play()

	screen_stack:push(screen_prompt)
end

function _game:reset()
	globals.timer = globals.mission.time
	globals.player = Player.new(24, 48)
	globals.shots = {}
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
	end

	for i,shot in ipairs(globals.shots) do
		if not shot.hit then
			if shot.target ~= nil then
				if math.pow(shot.x - shot.target.x, 2) + math.pow(shot.y - shot.target.y, 2) < 1 then shot.hit = true end
				angle = math.atan2(shot.target.y - shot.y, shot.target.x - shot.x)
				shot.x = shot.x + 32*dt*math.cos(angle)
				shot.y = shot.y + 32*dt*math.sin(angle)
			else
				shot.y = shot.y + 32*dt
			end
			if globals.player:checkCollision(shot.x, shot.y) then
				globals.player.alive = false
				shot.hit = true
			end
		end
	end

	for i = #globals.aliens,1,-1 do
		if not globals.aliens[i].alive then table.remove(globals.aliens, i) end
	end

	globals.timer = globals.timer - dt
	if globals.timer <= 0 then
		if globals.mission.win <= 0 then
			screen_stack:pop(true)
		else
			globals.level = globals.level + 1
			screen_stack:push(screen_prompt)
		end

		globals.aliens = {}
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

	love.graphics.draw(globals.spritesheet[globals.sprite_mode], self.bg_sprite, 0, 0)

	globals.player:draw()
	for i,alien in ipairs(globals.aliens) do
		alien:draw()
	end

	for i,shot in pairs(globals.shots) do
		if not shot.hit then love.graphics.rectangle("fill", shot.x, shot.y, 1, 1) end
	end

	if globals.mission.win == 0 then
		love.graphics.setColor(64,64,64,255)
		love.graphics.rectangle("fill", 1, 64-3, 62, 2)
		time_ratio = globals.timer/globals.mission.time
		if time_ratio > 0.5 then
			love.graphics.setColor(255,255,255,255)
		elseif time_ratio > 0.25 then
			love.graphics.setColor(255,192,0,255)
		else
			love.graphics.setColor(255,0,0,255)
		end
		love.graphics.rectangle("fill", 1, 64-3, 62 * time_ratio, 2)
		love.graphics.setColor(255,255,255,255)
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
	globals.aliens = nil
end

return _game