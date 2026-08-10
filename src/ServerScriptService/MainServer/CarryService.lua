--!strict
-- CarryService — the carried-item layer (flow spec v1.1 F1/F4, BUILT NEW for
-- M1.1). Bought packs and collected card boxes are VISIBLE carried items: a
-- Tool in the player's hand/hotbar, never a silent teleport. One carried pack
-- and one carried box at a time (M1.1 blockout rule). State lives in
-- data.carried so a rejoin never eats a purchase; Tools are rebuilt on
-- join/respawn from that state.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PackConfig = require(Shared.PackConfig)
local FoilConfig = require(Shared.FoilConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)

local CarryService = {}

local PACK_COLORS: { [string]: Color3 } = {
	street = Color3.fromRGB(90, 170, 90),
	sandlot = Color3.fromRGB(195, 165, 110),
	clubhouse = Color3.fromRGB(110, 165, 205),
}

local function makeTool(name: string, size: Vector3, color: Color3): Tool
	local tool = Instance.new("Tool")
	tool.Name = name
	tool.CanBeDropped = false
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = size
	handle.Color = color
	handle.Material = Enum.Material.SmoothPlastic
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = tool
	return tool
end

-- Equips into the hand when a character exists, else waits in the Backpack.
local function giveTool(player: Player, tool: Tool)
	local character = player.Character
	tool.Parent = character or player:WaitForChild("Backpack")
end

local function destroyToolsOfKind(player: Player, kind: string)
	for _, container in { player.Character, player:FindFirstChild("Backpack") } do
		if container then
			for _, inst in container:GetChildren() do
				if inst:IsA("Tool") and inst:GetAttribute("Kind") == kind then
					inst:Destroy()
				end
			end
		end
	end
end

local function packLabel(packID: string, foil: string): string
	local pack = PackConfig.get(packID)
	local foilName = FoilConfig.get(foil).displayName
	if foilName == "Base" then
		return pack.displayName
	end
	return foilName .. " " .. pack.displayName
end

--[[ packs ]]--

-- Puts a bought pack in the player's hand. Returns true or false + reason.
function CarryService.GivePack(self: any, player: Player, packID: string, foil: string): (boolean, string?)
	local data = DataService:GetData(player)
	if not data then
		return false, "Data not loaded"
	end
	if data.carried.packID then
		return false, "You're already carrying a pack — place it on your plot first"
	end
	data.carried.packID = packID
	data.carried.packFoil = foil

	local tool = makeTool(packLabel(packID, foil), Vector3.new(1.8, 1.8, 1.8), PACK_COLORS[packID] or Color3.fromRGB(150, 150, 160))
	tool:SetAttribute("Kind", "Pack")
	tool:SetAttribute("PackId", packID)
	tool:SetAttribute("Foil", foil)
	giveTool(player, tool)
	player:SetAttribute("CarriedPack", packLabel(packID, foil))
	return true, nil
end

-- Reads the carried pack without clearing it (nil when hands are empty).
function CarryService.PeekPack(self: any, player: Player): (string?, string?)
	local data = DataService:GetData(player)
	if not data or not data.carried.packID then
		return nil, nil
	end
	return data.carried.packID, data.carried.packFoil or "Base"
end

-- Clears the carried pack (placed, sold, ...) and destroys the Tool.
function CarryService.TakePack(self: any, player: Player)
	local data = DataService:GetData(player)
	if data then
		data.carried.packID = nil
		data.carried.packFoil = nil
	end
	destroyToolsOfKind(player, "Pack")
	player:SetAttribute("CarriedPack", nil)
end

--[[ boxes ]]--

-- Puts a collected card box in the player's hand (flow spec F4: "On Carry").
function CarryService.GiveBox(self: any, player: Player, value: number): (boolean, string?)
	local data = DataService:GetData(player)
	if not data then
		return false, "Data not loaded"
	end
	if (data.carried.boxValue or 0) > 0 then
		return false, "You're already carrying a box — sell it at the Sell zone first"
	end
	data.carried.boxValue = value

	local tool = makeTool("Card Box " .. EconomyConfig.formatMoney(value), Vector3.new(1.8, 1.6, 1.8), Color3.fromRGB(139, 105, 70))
	tool:SetAttribute("Kind", "Box")
	tool:SetAttribute("Value", value)
	giveTool(player, tool)
	player:SetAttribute("CarriedBoxValue", value)
	return true, nil
end

-- Clears the carried box, returning its value (0 when not carrying one).
function CarryService.TakeBox(self: any, player: Player): number
	local data = DataService:GetData(player)
	local value = data and data.carried.boxValue or 0
	if data then
		data.carried.boxValue = 0
	end
	destroyToolsOfKind(player, "Box")
	player:SetAttribute("CarriedBoxValue", 0)
	return value
end

--[[ lifecycle ]]--

local function restore(player: Player)
	local data = DataService:GetData(player)
	if not data then
		return
	end
	task.defer(function()
		if not player:IsDescendantOf(Players) then
			return
		end
		if data.carried.packID then
			local packID, foil = data.carried.packID, data.carried.packFoil or "Base"
			destroyToolsOfKind(player, "Pack")
			local tool = makeTool(packLabel(packID, foil), Vector3.new(1.8, 1.8, 1.8), PACK_COLORS[packID] or Color3.fromRGB(150, 150, 160))
			tool:SetAttribute("Kind", "Pack")
			tool.Parent = player:FindFirstChild("Backpack") or player.Character
		end
		if (data.carried.boxValue or 0) > 0 then
			destroyToolsOfKind(player, "Box")
			local tool = makeTool("Card Box " .. EconomyConfig.formatMoney(data.carried.boxValue), Vector3.new(1.8, 1.6, 1.8), Color3.fromRGB(139, 105, 70))
			tool:SetAttribute("Kind", "Box")
			tool.Parent = player:FindFirstChild("Backpack") or player.Character
		end
		player:SetAttribute("CarriedPack", if data.carried.packID then packLabel(data.carried.packID, data.carried.packFoil or "Base") else nil)
		player:SetAttribute("CarriedBoxValue", data.carried.boxValue or 0)
	end)
end

function CarryService.OnStart(self: any)
	DataService.ProfileLoaded:Connect(function(player)
		restore(player)
		player.CharacterAdded:Connect(function()
			restore(player)
		end)
	end)

	print("[CarryService] Ready (packs & boxes are carried items)")
end

return CarryService
