--!strict
-- RevealController — the reveal ceremony (spec §4: full-screen card, band
-- ribbon color, foil shine, $/Card, sport — rarity must read instantly by
-- color, even in blockout). Placeholder frames only: band owns the ribbon
-- (BandConfig colors from the art spec), foil owns the frame (FoilConfig).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local BandConfig = require(Shared.BandConfig)
local FoilConfig = require(Shared.FoilConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local RevealController = {}

local player = Players.LocalPlayer

local function showReveal(payload: any)
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SCF_HUD")
	if not gui then
		return
	end

	local band = BandConfig.get(payload.band)
	local foil = FoilConfig.get(payload.foil)

	local overlay = Instance.new("Frame")
	overlay.Name = "Reveal"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	overlay.BackgroundTransparency = 0.25
	overlay.Parent = gui

	-- full-screen band wash: rarity reads by color before anything else loads
	local wash = Instance.new("Frame")
	wash.Size = UDim2.fromScale(1, 1)
	wash.BackgroundColor3 = band.ribbonColor
	wash.BackgroundTransparency = 0.85
	wash.BorderSizePixel = 0
	wash.Parent = overlay

	-- the card (placeholder frame: foil color border, band ribbon, text)
	local card = Instance.new("Frame")
	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.new(0, 0, 0, 0)
	card.BackgroundColor3 = foil.frameColor
	card.BorderSizePixel = 0
	card.Parent = overlay
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 14)
	cardCorner.Parent = card

	local inner = Instance.new("Frame")
	inner.AnchorPoint = Vector2.new(0.5, 0.5)
	inner.Position = UDim2.fromScale(0.5, 0.5)
	inner.Size = UDim2.new(1, -16, 1, -16)
	inner.BackgroundColor3 = Color3.fromRGB(250, 248, 240)
	inner.BorderSizePixel = 0
	inner.Parent = card
	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(0, 10)
	innerCorner.Parent = inner

	local ribbon = Instance.new("Frame")
	ribbon.Size = UDim2.new(1, 0, 0, 48)
	ribbon.BackgroundColor3 = band.ribbonColor
	ribbon.BorderSizePixel = 0
	ribbon.Parent = inner
	local ribbonCorner = Instance.new("UICorner")
	ribbonCorner.CornerRadius = UDim.new(0, 10)
	ribbonCorner.Parent = ribbon
	local ribbonText = Instance.new("TextLabel")
	ribbonText.Size = UDim2.fromScale(1, 1)
	ribbonText.BackgroundTransparency = 1
	ribbonText.Font = Enum.Font.GothamBlack
	ribbonText.TextScaled = true
	ribbonText.TextColor3 = Color3.fromRGB(25, 25, 30)
	ribbonText.Text = string.upper(band.displayName)
	ribbonText.Parent = ribbon

	local nameLabel = Instance.new("TextLabel")
	nameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	nameLabel.Position = UDim2.new(0.5, 0, 0.42, 0)
	nameLabel.Size = UDim2.new(0.9, 0, 0.22, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.TextScaled = true
	nameLabel.TextWrapped = true
	nameLabel.TextColor3 = Color3.fromRGB(35, 35, 40)
	nameLabel.Text = payload.name
	nameLabel.Parent = inner

	local subLabel = Instance.new("TextLabel")
	subLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	subLabel.Position = UDim2.new(0.5, 0, 0.62, 0)
	subLabel.Size = UDim2.new(0.9, 0, 0.09, 0)
	subLabel.BackgroundTransparency = 1
	subLabel.Font = Enum.Font.GothamBold
	subLabel.TextScaled = true
	subLabel.TextColor3 = Color3.fromRGB(90, 90, 100)
	subLabel.Text = payload.sport .. " · " .. foil.displayName
	subLabel.Parent = inner

	local valueLabel = Instance.new("TextLabel")
	valueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	valueLabel.Position = UDim2.new(0.5, 0, 0.78, 0)
	valueLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.GothamBlack
	valueLabel.TextScaled = true
	valueLabel.TextColor3 = Color3.fromRGB(30, 140, 60)
	valueLabel.Text = EconomyConfig.formatMoney(payload.value) .. "/Card"
	valueLabel.Parent = inner

	local fromLabel = Instance.new("TextLabel")
	fromLabel.AnchorPoint = Vector2.new(0.5, 1)
	fromLabel.Position = UDim2.new(0.5, 0, 1, -60)
	fromLabel.Size = UDim2.new(0.9, 0, 0, 22)
	fromLabel.BackgroundTransparency = 1
	fromLabel.Font = Enum.Font.Gotham
	fromLabel.TextScaled = true
	fromLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
	fromLabel.Text = "from " .. tostring(payload.packName)
	fromLabel.Parent = overlay

	local collect = Instance.new("TextButton")
	collect.AnchorPoint = Vector2.new(0.5, 1)
	collect.Position = UDim2.new(0.5, 0, 1, -28)
	collect.Size = UDim2.new(0, 220, 0, 44)
	collect.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
	collect.Font = Enum.Font.GothamBold
	collect.TextScaled = true
	collect.TextColor3 = Color3.fromRGB(255, 255, 255)
	collect.Text = "COLLECT"
	collect.Parent = overlay
	local collectCorner = Instance.new("UICorner")
	collectCorner.CornerRadius = UDim.new(0, 10)
	collectCorner.Parent = collect

	-- pop-in
	local target = UDim2.new(0, 320, 0, 460)
	local tween = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = target })
	tween:Play()

	local function dismiss()
		overlay:Destroy()
	end
	collect.MouseButton1Click:Connect(dismiss)
	-- safety auto-dismiss so a lost click never soft-locks the screen
	task.delay(20, function()
		if overlay.Parent then
			overlay:Destroy()
		end
	end)
end

function RevealController.OnStart(self: any)
	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CardRevealed").OnClientEvent:Connect(function(payload)
		-- settings toggle (spec §4: Pack Reveal Effect) — off = skip the ceremony
		if player:GetAttribute("Setting_PackReveal") == false then
			return
		end
		showReveal(payload)
	end)
	print("[RevealController] Ready")
end

return RevealController
