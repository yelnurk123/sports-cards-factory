--!strict
-- EconomyConfig — M1 economy constants + the card value formula. Numbers are
-- canon (economy v1.1 + hub rulings 2026-08-10), never borrowed from the
-- reference games.

local FoilConfig = require(script.Parent.FoilConfig)

local EconomyConfig = {}

-- Onboarding (economy §8): fresh players start with exactly one rung-1 pack.
EconomyConfig.START_CASH = 100

-- The drip (economy §2f): every ~5s each displayed card drops one token worth
-- its current $/Card onto its adjacent token lane; HUD "$/s" = Σ ÷ 5 (hub
-- ruling 2026-08-10: the economy file wins on numbers — Σ÷5, NOT ×0.15).
EconomyConfig.BOX_INTERVAL = 5 -- seconds between token drops
EconomyConfig.INCOME_PER_SECOND_DIVISOR = 5 -- $/s = Σ(displayed values) ÷ this
-- Box mechanics (flow spec v1.2 F3.16–18, canon 2026-08-11): a box fills with
-- exactly 8 token-cards; when full a new empty box spawns ON TOP; the stack
-- caps at 5 boxes and the drip pauses while a 6th would be needed.
EconomyConfig.BOX_FILL_COUNT = 8
EconomyConfig.MAX_UNCOLLECTED_BOXES = 5 -- box stack cap per lane box point

-- Sell stall (canon §2/§5): 50% of card value.
EconomyConfig.SELL_RATE = 0.5

-- Plot (economy §5): display slots start at 10; Base Expansion is a later
-- milestone. Pack pedestals hold queued packs (endgame 8+; M1 blockout: 2).
EconomyConfig.DISPLAY_SLOTS_START = 10
EconomyConfig.PACK_PEDESTALS = 2

-- Level multiplier (economy §2c): ×1.18 per level, ×~3300 at L50. M1 cards
-- are all L1; the curve is here so value math never special-cases it.
function EconomyConfig.levelMult(level: number): number
	return 1.18 ^ (math.max(1, level) - 1)
end

-- The card formula (spec §2): value = base × foil × 1.18^(level−1) × grade × trait.
-- M1: foil = Base (×1), grade/trait unset (×1 each). Schema carries the fields.
function EconomyConfig.cardValue(base: number, foil: string?, level: number?, gradeMult: number?, traitMult: number?): number
	return base
		* FoilConfig.mult(foil or "Base")
		* EconomyConfig.levelMult(level or 1)
		* (gradeMult or 1)
		* (traitMult or 1)
end

-- What a displayed card earns per second (economy §2f: $/s = value ÷ 5).
function EconomyConfig.incomePerSecond(value: number): number
	return value / EconomyConfig.INCOME_PER_SECOND_DIVISOR
end

-- What the Sell stall pays for a card (canon: 50% of value).
function EconomyConfig.sellPrice(value: number): number
	return math.floor(value * EconomyConfig.SELL_RATE)
end

-- Suffix ladder (economy §1): $ → K → M → B → T → Qa → Qi → Sx → Sp → Oc → N → Dc → Ud → Dd.
local SUFFIXES = table.freeze({ "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "N", "Dc", "Ud", "Dd" })

-- 1234.5 -> "$1.23K"; small values keep cents ("$7.50").
function EconomyConfig.formatMoney(n: number): string
	local sign = n < 0 and "-" or ""
	local v = math.abs(n)
	if v < 1000 then
		if v == math.floor(v) then
			return sign .. "$" .. tostring(math.floor(v))
		end
		return sign .. string.format("$%.2f", v)
	end
	local tier = math.min(math.floor(math.log10(v) / 3), #SUFFIXES - 1)
	local scaled = v / 10 ^ (tier * 3)
	return sign .. string.format("$%.2f%s", scaled, SUFFIXES[tier + 1])
end

-- Same ladder without the $ prefix, for rates ("2.60/s").
function EconomyConfig.formatRate(n: number): string
	return EconomyConfig.formatMoney(n):sub(2) .. "/s"
end

return EconomyConfig
