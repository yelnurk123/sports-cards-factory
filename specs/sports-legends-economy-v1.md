# SPORTS LEGENDS CARD FARM — ECONOMY & NUMBERS SPEC v1.1
### The numbers backbone. Cloned from the reference's frame-confirmed economy; reskinned to sports. Kimi Code builds against this file + the Grand Roster + the flow reconstruction.
**v1.1 (2026-08-08, hub):** IP audit renames propagated — foil tier Prizm→Prism (Panini trademark adjacency), rung-table pack names (Esports Battle Bus→Drop Zone, Esports Pajama→CRT), evolution names (WrestleMania Moment→The Mega Moment, Lakers Gold→Skyhook Gold). No numbers changed.

## 0. Canon sources
Reference numbers from the KB teardown (284-screen frame pass, 2026-08-07) + our screenshot sessions (user-confirmed current prices). Where the two disagreed, screenshots win on price, teardown wins on mechanics.

---

## 1. Currencies
| Currency | Role | Source |
|---|---|---|
| **Cash ($)** | soft currency | selling cards/boxes (50% of value), offline earnings, dailies, group 1.25x |
| **Grade Gems (blue)** | grade rolls | Tower floor 100+, ads, shop |
| **Trait Gems (purple)** | trait rolls | Tower floor 200+, ads, shop |
| **Raid Shards** | artifact leveling | any boss |
| **Boss Shards (per boss)** | boss card crafts + raid shop | that boss |
| **Robux (R$)** | monetization | — |
Suffix ladder: $ → K → M → B → T → Qa → Qi → Sx → Sp → Oc → N → Dc → Ud → Dd.

---

## 2. The five multipliers (the card formula)
**Card value = Base × Foil × Level × Grade × Trait**

### 2a. Base ($/Card by rarity band)
Card base = **pack rung price ÷ 10**. The 4 cards inside a pack spread 0.7× / 0.9× / 1.1× / 1.3× around that center.

### 2b. Foil ladder (13 tiers) — anchored to measured Golden ×1.5, Diamond ×2, Venomous ×3
| # | Foil | × | # | Foil | × |
|---|---|---|---|---|---|
| 1 | Base | 1 | 8 | Sapphire | 20 |
| 2 | Silver | 1.5 | 9 | Ruby | 32 |
| 3 | Gold | 2 | 10 | Galactic | 50 |
| 4 | Platinum | 3 | 11 | Cosmic | 100 |
| 5 | Holo | 5 | 12 | Owner | 200 |
| 6 | Prism | 8 | 13 | **One of One** | 400 |
| 7 | Chrome | 12 | | | |
(v1 tunable; anchors fixed by measurement. Foil rolls at pack spawn and shows on the pack.)

### 2c. Level (max 50) — the ×3300 law
L1→L50 multiplies value **×3300** (reference-confirmed on 4 cards). Per-level ≈ ×1.18 compounding. Level-up cost scales with card base × level step (reference points: band-1 card L1→2 = $2, L2→3 = $3; band-9 card L1→2 = $80K). MAX badge at 50.

### 2f. Earnings model (the drip, exactly)
- A card's displayed **$/Card = its earning rate**. Every ~5s a box spawns on the conveyor worth **Σ(all placed cards' current $/Card)**. HUD "You make: $X/s" = Σ ÷ 5. Evidence: 1×$10 card → $2/s; ~$180 combined → $36/s; one L50 chase card → income $437.5K/s → $117.8T/s (teardown).
- **Level value curve:** ×1.18/level, ×3300 at L50 (Fog Slayer $320K → $1.42M L10 → $1.07B L50; Ice Queen L4 $32 → L5 $38 = ×1.1875; Ice Princess L1 $15 → L9 $56 = 1.179⁸).
- **Level cost curve (v1):** cost(L→L+1) = **base × 0.125 × L** early bands, **base × 0.25 × L** top tiers. Confirmed points: Common L1→2 $2 · L2→3 $3–5 · L4→5 $12 · L5→6 $16 · Transcendent L1→2 $80K.
- **Maxing ROI:** L1→50 costs ≈ **160× base**, returns **×3300** — ~20× ROI. This is the retention engine: leveling is the clearest legible lever, and it's why the pull→level→re-place loop holds players for months.

