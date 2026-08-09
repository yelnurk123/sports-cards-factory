--!strict
-- CardConfig — the card catalog. M1 ships the 12 cards of starter rungs 1–3
-- (one pack per rung, 4-card pull pool each — hub ruling 2026-08-10: one card
-- per pack open, equal 25% weight).
--
-- Names are the Grand Roster's parody names ONLY (spec §16: no real
-- player/team/league names anywhere). Base values: rung price ÷ 10, spread
-- 0.7× / 0.9× / 1.1× / 1.3× across the pool (economy §2a); the biggest name
-- in each pack carries the 1.3× chase slot.

local CardConfig = {}

export type Card = {
	id: string,
	name: string, -- parody name from the Grand Roster
	sport: string,
	pack: string, -- PackConfig pack id
	band: string, -- BandConfig band id (rungs 1–3 => Rookie)
	base: number, -- $/Card base value (economy §2a)
}

local function c(id: string, name: string, sport: string, pack: string, base: number): Card
	return { id = id, name = name, sport = sport, pack = pack, band = "Rookie", base = base }
end

CardConfig.Cards = table.freeze({
	-- Rung 1 · Street Pack (soccer, $100, center $10)
	street_bendham = c("street_bendham", "Bendham", "Soccer", "street", 7),
	street_henry   = c("street_henry", "Terry Henry", "Soccer", "street", 9),
	street_zizou   = c("street_zizou", "Zizou", "Soccer", "street", 11),
	street_ronnie  = c("street_ronnie", "Ronnie Magic", "Soccer", "street", 13),
	-- Rung 2 · Sandlot Pack (baseball, $250, center $25)
	sandlot_clemente  = c("sandlot_clemente", "Bob Clemente", "Baseball", "sandlot", 17.5),
	sandlot_ironhorse = c("sandlot_ironhorse", "Lou Ironhorse", "Baseball", "sandlot", 22.5),
	sandlot_mantle    = c("sandlot_mantle", "Mick Mantle", "Baseball", "sandlot", 27.5),
	sandlot_jackie    = c("sandlot_jackie", "Jackie Steals Home", "Baseball", "sandlot", 32.5),
	-- Rung 3 · Clubhouse Pack (golf, $500, center $50)
	clubhouse_viktor  = c("clubhouse_viktor", "Viktor the Viking", "Golf", "clubhouse", 35),
	clubhouse_annika  = c("clubhouse_annika", "Annika Ace", "Golf", "clubhouse", 45),
	clubhouse_brooks  = c("clubhouse_brooks", "Brooks Major", "Golf", "clubhouse", 55),
	clubhouse_scottie = c("clubhouse_scottie", "Scottie Steady", "Golf", "clubhouse", 65),
} :: { [string]: Card })

function CardConfig.get(id: string): Card
	local card = (CardConfig.Cards :: any)[id]
	assert(card, "unknown card id: " .. tostring(id))
	return card
end

function CardConfig.exists(id: string): boolean
	return (CardConfig.Cards :: any)[id] ~= nil
end

return CardConfig
