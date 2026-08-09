--!strict
-- BandConfig — the 10 rarity bands (art spec §3) and their ribbon colors.
-- Colors from art spec §7h band rim-light coding: rarity must read by color,
-- even in blockout. The band owns the ribbon zone on the card; nothing else
-- may use these colors on the card face.
-- Rungs 1–3 (M1 content) are all Rookie band per economy §3 mapping
-- ("Rookie pack = rung 1–3, Prospect = 4–6 …").

local BandConfig = {}

export type Band = {
	id: string,
	index: number,
	displayName: string,
	ribbonColor: Color3,
}

BandConfig.Bands = table.freeze({
	Rookie   = { id = "Rookie",   index = 1,  displayName = "Rookie",   ribbonColor = Color3.fromRGB(235, 242, 255) }, -- cool white
	Prospect = { id = "Prospect", index = 2,  displayName = "Prospect", ribbonColor = Color3.fromRGB(0, 220, 230) },   -- cyan
	Pro      = { id = "Pro",      index = 3,  displayName = "Pro",      ribbonColor = Color3.fromRGB(30, 200, 120) },  -- emerald
	AllStar  = { id = "AllStar",  index = 4,  displayName = "All-Star", ribbonColor = Color3.fromRGB(255, 180, 40) },  -- amber
	Champion = { id = "Champion", index = 5,  displayName = "Champion", ribbonColor = Color3.fromRGB(220, 30, 60) },   -- crimson
	Icon     = { id = "Icon",     index = 6,  displayName = "Icon",     ribbonColor = Color3.fromRGB(150, 80, 255) },  -- violet
	Legend   = { id = "Legend",   index = 7,  displayName = "Legend",   ribbonColor = Color3.fromRGB(40, 90, 255) },   -- royal blue
	Immortal = { id = "Immortal", index = 8,  displayName = "Immortal", ribbonColor = Color3.fromRGB(200, 205, 215) }, -- silver
	Eternal  = { id = "Eternal",  index = 9,  displayName = "Eternal",  ribbonColor = Color3.fromRGB(190, 150, 60) },  -- aged gold
	GOAT     = { id = "GOAT",     index = 10, displayName = "GOAT",     ribbonColor = Color3.fromRGB(255, 205, 40) },  -- pure gold
} :: { [string]: Band })

BandConfig.Order = table.freeze({ "Rookie", "Prospect", "Pro", "AllStar", "Champion", "Icon", "Legend", "Immortal", "Eternal", "GOAT" })

function BandConfig.get(id: string): Band
	local band = (BandConfig.Bands :: any)[id]
	assert(band, "unknown band id: " .. tostring(id))
	return band
end

return BandConfig
