# Build environment — Sports Card Farm (as of 2026-08-10)
How to rebuild this setup cold. Written by the M1 build session; everything below was actually run on this Mac.

## 1. Argon sync (files ↔ Studio)

**Direction: files → Studio only. The repo is the source of truth; never sync Studio → files.**

- Argon CLI lives at `~/.local/bin/argon` (2.0.29; see `~/factory/fish-a-brainrot/ARGON-SETUP.md` for install). Studio plugin already installed (`~/Documents/Roblox/Plugins/Argon.rbxm`).
- One-time CLI config (already set on this Mac):
  ```sh
  argon config lua_extension true        # scripts sync as .lua
  argon config changes_threshold 100000  # no per-batch prompts on first sync
  ```
- Serve:
  ```sh
  cd ~/factory/sports-cards-factory && argon serve   # http://localhost:8000, serves default.project.json
  ```
- Studio side: open place **"Sports Card Farm"** → Plugins → Argon → widget Settings (gear) → **Initial Sync Priority = Server** (filesystem wins) → Host `localhost`, Port `8000` → Connect.
- **Port collision trap:** only one `argon serve` can hold :8000. A stale serve for another repo (`fish-a-brainrot`) was running once and silently served the wrong project. Check first:
  ```sh
  lsof -iTCP:8000 -sTCP:LISTEN          # get PID
  lsof -p <PID> | grep cwd              # which repo it serves
  kill <PID>                            # then start yours
  ```
- **Naming conventions (hard-won):**
  - `.server.lua` = Script, `.client.lua` = LocalScript, `.lua` = ModuleScript.
  - **Scripts with children MUST use the `init` convention**: `MainServer/init.server.lua` makes the directory the Script and its siblings the children. Argon does NOT merge adjacent `Foo.lua` + `Foo/` — it creates a Script AND a same-named Folder, and every `script.Child` require breaks. This cost a full debug cycle.
  - Directories without a same-named lua file sync as Folders.
- **Workspace is intentionally NOT mapped** in `default.project.json`: an empty mapped `src/Workspace` synced with Server priority deletes the place's live Workspace contents. The map is code-built (`WorldService`). Re-add the mapping only when real static instances exist in `src/Workspace`.
- Sanity-check the tree without Studio: `argon build -o /tmp/scf-check.rbxl` — fast structural validation of the whole project.
- **TWO-WAY SYNC HAZARD (3 hits: 2026-08-10 ×2, 2026-08-11 ×1):** while `argon serve` was up, a Studio window with the WRONG place open (an unrelated car game; later a throwaway local test build) or the RIGHT but EMPTY place (real "Sports Card Farm" before seeding) connected and Argon wrote Studio state back to files: all 132 `src/` files were deleted (×3). Git history saves you: `git checkout -- .` restores everything (re-apply uncommitted work from context FIRST if it was wiped too); foreign files are untracked. Defenses: connect the widget ONLY with "Sports Card Farm" open in the foreground window; use Initial Sync Priority = Server; **never connect Argon against an EMPTY/mismatched place — seed the place with code first** (MCP push below or a local-file build) so any connect is a no-op; stop `argon serve` when you're not actively syncing; pre-push `git status` check (foreign files = STOP).
- **One-way sync without Argon (proven 2026-08-11, wipe-proof):** `argon build -o /tmp/scf-check.rbxl` → open it in a throwaway instance (`manage_instance launch source=local_file`) → move synced roots into a staging `Folder` in Workspace → `export_rbxm` → `import_rbxm` into the REAL place under Workspace → move children into their service roots (execute_luau) → destroy staging. One-way by construction; Argon is only needed afterwards for incremental file-watch syncs, and only once the place is non-empty.
- **Place publish:** no plugin publish API exists (`game:SaveToRobloxAsync` is not a thing). After verifying via MCP playtest, the USER publishes: File → Publish to Roblox.

## 2. Playtesting in Studio via the robloxstudio-mcp

The `robloxstudio-mcp` MCP server talks to a Studio plugin (v2.23.1 at time of writing). Two Studio instances can coexist: the user's main window (place open, role `edit`) and throwaway test instances.

