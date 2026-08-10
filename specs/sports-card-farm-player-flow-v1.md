# PLAYER FLOW MICRO-SPEC v1 — the connecting tissue
### The exact step-by-step physical flow of the core loop. Canon, 2026-08-10.
**Why this file exists:** the master spec pins the seven-step skeleton; this file pins the micro-beats BETWEEN the steps — who carries what, what spawns where, what the player's hands are doing. When this conflicts with a coarse reading of the master spec, this file wins for flow.
**Evidence tags:** [REF] = flow reconstruction (35-screen pass) · [TD] = teardown (284-screen frame pass) · [USER] = user-confirmed from play, 2026-08-10. Numbers still come from economy v1.1; this file owns FLOW, not numbers.

---

## F1 · Buying a pack (the conveyor is a spawn machine, not a vendor shelf)
1. The plot has ONE pack conveyor with a **Spawn Pack kiosk** at its head — a pedestal showing a face-down "?" pack. [REF-A3]
2. The player presses the **buy button** → exactly **ONE pack spawns at the center of the belt**. [USER] Which pack spawns follows the conveyor ladder/selection (M1: the cheapest unbought rung the player can afford; conveyor settings UI comes later [REF-A4]).
3. The player walks up and **buys it off the belt** (prompt shows pack name, price, and the odds panel trigger). Cash leaves the moment of purchase. [REF-A5, USER]
4. The pack goes **into the player's hand** (hotbar item, pack visible in-hand). [REF-A5: "Lightning Pack (Normal)" held, hotbar slot] [USER]
5. **No Pack / Recover Pack R$** affordance sits near the kiosk — recovering a lost pack is a paid convenience. [REF-A3]

**NOT this:** three packs standing on sale pedestals with ProximityPrompts (M1 blockout shortcut — replaced by F1).

## F2 · Placing & hatching
6. The player **carries the pack** to a free pedestal on their plot and places it (prompt). The pack is no longer in the hotbar; it stands in the world. [TD, USER]
7. The hatch timer starts on placement: billboard **"OPENING IN mm:ss"** [TD], duration from the economy rung table. Timestamp-based (survives rejoin).
8. When the timer ends the pack stays on the pedestal, ready. The player **presses it again to open**. [USER] The reveal ceremony fires (one card, band ribbon, foil shine — master spec §4). [REF-A5]
9. The pulled card goes to the player's inventory; on first pull it auto-places to a free display slot (later: player chooses, "Equip Best" exists [TD]). [TD: "You carry the card"]

## F3 · The drip (how a card earns — the "poop" mechanic)
10. Each displayed card periodically **drops a small card token** onto the plot's OWN mini-conveyor — a separate belt from the pack belt. One token per card per tick (~5s); token value = that card's current $/Card. [USER; numbers: economy §2f]
11. Tokens ride the mini-belt and **accumulate into physical card boxes** stacked by the belt. A box's value = the sum of what went into it. [TD: "The box gains value as cards accumulate"; REF-A16: cardboard boxes stacked by the belt]
12. Boxes wait to be collected (cap on uncollected boxes — M1 ships 5; tuning, not canon).

## F4 · Collecting & selling (income is a carry loop, not a cash faucet)
13. The player **presses a box to collect it** → the box becomes an item in hand/inventory immediately. [USER]
14. The player **carries boxes to the Sell stall** (Plaza, NPC — the reference's "Card Hunter" [TD]) and sells them via the NPC dialog. Box sale = the income cash-out, paid **1:1** (boxes ARE earned income; the 50% rate does NOT apply here). [REF-A9 "E · Sell Card Boxes!", TD sell dialog]
15. The same Sell NPC dialog also sells **cards** (the deliberate 50%-of-value action) and packs — reference dialog pattern: sell inventory / this item / cards only / packs only / nevermind. [TD]
16. Only after selling does cash land. HUD "You make: $X/s" = Σ(displayed $/Card) ÷ 5 regardless of collection state — it's a rate readout, not a balance. [REF-A8, economy §2f]

**NOT this:** boxes auto-crediting cash on touch (M1 blockout shortcut — replaced by F4). The walk to the Sell stall is the retention beat: it keeps the player circulating through the Plaza where the stations and offers live.

## F5 · The whole loop, one breath
Spawn kiosk → one pack on the belt → buy → pack in hand → carry to plot → place → timer → press to open → reveal → card displays → card drops tokens onto the mini-belt → tokens build into boxes → collect boxes → carry to Sell stall → cash → walk back richer → spawn the next, pricier pack. [TD seven-step loop, micro-beats per F1–F4]

---

## Open flow questions (for user playtest, not invented)
- Does the base have its own box-sell NPC, or only the central Plaza stall? (REF-A9 shows a "Sell Card Boxes" sign near a base; TD shows the central stall.) v1: ONE Sell stall in the Plaza. If playtest says the base-side sell matters, it becomes a convenience unlock, not a second free NPC.
- Token-to-box consolidation ratio (how many tokens visually make a box) is presentation, not economy — build chat picks, user judges in playtest.
- Whether unbought packs on the belt despawn/return (Recover Pack R$20 exists for a reason [REF-A3]) — M1.1: pack on belt persists until bought or plot reset.
