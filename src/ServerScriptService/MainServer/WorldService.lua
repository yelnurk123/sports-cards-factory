--!strict
-- WorldService — builds the M1.2 world in code (the repo is the source of
-- truth; nothing static lives in Studio). Environment canon v1 (2026-08-11):
-- one island world; Plaza hub at the center (awning stall row SHOP/SELL/
-- UPGRADE, Sell stall = Card Hunter + green Sell zone, station stubs, board
-- row); a ring of per-player bases outside the arrowed navy road circuit.
-- EVERYTHING IS CONNECTED AND WALKABLE — ground, road, walkways and platforms
-- form one continuous surface (kill-list: the M1.1 floating-platform gap).
-- Owns plot claiming; PlacementService renders packs/cards onto the anchors.
-- Scale is builder's judgment per env v1 E3 (base → Sell walk ≈ 10–15s).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotLayout = require(ReplicatedStorage.Shared.PlotLayout)

local WorldService = {}

local PLOT_COUNT = PlotLayout.PLOT_COUNT

export type LaneRec = {
	index: number,
	pallet: Part, -- box-point pallet the box stack stands on
	stackFolder: Folder, -- IncomeService rebuilds the box stack visuals here
	carryPrompt: ProximityPrompt, -- "Carry" (takes the TOP box, flow v1.2 F3.18)
	valueLabel: TextLabel, -- "n/8 · $X" above the box point
	tokenTarget: Vector3, -- world pos where riding tokens land
}

export type PlotRec = {
	index: number,
	model: Model,
	origin: CFrame, -- platform-top center, -Z faces the Plaza
	spawnLocation: SpawnLocation,
	spawnCFrame: CFrame, -- fresh spawns land here facing the spawn machine
	displaySlots: { [string]: CFrame }, -- slotKey "1".."10" -> pedestal-top CFrame
	displaySlotLane: { [string]: number }, -- slotKey -> lane index (tokens drop here)
	packPedestals: { [number]: CFrame }, -- pedestal index -> pedestal-top CFrame
	placePrompts: { [number]: ProximityPrompt },
	lanes: { LaneRec },
	beltCenter: Vector3, -- where this base's one pack appears on its OWN belt
	spawnPodiumPrompt: ProximityPrompt, -- per-base Spawn Pack podium (owner only)
	rateSignLabel: TextLabel, -- "You make: $X/s" beside the box points
	bestCardLabel: TextLabel, -- BEST CARD board at the back fence
	sellZone: Part, -- the base's own "Sell Card Boxes!" pad (env v1.1 E1.16a)
	sellPrompt: ProximityPrompt, -- the base vendor's Talk prompt (owner only)
	owner: Player?,
}

local worldFolder: Folder = nil :: any
local plots: { PlotRec } = {}
local plotByPlayer: { [Player]: PlotRec } = {}

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

-- World signs are NOT AlwaysOnTop and get a MaxDistance, so far-away signs
-- never pile up at the screen bottom (kill-list: scf-01 tutorial/sign
-- overlap). You read a sign when you're standing at its module.
local function billboard(parent: Instance, name: string, text: string, size: Vector2, offsetY: number, textColor: Color3?, maxDistance: number?): BillboardGui
	local bb = Instance.new("BillboardGui")
	bb.Name = name
	bb.Size = UDim2.fromOffset(size.X, size.Y)
	bb.StudsOffset = Vector3.new(0, offsetY, 0)
	bb.AlwaysOnTop = false
	bb.MaxDistance = maxDistance or 55
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

-- Big readable boards (group/like, BEST CARD) are SurfaceGuis on wooden
-- boards: naturally occluded, readable from the road, no screen-space pile-up.
local function boardLabel(board: Part, name: string, text: string, textColor: Color3?): TextLabel
	local gui = Instance.new("SurfaceGui")
	gui.Name = name
	gui.Face = Enum.NormalId.Front
	gui.Parent = board
	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.5
	label.Parent = gui
	return label
end

-- White chevron ">" marker lying flat on a belt/road, pointing -Z of `cf`.
local function chevron(parent: Instance, name: string, cf: CFrame)
	for _, sign in { -1, 1 } do
		local arm = part(parent, name, Vector3.new(1.8, 0.16, 0.7), cf * CFrame.new(sign * 0.6, 0, 0) * CFrame.Angles(0, sign * math.rad(45), 0), Color3.fromRGB(240, 240, 245))
		arm.CanCollide = false
	end
end

local function makePrompt(parent: Instance, name: string, action: string, object: string, tag: string): ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = name
	prompt.ActionText = action
	prompt.ObjectText = object
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt:SetAttribute("Tag", tag)
	prompt.Parent = parent
	return prompt
end

