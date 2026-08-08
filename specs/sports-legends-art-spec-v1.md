# SPORTS LEGENDS — ART PRODUCTION SPEC v1.1
### Card architecture, template rules, and the production manifest. Companion to Grand Roster v3.2 (names) and Economy v1 (values).
**v1.1 (2026-08-08, hub):** baseball pose library extended with pitching poses (windup / delivery / follow-through) — the roster carries dedicated pitcher packs (All-Star, Ace, Eternal) and the batting-only library would have forced invention. Signature-features column now lives in the per-sport manifests (closes checklist item).

## 1. Core principle
Each progression system answers a different question, so each owns a different visual zone. They never fight.
- **Rarity band** (10) = *where it came from* → ribbon tab
- **Foil** (13) = *what finish it rolled* → frame + texture
- **Grade** (11) = *what the machine certified* → slab
- **Level** = cash upgrade → MAX badge at 50
- **Trait** = roll → small icon slot

Read at a glance: "Immortal band · Holo foil · Gem Mint 10 · MAX · GOAT trait."

## 2. Card = layered stack (bottom → top)
1. **Base art** — blocky toy render, frameless, watermark cropped
2. **Foil wash** — aura/tint by foil tier
3. **Foil frame + texture** — 13-frame overlay
4. **Ribbon** — rarity band tab
5. **Serial number** — chase/limited cards only ("04/10")
6. **Autograph** — GOAT / evolution / One of One only (unique scribble per legend)
7. **Slab** — graded cards only: clear case + grade label (replaces ribbon zone)

## 3. Rarity bands (10) — ribbon color per band
Rookie · Prospect · Pro · All-Star · Champion · Icon · Legend · Immortal · Eternal · **GOAT** (mapped from rung bands in Economy §3).

## 4. Foil frame system (13 tiers, worst → best)
| # | Foil | Frame treatment |
|---|---|---|
| 1 | Base | plain cream frame |
| 2 | Silver | silver metallic |
| 3 | Gold | gold metallic |
| 4 | Platinum | dark platinum + shine |
| 5 | Holo | rainbow gradient holo |
| 6 | Prizm | checkerboard prizm border |
| 7 | Chrome | mirror chrome |
| 8 | Sapphire | deep blue crystalline |
| 9 | Ruby | deep red crystalline |
| 10 | Galactic | starfield galaxy |
| 11 | Cosmic | nebula swirl |
| 12 | Owner | black + gold luxury |
| 13 | **One of One** | white-hot prismatic + serial required |
**Vintage cream frame** = reserved treatment for retro-era packs (Cooperstown, Eternal, Legacy packs).

## 5. Grading slab (the Grading machine output)
Ungraded → standard card. Graded → card returns **in a clear slab case** with grade label at top: Poor · Fair · Good · Very Good · Near Mint · Mint · Grade 9 · Grade 9.5 · Grade 10 · **Gem Mint 10** · **Pristine Black Label** (black-label slab, glow). The grade is a costume change, not just a number.

## 6. Chase treatments
- **Serial number:** gold "N/Total" top-right — required on One of One and limited-stock cards.
- **Autograph:** one unique gold scribble per legend, applied to GOAT-pack cards, evolutions, One of Ones.
- **Evolution tag:** "EVOLUTION" badge on craft results; foil set by recipe (Mutations slot).
- **Stat strip:** detail view ONLY (never on pedestal face): SPD / PWR / SKL + era tag ("90s Heavyweight", "Gold Medal Final"). Parked as a future real-system hook (PWR→raid, SKL→tower crit, SPD→clear speed).

## 7. Base art production rules
- **Style:** glossy toy-like 3D render, blocky Roblox-style figure (rounded square head, blocky torso), cel-lit, saturated.
- **Ratio:** 2:3 portrait, opaque backdrop, no text/logos baked in.
- **Signature features (per card, 2–3):** the recognizable non-likeness traits (bald + gap grin = Byson; beard + swept hair = Leo; flat cap + round cheeks = Bambino). Full column to be added to all 460 roster rows.
- **Generic-uniform rule:** no teams, leagues, logos, jersey numbers, national stripe patterns, single-club color identities, sponsor marks, face tattoos, or photo reference.
- **Pose library (per sport):** boxing (champion pose / uppercut), soccer (bicycle kick / strike), basketball (dunk / jump shot), baseball (batting stance / swing / pitching windup / full delivery), NFL (throw / carry), MMA (stance / ground), racing (helmet off / podium), tennis (serve / forehand), WWE (entrance pose / taunt), golf (backswing / putt), cricket (cover drive / bowl), athletics (lightning pose / finish line), esports (chair + headset pose / keyboard flair).
- **Backdrop library (per sport):** ring, night stadium, arena, sunset ballpark, stadium tunnel, octagon, racetrack grid, Centre Court, entrance ramp, 18th green, cricket ground, track finish, dark LAN arena.
- **Watermark:** bottom strip cropped/covered by frame in every output.

## 8. Production pipeline (per card)
1. Generate base art from roster row (name + signature features + pose + backdrop).
2. Crop watermark strip.
3. ×13 foil frames (overlay).
4. ×11 grade slabs (overlay, on graded only).
5. Serial/autograph overlays (chase only).
6. Composite stat strip (detail view variant).
Total unique generations: 460 (one per card). Everything else = code overlays.

## 9. Approval checklist before batch
- [ ] Direction locked: blocky toy portraits (user-approved)
- [ ] Stat strip: detail view only (user-approved pending final confirm)
- [ ] Vintage cream for retro packs (proposed)
- [ ] Slab replaces ribbon on graded (proposed)
- [ ] Pose + backdrop library per sport (proposed, table above)
- [ ] Signature-features column written into all 460 roster rows
