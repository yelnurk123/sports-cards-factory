--!strict
-- PromptController — routes proximity-prompt triggers to the right panel.
-- Panel prompts open client-side UI (the server sees them too but ignores
-- anything not tagged for it; OpenPack is handled entirely server-side).

local ProximityPromptService = game:GetService("ProximityPromptService")
local Players = game:GetService("Players")

local PackInfoController = require(script.Parent.PackInfoController)
local SellController = require(script.Parent.SellController)

local PromptController = {}

function PromptController.OnStart(self: any)
	ProximityPromptService.PromptTriggered:Connect(function(prompt, _player)
		local tag = prompt:GetAttribute("Tag")
		if tag == "PackInfo" then
			local packId = prompt:GetAttribute("PackId")
			if type(packId) == "string" then
				local foil = prompt:GetAttribute("Foil")
				PackInfoController:Open(packId, if type(foil) == "string" then foil else nil)
			end
		elseif tag == "SellStall" then
			-- per-base vendors answer only their plot's owner (env v1.1 E1.16a);
			-- the plaza stall has no OwnerUserId and serves everyone (duplicate)
			local ownerId = prompt:GetAttribute("OwnerUserId")
			if type(ownerId) == "number" and ownerId ~= Players.LocalPlayer.UserId then
				local HudController = require(script.Parent.HudController)
				HudController:Toast("That's not your vendor!")
				return
			end
			SellController:Open()
		end
		-- SpawnPack / PlacePack / OpenPack / CarryBox are handled server-side
	end)

	print("[PromptController] Ready")
end

return PromptController
