-- Screens, as usual

Resolution = {
	x = 64,
	y = 64,
	scale = 8,
	max_scale = 10
}

Screen = {
	width = 64,
	height = 64,
	offx = 0,
	offy = 0
}
Screen.__index = Screen

function Screen.new(width, height)
	scr = {}
	scr = setmetatable(scr, Screen)

	scr.width = width or 64;
	scr.height = height or 64;

	scr.canvas = love.graphics.newCanvas(scr.width, scr.height)
	scr.offx = (Resolution.x - scr.width)/2
	scr.offy = (Resolution.y - scr.height)/2

	return scr
end

function Screen:init()
	-- Called to initialize the screen
end

function Screen:exit()
	-- Called to finalize the screen
end

function Screen:keypressed(key)
	-- Called to deal with keypresses
end

function Screen:update(dt)
	-- Called to update content on the top screen
end

function Screen:draw()
	-- Called to drawn on the screen canvas
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	love.graphics.setCanvas()
end

-- Screen stack implementation

screen_stack = {}

function screen_stack:push(scr)
	table.insert(self, scr)
	scr:init()
end

function screen_stack:pop(reset)
	top_scr = table.remove(self)
	top_scr:exit()
	if #self <= 0 then love.event.quit()
	else
		if reset then self[#self]:init() end
	end
	return top_scr
end

function screen_stack:update(dt)
	top_scr = self[#self]
	top_scr:update(dt)
end

function screen_stack:draw()
	-- Draw screens on top of each other
	top_scr = self[#self]
	love.graphics.setCanvas(top_scr.canvas)
	top_scr:draw()
	love.graphics.setCanvas()

	love.graphics.push()
	love.graphics.scale(Resolution.scale)
	for i,scr in ipairs(self) do
		love.graphics.draw(scr.canvas, scr.offx, scr.offy)
	end
	love.graphics.pop()
end
