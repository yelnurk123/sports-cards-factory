-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

task.defer(function()
	local v1 = game:GetService("RunService")
	local v2 = require(script.Parent.VERSION)
	local v3 = v2.getAppVersion()
	local v4 = v2.getLatestVersion()
	local v5 = not v2.isUpToDate()
	if not v1:IsStudio() then
		print((("\240\159\141\141 Running TopbarPlus %* by @ForeverHD & HD Admin"):format(v3)))
	end
	if v5 then
		warn((("A new version of TopbarPlus (%*) is available: https://devforum.roblox.com/t/topbarplus/1017485"):format(v4)))
	end
end)
return {}