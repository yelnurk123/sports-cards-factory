-- givepack (CMDR command definition)
-- Admin-only (Group "Testing"): place a pack directly on a player's plot,
-- bypassing cash. Impl: givepackServer.

return {
	Name = "givepack",
	Aliases = { "pack" },
	Description = "Give a player a pack (street | sandlot | clubhouse), placed on their plot.",
	Group = "Testing",
	Args = {
		{ Type = "player", Name = "player", Description = "Who to give the pack to." },
		{ Type = "string", Name = "packId", Description = "Pack id: street, sandlot, or clubhouse." },
	},
}
