-- Initial menu screen

local _menu = Screen.new()

_menu.options = {
	{text = "START", action = function()
		screen_stack:push(screen_game)
	end },
	{text = "SCALE", action = function()
		if Resolution.scale < Resolution.max_scale then
			Resolution.scale = Resolution.scale + 1
		else
			Resolution.scale = 1
		end
		love.window.setMode(64*Resolution.scale , 64*Resolution.scale)
	end	},
	{text = "MODE", action = function()
		if globals.sprite_mode == 'lo' then
			globals.sprite_mode = 'hi'
		else
			globals.sprite_mode = 'lo'
		end
		love.graphics.setFont(globals.font[globals.sprite_mode])
	end	},
	{text = "QUIT", action = function()
		screen_stack:pop()
	end }
}

function _menu:init()
	self.pointer = 1

	self.color_blink = 0

	love.audio.stop()
	globals.bgm.title:play()
end

function _menu:update(dt)
	self.color_blink = self.color_blink + 4*dt
end

function _menu:keypressed(key)
	if key == "return" or key == " " then
		self.options[self.pointer].action()
	elseif key == "escape" then
		screen_stack:pop()
	elseif key == "down" then
		self.pointer = (self.pointer)%(#self.options) + 1
	elseif key == "up" then
		self.pointer = self.pointer - 1
		if self.pointer <= 0 then self.pointer = #self.options end
	end	
end

function _menu:draw() 
	love.graphics.clear(0,0,0,255)

	love.graphics.printf("FLASH", 1, 1, 40, "center")
	love.graphics.printf("SHMUP", 24, 8, 40, "center")
	
	for i=1,#self.options,1 do
		love.graphics.push()
		love.graphics.translate(0, 16 + i*8)
		if self.pointer == i  and math.abs(math.sin(math.pi * self.color_blink)) > 0.5 then
			love.graphics.setColor(255, 192, 0, 255)
		end
		love.graphics.printf(self.options[i].text, 17, 0, 30, "center")
		love.graphics.pop()
		love.graphics.setColor(255,255,255,255)
	end
end

return _menu