--!strict
-- PurchaseService — owns every way cash/Robux turns into a thing:
-- 1. MarketplaceService receipts (pipeline reused from World Cup RNG; M1 ships
--    NO real products — every id in MonetizationConfig is 0).
-- 2. PACK ACQUISITION (flow spec v1.1 F1, M1.1): the Spawn Pack kiosk puts ONE
--    pack at the center of the pack belt — the cheapest unbought rung the
--    player can afford — with its FOIL ROLLED AT SPAWN and shown on the label
--    (finish · tier · name · price). Buying it off the belt puts the pack in
--    the player's hand (CarryService); PlacementService takes over at placing.

local MarketplaceService = game:GetService("MarketplaceService")
local Players            = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local MonetizationConfig = require(ReplicatedStorage.Shared.MonetizationConfig)
local Shared = ReplicatedStorage:WaitForChild("Shared")
local PackConfig = require(Shared.PackConfig)
local FoilConfig = require(Shared.FoilConfig)
local EconomyConfig = require(Shared.EconomyConfig)
local DataService        = require(script.Parent.DataService)
local WorldService = require(script.Parent.WorldService)
local CarryService = require(script.Parent.CarryService)
local PlacementService = require(script.Parent.PlacementService)

local PurchaseService = {}

local rng = Random.new()

-- ONE pack on the belt at a time (flow spec F1); owned by whoever spawned it.
-- "Unbought offer passes" — a new spawn replaces it. Conveyor cycling/settings
-- UI is a later milestone.
local beltPack: { model: Part?, owner: Player?, packID: string, foil: string } = nil :: any
local boughtRungs: { [Player]: { [string]: boolean } } = {} -- runtime ladder state
local lastSpawnAt: { [Player]: number } = {}

local PACK_COLORS: { [string]: Color3 } = {
	street = Color3.fromRGB(90, 170, 90),
	sandlot = Color3.fromRGB(195, 165, 110),
	clubhouse = Color3.fromRGB(110, 165, 205),
}

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

--[[ pack belt (flow spec v1.1 F1) ]]--

local function clearBeltPack()
	if beltPack and beltPack.model and beltPack.model.Parent then
		beltPack.model:Destroy()
	end
	beltPack = nil
end

local function buildBeltPack(packID: string, foil: string): Part
	local pack = PackConfig.get(packID)
	local conveyor = WorldService:GetConveyor()
	local center = (conveyor.startPos + conveyor.endPos) / 2

	local model = Instance.new("Part")
	model.Name = "BeltPack"
	model.Size = Vector3.new(2.6, 2.6, 2.6)
	model.Color = PACK_COLORS[packID] or Color3.fromRGB(150, 150, 160)
	model.Material = Enum.Material.SmoothPlastic
	model.Anchored = true
	model.CanCollide = false
	model.CanQuery = true
	model.CFrame = CFrame.new(center)

	-- label stack (flow spec F1.3): finish · tier · name · price — foil shown
	-- BEFORE buy, displayed = rolled
	local bb = Instance.new("BillboardGui")
	bb.Name = "PackBillboard"
	bb.Size = UDim2.fromOffset(300, 96)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.Parent = model
	local stack = Instance.new("TextLabel")
	stack.Name = "Stack"
	stack.Size = UDim2.fromScale(1, 1)
	stack.BackgroundTransparency = 1
	stack.Font = Enum.Font.GothamBold
	stack.TextScaled = true
	stack.TextColor3 = Color3.fromRGB(255, 255, 255)
	stack.TextStrokeTransparency = 0.5
	stack.Text = FoilConfig.get(foil).displayName
		.. "\n" .. PackConfig.band(packID)
		.. "\n" .. pack.displayName
		.. "\n" .. EconomyConfig.formatMoney(pack.price)
	stack.Parent = bb

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "PackInfoPrompt"
	prompt.ActionText = "Odds & Buy"
	prompt.ObjectText = pack.displayName
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt:SetAttribute("Tag", "PackInfo")
	prompt:SetAttribute("PackId", packID)
	prompt:SetAttribute("Foil", foil)
	prompt.Parent = model

	return model
end

