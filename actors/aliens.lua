-- Common enemies

Alien = {
	shots = {}
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

			if #self.shots < math.floor(self.timer + 0.5) then
				table.insert(self.shots, {x = self.x+4, y = self.y + 8})
			end
		end
	},
	{
		name = "HELM",
		life = 1,
		sprite = love.graphics.newQuad(24, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt

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
	return Alien.typeset[math.min(math.ceil(level/4), math.random(#Alien.typeset))]
end

function Alien.new(type, x, y)
	actor = Actor.new(x, y)
	actor.type = type
	actor.sprite = Alien.types[type].sprite
	actor.update = Alien.types[type].update
	
	actor.life = Alien.types[type].life
	actor.shots = {}
	actor.timer = 0

	actor.root = {x = actor.x, y = actor.y}

	setmetatable(actor, Alien)

	return actor
end

function Alien:draw()
	Actor.draw(self)

	for i,shot in pairs(self.shots) do
		if not shot.hit then love.graphics.rectangle("fill", shot.x, shot.y, 1, 1) end
	end
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