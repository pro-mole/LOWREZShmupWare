-- Game Actor Implementation

Actor = {
	x = 0,
	y = 0,
	sprite = nil,
	bounds = nil,
	hspeed = 0,
	vspeed = 0,
	alive = true,
	bounds = {}
}

Actor.__index = Actor

function Actor.new(x, y, sprite)
	A = {}
	A.x = x or 0
	A.y = y or 0
	A.sprite = sprite
	A.bounds = {}

	setmetatable(A, Actor)

	return A
end

function Actor:draw()
	if self.sprite then
		love.graphics.draw(globals.spritesheet[globals.sprite_mode], self.sprite, self.x, self.y)
	end
end

function Actor:addBounds(x, y, w, h)
	table.insert(self.bounds, {
		x = x or 0,
		y = y or 0,
		w = w or 8,
		h = h or 8})
end

function Actor:checkCollision(x, y)
	collided = false

	for i,box in ipairs(self.bounds) do
		collided = collided or 
			(x >= self.x+box.x and x <= self.x+box.x+box.w and
			y >= self.y+box.y and y <= self.y+box.y+box.h)
	end

	return collided
end

require("actors/player")
require("actors/aliens")