--!strict
-- PackInfoController — the pre-purchase pack panel (spec §16: every pack shows
-- its real odds table before purchase; flow spec v1.1 F1: the pack's foil was
-- rolled at spawn and shows here too — displayed = rolled). Odds come from the
-- shared PackConfig — the same table the server rolls from, so display and
-- roll can never drift. BUY fires BuyPack; the server owns the belt state.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PackConfig = require(Shared.PackConfig)
local BandConfig = require(Shared.BandConfig)
local CardConfig = require(Shared.CardConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local PackInfoController = {}

local player = Players.LocalPlayer
local panel: Frame = nil :: any
local titleLabel: TextLabel = nil :: any
local subLabel: TextLabel = nil :: any
local oddsList: Frame = nil :: any
local buyButton: TextButton = nil :: any
local currentPackId: string? = nil

local function build()
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SCF_HUD") or Instance.new("ScreenGui")
	gui.Name = "SCF_HUD"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	panel = Instance.new("Frame")
	panel.Name = "PackInfoPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.new(0, 420, 0, 420)
	panel.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = panel

	titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 0, 40)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Text = "Pack"
	titleLabel.Parent = panel

	subLabel = Instance.new("TextLabel")
	subLabel.Size = UDim2.new(1, -20, 0, 26)
	subLabel.Position = UDim2.new(0, 10, 0, 46)
	subLabel.BackgroundTransparency = 1
	subLabel.Font = Enum.Font.Gotham
	subLabel.TextScaled = true
	subLabel.TextColor3 = Color3.fromRGB(180, 200, 230)
	subLabel.Text = ""
	subLabel.Parent = panel

	local oddsHeader = Instance.new("TextLabel")
	oddsHeader.Size = UDim2.new(1, -20, 0, 24)
	oddsHeader.Position = UDim2.new(0, 10, 0, 80)
	oddsHeader.BackgroundTransparency = 1
	oddsHeader.Font = Enum.Font.GothamBold
	oddsHeader.TextScaled = true
	oddsHeader.TextColor3 = Color3.fromRGB(255, 230, 150)
	oddsHeader.Text = "PULL ODDS — one card per pack"
	oddsHeader.Parent = panel

	oddsList = Instance.new("Frame")
	oddsList.Size = UDim2.new(1, -20, 0, 220)
	oddsList.Position = UDim2.new(0, 10, 0, 108)
	oddsList.BackgroundTransparency = 1
	oddsList.Parent = panel
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 6)
	layout.Parent = oddsList

	buyButton = Instance.new("TextButton")
	buyButton.AnchorPoint = Vector2.new(0.5, 1)
	buyButton.Position = UDim2.new(0.5, 0, 1, -14)
	buyButton.Size = UDim2.new(0, 240, 0, 48)
	buyButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextScaled = true
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Text = "BUY"
	buyButton.Parent = panel
	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 10)
	buyCorner.Parent = buyButton
	buyButton.MouseButton1Click:Connect(function()
		if currentPackId then
			-- the server resolves WHICH belt pack this player owns (displayed = rolled)
			ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyPack"):FireServer()
		end
		panel.Visible = false
	end)

	local close = Instance.new("TextButton")
	close.Name = "Close"
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
end

function PackInfoController.Open(self: any, packId: string, foil: string?)
	if not PackConfig.exists(packId) then
		return
	end
	currentPackId = packId
	local pack = PackConfig.get(packId)
	titleLabel.Text = pack.displayName
	subLabel.Text = (foil or "Base") .. " · " .. pack.sport .. " · Rung " .. pack.rung .. " · " .. EconomyConfig.formatMoney(pack.price)
		.. " · opens in " .. pack.hatch .. "s"
	buyButton.Text = "BUY " .. EconomyConfig.formatMoney(pack.price)

	for _, child in oddsList:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	for _, row in PackConfig.getOdds(packId) do
		local card = CardConfig.get(row.cardId)
		local band = BandConfig.get(card.band)
		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, 0, 0, 46)
		line.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
		line.BorderSizePixel = 0
		line.Parent = oddsList
		local lineCorner = Instance.new("UICorner")
		lineCorner.CornerRadius = UDim.new(0, 8)
		lineCorner.Parent = line

		local chip = Instance.new("Frame")
		chip.Size = UDim2.new(0, 14, 0.7, 0)
		chip.Position = UDim2.new(0, 8, 0.15, 0)
		chip.BackgroundColor3 = band.ribbonColor
		chip.BorderSizePixel = 0
		chip.Parent = line

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.6, -30, 1, 0)
		nameLabel.Position = UDim2.new(0, 30, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextScaled = true
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
		nameLabel.Text = row.name .. "  (" .. EconomyConfig.formatMoney(row.base) .. "/Card)"
		nameLabel.Parent = line

		local oddsLabel = Instance.new("TextLabel")
		oddsLabel.Size = UDim2.new(0.4, -10, 1, 0)
		oddsLabel.Position = UDim2.new(0.6, 0, 0, 0)
		oddsLabel.BackgroundTransparency = 1
		oddsLabel.Font = Enum.Font.GothamBold
		oddsLabel.TextScaled = true
		oddsLabel.TextXAlignment = Enum.TextXAlignment.Right
		oddsLabel.TextColor3 = Color3.fromRGB(255, 230, 150)
		oddsLabel.Text = string.format("%.1f%%", row.chance * 100)
		oddsLabel.Parent = line
	end

	panel.Visible = true
end

function PackInfoController.OnStart(self: any)
	build()
	print("[PackInfoController] Ready")
end

return PackInfoController
