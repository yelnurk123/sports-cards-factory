# SPORTS LEGENDS CARD FARM — MASTER BUILD SPEC v1
### The game loop and systems blueprint for Kimi Code. Hub canon, 2026-08-10.
**How to use this file:** this is the single blueprint for building the game. It adapts the proven Anime Card Farm machine (frame-verified teardown) to Sports Legends canon. When this spec conflicts with anything, this spec wins for the build; the repo canon (roster, economy, art spec) wins for content and numbers.
**Reference anchor (canon rule, 2026-08-10):** `specs/anime-card-farm-flow-reconstruction.md` (and `reference/anime-card-farm-teardown.html`) is THE reference for how this game plays and feels. When the spec is silent on a flow or UX detail, follow it and cite it. When it suggests something different from the spec, flag it in `notes/hub-questions.md` as a proposal with the citation — never change course silently, never invent flow details, never drift without a dated decision. Canon files in the repo:
- `specs/sports-legends-grand-roster-v3.md` — every card, pack, band (492 cards incl. rugby; +24 bonus cards pending adoption)
- `specs/sports-legends-economy-v1.md` — 45-rung price table, foil ladder, evolution values
- `specs/sports-legends-art-spec-v1.md` — card architecture: band owns ribbon, foil owns frame, grade owns slab

**User-locked product decisions (2026-08-10):** first build = core loop + upgrading · cards earn while offline · player trading comes in a later update · monetization = both packs and passes, mapped with free-player progression intact.

---

## 1. Game atoms (what this is at the mechanics level)
- **Verb:** pull & collect (gacha) on top of idle income.
- **Fantasy:** run a sports card shop/farm. Buy packs off the conveyor, they open on a timer, cards land on your display plot and drip $/sec, sell and reinvest into pricier packs. Chase your sport's GOAT cards.
- **Archetype:** RNG-COLLECTOR. Cozy storefront mask, deep collector math underneath.
- **Skeleton (7 steps):** buy pack → place on plot → wait timer → reveal ceremony → card drips $/s → sell box → reinvest. Everything else is a multiplier on these steps.
- **No rebirth.** Progression = collect foils → level to 50 → roll grade → roll trait → evolve.

## 2. The card entity — 5 multipliers
One card instance = `cardID × foil × level × grade × trait`. Two "same" cards can differ thousandfold. This is the engine; every multiplier is its own system and its own (later) monetization point.

| Multiplier | Our canon | Source of truth |
|---|---|---|
| Base value | Card's rung band value (Rookie $10-ish → GOAT top rungs) | economy v1.1 rung table |
| Foil (13 tiers) | Frame treatment, ×1 up the foil ladder | economy v1.1 foil ladder |
| Level (1–50) | ×1.18 per level → **×3328 at L50** | teardown formula, verified |
| Grade (roll) | Slab grade multiplier (see §7) | mirrors teardown rank machine |
| Trait (roll) | Secondary % boost (see §7) | mirrors teardown trait machine |

**Value formula:** `value = base × foilMult × 1.18^(level−1) × gradeMult × traitMult`
**Income:** displayed cards drip `$/s = displayedValueSum ÷ 5` — a box worth Σ spawns on the conveyor every ~5s and is carried to the Sell point (economy §2f, frame-verified: $10 card → $2/s). Hub ruling 2026-08-10: economy file wins on numbers; this line previously said ×0.15 — corrected.
**Sell:** ~50% of value, paid at the Sell stall ("Scout NPC" buys your box).

## 3. Packs, conveyor & the rung ladder
- The conveyor cycles available packs; the player buys from a podium, pack lands on the plot, opens on a timer.
- **Our ladder = the 45 rungs from economy v1.1** ($100 rung-1 → $1.5Qn rung-45). Each pack in the roster maps to a rung (final rung→band map is a pending hub deliverable — M2 needs it; until then, price packs by band: Rookie pack = rung 1–3, Prospect = 4–6 … GOAT = top rungs).
- **Timer wall:** base open timer ~5 min at low rungs, grows with rung (30 min – 1h+ at top). Skip buttons sell graded doses (Skip 5/10/30/120 min, Skip All). The plot holds 8+ queued packs at endgame.
- **Pack odds must be displayed** (Roblox policy + trust): each pack shows its band-odds table before purchase. Odds skeleton per pack ≈ 48.5 / 32 / 14 / 5 / 0.5% across its band spread, shifted up for pricier packs.
- **Foil luck on packs:** any pack can spawn pre-foiled (Golden/Diamond/…) and yields a foiled card. Mutated pack costs more and yields a pricier card — same as teardown.
- Any pack also purchasable with Robux (shortcut past the grind).

## 4. The Index (collection catalog)
- Catalog of every card × foil combination (roster 492 cards × 13 foils + evolution forms; ~6,400+ entries), organized by sport tabs, then pack, then foil. Unowned = "???".
- Index completion per sport and per band is the collector spine; each sport tab shows completion % (drives the regional campaign strategy — players chase "their" heroes).
- Reveal ceremony on every pull: full-screen card, band ribbon color, foil shine, $/Card, sport. Rarity must read instantly by color — this is the emotional core of the game. Settings toggles: Pack Reveal Effect, Visual Effects.

