-- Common enemies

Alien = {
	shots = {}
}

Alien.types = {
	myrm = {
		sprite = love.graphics.newQuad(8, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt
			self.x = self.x + 16*dt * math.sin(self.timer * 2*math.pi)

			self.y = self.y + 8*dt
		end
	},
	fore = {
		sprite = love.graphics.newQuad(16, 0, 8, 8, 256, 256)
	},
	helm = {
		sprite = love.graphics.newQuad(24, 0, 8, 8, 256, 256),
		update = function(self,dt)
			self.timer = self.timer + dt
			
			self.x = self.x + 16*dt * math.sin(self.timer * 2*math.pi)

			self.y = self.y + 8*dt
		end
	}
}

Alien.typeset = {}
for k,v in pairs(Alien.types) do
	table.insert(Alien.typeset, k)
end

function Alien.getRandomType()
	return Alien.typeset[math.random(#Alien.typeset)]
end

function Alien.new(type, x, y)
	actor = Actor.new(x, y)
	actor.type = type
	actor.sprite = Alien.types[type].sprite
	actor.update = Alien.types[type].update
	actor.timer = 0

	setmetatable(actor, Alien)

	return actor
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