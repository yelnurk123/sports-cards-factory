--!strict
-- SellController — the Card Hunter dialog (flow spec v1.1 F4, rewritten for
-- M1.1). The 5 reference options verbatim; bulk options ask the server for a
-- quote and show an enumerated confirmation (count per type + total payout)
-- BEFORE committing (hub ruling 2026-08-10: no silent card selling). Cards
-- sell at 50% of value; carried boxes are never sold here — they cash out 1:1
-- by walking into the green Sell zone. The server recomputes everything at
-- commit time; this panel is display-only.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local BandConfig = require(Shared.BandConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local SellController = {}

local player = Players.LocalPlayer
local panel: Frame = nil :: any
local body: Frame = nil :: any
local latestStorage: { any } = {}

local pendingOption: string? = nil
local pendingUid: string? = nil

local OPTIONS = {
	{ key = "inventory", label = "I want to sell my Inventory" },
	{ key = "this", label = "I want to sell this" },
	{ key = "cards", label = "I want to sell my cards only" },
	{ key = "packs", label = "I want to sell my packs only" },
	{ key = "nevermind", label = "Nevermind" },
}

local function remotes(): Folder
	return ReplicatedStorage:WaitForChild("Remotes") :: Folder
end

local function clearBody()
	for _, child in body:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
end

local function makeButton(parent: Instance, text: string, color: Color3): TextButton
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 44)
	button.BackgroundColor3 = color
	button.Font = Enum.Font.GothamBold
	button.TextScaled = true
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = text
	button.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	return button
end

local function showMenu()
	clearBody()
	local npcLine = Instance.new("TextLabel")
	npcLine.Size = UDim2.new(1, 0, 0, 30)
	npcLine.BackgroundTransparency = 1
	npcLine.Font = Enum.Font.Gotham
	npcLine.TextScaled = true
	npcLine.TextColor3 = Color3.fromRGB(255, 230, 150)
	npcLine.Text = '"Got anything to sell?"'
	npcLine.Parent = body

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 1, -38)
	list.Position = UDim2.new(0, 0, 0, 38)
	list.BackgroundTransparency = 1
	list.Parent = body
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = list

	for _, option in OPTIONS do
		local color = if option.key == "nevermind" then Color3.fromRGB(90, 92, 100) else Color3.fromRGB(60, 90, 140)
		local button = makeButton(list, option.label, color)
		button.MouseButton1Click:Connect(function()
			if option.key == "nevermind" then
				panel.Visible = false
				return
			end
			if option.key == "this" then
				-- carried box: the zone is its only cash-out path (1:1);
				-- carried pack: quotable here; empty hands: pick a card
				if (player:GetAttribute("CarriedBoxValue") or 0) > 0 then
					remotes():WaitForChild("SellDialog"):FireServer("this")
					return
				end
				if player:GetAttribute("CarriedPack") then
					remotes():WaitForChild("SellDialog"):FireServer("this")
					return
				end
				SellController:ShowCardPicker()
				return
			end
			remotes():WaitForChild("SellDialog"):FireServer(option.key)
		end)
	end
end

function SellController.ShowCardPicker(self: any)
	clearBody()
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.Text = "Sell which card? (50% of value)"
	header.Parent = body

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, 0, 1, -84)
	list.Position = UDim2.new(0, 0, 0, 36)
	list.BackgroundTransparency = 1
	list.ScrollBarThickness = 6
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.Parent = body
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = list

	if #latestStorage == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.new(1, 0, 0, 40)
		empty.BackgroundTransparency = 1
		empty.Font = Enum.Font.Gotham
		empty.TextScaled = true
		empty.TextColor3 = Color3.fromRGB(180, 180, 190)
		empty.Text = "No cards yet — buy a pack off the belt!"
		empty.Parent = list
	end
	for _, entry in latestStorage do
		local card = CardConfig.get(entry.cardID)
		local band = BandConfig.get(card.band)
		local row = makeButton(
			list,
			card.name
				.. " · " .. EconomyConfig.formatMoney(entry.value) .. "/Card → SELL "
				.. EconomyConfig.formatMoney(EconomyConfig.sellPrice(entry.value))
				.. (entry.displayed and "  · on display" or ""),
			Color3.fromRGB(35, 38, 45)
		)
		row.TextXAlignment = Enum.TextXAlignment.Left
		local chip = Instance.new("Frame")
		chip.Size = UDim2.new(0, 6, 0.7, 0)
		chip.Position = UDim2.new(1, -12, 0.15, 0)
		chip.BackgroundColor3 = band.ribbonColor
		chip.BorderSizePixel = 0
		chip.Parent = row
		row.MouseButton1Click:Connect(function()
			remotes():WaitForChild("SellDialog"):FireServer("card", entry.uid)
		end)
	end

	local back = makeButton(body, "Back", Color3.fromRGB(90, 92, 100))
	back.AnchorPoint = Vector2.new(0, 1)
	back.Position = UDim2.new(0, 0, 1, 0)
	back.Size = UDim2.new(1, 0, 0, 40)
	back.MouseButton1Click:Connect(showMenu)
