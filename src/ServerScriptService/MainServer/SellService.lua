--!strict
-- SellService — the Sell stall. Canon §2/§5: the Scout pays 50% of card value.
-- The client Sell panel (opened at the stall prompt) lists owned cards; each
-- row fires SellCard with a uid. Server validates ownership and pays out.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CardConfig = require(Shared.CardConfig)
local EconomyConfig = require(Shared.EconomyConfig)

local DataService = require(script.Parent.DataService)
local PlacementService = require(script.Parent.PlacementService)

local SellService = {}

local sellRemote: RemoteEvent = nil :: any

function SellService.SellCard(self: any, player: Player, uid: string): boolean
	local data = DataService:GetData(player)
	if not data then
		return false
	end
	local rec = data.storage[uid]
	if not rec then
		return false
	end
	local payout = EconomyConfig.sellPrice(rec.valueCache)

	-- pull off the display plot if shown
	for slotKey, displayedUid in data.displayed do
		if displayedUid == uid then
			data.displayed[slotKey] = nil
			PlacementService:Notify(player, "Sold " .. CardConfig.get(rec.cardID).name .. " for " .. EconomyConfig.formatMoney(payout))
			break
		end
	end
	data.storage[uid] = nil
	data.cash += payout

	-- re-render the plot (PlacementService owns models; ask it to sync)
	PlacementService:OnCardRemoved(player, uid)
	PlacementService:SyncCards(player)
	print(("[SellService] %s sold %s for $%d"):format(player.Name, rec.cardID, payout))
	return true
end

function SellService.OnStart(self: any)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
	sellRemote = Instance.new("RemoteEvent")
	sellRemote.Name = "SellCard"
	sellRemote.Parent = remotes

	sellRemote.OnServerEvent:Connect(function(player, uid)
		if type(uid) == "string" then
			SellService:SellCard(player, uid)
		end
	end)

	print("[SellService] Ready (50% of value)")
end

return SellService