**Proven loop-test workflow (what the M1 session used):**
1. `argon build -o /tmp/scf-check.rbxl`
2. `manage_instance` action `launch`, `source="local_file"`, `local_place_file=/tmp/scf-check.rbxl` → returns an `anon:...` instance_id. This tests the exact files Argon would sync, without touching the user's place.
3. `solo_playtest` action `start`, `mode="play"` → roles become `edit/server/client-1`.
4. Drive it:
   - `get_runtime_logs` target `server`/`client-1` — every boot print + error. Check this FIRST, always.
   - `eval_server_runtime` — runs in the game's server Script VM (shares require cache): can `require(ServerScriptService.MainServer.DataService)` etc. and call services directly. This is how buys/opens/sells/CMDR were verified.
   - `eval_client_runtime` target `client-1` — same for the client VM (HUD labels, panels).
   - `simulate_keyboard_input` — real input pipeline; an `E` tap near a prompt triggered it end-to-end.
5. Teardown: `solo_playtest stop`, then `manage_instance close`. **`stop` flaked once** ("teardown did not complete", peers stuck) — closing the whole instance worked fine.

**Errors hit and fixes (don't re-debug these):**
- `ProximityPromptService.Triggered` does not exist → it's **`PromptTriggered(prompt, playerWhoTriggered)`** (prompt first, player second, both server and client).
- TopbarPlus (`Packages/Icon`, 1foreverhd_topbarplus@3.4.0) has **no `setTip`/`setEvent`** → use `Icon.new()`, `:setName()`, `:setLabel()`, and the GoodSignal fields `icon.selected` / `icon.deselected` (+ `icon:deselect()`, `:lock()`, `:notify()`).
- `capture_screenshot` timed out in the anon local test place ("plugin connection timeout"; needs EditableImage API enabled and a visible window). Verify UI structurally via `eval_client_runtime` instead — worked every time.
- Studio saves: ProfileStore **Mock** in Studio (`RunService:IsStudio()` branch in DataService). Loads/reconciles/releases clean; does NOT persist across separate play sessions (accepted for M1). Per-player mock override exists via boolean attributes on the DataService script.

**Local Luau syntax checks** (optional): downloaded `luau-macos.zip` from luau-lang releases to `/tmp/luau`; `luau-analyze file.lua` catches parse errors. Without Roblox type defs it floods "Unknown global game/script/Color3" — ignore those, only syntax errors matter.

## 3. This Mac: paths, .env, git quirks

- Repo roots (all in `~/factory/`):
  - `factory-ops` — the mailbox (`ops/mailbox/from-hub` tasks, `from-code` results). Clone: `https://github.com/yelnurk123/factory-ops`.
  - `sports-cards-factory` — THIS repo (canon `specs/` + game `src/`). Remote: `https://github.com/yelnurk123/sports-cards-factory`.
  - `sports-cards` — World Cup RNG Studio export (read-only reference; has its own AGENTS.md).
  - `fish-a-brainrot` — ReelBrainrots Argon-synced reference.
  - `bloom-brain-knowledge` — knowledge base (see quirks).
  - `tools/` — incl. `studio_sync.py` (used to export WCRNG; not needed for this repo).
- **`~/factory/.env`:** holds `GITHUB_TOKEN`, needed ONLY for the bloom-brain repo. Mailbox and game repos push fine with default (keychain) git credentials. Never commit tokens; never write them into mailbox files.
- **Bloom-brain is currently broken:** remote `askarbtw/bloom-brain-knowledge` returns "Repository not found" and the `.env` token is rejected. The local clone has NO `notes/agent-alignment-pack.md` (a mailbox task referenced it — flagged to hub). Treat the local clone as read-only-stale.
- **Git rhythm:** README rule — `git pull --rebase` before acting, push after. The hub pushes rulings/state commits often; **expect non-fast-forward rejections mid-task** — just rebase and push again. Keep commits small and plain-language.
- `fish-a-brainrot` once had ALL synced code deleted in its working tree (uncommitted). If its `src/` looks empty: `git -C ~/factory/fish-a-brainrot checkout -- .` restores from HEAD.
- Studio place for sync tests: the MCP `manage_instance launch source=local_file` flow above needs nothing published; the real "Sports Card Farm" place (placeId 73099792518377) belongs to the user's main Studio window.
