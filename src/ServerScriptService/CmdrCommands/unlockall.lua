-- unlockall (CMDR command definition)
-- Admin-only (Group "Testing"): grant one of every M1 card + a cash cushion so
-- playtests skip the grind. Impl: unlockallServer.

return {
	Name = "unlockall",
	Aliases = { "grantall" },
	Description = "Grant a player one of every M1 card plus $10,000 test cash.",
	Group = "Testing",
	Args = {
		{ Type = "player", Name = "player", Description = "Who to unlock everything for." },
	},
}
