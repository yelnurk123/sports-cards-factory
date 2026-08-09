-- MainClient — client boot. Loader pattern from World Cup RNG: auto-load every
-- *Controller child module, then call OnStart on each.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Loader"))

local controllerModules = Loader.LoadChildren(script, function(moduleScript)
	return moduleScript.Name:match("Controller$") ~= nil
end)

Loader.SpawnAll(controllerModules, "OnStart")
Loader.SpawnAll(controllerModules, "Init")