-- Kiosk press: spawn ONE pack at the belt's center. Which pack (M1.1 rule):
-- the cheapest unbought rung the player can afford; if every unbought rung is
-- out of reach, the cheapest affordable rung (the belt never dead-ends).
function PurchaseService.SpawnPack(self: any, player: Player)
	local data = DataService:GetData(player)
	if not data then
		return
	end
	local now = os.clock()
	if lastSpawnAt[player] and now - lastSpawnAt[player] < 0.5 then
		return
	end
	lastSpawnAt[player] = now

	local bought = boughtRungs[player] or {}
	boughtRungs[player] = bought
	local choice: string? = nil
	for _, packID in PackConfig.Order do
		if not bought[packID] and data.cash >= PackConfig.get(packID).price then
			choice = packID
			break
		end
	end
	if not choice then
		for _, packID in PackConfig.Order do
			if data.cash >= PackConfig.get(packID).price then
				choice = packID
				break
			end
		end
	end
	if not choice then
		PlacementService:Notify(player, "You need " .. EconomyConfig.formatMoney(PackConfig.get(PackConfig.Order[1]).price) .. " for a pack — sell some cards first!")
		return
	end

	if beltPack and beltPack.owner and beltPack.owner ~= player and beltPack.owner.Parent == Players then
		PlacementService:Notify(beltPack.owner, "Your pack offer on the belt passed.")
	end
	clearBeltPack()

	local foil = FoilConfig.roll(rng) -- foil rolls AT SPAWN (flow spec v1.1 F1.3)
	local model = buildBeltPack(choice, foil)
	model.Parent = workspace
	beltPack = { model = model, owner = player, packID = choice, foil = foil }
	local pack = PackConfig.get(choice)
	PlacementService:Notify(player, pack.displayName .. " (" .. FoilConfig.get(foil).displayName .. ") on the belt — " .. EconomyConfig.formatMoney(pack.price))
end

-- Server-authoritative buy off the belt. The client already saw the odds
-- panel; this validates ownership + cash, deducts, and puts the pack IN HAND.
function PurchaseService.BuyPack(self: any, player: Player)
	if not beltPack or not beltPack.model or not beltPack.model.Parent then
		PlacementService:Notify(player, "No pack on the belt — press the Spawn Pack kiosk first")
		return
	end
	if beltPack.owner ~= player then
		PlacementService:Notify(player, "That pack isn't yours — spawn your own at the kiosk")
		return
	end
	local data = DataService:GetData(player)
	if not data then
		return
	end
	local pack = PackConfig.get(beltPack.packID)
	if data.cash < pack.price then
		PlacementService:Notify(player, "Not enough cash for the " .. pack.displayName .. " (" .. EconomyConfig.formatMoney(pack.price) .. ")")
		return
	end
	local packID, foil = beltPack.packID, beltPack.foil
	local ok, err = CarryService:GivePack(player, packID, foil)
	if not ok then
		PlacementService:Notify(player, err or "Can't carry that pack right now")
		return
	end
	data.cash -= pack.price
	boughtRungs[player][packID] = true
	clearBeltPack()
	DataService:SyncMirror(player)
	PlacementService:Notify(player, pack.displayName .. " in hand — carry it to your plot and place it!")
	print(("[PurchaseService] %s bought %s (%s) for $%d"):format(player.Name, packID, foil, pack.price))
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

	-- pack acquisition remotes + prompts (flow spec v1.1 F1)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
	local buyRemote = Instance.new("RemoteEvent")
	buyRemote.Name = "BuyPack"
	buyRemote.Parent = remotes
	buyRemote.OnServerEvent:Connect(function(player)
		PurchaseService:BuyPack(player)
	end)

	ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
		if prompt:GetAttribute("Tag") == "SpawnPack" then
			PurchaseService:SpawnPack(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		boughtRungs[player] = nil
		lastSpawnAt[player] = nil
		if beltPack and beltPack.owner == player then
			clearBeltPack()
		end
	end)

	print("[PurchaseService] Ready (kiosk spawns one pack, foil rolled at spawn; all SKUs placeholder id 0)")
end

return PurchaseService