### 2d. Grade (reskin of Rank) — rolled at the Grading Machine
| Grade | ×Cash | Odds | Grade | ×Cash | Odds |
|---|---|---|---|---|---|
| Poor | 1x | 32% | Mint | 2x | 3.82% |
| Fair | 1.1x | 26% | Grade 9 | 3x | 1% |
| Good | 1.2x | 18% | Grade 9.5 | 6.5x | 0.1% |
| Very Good | 1.35x | 12% | Grade 10 | 8x | 0.05% |
| Near Mint | 1.6x | 7% | **Gem Mint 10** | 10x | 0.02% |
| **Pristine Black Label** | 12x+ | unpublished | | | |
Pity: **Gem Mint guaranteed in 1500 rolls, Black Label in 4000.** RNG both ways (can slide down). Cost scales with card value; roll at Level 1 always (costs scale with level).

### 2e. Traits — rolled at the Traits Machine (sports names)
| Trait | Effect | Odds |
|---|---|---|
| Clutch I / II | 1.1x / 1.3x Cash | 16% / 10.7% |
| Ironman I / II | 1.1x / 1.3x Stamina | 16% / 10.7% |
| Sniper I / II | 1.1x / 1.3x Power | 16% / 10.7% |
| Warrior | 1.5x Power + 1.5x Stamina | 1% |
| Wall | 1.2x Power + 1.75x Stamina | 1% |
| Franchise | 2x Cash | 0.4% |
| Emperor | 1.2x Cash + 1.5x Power + 1.5x Stamina | 0.3% |
| Phoenix | 1.75x all | 0.14% |
| **GOAT** | 2x all | apex (pity 4000) |
Pity: 1500 / 4000 rolls. Cost: 1 Trait Gem/roll or cash (scales with card value).

**Worked example:** Byson (Immortal-band base $3.2M) at One of One ×400, L50 ×3300, Gem Mint ×10, GOAT trait ×2 ≈ **$84.5Dd/Card** — one card outweighs the whole early board, exactly like the reference.

---

## 3. The rung ladder (45 rungs, 115 packs, 2–3 sports per rung)
Price rule: pack price per rung; card base center = price ÷ 10; timer = pack open time (before Time Boost −24% / VIP −20%).

| Rung | Price | Card base | Timer | Packs (sport pack) |
|---|---|---|---|---|
| 1 | $100 | $10 | 5s | Soccer Street · Boxing Club Fighter · Athletics Track |
| 2 | $250 | $25 | 8s | Soccer Sunday League · Baseball Sandlot · WWE Jobber |
| 3 | $500 | $50 | 12s | Esports Rookie Rift · Golf Clubhouse · Cricket Gully |
| 4 | $1.0K | $100 | 15s | Soccer Academy · MMA Regional · Basketball Streetball |
| 5 | $2.0K | $200 | 20s | NFL Campus · Baseball Little League |
| 6 | $4.0K | $400 | 30s | Soccer Pro · Basketball Playground · Esports Lane Legend |
| 7 | $8.0K | $800 | 45s | Racing Karting · Tennis Club · Cricket Club |
| 8 | $15K | $1.5K | 60s | Soccer All-League · MMA Prospect · Golf Tour |
| 9 | $30K | $3K | 90s | Baseball Minor League · NFL Pro · WWE Midcard |
| 10 | $60K | $6K | 2min | Soccer Star · Tennis Next Gen |
| 11 | $120K | $12K | 2.5min | Soccer Superstar · Basketball Pro · Racing Sprint |
| 12 | $250K | $25K | 3min | MMA Contender · Esports GOAT Rift |
| 13 | $500K | $50K | 4min | Soccer Icon · Baseball Farm |
| 14 | $1.0M | $100K | 5min | Racing Grand Prix · Tennis Tour · Soccer Legend |
| 15 | $2.0M | $200K | 6min | NFL All-Pro · Basketball All-Star |
| 16 | $4.0M | $400K | 8min | Athletics Sprint · Soccer World Class |
| 17 | $8.0M | $800K | 10min | MMA Title · Golf International |
| 18 | $15M | $1.5M | 12min | Soccer Galactico · Basketball Superstar |
| 19 | $30M | $3M | 15min | Racing Endurance · Cricket Pace |
| 20 | $60M | $6M | 18min | Tennis Grit · Soccer Immortal |
| 21 | $100M | $10M | 20min | Basketball Champion · NFL Star |
| 22 | $200M | $20M | 25min | MMA Striker · Baseball All-Star |
| 23 | $400M | $40M | 30min | Esports Headshot · WWE Attitude |
| 24 | $700M | $70M | 35min | Basketball Legend · Soccer Eternal |
| 25 | $1.5B | $150M | 40min | Racing Grid · Cricket Wall |
| 26 | $3.0B | $300M | 45min | Tennis Pioneer · Golf Major |
| 27 | $6.0B | $600M | 50min | MMA Champion · Baseball Ace |
| 28 | $12B | $1.2B | 55min | Esports Tactical · NFL Champion |
| 29 | $25B | $2.5B | 60min | Basketball Immortal · Athletics Distance |
| 30 | $50B | $5B | 70min | Soccer GOAT tier approaches · Racing Heritage |
| 31 | $100B | $10B | 80min | NFL Legend · MMA Queen |
| 32 | $200B | $20B | 90min | Baseball Slugger · Esports CRT |
| 33 | $400B | $40B | 100min | Basketball Dynasty · WWE Next Era |
| 34 | $700B | $70B | 110min | MMA Pioneer · Tennis Elegant |
| 35 | $1.5T | $150B | 120min | Racing Champion · Cricket Legend |
| 36 | $3.0T | $300B | 130min | Golf Masters · Athletics Field |
| 37 | $6.0T | $600B | 140min | Basketball Eternal · Baseball Legend |
| 38 | $12T | $1.2T | 150min | Esports Drop Zone · MMA King |
| 39 | $25T | $2.5T | 165min | WWE Extreme · NFL Immortal |
| 40 | $50T | $5T | 180min | WWE Main Event · Boxing Warrior |
| 41 | $100T | $10T | 195min | Tennis Major · Boxing Heavy |
| 42 | $200T | $20T | 210min | Racing Legend · Cricket GOAT |
| 43 | $400T | $40T | 225min | NFL Eternal · Baseball Cooperstown |
| 44 | $700T | $70T | 240min | MMA GOAT · Boxing Immortal · Tennis GOAT |
| 45 | $1.5Qn | $150T | 270min | **Soccer GOAT · Basketball Dynasty-top: Eternal, WWE Icon, Golf Legend, Athletics GOAT, Esports Ancient & Emperor** |

