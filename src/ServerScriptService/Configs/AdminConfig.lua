-- AdminConfig — CMDR admin whitelist. Studio sessions are always admin (M1
-- playtests run in Studio); add live UserIds before publish.

local AdminConfig = {}

AdminConfig.AdminUserIds = {
	-- add your Roblox UserId here for live admin access
}

function AdminConfig.IsAdmin(player: Player): boolean
	if game:GetService("RunService"):IsStudio() then
		return true
	end
	for _, id in ipairs(AdminConfig.AdminUserIds) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

return AdminConfig
