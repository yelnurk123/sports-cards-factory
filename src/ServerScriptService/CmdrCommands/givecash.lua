-- givecash (CMDR command definition)
-- Admin-only (Group "Testing"): add cash to a player. Impl: givecashServer.

return {
	Name = "givecash",
	Aliases = { "addcash" },
	Description = "Give a player cash.",
	Group = "Testing",
	Args = {
		{ Type = "player", Name = "player", Description = "Who to give cash to." },
		{ Type = "number", Name = "amount", Description = "Amount of cash to add." },
	},
}
