# M0 Codebase Audit — Sports Legends Card Farm
### What we already own, what we keep, what we build new. Hub, 2026-08-10.
**Sources audited:** `yelnurk123/sports-cards` (World Cup RNG — live Studio export 2026-08-07, its own `AS-BUILT.md` verified against the code) and `yelnurk123/fish-a-brainrot` (ReelBrainrots — real game code synced via Argon on 2026-08-09, NOT the empty scaffold earlier notes predicted).
**Judged against:** `specs/sports-legends-master-build-spec-v1.md` + `specs/sports-legends-economy-v1.md` (canon). Per the alignment pack: audit sources inform reuse, they never supply canon. **Economy numbers, card formula, odds, and naming are ALWAYS rebuilt from canon.**

---

## 1. The headline

World Cup RNG and Sports Legends are different game shapes. World Cup RNG is a **squad-builder** (collect footballers, fill positions, sim matches, PvP duels, live World Cup event pipeline). Sports Legends is an **idle income farm** (cards drip $/s on a display plot, level them with cash, sell, reinvest). Almost no game-logic transfers 1:1 — but the **plumbing is excellent and transfers broadly**: save system, purchase pipeline, pack placement + hatch timers, server-authoritative RNG, index, leaderboards, admin tooling.

Fish a Brainrot, unexpectedly, is the more relevant economy reference: it's an idle game with **live offline earnings and per-plot income** — the two systems World Cup RNG cut.

**The three biggest gaps that must be built new, no matter what:**
1. **The idle income engine** — World Cup RNG's `IncomeService` was cut on 2026-07-15 (`ServerStorage/IncomeService_cut_20260715.lua`). No live drip $/s exists there. Fish a Brainrot has a live one (`ReelBrainrotsRuntimePlot.lua`, `EntityIncome` attribute stamping).
2. **Offline earnings with welcome-back popup** — user-locked canon (spec §5). World Cup RNG: nothing (only a `lastSessionTimestamp` hook in the save schema). Fish a Brainrot: live implementation (`ReelBrainrotsRuntime.lua:632`, `OFFLINE_RATE = 0.5`, per-plot accrual + elapsed tracking).
3. **Card leveling 1→50 with cash** — the dominant lever (spec §6). World Cup RNG's only "levels" are dupe-copy fusion (copies → L7, ×1.25/step — `EconomyConfig.Dupe`), a different mechanic. Canon's ×1.18 → ×3328 curve and `0.25×base×1.35^(L−1)` cost curve exist nowhere in old code.

---

## 2. World Cup RNG — architecture overview

**Boot:** `MainServer.lua` auto-loads every `*Service` module via a Loader (`OnStart`/`Init`); client mirrors this with `MainClient.lua` + 30 `*Controller` modules. CMDR admin console, default-deny, whitelisted (`ServerScriptService/Configs/AdminConfig.lua`). One dead require (`Locker`), tolerated.
**Data flow:** ProfileStore-backed `DataService` (schema v10, `DataService/template.lua`) is the single state owner; services read/mutate profile data and fire runtime-created RemoteEvents (~75, via `ensureRemote`) to controllers. Server-authoritative everywhere that matters (rolls, purchases, placement).
**Save system:** `DataService.lua` (308L) — ProfileStore wrapper with session locking, `Reconcile()` for schema backfill, Studio mock store, per-player mock override for testing, `SyncMirror` for client state. Battle-tested in production.
**Module map (ServerScriptService/MainServer/, ~14k lines):**

