# Sports Cards Factory — central hub + game source

Central storage + reference for the Sports Legends Card Farm project, AND the game source (Argon-synced). Every chat (design hub, factory lanes, code agents) syncs from here.

**Game code: this repo is the source of truth** — Studio syncs FROM files via Argon, never the reverse. See `ARGON-SETUP.md`.

## Layout
- `specs/` — the canon: flow reconstruction (evidence base), grand roster v3 (464 cards), economy v1 (numbers), art spec v1 (card architecture), plan.md
- `briefs/` — role briefs. Design hub: `design-hub-handoff.md`. Factories: `art-factory-handoff.md`, `factory-lane-A|B|C-brief.md`
- `manifests/` — per-sport generation queues (manifest-<sport>.csv). Status flow: `pending → generated → approved`
- `cards/base/` — registered base card PNGs (one per card, watermark-free)
- `art-tests/` — review sheets + style test history
- `src/` — game code (Argon project, `default.project.json`):
  - `src/ReplicatedStorage/Shared` — modules both sides use (config, formulas, data)
  - `src/ServerScriptService/Server` — server logic (services, economy, saves)
  - `src/StarterPlayer/StarterPlayerScripts/Client` — client logic (controllers, UI, input)
  - `src/StarterGui/UI` — interface assets
  - `src/Workspace` — static map pieces (M1 builds its blockout map in code)

## Rules of the road
1. **Pull before you act.** `git pull --rebase` before every pack/batch. Never work stale.
2. **Push after you act.** Generated PNGs + manifest status updates go back in the same commit, one commit per pack, message like `laneB: prospect pack (4 cards)`.
3. **Lanes never share a pack.** Lane A = soccer/tennis/golf/cricket/athletics · Lane B = boxing/MMA/WWE/basketball · Lane C = NFL/baseball/racing/esports.
4. **Lanes edit only their own sport manifests.** The hub edits specs and briefs.
5. **Specs/briefs change → hub bumps the version note in the file header and says so in the commit.** Lanes re-read on the next pull.
6. **Only `approved` cards are final.** Factories mark `generated`; the hub marks `approved` after sheet review.
7. **No tokens, keys, or secrets in this repo, ever.**
8. **Code changes commit early and often, plain-language messages.** `.lua` extension convention (Argon `lua_extension true`): `.server.lua` = Script, `.client.lua` = LocalScript, plain `.lua` = ModuleScript.
