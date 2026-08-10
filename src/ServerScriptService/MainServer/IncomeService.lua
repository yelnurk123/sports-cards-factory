--!strict
-- IncomeService — the drip (flow spec v1.3 F3). Canon numbers unchanged
-- (economy §2f): each DISPLAYED card drops one token worth its current $/Card
-- every ~5s; "$/s" = Σ ÷ 5. Tokens drop onto the token lane ADJACENT to the
-- card's pedestal and ride to that lane's box point at the base's front edge.
-- Box mechanics (v1.2/v1.3, hub rulings 2026-08-11): a box fills with exactly
-- 8 token-cards → a new empty box spawns ON TOP (vertical stack, cap 5 — the
-- drip pauses while a 6th would be needed); "E Carry $X" takes the WHOLE
-- stack (value = Σ of all token-cards in all boxes, shown on the prompt), a
-- fresh empty box starts filling after. The "You make: $X/s" sign and BEST
-- CARD board keep ticking regardless.

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

local TOKEN_RIDE_TIME = 1.6 -- seconds from pedestal to the box point
local BOX_SIZE = Vector3.new(3.2, 1.8, 3.2)
local BOX_FILL = EconomyConfig.BOX_FILL_COUNT -- exactly 8 token-cards per box
local STACK_CAP = EconomyConfig.MAX_UNCOLLECTED_BOXES -- 5 boxes per box point

type Box = { fill: number, value: number }

-- per-player, per-lane box stacks; the LAST entry is the top box
local stacks: { [Player]: { [number]: { Box } } } = {}

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

local function getStack(player: Player, laneIdx: number): { Box }
	local perPlayer = stacks[player]
	if not perPlayer then
		perPlayer = {}
		stacks[player] = perPlayer
	end
	local stack = perPlayer[laneIdx]
	if not stack then
		stack = {}
		perPlayer[laneIdx] = stack
	end
	if #stack == 0 then
		table.insert(stack, { fill = 0, value = 0 })
	end
	return stack
end

