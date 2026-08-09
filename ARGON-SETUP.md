# Argon setup — Sports Card Farm

How Studio stays in sync with this repo: **files ↔ Roblox Studio** via [Argon](https://argon.wiki). Unlike fish-a-brainrot's first sync, **this repo is the source of truth** — the published place (Sports Card Farm) started as an empty baseplate, so sync direction is always **files → Studio**.

## 1. Tooling (once per machine)

Already installed on the first machine (see `~/factory/fish-a-brainrot/ARGON-SETUP.md`):
- Argon CLI at `~/.local/bin/argon` (or the VS Code extension `Dervex.argon`, which bundles it)
- Studio plugin: `argon plugin install` (fully quit Studio after installing)
- Repo-matching settings:
  ```sh
  argon config lua_extension true        # scripts sync as .lua
  argon config changes_threshold 100000  # big first sync, don't prompt per batch
  ```

## 2. Get the repo
```sh
git clone https://github.com/yelnurk123/sports-cards-factory ~/factory/sports-cards-factory
cd ~/factory/sports-cards-factory
```

## 3. Connect Studio (every session)
1. From the repo root: `argon serve` → should say `Serving on: http://localhost:8000`
   (or VS Code: open the folder → `⌘⇧P` → `Argon: Open Menu` → **Serve** → `default.project.json`)
2. In Roblox Studio: open the **Sports Card Farm** place.
3. Plugins tab → **Argon** → widget **Settings** (gear) → **Initial Sync Priority = Server**.
   *Server = the filesystem wins. This is what makes sync go files → Studio.*
4. Host `localhost`, Port `8000` → **Connect**.
5. The empty baseplate fills with the repo's instances. From then on, file edits hot-sync into Studio.

**Direction warning:** if a confirmation dialog would create/change instances in Studio, accept (that's the correct direction). If it would change files on disk from Studio state, **Cancel** — wrong direction; check Initial Sync Priority.

## 4. Rules
- Repo is truth. If Studio state drifts, re-sync from files, don't pull Studio → files.
- Commit early and often; plain-language messages.
- No secrets in the repo.
