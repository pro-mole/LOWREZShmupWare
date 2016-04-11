-- Pause menu

local _pause = Screen.new(48, 32)

_pause.quit = false

function _pause:keypressed(key)
	if key == "left"  or key == "right" then
		self.quit = not self.quit
	elseif key == "escape" then
		screen_stack:pop()
	elseif key == "return" then
		screen_stack:pop()
		if self.quit then screen_stack:pop() end
	end
end

function _pause:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill",0,0,48,32)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",1,1,46,30)

	love.graphics.setColor(255,255,255,255)
	--love.graphics.setFont(globals.font.small)
	love.graphics.printf("PAUSE", 2, 2, 44, "center")

	if not self.quit then
		love.graphics.setColor(255,192,0,255)
	else
		love.graphics.setColor(192,192,192,255)
	end
	love.graphics.printf("BACK", 2, 24, 24, "center")

	if not self.quit then
		love.graphics.setColor(192,192,192,255)
	else
		love.graphics.setColor(255,192,0,255)
	end
	love.graphics.printf("QUIT", 26, 24, 22, "center")

	love.graphics.setColor(255,255,255,255)
end

return _pause