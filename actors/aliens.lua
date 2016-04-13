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
			self.x = self.root.x + 8*math.sin(self.timer * math.pi)

			self.y = self.root.y + 4*self.timer

			if self.shots < math.floor(self.timer + 0.5) then
				table.insert(globals.shots, {x = self.x+4, y = self.y + 8})
				self.shots = self.shots + 1
			end

			self.x = math.max(1, math.min(self.x, 55))
			self.y = math.max(1, math.min(self.y, 55))
		end
	},
	{
		name = "HELM",
		life = 1,
		sprite = love.graphics.newQuad(24, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt

			if self.shots < math.floor(self.timer + 0.5) then
				table.insert(globals.shots, {x = self.x + 4, y = self.y + 8,
					target = { x = globals.player.x, y = globals.player.y })
				self.shots = self.shots + 1
			end
		end
	},
	{
		name = "FORE",
		life = 1,
		sprite = love.graphics.newQuad(16, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt

			self.x = self.root.x + 8*math.sin(self.timer * math.pi)
			self.y = self.root.y + 6*math.sin(self.timer * 2*math.pi)

			self.x = math.max(1, math.min(self.x, 55))
			self.y = math.max(1, math.min(self.y, 55))
		end
	}
}

Alien.bosses = {
	moth = {
		life = 10,
		sprite = love.graphics.newQuad(32, 0, 32, 32, 256, 256),
		update = function(self, dt)
			self.timer = self.timer + dt
		end
	}
}

Alien.typeset = {}
for k,v in pairs(Alien.types) do
	print(k)
	table.insert(Alien.typeset, k)
end

function Alien.getRandomType(level)
	return Alien.typeset[math.min(math.ceil(math.sqrt(level)), math.random(#Alien.typeset))]
end

function Alien.new(type, x, y)
	actor = Actor.new(x, y)
	actor.type = type
	actor.sprite = Alien.types[type].sprite
	actor.update = Alien.types[type].update
	
	actor.life = Alien.types[type].life
	actor.shots = 0
	actor.timer = 0

	actor.root = {x = actor.x, y = actor.y}

	table.insert(globals.aliens, actor)
	setmetatable(actor, Alien)

	return actor
end

function Alien:draw()
	Actor.draw(self)
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