-- Blocky vendor mannequin (zero custom meshes): the plaza Card Hunter and
-- every base's own Sell vendor share this treatment (env v1.1 E1.16a).
local function mannequin(parent: Instance, name: string, cf: CFrame): Part
	local npc = Instance.new("Model")
	npc.Name = name
	local torso = part(npc, "Torso", Vector3.new(2, 2, 1), cf * CFrame.new(0, 3.9, 0), Color3.fromRGB(80, 60, 120))
	part(npc, "Head", Vector3.new(1.2, 1.2, 1.2), cf * CFrame.new(0, 5.5, 0), Color3.fromRGB(245, 205, 160))
	part(npc, "LegL", Vector3.new(0.9, 1.9, 1), cf * CFrame.new(-0.55, 2, 0), Color3.fromRGB(50, 50, 60))
	part(npc, "LegR", Vector3.new(0.9, 1.9, 1), cf * CFrame.new(0.55, 2, 0), Color3.fromRGB(50, 50, 60))
	part(npc, "ArmL", Vector3.new(0.8, 2, 0.9), cf * CFrame.new(-1.45, 3.9, 0), Color3.fromRGB(245, 205, 160))
	part(npc, "ArmR", Vector3.new(0.8, 2, 0.9), cf * CFrame.new(1.45, 3.9, 0), Color3.fromRGB(245, 205, 160))
	npc.Parent = parent
	return torso
end

--[[ island ground + road circuit ]]--

local function buildGround()
	-- bright green world ground (env v1 E4); everything else stands on it
	local ground = part(worldFolder, "Ground", Vector3.new(700, 1, 700), CFrame.new(0, 0, 0), Color3.fromRGB(91, 174, 84))
	ground.Material = Enum.Material.Grass

	-- a few cheap dressing trees on the lawn (env v1 E4: blockout+ dressing)
	local treeSpots = {
		Vector3.new(-120, 0, -120), Vector3.new(120, 0, -120), Vector3.new(-120, 0, 120), Vector3.new(120, 0, 120),
		Vector3.new(0, 0, -115), Vector3.new(0, 0, 115), Vector3.new(-115, 0, 0), Vector3.new(115, 0, 0),
	}
	for i, pos in treeSpots do
		local trunk = part(worldFolder, "TreeTrunk" .. i, Vector3.new(1.6, 6, 1.6), CFrame.new(pos + Vector3.new(0, 3, 0)), Color3.fromRGB(120, 88, 60))
		trunk.Material = Enum.Material.Wood
		local leaves = part(worldFolder, "TreeLeaves" .. i, Vector3.new(7, 6, 7), CFrame.new(pos + Vector3.new(0, 8, 0)), Color3.fromRGB(70, 150, 70))
		leaves.Shape = Enum.PartType.Ball
	end
end

local function buildRoad()
	-- single arrowed road circuit (env v1 E0.2): navy strip, white chevrons,
	-- low brick guard walls on the outer edge (with gaps at each base walkway)
	local roadFolder = Instance.new("Folder")
	roadFolder.Name = "Road"
	local half = PlotLayout.ROAD_HALF
	local width = PlotLayout.ROAD_WIDTH
	local navy = Color3.fromRGB(35, 45, 80)
	local stripLen = half * 2 + width

	-- strips (N/S run along X, E/W along Z); travel runs clockwise from above
	local strips = {
		{ cf = CFrame.new(0, 0.75, -half), size = Vector3.new(stripLen, 0.5, width), dir = Vector3.new(1, 0, 0) }, -- N, travel +X
		{ cf = CFrame.new(half, 0.75, 0), size = Vector3.new(width, 0.5, stripLen), dir = Vector3.new(0, 0, 1) }, -- E, travel +Z
		{ cf = CFrame.new(0, 0.75, half), size = Vector3.new(stripLen, 0.5, width), dir = Vector3.new(-1, 0, 0) }, -- S, travel -X
		{ cf = CFrame.new(-half, 0.75, 0), size = Vector3.new(width, 0.5, stripLen), dir = Vector3.new(0, 0, -1) }, -- W, travel -Z
	}
	for i, strip in strips do
		part(roadFolder, "Strip" .. i, strip.size, strip.cf, navy)
		-- chevrons every 14 studs along the strip's travel direction
		local along = stripLen / 2 - 8
		for d = -along, along, 14 do
			local pos = strip.cf.Position + strip.dir * d
			local face = CFrame.lookAt(pos + Vector3.new(0, 1.08 - pos.Y, 0), pos + Vector3.new(0, 1.08 - pos.Y, 0) + strip.dir)
			chevron(roadFolder, "Arrow", face)
		end
	end

	-- guard walls on the outer edge, broken where base walkways meet the road
	local wallY = 2
	local wallOffset = half + width / 2 + 0.5
	for side = 0, 3 do
		local horizontal = side % 2 == 0 -- N/S sides run along X
		local sign = if side < 2 then -1 else 1
		local segments = { { -half - 5, -104 }, { -76, 76 }, { 104, half + 5 } }
		for si, seg in segments do
			local len = seg[2] - seg[1]
			if len > 2 then
				local mid = (seg[1] + seg[2]) / 2
				local cf: CFrame
				local size: Vector3
				if horizontal then
					cf = CFrame.new(mid, wallY, sign * wallOffset)
					size = Vector3.new(len, 3, 1)
				else
					cf = CFrame.new(sign * wallOffset, wallY, mid)
					size = Vector3.new(1, 3, len)
				end
				local wall = part(roadFolder, ("Guard%d_%d"):format(side, si), size, cf, Color3.fromRGB(139, 105, 70))
				wall.Material = Enum.Material.Brick
			end
		end
	end
	roadFolder.Parent = worldFolder
