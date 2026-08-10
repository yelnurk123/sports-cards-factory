# PLAYER FLOW MICRO-SPEC v1.1 — the connecting tissue
### The exact step-by-step physical flow of the core loop. Canon, 2026-08-10 (v1.1: frame-verified).
**Why this file exists:** the master spec pins the seven-step skeleton; this file pins the micro-beats BETWEEN the steps — who carries what, what spawns where, what the player's hands are doing. When this conflicts with a coarse reading of the master spec, this file wins for flow.
**Evidence tags:** [REF] = flow reconstruction (35-screen pass) · [TD] = teardown · [USER] = user-confirmed from play, 2026-08-10 · [FRAME-nn] = extracted teardown frame (`reference/anime-card-farm-teardown.html`, hub extraction 2026-08-10; index in `notes/transcript-frame-reconciliation-2026-08-10.md`) · [VIDEO-0n] = Gemini viewing-log transcript in `evidence/`. Numbers still come from economy v1.1; this file owns FLOW, not numbers.
**v1.1 changes (2026-08-10, hub ruling after viewing 17 key frames + all 6 transcripts):** pack foil pre-roll visible at buy (F1) · token lane + ONE crate replaces per-plot mini-belts (F3) · Sell = walk-in zone for boxes + NPC dialog for inventory (F4) · tutorial rail recorded (F0).

---

## F0 · First-session tutorial rail (reference-verified, M2 candidate — M1.1 keeps its in-world sign)
Six bottom-banner steps, in order: **[Tutorial]: SPAWN & BUY YOUR FIRST PACK** → **PLACE THE PACK ON YOUR PLOT!** → **WAIT AND OPEN THE PACK** → wait for first token ("WAIT FOR A CARD TO SPAWN 0/1") → **CARRY YOUR ANIME CARD BOX** → **SELL YOUR ANIME CARD BOX** → banner **"Tutorial Complete! Hunt the rarest Cards!"** + **[Tutorial]: REPEAT & HAVE FUN!** [FRAME-04…10, VIDEO-01]

## F1 · Buying a pack (the conveyor is a spawn machine, not a vendor shelf)
1. The plot has ONE pack conveyor with a **Spawn Pack kiosk** at its head — a pedestal showing a face-down "?" pack. [REF-A3, FRAME-04/05]
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
15. Tokens ride the base's **token lane** — the conveyor running by the plots (red carpet + white arrows in the reference), **a separate belt from the pack belt** — into **ONE wooden crate at the lane's end**. [FRAME-08: arrows on the lane feed a single crate, small cards visible inside; USER: "the conveyor of your plot, seperate to the conveyor where packs appear"]
16. The crate **accumulates**: carried value = Σ of every token that went in since last collection. [VIDEO-01 box values $15/$56/$114 tracking placed cards' values; VIDEO-06 "$146B On Carry"; REF-A16 boxes stacked by belt; TD "the box gains value as cards accumulate"] Visual fill/stack as it grows = presentation (build chat picks, user judges in playtest).
17. Cap on uncollected value stays tuning, not canon (M1 ships 5 boxes' worth).
18. Late game: conveyor upgrades / Auto Conveyor pass **auto-sell at the lane's end** — the manual carry loop is the early/mid game, automation is the unlock. [VIDEO-03 "boxes automatically sell at the end of the belt"; FRAME-11 Auto Conveyor ⬡899] M-later, not M1.1.
19. A **"You make: $X/s"** sign sits by the crate; **"BEST CARD $X/Card"** shows on the HUD. Both are rate readouts, not balances. [FRAME-08/10, VIDEO-02/06]

**NOT this:** one mini-conveyor per plot (v1 wording — replaced by the shared lane + single crate, frame-verified).

## F4 · Collecting & selling (income is a carry loop, not a cash faucet)
20. The player **presses the crate to collect** → the crate/box becomes an item in hand immediately (hotbar shows carried value, "On Carry" style). A fresh empty crate takes its place and starts filling again. [USER, FRAME-08 "CARRY YOUR ANIME CARD BOX", VIDEO-06 "$146B On Carry"]
21. The player **carries the box to the Sell area** (Plaza hub; bases ring the Plaza [FRAME-17]; teleports Plaza / Base / Sell [FRAME-04]).
22. **Box cash-out = walk into the Sell zone carrying boxes** → carried boxes cash instantly at **1:1**. [VIDEO-01 00:55: walks into green "Sell Card Boxes!" zone, box vanishes, cash 85→100; VIDEO-02 02:51; REF-A9] Boxes ARE earned income; the 50% rate does NOT apply to them.
23. The **Sell stall NPC** ("Card Hunter" in the reference) stands at the same spot and opens the inventory dialog — verbatim reference options: **"Got anything to sell?" → 1) I want to sell my Inventory · 2) I want to sell this · 3) I want to sell my cards only · 4) I want to sell my packs only · 5) Nevermind.** Cards sell at the deliberate **50% of value**. [FRAME-09, TD; KB classification: "Cash (soft, from selling cards ~50% of value)"]
24. **Guardrail (hub ruling 2026-08-10):** bulk options ("sell my Inventory") include unplaced CARDS — the reference burns players with this [VIDEO-01 11:27: player loses a wanted Sakura card]. Our bulk options must show a confirmation enumerating contents (count per type + total payout) before committing. Same 5 options, no silent trap.
25. Only after selling does cash land. [economy §2f]

**NOT this:** boxes auto-crediting cash on touch at the crate (M1 blockout shortcut — replaced by F4). The walk to the Sell stall is the retention beat: it keeps the player circulating through the Plaza where the stations and offers live.

## F5 · The whole loop, one breath
Spawn kiosk → one pack on the belt (foil visible) → buy → pack in hand → carry to plot → place → timer → press to open → full-screen reveal → card displays on its pedestal → tokens drip onto the token lane → crate fills → collect crate → box in hand → carry to Sell → walk into zone → cash → walk back richer → spawn the next, pricier pack. [TD seven-step loop, micro-beats per F1–F4, frame-verified]

---

## Open flow questions (for user playtest, not invented)
- Base-side sell: reference has ONE central Plaza stall [FRAME-09/17]. v1.1 keeps ONE stall. If playtest says the base-side sell matters, it becomes a convenience unlock, not a second free NPC.
- Crate fill visuals (tokens visibly stacking, when the pile "looks full") = presentation — build chat picks, user judges in playtest.
- Whether unbought packs on the belt despawn/return (Recover Pack ⬡24 exists for a reason [FRAME-04]) — M1.1: pack on belt persists until bought or plot reset.
- Offer cycling cadence (how fast the spawner rotates declined offers) = conveyor-settings milestone, not M1.1.
