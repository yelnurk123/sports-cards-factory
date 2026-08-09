--!strict
-- ConveyorService — pack acquisition. BUILT NEW (no finished server conveyor
-- exists in either reference codebase; audit §4). The conveyor podium cycles
-- the M1 starter packs on a belt; walking up to a pack opens its odds panel
-- (spec §16: odds shown before purchase), BUY fires BuyPack, the server
-- validates and the pack lands on the buyer's plot (PlacementService).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PackConfig = require(Shared.PackConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local WorldService = require(script.Parent.WorldService)
local PlacementService = require(script.Parent.PlacementService)

local ConveyorService = {}

local BELT_SPEED = 6 -- studs/s
local PACK_SPACING = 30 -- studs between packs on the belt (3 packs, 90-stud belt)

local buyRemote: RemoteEvent = nil :: any

local packModels: { [number]: Part } = {} -- Order index -> belt pack model
local beltPos: { [number]: number } = {} -- Order index -> distance along belt

local function buildBeltPack(packId: string): Part
	local pack = PackConfig.get(packId)
	local model = Instance.new("Part")
	model.Name = "BeltPack_" .. packId
	model.Size = Vector3.new(2.4, 2.4, 2.4)
	model.Color = ({ street = Color3.fromRGB(90, 170, 90), sandlot = Color3.fromRGB(195, 165, 110), clubhouse = Color3.fromRGB(110, 165, 205) } :: any)[packId] or Color3.fromRGB(150, 150, 160)
	model.Material = Enum.Material.SmoothPlastic
	model.Anchored = true
	model.CanCollide = false
	model.CanQuery = true

	local bb = Instance.new("BillboardGui")
	bb.Name = "PackBillboard"
	bb.Size = UDim2.fromOffset(280, 56)
	bb.StudsOffset = Vector3.new(0, 2.8, 0)
	bb.AlwaysOnTop = true
	bb.Parent = model
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0.55, 0)
	title.BackgroundTransparency = 1
	title.Text = pack.displayName
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextStrokeTransparency = 0.5
	title.Parent = bb
	local price = Instance.new("TextLabel")
	price.Name = "Price"
	price.Position = UDim2.new(0, 0, 0.55, 0)
	price.Size = UDim2.new(1, 0, 0.45, 0)
	price.BackgroundTransparency = 1
	price.Text = EconomyConfig.formatMoney(pack.price) .. " · opens in " .. pack.hatch .. "s"
	price.Font = Enum.Font.Gotham
	price.TextScaled = true
	price.TextColor3 = Color3.fromRGB(255, 230, 150)
	price.TextStrokeTransparency = 0.5
	price.Parent = bb

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "PackInfoPrompt"
	prompt.ActionText = "Odds & Buy"
	prompt.ObjectText = pack.displayName
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt:SetAttribute("Tag", "PackInfo")
	prompt:SetAttribute("PackId", packId)
	prompt.Parent = model

	return model
end

-- Server-authoritative buy. Client already saw the odds panel; this validates
-- cash + plot space, deducts, and lands the pack on the buyer's plot.
function ConveyorService.BuyPack(self: any, player: Player, packId: string)
	if not PackConfig.exists(packId) then
		return
	end
	local data = DataService:GetData(player)
	if not data then
		return
	end
	local pack = PackConfig.get(packId)
	if data.cash < pack.price then
		PlacementService:Notify(player, "Not enough cash for the " .. pack.displayName .. " (" .. EconomyConfig.formatMoney(pack.price) .. ")")
		return
	end
	local placementId, err = PlacementService:PlacePack(player, packId)
	if not placementId then
		PlacementService:Notify(player, err or "Can't place that pack right now")
		return
	end
	data.cash -= pack.price
	DataService:SyncMirror(player)
	PlacementService:Notify(player, pack.displayName .. " bought — it's hatching on your plot!")
	print(("[ConveyorService] %s bought %s for $%d"):format(player.Name, packId, pack.price))
end

function ConveyorService.OnStart(self: any)
	buyRemote = Instance.new("RemoteEvent")
	buyRemote.Name = "BuyPack"
	local remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
	buyRemote.Parent = remotes

	buyRemote.OnServerEvent:Connect(function(player, packId)
		if type(packId) == "string" then
			ConveyorService:BuyPack(player, packId)
		end
	end)

	-- spawn the belt packs (one of each M1 pack, evenly spaced) and ride the belt
	local conveyor = WorldService:GetConveyor()
	local beltLength = (conveyor.endPos - conveyor.startPos).Magnitude
	for i, packId in PackConfig.Order do
		local model = buildBeltPack(packId)
		model.Parent = workspace
		packModels[i] = model
		beltPos[i] = (i - 1) * PACK_SPACING
	end

	local dt = 0.1
	task.spawn(function()
		while true do
			task.wait(dt)
			for i, model in packModels do
				beltPos[i] += BELT_SPEED * dt
				if beltPos[i] > beltLength then
					beltPos[i] -= beltLength + 6 -- wrap: pop back just before the start
				end
				local alpha = math.clamp(beltPos[i] / beltLength, 0, 1)
				local pos = conveyor.startPos:Lerp(conveyor.endPos, alpha)
				model.CFrame = CFrame.new(pos) * CFrame.Angles(0, os.clock() * 1.5 + i, 0) -- slow spin
			end
		end
	end)

	print("[ConveyorService] Ready (" .. tostring(#PackConfig.Order) .. " packs on the belt)")
end

return ConveyorService