| Cluster | Modules | State |
|---|---|---|
| Persistence | DataService + template.lua | Finished, production |
| Cards & packs | PackService (169L), InventoryService (1099L), PlacementService (1743L), IndexService | Finished |
| Economy/monetization | PurchaseService (266L), MonetizationConfig, BoostService, OnlineLuckService, LuckEventService | Finished, real published ids |
| Match sim (game-specific) | MatchService, MatchSessionService (843L), SimEngine (486L), DuelService, SynergyService | Finished — not our game |
| World Cup event (expired context) | WorldCupService, FinalMatchService, VoteService, WorldCupProviders, 6 more | Finished — tournament over |
| Meta | ProgressionService, OnboardingFunnelService, AnalyticsService, TutorialService, SettingsService | Finished |
| Client | 30 Controllers incl. reveal camera pipeline, ConveyorController; NewHudController (1728L) PARTIAL (panel content unpopulated); React UI tree dormant legacy | Mixed |

---

## 3. Fish a Brainrot — architecture overview

**Shape:** "ReelBrainrots" — fishing/idle hybrid. Monolith runtime (`ReelBrainrotsRuntime.lua`, 4488L) + focused modules (Plot 979L, Purchase 957L, FishingRod 666L, Merchant 560L) + a compiled roblox-ts React UI tree (`ReplicatedStorage/TS`, ~185 files). Raw DataStore (not ProfileStore) with retry/backoff, autosave, backup store, and schema-migration machinery (`DataService.lua` 794L, `RuntimeProfileUtils.lua`).
**Save system:** hand-rolled but careful — load/save retries with backoff, 180s autosave, pre-migration backup DataStore, versioned schema upgrades.
**What it has that World Cup RNG doesn't:** live per-plot idle income (`updatePlotIncome`, `EntityIncome` attribute stamping), live offline accrual (`OFFLINE_RATE = 0.5`, per-plot `offlineCashByPlot` + elapsed tracking), a gifting system with product mapping + pending-purchase reconciliation + a "Gifting" settings toggle (`GiftsProductMapping.lua`, `applyGiftReward`), a spin wheel (retention), sell-by-rarity auto-filters in settings.
**What it has that we explicitly don't want:** rebirth (canon: no rebirth treadmill, spec §18), steal mechanic, admin-abuse module.

---

## 4. Systems inventory & relevance map

Legend — **REUSE**: take the code/pattern nearly as-is. **RESKIN**: take the machinery, replace data/semantics with canon. **REBUILD**: write new; old code is a reference at most. **CUT**: do not carry.

