# Loop state — updated by the loop itself each wake

- milestone: M1 — vertical slice (per specs/sports-legends-master-build-spec-v1.md)
- IN SCOPE: pack buy/spawn → place on pedestal → timed open with odds reveal → card generates boxes on conveyor → carry → sell for cash → card upgrade raises rate → save/load persistence → FTUE tutorial → 2 packs, ~12 cards, basic HUD. Grey/placeholder art.
- OUT OF SCOPE: full 22-sport roster, mutations/variants, crafting, plaza, events, most passes, polish, card art production.

## Acceptance tests (all must pass in solo playtest)
1. Player spawns; FTUE tutorial completes end-to-end.
2. Buy a pack, place it, it opens on timer, a card appears on a pedestal.
3. Boxes generate on the conveyor; carry + sell yields cash at the correct rate.
4. Upgrading a card increases its generation rate.
5. Progress persists across leave/rejoin (ProfileStore).

## State
- status: not started
- next action: build core loop systems in this order: spawn/pack purchase → pedestal/open → box generation → carry/sell → upgrade → persistence → FTUE → HUD
- spend cap: $80-equivalent in credits; spent so far: 0
- halt counter: 0
- last wake: never