(Apex rung intentionally hosts the 7 GOAT-tier packs — the endgame shelf. Final per-rung spread ≤3 packs below apex; tuning pass after first playtest.)

---

## 4. Evolution (craft) values — priced above each sport's top band
Reference pattern: evolution cards price ~2–5 rungs above their ingredient band. Components destroyed (5 cards + cash), output L1, foil forced/rolled via Mutations slot.
| Evolution | Output base | | Evolution | Output base |
|---|---|---|---|---|
| The Thrilla | $2.0Qn | | Champion's Camp | $6.0T |
| The Eternal Debate | $10.0Qn | | The Silver Arrow | $4.0T |
| Galactico XI | $1.5T | | Calendar Slam | $3.0T |
| Dream Team '92 | $8.0Qn | | The Mega Moment | $8.0T |
| Skyhook Gold | $1.5Qn | | The Grand Slam | $2.5T |
| The Hail Mary | $5.0Qn | | The Ashes Urn | $2.0T |
| Sandlot Immortal | $1.0Qn | | Lightning Strike | $2.5T |
| Heavyweight Crown | $500T | | World Champion (esports) | $12.0T |
| Black Label chase craft (post-launch) | $2.0Dd | | | |

---

## 5. Sinks & sell-back
- **Sell-back: 50% of card value** (endgame cash source = selling whole rare cards/packs).
- **Conveyor upgrade: uncapped**, ~5× per level (reference: $1K → $50T+). Levels unlock faster belts + more luck.
- **Base Expansion: uncapped** (+1 slot; reference anchors: 21 slots $100T → 29 slots $8.0Qn). Start: 10 slots.
- **Boosts (capped):** Cash Boost +200% MAX · Time Boost −24% MAX · Luck Boost (uncapped per reference behavior) · Speed Boost.
- Dual-priced (cash or Robux), cash price escalates per level.

## 6. Time walls
- Pack timers per rung (table above): 5s → 270min. Endgame base holds 8+ queued packs.
- Craft timers: 50–70min per evolution tier. Robux skip (reference: 109 R$ for 55min).
- Boss Raid: opens every 60min, 15-min entry window, 5-min fight, 4 phases + RAGE. 1 fight/hour.
- Tower: auto-battle climb; milestone drops (Cash 25% F1+, Grade Gems 10% F100+, Trait Gems 16% F200+).
- Daily Rewards 24h (7-day ladder) · PlayTime 12 rewards, resets on leave · Free Rewards 4 ads/day.

