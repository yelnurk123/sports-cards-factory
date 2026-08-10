-- givepackServer (CMDR command implementation for givepack)

local ServerScriptService = game:GetService("ServerScriptService")
local CarryService = require(ServerScriptService.MainServer.CarryService)

return function(_context, player: Player, packId: string)
	local ok, err = CarryService:GivePack(player, packId, "Base")
	if not ok then
		return ("Couldn't give pack: %s"):format(tostring(err))
	end
	return ("Gave %s a carried %s pack (Base foil)."):format(player.Name, packId)
end
