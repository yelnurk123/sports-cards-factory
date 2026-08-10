# Transcript & frame reconciliation — 2026-08-10
### All 6 Gemini transcripts read end-to-end + 53 frames extracted from `reference/anime-card-farm-teardown.html` (8.8MB, base64-embedded) and the 17 flow-critical ones viewed. This note is the working table; distilled rulings live in `notes/hub-questions.md`; flow canon in `specs/sports-card-farm-player-flow-v1.md` (v1.1).
**Source discipline:** transcripts are AI viewing-logs (evidence/README.md) — trusted for OCR'd UI text, discounted on inference. Frames are ground truth. User's first-hand play description outranks transcript inference. Nothing here comes from audit-source games (WCRNG/Fish).

---

## 1. What got CONFIRMED (canon already matches — no change)

| Claim in our canon | Verification |
|---|---|
| $/s = Σ(displayed $/Card) ÷ 5 | FRAME-08: $10/Card card → "You make: $2/s" sign. VIDEO-06: Σ≈6.5×10²⁹ ÷ 5 × 5.10 VIP × 2 boost = displayed $1.3N/s. Multipliers stack OUTSIDE the ÷5 |
| Level curve ×1.18 → ×3300 at L50 | VIDEO-05: Dark Saber L1 $6.91O → L50 $22.99N (~×3300); KB classification "level(<=50, x3300)" |
| Upgrade cost 0.25×base×1.35^(L−1) | FRAME-10: base $10 card → L1→2 costs $2 (formula: $2.5 floored), L2→3 costs $3 (formula: $3.4 floored) |
| Sell dialog: 5 options, cards at 50% | FRAME-09 verbatim: "Got anything to sell?" / sell my Inventory / sell this / cards only / packs only / Nevermind. KB: "Cash (soft, from selling cards ~50% of value)" |
| Grade pity 1500/4000 | FRAME-21/22: "UR Guaranteed in 1500 Rolls / LR Guaranteed in 4000 Rolls" on both machines |
| Card value = base × finish × level × rank × trait (5 multipliers) | KB classification block: "card value = name*rarity * finish * level(<=50, x3300) * rank * trait" |
| 13 finishes, worst→best | VIDEO-03 hierarchy: Normal, Golden, Diamond, Venomous, Rainbow, Sakura, Candy, Blessed, Radioactive, Glitch, Starfallen, Admin, Unknown — matches FRAME-14 Index tabs and our 13 foils |
| One pack at a time on the belt, bought at a window | FRAME-04/05: Spawn Pack podium, single pack at the buy window, "E Buy" |
| Hatch = timestamped wait, press to open, full-screen reveal | FRAME-06 ("OPENING IN 00:03", "E Skip 5min"), FRAME-40/41 (full-screen card + foil glow) |
| Displayed card = standing billboard, upgrade pad at foot, E Remove | FRAME-08/10 |
| Storage 150, Equip Best, hotbar carry | FRAME-34 ("Storage 2/150", "Equipped 3 best cards!"), VIDEO-02 (70/150) |
| Foil = colored glow on card art; rank = corner letter badge | FRAME-41 (Diamond green glow), FRAME-22 (green "E" badge top-left) — aligns with art spec v2.1 rim-light coding |
| Index counts card×finish as separate entries | FRAME-14: "2/2132 Collected", finish tabs. Ours: 492×13 = 6,396 (already in hub-queue) |

## 2. What got AMENDED (v1 → v1.1, rulings in hub-questions)

| Was (v1 / M1.1 task) | Now (v1.1) | Proof |
|---|---|---|
| Foil rolled at open | **Foil rolled at pack spawn, shown on label pre-buy; card inherits** | FRAME-05 "Normal/Common/Ice Pack/$100"; VIDEO-02 "Candy Conquest Pack"; VIDEO-03 pre-roll; VIDEO-01 buy-or-wait |
| One mini-conveyor per plot | **ONE shared token lane (by the plots, separate from pack belt) → ONE wooden crate at lane end; crate accumulates Σ** | FRAME-08 (arrows feed single crate); VIDEO-01 box $15/$56/$114; VIDEO-06 "$146B On Carry"; USER "seperate to the conveyor where packs appear" |
| Boxes sold via NPC dialog | **Boxes cash out by walking into the Sell ZONE (instant 1:1); NPC dialog = inventory only (cards 50%)** | VIDEO-01 00:55 zone walk-in; VIDEO-02 bin; FRAME-09 dialog at same stall |
| (no guardrail) | **Bulk sell options confirm with enumerated contents first** | VIDEO-01 11:27 loses wanted Sakura to "sell my Inventory" |
| (no tutorial spec) | **F0: 6-step banner rail recorded (M2 candidate)** | FRAME-04…10; VIDEO-01 |

## 3. Reference systems we DON'T build now (parked, cited for later milestones)

