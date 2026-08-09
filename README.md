# Sports Card Farm — game source (Argon-synced)

Roblox game code as plain files. **This repo is the source of truth** — Studio syncs FROM files via Argon, never the reverse.

Canon (specs, roster, economy, art spec) lives in `specs/` — those files win every conflict for content and numbers.

## Layout
- `src/ReplicatedStorage/Shared` — modules both sides use (config, formulas, data)
- `src/ServerScriptService/Server` — server logic (services, economy, saves)
- `src/StarterPlayer/StarterPlayerScripts/Client` — client logic (controllers, UI, input)
- `src/StarterGui/UI` — interface assets
- `src/Workspace` — static map pieces (M1 builds its blockout map in code)

## Day-to-day
- Edit files → Argon pushes them into Studio → commit + push like any project.
- Never edit in Studio and sync back; make changes here.
- Conventions: `.lua` extension (Argon `lua_extension true`), `.server.lua` = Script, `.client.lua` = LocalScript, plain `.lua` = ModuleScript.

See `ARGON-SETUP.md` for tooling.
