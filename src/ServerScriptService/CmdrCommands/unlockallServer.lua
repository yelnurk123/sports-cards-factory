-- unlockallServer (CMDR command implementation for unlockall)

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CardConfig = require(ReplicatedStorage.Shared.CardConfig)
local DataService = require(ServerScriptService.MainServer.DataService)
local PlacementService = require(ServerScriptService.MainServer.PlacementService)

return function(_context, player: Player)
	local data = DataService:GetData(player)
	if not data then
		return ("%s has no loaded data."):format(player.Name)
	end
	local granted = 0
	for cardId in CardConfig.Cards do
		if PlacementService:GrantCard(player, cardId) then
			granted += 1
		end
	end
	data.cash += 10000
	PlacementService:SyncCards(player)
	return ("Granted %d cards + $10,000 to %s."):format(granted, player.Name)
end
