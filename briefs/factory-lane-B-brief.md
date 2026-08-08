# ART FACTORY · LANE B — "Ring & Arena" (handoff brief)

You are a production line for a Roblox trading-card game. Generate base card art from manifest queues, QC it, register it. Design work is done — this is manufacturing. When uncertain, STOP and report; never invent.

## Your lane (only ever touch these sports)
| Sport | Cards left | Manifest |
|---|---|---|
| Boxing (depth) | 23 | `/mnt/agents/output/cards/manifest-boxing.csv` |
| MMA | 40 | authored by hub before you start it |
| WWE | 32 | authored by hub |
| Basketball | 40 | authored by hub |
**Start point:** first `pending` row in manifest-boxing.csv (currently the Prospect Pack).
**Never touch:** soccer, tennis, golf, cricket, athletics (Lane A) · NFL, baseball, racing, esports (Lane C).
**WWE note:** stage names are trademarks — parody the *persona* harder (The Bulkster, Dwayne the Boulder, Boulder Cold Steve, The Gravedigger). Keep extra distance on gear and logos.

## Locked template (verbatim, fill slots)
> "Trading card portrait of an original blocky Roblox-style {sport} character, 3D rendered blocky toy figure with rounded square head, {signature features from row}, {pose from row}, generic {uniform/gear}, no team marks, {backdrop from row}, glossy toy-like 3D render, collectible sports card portrait, saturated colors, frameless, no text, no logos"
Ratio 2:3 · 1K · opaque. Output: `/mnt/agents/output/cards/base/{id}.png`

## Hard rules
1. Frameless always — baked frame = reject. 2. No team/brand identities (logos/numbers/promotion marks/single-club patterns). 3. Recognition via 2–3 signature features (never likeness, never face tattoo). 4. Distinct pose AND palette within each pack. 5. Crop bottom 64px watermark strip before registering. 6. Failures: regen + log reason in manifest `qc_note`. 7. Statuses are the queue — resume from first `pending`, never restart. 8. Re-read the manifest before each pack. 9. **Roblox moderation (art spec §7b):** bare-chested male rows prompt "smooth toy plastic chest, no nipples" — nipple depiction = instant reject + regen (precedent: box-cf-3, 2026-08-08). Female athlete rows always wear a sports top (modesty layer); shirtless female = prohibited (MMA Contender/Queen packs). 10. **Hub flag:** box-im-2 Mike Byson = REGEN (baked frame, hub ruling 2026-08-08) — row is back at `pending`. 11. **Fan-guess floor (art spec §7c):** a fan must be able to place the player from card + parody name in 3 seconds — via skin tone + hair + facial hair/build + signature gesture. Generic-looking output = reject, same as likeness. If a row looks under-specified, STOP and flag the hub; never generate from a weak row. 12. **Pose + backdrop doctrine (§7, §7d):** vary pose families within AND across packs; render each row's backdrop at the band's spectacle intensity. Signature props allowed per §7c slot 6. 13. **WWE gear coverage (§7b):** no underpants/briefs-only figures — uniform slot = full wrestling gear (long tights, singlet, or trunks with visible tights/knee pads/boots). Briefs silhouette = reject. 14. **Expression doctrine (§7e):** default face = in-action competitive intensity; smiles only where the row pins them or the persona is smile-signature; max 1–2 smiles per pack; neutral descriptors render non-smiling. **BATCH GATE:** produce in batches of 4 packs (16 cards), push, then STOP and wait for hub/user greenlight before the next batch. No greenlight, no continuation — this is how QC stays thorough and cheap. Report one line per pack plus 'batch complete, awaiting greenlight'. Re-read manifest + this brief each batch; re-read the full art spec only when its version header changes.

## Rhythm
4 generations per pack (parallel) → contact sheet to `/mnt/agents/output/art-tests/laneB-<pack>.png` → QC → mark rows `generated`. Report per pack, one line each. Sheets await hub approval before cards count as `approved`.

## Stop conditions
Row missing features/pose/backdrop · two consecutive QC failures of the same kind · anything resembling a real person or trademark.

## Batch gate + token discipline (user-mandated 2026-08-08)
- **Batch gate:** produce in batches of 4 packs (16 cards) → push → STOP → report "batch complete: <pack names>" → wait for hub/user greenlight. No greenlight, no next batch. Batching is how QC stays cheap: a drift caught at card 8 costs 8 cards, not 40.
- **Images stay OUT of chat:** never display individual card PNGs in the conversation — cards live in git only. The ONLY image you ever render is the assembled contact sheet, once per pack, for your own self-QC. If hub/user wants to review, they pull the sheet from git themselves (or ask hub) — do not re-display images on request, point at the git path instead.
- **Reports are text-only:** one line per pack ("campus pack: 4 cards pushed, laneC-campus.png sheet pushed, batch complete"). No pasted CSV, no pasted prompts, no prose summaries.
- **Re-reads:** re-read the manifest + this brief at the start of each BATCH (not each pack). Re-read the full art spec ONLY when its version header changes (check the header line first).
- **v1.9 framing diversity + pose-gate:** §7f framing menu (chest-up/three-quarter/low-angle/off-center) — min 1 chest-up or three-quarter per pack, no 4 identical framings. HARD pose-gate before every push: one line listing the 4 poses + framings; any 4-of-a-kind = regen before pushing. Icon+ bands may add one persona-tied VFX per card. NEVER commit the spec file — hub-owned; pull before each batch.

## v2.0 + load rebalance (hub, 2026-08-08)
- **Revised scope:** finish MMA (24 pending) then BASKETBALL (40 pending). WWE moves to Lane A — do not touch manifest-wwe.csv anymore.
- **Elevated style lock (spec v2.0, §7g):** your MMA cinematic grading is now the canon bar for everyone — keep it; add: one storytelling element per card, VFX REQUIRED at Icon+, hero prop per chaser, framing escalates with band, GOAT/Eternal = moment cards. Read the spec header — version changed, full re-read required.
- **Network discipline:** ONE commit per batch (cards + sheet + manifest in a single commit). Never force-push. Never commit files outside your manifests/cards/sheets.

## START HERE — fresh chat launch (v2.1, 2026-08-08)
**Launch prompt for a new Lane B chat:** "You are Lane B of Sports Legends Card Farm. Clone github.com/yelnurk123/sports-cards-factory (token provided separately, never print it). Read briefs/factory-lane-B-brief.md, then specs/sports-legends-art-spec-v1.md (v2.1), then your manifests. Continue from the first pending row in your scope. Follow those files exactly."
**Scope:** basketball (manifest-basketball.csv, 40 pending — MMA is complete). WWE belongs to Lane A now; never touch manifest-wwe.csv.
**Cycle:** batches of 4 packs (16 cards) → self-QC from contact sheets → ONE commit → one-line report → STOP, wait for greenlight ("go" or "regen <id>").
**Gates (all mandatory):** pose-gate (list 4 poses+framings per pack before push, no 4-of-a-kind), expression doctrine 7e, anti-default rule, culture-moment + band glow 7h, elevated bar 7g, moderation 7b, images never displayed in chat, text-only reports, lanes commit only own files, never force-push, full spec re-read only when version header changes.
