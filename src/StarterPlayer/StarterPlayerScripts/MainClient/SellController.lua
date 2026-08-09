--!strict
-- SellController — the Sell stall panel. Lists owned cards from the server's
-- CardsSync (server-canonical), each row sells at 50% of value (canon §2) via
-- the SellCard remote. The server re-validates ownership.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local BandConfig = require(Shared.BandConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local SellController = {}

local player = Players.LocalPlayer
local panel: Frame = nil :: any
local listFrame: ScrollingFrame = nil :: any
local emptyLabel: TextLabel = nil :: any
local latestStorage: { any } = {}

local function rebuild()
	for _, child in listFrame:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	emptyLabel.Visible = #latestStorage == 0
	for _, entry in latestStorage do
		local card = CardConfig.get(entry.cardID)
		local band = BandConfig.get(card.band)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -8, 0, 52)
		row.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
		row.BorderSizePixel = 0
		row.Parent = listFrame
		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 8)
		rowCorner.Parent = row

		local chip = Instance.new("Frame")
		chip.Size = UDim2.new(0, 14, 0.7, 0)
		chip.Position = UDim2.new(0, 8, 0.15, 0)
		chip.BackgroundColor3 = band.ribbonColor
		chip.BorderSizePixel = 0
		chip.Parent = row

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.52, -30, 0.55, 0)
		nameLabel.Position = UDim2.new(0, 30, 0, 4)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextScaled = true
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
		nameLabel.Text = card.name .. (entry.displayed and "  · on display" or "")
		nameLabel.Parent = row

		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0.52, -30, 0.4, 0)
		valueLabel.Position = UDim2.new(0, 30, 0.55, -2)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Font = Enum.Font.Gotham
		valueLabel.TextScaled = true
		valueLabel.TextXAlignment = Enum.TextXAlignment.Left
		valueLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
		valueLabel.Text = card.sport .. " · " .. EconomyConfig.formatMoney(entry.value) .. "/Card"
		valueLabel.Parent = row

		local sell = Instance.new("TextButton")
		sell.AnchorPoint = Vector2.new(1, 0.5)
		sell.Position = UDim2.new(1, -8, 0.5, 0)
		sell.Size = UDim2.new(0, 120, 0, 38)
		sell.BackgroundColor3 = Color3.fromRGB(200, 140, 40)
		sell.Font = Enum.Font.GothamBold
		sell.TextScaled = true
		sell.TextColor3 = Color3.fromRGB(255, 255, 255)
		sell.Text = "SELL " .. EconomyConfig.formatMoney(EconomyConfig.sellPrice(entry.value))
		sell.Parent = row
		local sellCorner = Instance.new("UICorner")
		sellCorner.CornerRadius = UDim.new(0, 8)
		sellCorner.Parent = sell
		sell.MouseButton1Click:Connect(function()
			ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SellCard"):FireServer(entry.uid)
		end)
	end
end

function SellController.Open(self: any)
	rebuild()
	panel.Visible = true
end

function SellController.OnStart(self: any)
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SCF_HUD") or Instance.new("ScreenGui")
	gui.Name = "SCF_HUD"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	panel = Instance.new("Frame")
	panel.Name = "SellPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.new(0, 460, 0, 440)
	panel.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = panel

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 40)
	title.Position = UDim2.new(0, 10, 0, 8)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Text = "SELL CARDS — the Scout pays 50%"
	title.Parent = panel

	emptyLabel = Instance.new("TextLabel")
	emptyLabel.Size = UDim2.new(1, -20, 0, 60)
	emptyLabel.Position = UDim2.new(0, 10, 0, 180)
	emptyLabel.BackgroundTransparency = 1
	emptyLabel.Font = Enum.Font.Gotham
	emptyLabel.TextScaled = true
	emptyLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
	emptyLabel.Text = "No cards yet — buy a pack off the conveyor!"
	emptyLabel.Visible = false
	emptyLabel.Parent = panel

	listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1, -20, 1, -70)
	listFrame.Position = UDim2.new(0, 10, 0, 56)
	listFrame.BackgroundTransparency = 1
	listFrame.ScrollBarThickness = 6
	listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	listFrame.Parent = panel
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = listFrame

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

	-- keep the panel live as the server syncs card state
	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CardsSync").OnClientEvent:Connect(function(payload)
		if type(payload) == "table" and type(payload.storage) == "table" then
			latestStorage = payload.storage
			if panel.Visible then
				rebuild()
			end
		end
	end)

	print("[SellController] Ready")
end

return SellController
