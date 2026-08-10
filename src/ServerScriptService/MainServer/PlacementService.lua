--!strict
-- PlacementService — the pack→card pipeline. Patterns reskinned from World Cup
-- RNG's PlacementService (timestamp openAt hatches that survive rejoin,
-- billboard countdowns, server-authoritative open→roll→grant→reveal,
-- ensureRemote); squad logic (positions, offers, synergy, autoroll) stripped.
-- Canon content: rung timers from economy §3, one card per pack at equal 25%
-- pool weight (hub ruling 2026-08-10), reveal payload reads band by color.

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local PackConfig = require(Shared.PackConfig)
local BandConfig = require(Shared.BandConfig)
local FoilConfig = require(Shared.FoilConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local WorldService = require(script.Parent.WorldService)
local CarryService = require(script.Parent.CarryService)

local PlacementService = {}

local rng = Random.new()

local packModels: { [Player]: { [string]: Part } } = {} -- placementId -> pack model
local cardModels: { [Player]: { [string]: Model } } = {} -- slotKey -> card model
local packPedestalOf: { [Player]: { [string]: number } } = {} -- placementId -> pedestal idx

local PACK_COLORS: { [string]: Color3 } = {
	street = Color3.fromRGB(90, 170, 90),
	sandlot = Color3.fromRGB(195, 165, 110),
	clubhouse = Color3.fromRGB(110, 165, 205),
}

--[[ remotes (World Cup RNG ensureRemote pattern) ]]--

local remotesFolder: Folder = nil :: any
local function ensureRemote(name: string): RemoteEvent
	if not remotesFolder then
		remotesFolder = ReplicatedStorage:FindFirstChild("Remotes") :: Folder
		if not remotesFolder then
			remotesFolder = Instance.new("Folder")
			remotesFolder.Name = "Remotes"
			remotesFolder.Parent = ReplicatedStorage
		end
	end
	local remote = remotesFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotesFolder
	end
	return remote :: RemoteEvent
end

local revealRemote: RemoteEvent = nil :: any
local cardsSyncRemote: RemoteEvent = nil :: any
local notifyRemote: RemoteEvent = nil :: any

--[[ helpers ]]--

local function mmss(seconds: number): string
	seconds = math.max(0, math.floor(seconds + 0.5))
	return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end

local function freeDisplaySlot(data: any): string?
	for i = 1, data.plotSlots do
		local key = tostring(i)
		if data.displayed[key] == nil then
			return key
		end
	end
	return nil
end

local function incomeRate(data: any): number
	local sum = 0
	for _, uid in data.displayed do
		local rec = data.storage[uid]
		if rec then
			sum += rec.valueCache
		end
	end
	return EconomyConfig.incomePerSecond(sum)
end

local function mirrorIncome(player: Player, data: any)
	player:SetAttribute("IncomeRate", incomeRate(data))
end

--[[ card/pack models on the plot ]]--

local function buildCardModel(rec: any): Model
	local card = CardConfig.get(rec.cardID)
	local band = BandConfig.get(card.band)
	local foil = FoilConfig.get(rec.foil)

	local model = Instance.new("Model")
	model.Name = "Card_" .. rec.uid

	local face = Instance.new("Part")
	face.Name = "Face"
	face.Size = Vector3.new(2.4, 3.6, 0.2)
	face.Color = foil.frameColor
	face.Material = Enum.Material.SmoothPlastic
	face.Anchored = true
	face.CanCollide = false
	face.TopSurface = Enum.SurfaceType.Smooth
	face.BottomSurface = Enum.SurfaceType.Smooth
	face.Parent = model

	local gui = Instance.new("SurfaceGui")
	gui.Name = "FaceGui"
	gui.Face = Enum.NormalId.Front
	gui.CanvasSize = Vector2.new(240, 360)
	gui.Parent = face

	local ribbon = Instance.new("Frame")
	ribbon.Name = "Ribbon"
	ribbon.Size = UDim2.new(1, 0, 0, 44)
	ribbon.BackgroundColor3 = band.ribbonColor
	ribbon.BorderSizePixel = 0
	ribbon.Parent = gui
	local ribbonText = Instance.new("TextLabel")
	ribbonText.Size = UDim2.fromScale(1, 1)
	ribbonText.BackgroundTransparency = 1
	ribbonText.Text = string.upper(band.displayName)
	ribbonText.Font = Enum.Font.GothamBold
	ribbonText.TextScaled = true
	ribbonText.TextColor3 = Color3.fromRGB(30, 30, 35)
	ribbonText.Parent = ribbon

	local name = Instance.new("TextLabel")
	name.Name = "CardName"
	name.Position = UDim2.new(0, 8, 0, 130)
	name.Size = UDim2.new(1, -16, 0, 80)
	name.BackgroundTransparency = 1
	name.Text = card.name
	name.Font = Enum.Font.GothamBold
	name.TextScaled = true
	name.TextWrapped = true
	name.TextColor3 = Color3.fromRGB(40, 40, 45)
	name.Parent = gui

	local foot = Instance.new("TextLabel")
	foot.Name = "Foot"
	foot.Position = UDim2.new(0, 8, 1, -70)
	foot.Size = UDim2.new(1, -16, 0, 56)
	foot.BackgroundTransparency = 1
	foot.Text = EconomyConfig.formatMoney(rec.valueCache) .. "/Card · " .. card.sport
	foot.Font = Enum.Font.Gotham
	foot.TextScaled = true
	foot.TextColor3 = Color3.fromRGB(90, 90, 100)
	foot.Parent = gui

	model.PrimaryPart = face
	return model
end

local function renderCard(player: Player, slotKey: string, uid: string)
	local plot = WorldService:GetPlot(player)
	local data = DataService:GetData(player)
	if not plot or not data then
		return
	end
	local rec = data.storage[uid]
	local cf = plot.displaySlots[slotKey]
	if not rec or not cf then
		return
	end
	local models = cardModels[player]
	if models and models[slotKey] then
		models[slotKey]:Destroy()
	end
	local model = buildCardModel(rec)
	model:PivotTo(cf)
	model.Parent = workspace
	cardModels[player] = cardModels[player] or {}
	cardModels[player][slotKey] = model
end

local function clearCardModel(player: Player, slotKey: string)
	local models = cardModels[player]
	if models and models[slotKey] then
		models[slotKey]:Destroy()
		models[slotKey] = nil
	end
end

local function freePackPedestal(player: Player): number?
	local plot = WorldService:GetPlot(player)
	if not plot then
		return nil
	end
	local used = packPedestalOf[player] or {}
	for i = 1, EconomyConfig.PACK_PEDESTALS do
		local taken = false
		for _, idx in used do
			if idx == i then
				taken = true
				break
			end
		end
		if not taken then
			return i
		end
	end
	return nil
end

local function renderPack(player: Player, placementId: string, rec: any)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	-- the pedestal the player placed it on (legacy saves predate rec.pedestal)
	local pedestalIdx = rec.pedestal
	if not pedestalIdx or not plot.packPedestals[pedestalIdx] then
		pedestalIdx = freePackPedestal(player)
	end
	if not pedestalIdx then
		return
	end
	packPedestalOf[player] = packPedestalOf[player] or {}
	packPedestalOf[player][placementId] = pedestalIdx

	local pack = PackConfig.get(rec.packID)
	local foilName = FoilConfig.get(rec.foil or "Base").displayName
	local model = Instance.new("Part")
	model.Name = "Pack_" .. placementId
	model.Size = Vector3.new(2.2, 2.2, 2.2)
	model.Color = PACK_COLORS[rec.packID] or Color3.fromRGB(150, 150, 160)
	model.Material = Enum.Material.SmoothPlastic
	model.Anchored = true
	model.CanCollide = false
	model.CFrame = plot.packPedestals[pedestalIdx]

	local bb = Instance.new("BillboardGui")
	bb.Name = "PackBillboard"
	bb.Size = UDim2.fromOffset(260, 60)
	bb.StudsOffset = Vector3.new(0, 2.6, 0)
	bb.AlwaysOnTop = true
	bb.Parent = model
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.BackgroundTransparency = 1
	-- placed packs keep the spawn-rolled foil on the label (flow spec F2.9)
	title.Text = (if foilName ~= "Base" then foilName .. " " else "") .. pack.displayName
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextStrokeTransparency = 0.5
	title.Parent = bb
	local timer = Instance.new("TextLabel")
	timer.Name = "Timer"
	timer.Position = UDim2.new(0, 0, 0.5, 0)
	timer.Size = UDim2.new(1, 0, 0.5, 0)
	timer.BackgroundTransparency = 1
	timer.Text = "OPENING IN " .. mmss((rec.openAt or 0) - os.time())
	timer.Font = Enum.Font.GothamBold
	timer.TextScaled = true
	timer.TextColor3 = Color3.fromRGB(255, 230, 150)
	timer.TextStrokeTransparency = 0.5
	timer.Parent = bb

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "OpenPackPrompt"
	prompt.ActionText = "Open"
	prompt.ObjectText = pack.displayName
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.Enabled = false
	prompt:SetAttribute("Tag", "OpenPack")
	prompt:SetAttribute("PlacementId", placementId)
	prompt:SetAttribute("OwnerUserId", player.UserId)
	prompt.Parent = model

	model.Parent = workspace
	packModels[player] = packModels[player] or {}
	packModels[player][placementId] = model
end

local function clearPackModel(player: Player, placementId: string)
	local models = packModels[player]
	if models and models[placementId] then
		models[placementId]:Destroy()
		models[placementId] = nil
	end
	if packPedestalOf[player] then
		packPedestalOf[player][placementId] = nil
	end
end

local function renderAll(player: Player, data: any)
	-- packs waiting to open
	for placementId, rec in data.packQueue do
		renderPack(player, placementId, rec)
	end
	-- displayed cards
	for slotKey, uid in data.displayed do
		renderCard(player, slotKey, uid)
	end
end

local function clearAllModels(player: Player)
	if packModels[player] then
		for _, model in packModels[player] do
			model:Destroy()
		end
		packModels[player] = nil
	end
	if cardModels[player] then
		for _, model in cardModels[player] do
			model:Destroy()
		end
		cardModels[player] = nil
	end
	packPedestalOf[player] = nil
end

--[[ client sync ]]--

function PlacementService.SyncCards(self: any, player: Player)
	local data = DataService:GetData(player)
	if not data then
		return
	end
	local storageList = {}
	for uid, rec in data.storage do
		table.insert(storageList, {
			uid = uid,
			cardID = rec.cardID,
			foil = rec.foil,
			level = rec.level,
			value = rec.valueCache,
			displayed = false, -- filled below
		})
	end
	local displayedSlotOf: { [string]: string } = {}
	for slotKey, uid in data.displayed do
		displayedSlotOf[uid] = slotKey
	end
	for _, entry in storageList do
		entry.displayed = displayedSlotOf[entry.uid] ~= nil
	end
	table.sort(storageList, function(a, b)
		return a.value > b.value
	end)
	-- HUD "BEST CARD $X/Card" (flow spec F3.19): rate readout, not a balance
	player:SetAttribute("BestCardValue", if storageList[1] then storageList[1].value else 0)
	local indexList = {}
	for key in data.index do
		table.insert(indexList, key)
	end
	cardsSyncRemote:FireClient(player, { storage = storageList, index = indexList })
	DataService:SyncMirror(player)
	mirrorIncome(player, data)
end

function PlacementService.Notify(self: any, player: Player, text: string)
	notifyRemote:FireClient(player, { text = text })
end

-- Removes a card's plot model (sold/traded away). SellService calls this after
-- mutating data; the card's slot model is named Card_<uid>.
function PlacementService.OnCardRemoved(self: any, player: Player, uid: string)
	local models = cardModels[player]
	if not models then
		return
	end
	for slotKey, model in models do
		if model.Name == "Card_" .. uid then
			model:Destroy()
			models[slotKey] = nil
		end
	end
end

--[[ the pipeline ]]--

-- Grants a card to the player: storage + index + auto-display on a free slot.
-- Returns the new uid. Server-authoritative; used by OpenPack and admin commands.
function PlacementService.GrantCard(self: any, player: Player, cardID: string, foil: string?): string?
	local data = DataService:GetData(player)
	if not data then
		return nil
	end
	local card = CardConfig.get(cardID)
	local foilId = foil or "Base"
	local uid = tostring(data.nextUid)
	data.nextUid += 1
	local rec: DataService.CardRec = {
		uid = uid,
		cardID = cardID,
		foil = foilId,
		level = 1,
		grade = nil,
		trait = nil,
		valueCache = EconomyConfig.cardValue(card.base, foilId, 1, nil, nil),
	}
	data.storage[uid] = rec
	data.index[cardID .. ":" .. foilId] = true
	local slot = freeDisplaySlot(data)
	if slot then
		data.displayed[slot] = uid
		renderCard(player, slot, uid)
	end
	return uid
end

-- Places the pack the player is CARRYING onto the chosen pedestal (flow spec
-- v1.1 F2: carry it over, place it, the hatch timer starts on placement).
-- Returns true or false + reason.
function PlacementService.PlaceCarriedPack(self: any, player: Player, pedestalIdx: number): (boolean, string?)
	local data = DataService:GetData(player)
	if not data then
		return false, "Data not loaded"
	end
	local plot = WorldService:GetPlot(player)
	if not plot then
		return false, "No plot claimed"
	end
	if not plot.packPedestals[pedestalIdx] then
		return false, "No such pedestal"
	end
	for _, idx in (packPedestalOf[player] or {}) do
		if idx == pedestalIdx then
			return false, "That pedestal is taken"
		end
	end
	local queued = 0
	for _ in data.packQueue do
		queued += 1
	end
	if queued >= EconomyConfig.PACK_PEDESTALS then
		return false, "Pack pedestals full — open a pack first"
	end
	local packID, foil = CarryService:PeekPack(player)
	if not packID then
		return false, "You're not carrying a pack — buy one off the belt first"
	end

	CarryService:TakePack(player)
	local pack = PackConfig.get(packID)
	local placementId = tostring(data.nextPlacementId)
	data.nextPlacementId += 1
	data.packQueue[placementId] = {
		packID = packID,
		foil = foil or "Base", -- rolled at pack spawn; the card inherits it
		openAt = os.time() + pack.hatch,
		pedestal = pedestalIdx,
	}
	renderPack(player, placementId, data.packQueue[placementId])
	DataService:SyncMirror(player)
	return true, nil
end

-- Opens a placed pack whose timer has finished: roll one card from the pool
-- (equal 25% each, hub ruling), grant it, fire the reveal ceremony.
function PlacementService.OpenPack(self: any, player: Player, placementId: string): boolean
	local data = DataService:GetData(player)
	if not data then
		return false
	end
	local rec = data.packQueue[placementId]
	if not rec then
		return false
	end
	if os.time() < (rec.openAt or 0) then
		return false
	end

	local pack = PackConfig.get(rec.packID)
	local cardID = PackConfig.rollCard(rec.packID, rng)
	data.packQueue[placementId] = nil
	data.packsOpened += 1
	clearPackModel(player, placementId)

	local uid = PlacementService:GrantCard(player, cardID, rec.foil)
	if not uid then
		return false
	end
	local cardRec = data.storage[uid]
	local card = CardConfig.get(cardID)

	revealRemote:FireClient(player, {
		cardID = cardID,
		name = card.name,
		sport = card.sport,
		band = card.band,
		foil = rec.foil,
		value = cardRec.valueCache,
		packID = rec.packID,
		packName = pack.displayName,
	})
	PlacementService:SyncCards(player)
	print(("[PlacementService] %s opened %s -> %s ($%s)"):format(player.Name, rec.packID, cardID, tostring(cardRec.valueCache)))
	return true
end

--[[ lifecycle ]]--

function PlacementService.OnStart(self: any)
	revealRemote = ensureRemote("CardRevealed")
	cardsSyncRemote = ensureRemote("CardsSync")
	notifyRemote = ensureRemote("Notify")

	-- claim a plot + render persisted packs/cards once data is ready
	DataService.ProfileLoaded:Connect(function(player, data)
		local plot = WorldService:ClaimPlot(player)
		if not plot then
			PlacementService:Notify(player, "All plots are taken in this server — rejoin!")
			return
		end
		renderAll(player, data)
		PlacementService:SyncCards(player)
	end)

	DataService.ProfileReleasing:Connect(function(player)
		clearAllModels(player)
	end)

	-- Open prompts are server-authoritative (ProximityPromptService.PromptTriggered
	-- fires on the server with the triggering player).
	ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
		local tag = prompt:GetAttribute("Tag")
		if tag == "PlacePack" then
			if prompt:GetAttribute("OwnerUserId") ~= player.UserId then
				PlacementService:Notify(player, "That's not your plot!")
				return
			end
			local pedestalIdx = prompt:GetAttribute("Pedestal")
			if type(pedestalIdx) == "number" then
				local ok, err = PlacementService:PlaceCarriedPack(player, pedestalIdx)
				if not ok then
					PlacementService:Notify(player, err or "Can't place that pack here")
				else
					PlacementService:Notify(player, "Pack placed — it's hatching!")
				end
			end
			return
		end
		if tag ~= "OpenPack" then
			return
		end
		if prompt:GetAttribute("OwnerUserId") ~= player.UserId then
			PlacementService:Notify(player, "That's not your pack!")
			return
		end
		local placementId = prompt:GetAttribute("PlacementId")
		if type(placementId) == "string" then
			PlacementService:OpenPack(player, placementId)
		end
	end)

	-- countdown loop (World Cup RNG refreshDisplays idiom): billboard mm:ss,
	-- prompt unlocks at READY. Timestamps are authoritative; this is display only.
	task.spawn(function()
		while true do
			task.wait(0.5)
			for player, models in packModels do
				local data = DataService:GetData(player)
				if not data then
					continue
				end
				for placementId, model in models do
					local rec = data.packQueue[placementId]
					if rec and model.Parent then
						local remaining = (rec.openAt or 0) - os.time()
						local bb = model:FindFirstChild("PackBillboard")
						local label = bb and bb:FindFirstChild("Timer")
						if label and label:IsA("TextLabel") then
							label.Text = remaining > 0 and ("OPENING IN " .. mmss(remaining)) or "READY!"
							label.TextColor3 = remaining > 0 and Color3.fromRGB(255, 230, 150) or Color3.fromRGB(140, 255, 140)
						end
						local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
						if prompt then
							prompt.Enabled = remaining <= 0
						end
					end
				end
			end
		end
	end)

	print("[PlacementService] Ready")
end

return PlacementService
