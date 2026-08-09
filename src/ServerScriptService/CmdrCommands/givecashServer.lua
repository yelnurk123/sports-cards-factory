-- givecashServer (CMDR command implementation for givecash)

local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ServerScriptService.MainServer.DataService)

return function(_context, player: Player, amount: number)
	local data = DataService:GetData(player)
	if not data then
		return ("%s has no loaded data."):format(player.Name)
	end
	amount = math.floor(amount)
	data.cash += amount
	DataService:SyncMirror(player)
	return ("Gave %s %s (now %s)."):format(player.Name, tostring(amount), tostring(math.floor(data.cash)))
end
