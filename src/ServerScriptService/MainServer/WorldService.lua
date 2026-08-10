--!strict
-- WorldService — builds the M1 blockout map in code (the repo is the source of
-- truth; nothing static lives in Studio). Plaza with the conveyor podium, Sell
-- stall, "Coming Soon" station placeholders (spec §11), how-to signage, and a
-- grid of player plots (display pedestals + pack pedestals + box pad).
-- Owns plot claiming; PlacementService renders packs/cards onto the anchors.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotLayout = require(ReplicatedStorage.Shared.PlotLayout)

local WorldService = {}

local PLOT_COUNT = PlotLayout.PLOT_COUNT
local PLOT_SIZE = PlotLayout.PLOT_SIZE
local DISPLAY_COLS = 5

export type PlotRec = {
	index: number,
	model: Model,
	origin: CFrame,
	displaySlots: { [string]: CFrame }, -- slotKey "1".."10" -> pedestal-top CFrame
	packPedestals: { [number]: CFrame }, -- pedestal index -> pedestal-top CFrame
	placePrompts: { [number]: ProximityPrompt }, -- pedestal index -> "Place Pack" prompt
	laneStart: Vector3, -- token drip: tokens spawn here and ride to the crate
	laneEnd: Vector3, -- ... landing here (crate top)
	cratePart: Part,
	crateFill: Part, -- scales up as the crate accumulates
	crateValueLabel: TextLabel, -- "$X" on the crate
	crateSignLabel: TextLabel, -- "You make: $X/s" sign by the crate
	cratePrompt: ProximityPrompt,
	owner: Player?,
}

local worldFolder: Folder = nil :: any
local plots: { PlotRec } = {}
local plotByPlayer: { [Player]: PlotRec } = {}

local conveyorInfo: { startPos: Vector3, endPos: Vector3, y: number } = nil :: any
local sellZone: Part = nil :: any

--[[ helpers ]]--

local function part(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, anchored: boolean?): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = if anchored == nil then true else anchored
	p.CanCollide = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function billboard(parent: Instance, name: string, text: string, size: Vector2, offsetY: number, textColor: Color3?): BillboardGui
	local bb = Instance.new("BillboardGui")
	bb.Name = name
	bb.Size = UDim2.fromOffset(size.X, size.Y)
	bb.StudsOffset = Vector3.new(0, offsetY, 0)
	bb.AlwaysOnTop = true
	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.5
	label.Parent = bb
	bb.Parent = parent
	return bb
end

--[[ map pieces ]]--

local function buildSpawn()
	-- replace any spawn points from the template baseplate with ours
	for _, inst in workspace:GetDescendants() do
		if inst:IsA("SpawnLocation") then
			inst:Destroy()
		end
	end
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnLocation"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.CFrame = CFrame.new(0, 1.5, -44)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Color = Color3.fromRGB(120, 200, 120)
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.Parent = worldFolder
end