| System | Where it lives | Verdict | Why (against build spec) |
|---|---|---|---|
| **Save/load** | WCRNG `DataService.lua` + `template.lua` (ProfileStore, Reconcile, Studio mock) | **REUSE** the wrapper; **REBUILD** the template | The wrapper is production-hardened and game-agnostic. The schema is squad-builder data; canon §14 defines ours (`storage[{cardID, foil, level, grade, trait}]`, `displayed`, `packQueue`, tokens, pity…). Fish's migration/backup ideas worth stealing for the wrapper. |
| **Incremental income (drip $/s)** | Fish `ReelBrainrotsRuntimePlot.lua` (live); WCRNG `IncomeService_cut_20260715.lua` (dead) | **REBUILD**, Fish as pattern reference | Canon formula is exact: box worth Σ(card values) spawns ~every 5s; `$/s = Σ×0.15` (economy §2f). Neither old game uses this math. Fish proves the per-plot accrual pattern works live. |
| **Offline earnings** | Fish `ReelBrainrotsRuntime.lua:632` (live, 50% rate, per-plot) | **REBUILD**, Fish as pattern reference | Canon §5: capped accrual, cap scales with plot tier, welcome-back popup, double-for-R$ offer, 2x Offline pass. Fish's elapsed-time + settle-on-join machinery is the right skeleton; rates/caps/UI from canon. |
| **Level curves (cards)** | WCRNG `EconomyConfig.Dupe` (copies→L7 fusion) | **REBUILD** | Canon §6: cash-paid L1–50, ×1.18/level (×3328 at 50), cost `0.25×base×1.35^(L−1)`. Dupe-fusion is a different mechanic; nothing transfers except "store a level per card." |
| **Pack buy/place/open flow** | WCRNG `PackService.lua` + `PlacementService.lua` (PlacePack → `openAt = os.time()+hatch` → Open → server roll → grant → reveal) | **RESKIN** | The skeleton is exactly our loop: server-authoritative placement, timestamp hatch timers, grant pipeline, OpenAll dev product, autoroll pass. Replace contents: 45 rungs from canon economy §3 (not their 11), band-odds tables from canon (not their tier odds), single-card reveal ceremony (spec §4) instead of their choose-1-of-3 offers, foil roll at pack spawn (canon §3) which they don't have. |
| **Pack/RNG odds display** | WCRNG `PackInfo.lua` — shared config, header: "Shared (client shows odds); the SERVER rolls" | **RESKIN** the pattern; **REBUILD** all odds | Pattern already matches Roblox policy + canon §3/§16 (odds shown before purchase). Every actual number from canon. |
| **Timers** | WCRNG hatch `openAt` timestamps + `hatchMult` upgrade (`PlacementService.lua:750–762`) | **RESKIN** | Timestamp-based (survives rejoin) is the right pattern. Canon rung timers 5s→270min (economy §3) + Time Boost −24% / VIP −20% replace values. |
| **Foil/mutation system** | WCRNG `EconomyConfig.Mutation` (5% base chance, ×2–×25 weights, machine levels) | **REBUILD** | Canon: 13-tier foil ladder rolled at pack spawn, shown on the pack, anchors ×1.5/×2/×3 (economy §2b). Their mutation machine is a different shape (post-pull, upgrade-gated). |
| **Grade & trait rolls** | — (nothing in either codebase) | **REBUILD** | Canon §7 machines (grade ladder, trait table, pity 1500/4000, slide-both-ways RNG) are new. WCRNG's roll/pity idioms in PlacementService are the nearest pattern. |
| **Index (collection catalog)** | WCRNG `IndexService.lua` (discovery set + migration seed + client sync) | **RESKIN** | Same job, bigger catalog: canon wants cardID×foil (~6,400 entries), sport tabs, "???" for unowned, completion % per sport/band (spec §4). Their service is small and clean. |
| **Monetization pipeline** | WCRNG `MonetizationConfig.lua` + `PurchaseService.lua` | **REUSE** the pipeline; **REBUILD** the SKU table | Excellent pattern: one config owns every id, `idToName` reverse-dispatch, id 0 = unpublished (button hides), idempotent gamepass re-apply on join, receipt retry handling. SKUs/prices/products all from canon §10 + economy §7b. Their published product ids are WCRNG's — never reuse ids across games. |
| **Leaderboards** | WCRNG `LeaderboardService.lua` + podium services (OrderedDataStore, Studio-mock fallback) | **RESKIN** | Canon wants Highest Floor + Cash net-worth boards (spec §12, M7/M8). Machinery transfers; metrics and podium dressing rebuild. |
| **Tutorial/onboarding** | WCRNG `TutorialService.lua` + `OnboardingFunnelService.lua` | **RESKIN** | Canon §8 onboarding curve ($100 start → rung-1 pack → 5s open → first card → sell → first wall ~3min) is a different script; the step-gating + funnel-analytics pattern transfers. |
| **Daily/PlayTime rewards** | WCRNG: `DailyRewardInfo.lua` config exists but **no consumer — never implemented**. Fish: spin wheel live | **REBUILD** | Canon §9 (7-day daily ladder, 12-step PlayTime ladder, 4 ads/day) exists in neither codebase as working code. |
| **Admin/dev tooling** | WCRNG `ServerScriptService/CmdrCommands/` (30 commands: givecash/givecard/givepack/boosts/unlockall…), whitelisted CMDR | **REUSE** | Game-agnostic dev accelerators; will pay for itself every playtest. Rename targets to our services. |
| **Analytics/telemetry** | WCRNG `AnalyticsService.lua` + `BloomAnalytics.lua` (external relay, secrets in ServerStorage, redacted-on-export discipline) | **REUSE** pattern; **REBUILD** events | Canon §15 needs region-level campaign telemetry (pack opens, $/s, retention, chase pulls per Hero Drop) — new event taxonomy, same pipe. |
| **Reveal ceremony / VFX** | WCRNG `CardRevealCameraController` + `AnimatedPackReveal` + `RevealConfig` (camera mode active), `CardAnimator`/`AuraVFX` server | **RESKIN** | Canon §4: full-screen card, band ribbon color, foil shine — rarity reads by color instantly. Their camera-driven reveal is the right chassis; dressing from art spec (band owns ribbon, foil owns frame). |
| **HUD/layout** | WCRNG `NewHudController` (partial), dormant React tree, `Icon` topbar package | **REBUILD** HUD; **REUSE** topbar Icon package | Canon §11 layout (top nav Plaza/Base/Sell, left rail, bottom multiplier readout + 10-slot hotbar) is ours. Their HUD is unfinished anyway; the dormant React tree should NOT be carried (dead weight). |
| **Conveyor** | WCRNG `ConveyorController.lua` (client visual); **server-side ConveyorService was planned but never written** (PackService comments reference it; acquisition was in flux) | **REBUILD** server, client visual as reference | Canon §3 conveyor podium is core loop. There is no finished server conveyor to inherit — M1 builds it. |
| **Match sim / duels / synergy / stadium / World Cup pipeline / votes / moments / skins** | WCRNG Match cluster, WorldCup cluster, SkinPackService, MomentCards etc. | **CUT** | Not our game. Combat (spec §12, M7) is specced fresh from canon. |
| **Rebirth / steal / admin abuse** | Fish `RuntimeRebirth`, `RuntimeSteal`, `RuntimeAdminAbuse` | **CUT** | Canon §18 explicitly: no rebirth treadmill. |
| **Gifting** | Fish `GiftsProductMapping` + pending-gift reconciliation + "Gifting" toggle | **REBUILD** (M8), Fish as the reference implementation | Canon §13: one-way gifting with guardrails (accept/decline, daily limit, progression-gated receiving, block toggle). Fish proves the product-mapping + pending-purchase pattern; guardrails are new (spec §13, queue item). |

