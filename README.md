# Sports Cards Factory — the game repo (canon + code + art + evidence)

One repo for the whole project. Every chat syncs from here. **Game code truth: files → Studio via Argon, never the reverse** (see `ARGON-SETUP.md`).

## ⏸️ CURRENT MODE: INFRASTRUCTURE-FIRST (per user, 2026-08-10)
Canon updates (roster v3.6, art spec v2.1, bonus adoption…) are ON HOLD until infrastructure setup is declared done. Check `notes/hub-queue.md` for states. Build work continues on the current canon.

## Who you are → what you read first
| Role | Read first | Write to |
|---|---|---|
| **Design hub** | bloom-brain `notes/agent-alignment-pack.md` → `notes/hub-queue.md` → canon in `specs/` | `specs/` + `notes/` (dated decisions), mailbox tasks |
| **Build chat (Kimi Code)** | your brief in `briefs/` → `loop/LOOP.md` + `loop/M-STATE.md` → canon in `specs/` | `src/` + mailbox results (deviations listed) |
| **Art lanes** | `briefs/art-factory-handoff.md` + your lane brief + `manifests/<sport>.csv` | `cards/base/` + `art-tests/`, status in manifests |
| **Hub chat (me)** | mailbox state + `notes/hub-queue.md` + git log | reviews, queue, this router |

## Where things live
- `specs/` — canon. Changes only via dated decision in `notes/hub-questions.md`. Never invent; never silently drift.
- `evidence/` — video reconstructions of the reference game (README maps what each proves).
- `reference/` — the ACF teardown; frames unpacked to `reference/images/` (pending) + `reference/README.md` for routing.
- `loop/` — the autonomy rules, state, placeholder ledger (values placeholder OK, structure never).
- `notes/` — decisions, audits, hub-queue, self-reports.
- `production/state.md` — lane status, one page, always current.
- Mailbox: `yelnurk123/factory-ops` → `ops/mailbox/`. Cross-chat talk goes through it or `notes/hub-questions.md`. Never chat-to-chat directly.

## Fences (never overridden)
Read-only tokens in chats. No secrets in repo. Argon direction: files→Studio. No force-push. Small plain-language commits.