local function buildPlaza()
	-- main plaza pad
	part(worldFolder, "Plaza", Vector3.new(200, 1, 90), CFrame.new(0, 0, -10), Color3.fromRGB(163, 162, 165))

	-- pack belt: the conveyor is a SPAWN MACHINE (flow spec v1.1 F1), not a
	-- vendor shelf — the kiosk spawns ONE pack at the belt's center
	local beltY = 1.25
	part(worldFolder, "ConveyorBelt", Vector3.new(90, 0.5, 6), CFrame.new(0, beltY, -18), Color3.fromRGB(60, 60, 65))
	-- belt end caps
	part(worldFolder, "BeltCapA", Vector3.new(2, 2.5, 6), CFrame.new(-46, beltY + 1, -18), Color3.fromRGB(40, 40, 45))
	part(worldFolder, "BeltCapB", Vector3.new(2, 2.5, 6), CFrame.new(46, beltY + 1, -18), Color3.fromRGB(40, 40, 45))
	conveyorInfo = {
		startPos = Vector3.new(-44, beltY + 2.25, -18),
		endPos = Vector3.new(44, beltY + 2.25, -18),
		y = beltY + 2.25,
	}
	local podium = part(worldFolder, "ConveyorPodium", Vector3.new(16, 1, 4), CFrame.new(0, 1, -11), Color3.fromRGB(90, 90, 100))
	billboard(podium, "Sign", "THE PACK BELT — spawn a pack at the kiosk, buy it off the belt", Vector2.new(420, 40), 3)

	-- Spawn Pack kiosk at the belt head (flow spec F1: face-down "?" pedestal)
	local kiosk = part(worldFolder, "SpawnKiosk", Vector3.new(4, 1, 4), CFrame.new(-54, 1, -18), Color3.fromRGB(90, 90, 100))
	billboard(kiosk, "Sign", "SPAWN PACK\n cheapest pack you can afford", Vector2.new(320, 56), 4.6, Color3.fromRGB(255, 230, 150))
	local faceDown = part(worldFolder, "KioskPack", Vector3.new(2.4, 0.6, 2.4), CFrame.new(-54, 1.9, -18), Color3.fromRGB(35, 35, 45))
	local q = billboard(faceDown, "Q", "?", Vector2.new(120, 120), 2.2)
	local qText = q:FindFirstChild("Text")
	if qText and qText:IsA("TextLabel") then
		qText.TextColor3 = Color3.fromRGB(255, 205, 40)
	end
	local spawnPrompt = Instance.new("ProximityPrompt")
	spawnPrompt.Name = "SpawnPackPrompt"
	spawnPrompt.ActionText = "Spawn Pack"
	spawnPrompt.ObjectText = "Spawn Pack kiosk"
	spawnPrompt.HoldDuration = 0
	spawnPrompt.MaxActivationDistance = 12
	spawnPrompt.RequiresLineOfSight = false
	spawnPrompt:SetAttribute("Tag", "SpawnPack")
	spawnPrompt.Parent = faceDown

	-- Recover Pack affordance (flow spec F1.6): signage only in M1.1 — the R$
	-- product lands with the monetization milestone
	local recover = part(worldFolder, "RecoverPackPad", Vector3.new(4, 0.4, 4), CFrame.new(-60, 1.2, -18), Color3.fromRGB(60, 90, 140))
	billboard(recover, "Sign", "No Pack? Recover Pack ⬡24\n(coming with the shop)", Vector2.new(260, 50), 3, Color3.fromRGB(180, 210, 255))

	-- Sell stall (flow spec v1.1 F4): boxes cash out by WALKING INTO the green
	-- Sell zone (instant 1:1); the Card Hunter dialog sells INVENTORY (cards 50%)
	local stall = Instance.new("Model")
	stall.Name = "SellStall"
	local counter = part(stall, "Counter", Vector3.new(10, 3, 3), CFrame.new(60, 2.5, -24), Color3.fromRGB(139, 105, 70))
	part(stall, "PostL", Vector3.new(1, 7, 1), CFrame.new(55.5, 4.5, -26), Color3.fromRGB(110, 84, 60))
	part(stall, "PostR", Vector3.new(1, 7, 1), CFrame.new(64.5, 4.5, -26), Color3.fromRGB(110, 84, 60))
	part(stall, "Roof", Vector3.new(12, 0.8, 6), CFrame.new(60, 8.4, -25), Color3.fromRGB(178, 60, 60))
	billboard(counter, "Sign", "CARD HUNTER — sells your inventory (cards at 50%)", Vector2.new(380, 36), 3.2, Color3.fromRGB(255, 230, 150))
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SellStallPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = "Card Hunter (sell inventory)"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt:SetAttribute("Tag", "SellStall")
	prompt.Parent = counter
	stall.Parent = worldFolder

	-- the green Sell zone: carry a card box in, it cashes out instantly at 1:1
	sellZone = part(worldFolder, "SellZone", Vector3.new(12, 0.4, 8), CFrame.new(60, 1.2, -17), Color3.fromRGB(60, 200, 90))
	sellZone.Transparency = 0.15
	billboard(sellZone, "Sign", "Sell Card Boxes! Walk in while carrying (1:1)", Vector2.new(400, 36), 2.6, Color3.fromRGB(200, 255, 200))

	-- station placeholders (spec §11: they exist as "Coming Soon" from M1)
	local stations = { "GRADING", "TRAINING", "CRAFT", "BOSS MATCH", "LEGENDS LADDER", "FREE REWARDS" }
	for i, stationName in stations do
		local x = -75 + (i - 1) * 30
		local base = part(worldFolder, "Station_" .. stationName, Vector3.new(10, 4, 6), CFrame.new(x, 2.5, -40), Color3.fromRGB(80, 82, 90))
		billboard(base, "Sign", stationName .. "\nCOMING SOON", Vector2.new(260, 60), 3.4, Color3.fromRGB(200, 200, 210))
	end

	-- how-to signage at spawn
	local sign = part(worldFolder, "HowToSign", Vector3.new(14, 7, 1), CFrame.new(0, 4.5, -34), Color3.fromRGB(45, 48, 60))
	billboard(
		sign,
		"Sign",
		"1. Spawn a pack at the kiosk  →  2. Buy it off the belt  →  3. Carry it to YOUR PLOT and place it  →  4. When READY, press it to open  →  5. Cards drip tokens into your CRATE  →  6. Carry the box into the green SELL ZONE",
		Vector2.new(700, 80),
		4.6,
		Color3.fromRGB(180, 230, 255)
	)
