# CODER ONBOARDING — Sports Card Farm (give this whole document to your AI before its first task)
### Last updated 2026-08-11 by the design hub. The live status pages this points at are always newer than any chat memory — trust the repo, not conversations.

---

## 1. What you're joining

**Sports Card Farm** — a Roblox idle trading-card game. Players buy card packs off a conveyor, hatch them on their plot, cards drip income passively (small token-cards that stack into boxes), and they carry boxes to a vendor for cash that buys the next, pricier pack. It is a disciplined reskin of a proven hit ("Anime Card Farm" — our reference game, studied frame-by-frame and via playthrough). Sports theme, parody players only — NEVER real names, teams, leagues, logos, or likenesses.

The game is live in a real published Roblox place (**"Sports Card Farm", placeId 73099792518377**, private/playtest state).

**The org around you:** the USER is product owner and final judge of feel. The DESIGN HUB (a separate AI) owns canon — specs, rules, decision log, task queue. YOU (and your AI) build code. Work flows: hub writes a mailbox task → you build it → you write a result note → hub reviews → user playtests.

## 2. The repos

| Repo | Role |
|---|---|
| `yelnurk123/sports-cards-factory` | THE repo: game code (`src/`), canon (`specs/`), decisions (`notes/`), evidence, reference materials |
| `yelnurk123/factory-ops` | The mailbox: `ops/mailbox/from-hub/` (tasks TO you), `ops/mailbox/from-code/` (your result notes), `ops/mailbox/archive/` (done) |
| `askarbtw/bloom-brain-knowledge` | Factory-wide brain: alignment pack (working laws), other projects' teardowns |

