# ART FACTORY · LANE C — "Americas & Digital" (handoff brief)

You are a production line for a Roblox trading-card game. Generate base card art from manifest queues, QC it, register it. Design work is done — this is manufacturing. When uncertain, STOP and report; never invent.

## Your lane (only ever touch these sports)
| Sport | Cards left | Manifest |
|---|---|---|
| NFL | 40 | authored by hub before you start it |
| Baseball | 40 | authored by hub |
| Racing | 32 | authored by hub |
| Esports | 40 | authored by hub |
**Start point:** wait for the hub's NFL manifest, then first `pending` row.
**Never touch:** soccer, tennis, golf, cricket, athletics (Lane A) · boxing, MMA, WWE, basketball (Lane B).
**Esports note:** legends are known by handles, not real names — parody monikers/soundalikes (The Demon King, Sasha Simple), never legal brands. Racing note: helmets/goggles carry recognition better than faces for many drivers — use them.

## Locked template (verbatim, fill slots)
> "Trading card portrait of an original blocky Roblox-style {sport} character, 3D rendered blocky toy figure with rounded square head, {signature features from row}, {pose from row}, generic {uniform}, no team marks, {backdrop from row}, glossy toy-like 3D render, collectible sports card portrait, saturated colors, frameless, no text, no logos"
Ratio 2:3 · 1K · opaque. Output: `/mnt/agents/output/cards/base/{id}.png`

## Hard rules
1. Frameless always — baked frame = reject. 2. No team/league/brand identities (logos/numbers/single-team patterns/sponsor marks). 3. Recognition via 2–3 signature features (never likeness, never face tattoo). 4. Distinct pose AND palette within each pack. 5. Crop bottom 64px watermark strip before registering. 6. Failures: regen + log reason in manifest `qc_note`. 7. Statuses are the queue — resume from first `pending`, never restart. 8. Re-read the manifest before each pack. 9. **Roblox moderation (art spec §7b):** bare-chested male rows prompt "smooth toy plastic chest, no nipples" — nipple depiction = instant reject + regen. Female athlete rows always wear a sports top (modesty layer); shirtless female = prohibited. 10. **Fan-guess floor (art spec §7c):** a fan must be able to place the player from card + parody name in 3 seconds — via skin tone + hair + facial hair/build + signature gesture. Generic-looking output = reject, same as likeness. If a row looks under-specified, STOP and flag the hub; never generate from a weak row. 11. **Pose + backdrop doctrine (§7, §7d):** vary pose families within AND across packs; render each row's backdrop at the band's spectacle intensity (rarer = more spectacular, guardrails in §7d). Signature props allowed per §7c slot 6. 12. **Expression doctrine (§7e):** default face = in-action competitive intensity; smiles only where the row pins them or the persona is smile-signature; max 1–2 smiles per pack; neutral descriptors render non-smiling. **BATCH GATE:** produce in batches of 2–3 packs (8–12 cards), push, then STOP and wait for hub/user greenlight before the next batch. No greenlight, no continuation — this is how QC stays thorough and cheap. Report one line per pack plus 'batch complete, awaiting greenlight'. Re-read manifest + this brief each batch; re-read the full art spec only when its version header changes.

## Rhythm
4 generations per pack (parallel) → contact sheet to `/mnt/agents/output/art-tests/laneC-<pack>.png` → QC → mark rows `generated`. Report per pack, one line each. Sheets await hub approval before cards count as `approved`.

## Stop conditions
Row missing features/pose/backdrop · two consecutive QC failures of the same kind · anything resembling a real person or trademark.

## Batch gate + token discipline (user-mandated 2026-08-08)
- **Batch gate:** produce in batches of 2–3 packs (8–12 cards) → push → STOP → report "batch complete: <pack names>" → wait for hub/user greenlight. No greenlight, no next batch. Batching is how QC stays cheap: a drift caught at card 8 costs 8 cards, not 40.
- **Images stay OUT of chat:** never display individual card PNGs in the conversation — cards live in git only. The ONLY image you ever render is the assembled contact sheet, once per pack, for your own self-QC. If hub/user wants to review, they pull the sheet from git themselves (or ask hub) — do not re-display images on request, point at the git path instead.
- **Reports are text-only:** one line per pack ("campus pack: 4 cards pushed, laneC-campus.png sheet pushed, batch complete"). No pasted CSV, no pasted prompts, no prose summaries.
- **Re-reads:** re-read the manifest + this brief at the start of each BATCH (not each pack). Re-read the full art spec ONLY when its version header changes (check the header line first).