end

local function buildPlot(index: number): PlotRec
	-- 2 rows of 4; plots face -Z toward the plaza
	local center = PlotLayout.center(index)
	local cx, cz = center.Position.X, center.Position.Z
	local model = Instance.new("Model")
	model.Name = "Plot" .. index

	local origin = CFrame.new(cx, 1, cz)
	part(model, "Pad", Vector3.new(PLOT_SIZE, 1, PLOT_SIZE), CFrame.new(cx, 0.5, cz), Color3.fromRGB(200, 200, 205))
	-- border strips so plots read as "yours"
	part(model, "BorderF", Vector3.new(PLOT_SIZE, 0.3, 1), CFrame.new(cx, 1.15, cz - PLOT_SIZE / 2), Color3.fromRGB(255, 205, 40))

	-- display pedestals: 2 rows x 5 cols at the back of the plot
	local displaySlots: { [string]: CFrame } = {}
	local slot = 0
	for r = 0, 1 do
		for c = 0, DISPLAY_COLS - 1 do
			slot += 1
			local px = cx - 16 + c * 8
			local pz = cz + 10 + r * 8
			part(model, "Pedestal" .. slot, Vector3.new(3, 1.2, 3), CFrame.new(px, 1.6, pz), Color3.fromRGB(95, 95, 105))
			-- card stands upright on the pedestal, facing -Z (toward the plot entrance)
			displaySlots[tostring(slot)] = CFrame.new(px, 4.6, pz)
		end
	end

	-- pack pedestals near the front (carried packs are placed here and hatch);
	-- each gets a "Place Pack" prompt (PlacementService validates the carrier)
	local packPedestals: { [number]: CFrame } = {}
	local placePrompts: { [number]: ProximityPrompt } = {}
	for i = 1, 2 do
		local px = cx - 5 + (i - 1) * 10
		local pz = cz - 2
		local pedestal = part(model, "PackPedestal" .. i, Vector3.new(3.5, 1, 3.5), CFrame.new(px, 1.5, pz), Color3.fromRGB(70, 90, 140))
		packPedestals[i] = CFrame.new(px, 3.9, pz)
		local placePrompt = Instance.new("ProximityPrompt")
		placePrompt.Name = "PlacePackPrompt"
		placePrompt.ActionText = "Place Pack"
		placePrompt.ObjectText = "Pack pedestal"
		placePrompt.HoldDuration = 0
		placePrompt.MaxActivationDistance = 10
		placePrompt.RequiresLineOfSight = false
		placePrompt:SetAttribute("Tag", "PlacePack")
		placePrompt:SetAttribute("Pedestal", i)
		placePrompt.Parent = pedestal
		placePrompts[i] = placePrompt
	end

	-- token lane (flow spec v1.1 F3: ONE shared lane per base, separate from the
	-- pack belt) running down the plot's right edge into ONE wooden crate
	local laneX = cx + 19
	part(model, "TokenLane", Vector3.new(3, 0.3, 30), CFrame.new(laneX, 1.15, cz + 2), Color3.fromRGB(170, 50, 50))
	local laneStart = Vector3.new(laneX, 2.4, cz + 16)
	local laneEnd = Vector3.new(laneX, 3.2, cz - 13)

	-- the wooden crate at the lane's end: accumulates Σ tokens since last
	-- collect; the green fill block scales up as it grows
	local cratePart = part(model, "TokenCrate", Vector3.new(3.4, 3, 3.4), CFrame.new(laneX, 2.5, cz - 15), Color3.fromRGB(139, 105, 70))
	cratePart.Material = Enum.Material.Wood
	local crateFill = part(model, "CrateFill", Vector3.new(2.4, 0.2, 2.4), CFrame.new(laneX, 1.2, cz - 15), Color3.fromRGB(255, 205, 40))
	local valueBb = billboard(cratePart, "Value", "$0", Vector2.new(160, 40), 2.6, Color3.fromRGB(180, 255, 140))
	local crateValueLabel = valueBb:FindFirstChild("Text") :: TextLabel
	local cratePrompt = Instance.new("ProximityPrompt")
	cratePrompt.Name = "CollectCratePrompt"
	cratePrompt.ActionText = "Collect"
	cratePrompt.ObjectText = "Card box crate"
	cratePrompt.HoldDuration = 0
	cratePrompt.MaxActivationDistance = 10
	cratePrompt.RequiresLineOfSight = false
	cratePrompt:SetAttribute("Tag", "CollectCrate")
	cratePrompt.Parent = cratePart

	-- "You make: $X/s" sign sits by the crate (flow spec F3.19: rate readout)
	local signPost = part(model, "RateSign", Vector3.new(0.5, 5, 0.5), CFrame.new(laneX - 3.5, 3.5, cz - 15), Color3.fromRGB(90, 90, 100))
	local rateBb = billboard(signPost, "Rate", "You make: $0/s", Vector2.new(240, 40), 3.2, Color3.fromRGB(180, 230, 255))
	local crateSignLabel = rateBb:FindFirstChild("Text") :: TextLabel

	-- owner post
	local post = part(model, "OwnerPost", Vector3.new(0.5, 6, 0.5), CFrame.new(cx - 19, 4, cz - 19), Color3.fromRGB(90, 90, 100))
	local ownerBb = billboard(post, "Owner", "FREE PLOT", Vector2.new(220, 30), 3.6, Color3.fromRGB(255, 255, 180))
	ownerBb.Name = "OwnerLabel"

	model.Parent = worldFolder

	return {
		index = index,
		model = model,
		origin = origin,
		displaySlots = displaySlots,
		packPedestals = packPedestals,
		placePrompts = placePrompts,
		laneStart = laneStart,
		laneEnd = laneEnd,
		cratePart = cratePart,
		crateFill = crateFill,
		crateValueLabel = crateValueLabel,
		crateSignLabel = crateSignLabel,
		cratePrompt = cratePrompt,
		owner = nil,
	}