Standard local layout: `~/factory/sports-cards-factory` and `~/factory/factory-ops`. You push with your own GitHub account (you're a collaborator).

## 3. sports-cards-factory structure

```
src/                    132 Lua files — the actual game (runtime-built world; Workspace is NOT mapped)
  ServerScriptService/MainServer/   Loader + *Service modules: DataService (ProfileStore saves),
                                    PurchaseService (kiosk/belt/foil roll), CarryService, PlacementService,
                                    IncomeService (token drip → box stacks), SellService (vendor + dialog),
                                    WorldService (BUILDS THE WHOLE WORLD AT RUNTIME)
  ReplicatedStorage/Shared/         *Config modules: PackConfig, CardConfig, FoilConfig, BandConfig,
                                    EconomyConfig, MonetizationConfig (all product ids 0 = unpublished)
  StarterGui + ReplicatedStorage    client controllers (HUD, prompts, sell dialog, pack info)
specs/                  CANON — the law, in force-ranked order for their domains:
  sports-legends-master-build-spec-v1.md     the blueprint & milestone ladder
  sports-legends-economy-v1.md               the numbers (value = base × foil × 1.18^(lvl-1) × grade × trait;
                                             income $/s = Σ displayed ÷ 5; sell cards at 50%; 45 rungs)
  sports-card-farm-player-flow-v1.md         v1.3 — the exact physical loop, step by step
  sports-card-farm-environment-v1.md         v1.1 — what stands where (world module map)
  sports-legends-grand-roster-v3.md          468 cards / 117 packs / 13 sports (v3.6 queued: +rugby)
  sports-legends-art-spec-v1.md              card/pack art rules for the art lanes
  anime-card-farm-flow-reconstruction.md     the reference-game anchor doc
  ip-audit-2026-08-08.md                     parody/IP discipline record
notes/                  decisions & state:
  hub-queue.md            THE QUEUE — what's owed/authored/blocked/landed (read this FIRST)
  hub-questions.md        dated decision log — every ruling with citations
  production/state.md     one-page production state (art lanes, build state)
  build-environment.md    Argon/MCP/git ritual on the Mac — READ BEFORE ANY STUDIO WORK
  codebase-audit-m0.md    donor-codebase audit (what was reused from where)
  transcript-frame-reconciliation-2026-08-10.md  evidence master table + frame index
  design-hub-self-report.md                  how the factory works (infra proposals → now landed)
evidence/               proof: 6 video transcripts (video-01…06), dev-products list,
                        user-playthrough-2026-08-10/ (owner's reference screenshots + 2 bug shots)
reference/              the Anime Card Farm teardown: acf-unpacked/ (879-line markdown + 53 frames),
                        images/ + index.json (captioned frame set), original HTML
manifests/              per-sport card manifests (23 CSVs — the roster data)
briefs/                 lane/hand-off briefs (art lanes A/B/C, hub handoff)
```

## 4. What's already built (each hub-reviewed)

| Milestone | State | What it is |
|---|---|---|
| M0 audit | done | donor codebases mapped; reuse/reskin/rebuild verdicts |
| M1 core loop | shipped+reviewed | boot loader, ProfileStore saves (schema v2), conveyor podium, placement/hatch/reveal, Σ÷5 income, 50% sell, HUD, CMDR admin |
| M1.1 flow fidelity | shipped+reviewed | Spawn kiosk + per-run belt packs, **foil rolled at spawn + shown on label**, pack carried in hand (persisted), press-to-open, token lane + crate, walk-in Sell zone 1:1, Card Hunter 5-option dialog with enumerated confirmations |
| M1.2 world pass | shipped (94218d1) | full environment: plaza hub + 8 per-player bases + road circuit, per-base brick spawn structure + own pack belt, 10 pedestals interleaved with 2 token lanes, 8-card box stacks, no-gap walkable world, published into the real place |
| M1.2.1 flow deltas | **in flight** (task 2026-08-11-002) | per-plot Sell vendor (+ teleport retarget), whole-stack carry |
| M2 | next (gated) | leveling + full 45-rung ladder — waits on M1.2.1 + user playtest + the foil spawn-rate spec |

## 5. The LAW (breaking these = rework)

1. **Canon wins over chat.** Specs are the law; `notes/hub-queue.md` is the live queue; `notes/hub-questions.md` is the dated ruling log. When canon is silent on a flow/UX detail, follow the reference anchor and cite it. **Never change course silently** — judgment calls go in your result note as deviations (the hub ratifies or reverses; 13 deviations ratified so far, zero reversals).
2. **Honesty rules:** displayed odds = rolled odds; displayed foil = rolled foil. No placeholders presented as real.
3. **Parody discipline:** no real athletes/teams/leagues/logos/likeness. Recognizable silhouette, unmistakably not the person.
4. **Numbers come from economy v1 only.** Don't invent rates — if a rate is missing, that's a deviation to flag, not a gap to fill.
5. **Secrets:** never in chat, never in repos, never in code. Tokens live in `~/.factory/.env` (chmod 600). You push with your own account.
6. **Studio sync:** one-way MCP push ONLY (`argon build` → `export_rbxm` → import into the real place). **NEVER connect the Argon two-way widget** — it has wiped `src/` three times (empty/mismatched place syncing Studio→files). Full ritual: `notes/build-environment.md`. Workspace stays unmapped — WorldService builds the world at runtime.
7. **Publishing is a user action** — you playtest green in the real place, then tell the user to hit Publish.

## 6. The workflow (mailbox loop)

1. Read `notes/hub-queue.md` → find your task in `ops/mailbox/from-hub/` (self-contained: context, scope, guardrails, done-when).
2. `git pull` both repos. Build. Commit early/often, clear messages.
3. Playtest in the real place via MCP (zero script errors server + client).
4. Write `ops/mailbox/from-code/<task-id>-result.md`: status done, what shipped, playtest evidence, **deviations listed**, commit hashes. Push both repos.
5. Hub reviews; user playtests. If you're told to fix, that's a follow-up task — same loop.
6. Long chats rot: when context gets low, the next task starts in a FRESH chat pointed at its task file — everything needed is in the repos by design.

## 7. Where things stand RIGHT NOW (2026-08-11)

- The full core loop is playable in the real place end-to-end; M1.2.1 (per-plot vendor + whole-stack carry) is the active build task.
- Next big build: **M2** (leveling + 45-rung ladder). Hub debts ahead of it: foil spawn-rate spec, rung→band map.
- Canon queue parked by the user's infrastructure-first hold: roster v3.6 (+rugby, 492 cards), art spec v2.1, bonus-card adoption — do NOT treat as active.
- Later milestones already specced in principle: conveyor automation pass, premium weighted pools, tutorial rail, crafting/traits/ranks, monetization (all product ids currently 0).

## 8. Your first session — checklist

1. Clone both repos; skim `README.md`, then this file.
2. Read `notes/hub-queue.md` (live queue) + `production/state.md` (one-page state).
3. Read `specs/sports-card-farm-player-flow-v1.md` (v1.3) and `specs/sports-card-farm-environment-v1.md` — the game as it must feel.
4. Read `notes/build-environment.md` BEFORE any Studio/git-sync action.
5. Read your task file fully, including any hub addendum at the bottom.
6. Then execute per §6. If anything in canon seems wrong, flag it in your result note — don't route around it.

*Welcome to the factory. The specs are the map; the mailbox is the job board; the result note is your voice.*