-- Rebuilds one lane's box-stack visuals from state (≤5 boxes) and refreshes
-- the carry prompt (Σ of the WHOLE stack, flow v1.3 F3.18) + the floating
-- box-point label (the top box's own fill).
local function rebuildLaneVisuals(player: Player, laneIdx: number)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	local lane = plot.lanes[laneIdx]
	if not lane then
		return
	end
	local stack = getStack(player, laneIdx)
	lane.stackFolder:ClearAllChildren()
	local baseCF = lane.pallet.CFrame
	for i, box in stack do
		local boxPart = Instance.new("Part")
		boxPart.Name = "Box" .. i
		boxPart.Size = BOX_SIZE
		boxPart.Color = Color3.fromRGB(196, 150, 95)
		boxPart.Material = Enum.Material.Cardboard
		boxPart.Anchored = true
		boxPart.CanCollide = false
		boxPart.CFrame = baseCF * CFrame.new(0, 0.2 + (i - 0.5) * BOX_SIZE.Y, 0)
		boxPart.Parent = lane.stackFolder
		-- the TOP box shows the token-cards physically inside it (flow v1.2)
		if i == #stack and box.fill > 0 then
			for j = 1, box.fill do
				local mini = Instance.new("Part")
				mini.Name = "Token" .. j
				mini.Size = Vector3.new(0.7, 1, 0.15)
				mini.Color = Color3.fromRGB(245, 240, 220)
				mini.Material = Enum.Material.SmoothPlastic
				mini.Anchored = true
				mini.CanCollide = false
				mini.CanQuery = false
				local col = (j - 1) % 4
				local row = math.floor((j - 1) / 4)
				mini.CFrame = boxPart.CFrame
					* CFrame.new(-1.05 + col * 0.7, BOX_SIZE.Y / 2 + 0.4, -0.45 + row * 0.9)
					* CFrame.Angles(0, math.rad(-8 + col * 5), 0)
				mini.Parent = lane.stackFolder
			end
		end
	end
	local top = stack[#stack]
	local sum = 0
	for _, box in stack do
		sum += box.value
	end
	lane.carryPrompt.ObjectText = EconomyConfig.formatMoney(sum)
		.. " · "
		.. tostring(#stack)
		.. (if #stack == 1 then " box" else " boxes")
	lane.valueLabel.Text = tostring(top.fill) .. "/" .. tostring(BOX_FILL) .. " · " .. EconomyConfig.formatMoney(top.value)
end

local function updateRateSigns(player: Player, sum: number)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	plot.rateSignLabel.Text = "You make: " .. EconomyConfig.formatRate(EconomyConfig.incomePerSecond(sum))
	plot.bestCardLabel.Text = "BEST CARD " .. EconomyConfig.formatMoney(player:GetAttribute("BestCardValue") or 0) .. "/Card"
end

-- Adds one arrived token to the top box of a lane; spawns a fresh empty box
-- ON TOP when one fills (v1.2 F3.16). Returns false when the stack is capped.
local function addToken(player: Player, laneIdx: number, value: number)
	local stack = getStack(player, laneIdx)
	local top = stack[#stack]
	if top.fill >= BOX_FILL then
		if #stack >= STACK_CAP then
			return false -- drip paused at the 5-box cap (v1.2 F3.17)
		end
		table.insert(stack, { fill = 0, value = 0 })
		top = stack[#stack]
	end
	top.fill += 1
	top.value += value
	if top.fill >= BOX_FILL and #stack < STACK_CAP then
		table.insert(stack, { fill = 0, value = 0 }) -- new empty box spawns ON TOP
	end
	rebuildLaneVisuals(player, laneIdx)
	return true
end

-- One token per displayed card per tick: spawns at the card's pedestal, rides
-- its adjacent lane to the box point, and lands in the top box on arrival.
local function dropToken(player: Player, slotKey: string, value: number)
	local plot = WorldService:GetPlot(player)
	if not plot then
		return
	end
	local laneIdx = plot.displaySlotLane[slotKey]
	local lane = laneIdx and plot.lanes[laneIdx]
	local slotCF = plot.displaySlots[slotKey]
	if not lane or not slotCF then
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
	token.CFrame = slotCF * CFrame.new(0, 1.5, 0)
	token.Parent = workspace

	local tween = TweenService:Create(token, TweenInfo.new(TOKEN_RIDE_TIME, Enum.EasingStyle.Linear), { CFrame = CFrame.new(lane.tokenTarget) })
	tween:Play()
	tween.Completed:Connect(function()
		token:Destroy()
		if not player:IsDescendantOf(Players) then
			return
		end
		addToken(player, laneIdx, value)
	end)
	-- failsafe so a cancelled tween never leaks parts
	task.delay(TOKEN_RIDE_TIME + 2, function()
		if token.Parent then
			token:Destroy()
		end
	end)
end

function IncomeService.OnStart(self: any)
	-- carry: the WHOLE stack at a box point goes into hand (flow v1.3 F3.18) —
	-- value = Σ of every token-card in every stacked box; a fresh empty box
	-- starts filling after. One carried batch at a time.
	ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
		if prompt:GetAttribute("Tag") ~= "CarryBox" then
			return
		end
		if prompt:GetAttribute("OwnerUserId") ~= player.UserId then
			PlacementService:Notify(player, "That's not your box point!")
			return
		end
		local laneIdx = prompt:GetAttribute("Lane")
		if type(laneIdx) ~= "number" then
			return
		end
		local stack = getStack(player, laneIdx)
		local sum = 0
		for _, box in stack do
			sum += box.value
		end
		if sum <= 0 then
			PlacementService:Notify(player, "Boxes are empty — displayed cards drip tokens into them every " .. tostring(EconomyConfig.BOX_INTERVAL) .. "s")
			return
		end
		local ok, err = CarryService:GiveBox(player, sum)
		if not ok then
			PlacementService:Notify(player, err or "Can't carry those boxes right now")
			return
		end
		stacks[player][laneIdx] = { { fill = 0, value = 0 } } -- fresh empty box starts filling
		rebuildLaneVisuals(player, laneIdx)
		PlacementService:Notify(player, "Carrying " .. EconomyConfig.formatMoney(sum) .. " — sell it to your plot's Sell vendor!")
	end)

	Players.PlayerRemoving:Connect(function(player)
		stacks[player] = nil
	end)

	-- one shared tick (economy §2f cadence); per-player, per-lane accumulation
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
				updateRateSigns(player, sum)
				if sum <= 0 then
					continue
				end
				local plot = WorldService:GetPlot(player)
				if not plot then
					continue
				end
				for slotKey, uid in data.displayed do
					local rec = data.storage[uid]
					if not rec then
						continue
					end
					-- per-lane cap check (v1.2 F3.17): the drip pauses on a lane
					-- whose stack holds 5 boxes with a full one on top
					local laneIdx = plot.displaySlotLane[slotKey]
					if laneIdx then
						local stack = getStack(player, laneIdx)
						local top = stack[#stack]
						if top.fill >= BOX_FILL and #stack >= STACK_CAP then
							continue
						end
						dropToken(player, slotKey, rec.valueCache)
					end
				end
			end
		end
	end)

	print("[IncomeService] Ready (v1.3: tokens → lane box points; 8-fill boxes stack to 5; Carry takes the whole stack)")
end

return IncomeService