## 7. Robux catalogue (user-confirmed current display prices)
**Bundles:** Starter 9 · Pro 64 · Master 280 · Royal 80/240/640 (1/3/10).
**Passes:** VIP 160 (−20% timer, ×1.5 cash, name tag) · Auto Conveyor 720 (Auto Spawn/Buy/Mutations Warn) · 2x Cash 96 · 2x Offline Cash 64 · 2x Luck 120 · 4x Luck 400 · 2x Tower Speed 160 · 2x Roll Speed 240.
**Convenience:** Skip All 160 · Recover Pack 20 · double offline 24 · Server Luck 40 (+5min).
**Cash packs:** 9 / 20 / 40 / 104 / 320.
**Gem packs:** 30 / 150 / 650 / 1.5K / 5K → 40 / 104 / 400 / 720 / 1,600.
**Limited stock (One of One cards):** 360 / 800 / 3,840 with global stock counters (1000/400/125 style).
**Premium packs with published odds:** skeleton 48.5 / 32 / 14 / 5 / 0.5% and 48.5 / 34 / 15.4 / 1 / 0.1%.
**Pricing trick:** configure at API price, display at ×0.8 with struck anchor (reference behavior, frame-confirmed).

## 7b. Complete dev-product catalogue (API prices, user-provided; display = ×0.8)
**Passes (permanent, with creation dates):** 2x Cash 119 (May 15) · 2x Luck [STACKS] 149 · 4x Luck [STACKS] 499 (2×4=8x multiplicative) · 2x Offline Cash 79 · VIP 199 · Auto Conveyor 899 (Jul 4) · 2x Tower Speed 199 (Jun 6) · 2x Roll Speed 299 (Jun 13).
**Server Luck ladder (consumable, server-wide):** 2x 49 · 4x 249 · 6x 999 · 8x 2,999 · **16x 4,999** (+ "[Extra 5 min]" variants at 199/2,999/4,999). The whale-funded admin-abuse engine.
**Direct pack buys (any rung for Robux):** Ice 4 · Sand 19 · Inferno 49 · Lightning 89 · Hightech 154 · Dark 199 · Eclipse 289 · Isekai 399 · Slayer 499 · Monarch 649 · Pirate King 799 · Demon 949 · Manga 1,099 · Galaxy 1,249 · Heaven 1,499 · Soccer 1,999 · Void 1,799 · Bizarre 2,499 · Empyrean 2,299 · Titan 2,699 · Evolved 2,799 · Ruin 3,199 · Chaos 3,099 · Oni 2,999 · Grimoire 2,999 · Mage 3,299 · Beast 3,399 · Viking 3,499.
**Bundle packs:** Starter 9 · PRO 79 · MASTER 349 · Royal 99/299/799 [x10 20% OFF] · Diamond 299/899/2,499 [x10 25% OFF].
**Limited stock (price-tested, tuned to drain):** Pirate King 599→499 · Phantom Monarch 1,999→1,499 · Curse King 449→799→499 · Infinity Sorcerer 1,499→999 · Sun God 1,999 · Temple Guardian 1,000 · Abyss Lord 2,499 · Titan Ravager 3,999. (Screenshot era: Almighty King 449, Vision Striker 999, Ember Elf 4,799 API → displayed 360/800/3,840.)
**Skips:** <5MIN 9 · <10MIN 14 · <30MIN 29 · <60MIN 59 · <120MIN 99 · <240MIN 149 · <360MIN 199 · Skip All Packs Timers 199. (Corrects the video's "35 R$" — API is authoritative.)
**Convenience:** Recover Pack 24 · CLAIM ALL (PlayTime) 449 · X2 Offline Reward 29 · X4 Offline Reward 54 · Reward Ad 3.
**Upgrade products (dual-price R$ arm):** Base Expansion 99 · Cash Upgrade 34 · Luck Upgrade 29 · Speed Upgrade 19 · Time Upgrade 24.
**Cash packs:** Small 9 · Simple 24 · Medium 49 · Large 129 · MEGA 399 [90% OFF].
**Gems (Rank & Trait, same ladder):** Small 49 · Medium 129 · Large 499 · Huge 899 · Mega 1,999.
**×0.8 display rule holds on every SKU in the list.**

## 8. Onboarding curve (first 60 seconds, cloned)
$100 start → buy rung-1 pack ($100) → place on pedestal (OPENING IN 5s) → Skip 5min offer → first card (band-1, $10/Card) → carry box → sell (+$10) → tutorial complete → first upgrades ($2, $3) → first wall at ~3 minutes (can't afford next upgrade).
Daily Rewards fires before the tutorial on return visits.

## 9. Tuning notes
- All v1 numbers marked tunable: foil multipliers (anchors at 1.5/2/3 only), rung prices (formula-smoothed), evolution outputs, apex crowding.
- First playtest targets: does the first wall land ~3 min? Does one L50 chase card swing the board? Is the ×3300 law felt?
- Robux sheet: Skip 5min = 9 R$ (API-confirmed via dev products, §7b). Full catalogue cloned; ×0.8 display rule applies to all SKUs.
