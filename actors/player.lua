-- Player actor

Player = {
}

function Player.new(x, y)
	A = Actor.new(x, y, love.graphics.newQuad(0, 0, 8, 8, 256, 256))
	A:addBounds()
	A.shots = {}
	A.alive = true

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
	if self.alive then
		if globals.keydown.right and self.x < 64-9 then
			self.x = self.x + dt * 16
		end

		if globals.keydown.left and self.x > 1 then
			self.x = self.x - dt * 16
		end
	end

	for i,shot in pairs(self.shots) do
		shot.y = shot.y - 128*dt
	end

	for i = #self.shots,1,-1 do
		if self.shots[i].y < 0 or self.shots[i].hit then table.remove(self.shots, i) end
	end
end

function Player:keypressed(key)
	if self.alive and key == "space" then
		table.insert(self.shots, {x = self.x+4, y = self.y-2})
	end
end

function Player:draw()
	Actor.draw(self)

	for i,shot in pairs(self.shots) do
		love.graphics.rectangle("fill", shot.x, shot.y, 1, 1)
	end

	love.graphics.print(string.format("(%d,%d)", globals.player.x, globals.player.y), 0, 0)
end