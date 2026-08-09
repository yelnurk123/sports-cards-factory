-- Canon save template (spec §14), trimmed to M1 fields with schema room left
-- for M2 leveling, M3 grade/trait/pity, M5 retention/monetization. Reconcile()
-- in DataService backfills any missing field on load, so new fields only ever
-- need a default here + a schemaVersion bump.

return {
	schemaVersion = 1,
	cash = 100, -- economy §8: $100 start = exactly one rung-1 pack
	luckMult = 1,
	cashMult = 1,
	plotSlots = 10, -- display slots (economy §5: start 10)
	conveyorTier = 1, -- reserved (economy §5 conveyor upgrade)

	-- Cards owned. uid -> { cardID, foil, level, grade, trait, valueCache }
	-- grade/trait stay nil until M3; foil stays "Base" until foil rolls ship.
	storage = {},
	-- Display plot occupancy: slotKey ("1".."10") -> uid into storage.
	displayed = {},
	-- Packs placed on the plot, waiting to open: placementId -> { packID, foil, openAt }
	packQueue = {},
	nextUid = 1,
	nextPlacementId = 1,

	packsOpened = 0,
	index = {}, -- "cardID:foil" -> true once ever pulled (spec §4 collection catalog)

	-- M3 schema room (grade/trait machines + pity counters, economy §2d/§2e)
	tokens = { grade = 0, training = 0 },
	pity = { gradeRolls = 0, traitRolls = 0 },

	-- M5 schema room (retention + monetization)
	potions = {},
	passes = {},
	upgrades = { expansion = 0, luck = 0, cash = 0, time = 0, speed = 0 },
	dailyStreak = 0,
	lastDailyClaim = 0,
	lastOfflineTs = 0,
	playtimeLadderState = 0,
	purchaseHistory = {}, -- receipt PurchaseId -> true (ProcessReceipt idempotency)

	-- M7/M8 schema room
	badges = { towerFloor = 0, netWorth = 0 },

	settings = { Music = true, Sound = true, PackReveal = true, VFX = true },
	playtimeSeconds = 0,
	lastSessionTimestamp = 0,
	firstJoinAt = 0,
}
