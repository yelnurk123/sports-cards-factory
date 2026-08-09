--!strict
-- IndexController — the collection catalog (spec §4 blockout): every M1 card
-- slot visible from day one; owned cards show name + band color, unowned show
-- "???". Owned set comes from the server's CardsSync index (ever-pulled).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local PackConfig = require(Shared.PackConfig)
local BandConfig = require(Shared.BandConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local IndexController = {}

local player = Players.LocalPlayer
local panel: Frame = nil :: any
local grid: Frame = nil :: any
local countLabel: TextLabel = nil :: any
local owned: { [string]: boolean } = {}

local function rebuild()
	local total = 0
	local have = 0
	for _, child in grid:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	-- pack by pack, pool order (chase card last)
	for _, packId in PackConfig.Order do
		local pack = PackConfig.get(packId)
		for _, cardId in pack.pool do
			total += 1
			local card = CardConfig.get(cardId)
			local isOwned = owned[cardId .. ":Base"] == true
			if isOwned then
				have += 1
			end
			local band = BandConfig.get(card.band)
			local cell = Instance.new("Frame")
			cell.BackgroundColor3 = isOwned and Color3.fromRGB(35, 38, 45) or Color3.fromRGB(22, 23, 28)
			cell.BorderSizePixel = 0
			cell.Parent = grid
			local cellCorner = Instance.new("UICorner")
			cellCorner.CornerRadius = UDim.new(0, 8)
			cellCorner.Parent = cell

			local ribbon = Instance.new("Frame")
			ribbon.Size = UDim2.new(1, 0, 0, 10)
			ribbon.BackgroundColor3 = isOwned and band.ribbonColor or Color3.fromRGB(60, 60, 66)
			ribbon.BorderSizePixel = 0
			ribbon.Parent = cell

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -8, 0.55, 0)
			nameLabel.Position = UDim2.new(0, 4, 0, 12)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextScaled = true
			nameLabel.TextWrapped = true
			nameLabel.TextColor3 = isOwned and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(120, 120, 128)
			nameLabel.Text = isOwned and card.name or "???"
			nameLabel.Parent = cell

			local subLabel = Instance.new("TextLabel")
			subLabel.Size = UDim2.new(1, -8, 0.3, -4)
			subLabel.Position = UDim2.new(0, 4, 0.68, 0)
			subLabel.BackgroundTransparency = 1
			subLabel.Font = Enum.Font.Gotham
			subLabel.TextScaled = true
			subLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
			subLabel.Text = isOwned and (EconomyConfig.formatMoney(card.base) .. "/Card") or (pack.displayName)
			subLabel.Parent = cell
		end
	end
	countLabel.Text = "Index: " .. tostring(have) .. "/" .. tostring(total)
end

function IndexController.Toggle(self: any)
	panel.Visible = not panel.Visible
	if panel.Visible then
		rebuild()
	end
end

function IndexController.Hide(self: any)
	panel.Visible = false
end

function IndexController.OnStart(self: any)
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SCF_HUD") or Instance.new("ScreenGui")
	gui.Name = "SCF_HUD"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	panel = Instance.new("Frame")
	panel.Name = "IndexPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.new(0, 520, 0, 460)
	panel.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = panel

	countLabel = Instance.new("TextLabel")
	countLabel.Size = UDim2.new(1, -20, 0, 40)
	countLabel.Position = UDim2.new(0, 10, 0, 8)
	countLabel.BackgroundTransparency = 1
	countLabel.Font = Enum.Font.GothamBold
	countLabel.TextScaled = true
	countLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	countLabel.Text = "Index: 0/12"
	countLabel.Parent = panel

	grid = Instance.new("Frame")
	grid.Size = UDim2.new(1, -20, 1, -64)
	grid.Position = UDim2.new(0, 10, 0, 54)
	grid.BackgroundTransparency = 1
	grid.Parent = panel
	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(0, 118, 0, 108)
	layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.Parent = grid

	local close = Instance.new("TextButton")
	close.AnchorPoint = Vector2.new(1, 0)
	close.Position = UDim2.new(1, -8, 0, 8)
	close.Size = UDim2.new(0, 32, 0, 32)
	close.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	close.Font = Enum.Font.GothamBold
	close.TextScaled = true
	close.TextColor3 = Color3.fromRGB(255, 255, 255)
	close.Text = "X"
	close.Parent = panel
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = close
	close.MouseButton1Click:Connect(function()
		panel.Visible = false
	end)

	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CardsSync").OnClientEvent:Connect(function(payload)
		if type(payload) == "table" and type(payload.index) == "table" then
			owned = {}
			for _, key in payload.index do
				owned[key] = true
			end
			if panel.Visible then
				rebuild()
			end
		end
	end)

	print("[IndexController] Ready")
end

return IndexController
