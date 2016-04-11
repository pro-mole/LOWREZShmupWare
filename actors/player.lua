-- Player actor

Player = {
}

function Player.new(x, y)
	A = Actor.new(x, y, love.graphics.newQuad(0, 0, 8, 8, 256, 256))
	A:addBounds()
	A.shots = {}

	P = setmetatable(A, Player)

	return P
end

function Player:__index(index)
	if rawget(self,index) ~= nil then
		return rawget(self,index)
	elseif Player[index] ~= nil then
		return Player[index]
	else
		return Actor[index]
	end
end

function Player:update(dt)
	if globals.keydown.right and self.x < 64-9 then
		self.x = self.x + dt * 16
	end

	if globals.keydown.left and self.x > 1 then
		self.x = self.x - dt * 16
	end

	for i,shot in pairs(self.shots) do
		shot.y = shot.y - 64*dt
	end

	-- Shot collision check
	for i,shot in ipairs(self.shots) do
		for j,alien in ipairs(globals.aliens) do
			if alien:checkCollision(shot.x, shot.y) then
				alien.alive = false
				shot.hit = true
			end
		end
	end

	for i = #self.shots,1,-1 do
		if self.shots[i].y < 0 or self.shots[i].hit then table.remove(self.shots, i) end
	end
end

function Player:keypressed(key)
	if key == "space" then
		table.insert(self.shots, {x = self.x+4, y = self.y-2})
	end
end

function Player:draw()
	Actor.draw(self)

	for i,shot in pairs(self.shots) do
		love.graphics.rectangle("fill", shot.x, shot.y, 1, 1)
	end
end