---

## 5. Policy-gap flags (fix in OUR build; never copy)

1. **Real player references, at scale** — WCRNG `FootballerOdds.lua` (859L): hundreds of real footballer surnames with real-photo `rbxassetid`s (Baena, Martinelli, Trossard, Wissa…). `MomentCards.lua`: authored real WC2026 storylines with real names. `KitConfig.lua` (597L): real national-team kits. **None of this may touch Sports Legends** — canon is parody-only (roster names, spec §16). Flag, don't copy.
2. **Odds tables** — WCRNG does this RIGHT (shared PackInfo, client shows odds, server rolls). But `CardPackConfig.lua` self-describes: "Prices/odds/art are launch placeholders" with price 0 / freeOpen active. Our bar: every pack shows its real band-odds table before purchase, no placeholder ever ships (canon §3, §16).
3. **Secrets hygiene** — WCRNG export redacted two live secrets (`REDACTED_ON_EXPORT`: API-Football key, BloomAnalytics ApiKey) but they still exist in Studio (their QUESTIONS.md). Carry the redaction habit, not the secrets. Bot-token-only rule per alignment pack §3.
4. **Dead weight not to carry** — WCRNG dormant React UI tree, `ServerStorage` archives (IncomeService cut, pre-reel UI, dead asset folders), expired one-off `CityEventGlow` script, dead `Locker` require. Fish: roblox-ts `rbxts_include` (1,028 generated files) — if we use TS UI we generate our own; don't inherit the compiled output.
5. **Free-model check** — no unvetted free-model code found in either repo's own source; Packages are known libs (ProfileStore, CMDR, TopbarPlus/Icon, Zone, React, Seam). Keep to this list.

---

## 6. M1 build-from-pieces plan (blockout core loop)

