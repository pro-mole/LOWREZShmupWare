-- SHMUPWARE
-- A 64x64 Space Invaders/WarioWare mashup
-- A low res misson-centric game of skill and increasing difficulty!

love.graphics.setDefaultFilter("nearest", "nearest", 1)

globals = {
	font = {
		standard = love.graphics.newFont("assets/font/imagine_font.otf",8)
	}
}

require("screen")

screen_menu = require("screens/menu")
screen_game = require("screens/gameplay")
screen_pause = require("screens/pause")
screen_prompt = require("screens/prompt")

function love.load()
	love.graphics.setFont(globals.font.standard)
	screen_stack:push(screen_menu)
end

function love.update(dt)
	screen_stack:update(dt)
end

function love.draw()
	screen_stack:draw()
end

function love.quit()
	while #screen_stack > 0 do
		screen_stack:pop()
	end
end