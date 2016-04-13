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
			self.targets = {}
			print(self.prompt, alienType, alienNumber)
			for i = 1,alienNumber,1 do
				A = Alien.new(alienType, alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(self.targets, A)
			end
		end,
		victory = function(self)
			all_dead = true
			for i,a in ipairs(self.targets) do
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
			self.targets = {}
			for i = 1,alienNumber,1 do
				A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(self.targets, A)
			end
		end,
		victory = function(self)
			all_dead = true
			for i,a in ipairs(self.targets) do
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
			self.targets = {}
			for j = 1,2,1 do
				for i = 1,alienNumber,1 do
					A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4 + (j-1)*12)
				end
			end
		end,
		victory = function(self)
			return globals.timer <= 0.5 and globals.player.alive
		end,
		loss = function(self)
			return not globals.player.alive
		end
	},
	{
		prompt = "KILL THE MARK!",
		time = 6,
		init = function(self,level)
			self.mark = nil
			alienNumber = math.min(1 + math.random(level/2), 4) * 2
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.targets = {}
			for i = 1,alienNumber,1 do
				A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4)
				if (not self.mark and math.random(0, alienNumber-i) == 0) then
					self.mark = A
					self.mark.life = 3
					self.mark.bounty = true
				end
			end
		end,
		victory = function(self)
			return not self.mark.alive
		end,
		loss = function(self)
			return not globals.player.alive
		end
	},
	{
		prompt = "SAVE YOUR ALLY!",
		time = 6,
		init = function(self,level)
			self.ally = nil
			alienNumber = math.min(1 + math.random(level/2), 3) * 2
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.targets = {}
			for i = 1,alienNumber,1 do
				A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(self.targets, A)
			end
			A = Alien.new(Alien.getRandomType(level), 28, 12)
			self.ally = A
			self.ally.ally = true
		end,
		victory = function(self)
			all_dead = true
			for i,a in ipairs(self.targets) do
				if a.alive then all_dead = false end
			end
			return all_dead
		end,
		loss = function(self)
			return not globals.player.alive or not self.ally.alive
		end
	},
	{
		prompt = "PACIFIST MODE!",
		time = 6,
		init = function(self,level)
			self.ally = nil
			alienNumber = math.min(1 + math.random(level/2), 4) * 2
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.targets = {}
			for i = 1,alienNumber,1 do
				A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4)
				table.insert(self.targets, A)
			end
			A = Alien.new(Alien.getRandomType(level), 28, 12)
			self.ally = A
			self.ally.ally = true
		end,
		victory = function(self)
			all_alive = true
			for i,a in ipairs(self.targets) do
				if not a.alive then all_alive = false end
			end
			return all_alive and self.timer <= 0.5
		end,
		loss = function(self)
			all_alive = true
			for i,a in ipairs(self.targets) do
				if not a.alive then all_alive = false end
			end
			return all_alive and not globals.player.alive
		end
	},
	{
		prompt = "PACIFIST MODE!",
		time = 6,
		init = function(self,level)
			self.ally = nil
			alienNumber = math.min(1 + math.random(level/2), 4) * 2
			alienWidth = 64/alienNumber
			globals.aliens = {}
			self.targets = {}
			for j = 1,2,1 do
				for i = 1,alienNumber,1 do
					A = Alien.new(Alien.getRandomType(level), alienWidth/2-4 + (i-1)*alienWidth, 4 + (j-1)*12)
					table.insert(self.targets, A)
				end
			end
			A = Alien.new(Alien.getRandomType(level), 28, 12)
			self.ally = A
			self.ally.ally = true
		end,
		victory = function(self)
			all_alive = true
			for i,a in ipairs(self.targets) do
				if not a.alive then all_alive = false end
			end
			return all_alive and self.timer <= 0.5
		end,
		loss = function(self)
			all_alive = true
			for i,a in ipairs(self.targets) do
				if not a.alive then all_alive = false end
			end
			return all_alive and not globals.player.alive
		end
	}
}

BossMission = {
	prompt = "KILL THE BOSS!",
	time = 20,
	init = function(self, level)
		self.boss = Alien.new(Alien.getBoss(level), 16, 8)
	end,
	victory = function(self)
		return not self.boss.alive
	end,
	loss = function(self)
		return not globals.player.alive
	end
}

function getRandomMission(level)
	if level % 10 == 0 then return BossMission end

	return Missions[math.min(math.random(#Missions), math.ceil(math.sqrt(globals.level)))]
end
