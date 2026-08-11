# Production state — one page, always current
> Lanes append one line per batch; hub owns the file. Rebuilt 2026-08-12 from manifests + git log (the seeded 2026-08-10 version had gone stale — lanes did not append).

## Card production (manifest rows, 2026-08-12)

| sport | rows | approved | generated (awaiting hub checkpoint) | pending |
|---|---|---|---|---|
| soccer (base 64) | 64 | 2 | 59 | 3 (regen queue: soc-wc-1/2/4 — Lane A, still owed) |
| soccer-164 expansion | 100 | **100 (hub checkpoint 2026-08-12)** | 0 | 0 |
| boxing | 40 | 10 | 30 | 0 |
| nfl | 40 | 20 | 20 | 0 |
| basketball | 40 | 0 | 40 | 0 |
| mma | 40 | 0 | 40 | 0 |
| baseball | 40 | 0 | 40 | 0 |
| esports | 40 | 0 | 40 | 0 |
| wwe | 32 | 0 | 32 | 0 |
| racing | 32 | 0 | 32 | 0 |
| tennis | 32 | 0 | 32 | 0 |
| cricket (incl. culture 4) | 28 | 0 | 28 | 0 |
| golf | 24 | 0 | 22 | 2 (regen queue: glf-ms-1/3 — Lane A, still owed) |
| athletics | 20 | 0 | 20 | 0 |
| hockey (bonus, adopted) | 8 | 0 | 8 | 0 |
| olympians (bonus, adopted — 9 sports) | 12 | 0 | 12 | 0 |
| **total** | **592** | **132** | **455** | **5** |

## Open production items
- Regen queue 5 (Lane A): glf-ms-1, glf-ms-3, soc-wc-1/2/4 — carried since 2026-08-08, not yet produced.
- Rugby 24: Lane C prompt delivered 2026-08-10, never produced (Lane C ran esports). Needs lane reassignment or a v3.6 decision.
- Hub checkpoint backlog: 455 generated rows await per-sport hub visual checkpoints (boxing 30, NFL 20, basketball, mma, baseball, esports, wwe, racing, tennis, cricket, golf 22, athletics, hockey, olympians, soccer-base 59).
- Bonus adoption (hockey 8, olympians 12, cricket culture 4) is de facto live in manifests; formal roster v3.6 still parked under the canon hold.

## Build
M1 shipped + hub-reviewed PASS. M1.1 (carry loop) shipped + PASS. M1.2 (world pass, real place 73099792518377) shipped + PASS; one-way MCP push is the sync law (Argon widget suspended). M1.2.1 (per-plot Sell vendor, whole-stack carry) shipped + hub-reviewed PASS 2026-08-12 — awaits user re-publish + playtest, then foil spawn-rate spec → M2.
