-- givepackServer (CMDR command implementation for givepack)

local ServerScriptService = game:GetService("ServerScriptService")
local PlacementService = require(ServerScriptService.MainServer.PlacementService)

return function(_context, player: Player, packId: string)
	local placementId, err = PlacementService:PlacePack(player, packId)
	if not placementId then
		return ("Couldn't give pack: %s"):format(tostring(err))
	end
	return ("Gave %s a %s pack (placement %s)."):format(player.Name, packId, placementId)
end
