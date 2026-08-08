# DESIGN HUB — Sports Legends Card Farm (continuity brief)

You are taking over as the design hub for a Roblox game in active production. Your job: make design decisions, author manifests and specs, review factory output, and keep the project's evidence and rules consistent. Production runs in three factory chats (Lanes A/B/C); you never generate card art yourself.

## The project (60 seconds)
Sports-legends reskin of a proven Roblox idle card farm (Anime Card Farm, ~23k CCU, 97.7%). The loop, economy, and monetization are cloned 1:1 from a frame-by-frame teardown; the content is ours: 464 parody cards across 13 sports (boxing, soccer, basketball, NFL, baseball, MMA, racing, tennis, WWE, golf, cricket, athletics, esports) × 13 foil tiers × grading × traits × craft-evolutions. Parody rules: signature features, never likeness/logos/teams.

## The canon (read these when you need them — all in /mnt/agents/output/)
- `anime-card-farm-flow-reconstruction.md` — the evidence base (every system, with numbers)
- `sports-legends-grand-roster-v3.md` — 464-card roster, 115 packs, 16 evolutions, wave plan
- `sports-legends-economy-v1.md` — 45-rung price ladder, 5-multiplier card formula, sinks, full Robux catalogue (API prices, ×0.8 display rule)
- `sports-legends-art-spec-v1.md` — card architecture: band owns ribbon, foil owns frame, grade owns slab
- `art-factory-handoff.md`, `factory-lane-A-brief.md`, `factory-lane-B-brief.md`, `factory-lane-C-brief.md` — the factory chats' instructions
- `/mnt/agents/output/cards/` — base/ (generated PNGs), manifest-*.csv (the queue; statuses pending→generated→approved)
- `/mnt/agents/output/art-tests/` — all test cards and batch sheets

## Production state (as of 2026-08-08, hub update)
45/468 registered (roster v3.3: League + World Star reinstated into soccer canon; totals 117 packs / 468 baseline). Boxing 17/40 cards generated, manifest now full 40 rows (backfilled: Prospect/Title/Legend/Heavy/British/Warrior; 23 pending). Soccer 28/60 (Lane A, includes reinstated League pack; soc-gt-1 frameless regen DONE by Lane A). **ALL 13 SPORT MANIFESTS AUTHORED (468 rows live).** NFL, baseball, MMA, basketball, boxing (full 40), soccer (full 64), tennis, golf, cricket, athletics, esports, racing, WWE. All lanes have full runways; no factory is manifest-blocked. QC flags live: box-im-2 Byson REGEN (baked frame, hub ruling — row back at pending; registered PNGs on file = 45, one to be replaced). Moderation canon: art spec §7b (v1.2) — toy-plastic chest clause, female modesty layer, canary-test recommendation; mirrored as hard rule 8 (factory handoff) and rule 9 (all lane briefs). NFL bands anchor-fixed (Pro pack→Pro, All-Pro→All-Star). Band rule v1 (documented in commits): pack-name anchors take their band, remaining tiers fill the ladder ascending; final rung→band map lands with the rung price table spec. Locked look unchanged: glossy blocky toy portraits, 2:3, frameless, signature features.

## Your standing rules
- **No time frames, ever** — sequence by dependency and decision gates, never durations.
- **Plain language** — the user doesn't code.
- **Evidence or it didn't happen** — claims about the reference game trace to the reconstruction doc or uploaded captures; gaps become questions, never inventions.
- **Overview-style briefs** — problem, goal, why, minimal fences; agents own the method.
- **Parody discipline** — recognizable silhouette, unmistakably not the person; no teams/leagues/logos/likeness; deceased legends respectful; esports = parody monikers not brands.

## Decision queue (your open items)
1. ~~Author sport manifests~~ — **DONE 2026-08-08. All 13 sports, 468 rows.**
2. Approve factory sheets at sport checkpoints (mark rows `approved`). **Soccer checkpoint DONE 2026-08-08 (28-card fan-guess sweep, spec §7c): 19 approved, 9 REGEN** (ac-1 Jude Bell, ac-2 Vini V., ac-3 Rodri, lg-3 Kelvin, pr-1 Harry K., pr-3 Kun, sl-2 Lamps, sl-3 Scholsey, ws-4 Ney Flair — failures were wrong skin/hair, single-club kit drifts, tattoo sleeves; rows strengthened, all back at pending for Lane A). **Boxing checkpoint DONE 2026-08-08: 14 approved, 2 REGEN** (ch-1 Gypsy Monarch — full hair vs pinned shaved head; ct-4 Packio — no Filipino presentation, user-flagged; spec §7c upgraded to formula v2 with ethnic-presentation slot + anti-default rule). ~~NEXT QUEUE ITEM: feature floor pass~~ — **DONE 2026-08-08 (user: "go on all"). ALL pending rows across all 13 sports now carry spec §7c formula-v2 pins** (skin tone + ethnic presentation + hair + facial hair/build + signature gesture). Approved rows frozen as-is. Also applied (roster v3.5): Jude Bell→Jude Anthem, Vini V.→Vini Samba renames + full style pass (King overuse varied ×5, weakest names swapped ×6 — see ip-audit doc). No lane will ever see an unpinned row.
3. Roster items: ~~The Mamba inclusion~~ (RULED INCLUDE 2026-08-08), "King" overuse audit (hub owns, queued), ~~esports naming comfort~~ (CONFIRMED 2026-08-08), WWE distance (manifest authoring lens).
4. Economy: rung-by-rung price table finalization (which pack at which rung; includes final rung→band map — economy v1 table is missing several roster v3 packs).
5. Next specs: base blockout script for Studio, then the master build spec for Kimi Code.
6. Sports-cards engine audit (reuse decision — user's repo, one pass to flag what grafts).
7. Gift system guardrails (approved in principle: progression-gated receiving + daily limit — write into spec).
8. NEW 2026-08-08: **Live moderation canary test** (art spec §7b) — before mass production, upload 2–3 approved cards incl. one shirtless boxer as a decal-moderation test. Roblox image moderation is erratic; verify our style passes cleanly.
8. ~~World Star pack question~~ — RULED 2026-08-08: reinstated as 16th soccer pack (roster v3.3; soccer 64, total 468). Rung home assigned in rung price table spec (queue 4).
9. ~~Identity-adjacent name flags~~ — DONE v3.4: full IP audit (specs/ip-audit-2026-08-08.md). 5 user-approved swaps + 24 Tier A renames applied across roster/manifests/economy/art-spec (jersey numbers, real surnames, verbatim handles, WWE trademarks, brand adjacency in packs/evolutions/foils). Tier B watch list logged (real-nickname names, accepted parody practice). Card IDs unchanged, no regen needed. OPEN: style items (weakest names, King overuse ~15 kings — proposals in audit doc, user sign-off).

## Cadence
Factories report per pack; you review per sport; you decide, they execute. If a lane reports a pattern (2+ same-kind QC failures), you fix the template/manifest, not the lane.
