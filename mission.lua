-- Mission prompts

Missions = {
	{
		prompt = "KILL EM ALL!",
		time = 6,
		init = function(self,level)
			alienType = Alien.getRandomType(level)
			alienNumber = math.min(1 + math.random(level/2), 4)
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.aliens = {}
			print(self.prompt, alienType, alienNumber)
			for i = 1,alienNumber,1 do
				A = Alien.new(alienType, alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(globals.aliens, A)
				table.insert(self.aliens, A)
			end
		end,
		victory = function(self)
			all_dead = true
			for i,a in ipairs(self.aliens) do
				if a.alive then all_dead = false end
			end
			return all_dead
		end,
		loss = function(self)
			return not globals.player.alive
		end
	},
	{
		prompt = "KILL EM ALL!",
		time = 6,
		init = function(self,level)
			alienNumber = math.min(1 + math.random(level/2), 4)
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.aliens = {}
			for i = 1,alienNumber,1 do
				A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(globals.aliens, A)
				table.insert(self.aliens, A)
			end
		end,
		victory = function(self)
			all_dead = true
			for i,a in ipairs(self.aliens) do
				if a.alive then all_dead = false end
			end
			return all_dead
		end,
		loss = function(self)
			return not globals.player.alive
		end
	},
	{
		prompt = "STAY ALIVE!",
		time = 6,
		init = function(self,level)
			alienNumber = math.min(1 + math.random(level/2), 4) * 2
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.aliens = {}
			for j = 1,2,1 do
				for i = 1,alienNumber,1 do
					A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4 + (j-1)*8)
					table.insert(globals.aliens, A)
					table.insert(self.aliens, A)
				end
			end
		end,
		victory = function(self)
			return globals.timer <= 1 and globals.player.alive
		end,
		loss = function(self)
			return not globals.player.alive
		end
	}
}

function getRandomMission(level)
	return Missions[math.min(math.random(#Missions), math.ceil(globals.level/5))]
end

return _prompt
