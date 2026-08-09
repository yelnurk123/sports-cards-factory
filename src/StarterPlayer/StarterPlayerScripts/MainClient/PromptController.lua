--!strict
-- PromptController — routes proximity-prompt triggers to the right panel.
-- Panel prompts open client-side UI (the server sees them too but ignores
-- anything not tagged for it; OpenPack is handled entirely server-side).

local ProximityPromptService = game:GetService("ProximityPromptService")

local PackInfoController = require(script.Parent.PackInfoController)
local SellController = require(script.Parent.SellController)

local PromptController = {}

function PromptController.OnStart(self: any)
	ProximityPromptService.Triggered:Connect(function(prompt, _player)
		local tag = prompt:GetAttribute("Tag")
		if tag == "PackInfo" then
			local packId = prompt:GetAttribute("PackId")
			if type(packId) == "string" then
				PackInfoController:Open(packId)
			end
		elseif tag == "SellStall" then
			SellController:Open()
		end
	end)

	print("[PromptController] Ready")
end

return PromptController
