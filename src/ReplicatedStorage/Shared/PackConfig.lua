--!strict
-- PackConfig — the M1 starter packs: economy §3 rungs 1–3, one pack per rung.
-- Prices/timers are canon (rung 1 $100/5s · rung 2 $250/8s · rung 3 $500/12s).
--
-- Pull pool (hub ruling 2026-08-10): ONE card per pack open; the pack's 4
-- roster cards are the pool, equal 25% weight each. The odds table shown
-- before purchase is computed from this pool — shared config, server rolls,
-- client displays (spec §16; the odds shown are the odds rolled).

local CardConfig = require(script.Parent.CardConfig)

local PackConfig = {}

export type Pack = {
	id: string,
	displayName: string,
	sport: string,
	rung: number,
	price: number, -- cash price (economy §3)
	hatch: number, -- seconds from placement to openable (economy §3 rung timer)
	pool: { string }, -- 4 card ids, equal weight
}

local function p(id: string, displayName: string, sport: string, rung: number, price: number, hatch: number, pool: { string }): Pack
	for _, cardId in pool do
		assert(CardConfig.exists(cardId), "pack " .. id .. " references unknown card " .. cardId)
	end
	return { id = id, displayName = displayName, sport = sport, rung = rung, price = price, hatch = hatch, pool = pool }
end

PackConfig.Packs = table.freeze({
	street = p("street", "Street Pack", "Soccer", 1, 100, 5, {
		"street_bendham", "street_henry", "street_zizou", "street_ronnie",
	}),
	sandlot = p("sandlot", "Sandlot Pack", "Baseball", 2, 250, 8, {
		"sandlot_clemente", "sandlot_ironhorse", "sandlot_mantle", "sandlot_jackie",
	}),
	clubhouse = p("clubhouse", "Clubhouse Pack", "Golf", 3, 500, 12, {
		"clubhouse_viktor", "clubhouse_annika", "clubhouse_brooks", "clubhouse_scottie",
	}),
} :: { [string]: Pack })

-- Conveyor display order (lowest rung first).
PackConfig.Order = table.freeze({ "street", "sandlot", "clubhouse" })

function PackConfig.get(id: string): Pack
	local pack = (PackConfig.Packs :: any)[id]
	assert(pack, "unknown pack id: " .. tostring(id))
	return pack
end

function PackConfig.exists(id: string): boolean
	return (PackConfig.Packs :: any)[id] ~= nil
end

export type OddsRow = { cardId: string, name: string, base: number, chance: number }

-- The pack's odds table for pre-purchase display (spec §16). Equal 25% per
-- pool card (hub ruling); derived from the pool so display and roll can never
-- drift apart.
function PackConfig.getOdds(packId: string): { OddsRow }
	local pack = PackConfig.get(packId)
	local chance = 1 / #pack.pool
	local rows: { OddsRow } = {}
	for _, cardId in pack.pool do
		local card = CardConfig.get(cardId)
		table.insert(rows, { cardId = cardId, name = card.name, base = card.base, chance = chance })
	end
	return rows
end

-- Server-authoritative roll: one card from the pool, equal weight.
function PackConfig.rollCard(packId: string, rng: Random): string
	local pack = PackConfig.get(packId)
	return pack.pool[rng:NextInteger(1, #pack.pool)]
end

return PackConfig
