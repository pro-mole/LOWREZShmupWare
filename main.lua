-- SHMUPWARE
-- A 64x64 Space Invaders/WarioWare mashup
-- A low res misson-centric game of skill and increasing difficulty!

love.graphics.setDefaultFilter("nearest", "nearest", 1)

globals = {
	font = {
		standard = love.graphics.newFont("assets/font/BYond.ttf",8)
	},
	bgm = {
		title = love.audio.newSource("assets/bgm/Murky.wav", "stream"),
		gameplay =  love.audio.newSource("assets/bgm/On Fire.wav", "stream")
	},
	sprite_mode = 'lo',
	spritesheet = {
		lo = love.graphics.newImage("assets/sprite/spritesheet.png"),
		hi = love.graphics.newImage("assets/sprite/spritesheet_hi.png")
	},
	keydown = {}
}

require("actor")
require("screen")
require("mission")

screen_menu = require("screens/menu")
screen_game = require("screens/gameplay")
screen_pause = require("screens/pause")
screen_prompt = require("screens/prompt")

function love.load()
	love.graphics.setFont(globals.font.standard)
	screen_stack:push(screen_menu)
end

function love.keypressed(key, scancode, isrepeat)
	screen_stack[#screen_stack]:keypressed(key)

	if not isrepeat then
		globals.keydown[key] = true
	end
end

function love.keyreleased(key, scancode)
	globals.keydown[key] = false
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