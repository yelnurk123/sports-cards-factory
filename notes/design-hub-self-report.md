# Design Hub — Self Report
### Current reality, as asked. 2026-08-10. Plain and complete.

---

## 1. How I work right now

**Environment:** I run in the hub chat (this conversation) with a sandbox that wipes between turns except `/mnt/agents`. My working clones live in `/mnt/agents/work/`. The factory repo is cloned **blobless + sparse** (specs/manifests/briefs/notes/src — not `cards/`, `art-tests/`, `reference/` images): the full repo is ~1.5GB of card art and the mount chokes on it. For my job — text canon, code review — that's the right trade.

**Read order on startup:** (1) `notes/agent-alignment-pack.md` in bloom-brain-knowledge — wins over everything; (2) canon in this repo: master build spec, economy, roster, art spec; (3) mailbox state in factory-ops; (4) git log of this repo to see what shipped while I was away.

**Where I write:** canon and decisions into THIS repo (`specs/`, `notes/`), tasks into `factory-ops/ops/mailbox/from-hub/`, nothing anywhere else. Committed immediately, dated, plain language. I never write game code — analysis and specs only.

**Coordination:** async over git via the mailbox. I file tasks (`from-hub/`), the build chat (Kimi Code on the Mac, `~/factory/sports-cards-factory`) claims them, ships, files results (`from-code/`); I review the actual diffs against acceptance criteria, then archive the task. Art lanes run in their own chats with their own briefs; I don't manage them live — their state reaches me through this repo's git log (manifest/card commits). The user is the transport for anything Studio: playtests, publishing, dashboard products. Decisions that are genuinely his get asked; everything else gets ruled, dated, and logged in `notes/hub-questions.md`.

**Review standard:** evidence or it didn't happen. I read shipped code and trace every claim (formulas, names, odds) back to canon before I call a milestone passed.

## 2. What exists and what state it's in

**Canon (committed, ruling):**
- `specs/sports-legends-master-build-spec-v1.md` — the blueprint. Amended today: reference-anchor rule in the header, income formula corrected (Σ÷5), flow spec linked.
- `specs/sports-legends-economy-v1.md` (v1.1) — numbers backbone. Amended today: §2a one-card-per-pack ruling (25% pool, 0.7/0.9/1.1/1.3 spread).
- `specs/sports-card-farm-player-flow-v1.md` — NEW today, canon for flow: spawn kiosk → one pack on belt → carry in hand → place → press-to-open → token drip on plot mini-belt → boxes → carry to Sell stall. Evidence-tagged per step.
- `specs/sports-legends-grand-roster-v3.md` — at v3.5 in repo. 117 packs, 468 baseline, 13 sports.
- `specs/sports-legends-art-spec-v1.md` — at v1 in repo (v2.1 authored, not pushed — see queue).
- `notes/codebase-audit-m0.md` — the reuse map the build follows.
- `notes/hub-questions.md` — decision log, 6 dated entries (income ruling, cards-per-pack, game name = Sports Card Farm, chase-slot rule, foil-rate debt, flow spec).

**Build state:** M1 shipped and hub-reviewed — pass. M1.1 (flow fidelity: kill vendor pedestals + touch-collect, build the carry loop) tasked as `2026-08-10-002`, high priority. Argon scaffold live; user's place "Sports Card Farm" syncs files→Studio.

**Art production:** ~92%+. Per repo evidence: WWE complete (Lane B commit: WWE 32/32). Rugby 24 in flight (Lane C, prompt delivered). Regen queue 5 (Lane A: glf-ms-1, glf-ms-3, soc-wc-1/2/4). Bonus cards awaiting adoption: hockey 8, olympians 12, cricket culture 4 — user answered "no preference," hub carries **adopt all** into roster v3.6.

