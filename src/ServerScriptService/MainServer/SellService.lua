--!strict
-- SellService — cashing out (flow spec v1.3 F4, M1.2.1).
-- TWO paths, frame-verified:
--  1. CARD BOXES: walking into a green "Sell Card Boxes!" zone while carrying
--     boxes cashes them instantly at 1:1 (boxes ARE earned income; the 50%
--     rate never applies). The canonical zone is each base's OWN vendor pad
--     (env v1.1 E1.16a, owner-only); the plaza Sell zone is a duplicate.
--  2. VENDOR DIALOG (inventory only): the 5 reference options verbatim;
--     cards sell at the deliberate 50% of value. Bulk options show a quote
--     enumerating contents (count per type + total payout) and only commit on
--     an explicit confirm (hub ruling 2026-08-10: no silent card selling).
-- Packs (carried) sell at 50% of pack price — same deliberate-half pattern;
-- no canon pack rate exists yet (flagged in the M1.1 result note).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local PackConfig = require(Shared.PackConfig)
local FoilConfig = require(Shared.FoilConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local PlacementService = require(script.Parent.PlacementService)
local CarryService = require(script.Parent.CarryService)
local WorldService = require(script.Parent.WorldService)

local SellService = {}

local dialogRemote: RemoteEvent = nil :: any
local confirmRemote: RemoteEvent = nil :: any
local quoteRemote: RemoteEvent = nil :: any

local lastZoneSell: { [Player]: number } = {}

export type QuoteLine = { text: string, subtotal: number }
export type Quote = { lines: { QuoteLine }, total: number, note: string?, uids: { string }, sellsCarriedPack: boolean }

-- Builds the exact contents a dialog option would sell right now. Commit
-- recomputes from live data, so a quote can never promise stale contents.
local function computeQuote(player: Player, data: any, option: string, uid: string?): Quote
	local quote: Quote = { lines = {}, total = 0, note = nil, uids = {}, sellsCarriedPack = false }

	local function addCards(filterUid: string?)
		local groups: { [string]: { count: number, subtotal: number, label: string } } = {}
		local order: { string } = {}
		for cardUid, rec in data.storage do
			if filterUid and cardUid ~= filterUid then
				continue
			end
			local card = CardConfig.get(rec.cardID)
			local foilName = FoilConfig.get(rec.foil).displayName
			local key = rec.cardID .. ":" .. rec.foil
			local label = card.name .. (if foilName ~= "Base" then " (" .. foilName .. ")" else "")
			if not groups[key] then
				groups[key] = { count = 0, subtotal = 0, label = label }
				table.insert(order, key)
			end
			groups[key].count += 1
			groups[key].subtotal += EconomyConfig.sellPrice(rec.valueCache)
			table.insert(quote.uids, cardUid)
		end
		table.sort(order)
		for _, key in order do
			local group = groups[key]
			table.insert(quote.lines, {
				text = tostring(group.count) .. "× " .. group.label,
				subtotal = group.subtotal,
			})
			quote.total += group.subtotal
		end
	end

	local function addCarriedPack()
		if data.carried.packID then
			local pack = PackConfig.get(data.carried.packID)
			local foilName = FoilConfig.get(data.carried.packFoil or "Base").displayName
			local payout = EconomyConfig.sellPrice(pack.price)
			table.insert(quote.lines, {
				text = "1× " .. (if foilName ~= "Base" then foilName .. " " else "") .. pack.displayName .. " (pack)",
				subtotal = payout,
			})
			quote.total += payout
			quote.sellsCarriedPack = true
		end
	end

	if option == "inventory" then
		addCards()
		addCarriedPack()
	elseif option == "cards" then
		addCards()
	elseif option == "packs" then
		addCarriedPack()
	elseif option == "card" then
		if uid and data.storage[uid] then
			addCards(uid)
		else
			quote.note = "That card is gone."
		end
	elseif option == "this" then
		if (data.carried.boxValue or 0) > 0 then
			quote.note = "Boxes cash out at full value — just walk into the green Sell zone!"
		elseif data.carried.packID then
			addCarriedPack()
		else
			quote.note = "You're not carrying anything."
		end
	end

	if not quote.note and #quote.lines == 0 then
		quote.note = "Nothing to sell."
	end
	return quote
end

local function commitQuote(player: Player, data: any, quote: Quote)
	for _, uid in quote.uids do
		local rec = data.storage[uid]
		if rec then
			for slotKey, displayedUid in data.displayed do
				if displayedUid == uid then
					data.displayed[slotKey] = nil
					break
				end
			end
			data.storage[uid] = nil
			PlacementService:OnCardRemoved(player, uid)
		end
	end
	if quote.sellsCarriedPack then
		CarryService:TakePack(player)
	end
	data.cash += quote.total
	DataService:SyncMirror(player)
	PlacementService:SyncCards(player)
	PlacementService:Notify(player, "Sold for " .. EconomyConfig.formatMoney(quote.total))
	print(("[SellService] %s sold via dialog for $%d"):format(player.Name, quote.total))
end

-- Walk-in box cash-out (flow spec v1.3 F4.22–23): carrying boxes into a Sell
-- zone pays their full value instantly, 1:1. The canonical sell point is each
-- base's OWN vendor zone (env v1.1 E1.16a, owner-only); the plaza zone stays
-- as a duplicate convenience for anyone.
local function cashCarriedBox(player: Player): boolean
	local now = os.clock()
	if lastZoneSell[player] and now - lastZoneSell[player] < 0.5 then
		return false
	end
	local data = DataService:GetData(player)
	if not data or (data.carried.boxValue or 0) <= 0 then
		return false
	end
	lastZoneSell[player] = now
	local value = CarryService:TakeBox(player)
	data.cash += value -- 1:1, boxes are income
	DataService:SyncMirror(player)
	PlacementService:Notify(player, "Box sold: +" .. EconomyConfig.formatMoney(value))
	print(("[SellService] %s sold a box for $%s (1:1 zone)"):format(player.Name, tostring(value)))
	return true
end

local function onZoneTouched(hit: BasePart)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
		or Players:GetPlayerFromCharacter(hit.Parent and hit.Parent.Parent)
	if player then
		cashCarriedBox(player)
	end
end

-- Per-base vendor zone: only the plot OWNER's boxes cash out here (v1.3).
local function onBaseZoneTouched(plot: any, hit: BasePart)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
		or Players:GetPlayerFromCharacter(hit.Parent and hit.Parent.Parent)
	if not player then
		return
	end
	if plot.owner ~= player then
		local now = os.clock()
		if lastZoneSell[player] and now - lastZoneSell[player] < 0.5 then
			return
		end
		lastZoneSell[player] = now
		PlacementService:Notify(player, "That's not your vendor!")
		return
	end
	cashCarriedBox(player)
end

function SellService.OnStart(self: any)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
	dialogRemote = Instance.new("RemoteEvent")
	dialogRemote.Name = "SellDialog"
	dialogRemote.Parent = remotes
	confirmRemote = Instance.new("RemoteEvent")
	confirmRemote.Name = "SellConfirm"
	confirmRemote.Parent = remotes
	quoteRemote = Instance.new("RemoteEvent")
	quoteRemote.Name = "SellQuote"
	quoteRemote.Parent = remotes

	-- quote request: the client shows the enumerated confirmation from this
	dialogRemote.OnServerEvent:Connect(function(player, option, uid)
		if type(option) ~= "string" then
			return
		end
		local data = DataService:GetData(player)
		if not data then
			return
		end
		local quote = computeQuote(player, data, option, if type(uid) == "string" then uid else nil)
		quoteRemote:FireClient(player, {
			option = option,
			uid = if type(uid) == "string" then uid else nil,
			lines = quote.lines,
			total = quote.total,
			note = quote.note,
		})
	end)

	-- commit: recompute from live data (never trust the client's quote)
	confirmRemote.OnServerEvent:Connect(function(player, option, uid)
		if type(option) ~= "string" then
			return
		end
		local data = DataService:GetData(player)
		if not data then
			return
		end
		local quote = computeQuote(player, data, option, if type(uid) == "string" then uid else nil)
		if quote.note or quote.total <= 0 then
			PlacementService:Notify(player, quote.note or "Nothing to sell.")
			return
		end
		commitQuote(player, data, quote)
	end)

	WorldService:GetSellZone().Touched:Connect(onZoneTouched) -- plaza duplicate
	-- per-base vendor zones (env v1.1 E1.16a): owner-only cash-out
	for _, plot in WorldService:GetPlots() do
		plot.sellZone.Touched:Connect(function(hit)
			onBaseZoneTouched(plot, hit)
		end)
	end

	Players.PlayerRemoving:Connect(function(player)
		lastZoneSell[player] = nil
	end)

	print("[SellService] Ready (boxes 1:1 in the zone; dialog 5 options, cards 50%, confirm-first)")
end

return SellService
