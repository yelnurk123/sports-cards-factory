--!strict
-- PromptController — routes proximity-prompt triggers to the right panel.
-- Panel prompts open client-side UI (the server sees them too but ignores
-- anything not tagged for it; OpenPack is handled entirely server-side).

local ProximityPromptService = game:GetService("ProximityPromptService")

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
			SellController:Open()
		end
		-- SpawnPack / PlacePack / OpenPack / CollectCrate are handled server-side
	end)

	print("[PromptController] Ready")
end

return PromptController
