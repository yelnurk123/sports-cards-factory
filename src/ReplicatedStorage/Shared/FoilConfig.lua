--!strict
-- FoilConfig — the 13-tier foil ladder (economy §2b). Multipliers are canon
-- (anchors Golden ×1.5 / Diamond ×2 / Venomous ×3 measured; full ladder v1 tunable).
-- Frame treatments per art spec §4 (foil owns the frame).
-- M1.1 (flow spec v1.1 F1): foil rolls AT PACK SPAWN and shows on the pack label
-- before buy; the placed pack keeps it and the pulled card inherits it. Spawn
-- weights below are PLACEHOLDER (hub ruling 2026-08-10 allows placeholder
-- weights — displayed = rolled; the real foil spawn-rate spec is hub debt due
-- before M2 and replaces SpawnWeights when it lands).

local FoilConfig = {}

export type Foil = {
	id: string,
	index: number,
	displayName: string,
	mult: number,
	frameColor: Color3, -- blockout stand-in for the frame treatment
}

local function f(id: string, index: number, mult: number, r: number, g: number, b: number): Foil
	return { id = id, index = index, displayName = id, mult = mult, frameColor = Color3.fromRGB(r, g, b) }
end

FoilConfig.Foils = table.freeze({
	Base     = f("Base",       1,  1,   245, 240, 220), -- plain cream frame
	Silver   = f("Silver",     2,  1.5, 192, 192, 200), -- silver metallic
	Gold     = f("Gold",       3,  2,   255, 200, 50),  -- gold metallic
	Platinum = f("Platinum",   4,  3,   90,  95,  110), -- dark platinum + shine
	Holo     = f("Holo",       5,  5,   255, 120, 255), -- rainbow gradient holo (blockout approx)
	Prism    = f("Prism",      6,  8,   120, 255, 180), -- checkerboard prism border (blockout approx)
	Chrome   = f("Chrome",     7,  12,  220, 230, 240), -- mirror chrome
	Sapphire = f("Sapphire",   8,  20,  30,  60,  220), -- deep blue crystalline
	Ruby     = f("Ruby",       9,  32,  200, 20,  40),  -- deep red crystalline
	Galactic = f("Galactic",   10, 50,  60,  20,  120), -- starfield galaxy (blockout approx)
	Cosmic   = f("Cosmic",     11, 100, 160, 60,  200), -- nebula swirl (blockout approx)
	Owner    = f("Owner",      12, 200, 20,  20,  25),  -- black + gold luxury
	OneOfOne = f("One of One", 13, 400, 255, 255, 255), -- white-hot prismatic + serial required
} :: { [string]: Foil })

FoilConfig.Order = table.freeze({ "Base", "Silver", "Gold", "Platinum", "Holo", "Prism", "Chrome", "Sapphire", "Ruby", "Galactic", "Cosmic", "Owner", "OneOfOne" })

function FoilConfig.get(id: string): Foil
	-- displayName differs from key for OneOfOne; look up by key first, then displayName
	local byKey = (FoilConfig.Foils :: any)[id]
	if byKey then
		return byKey
	end
	for _, foil in FoilConfig.Foils do
		if foil.displayName == id then
			return foil
		end
	end
	error("unknown foil id: " .. tostring(id))
end

function FoilConfig.mult(id: string): number
	return FoilConfig.get(id).mult
end

-- PLACEHOLDER spawn weights (hub debt: the foil spawn-rate spec lands before M2
-- and replaces these). Deliberately Base-heavy and capped at Holo so a lucky
-- roll can't break the M1 economy. Displayed foil = rolled foil, always.
FoilConfig.SpawnWeights = table.freeze({
	Base = 85,
	Silver = 8,
	Gold = 4,
	Platinum = 2,
	Holo = 1,
} :: { [string]: number })

-- Server-authoritative foil roll at pack spawn (PurchaseService). Returns a
-- foil id from SpawnWeights.
function FoilConfig.roll(rng: Random): string
	local total = 0
	for _, weight in FoilConfig.SpawnWeights do
		total += weight
	end
	local pick = rng:NextNumber(0, total)
	for id, weight in FoilConfig.SpawnWeights do
		pick -= weight
		if pick <= 0 then
			return id
		end
	end
	return "Base"
end

return FoilConfig