end

--[[ public API ]]--

function WorldService.GetConveyor(self: any): { startPos: Vector3, endPos: Vector3, y: number }
	return conveyorInfo
end

function WorldService.GetSellZone(self: any): Part
	return sellZone
end

function WorldService.ClaimPlot(self: any, player: Player): PlotRec?
	local existing = plotByPlayer[player]
	if existing then
		return existing
	end
	for _, plot in plots do
		if plot.owner == nil then
			plot.owner = player
			plotByPlayer[player] = plot
			player:SetAttribute("PlotIndex", plot.index) -- client HUD teleport target
			-- prompts only answer the plot owner (server re-validates anyway)
			for _, placePrompt in plot.placePrompts do
				placePrompt:SetAttribute("OwnerUserId", player.UserId)
			end
			plot.cratePrompt:SetAttribute("OwnerUserId", player.UserId)
			-- fresh crate for the new owner (IncomeService owns the value)
			plot.crateValueLabel.Text = "$0"
			plot.crateSignLabel.Text = "You make: $0/s"
			plot.crateFill.Size = Vector3.new(2.4, 0.2, 2.4)
			local crateCF = plot.cratePart.CFrame
			plot.crateFill.CFrame = CFrame.new(crateCF.X, crateCF.Y - 1.5 + 0.2, crateCF.Z)
			local label = plot.model:FindFirstChild("OwnerPost")
			local bb = label and label:FindFirstChild("OwnerLabel")
			local text = bb and bb:FindFirstChild("Text")
			if text and text:IsA("TextLabel") then
				text.Text = player.DisplayName .. "'s plot"
			end
			return plot
		end
	end
	warn("[WorldService] no free plot for", player.Name)
	return nil
end

function WorldService.ReleasePlot(self: any, player: Player)
	local plot = plotByPlayer[player]
	if not plot then
		return
	end
	plotByPlayer[player] = nil
	plot.owner = nil
	player:SetAttribute("PlotIndex", nil)
	for _, placePrompt in plot.placePrompts do
		placePrompt:SetAttribute("OwnerUserId", nil)
	end
	plot.cratePrompt:SetAttribute("OwnerUserId", nil)
	local label = plot.model:FindFirstChild("OwnerPost")
	local bb = label and label:FindFirstChild("OwnerLabel")
	local text = bb and bb:FindFirstChild("Text")
	if text and text:IsA("TextLabel") then
		text.Text = "FREE PLOT"
	end
end

function WorldService.GetPlot(self: any, player: Player): PlotRec?
	return plotByPlayer[player]
end

function WorldService.OnStart(self: any)
	worldFolder = Instance.new("Folder")
	worldFolder.Name = "SCF_World"
	worldFolder.Parent = workspace

	buildSpawn()
	buildPlaza()
	for i = 1, PLOT_COUNT do
		table.insert(plots, buildPlot(i))
	end

	Players.PlayerRemoving:Connect(function(player)
		WorldService:ReleasePlot(player)
	end)

	print(("[WorldService] map built (%d plots)"):format(PLOT_COUNT))
end

return WorldService
