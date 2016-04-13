-- Common enemies

Alien = {
}

Alien.types = {
	{
		name = "MYRM",
		life = 1,
		sprite = love.graphics.newQuad(8, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt
			self.x = self.root.x + 8*math.sin((self.timer + self.phase) * math.pi)

			self.y = self.root.y + 4*self.timer

			if self.shots < math.floor(self.timer - 0.5) then
				table.insert(globals.shots, {x = self.x+4, y = self.y + 8})
				self.shots = self.shots + 1
			end

			self.x = math.max(1, math.min(self.x, 55))
			self.y = math.max(1, math.min(self.y, 55))
		end,
		update_ally = function(self,dt)
			self.timer = self.timer + dt
			self.x = self.root.x + 16*math.sin((self.timer + self.phase) * math.pi)

			self.y = self.root.y + 2*self.timer
		end
	},
	{
		name = "HELM",
		life = 1,
		sprite = love.graphics.newQuad(24, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt

			if self.shots < math.floor(self.timer - 0.5) then
				table.insert(globals.shots, {x = self.x + 4, y = self.y + 8,
					target = { x = globals.player.x, y = globals.player.y+8 }} )
				self.shots = self.shots + 1
			end
		end,
		update_ally = function(self,dt)
			self.timer = self.timer + dt
			self.x = self.root.x + 8 * math.round(2*math.sin((self.timer + self.phase) * math.pi))
		end
	},
	{
		name = "FORE",
		life = 1,
		sprite = love.graphics.newQuad(16, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt

			self.x = self.root.x + 8*math.sin((self.timer + self.phase) * math.pi)
			self.y = self.root.y + 6*math.sin((self.timer + self.phase) * 2*math.pi)

			self.x = math.max(1, math.min(self.x, 55))
			self.y = math.max(1, math.min(self.y, 55))

			if self.shots < math.floor(self.timer - 0.5) then
				table.insert(globals.shots, {x = self.x + 4, y = self.y + 8,
					target = { x = self.x - 4, y = 56 }} )
				table.insert(globals.shots, {x = self.x + 4, y = self.y + 8,
					target = { x = self.x + 12, y = 56 }} )
				self.shots = self.shots + 1
			end
		end,
		update_ally = function(self,dt)
			self.timer = self.timer + dt
			self.x = self.root.x + 16*math.sin((self.timer + self.phase) * math.pi)
			self.y = self.root.y + 8*math.sin((self.timer + self.phase) * math.pi)
		end
	}
}

Alien.bosses = {
	{
		name = 'MOTH',
		life = 10,
		sprite = love.graphics.newQuad(32, 0, 32, 32, 256, 256),
		update = function(self, dt)
			self.timer = self.timer + dt

			self.x = self.root.x + 16*math.sin((self.timer + self.phase) * math.pi/2)
			self.y = self.root.y + 4*math.sin((self.timer + self.phase) * 3*math.pi)

			if self.shots < math.floor(self.timer - 1) then
				table.insert(globals.shots, {x = self.x - 12, y = self.y + 32})
				table.insert(globals.shots, {x = self.x + 12, y = self.y + 32})
				table.insert(globals.shots, {x = self.x, y = self.y + 32})
				self.shots = self.shots + 1
			end
		end
	}
}

function Alien.getRandomType(level)
	return Alien.types[math.min(math.ceil(math.sqrt(level)), math.random(#Alien.types))]
end

function Alien.getBoss(level)
	return Alien.bosses[level/10 % #Alien.bosses]
end

function Alien.new(type, x, y)
	actor = Actor.new(x, y)
	actor.type = type
	actor.sprite = type.sprite
	actor.update = type.update
	
	actor.life = type.life
	actor.shots = 0
	actor.timer = 0
	actor.phase = math.random()

	actor.root = {x = actor.x, y = actor.y}

	table.insert(globals.aliens, actor)
	setmetatable(actor, Alien)

	return actor
end

function Alien:draw()
	if (self.bounty) then love.graphics.setColor(255,0,0,255) end
	if (self.ally) then love.graphics.setColor(255,128,255,255) end

	Actor.draw(self)
	love.graphics.setColor(255,255,255,255)
end

function Alien:__index(index)
	if rawget(self,index) ~= nil then
		return rawget(self,index)
	elseif Alien[index] ~= nil then
		return Alien[index]
	else
		return Actor[index]
	end
end