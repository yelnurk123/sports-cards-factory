# ART FACTORY — Sports Legends Card Farm (handoff brief)

You are the production line for a Roblox trading-card game. Your job: generate base card art for the Grand Roster (468 cards, roster v3.3), following a locked template, and register each card. The design work is done — this is manufacturing. When uncertain, STOP and report rather than inventing.

## The mission
Fill the queue: every manifest row marked `pending` gets one generated, QC-checked, registered base PNG. Update the row's status to `generated` when done. Report progress per pack with a contact sheet.

## Files you own
- Manifests (read + update statuses): `/mnt/agents/output/cards/manifest-boxing.csv`, `/mnt/agents/output/cards/manifest-soccer.csv` (more sports get their own `manifest-<sport>.csv`)
- Output (one PNG per card): `/mnt/agents/output/cards/base/{id}.png`
- Review sheets: `/mnt/agents/output/art-tests/batch-<pack>.png`
- Style reference (locked look): `/mnt/agents/output/art-tests/byson-features.png`, `leo-features.png`, `bambino-features.png`

## Current queue position (verified 2026-08-08)
- Boxing: 17/40 done. Next: Prospect, Title (rest of), Legend, Heavy, British, Warrior packs.
- Soccer: 28/60 done. Next: All-League, Star, Superstar, Icon, Legend, World Class, Galactico, Immortal, Eternal.
- Then the other 11 sports (basketball, NFL, baseball, MMA, racing, tennis, WWE, golf, cricket, athletics, esports) — manifests get authored per sport before generation.
- ~~CLEANUP FLAG: soc-gt-1~~ — DONE (Lane A frameless regen, 2026-08-08). New flag: box-im-2 Mike Byson carries a baked frame — hub ruled REGEN 2026-08-08 (Lane B owns).

## The locked generation template (use verbatim, fill slots)
Call the image generation tool with:
> "Trading card portrait of an original blocky Roblox-style {sport} character, 3D rendered blocky toy figure with rounded square head, {signature features from manifest row}, {pose from row}, generic {uniform}, no team marks, {backdrop from row}, glossy toy-like 3D render, collectible sports card portrait, saturated colors, frameless, no text, no logos"
Ratio 2:3, resolution 1K, background opaque.

## Hard rules (learned the expensive way — do not skip)
1. **Frameless always.** Frames are code overlays later. Any baked frame/border = reject.
2. **No team identities.** No logos, numbers, sponsors, national stripe patterns, or single-club color signatures (e.g., red body + white sleeves = Arsenal → reject; solid color + trim = fine).
3. **Signature features carry recognition** — 2–3 per card from the manifest (e.g., bald + gap grin; beard + swept hair; headband + toothy grin; tanned + tribal arm tattoos). Never a real likeness, never a face tattoo.
4. **Distinct within a pack** — the 4 cards of a pack must differ in pose AND palette.
5. **Watermark crop:** every output gets the bottom 64px cropped before registration (the generator adds an "AI生成" strip).
6. **Failures:** regenerate with a corrected prompt, log the reason in the manifest `qc_note` column, move on. Never ship a QC fail.
7. **Statuses are the queue.** If interrupted, resume from the first `pending` row. Never restart from zero.
8. **Roblox moderation (art spec §7b).** Bare-chested male rows: prompt includes "smooth toy plastic chest, no nipples" — any nipple depiction = instant reject + regen (same class as baked frame). Female athlete rows always wear a sports top (modesty layer); shirtless female = prohibited.

## Batch rhythm
- 4 generations per pack (parallel), then assemble the pack contact sheet (labels: card name + pack name + running depth), then QC against the rules, then update manifest statuses.
- Report per pack: pass/fix summary, one line each.

## Stop conditions
- Manifest row missing features/pose/backdrop → stop, ask for the row to be authored.
- Two consecutive QC failures of the same kind → stop, report the pattern.
- Anything that smells like a real likeness or a trademark → reject and report.
