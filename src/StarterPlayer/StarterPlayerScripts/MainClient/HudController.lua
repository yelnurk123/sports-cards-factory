--!strict
-- HudController — M1 blockout HUD (spec §11 layout, plain Luau + Icon topbar).
-- Bottom readout: cash + "You make: $X/s" + displayed count (the numbers-go-up
-- strip). Top nav teleports (Plaza / Base / Sell); left rail icons: Index
-- (works), Shop / Upgrade / Items (Coming Soon placeholders). Also owns the
-- toast line every service can notify through.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local EconomyConfig = require(Shared.EconomyConfig)
local PlotLayout = require(Shared.PlotLayout)
local Icon = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Icon"))

local HudController = {}

local player = Players.LocalPlayer
local cashLabel: TextLabel = nil :: any
local rateLabel: TextLabel = nil :: any
local displayedLabel: TextLabel = nil :: any
local toastLabel: TextLabel = nil :: any
local toastToken = 0

local function teleportTo(pos: Vector3)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(pos)
	end
end

local function makeLabel(parent: Instance, name: string, text: string): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = text
	label.Parent = parent
	return label
end

function HudController.Toast(self: any, text: string)
	if not toastLabel then
		return
	end
	toastToken += 1
	local token = toastToken
	toastLabel.Text = text
	toastLabel.TextTransparency = 0
	task.spawn(function()
		task.wait(3)
		if toastToken == token then
			toastLabel.TextTransparency = 1
		end
	end)
end

local function refreshMirror(attr: string)
	if attr == "Cash" or attr == nil then
		cashLabel.Text = EconomyConfig.formatMoney(player:GetAttribute("Cash") or 0)
	end
	if attr == "IncomeRate" or attr == nil then
		rateLabel.Text = "You make: " .. EconomyConfig.formatRate(player:GetAttribute("IncomeRate") or 0)
	end
	if attr == "DisplayedCount" or attr == nil then
		displayedLabel.Text = "Displayed: " .. tostring(player:GetAttribute("DisplayedCount") or 0) .. "/" .. tostring(EconomyConfig.DISPLAY_SLOTS_START)
	end
end

function HudController.OnStart(self: any)
	local gui = Instance.new("ScreenGui")
	gui.Name = "SCF_HUD"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.Parent = player:WaitForChild("PlayerGui")

	-- bottom readout strip (spec §11: multiplier readout always visible)
	local strip = Instance.new("Frame")
	strip.Name = "BottomStrip"
	strip.AnchorPoint = Vector2.new(0.5, 1)
	strip.Position = UDim2.new(0.5, 0, 1, -12)
	strip.Size = UDim2.new(0, 560, 0, 48)
	strip.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
	strip.BackgroundTransparency = 0.15
	strip.BorderSizePixel = 0
	strip.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = strip

	local cashBox = Instance.new("Frame")
	cashBox.Size = UDim2.new(0.3, 0, 1, 0)
	cashBox.BackgroundTransparency = 1
	cashBox.Parent = strip
	cashLabel = makeLabel(cashBox, "Cash", "$0")
	cashLabel.TextColor3 = Color3.fromRGB(140, 255, 140)

	local rateBox = Instance.new("Frame")
	rateBox.Position = UDim2.new(0.3, 0, 0, 0)
	rateBox.Size = UDim2.new(0.4, 0, 1, 0)
	rateBox.BackgroundTransparency = 1
	rateBox.Parent = strip
	rateLabel = makeLabel(rateBox, "Rate", "You make: $0/s")
	rateLabel.TextColor3 = Color3.fromRGB(180, 230, 255)

	local displayedBox = Instance.new("Frame")
	displayedBox.Position = UDim2.new(0.7, 0, 0, 0)
	displayedBox.Size = UDim2.new(0.3, 0, 1, 0)
	displayedBox.BackgroundTransparency = 1
	displayedBox.Parent = strip
	displayedLabel = makeLabel(displayedBox, "Displayed", "Displayed: 0/10")
	displayedLabel.TextColor3 = Color3.fromRGB(220, 220, 225)

	-- toast line (server Notify remote lands here)
	toastLabel = Instance.new("TextLabel")
	toastLabel.Name = "Toast"
	toastLabel.AnchorPoint = Vector2.new(0.5, 1)
	toastLabel.Position = UDim2.new(0.5, 0, 1, -72)
	toastLabel.Size = UDim2.new(0, 640, 0, 30)
	toastLabel.BackgroundTransparency = 1
	toastLabel.Font = Enum.Font.GothamBold
	toastLabel.TextScaled = true
	toastLabel.TextColor3 = Color3.fromRGB(255, 240, 180)
	toastLabel.TextStrokeTransparency = 0.5
	toastLabel.TextTransparency = 1
	toastLabel.Text = ""
	toastLabel.Parent = gui

	local remotes = ReplicatedStorage:WaitForChild("Remotes")
	remotes:WaitForChild("Notify").OnClientEvent:Connect(function(payload)
		if type(payload) == "table" and type(payload.text) == "string" then
			HudController:Toast(payload.text)
		end
	end)

	-- attribute mirrors from DataService.SyncMirror / IncomeService
	player:GetAttributeChangedSignal("Cash"):Connect(function()
		refreshMirror("Cash")
	end)
	player:GetAttributeChangedSignal("IncomeRate"):Connect(function()
		refreshMirror("IncomeRate")
	end)
	player:GetAttributeChangedSignal("DisplayedCount"):Connect(function()
		refreshMirror("DisplayedCount")
	end)
	refreshMirror(nil)

	-- top nav teleports (spec §11: Plaza / Base / Sell). Momentary buttons:
	-- act on "selected", then drop the highlight straight away.
	local function momentary(name: string, tip: string, action: () -> ())
		local icon = Icon.new()
			:setName(name)
			:setLabel(name)
			:setTip(tip)
		icon:setEvent("selected", function()
			action()
			icon:deselect()
		end)
		return icon
	end

	momentary("Plaza", "Teleport to the Plaza", function()
		teleportTo(PlotLayout.PlazaSpot)
	end)

	momentary("Base", "Teleport to your plot", function()
		local idx = player:GetAttribute("PlotIndex")
		if idx then
			teleportTo(PlotLayout.center(idx).Position + Vector3.new(0, 4, -14))
		else
			HudController:Toast("No plot yet!")
		end
	end)

	momentary("Sell", "Teleport to the Sell stall", function()
		teleportTo(PlotLayout.SellSpot)
	end)

	-- left rail (spec §11): Index works; Shop/Upgrade/Items are Coming Soon
	local indexIcon = Icon.new()
		:setName("Index")
		:setLabel("Index")
		:setTip("Collection catalog")
	indexIcon:setEvent("selected", function()
		local IndexController = require(script.Parent.IndexController)
		IndexController:Toggle()
	end)
	indexIcon:setEvent("deselected", function()
		local IndexController = require(script.Parent.IndexController)
		IndexController:Hide()
	end)

	for _, name in { "Shop", "Upgrade", "Items" } do
		momentary(name, name .. " — coming soon", function()
			HudController:Toast(name .. " is coming in a later milestone!")
		end)
	end

	print("[HudController] Ready")
end

return HudController
