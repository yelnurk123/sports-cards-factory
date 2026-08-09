--!strict
-- PurchaseService — the single owner of MarketplaceService. Pipeline reused
-- from World Cup RNG (MonetizationConfig owns every id, idToName
-- reverse-dispatch, id 0 = unpublished, idempotent receipts via
-- purchaseHistory). M1 ships NO real products: every id in
-- MonetizationConfig is 0, so no receipt can ever fire; the handlers land
-- with M5's monetization milestone.

local MarketplaceService = game:GetService("MarketplaceService")
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local MonetizationConfig = require(ReplicatedStorage.Shared.MonetizationConfig)
local DataService        = require(script.Parent.DataService)

local PurchaseService = {}

-- name -> function(player, data): boolean (true = granted, false = hold/NotProcessedYet).
-- Empty in M1 — handlers are added as their SKUs publish (M5).
local Handlers: { [string]: (Player, any) -> boolean } = {}

local function processReceipt(receiptInfo: any): Enum.ProductPurchaseDecision
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet -- retry when they're back
	end
	local data = DataService:GetData(player)
	if not data then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	data.purchaseHistory = data.purchaseHistory or {}
	local pid = tostring(receiptInfo.PurchaseId)
	if data.purchaseHistory[pid] then
		return Enum.ProductPurchaseDecision.PurchaseGranted -- already fulfilled
	end

	print("[PurchaseService] receipt: product", receiptInfo.ProductId, "player", receiptInfo.PlayerId)
	local name = MonetizationConfig.idToName(receiptInfo.ProductId)
	local handler = name and Handlers[name]
	if not handler then
		warn("[PurchaseService] no handler for product id", receiptInfo.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Claim the receipt BEFORE running the handler (handlers yield; a retry for
	-- the same PurchaseId during the yield would otherwise double-grant).
	-- Cleared if the grant fails so a genuine retry still works.
	data.purchaseHistory[pid] = true

	local ok, granted = pcall(handler, player, data)
	if not ok then
		data.purchaseHistory[pid] = nil
		warn("[PurchaseService] handler error for", name, granted)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	if not granted then
		data.purchaseHistory[pid] = nil
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Re-applies persisted gamepass flags on join (M1: no passes have effects yet).
local function refreshGamepasses(player: Player, data: any)
	for name, owned in data.passes do
		if owned then
			player:SetAttribute("Owns_" .. name, true)
		end
	end
	for name, id in MonetizationConfig.Gamepasses do
		if id ~= 0 then
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
			end)
			if ok and owns then
				data.passes[name] = true
				player:SetAttribute("Owns_" .. name, true)
			end
		end
	end
end

function PurchaseService.OnStart(self: any)
	MarketplaceService.ProcessReceipt = processReceipt

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, wasPurchased)
		if not wasPurchased then
			return
		end
		local name = MonetizationConfig.gamepassName(passId)
		if not name then
			return
		end
		local data = DataService:GetData(player)
		if data then
			data.passes[name] = true
			player:SetAttribute("Owns_" .. name, true)
		end
	end)

	DataService.ProfileLoaded:Connect(function(player, data)
		task.spawn(refreshGamepasses, player, data)
	end)

	print("[PurchaseService] Ready (all SKUs placeholder id 0 — no live products in M1)")
end

return PurchaseService
