local VERSION = {}

VERSION.appVersion = "v3.4.0"
VERSION.latestVersion = nil

function VERSION.getLatestVersion()
	local latestVersion = VERSION.latestVersion
	if latestVersion then
		return latestVersion
	end

	local placeName = ""
	while true do
		local success, productInfo = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(117501901079852)
		end)
		if success and productInfo then
			placeName = productInfo.Name
			break
		end
		task.wait(1)
	end

	latestVersion = string.match(placeName, "^TopbarPlus (.*)$")
	if latestVersion then
		latestVersion = latestVersion:gsub("%s+", "")
	end

	VERSION.latestVersion = latestVersion
	return latestVersion
end

function VERSION.getAppVersion()
	return VERSION.appVersion
end

function VERSION.isUpToDate()
	local latestVersion = VERSION.getLatestVersion()
	local appVersion = VERSION.getAppVersion()
	return latestVersion ~= nil and latestVersion == appVersion
end

return VERSION