## 5. Idle income & offline earnings (user-locked: offline = yes)
- Displayed cards drip $/s while playing (§2 formula).
- **Offline accrual:** the plot keeps earning while away, capped (cap scales with plot tier). On return: "Welcome Back! You earned $X" popup, with a one-tap "double it for ⬡" offer and a permanent 2x Offline pass in the shop.
- Plot = the player's card shop. Display slots start small; **Base Expansion** buys more slots (uncapped, steeply escalating cash price — the endgame cash sink).

## 6. Leveling (the dominant lever — first build scope)
- Cards level 1→50. Each level: value ×1.18. **L50 = ×3328.**
- Level-up cost: `cost(L→L+1) = 0.25 × base × 1.35^(L−1)` — first upgrade always 25% of card base; cost grows faster than value, so late levels are a deliberate investment. MAX badge on L50 cards.
- Leveling UI lives in the Upgrade stall + card detail panel. "Equip Best" button auto-fills display slots with highest-value cards.

## 7. Grade & Trait rolls (second gacha layer — first build scope)
Sports-flavored reskins of the teardown's rank/trait machines:
- **Slab Grading Station** ("Get your card graded" — the slab canon): roll a grade with Grade Tokens or cash. Ladder mirrors teardown rank odds exactly: F 1x 32% · E 1.1x 26% · D 1.2x 18% · C 1.35x 12% · B 1.6x 7% · A 2x 3.82% · S 3x 1% · SS 6.5x 0.1% · SR 8x 0.05% · UR 10x 0.02%. Re-rolls can slide back (RNG both ways). Pity: UR guaranteed within 1500 rolls on a card. Graded card gets the visual slab frame (grade owns slab — art canon).
- **Training Station** (trait roll): roll a trait with Training Tokens. Fortune line (+Cash: I 1.1x 16% / II 1.3x 10.7%), plus sport-flavored boosts for later combat (Power/Endurance I/II). Rare combo traits: Rich 2x Cash 0.4% · Champion (1.2x Cash + 1.5x Power + 1.5x Endurance) 0.3% · Phoenix 1.75x all 0.14% · Almighty 2x all (rarest). Pity 1500/4000.
- Token sources: daily rewards, tower/ladder rewards (later), rewarded ads (4/day), Robux bundles (30=⬡49 … 5K=⬡1999).

## 8. Evolution (16 recipes — later milestone M4)
- Card Craft station: sacrifice specific owned cards + cash → one evolved card (16 evolution recipes in economy v1.1, e.g. three Transcendent-tier cards → an evolved legend).
- Mutations slot lets the player force the evolved card's foil.
- This is the reason players keep spare cards — the dupes sink.

## 9. Retention loops (four overlaid, non-conflicting)
1. **Daily Rewards:** 7-day ladder, 24h cooldown (D1 cash → D2 mid pack → … → D7 top-foil chase card). Shows on join, before tutorial.
2. **PlayTime Rewards:** 12-reward session ladder that resets on leave ("Leaving Resets Progress!"). Claim All for ⬡449.
3. **Offline Welcome-Back:** accrued earnings popup + double-for-⬡ offer (§5).
4. **Free Rewards:** 4 rewarded ads/day → grade/training tokens, potions.
5. **Group bonus:** +1.25x Cash for joining the group (permanent). **Like goal board:** community counter → "BIG UPDATE" unlock.
6. **Events:** scheduled drops ("Saturday Match Day" event) — aligns with the regional Hero Drop campaigns.

## 10. Monetization map (user-locked: both, balanced, F2P intact)
Sells three things: time (skips), chance (luck passes, tokens), direct outcome (packs, chase podium). Everything purchasable with cash must stay earnable by play; Robux buys speed and certainty, never exclusive power that free players can't reach.
- **Passes:** 2x Cash ⬡119 · 2x Offline ⬡79 · Super Luck 2x ⬡149 · Ultra Luck 4x ⬡799 (stack multiplicatively) · 2x Roll Speed ⬡299 · Auto Conveyor ⬡899 · VIP ⬡199 (−20% timers + 1.5x Cash + name tag).
- **Timer skips:** Skip 5/10/30/120min · Skip All ⬡199–599.
- **Packs:** Starter ⬡9 · Pro ⬡79 · Master ⬡349 · Royal ⬡799 (odds table shown) · any conveyor pack direct.
- **Chase podium:** limited-stock Robux cards (e.g. Diamond GOAT-tier, stock counter visible — FOMO, transparent).
- **Direct cash:** ⬡9→⬡399 ladder. **Tokens/potions:** §7 bundles. Potions: Cash/Luck/Mutation lines × I–III tiers, timed, one per line active, additive into the HUD multiplier.
- **Upgrades stall (dual cash/Robux):** Base Expansion · Luck Boost (+% rarer packs) · Cash Boost (+% sell, cap +200%) · Time Boost (−% timer, cap −24%) · Speed Boost. Expansion and Luck are the uncapped sinks.

