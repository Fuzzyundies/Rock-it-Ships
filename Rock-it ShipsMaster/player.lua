Player = {}
Player.__index = Player

function Player:new()
	local self = setmetatable({},Player)
	return self
end

--Always return class at the end
return Player

--For putting in the game
Player = require "player"

player1 = Player:new()
player2 = Player:new()

--Could do same for asteroids

--Name of folder.name of file