- **Conveyor Settings / automation** — Auto Spawn / Auto Buy / Mutations Warn, pack × mutation filter checklists, conveyor levels ("More Luck! / Upgrade Conveyor" cash pad). Pass-locked (Auto Conveyor ⬡899 current; ⬡359→649→899 across updates). [FRAME-11/12, VIDEO-02/03/06]
- **Pack ladder shape** — 9 cash tiers (Ice Common → Slayer Transcendent) then premium named tiers (Chainsaw, Eternity, Academy, Dynasty, Grail, Conquest, Blaze, Devour, … ~41 total). Cash prices $100 → $131.2Dd. Input for the rung→band map (hub debt). [FRAME-11/12, VIDEO-02/03]
- **Suffix ladder** — $ K M B T Qa Qi Sx Sp Oc N Dc Ud Dd (goes far past our 45-rung $1.5Qn; ladder extension is an economy-spec future). [VIDEO-03/04/05/06]
- **Rank machine (post-pull gem roll, F 1×→UR 10×, Level-1 meta)** — our grade rolls at open; machine pattern parked for any post-pull sink. [FRAME-21, VIDEO-04/05/06]
- **Traits machine** — purple gems; Fortune/Vigor/Strength I–III 16.7/10.7% … Rich 0.4% (2× Cash), Tank 1%, Almighty <0.14%. [FRAME-22, VIDEO-04/05]
- **Card Craft (evolution)** — recipe of specific cards + cash, components DESTROYED, level irrelevant, output L1 with mutation odds = weighted mix of components' mutations, real-time craft timer (55–70min, Robux skip). [VIDEO-05/06]
- **Combat meta** — Infinity Tower (1v1 auto-battle, floors, main free gem/potion faucet), Boss Raid (4 difficulties, damage gates, artifacts with passive buffs, 1h cooldown). [VIDEO-04, FRAME-25…31]
- **Potions** — Cash/Luck/Mutation/Production/Time, tiers I–III, stackable. [VIDEO-02/03/04]
- **Live-ops** — server events (Server Luck 6×, 2× packs, 10× money), Admin Abuse spawns. [VIDEO-02/03]
- **Gifting** — placed card → "Gift!" → Accept/Decline popup. (Guardrail detail already queued for M8.) [VIDEO-02, FRAME-38]
- **Monetization price list** — dev-products-and-passes.txt archived: skips 9–199R (5min→360min + Skip All 199R), Recover Pack 24R, X2/X4 Offline 29/54R, cash packs 9–399R, gem packs 49–1999R, Robux packs 4R (Ice) → 3499R (Viking), limited-stock cards 499–4999R, server luck 49–4999R. VIP: −20% pack timer, ×1.5 cash, name tag. [dev-products-and-passes.txt, VIDEO-06]
- **Retention** — Daily Rewards 7-day track, PlayTime Rewards 12-rung session ladder, rewarded ads (4/day), like-goal board. [VIDEO-02, FRAME-03/36/37/39]
- **Starting cash** — $100 (VIDEO-01) vs $200 (FRAME-04, different build). Ours stays per EconomyConfig; note only.

## 4. Frame index (which frame proves what — route future questions here)

| Frames | Proves |
|---|---|
| 01–02 | Game icon; leaderboards (tower floor 963 soft-cap) |
| 03 | Daily Rewards first screen (D1 $100 … D7 card) |
| 04 | Spawn area: Spawn Pack podium, No Pack/Recover Pack ⬡24 pad, Upgrade Conveyor pad, Conveyor Settings pad, teleports, left rail, $200 |
| **05** | **Buy window: pack on belt, label Normal/Common/Ice Pack/$100, E Buy — foil pre-roll visible** |
| 06 | Plot grid; hatching ice block "OPENING IN 00:03" + "E Skip 5min" |
| 07 | Full-screen reveal: $10/Card Frosty Fighter Common Normal |
| **08** | **THE drip: card billboard + token lane arrows feeding ONE wooden crate (cards inside) + "You make: $2/s" + "Skip All ⬡160" + "BEST CARD $10/Card" + CARRY tutorial** |
| **09** | **Sell stall: 5-option dialog verbatim; SHOP/SELL/UPGRADE awning row** |
| **10** | **Displayed card: Level 2, $11/Card, $3 upgrade pad, E Remove; "Tutorial Complete!"** |
| **11/12** | **Conveyor Settings: 9 cash packs (Common→Transcendent) then premium tiers; Auto Conveyor ⬡899; Conveyor Lvl** |
| **13** | **Exclusive Shop: premium packs = 5-card weighted pools, displayed odds, 0.5% LIMITED, "All Mutations Possible*"** |
| **14** | **Index: finish tabs (13), 2/2132, padlocked "???" entries** |
| 15/16 | Same card across finishes (Normal $2.0K → Golden ×1.5 → Venomous ×3.0) |
| **17** | **World layout: Plaza hub (stalls, stations, tower) ringed by bases; arrowed road** |
| 18–20 | UPGRADE stall (Base Expansion/Luck/Cash/Time/Speed, cash or Robux); Items stall materials; potion details |
| **21/22** | **Rank Machine (F 1× 32% … UR 10× 0.02%; pity 1500/4000); Traits Machine (Fortune/Vigor/Strength; pity); rank letter badge on card** |
| 23/24 | Card Craft: 13 evolution recipes; recipe detail (3 specific cards + $) |
| 25–31 | Boss Raid (portal, team of 4, 4 phases, rewards); Infinity Tower (floors, 1v1 auto-battle, milestone rewards) |
| 32/33 | Native store tabs; limited-stock chase podiums (Venomous Almighty King $45.6B/Card ⬡449, 669/1000 left) |
| **34** | **Cards panel: Storage 2/150, Equip Best, search, hotbar** |
| 35–37 | Upgrades caps (Cash Boost +200% MAX → 3.00×); PlayTime Rewards ladder; rewarded ads |
| 38 | Gifting Accept/Decline popup |
| 39 | Like-goal collective board |
| **40/41** | **Reveal ceremony: full-screen card, $/Card + name + tier + finish, foil-colored glow; background plots show own hatch timers** |
| 42–53 | YouTube thumbnail proof (clippable moments; demand signals) |

*Extracted set: 53 JPEG frames, 6.5MB, hub-local at `~work/teardown-frames/` (with index.json). Canonical repo copy = mailbox task 2026-08-10-003 → `reference/images/`.*