## 11. HUD & layout
Top nav: Plaza / Base / Sell. Left rail: Shop · Index · Upgrade · Items. Bottom: multiplier readout (Luck × / Cash × always visible — every action reads as those numbers going up) + 10-slot card hotbar. Cards panel: Storage count, Equip Best. Right rail: current multipliers + offer pads + PlayTime timer. Plaza hub: SHOP / SELL / UPGRADE stalls + stations (Craft, Grading, Training, Boss Match, Legends Ladder, Free Rewards) — even if later milestones, the stations exist as "Coming Soon" placeholders from M1.

## 12. Combat (later milestone — specced now, built after M5)
Cards carry HP + DMG derived from value × grade × trait.
- **Boss Match (raid):** "Dream Team Boss" on a ~30-min cycle, 4-card team, 4 difficulties, 4-phase fight with a rage phase, 1 fight/hour cooldown, drops Match Shards + boss-card shards; shard shop sells boss cards (150 shards = 50% of best card value).
- **Legends Ladder (tower):** 4-card team, 1v1 auto-battles floor by floor, milestone rewards every 2 floors (cash, potions, tokens), auto-replay, public "Highest Floor" leaderboard + Cash net-worth leaderboard — the status system (no classic badges; status = push a number higher than your neighbor).

## 13. Social & gifting (later milestone — trading user-locked to post-launch)
- One-way gifting with guardrails at first: Accept/Decline popup, daily gift limit, progression-gated receiving (new accounts can't receive high-value packs — the teardown's gifted-pace problem is a design bug we avoid), "Block Gift requests" toggle.
- Two-way trading: post-launch update only, after economy is proven. Separate spec when scheduled.

## 14. Data model (save schema per player)
```
cash, luckMult, cashMult, plotSlots, conveyorTier,
storage[ {cardID, foil, level, grade, trait, valueCache} ],
displayed[ slot → storageRef ], packQueue[ {packID, foil, timerEnd} ],
dailyStreak, lastDailyClaim, lastOfflineTs, playtimeLadderState,
tokens {grade, training}, potions[ {line, tier, expires} ],
passes[ ], upgrades {expansion, luck, cash, time, speed},
index[ cardID+foil → owned ], badges {towerFloor, netWorth}
```

## 15. Telemetry (required for regional campaigns)
Log per player (country-level, Roblox policy-compliant): pack opens by pack, $/s, session length, return visits, chase pulls, campaign participation. Campaign dashboards need: pack-open rate, retention, and chase-pull rate per region per Hero Drop.

## 16. Roblox policy & moderation
- Show real odds on every pack (required). No misleading odds ever — the teardown's honesty rule is ours.
- No real leagues/teams/logos/player names anywhere in game text (parody canon). Card names are the roster's parody names.
- Chat-safe: no external trading promises; gifting UI is the only transfer channel.
- All art passes the moderation guardrails (art spec §7b) before upload; canary upload test before mass upload (pending queue item).

## 17. Build milestones for Kimi Code
- **M1 — Blockout core loop:** conveyor podium + 3 starter packs, pack timers, reveal ceremony (placeholder frames), display plot with drip $/s, Sell stall at 50%, save/load. Acceptance: a fresh player completes buy→open→place→sell→reinvest in <3 minutes; numbers match §2–3 formulas.
- **M2 — Leveling + full rung ladder:** L1–50 curves (§6), all 45 rungs priced (economy v1.1), timer growth, Index skeleton with real card data from the roster. Acceptance: teardown formulas reproduced exactly (spot-check 3 cards: ×1.18, ×1.35, ×0.15, 50%).
- **M3 — Grade + Training stations:** odds tables, pity counters, token currencies, slab/trait applied to value. Acceptance: odds + pity verifiable in logs.
- **M4 — Evolution:** 16 recipes from economy v1.1, dupes sink, mutations slot.
- **M5 — Retention + monetization:** §9–10 in full, offline accrual, ads, passes, podium. Acceptance: every SKU has a working purchase path; free-player progression math checked (a free player reaches rung ~15 by play alone).
- **M6 — Art integration:** swap placeholders for real card frames (band ribbon + foil frame + grade slab overlays on base art from the repo). Pipeline note: 492 base PNGs × 13 foil frames — overlay at runtime, not baked.
- **M7 — Combat:** Boss Match + Legends Ladder (§12). **M8 — Social:** gifting guardrails, leaderboards (§13).

## 18. What we deliberately don't copy
- No fake generosity: odds shown are odds rolled. No hidden throttling.
- No gifted-pace balancing: economy is tuned for solo play; gifting is guardrailed (§13), so VIP-fed speed runs aren't possible.
- No rebirth treadmill: depth comes from foils × levels × grades × traits × evolutions, not resets.
- Free-player integrity: every cash price is earnable by play; Robux is speed, not gate.