**Queued canon (authored or owed, NOT landed):**
- Roster v3.6: rugby section (+24), totals 468→492, 117→123 packs, 13→14 sports, Index 6,084→6,396 + bonus adoption. Blocked on: user green light (implicit via "no preference"? I want one explicit "go").
- Art spec v2.1: culture-moment rule (min 1/pack) + band rim-light coding. Authored, push failed previously; rugby/WWE prompts already carry it inline.
- Foil spawn-rate spec — MY DEBT, owed before M2 (economy has 13 multipliers, zero spawn odds; M1 correctly shipped without foil rolls).
- Rung→band map — MY DEBT, owed before M2 (spec §3 prices packs by band until this lands).
- Naming pass (~half of "the"-names → second-name style) — deferred post-production, IDs stable.
- Gift guardrails detail (M8), moderation canary upload test, step-gated tutorial decision (M1.1 shipped an in-world sign instead; fine for now).
- M2 task (leveling + full 45-rung ladder) — not yet written; waits on M1.1 + user playtest + foil spec.

## 3. What I'm missing

- **Eyes on the reference frames.** The teardown HTML embeds ~284 base64 images (8.8MB). My sandbox fetch of the raw file timed out; the frames aren't in git as files. Fix is already tasked (`2026-08-10-003`: build chat extracts frames + commits to `reference/images/` with index.json). Until then every visual claim I make is secondhand — flagged as such. **No visual pass done yet.**
- **Gemini transcripts** of gameplay videos: not in any repo. Build chat is hunting the Mac; if they live only in the research chat, the user must drop them into `reference/transcripts/`.
- **Card art QC:** by convention images stay out of chats and my sparse clone excludes `cards/`. I QC art by manifest + lane reports, not by looking. If hub-side visual QC becomes required, I need a contact-sheet-per-sport text-described report or a deliberate exception.
- **No push awareness:** I see the world by pulling. If the build chat ships mid-conversation, I know only when I next fetch. Works, but it's polling, not subscription.
- **Network:** my GitHub access is flaky (TLS drops, ~2 retries per push). Annoying, worked around with backoff loops. The 1.5GB full clone is impossible from here — sparse/blobless is permanent for me.
- **No Studio:** I can't run the game. Review = diffs + the build chat's MCP playtests + the user's hands. The feel layer (reveal drama, timer rhythm) is only verified by the user.
- **Mac `.env`:** held the revoked personal token (broke the build chat's knowledge-repo read). User instructed to swap in the bot token; unverified.
- **factory-o / factory-op:** duplicate repos, access granted as asked; deletion recommended, pending user action.

## 4. What I'd change if the infra reorganized around me

1. **A `notes/hub-queue.md`** — the canon queue as a tracked file (item, state: owed/authored/blocked/landed, blocker named). Right now the queue lives in handoff text between chats; that's how v2.1 got lost the first time. One file, always current, first thing every new hub chat reads after the alignment pack.
2. **Reference material unpacked, once:** `reference/images/` (frames + index.json), `reference/transcripts/`, `reference/README.md` describing what's there. After that, the "extract base64 from an 8.8MB HTML" workaround dies. Any future chat gets eyes in one `git checkout`.
3. **`production/state.md`** — one page: per-sport card counts, lane status, regen queue, bonus cards awaiting decisions. Currently reconstructed from git log archaeology every time. Lanes append one line per batch; hub owns the file.
4. **Land the queue:** roster v3.6 + art spec v2.1 + bonus adoption in one push (needs the user's "go"). Canon debt accrues interest — the build is already catching up to files that don't exist yet (foil rates, rung→band map).
5. **Spec state labels** (shelf/cart/built/cut per alignment pack §6) on build-spec milestones and roster packs, so "what's real vs decided vs idea" is readable in-file instead of inferred from three documents.
6. **Housekeeping:** delete factory-o/factory-op; verify `~/factory/.env` carries the bot token (documented in ARGON-SETUP or the pack); one canonical local layout note (`~/factory/<repo>` per game) inside the alignment pack — it says it, but every new chat should fail loudly if it's missing.
7. **Keep the mailbox exactly as is.** It works. The only addition: a convention that result notes list deviations explicitly (the M1 result did this well — deviations 1–8 were the most useful part).

*Report ends. Next moves I see: land `2026-08-10-003` (frames), review M1.1 when it ships, write the foil-rate spec, then M2.*
