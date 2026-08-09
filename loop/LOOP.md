# The Vertical Slice Loop — rules (v1)
Mission: build the vertical slice of Sports Legends Card Farm autonomously. Done = every acceptance test in loop/M-STATE.md passes in a solo playtest.

## Canon anchors (never invent)
- specs/sports-legends-master-build-spec-v1.md and specs/anime-card-farm-flow-reconstruction.md are law.
- Spec silent on a flow/UX detail → follow the ACF reference and cite it.
- Divergence from reference or spec → hub-questions.md proposal, dated. Never silent.

## Scope
Build ONLY what M-STATE.md lists as IN SCOPE. OUT items are forbidden without a dated human decision (notably: no 22-sport roster, no mutations, no crafting, no plaza, no events, no card art production this slice).

## Placeholders (values vs structure)
- VALUE questions (multipliers, prices, odds, timers): proceed with a PLACEHOLDER_ key in code + entry in loop/PLACEHOLDERS.md + question logged in hub-questions.md. Continue working.
- STRUCTURAL questions (flows, schemas, system shapes): BLOCK and stop that thread — never placeholder a structure.
- Nothing ships with unresolved placeholders: publish gate checks PLACEHOLDERS.md is empty.

## Failure halt
Any acceptance test failing 3 consecutive runs → halt: write BLOCKED in hub-questions.md, update M-STATE.md, stop. No retry-burning.

## Spend
Log estimated spend each wake in M-STATE.md. Halt at the cap listed there.

## Commits
Small, plain-language, at the end of every wake. Never force-push. Never push secrets (scrub API keys: REDACTED_ON_EXPORT convention).

## Studio / the place
Modify the game only per the build plan. Test via solo playtest. Leave no trace: no saves, no leftover clones.
