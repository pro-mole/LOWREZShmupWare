-- Initial menu screen

local _menu = Screen.new()

_menu.options = {
	"START",
	"SCALE MODE",
	"QUIT"
}

function _menu:init()
	self.pointer = 0
end

function _menu:update(dt)
end

function _menu:draw() 
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0,0,0,255)

	love.graphics.printf("FLASH SHMUP", 1, 1, 62, "center")
	
	love.graphics.setCanvas()
end

return _menu