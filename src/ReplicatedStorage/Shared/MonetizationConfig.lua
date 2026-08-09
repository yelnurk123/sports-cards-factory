--!strict
-- MonetizationConfig (spec §10) — single source of truth for every Robux SKU:
-- gamepass ids + developer-product ids. Pattern reused from World Cup RNG:
-- an id of 0 means "not yet published" — the client hides the button and the
-- server never receives a receipt. M1 ships NO real products; every id is 0.
-- SKU names/prices from canon §7b; our own product ids only when published
-- (never reuse another game's ids).

local MonetizationConfig = {}

-- Gamepasses (own-once, permanent). All placeholder ids for M1.
MonetizationConfig.Gamepasses = table.freeze({
	Cash2x = 0,        -- 2x Cash (canon ⬡119)
	Luck2x = 0,        -- Super Luck 2x (⬡149; stacks multiplicatively with Luck4x)
	Luck4x = 0,        -- Ultra Luck 4x (⬡799)
	Offline2x = 0,     -- 2x Offline (⬡79)
	RollSpeed2x = 0,   -- 2x Roll Speed (⬡299)
	AutoConveyor = 0,  -- Auto Conveyor (⬡899)
	VIP = 0,           -- −20% timers + 1.5x Cash + name tag (⬡199)
})

-- Developer products (consumable). Each key maps to a handler in PurchaseService.
MonetizationConfig.DevProducts = table.freeze({
	-- Timer skips (canon §7b: <5MIN 9 · <10MIN 14 · <30MIN 29 · <60MIN 59 · <120MIN 99 · Skip All 199)
	Skip5 = 0, Skip10 = 0, Skip30 = 0, Skip60 = 0, Skip120 = 0, SkipAll = 0,
	-- Robux pack bundles (canon §7b: Starter 9 · PRO 79 · MASTER 349 · Royal 99/299/799)
	StarterBundle = 0, ProBundle = 0, MasterBundle = 0,
	RoyalBundle1 = 0, RoyalBundle3 = 0, RoyalBundle10 = 0,
	-- Direct cash (canon §7b: Small 9 · Simple 24 · Medium 49 · Large 129 · MEGA 399)
	CashSmall = 0, CashSimple = 0, CashMedium = 0, CashLarge = 0, CashMega = 0,
	-- Upgrade stall, Robux arm (canon §7b)
	UpgradeExpansion = 0, UpgradeCash = 0, UpgradeLuck = 0, UpgradeSpeed = 0, UpgradeTime = 0,
})

-- Reverse lookup: developer-product id -> product name (for ProcessReceipt dispatch).
-- Ignores 0 (unpublished) so multiple placeholders never collide.
function MonetizationConfig.idToName(productId: number): string?
	if productId == 0 then
		return nil
	end
	for name, id in (MonetizationConfig.DevProducts :: any) do
		if id == productId then
			return name
		end
	end
	return nil
end

-- Reverse lookup: gamepass id -> gamepass name. Ignores 0.
function MonetizationConfig.gamepassName(passId: number): string?
	if passId == 0 then
		return nil
	end
	for name, id in (MonetizationConfig.Gamepasses :: any) do
		if id == passId then
			return name
		end
	end
	return nil
end

return MonetizationConfig
