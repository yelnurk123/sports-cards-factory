--!strict
-- IncomeService — the drip (flow spec v1.1 F3, rewritten for M1.1). Canon
-- numbers unchanged (economy §2f + hub ruling 2026-08-10): each DISPLAYED card
-- drops one token worth its current $/Card every ~5s; "$/s" = Σ ÷ 5. The M1
-- blockout spawned touch-to-collect cash boxes per plot — replaced by the
-- frame-verified topology: tokens ride the plot's ONE shared token lane
-- (separate from the pack belt) into ONE wooden crate at the lane's end. The
-- crate accumulates (value = Σ tokens since last collect, 5-box cap kept);
-- collecting puts the box in the player's hand (CarryService) and a fresh
-- crate starts filling. The "You make: $X/s" sign by the crate is a rate
-- readout and keeps ticking regardless of collection state.

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local WorldService = require(script.Parent.WorldService)
local CarryService = require(script.Parent.CarryService)
local PlacementService = require(script.Parent.PlacementService)

local IncomeService = {}

local TOKEN_RIDE_TIME = 1.6 -- seconds from lane start into the crate
local CRATE_FILL_MAX = 2.6 -- studs of fill at the cap

local crateValue: { [Player]: number } = {} -- Σ tokens since last collect
local lastSum: { [Player]: number } = {} -- Σ displayed at the latest tick (cap base + sign)

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

local function updateCrateVisuals(player: Player)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	local value = crateValue[player] or 0
	plot.crateValueLabel.Text = EconomyConfig.formatMoney(value)
	local cap = math.max((lastSum[player] or 0) * EconomyConfig.MAX_UNCOLLECTED_BOXES, 1)
	local frac = math.clamp(value / cap, 0, 1)
	local height = 0.2 + CRATE_FILL_MAX * frac
	plot.crateFill.Size = Vector3.new(2.4, height, 2.4)
	local crateCF = plot.cratePart.CFrame
	plot.crateFill.CFrame = CFrame.new(crateCF.X, crateCF.Y - 1.5 + height / 2, crateCF.Z)
	plot.crateFill.Color = if frac >= 1 then Color3.fromRGB(255, 120, 80) else Color3.fromRGB(255, 205, 40)
end

local function updateRateSign(player: Player, sum: number)
	local plot = WorldService:GetPlot(player)
	if plot then
		plot.crateSignLabel.Text = "You make: " .. EconomyConfig.formatRate(EconomyConfig.incomePerSecond(sum))
	end
end

-- One token per displayed card per tick: spawns at the lane start, rides into
-- the crate, and its value lands in the crate total on arrival.
local function dropToken(player: Player, value: number)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	local token = Instance.new("Part")
	token.Name = "CardToken"
	token.Size = Vector3.new(1, 1.4, 0.15)
	token.Color = Color3.fromRGB(245, 240, 220)
	token.Material = Enum.Material.SmoothPlastic
	token.Anchored = true
	token.CanCollide = false
	token.CanQuery = false
	token.CFrame = CFrame.new(plot.laneStart)
	token.Parent = workspace

	local tween = TweenService:Create(token, TweenInfo.new(TOKEN_RIDE_TIME, Enum.EasingStyle.Linear), { CFrame = CFrame.new(plot.laneEnd) })
	tween:Play()
	tween.Completed:Connect(function()
		token:Destroy()
		if not player:IsDescendantOf(Players) then
			return
		end
		crateValue[player] = (crateValue[player] or 0) + value
		updateCrateVisuals(player)
	end)
	-- failsafe so a cancelled tween never leaks parts
	task.delay(TOKEN_RIDE_TIME + 2, function()
		if token.Parent then
			token:Destroy()
		end
	end)
end

function IncomeService.OnStart(self: any)
	-- collect: the crate becomes a carried box; a fresh crate starts filling
	ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
		if prompt:GetAttribute("Tag") ~= "CollectCrate" then
			return
		end
		if prompt:GetAttribute("OwnerUserId") ~= player.UserId then
			PlacementService:Notify(player, "That's not your crate!")
			return
		end
		local value = crateValue[player] or 0
		if value <= 0 then
			PlacementService:Notify(player, "Crate is empty — displayed cards drip tokens into it every " .. tostring(EconomyConfig.BOX_INTERVAL) .. "s")
			return
		end
		local ok, err = CarryService:GiveBox(player, value)
		if not ok then
			PlacementService:Notify(player, err or "Can't carry that box right now")
			return
		end
		crateValue[player] = 0
		updateCrateVisuals(player)
		PlacementService:Notify(player, "Carrying " .. EconomyConfig.formatMoney(value) .. " — walk it into the green Sell zone!")
	end)

	Players.PlayerRemoving:Connect(function(player)
		crateValue[player] = nil
		lastSum[player] = nil
	end)

	-- one shared tick (economy §2f cadence); per-player crate accumulation
	task.spawn(function()
		while true do
			task.wait(EconomyConfig.BOX_INTERVAL)
			for _, player in Players:GetPlayers() do
				local data = DataService:GetData(player)
				if not data then
					continue
				end
				local sum = displayedSum(data)
				lastSum[player] = sum
				player:SetAttribute("IncomeRate", EconomyConfig.incomePerSecond(sum))
				updateRateSign(player, sum)
				if sum <= 0 then
					continue
				end
				-- 5-box uncollected cap (canon): the drip pauses while the
				-- crate holds 5 ticks' worth; the rate sign keeps ticking
				if (crateValue[player] or 0) >= sum * EconomyConfig.MAX_UNCOLLECTED_BOXES then
					continue
				end
				for _, uid in data.displayed do
					local rec = data.storage[uid]
					if rec then
						dropToken(player, rec.valueCache)
					end
				end
			end
		end
	end)

	print("[IncomeService] Ready (tokens ride the lane into the crate, every " .. tostring(EconomyConfig.BOX_INTERVAL) .. "s)")
end

return IncomeService