M1 scope per spec §17: conveyor podium + 3 starter packs, pack timers, reveal ceremony (placeholder frames), display plot with drip $/s, Sell stall at 50%, save/load. Acceptance: fresh player completes buy→open→place→sell→reinvest in <3 min; numbers match spec §2–3.

**Skeleton (from old code, in this order):**
1. **Boot + Loader pattern** from WCRNG (`MainServer`/`MainClient` auto-loading `*Service`/`*Controller`). Establishes the module shape every later milestone plugs into.
2. **DataService wrapper** from WCRNG, with a **new canon §14 template** (storage/displayed/packQueue/cash/luckMult/cashMult/plotSlots). Trim to M1 fields; leave schema room for tokens/grades/traits/pity (M2–M3). Borrow Fish's backup-store + migration idea now, while the schema is young.
3. **Placement/hatch machinery** from WCRNG `PlacementService` — strip squad logic (positions, offers, synergy, autoroll), keep: place-at-plot, `openAt` timestamp timers, billboard countdown, open→grant pipeline, OpenAll hook point. This is the biggest single reuse win.
4. **Pack acquisition = conveyor podium, BUILT NEW** (no finished server conveyor exists in either codebase). Client conveyor visual from WCRNG as the dressing reference. Rung table: canon economy §3 rungs 1–3 for M1's 3 starter packs.
5. **Income engine, BUILT NEW** on Fish's per-plot accrual pattern: box spawns ~5s worth Σ(values); `$/s = Σ×0.15`. Canon numbers only.
6. **Sell stall at 50%**, new and trivial (canon §2).
7. **Reveal ceremony** on WCRNG's camera-reveal chassis, placeholder frames, band ribbon colors from art spec (rarity-by-color is acceptance-critical even in blockout).
8. **Purchase pipeline** from WCRNG (`MonetizationConfig` + `PurchaseService`) with ids = 0 placeholders (pattern hides unpublished SKUs natively) — M1 needs no real products yet.
9. **CMDR admin commands** ported early (givecash/givepack/unlockall) so playtests are fast.
10. **Topbar Icon package** as-is.

**Written new in M1, full stop:** canon save template · conveyor server logic · income tick · sell stall · rung/odds configs from economy v1.1 · HUD blockout per spec §11 · tutorial script per canon §8.

**Deliberately NOT in M1:** leveling (M2), grade/trait (M3), evolution (M4), offline earnings + dailies + monetization SKUs (M5 — offline is user-locked YES, but sequenced after the loop proves), art integration (M6), combat (M7), gifting/leaderboards (M8).

---

## 7. Risks & open questions for the hub

- **Biggest reuse risk:** `PlacementService` is 1,743 lines deeply interwoven with squad semantics (positions, synergy, offers, galaxy rolls). The strip-down is surgery, not copy-paste — budget it as "reskin with teeth," and if the surgery fights back, rewrite the placement service clean using its patterns (timestamp hatches, ensureRemote, server-authoritative grants) rather than drag the corpse.
- **Fish a Brainrot divergence:** hand-rolled DataStore vs WCRNG's ProfileStore. Standardize on **ProfileStore** (session locking prevents the item-dupe class of bugs an economy game cannot afford). Fish's offline/accrual logic ports as patterns, not code.
- **UI stack decision for M1:** WCRNG's React tree is dormant legacy; Fish uses roblox-ts React (compiled, heavy). M1 blockout HUD should be plain Luau + the Icon topbar; defer the React/no-React call until HUD complexity justifies it. *(Hub recommendation: plain Luau through M5.)*
- **Open question (user gate, not code):** Fish a Brainrot's Argon sync landed 2026-08-09 and this audit used it — no longer a blocker. World Cup RNG's export is Studio-synced and current as of 2026-08-07. Both audit sources are now trustworthy snapshots.

*Audit ends here. No game code was written. Next gate: user reviews this map, then M1 tasks the build chat via factory-ops mailbox.*