end

--[[ Plaza hub (env v1 E2) ]]--

local function buildStall(parent: Instance, name: string, x: number, z: number, awningA: Color3, awningB: Color3, signText: string): Part
	local stall = Instance.new("Model")
	stall.Name = name
	local counter = part(stall, "Counter", Vector3.new(10, 3, 3), CFrame.new(x, 2.5, z), Color3.fromRGB(139, 105, 70))
	counter.Material = Enum.Material.Wood
	part(stall, "PostL", Vector3.new(1, 7, 1), CFrame.new(x - 4.5, 4.5, z + 2), Color3.fromRGB(110, 84, 60))
	part(stall, "PostR", Vector3.new(1, 7, 1), CFrame.new(x + 4.5, 4.5, z + 2), Color3.fromRGB(110, 84, 60))
	-- striped awning (env v1 E2.18)
	for i = 0, 4 do
		part(stall, "Awning" .. i, Vector3.new(2.4, 0.6, 7), CFrame.new(x - 4.8 + i * 2.4, 8.3, z + 1.5), if i % 2 == 0 then awningA else awningB)
	end
	billboard(counter, "Sign", signText, Vector2.new(380, 36), 3.2, Color3.fromRGB(255, 230, 150), 50)
	stall.Parent = parent
	return counter
end

