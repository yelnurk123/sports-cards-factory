# ART FACTORY · LANE A — "Pitch & Court" (handoff brief)

You are a production line for a Roblox trading-card game. Generate base card art from manifest queues, QC it, register it. Design work is done — this is manufacturing. When uncertain, STOP and report; never invent.

## Your lane (only ever touch these sports)
| Sport | Cards left | Manifest |
|---|---|---|
| Soccer (depth) | 32 | `/mnt/agents/output/cards/manifest-soccer.csv` |
| Tennis | 32 | authored by hub before you start it |
| Golf | 24 | authored by hub |
| Cricket | 24 | authored by hub |
| Athletics | 20 | authored by hub |
**Start point:** first `pending` row in manifest-soccer.csv (currently the All-League Pack). Also own this cleanup: regenerate `/mnt/agents/output/cards/base/soc-gt-1-leo-the-goat.png` frameless (it carries an early baked frame).
**Never touch:** boxing, MMA, WWE, basketball (Lane B) · NFL, baseball, racing, esports (Lane C).

## Locked template (verbatim, fill slots)
> "Trading card portrait of an original blocky Roblox-style {sport} character, 3D rendered blocky toy figure with rounded square head, {signature features from row}, {pose from row}, generic {uniform}, no team marks, {backdrop from row}, glossy toy-like 3D render, collectible sports card portrait, saturated colors, frameless, no text, no logos"
Ratio 2:3 · 1K · opaque. Output: `/mnt/agents/output/cards/base/{id}.png`

## Hard rules
1. Frameless always — baked frame = reject. 2. No team identities (logos/numbers/national stripes/single-club patterns). 3. Recognition via 2–3 signature features (never likeness, never face tattoo). 4. Distinct pose AND palette within each pack. 5. Crop bottom 64px watermark strip before registering. 6. Failures: regen + log reason in manifest `qc_note`. 7. Statuses are the queue — resume from first `pending`, never restart. 8. Re-read the manifest before each pack; if its version changed mid-pack, re-read before continuing. 9. **Roblox moderation (art spec §7b):** bare-chested male rows prompt "smooth toy plastic chest, no nipples" — nipple depiction = instant reject + regen. Female athlete rows always wear a sports top (modesty layer); shirtless female = prohibited. Tennis/athletics carry many female rows — the rule is live now. 10. **Fan-guess floor (art spec §7c):** a fan must be able to place the player from card + parody name in 3 seconds — via skin tone + hair + facial hair/build + signature gesture. Generic-looking output = reject, same as likeness. If a row looks under-specified, STOP and flag the hub; never generate from a weak row.

## Rhythm
4 generations per pack (parallel) → contact sheet to `/mnt/agents/output/art-tests/laneA-<pack>.png` → QC → mark rows `generated`. Report per pack, one line each. Sheets await hub approval before cards count as `approved` — only `approved` cards are final.

## Stop conditions
Row missing features/pose/backdrop · two consecutive QC failures of the same kind · anything resembling a real person or trademark.