end

local function showQuote(payload: any)
	clearBody()
	pendingOption = payload.option
	pendingUid = payload.uid

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.Text = "Confirm sale"
	header.Parent = body

	if payload.note or #(payload.lines or {}) == 0 then
		local note = Instance.new("TextLabel")
		note.Size = UDim2.new(1, 0, 1, -84)
		note.Position = UDim2.new(0, 0, 0, 36)
		note.BackgroundTransparency = 1
		note.Font = Enum.Font.Gotham
		note.TextScaled = true
		note.TextWrapped = true
		note.TextColor3 = Color3.fromRGB(200, 200, 210)
		note.Text = payload.note or "Nothing to sell."
		note.Parent = body
		local back = makeButton(body, "Back", Color3.fromRGB(90, 92, 100))
		back.AnchorPoint = Vector2.new(0, 1)
		back.Position = UDim2.new(0, 0, 1, 0)
		back.Size = UDim2.new(1, 0, 0, 40)
		back.MouseButton1Click:Connect(showMenu)
		return
	end

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, 0, 1, -136)
	list.Position = UDim2.new(0, 0, 0, 36)
	list.BackgroundTransparency = 1
	list.ScrollBarThickness = 6
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.Parent = body
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = list
	for _, line in payload.lines do
		local row = Instance.new("TextLabel")
		row.Size = UDim2.new(1, 0, 0, 34)
		row.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
		row.Font = Enum.Font.GothamBold
		row.TextScaled = true
		row.TextColor3 = Color3.fromRGB(235, 235, 240)
		row.Text = "  " .. line.text .. "  →  " .. EconomyConfig.formatMoney(line.subtotal)
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.Parent = list
		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 8)
		rowCorner.Parent = row
	end

	local total = Instance.new("TextLabel")
	total.AnchorPoint = Vector2.new(0, 1)
	total.Position = UDim2.new(0, 0, 1, -88)
	total.Size = UDim2.new(1, 0, 0, 30)
	total.BackgroundTransparency = 1
	total.Font = Enum.Font.GothamBlack
	total.TextScaled = true
	total.TextColor3 = Color3.fromRGB(140, 255, 140)
	total.Text = "TOTAL PAYOUT: " .. EconomyConfig.formatMoney(payload.total)
	total.Parent = body

	local confirm = makeButton(body, "CONFIRM SALE", Color3.fromRGB(60, 180, 80))
	confirm.AnchorPoint = Vector2.new(0, 1)
	confirm.Position = UDim2.new(0, 0, 1, -44)
	confirm.Size = UDim2.new(1, 0, 0, 40)
	confirm.MouseButton1Click:Connect(function()
		remotes():WaitForChild("SellConfirm"):FireServer(pendingOption, pendingUid)
		panel.Visible = false
	end)

	local cancel = makeButton(body, "CANCEL", Color3.fromRGB(180, 60, 60))
	cancel.AnchorPoint = Vector2.new(0, 1)
	cancel.Position = UDim2.new(0, 0, 1, 0)
	cancel.Size = UDim2.new(1, 0, 0, 40)
	cancel.MouseButton1Click:Connect(showMenu)
end

function SellController.Open(self: any)
	showMenu()
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
	title.Text = "CARD HUNTER"
	title.Parent = panel

	body = Instance.new("Frame")
	body.Name = "Body"
	body.Size = UDim2.new(1, -20, 1, -60)
	body.Position = UDim2.new(0, 10, 0, 52)
	body.BackgroundTransparency = 1
	body.Parent = panel

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

	-- server quotes land on the confirmation screen
	remotes():WaitForChild("SellQuote").OnClientEvent:Connect(function(payload)
		if type(payload) == "table" and panel.Visible then
			showQuote(payload)
		end
	end)

	-- keep the card list fresh for the picker
	remotes():WaitForChild("CardsSync").OnClientEvent:Connect(function(payload)
		if type(payload) == "table" and type(payload.storage) == "table" then
			latestStorage = payload.storage
		end
	end)

	print("[SellController] Ready (Card Hunter dialog: 5 options, confirm-first)")
end

return SellController
