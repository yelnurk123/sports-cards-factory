# PLAYER FLOW MICRO-SPEC v1.3 — the connecting tissue
### The exact step-by-step physical flow of the core loop. Canon, 2026-08-11 (v1.3: per-plot Sell vendor + whole-stack carry — user first-hand).
**Why this file exists:** the master spec pins the seven-step skeleton; this file pins the micro-beats BETWEEN the steps — who carries what, what spawns where, what the player's hands are doing. When this conflicts with a coarse reading of the master spec, this file wins for flow.
**Evidence tags:** [REF] = flow reconstruction · [TD] = teardown · [USER] = user-confirmed from play · [FRAME-nn] = extracted teardown frame (index in `notes/transcript-frame-reconciliation-2026-08-10.md`) · [VIDEO-0n] = Gemini transcript in `evidence/` · [US-n] = user's own reference-playthrough screenshots, `evidence/user-playthrough-2026-08-10/` (US-1 world plaza · US-2 spawn structure · US-3 plot lanes · US-4 box fill). Numbers still come from economy v1.1; this file owns FLOW, not numbers. PLACE (what stands where) lives in `sports-card-farm-environment-v1.md`.
**v1.3 changes (2026-08-11, hub ruling on user first-hand correction):** **each plot has its OWN Sell vendor** — boxes are sold at your base, not carried to the Plaza (F4; kills the "plaza walk is the retention beat" inference) · **Carry takes the WHOLE stack** of boxes at a box point, not just the top box (F3.18 — the v1.2 ruling was wrong, user-verified).
**v1.2 changes (2026-08-11, hub ruling on the user's first-hand evidence):** box = exactly 8 token-cards, new box spawns ON TOP when full (F3) · token lanes run per pedestal-column-pair, each ending in its own box point (F3) · pack belt is per-base, not a shared plaza belt (F1; supersedes M1.1 deviation 5).
**v1.1 changes (2026-08-10, hub ruling after viewing 17 key frames + all 6 transcripts):** pack foil pre-roll visible at buy (F1) · token lane + crate replaces per-plot mini-belts (F3) · Sell = walk-in zone for boxes + NPC dialog for inventory (F4) · tutorial rail recorded (F0).

---

## F0 · First-session tutorial rail (reference-verified, M2 candidate — M1.1 keeps its in-world sign)
Six bottom-banner steps, in order: **[Tutorial]: SPAWN & BUY YOUR FIRST PACK** → **PLACE THE PACK ON YOUR PLOT!** → **WAIT AND OPEN THE PACK** → wait for first token ("WAIT FOR A CARD TO SPAWN 0/1") → **CARRY YOUR ANIME CARD BOX** → **SELL YOUR ANIME CARD BOX** → banner **"Tutorial Complete! Hunt the rarest Cards!"** + **[Tutorial]: REPEAT & HAVE FUN!** [FRAME-04…10, VIDEO-01]

## F1 · Buying a pack (the conveyor is a spawn machine, not a vendor shelf)
1. **Each base has its OWN pack conveyor** (per-base belt — environment v1, E1.5 [US-2]; the M1.1 shared plaza belt was a blockout compromise, superseded). The brick spawn structure at the base's front-left holds the **Spawn Pack kiosk** — a podium showing a face-down "?" pack. [REF-A3, FRAME-04/05, US-2]
2. The player presses the **buy button** → exactly **ONE pack spawns at the center of the belt**. [USER] Which pack spawns follows the conveyor ladder/selection (M1.1: the cheapest unbought rung the player can afford; conveyor settings UI comes later [REF-A4, FRAME-11/12]).
3. **The pack's foil is rolled at spawn, not at open, and is shown on the pack label before purchase** — reference label stack: finish · pack tier · pack name · price ("Normal / Common / Ice Pack / $100"). The card inside inherits the pack's foil. [FRAME-05; VIDEO-02 "Candy Conquest Pack" placed and opened Candy; VIDEO-03 mutation pre-roll]. M1.1: move the foil roll into PurchaseService at spawn; displayed foil = rolled foil (same honesty rule as odds). Foil RATES unchanged — the foil spawn-rate spec (hub debt, before M2) replaces placeholders then.
4. The player walks up and **buys it off the belt** (prompt shows pack name, price, foil, and the odds panel trigger). Cash leaves the moment of purchase. [REF-A5, USER, FRAME-05 "E Buy"]
5. The pack goes **into the player's hand** (hotbar item, pack visible in-hand). [REF-A5, USER, FRAME-34 hotbar]
6. **No Pack / Recover Pack R$24** affordance sits near the kiosk — recovering a lost pack is a paid convenience. [REF-A3, FRAME-04; dev-products "Recover Pack!" 24R]
7. Buy-or-wait is real gameplay: offers the player declines effectively pass (late game: spawner cycles; auto-buy filters by pack × mutation [VIDEO-01 05:32 refuses Normal/Golden and waits; VIDEO-02 auto-buy]). M1.1 keeps button-spawn only; cycling = conveyor-settings milestone.

**NOT this:** three packs standing on sale pedestals with ProximityPrompts (M1 blockout shortcut — replaced by F1).

## F2 · Placing & hatching
8. The player **carries the pack** to a free pedestal on their plot and places it (prompt). The pack is no longer in the hotbar; it stands in the world as a translucent themed block. [TD, USER, FRAME-06 ice block]
9. The hatch timer starts on placement: billboard **"OPENING IN mm:ss"** [TD, FRAME-06/41], duration from the economy rung table. Timestamp-based (survives rejoin). Many packs hatch in parallel, each with its own timer. **The pack's foil shows on the placed block's label** ("Candy Conquest Pack" [VIDEO-02]).
10. A **Skip** prompt rides the hatching pack (reference: "E Skip 5min", priced per remaining time [FRAME-06; VIDEO-01]; skip pricing = monetization milestone).
11. When the timer ends the pack stays on the pedestal, ready. The player **presses it again to open**. [USER] The reveal ceremony fires: **full-screen card overlay** — card art fills the screen with foil-colored glow, text stack $/Card · name · tier · foil. [FRAME-40/41, REF-A5]
12. The pulled card goes to the player's inventory; on first pull it auto-places to a free display slot (later: player chooses, "Equip Best" exists [FRAME-34]). [TD: "You carry the card"]

## F3 · The drip (how a card earns — the "poop" mechanic)
13. Each displayed card stands on its pedestal as a big vertical card billboard (name · tier · level · $/Card overhead; upgrade pad at its foot; "E Remove" prompt). [FRAME-08/10]
14. Each displayed card periodically **drops a small card token** — one token per card per tick (~5s); token value = that card's current $/Card. [USER; VIDEO-01 "$15/Card" box; FRAME-08 "$10/Card → You make: $2/s"; numbers: economy §2f]
15. Tokens drop onto the **token lane adjacent to the card's pedestal** — navy chevron strips running back → front through the plot, interleaved with the pedestal columns (two pedestal columns per lane; a 10-pedestal starter base has 2 lanes), **separate belts from the pack belt**. [US-3; USER: "the conveyor of your plot, seperate to the conveyor where packs appear"]
16. Each lane terminates at the base's front edge in a **box point**. A box **fills with exactly 8 token-cards; when full, a new empty box spawns ON TOP** (vertical stack). Token value accumulates inside the box they're in. [US-4: box visibly holding ~7 cards, "E Carry $188.5K"; USER 2026-08-10: "it needs 8 cards to be added to fill up and have a new box spawn on top"; REF-A16 boxes stacked by belt]
17. Stack cap = **5 boxes per point** (tuning, not canon); the drip pauses while a 6th box would be needed. [cap lineage: M1's 5-box rule]
18. **"E Carry $X" takes the WHOLE stack** at the box point — every stacked box goes into hand; carried value = Σ of all token-cards in all of them. A fresh empty box starts filling. One carry action, one batch. [USER 2026-08-11: "when you pick up the boxes you pick up all of them not just the top one"; US-4 "E Carry $188.5K" shows the stack total] One carried batch at a time (M1.1 deviation 4).
19. Late game: conveyor upgrades / Auto Conveyor pass **auto-sell at the lane's end** — the manual carry loop is the early/mid game, automation is the unlock. [VIDEO-03 "boxes automatically sell at the end of the belt"; FRAME-11 Auto Conveyor ⬡899] M-later, not M1.x.
20. A **"You make: $X/s"** sign sits by the center box point; **"BEST CARD $X/Card"** billboard at the back fence + HUD strip. All are rate readouts, not balances. [FRAME-08/10, VIDEO-02/06, US-1]

**NOT this:** one mini-conveyor per plot (v1 wording — superseded), nor one single crate per base (v1.1 wording — superseded by per-lane box stacks, v1.2).

## F4 · Collecting & selling (income is a carry loop — to YOUR OWN vendor)
21. Collection = the **"E Carry" on a box point** (F3.18): the whole stack into hand, carried value shown ("On Carry" style). [USER, FRAME-08 "CARRY YOUR ANIME CARD BOX", VIDEO-06 "$146B On Carry"]
22. **Each plot has its own Sell vendor** — an NPC standing on/at the player's base. The player carries boxes a few steps to him. [USER 2026-08-11: "there's a vendor that exists on each plot where you sell him the boxes"; REF-A9 base-side "Sell Card Boxes!" sign; VIDEO-01's short sell runs] The Plaza Sell stall (frame-09) is a duplicate convenience surface, not the box loop.
23. **Box cash-out = walk into the vendor's green "Sell Card Boxes!" zone carrying boxes** → they cash instantly at **1:1**. [VIDEO-01 00:55: walks into the green zone, box vanishes, cash 85→100; REF-A9] Boxes ARE earned income; the 50% rate does NOT apply to them.
24. The **same vendor** opens the inventory dialog — verbatim reference options: **"Got anything to sell?" → 1) I want to sell my Inventory · 2) I want to sell this · 3) I want to sell my cards only · 4) I want to sell my packs only · 5) Nevermind.** Cards sell at the deliberate **50% of value**. [FRAME-09, TD; KB classification: "Cash (soft, from selling cards ~50% of value)"]
25. **Guardrail (hub ruling 2026-08-10):** bulk options ("sell my Inventory") include unplaced CARDS — the reference burns players with this [VIDEO-01 11:27: player loses a wanted Sakura card]. Our bulk options must show a confirmation enumerating contents (count per type + total payout) before committing. Same 5 options, no silent trap.
26. Only after selling does cash land. [economy §2f]

**NOT this:** boxes auto-crediting cash on touch at the box point (M1 blockout shortcut — replaced by F4), nor a Plaza-only sell point (v1.1/v1.2 inference — the vendor is per-plot, user-verified). The carry beat stays physical: crate → vendor is a real walk inside your own base.

## F5 · The whole loop, one breath
Spawn kiosk → one pack on your base's belt (foil visible) → buy → pack in hand → carry to plot → place → timer → press to open → full-screen reveal → card displays on its pedestal → tokens drip onto the adjacent lane → box fills (8 cards) → new box stacks on top → Carry the whole stack → box in hand → walk to your plot's vendor → step into his zone → cash → walk back richer → spawn the next, pricier pack. [TD seven-step loop, micro-beats per F1–F4, frame + user-playthrough verified]

---

## Open flow questions (for user playtest, not invented)
- Plaza Sell stall: kept as a duplicate convenience (frame-09 shows it exists). If it never gets used, it goes; decide after real playtime.
- Whether unbought packs on the belt despawn/return (Recover Pack ⬡24 exists for a reason [FRAME-04]) — M1.x: pack on belt persists until bought or plot reset.
- Offer cycling cadence (how fast the spawner rotates declined offers) = conveyor-settings milestone, not M1.x.