local function buildPlaza()
	-- light-gray stud plaza pad (env v1 E4), flush with the road (top Y=1)
	local pad = part(worldFolder, "Plaza", Vector3.new(130, 1, 130), CFrame.new(0, 0.5, 0), Color3.fromRGB(200, 200, 205))
	pad.TopSurface = Enum.SurfaceType.Studs

	-- neutral spawn at the plaza heart (bases take over via RespawnLocation)
	for _, inst in workspace:GetDescendants() do
		if inst:IsA("SpawnLocation") then
			inst:Destroy()
		end
	end
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnLocation"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.CFrame = CFrame.new(0, 1.5, 0)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Color = Color3.fromRGB(120, 200, 120)
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.Parent = worldFolder

	-- ONE how-to sign at spawn (kill-list: M1.1's overlapping banner pile)
	local sign = part(worldFolder, "HowToSign", Vector3.new(14, 7, 1), CFrame.new(0, 5.5, -9) * CFrame.Angles(0, math.pi, 0), Color3.fromRGB(45, 48, 60))
	billboard(
		sign,
		"Sign",
		"1. Spawn a pack at YOUR BASE's podium  →  2. Buy it off YOUR belt  →  3. Carry it to your plot and place it  →  4. When READY, press it to open  →  5. Cards drip tokens into your lane boxes  →  6. Carry boxes into the green SELL ZONE",
		Vector2.new(700, 80),
		4.6,
		Color3.fromRGB(180, 230, 255),
		60
	)

	-- awning stall row along the plaza's south edge (env v1 E2.18)
	buildStall(worldFolder, "ShopStall", -18, 52, Color3.fromRGB(178, 60, 60), Color3.fromRGB(240, 240, 240), "SHOP\n(coming with the shop milestone)")
	local sellCounter = buildStall(worldFolder, "SellStall", 0, 52, Color3.fromRGB(60, 160, 90), Color3.fromRGB(240, 240, 240), "CARD HUNTER — sells your inventory (cards at 50%)")
	buildStall(worldFolder, "UpgradeStall", 18, 52, Color3.fromRGB(70, 110, 190), Color3.fromRGB(240, 240, 240), "UPGRADE\n(coming with the upgrade milestone)")

	-- Card Hunter NPC behind the Sell counter (blocky mannequin; the prompt
	-- lives on the counter — flow spec F4's 5-option dialog is unchanged).
	-- The plaza stall is a DUPLICATE convenience (env v1.1 E2.19): the
	-- canonical sell point is each base's own vendor (E1.16a).
	local npc = Instance.new("Model")
	npc.Name = "CardHunter"
	local npcTorso = mannequin(npc, "Body", CFrame.new(0, 1, 49.5))
	billboard(npc, "Name", "Card Hunter", Vector2.new(160, 30), 8.2, Color3.fromRGB(255, 230, 150), 40)
	npc.Parent = worldFolder

	local sellPrompt = makePrompt(sellCounter, "SellStallPrompt", "Talk", "Card Hunter (sell inventory)", "SellStall")
	sellPrompt.MaxActivationDistance = 12

	-- the green Sell zone: carry a card box in, it cashes out instantly at 1:1
	sellZone = part(worldFolder, "SellZone", Vector3.new(12, 0.4, 8), CFrame.new(0, 1.2, 58), Color3.fromRGB(60, 200, 90))
	sellZone.Transparency = 0.15
	billboard(sellZone, "Sign", "Sell Card Boxes! Walk in while carrying (1:1)", Vector2.new(400, 36), 2.6, Color3.fromRGB(200, 255, 200), 50)

	-- station stubs ring around the center (env v1 E2.20): named pad + sign,
	-- no function — the world grows into them
	local stations = {
		{ name = "Card Craft", color = Color3.fromRGB(139, 105, 70) },
		{ name = "Traits Roll", color = Color3.fromRGB(150, 90, 200) },
		{ name = "Card Ranking", color = Color3.fromRGB(220, 180, 60) },
		{ name = "Free Rewards", color = Color3.fromRGB(90, 200, 120) },
		{ name = "Boss Raid", color = Color3.fromRGB(190, 60, 60) },
		{ name = "Infinity Tower", color = Color3.fromRGB(120, 125, 140) },
	}
	for i, station in stations do
		local angle = math.rad((i - 1) * 60)
		local sx = math.cos(angle) * 34
		local sz = math.sin(angle) * 34
		local padPart = part(worldFolder, "Station_" .. station.name:gsub(" ", ""), Vector3.new(8, 0.4, 8), CFrame.new(sx, 1.2, sz), station.color)
		if station.name == "Boss Raid" then
			-- portal stub: two posts + a top bar
			part(worldFolder, "PortalPostL", Vector3.new(1, 8, 1), CFrame.new(sx - 2.5, 5, sz), Color3.fromRGB(60, 30, 30))
			part(worldFolder, "PortalPostR", Vector3.new(1, 8, 1), CFrame.new(sx + 2.5, 5, sz), Color3.fromRGB(60, 30, 30))
			part(worldFolder, "PortalTop", Vector3.new(6, 1, 1), CFrame.new(sx, 9, sz), Color3.fromRGB(60, 30, 30))
		elseif station.name == "Infinity Tower" then
			part(worldFolder, "TowerStub", Vector3.new(4, 12, 4), CFrame.new(sx, 7, sz), Color3.fromRGB(120, 125, 140))
		elseif station.name == "Free Rewards" then
			part(worldFolder, "GiftBox", Vector3.new(2.6, 2.6, 2.6), CFrame.new(sx, 2.9, sz), Color3.fromRGB(220, 60, 80))
		end
		billboard(padPart, "Sign", station.name .. "\nCOMING SOON", Vector2.new(260, 60), 4.2, Color3.fromRGB(220, 220, 230), 45)
	end

	-- board row along the plaza's north edge (env v1 E2.21): leaderboards,
	-- like-goal board, limited-stock podium row — stubs
	local boards = {
		{ x = -14, title = "TOP CASH\nLEADERBOARD — COMING SOON" },
		{ x = 0, title = "TOP CARDS\nLEADERBOARD — COMING SOON" },
		{ x = 14, title = "LIKE GOAL\n0/100K — COMING SOON" },
	}
	for i, b in boards do
		part(worldFolder, "BoardPost" .. i, Vector3.new(0.6, 6, 0.6), CFrame.new(b.x, 4, -58), Color3.fromRGB(110, 84, 60))
		local board = part(worldFolder, "Board" .. i, Vector3.new(10, 5, 0.6), CFrame.new(b.x, 8, -58), Color3.fromRGB(139, 105, 70))
		board.Material = Enum.Material.Wood
		boardLabel(board, "BoardGui", b.title, Color3.fromRGB(255, 240, 200))
	end
	for i = 0, 2 do
		local podium = part(worldFolder, "LimitedPodium" .. i, Vector3.new(2.5, 2, 2.5), CFrame.new(24 + i * 5, 2, -56), Color3.fromRGB(70, 70, 85))
		billboard(podium, "Sign", "LIMITED STOCK\nCOMING SOON", Vector2.new(200, 50), 3, Color3.fromRGB(255, 200, 200), 40)
	end
end

--[[ per-player base (env v1 E1: EVERYTHING in here is per base) ]]--

-- 10 display pedestals interleaved with 2 token lanes (env v1 E1.11): each
-- lane is flanked by two pedestal columns; every pedestal touches one lane.
local PEDESTALS = {
	-- { x, z, lane } — lane1 = x -8, lane2 = x +10
	{ -14, 14, 1 }, { -14, 6, 1 }, { -14, -2, 1 }, -- lane1 left column (3)
	{ -2, 14, 1 }, { -2, 6, 1 }, --                 lane1 right column (2)
	{ 4, 14, 2 }, { 4, 6, 2 }, { 4, -2, 2 }, --     lane2 left column (3)
	{ 16, 14, 2 }, { 16, 6, 2 }, --                 lane2 right column (2)
}
local LANE_X = { -8, 10 }

local function buildBase(index: number): PlotRec
	local origin = PlotLayout.baseFrame(index)
	local model = Instance.new("Model")
	model.Name = "Base" .. index
	local function L(x: number, y: number, z: number): CFrame
		return origin * CFrame.new(x, y, z)
	end

	-- platform: light-stud, raised one step above the road (top Y=2), yellow
	-- trim on the front edge, red walkway strip to the road (env v1 E1)
	local pad = part(model, "Pad", Vector3.new(48, 1.5, 48), L(0, -0.75, 0), Color3.fromRGB(200, 200, 205))
	pad.TopSurface = Enum.SurfaceType.Studs
	part(model, "Trim", Vector3.new(48, 0.35, 1.2), L(0, 0.18, -23.5), Color3.fromRGB(255, 205, 40))
	-- red walkway flush with the pad, then a ramp down to the road (NO GAPS)
	local walkway = part(model, "Walkway", Vector3.new(10, 0.4, 11), L(0, -0.2, -29.5), Color3.fromRGB(200, 60, 50))
	walkway.TopSurface = Enum.SurfaceType.Studs
	local ramp = part(model, "Ramp", Vector3.new(10, 0.2, 3.2), L(0, -0.42, -36.5) * CFrame.Angles(math.rad(-18.4), 0, 0), Color3.fromRGB(200, 60, 50))
	ramp.CanCollide = true

	-- wooden fence along the back and sides (env v1 E1)
	local fenceColor = Color3.fromRGB(139, 105, 70)
	for x = -24, 24, 6 do
		local post = part(model, "FencePostB", Vector3.new(0.6, 3, 0.6), L(x, 1.5, 24), fenceColor)
		post.Material = Enum.Material.Wood
	end
	for _, fy in { 1.2, 2.4 } do
		local rail = part(model, "FenceRailB", Vector3.new(48.6, 0.4, 0.4), L(0, fy, 24), fenceColor)
		rail.Material = Enum.Material.Wood
		for _, sx in { -24, 24 } do
			local side = part(model, "FenceRailS", Vector3.new(0.4, 0.4, 48.6), L(sx, fy, 0), fenceColor)
			side.Material = Enum.Material.Wood
		end
	end
	for _, sx in { -24, 24 } do
		for z = -21, 24, 6 do
			local post = part(model, "FencePostS", Vector3.new(0.6, 3, 0.6), L(sx, 1.5, z), fenceColor)
			post.Material = Enum.Material.Wood
		end
	end

	-- Zone A: brick spawn structure with dark doorway (env v1 E1.5)
	local structure = part(model, "SpawnStructure", Vector3.new(16, 10, 6), L(-14, 5, -10), Color3.fromRGB(146, 96, 76))
	structure.Material = Enum.Material.Brick
	part(model, "Doorway", Vector3.new(4, 5, 0.6), L(-14, 2.5, -13.3), Color3.fromRGB(25, 25, 30))
	-- group/like billboard mounted on the structure (env v1 E1.10)
	local groupBoard = part(model, "GroupBoard", Vector3.new(12, 5, 0.5), L(-14, 7.5, -13.6), Color3.fromRGB(139, 105, 70))
	groupBoard.Material = Enum.Material.Wood
	boardLabel(groupBoard, "GroupGui", "JOIN THE GROUP FOR 1.25X CASH!\nLIKE THE GAME FOR BIG UPDATE — 65.3K/100K", Color3.fromRGB(255, 240, 180))

	-- per-base pack belt (flow v1.2 F1.1): emerges from the doorway, runs a
	-- short straight segment to the buy window at its end
	local belt = part(model, "PackBelt", Vector3.new(4, 0.4, 8), L(-14, 0.4, -18), Color3.fromRGB(35, 45, 80))
	belt.CanCollide = false
	chevron(model, "BeltArrow", L(-14, 0.7, -16))
	chevron(model, "BeltArrow", L(-14, 0.7, -20))
	local windowFrame = part(model, "BuyWindow", Vector3.new(5, 3.5, 1.2), L(-14, 1.75, -22.6), Color3.fromRGB(60, 60, 70))
	part(model, "BuyWindowGlass", Vector3.new(3.6, 2, 0.4), L(-14, 1.9, -23.2), Color3.fromRGB(20, 20, 28))
	local beltCenter = L(-14, 2.3, -18).Position

	-- Spawn Pack podium beside the doorway (env v1 E1.6): the spawn button
	local podium = part(model, "SpawnPodium", Vector3.new(2, 1.4, 2), L(-4.5, 0.7, -11), Color3.fromRGB(45, 45, 55))
	part(model, "SpawnPodiumTop", Vector3.new(2.2, 0.25, 2.2), L(-4.5, 1.52, -11), Color3.fromRGB(60, 200, 90))
	local faceDown = part(model, "PodiumPack", Vector3.new(1.4, 0.5, 1.4), L(-4.5, 1.95, -11), Color3.fromRGB(35, 35, 45))
	local q = billboard(faceDown, "Q", "?", Vector2.new(120, 120), 2.2, Color3.fromRGB(255, 205, 40), 40)
	local spawnPodiumPrompt = makePrompt(faceDown, "SpawnPackPrompt", "Spawn Pack", "Spawn Pack podium", "SpawnPack")
	billboard(podium, "Sign", "SPAWN PACK\non YOUR belt", Vector2.new(260, 50), 3.4, Color3.fromRGB(255, 230, 150), 40)

	-- No Pack / Recover Pack ⬡24 green pad (env v1 E1.7; pad + label only)
	local recover = part(model, "RecoverPackPad", Vector3.new(4, 0.3, 4), L(-4, 0.15, -16.5), Color3.fromRGB(60, 200, 90))
	billboard(recover, "Sign", "No Pack? Recover Pack ⬡24\n(coming with the shop)", Vector2.new(260, 50), 3, Color3.fromRGB(200, 255, 200), 40)

	-- Conveyor Settings mini-stall (env v1 E1.8; sign + pad only)
	local stallCounter = part(model, "ConveyorSettings", Vector3.new(4, 2, 2), L(-19.5, 1, -21.5), Color3.fromRGB(110, 84, 60))
	stallCounter.Material = Enum.Material.Wood
	part(model, "ConveyorSettingsPad", Vector3.new(3, 0.3, 3), L(-19.5, 0.15, -18.5), Color3.fromRGB(120, 125, 140))
	billboard(stallCounter, "Sign", "Conveyor Settings\n(coming)", Vector2.new(240, 44), 2.8, Color3.fromRGB(220, 220, 230), 40)

	-- "More luck! Upgrade Conveyor" cyan pad (env v1 E1.9; pad + label only)
	local luckPad = part(model, "UpgradeConveyorPad", Vector3.new(4, 0.3, 4), L(-19.5, 0.15, -14.5), Color3.fromRGB(80, 210, 220))
	billboard(luckPad, "Sign", "More luck!\nUpgrade Conveyor", Vector2.new(240, 50), 3, Color3.fromRGB(190, 245, 250), 40)

	-- Zone B: token lanes (navy chevron strips, back → front) interleaved with
	-- the pedestal columns (env v1 E1.11–12); separate from the pack belt
	for li, laneX in LANE_X do
		local lane = part(model, "TokenLane" .. li, Vector3.new(4, 0.3, 34), L(laneX, 0.3, 0), Color3.fromRGB(35, 45, 80))
		lane.CanCollide = false
		for z = 14, -10, -8 do
			chevron(model, "LaneArrow", L(laneX, 0.6, z))
		end
	end

	-- pedestals + foot upgrade pads (env v1 E1.13–14; pads are stubs)
	local displaySlots: { [string]: CFrame } = {}
	local displaySlotLane: { [string]: number } = {}
	for slot, spec in PEDESTALS do
		local px, pz, lane = spec[1], spec[2], spec[3]
		part(model, "PedestalPad" .. slot, Vector3.new(4.6, 0.2, 4.6), L(px, 0.1, pz), Color3.fromRGB(90, 90, 100))
		part(model, "Pedestal" .. slot, Vector3.new(4, 0.8, 4), L(px, 0.5, pz), Color3.fromRGB(110, 110, 122))
		part(model, "UpgradePad" .. slot, Vector3.new(2, 0.25, 2), L(px, 0.12, pz - 3.2), Color3.fromRGB(90, 180, 100))
		-- card stands upright on the pedestal, facing the front of the base
		displaySlots[tostring(slot)] = L(px, 2.9, pz)
		displaySlotLane[tostring(slot)] = lane
	end

	-- Zone C: per-lane box points at the front edge (env v1 E1.15, flow v1.2):
	-- cardboard boxes fill with 8 token-cards; full → new box ON TOP (cap 5)
	local lanes: { LaneRec } = {}
	for li, laneX in LANE_X do
		local pallet = part(model, "BoxPoint" .. li, Vector3.new(4, 0.4, 4), L(laneX, 0.2, -19), Color3.fromRGB(139, 105, 70))
		pallet.Material = Enum.Material.Wood
		local stackFolder = Instance.new("Folder")
		stackFolder.Name = "BoxStack" .. li
		stackFolder.Parent = model
		local carryPrompt = makePrompt(pallet, "CarryBoxPrompt", "Carry", "$0", "CarryBox")
		carryPrompt:SetAttribute("Lane", li)
		local valueBb = billboard(pallet, "Value", "0/8 · $0", Vector2.new(200, 40), 9.5, Color3.fromRGB(180, 255, 140), 45)
		local valueLabel = valueBb:FindFirstChild("Text") :: TextLabel
		table.insert(lanes, {
			index = li,
			pallet = pallet,
			stackFolder = stackFolder,
			carryPrompt = carryPrompt,
			valueLabel = valueLabel,
			tokenTarget = L(laneX, 3, -19).Position,
		})
	end

	-- "You make: $X/s" sign beside the center box point (env v1 E1.16)
	local signPost = part(model, "RateSign", Vector3.new(0.5, 5, 0.5), L(1, 2.5, -19), Color3.fromRGB(90, 90, 100))
	local rateBb = billboard(signPost, "Rate", "You make: $0/s", Vector2.new(240, 40), 3.2, Color3.fromRGB(180, 230, 255), 45)
	local rateSignLabel = rateBb:FindFirstChild("Text") :: TextLabel

	-- Zone C2: the base's OWN Sell vendor (env v1.1 E1.16a) at the front edge
	-- beside the box points, facing the walkway; his green "Sell Card Boxes!"
	-- zone pad in front cashes carried boxes 1:1 (owner only). He also opens
	-- the 5-option inventory dialog (cards 50%). This vendor, not any plaza
	-- stall, is the canonical sell point.
	local vendorTorso = mannequin(model, "SellVendor", L(5.5, 0, -18.5))
	billboard(vendorTorso, "Name", "Sell Vendor", Vector2.new(160, 30), 4.6, Color3.fromRGB(255, 230, 150), 40)
	local sellPrompt = makePrompt(vendorTorso, "SellVendorPrompt", "Talk", "Sell Vendor (sell inventory)", "SellStall")
	local baseSellZone = part(model, "SellZone", Vector3.new(4, 0.4, 3), L(5.5, 0.2, -21.5), Color3.fromRGB(60, 200, 90))
	baseSellZone.Transparency = 0.15
	billboard(baseSellZone, "Sign", "Sell Card Boxes!\nWalk in while carrying (1:1)", Vector2.new(320, 44), 2.4, Color3.fromRGB(200, 255, 200), 40)

	-- BEST CARD billboard at the back fence (env v1 E1.16; road-readable)
	part(model, "BestPostL", Vector3.new(0.5, 9, 0.5), L(-6, 4.5, 23.4), Color3.fromRGB(110, 84, 60))
	part(model, "BestPostR", Vector3.new(0.5, 9, 0.5), L(6, 4.5, 23.4), Color3.fromRGB(110, 84, 60))
	local bestBoard = part(model, "BestCardBoard", Vector3.new(14, 5, 0.5), L(0, 7, 23.4), Color3.fromRGB(139, 105, 70))
	bestBoard.Material = Enum.Material.Wood
	local bestCardLabel = boardLabel(bestBoard, "BestGui", "BEST CARD $0/Card", Color3.fromRGB(255, 230, 150))

	-- Zone D: 2x/4x boost pads + rotating pack-offer podium (env v1 E1.17;
	-- visual stubs, live with the shop milestone)
	local twoX = part(model, "Boost2x", Vector3.new(4, 0.3, 4), L(19, 0.15, -18), Color3.fromRGB(60, 200, 90))
	billboard(twoX, "Sign", "2x LUCK\n(coming)", Vector2.new(180, 44), 3, Color3.fromRGB(200, 255, 200), 40)
	local fourX = part(model, "Boost4x", Vector3.new(4, 0.3, 4), L(19, 0.15, -13), Color3.fromRGB(150, 90, 200))
	billboard(fourX, "Sign", "4x LUCK\n(coming)", Vector2.new(180, 44), 3, Color3.fromRGB(230, 200, 255), 40)
	local offer = part(model, "OfferPodium", Vector3.new(3, 2, 3), L(19, 1, -6), Color3.fromRGB(45, 45, 55))
	billboard(offer, "Sign", "STARTER PACK\nOFFER (coming)", Vector2.new(220, 44), 3, Color3.fromRGB(255, 230, 150), 40)

	-- pack pedestals (carried packs are placed here and hatch; PlacementService
	-- validates the carrier). Two for M1.x per EconomyConfig.PACK_PEDESTALS.
	local packPedestals: { [number]: CFrame } = {}
	local placePrompts: { [number]: ProximityPrompt } = {}
	for i, px in { -2, 5 } do
		local pedestal = part(model, "PackPedestal" .. i, Vector3.new(3.5, 1, 3.5), L(px, 0.5, -11), Color3.fromRGB(70, 90, 140))
		packPedestals[i] = L(px, 2.3, -11)
		local placePrompt = makePrompt(pedestal, "PlacePackPrompt", "Place Pack", "Pack pedestal", "PlacePack")
		placePrompt.MaxActivationDistance = 10
		placePrompt:SetAttribute("Pedestal", i)
		placePrompts[i] = placePrompt
	end

	-- per-base spawn (env v1 E3.25): fresh spawns face the spawn machine
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "BaseSpawn"
	spawnLocation.Size = Vector3.new(6, 1, 6)
	spawnLocation.CFrame = L(0, 0.5, -5)
	spawnLocation.Anchored = true
	spawnLocation.Neutral = false
	spawnLocation.Enabled = true
	spawnLocation.Color = Color3.fromRGB(150, 160, 170)
	spawnLocation.Material = Enum.Material.SmoothPlastic
	spawnLocation.TopSurface = Enum.SurfaceType.Smooth
	spawnLocation.Parent = model
	local spawnCFrame = CFrame.lookAt(L(0, 3.5, -5).Position, L(-14, 3.5, -10).Position)

	-- owner sign at the front-right corner ("X's plot", env v1 E0.1)
	local ownerPost = part(model, "OwnerPost", Vector3.new(0.5, 6, 0.5), L(21, 3, -22), Color3.fromRGB(90, 90, 100))
	local ownerBb = billboard(ownerPost, "OwnerLabel", "FREE PLOT", Vector2.new(220, 30), 3.6, Color3.fromRGB(255, 255, 180), 70)

	model.Parent = worldFolder

	return {
		index = index,
		model = model,
		origin = origin,
		spawnLocation = spawnLocation,
		spawnCFrame = spawnCFrame,
		displaySlots = displaySlots,
		displaySlotLane = displaySlotLane,
		packPedestals = packPedestals,
		placePrompts = placePrompts,
		lanes = lanes,
		beltCenter = beltCenter,
		spawnPodiumPrompt = spawnPodiumPrompt,
		rateSignLabel = rateSignLabel,
		bestCardLabel = bestCardLabel,
		sellZone = baseSellZone,
		sellPrompt = sellPrompt,
		owner = nil,
	}
end

--[[ public API ]]--

function WorldService.GetSellZone(self: any): Part
	return sellZone
end

function WorldService.GetPlots(self: any): { PlotRec }
	return plots
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
			for _, lane in plot.lanes do
				lane.carryPrompt:SetAttribute("OwnerUserId", player.UserId)
				lane.valueLabel.Text = "0/8 · $0"
				lane.stackFolder:ClearAllChildren()
			end
			plot.spawnPodiumPrompt:SetAttribute("OwnerUserId", player.UserId)
			plot.sellPrompt:SetAttribute("OwnerUserId", player.UserId)
			-- fresh readouts for the new owner (IncomeService owns the values)
			plot.rateSignLabel.Text = "You make: $0/s"
			plot.bestCardLabel.Text = "BEST CARD $0/Card"
			local bb = plot.model:FindFirstChild("OwnerPost") and (plot.model:FindFirstChild("OwnerPost") :: Part):FindFirstChild("OwnerLabel")
			local text = bb and bb:FindFirstChild("Text")
			if text and text:IsA("TextLabel") then
				text.Text = player.DisplayName .. "'s plot"
			end
			-- respawns land on the owned base; the fresh join walks from here
			player.RespawnLocation = plot.spawnLocation
			task.defer(function()
				if plotByPlayer[player] ~= plot then
					return
				end
				local char = player.Character or player.CharacterAdded:Wait()
				if plotByPlayer[player] ~= plot or not char then
					return
				end
				char:PivotTo(plot.spawnCFrame)
			end)
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
	if player.RespawnLocation == plot.spawnLocation then
		player.RespawnLocation = nil
	end
	for _, placePrompt in plot.placePrompts do
		placePrompt:SetAttribute("OwnerUserId", nil)
	end
	for _, lane in plot.lanes do
		lane.carryPrompt:SetAttribute("OwnerUserId", nil)
		lane.stackFolder:ClearAllChildren()
		lane.valueLabel.Text = "0/8 · $0"
	end
	plot.spawnPodiumPrompt:SetAttribute("OwnerUserId", nil)
	plot.sellPrompt:SetAttribute("OwnerUserId", nil)
	local bb = plot.model:FindFirstChild("OwnerPost") and (plot.model:FindFirstChild("OwnerPost") :: Part):FindFirstChild("OwnerLabel")
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

	buildGround()
	buildRoad()
	buildPlaza()
	for i = 1, PLOT_COUNT do
		table.insert(plots, buildBase(i))
	end

	Players.PlayerRemoving:Connect(function(player)
		WorldService:ReleasePlot(player)
	end)

	print(("[WorldService] world built (plaza hub + %d ring bases, no gaps)"):format(PLOT_COUNT))
end

return WorldService
