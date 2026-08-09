--!strict
-- IncomeService — the idle drip, BUILT NEW on Fish a Brainrot's per-plot
-- accrual pattern (audit §4/§6). Canon numbers only (economy §2f + hub ruling
-- 2026-08-10): every ~5s a box spawns on the player's plot worth Σ(all
-- displayed cards' values); HUD "$/s" = Σ ÷ 5. Boxes are touched to collect.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local WorldService = require(script.Parent.WorldService)

local IncomeService = {}

local boxes: { [Player]: { Part } } = {} -- uncollected boxes per player

local function displayedSum(data: any): number
	local sum = 0
	for _, uid in data.displayed do
		local rec = data.storage[uid]
		if rec then
			sum += rec.valueCache
		end
	end
	return sum
end

local function countBoxes(player: Player): number
	local list = boxes[player]
	if not list then
		return 0
	end
	local n = 0
	for _, box in list do
		if box.Parent then
			n += 1
		end
	end
	return n
end

local function spawnBox(player: Player, value: number)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	local box = Instance.new("Part")
	box.Name = "CashBox"
	box.Size = Vector3.new(1.6, 1.6, 1.6)
	box.Color = Color3.fromRGB(255, 205, 40)
	box.Material = Enum.Material.SmoothPlastic
	box.Anchored = true
	box.CanCollide = false
	box.CFrame = CFrame.new(plot.boxSpawnPos + Vector3.new(math.random(-10, 10) / 10, math.random(0, 10) / 10, math.random(-20, 20) / 10))
	box:SetAttribute("Value", value)

	local bb = Instance.new("BillboardGui")
	bb.Name = "Value"
	bb.Size = UDim2.fromOffset(140, 32)
	bb.StudsOffset = Vector3.new(0, 1.8, 0)
	bb.AlwaysOnTop = true
	bb.Parent = box
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = EconomyConfig.formatMoney(value)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(180, 255, 140)
	label.TextStrokeTransparency = 0.5
	label.Parent = bb

	boxes[player] = boxes[player] or {}
	table.insert(boxes[player], box)

	box.Touched:Connect(function(hit)
		if not box.Parent then
			return
		end
		local toucher = Players:GetPlayerFromCharacter(hit.Parent)
			or Players:GetPlayerFromCharacter(hit.Parent and hit.Parent.Parent)
		if toucher ~= player then
			return
		end
		local data = DataService:GetData(player)
		if not data then
			return
		end
		box:Destroy()
		data.cash += value
		DataService:SyncMirror(player)
	end)

	box.Parent = workspace
end

function IncomeService.OnStart(self: any)
	Players.PlayerRemoving:Connect(function(player)
		if boxes[player] then
			for _, box in boxes[player] do
				if box.Parent then
					box:Destroy()
				end
			end
			boxes[player] = nil
		end
	end)

	-- one shared tick; each loaded player spawns a box worth Σ(displayed values)
	task.spawn(function()
		while true do
			task.wait(EconomyConfig.BOX_INTERVAL)
			for _, player in Players:GetPlayers() do
				local data = DataService:GetData(player)
				if not data then
					continue
				end
				local sum = displayedSum(data)
				player:SetAttribute("IncomeRate", EconomyConfig.incomePerSecond(sum))
				if sum <= 0 then
					continue
				end
				if countBoxes(player) >= EconomyConfig.MAX_UNCOLLECTED_BOXES then
					continue
				end
				spawnBox(player, sum)
			end
		end
	end)

	print("[IncomeService] Ready (box every " .. tostring(EconomyConfig.BOX_INTERVAL) .. "s = Σ displayed)")
end

return IncomeService
