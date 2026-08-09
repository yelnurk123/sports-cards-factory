-- MainServer — boot script. Loader pattern from World Cup RNG: auto-load every
-- *Service child module, then call OnStart (and Init) on each. CMDR admin
-- console boots after all services are ready (default-deny, whitelisted).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Loader = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Loader"))

local serviceModules = Loader.LoadChildren(script, function(moduleScript)
	return moduleScript.Name:match("Service$") ~= nil
end)
Loader.SpawnAll(serviceModules, "OnStart")
Loader.SpawnAll(serviceModules, "Init")

-- Initialize CMDR after all services are ready
task.spawn(function()
	local Cmdr = require(ServerScriptService.Packages.Cmdr)
	local AdminConfig = require(ServerScriptService.Configs.AdminConfig)

	Cmdr:RegisterDefaultCommands()

	local commandsFolder = ServerScriptService:WaitForChild("CmdrCommands")
	local success, err = pcall(function()
		Cmdr:RegisterCommandsIn(commandsFolder)
	end)

	if not success then
		warn("[MainServer] Failed to register CMDR custom commands:", err)
		return
	end

	-- Default-deny: only AdminConfig.AdminUserIds may run ANY command (incl. Cmdr
	-- built-ins). Server-authoritative; the client console is open to all but every
	-- command is blocked here for non-admins.
	Cmdr.Registry:RegisterHook("BeforeRun", function(context)
		if not AdminConfig.IsAdmin(context.Executor) then
			return "You do not have permission to run commands."
		end
		return nil
	end)

	print("[MainServer] CMDR initialized. Press F2 or ';' for commands.")
	print("[MainServer] Commands restricted to admins.")
end)
