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
	boxSpawnPos: Vector3,
	owner: Player?,
}

local worldFolder: Folder = nil :: any
local plots: { PlotRec } = {}
local plotByPlayer: { [Player]: PlotRec } = {}

local conveyorInfo: { startPos: Vector3, endPos: Vector3, y: number } = nil :: any

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

	-- conveyor podium: the belt the packs ride (ConveyorService animates the packs)
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
	billboard(podium, "Sign", "THE CONVEYOR — walk up to a pack to see odds & buy", Vector2.new(420, 40), 3)

	-- Sell stall (canon §2: the Scout buys your cards at 50%)
	local stall = Instance.new("Model")
	stall.Name = "SellStall"
	local counter = part(stall, "Counter", Vector3.new(10, 3, 3), CFrame.new(60, 2.5, -24), Color3.fromRGB(139, 105, 70))
	part(stall, "PostL", Vector3.new(1, 7, 1), CFrame.new(55.5, 4.5, -26), Color3.fromRGB(110, 84, 60))
	part(stall, "PostR", Vector3.new(1, 7, 1), CFrame.new(64.5, 4.5, -26), Color3.fromRGB(110, 84, 60))
	part(stall, "Roof", Vector3.new(12, 0.8, 6), CFrame.new(60, 8.4, -25), Color3.fromRGB(178, 60, 60))
	billboard(counter, "Sign", "SELL STALL — the Scout pays 50% of card value", Vector2.new(380, 36), 3.2, Color3.fromRGB(255, 230, 150))
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SellStallPrompt"
	prompt.ActionText = "Sell cards"
	prompt.ObjectText = "Sell Stall (50%)"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt:SetAttribute("Tag", "SellStall")
	prompt.Parent = counter
	stall.Parent = worldFolder

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
		"1. Buy a pack off the conveyor  →  2. It lands on YOUR PLOT  →  3. Opens on a timer  →  4. Cards drip cash boxes  →  5. Sell cards at the Sell stall (50%)",
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

	-- pack pedestals near the front (bought packs land here and hatch)
	local packPedestals: { [number]: CFrame } = {}
	for i = 1, 2 do
		local px = cx - 5 + (i - 1) * 10
		local pz = cz - 2
		part(model, "PackPedestal" .. i, Vector3.new(3.5, 1, 3.5), CFrame.new(px, 1.5, pz), Color3.fromRGB(70, 90, 140))
		packPedestals[i] = CFrame.new(px, 3.9, pz)
	end

	-- box pad: income boxes pop out at the front edge of the plot
	part(model, "BoxPad", Vector3.new(4, 0.5, 8), CFrame.new(cx, 1.25, cz - 12), Color3.fromRGB(60, 60, 65))

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
		boxSpawnPos = Vector3.new(cx, 2.6, cz - 12),
		owner = nil,
	}
end

--[[ public API ]]--

function WorldService.GetConveyor(self: any): { startPos: Vector3, endPos: Vector3, y: number }
	return conveyorInfo
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
