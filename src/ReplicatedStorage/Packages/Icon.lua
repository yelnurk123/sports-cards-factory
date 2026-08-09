-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = game:GetService("UserInputService")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("StarterGui")
local v4 = game:GetService("Players")
require(script.Types)
local v_u_5 = script
local v6 = require(v_u_5.Reference)
local v7 = v6.getObject()
local v8
if v7 then
	v8 = v7.Value
else
	v8 = v7
end
if v8 and v8 ~= v_u_5 then
	return require(v8)
end
if not v7 then
	v6.addToReplicatedStorage()
end
local v_u_9 = require(v_u_5.Packages.GoodSignal)
local v_u_10 = require(v_u_5.Packages.Janitor)
local v_u_11 = require(v_u_5.Utility)
local v_u_12 = require(v_u_5.Features.Themes)
local v13 = require(v_u_5.Features.Gamepad)
local v14 = require(v_u_5.Features.Overflow)
local v_u_15 = {}
v_u_15.__index = v_u_15
local v_u_16 = v4.LocalPlayer
local v17 = v_u_5.Features.Themes
local v_u_18 = {}
local v_u_19 = v_u_9.new()
local v_u_20 = v_u_5.Elements
local v_u_21 = 0
local v_u_22 = {
	["mobile"] = Enum.PreferredInput.Touch,
	["desktop"] = Enum.PreferredInput.KeyboardAndMouse,
	["console"] = Enum.PreferredInput.Gamepad
}
v_u_15.baseDisplayOrderChanged = v_u_9.new()
v_u_15.baseDisplayOrder = 10
v_u_15.baseTheme = require(v17.Default)
v_u_15.isOldTopbar = false
v_u_15.iconsDictionary = v_u_18
v_u_15.insetHeightChanged = v_u_9.new()
v_u_15.container = require(v_u_20.Container)(v_u_15)
v_u_15.topbarEnabled = true
v_u_15.iconAdded = v_u_9.new()
v_u_15.iconRemoved = v_u_9.new()
v_u_15.iconChanged = v_u_9.new()
function v_u_15.getIcons()
	-- upvalues: (copy) v_u_15
	return v_u_15.iconsDictionary
end
function v_u_15.getIconByUID(p23)
	-- upvalues: (copy) v_u_15
	return v_u_15.iconsDictionary[p23] or nil
end
function v_u_15.getIcon(p24)
	-- upvalues: (copy) v_u_15, (copy) v_u_18
	local v25 = v_u_15.getIconByUID(p24)
	if v25 then
		return v25
	end
	for _, v26 in pairs(v_u_18) do
		if v26.name == p24 then
			return v26
		end
	end
	return nil
end
function v_u_15.setTopbarEnabled(p27, p28)
	-- upvalues: (copy) v_u_15
	if typeof(p27) ~= "boolean" then
		p27 = v_u_15.topbarEnabled
	end
	if not p28 then
		v_u_15.topbarEnabled = p27
	end
	for _, v29 in pairs(v_u_15.container) do
		v29.Enabled = p27
	end
end
function v_u_15.modifyBaseTheme(p30)
	-- upvalues: (copy) v_u_12, (copy) v_u_15, (copy) v_u_18
	local v31 = v_u_12.getModifications(p30)
	for _, v32 in pairs(v31) do
		for _, v33 in pairs(v_u_15.baseTheme) do
			v_u_12.merge(v33, v32)
		end
	end
	for _, v34 in pairs(v_u_18) do
		v34:setTheme(v_u_15.baseTheme)
	end
end
function v_u_15.setDisplayOrder(p35)
	-- upvalues: (copy) v_u_15
	v_u_15.baseDisplayOrder = p35
	v_u_15.baseDisplayOrderChanged:Fire(p35)
end
task.defer(v13.start, v_u_15)
task.defer(v14.start, v_u_15)
task.defer(function()
	-- upvalues: (copy) v_u_16, (copy) v_u_15, (copy) v_u_5
	local v36 = v_u_16:WaitForChild("PlayerGui")
	for _, v37 in pairs(v_u_15.container) do
		v37.Parent = v36
	end
	require(v_u_5.Attribute)
end)
function v_u_15.new()
	-- upvalues: (copy) v_u_15, (copy) v_u_10, (copy) v_u_11, (copy) v_u_18, (copy) v_u_9, (copy) v_u_5, (copy) v_u_20, (ref) v_u_21, (copy) v_u_1, (copy) v_u_22, (copy) v_u_19, (copy) v_u_3
	local v_u_38 = {}
	local v39 = v_u_15
	setmetatable(v_u_38, v39)
	local v40 = v_u_10.new()
	v_u_38.janitor = v40
	v_u_38.themesJanitor = v40:add(v_u_10.new())
	v_u_38.singleClickJanitor = v40:add(v_u_10.new())
	v_u_38.captionJanitor = v40:add(v_u_10.new())
	v_u_38.joinJanitor = v40:add(v_u_10.new())
	v_u_38.menuJanitor = v40:add(v_u_10.new())
	v_u_38.dropdownJanitor = v40:add(v_u_10.new())
	local v_u_41 = v_u_11.generateUID()
	v_u_18[v_u_41] = v_u_38
	v40:add(function()
		-- upvalues: (ref) v_u_18, (copy) v_u_41
		v_u_18[v_u_41] = nil
	end)
	v_u_38.selected = v40:add(v_u_9.new())
	v_u_38.deselected = v40:add(v_u_9.new())
	v_u_38.toggled = v40:add(v_u_9.new())
	v_u_38.viewingStarted = v40:add(v_u_9.new())
	v_u_38.viewingEnded = v40:add(v_u_9.new())
	v_u_38.stateChanged = v40:add(v_u_9.new())
	v_u_38.notified = v40:add(v_u_9.new())
	v_u_38.noticeStarted = v40:add(v_u_9.new())
	v_u_38.noticeChanged = v40:add(v_u_9.new())
	v_u_38.endNotices = v40:add(v_u_9.new())
	v_u_38.toggleKeyAdded = v40:add(v_u_9.new())
	v_u_38.fakeToggleKeyChanged = v40:add(v_u_9.new())
	v_u_38.alignmentChanged = v40:add(v_u_9.new())
	v_u_38.updateSize = v40:add(v_u_9.new())
	v_u_38.resizingComplete = v40:add(v_u_9.new())
	v_u_38.joinedParent = v40:add(v_u_9.new())
	v_u_38.menuSet = v40:add(v_u_9.new())
	v_u_38.dropdownSet = v40:add(v_u_9.new())
	v_u_38.updateMenu = v40:add(v_u_9.new())
	v_u_38.startMenuUpdate = v40:add(v_u_9.new())
	v_u_38.childThemeModified = v40:add(v_u_9.new())
	v_u_38.indicatorSet = v40:add(v_u_9.new())
	v_u_38.dropdownChildAdded = v40:add(v_u_9.new())
	v_u_38.menuChildAdded = v40:add(v_u_9.new())
	v_u_38.iconModule = v_u_5
	v_u_38.UID = v_u_41
	v_u_38.isEnabled = true
	v_u_38.enabled = v_u_38.isEnabled
	v_u_38.isSelected = false
	v_u_38.isViewing = false
	v_u_38.joinedFrame = false
	v_u_38.parentIconUID = false
	v_u_38.deselectWhenOtherIconSelected = true
	v_u_38.totalNotices = 0
	v_u_38.activeState = "Deselected"
	v_u_38.alignment = ""
	v_u_38.originalAlignment = ""
	v_u_38.appliedTheme = {}
	v_u_38.appearance = {}
	v_u_38.cachedInstances = {}
	v_u_38.cachedNamesToInstances = {}
	v_u_38.cachedCollectives = {}
	v_u_38.bindedToggleKeys = {}
	v_u_38.customBehaviours = {}
	v_u_38.toggleItems = {}
	v_u_38.bindedEvents = {}
	v_u_38.notices = {}
	v_u_38.menuIcons = {}
	v_u_38.dropdownIcons = {}
	v_u_38.childIconsDict = {}
	v_u_38.creationTime = os.clock()
	v_u_38.widget = v40:add(require(v_u_20.Widget)(v_u_38, v_u_15))
	v_u_38:setAlignment()
	v_u_21 = v_u_21 + 1
	local v42 = v_u_21 * 0.01 + 1
	v_u_38:setOrder(v42, "deselected")
	v_u_38:setOrder(v42, "selected")
	v_u_38:setTheme(v_u_15.baseTheme)
	local v43 = v_u_38:getInstance("ClickRegion")
	local v_u_44 = false
	local v_u_45 = 0
	v43.MouseButton1Click:Connect(function()
		-- upvalues: (ref) v_u_44, (copy) v_u_38, (ref) v_u_45
		v_u_44 = true
		if v_u_38.locked then
			return
		else
			local v46 = tick()
			if v46 - v_u_45 < 0.1 then
				return
			else
				v_u_45 = v46
				if v_u_38.isSelected then
					v_u_38:deselect("User", v_u_38)
				else
					v_u_38:select("User", v_u_38)
				end
			end
		end
	end)
	v43.TouchTap:Connect(function()
		-- upvalues: (ref) v_u_44, (copy) v_u_38, (ref) v_u_45
		if not v_u_44 then
			if v_u_38.locked then
				return
			end
			local v47 = tick()
			if v47 - v_u_45 < 0.1 then
				return
			end
			v_u_45 = v47
			if v_u_38.isSelected then
				v_u_38:deselect("User", v_u_38)
				return
			end
			v_u_38:select("User", v_u_38)
		end
	end)
	v40:add(v_u_1.InputBegan:Connect(function(p48, p49)
		-- upvalues: (copy) v_u_38, (ref) v_u_45
		if not v_u_38.locked then
			if v_u_38.bindedToggleKeys[p48.KeyCode] and not p49 then
				if v_u_38.locked then
					return
				end
				local v50 = tick()
				if v50 - v_u_45 < 0.1 then
					return
				end
				v_u_45 = v50
				if v_u_38.isSelected then
					v_u_38:deselect("User", v_u_38)
					return
				end
				v_u_38:select("User", v_u_38)
			end
		end
	end))
	local function v51()
		-- upvalues: (copy) v_u_38
		if not v_u_38.locked then
			v_u_38.isViewing = false
			v_u_38.viewingEnded:Fire(true)
			v_u_38:setState(nil, "User", v_u_38)
		end
	end
	v_u_38.joinedParent:Connect(function()
		-- upvalues: (copy) v_u_38
		if v_u_38.isViewing then
			if v_u_38.locked then
				return
			end
			v_u_38.isViewing = false
			v_u_38.viewingEnded:Fire(true)
			v_u_38:setState(nil, "User", v_u_38)
		end
	end)
	v43.MouseEnter:Connect(function()
		-- upvalues: (ref) v_u_1, (ref) v_u_22, (copy) v_u_38
		local v52 = v_u_1.PreferredInput ~= v_u_22.desktop
		if not v_u_38.locked then
			v_u_38.isViewing = true
			v_u_38.viewingStarted:Fire(true)
			if not v52 then
				v_u_38:setState("Viewing", "User", v_u_38)
			end
		end
	end)
	local v_u_53 = 0
	v40:add(v_u_1.TouchEnded:Connect(v51))
	v43.MouseLeave:Connect(v51)
	v43.SelectionGained:Connect(function(p54)
		-- upvalues: (copy) v_u_38
		if not v_u_38.locked then
			v_u_38.isViewing = true
			v_u_38.viewingStarted:Fire(true)
			if not p54 then
				v_u_38:setState("Viewing", "User", v_u_38)
			end
		end
	end)
	v43.SelectionLost:Connect(v51)
	v43.MouseButton1Down:Connect(function()
		-- upvalues: (copy) v_u_38, (ref) v_u_1, (ref) v_u_22, (ref) v_u_53
		if not v_u_38.locked and v_u_1.PreferredInput == v_u_22.mobile then
			v_u_53 = v_u_53 + 1
			local v_u_55 = v_u_53
			task.delay(0.2, function()
				-- upvalues: (copy) v_u_55, (ref) v_u_53, (ref) v_u_38
				if v_u_55 == v_u_53 then
					if v_u_38.locked then
						return
					end
					v_u_38.isViewing = true
					v_u_38.viewingStarted:Fire(true)
					v_u_38:setState("Viewing", "User", v_u_38)
				end
			end)
		end
	end)
	v43.MouseButton1Up:Connect(function()
		-- upvalues: (ref) v_u_53
		v_u_53 = v_u_53 + 1
	end)
	local v_u_56 = v_u_38:getInstance("IconOverlay")
	v_u_38.viewingStarted:Connect(function()
		-- upvalues: (copy) v_u_56, (copy) v_u_38
		v_u_56.Visible = not v_u_38.overlayDisabled
	end)
	v_u_38.viewingEnded:Connect(function()
		-- upvalues: (copy) v_u_56
		v_u_56.Visible = false
	end)
	v40:add(v_u_19:Connect(function(p57)
		-- upvalues: (copy) v_u_38
		if p57 ~= v_u_38 and (v_u_38.deselectWhenOtherIconSelected and p57.deselectWhenOtherIconSelected) then
			v_u_38:deselect("AutoDeselect", p57)
		end
	end))
	local v58 = debug.info(2, "s")
	local v59 = string.split(v58, ".")
	local v60 = game
	local v61 = nil
	for _, v62 in pairs(v59) do
		v60 = v60:FindFirstChild(v62)
		if not v60 then
			break
		end
		if v60:IsA("ScreenGui") then
			v61 = v60
		end
	end
	if v60 and (v61 and v61.ResetOnSpawn == true) then
		v_u_38.originsScreenGui = v61
		v_u_11.localPlayerRespawned(function()
			-- upvalues: (copy) v_u_38
			v_u_38:destroy()
		end)
	end
	v_u_38.toggled:Connect(function(p63)
		-- upvalues: (copy) v_u_38, (ref) v_u_15
		v_u_38.noticeChanged:Fire(v_u_38.totalNotices)
		for v64, _ in pairs(v_u_38.childIconsDict) do
			local v65 = v_u_15.getIconByUID(v64)
			v65.noticeChanged:Fire(v65.totalNotices)
			if not p63 and v65.isSelected then
				for _, _ in pairs(v65.childIconsDict) do
					v65:deselect("HideParentFeature", v_u_38)
				end
			end
		end
	end)
	v_u_38.selected:Connect(function()
		-- upvalues: (copy) v_u_38, (ref) v_u_3
		if #v_u_38.dropdownIcons > 0 then
			if v_u_3:GetCore("ChatActive") and v_u_38.alignment ~= "Right" then
				v_u_38.chatWasPreviouslyActive = true
				v_u_3:SetCore("ChatActive", false)
			end
			if v_u_3:GetCoreGuiEnabled("PlayerList") and v_u_38.alignment ~= "Left" then
				v_u_38.playerlistWasPreviouslyActive = true
				v_u_3:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			end
		end
	end)
	v_u_38.deselected:Connect(function()
		-- upvalues: (copy) v_u_38, (ref) v_u_3
		if v_u_38.chatWasPreviouslyActive then
			v_u_38.chatWasPreviouslyActive = nil
			v_u_3:SetCore("ChatActive", true)
		end
		if v_u_38.playerlistWasPreviouslyActive then
			v_u_38.playerlistWasPreviouslyActive = nil
			v_u_3:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end
	end)
	task.delay(0.1, function()
		-- upvalues: (copy) v_u_38
		if v_u_38.activeState == "Deselected" then
			v_u_38.stateChanged:Fire("Deselected")
			v_u_38:refresh()
		end
	end)
	v_u_15.iconAdded:Fire(v_u_38)
	return v_u_38
end
function v_u_15.setName(p66, p67)
	p66.widget.Name = p67
	p66.name = p67
	return p66
end
function v_u_15.setState(p68, p69, p70, p71)
	-- upvalues: (copy) v_u_11, (copy) v_u_19
	local v72 = p69 or (p68.isSelected and "Selected" or "Deselected")
	local v73 = v_u_11.formatStateName(v72)
	if p68.activeState ~= v73 then
		local v74 = p68.isSelected
		p68.activeState = v73
		if v73 == "Deselected" then
			p68.isSelected = false
			if v74 then
				p68.toggled:Fire(false, p70, p71)
				p68.deselected:Fire(p70, p71)
			end
			p68:_setToggleItemsVisible(false, p70, p71)
		elseif v73 == "Selected" then
			p68.isSelected = true
			if not v74 then
				p68.toggled:Fire(true, p70, p71)
				p68.selected:Fire(p70, p71)
				v_u_19:Fire(p68, p70, p71)
			end
			p68:_setToggleItemsVisible(true, p70, p71)
		end
		p68.stateChanged:Fire(v73, p70, p71)
	end
end
function v_u_15.getInstance(p_u_75, p_u_76)
	-- upvalues: (copy) v_u_12
	local v77 = p_u_75.cachedNamesToInstances[p_u_76]
	if v77 then
		return v77
	end
	local function v_u_81(p_u_78, p_u_79)
		-- upvalues: (copy) p_u_75
		if not p_u_75.cachedInstances[p_u_79] then
			local v80 = p_u_79:GetAttribute("Collective")
			if v80 then
				v80 = p_u_75.cachedCollectives[v80]
			end
			if v80 then
				table.insert(v80, p_u_79)
			end
			p_u_75.cachedNamesToInstances[p_u_78] = p_u_79
			p_u_75.cachedInstances[p_u_79] = true
			p_u_79.Destroying:Once(function()
				-- upvalues: (ref) p_u_75, (copy) p_u_78, (copy) p_u_79
				p_u_75.cachedNamesToInstances[p_u_78] = nil
				p_u_75.cachedInstances[p_u_79] = nil
			end)
		end
	end
	local v82 = p_u_75.widget
	v_u_81("Widget", v82)
	if p_u_76 == "Widget" then
		return v82
	end
	local v_u_83 = nil
	local function v_u_89(p84)
		-- upvalues: (copy) p_u_75, (ref) v_u_12, (copy) v_u_89, (copy) v_u_81, (copy) p_u_76, (ref) v_u_83
		for _, v85 in pairs(p84:GetChildren()) do
			local v86 = v85:GetAttribute("WidgetUID")
			if not v86 or v86 == p_u_75.UID then
				local v87 = v_u_12.getRealInstance(v85) or v85
				v_u_89(v87)
				if v87:IsA("GuiBase") or (v87:IsA("UIBase") or v87:IsA("ValueBase")) then
					local v88 = v87.Name
					v_u_81(v88, v87)
					if v88 == p_u_76 then
						v_u_83 = v87
					end
				end
			end
		end
	end
	v_u_89(v82)
	return v_u_83
end
function v_u_15.getCollective(p90, p91)
	local v92 = p90.cachedCollectives[p91]
	if v92 then
		return v92
	end
	local v93 = {}
	for v94, _ in pairs(p90.cachedInstances) do
		if v94:GetAttribute("Collective") == p91 then
			table.insert(v93, v94)
		end
	end
	p90.cachedCollectives[p91] = v93
	return v93
end
function v_u_15.getInstanceOrCollective(p95, p96)
	local v97 = {}
	local v98 = p95:getInstance(p96)
	if v98 then
		table.insert(v97, v98)
	end
	if #v97 == 0 then
		v97 = p95:getCollective(p96)
	end
	return v97
end
function v_u_15.getStateGroup(p99, p100)
	local v101 = p100 or p99.activeState
	local v102 = p99.appearance[v101]
	if not v102 then
		v102 = {}
		p99.appearance[v101] = v102
	end
	return v102
end
function v_u_15.refreshAppearance(p103, p104, p105)
	-- upvalues: (copy) v_u_12
	v_u_12.refresh(p103, p104, p105)
	return p103
end
function v_u_15.refresh(p106)
	p106:refreshAppearance(p106.widget)
	p106.updateSize:Fire()
	return p106
end
function v_u_15.updateParent(p107)
	-- upvalues: (copy) v_u_15
	local v108 = v_u_15.getIconByUID(p107.parentIconUID)
	if v108 then
		v108.updateSize:Fire()
	end
end
function v_u_15.setBehaviour(p109, p110, p111, p112, p113)
	local v114 = p110 .. "-" .. p111
	p109.customBehaviours[v114] = p112
	if p113 then
		local v115 = p109:getInstanceOrCollective(p110)
		for _, v116 in pairs(v115) do
			p109:refreshAppearance(v116, p111)
		end
	end
end
function v_u_15.modifyTheme(p117, p118, p119)
	-- upvalues: (copy) v_u_12
	return p117, v_u_12.modify(p117, p118, p119)
end
function v_u_15.modifyChildTheme(p120, p121, p122)
	-- upvalues: (copy) v_u_15
	p120.childModifications = p121
	p120.childModificationsUID = p122
	for v123, _ in pairs(p120.childIconsDict) do
		v_u_15.getIconByUID(v123):modifyTheme(p121, p122)
	end
	p120.childThemeModified:Fire()
	return p120
end
function v_u_15.removeModification(p124, p125)
	-- upvalues: (copy) v_u_12
	v_u_12.remove(p124, p125)
	return p124
end
function v_u_15.removeModificationWith(p126, p127, p128, p129)
	-- upvalues: (copy) v_u_12
	v_u_12.removeWith(p126, p127, p128, p129)
	return p126
end
function v_u_15.setTheme(p130, p131)
	-- upvalues: (copy) v_u_12
	v_u_12.set(p130, p131)
	return p130
end
function v_u_15.setEnabled(p132, p133)
	p132.isEnabled = p133
	p132.enabled = p132.isEnabled
	p132.widget.Visible = p133
	p132:updateParent()
	return p132
end
function v_u_15.select(p134, p135, p136)
	p134:setState("Selected", p135, p136)
	return p134
end
function v_u_15.deselect(p137, p138, p139)
	p137:setState("Deselected", p138, p139)
	return p137
end
function v_u_15.notify(p140, p141, p142)
	-- upvalues: (copy) v_u_20, (copy) v_u_15
	if not p140.notice then
		p140.notice = require(v_u_20.Notice)(p140, v_u_15)
	end
	p140.noticeStarted:Fire(p141, p142)
	return p140
end
function v_u_15.clearNotices(p143)
	p143.endNotices:Fire()
	return p143
end
function v_u_15.disableOverlay(p144, p145)
	p144.overlayDisabled = p145
	return p144
end
v_u_15.disableStateOverlay = v_u_15.disableOverlay
function v_u_15.setImage(p146, p_u_147, p148)
	-- upvalues: (copy) v_u_2
	p146:modifyTheme({
		"IconImage",
		"Image",
		p_u_147,
		p148
	})
	task.spawn(function()
		-- upvalues: (copy) p_u_147, (ref) v_u_2
		local v149 = p_u_147
		local v150
		if tonumber(v149) then
			v150 = ("rbxassetid://%*"):format(p_u_147)
		else
			v150 = p_u_147
		end
		if v_u_2:GetAssetFetchStatus(v150) ~= Enum.AssetFetchStatus.Success then
			pcall(v_u_2.PreloadAsync, v_u_2, { v150 })
		end
	end)
	return p146
end
function v_u_15.setLabel(p151, p152, p153)
	p151:modifyTheme({
		"IconLabel",
		"Text",
		p152,
		p153
	})
	return p151
end
function v_u_15.setOrder(p154, p155, p156)
	local v157 = p155 * 100
	p154:modifyTheme({
		"IconSpot",
		"LayoutOrder",
		v157,
		p156
	})
	p154:modifyTheme({
		"Widget",
		"LayoutOrder",
		v157,
		p156
	})
	return p154
end
function v_u_15.setCornerRadius(p158, p159, p160)
	p158:modifyTheme({
		"IconCorners",
		"CornerRadius",
		p159,
		p160
	})
	return p158
end
function v_u_15.align(p161, p162, p163)
	-- upvalues: (copy) v_u_15
	local v164 = tostring(p162):lower()
	local v165 = (v164 == "mid" or v164 == "centre") and "center" or v164
	local v166 = v165 ~= "left" and (v165 ~= "center" and v165 ~= "right") and "left" or v165
	local v167 = v166 == "center" and v_u_15.container.TopbarCentered or v_u_15.container.TopbarStandard
	local v168 = v167.Holders
	local v169 = string.upper((string.sub(v166, 1, 1))) .. string.sub(v166, 2)
	if not p163 then
		p161.originalAlignment = v169
	end
	local v170 = p161.joinedFrame
	local v171 = v168[v169]
	p161.screenGui = v167
	p161.alignmentHolder = v171
	if not p161.isDestroyed then
		p161.widget.Parent = v170 or v171
	end
	p161.alignment = v169
	p161.alignmentChanged:Fire(v169)
	v_u_15.iconChanged:Fire(p161)
	return p161
end
v_u_15.setAlignment = v_u_15.align
function v_u_15.setLeft(p172)
	p172:setAlignment("Left")
	return p172
end
function v_u_15.setMid(p173)
	p173:setAlignment("Center")
	return p173
end
function v_u_15.setRight(p174)
	p174:setAlignment("Right")
	return p174
end
function v_u_15.setWidth(p175, p176, p177)
	p175:modifyTheme({
		"Widget",
		"DesiredWidth",
		p176,
		p177
	})
	return p175
end
function v_u_15.setImageScale(p178, p179, p180)
	p178:modifyTheme({
		"IconImageScale",
		"Value",
		p179,
		p180
	})
	return p178
end
function v_u_15.setImageRatio(p181, p182, p183)
	p181:modifyTheme({
		"IconImageRatio",
		"AspectRatio",
		p182,
		p183
	})
	return p181
end
function v_u_15.setTextSize(p184, p185, p186)
	p184:modifyTheme({
		"IconLabel",
		"TextSize",
		p185,
		p186
	})
	return p184
end
function v_u_15.setTextFont(p187, p188, p189, p190, p191)
	local v192 = p189 or Enum.FontWeight.Regular
	local v193 = p190 or Enum.FontStyle.Normal
	local v194 = nil
	local v195 = typeof(p188)
	if v195 == "number" then
		v194 = Font.fromId(p188, v192, v193)
	elseif v195 == "EnumItem" then
		v194 = Font.fromEnum(p188)
	elseif v195 == "string" and not p188:match("rbxasset") then
		v194 = Font.fromName(p188, v192, v193)
	end
	p187:modifyTheme({
		"IconLabel",
		"FontFace",
		v194 or Font.new(p188, v192, v193),
		p191
	})
	return p187
end
function v_u_15.setTextColor(p196, p197, p198)
	if p197 == nil or (p197 == "" or (type(p197) ~= "userdata" or typeof(p197) ~= "Color3")) then
		if p197 ~= nil and p197 ~= "" then
			warn("setTextColor item must be a Color3 value! Changed the color to white.")
		end
		p197 = Color3.fromRGB(255, 255, 255)
	end
	p196:modifyTheme({
		"IconLabel",
		"TextColor3",
		p197,
		p198
	})
	return p196
end
function v_u_15.bindToggleItem(p199, p200)
	if not (p200:IsA("GuiObject") or p200:IsA("LayerCollector")) then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	p199.toggleItems[p200] = true
	p199:_updateSelectionInstances()
	return p199
end
function v_u_15.unbindToggleItem(p201, p202)
	p201.toggleItems[p202] = nil
	p201:_updateSelectionInstances()
	return p201
end
function v_u_15._updateSelectionInstances(p203)
	for v204, _ in pairs(p203.toggleItems) do
		local v205 = {}
		for _, v206 in pairs(v204:GetDescendants()) do
			if (v206:IsA("TextButton") or v206:IsA("ImageButton")) and v206.Active then
				table.insert(v205, v206)
			end
		end
		p203.toggleItems[v204] = v205
	end
end
function v_u_15._setToggleItemsVisible(p207, p208, _, p209)
	for v210, _ in pairs(p207.toggleItems) do
		if not p209 or (p209 == p207 or p209.toggleItems[v210] == nil) then
			v210[v210:IsA("LayerCollector") and "Enabled" or "Visible"] = p208
		end
	end
end
function v_u_15.bindEvent(p_u_211, p212, p_u_213)
	local v214 = p_u_211[p212]
	local v215
	if v214 then
		if typeof(v214) == "table" then
			v215 = v214.Connect
		else
			v215 = false
		end
	else
		v215 = v214
	end
	assert(v215, "argument[1] must be a valid topbarplus icon event name!")
	local v216 = typeof(p_u_213) == "function"
	assert(v216, "argument[2] must be a function!")
	p_u_211.bindedEvents[p212] = v214:Connect(function(...)
		-- upvalues: (copy) p_u_213, (copy) p_u_211
		p_u_213(p_u_211, ...)
	end)
	return p_u_211
end
function v_u_15.unbindEvent(p217, p218)
	local v219 = p217.bindedEvents[p218]
	if v219 then
		v219:Disconnect()
		p217.bindedEvents[p218] = nil
	end
	return p217
end
function v_u_15.bindToggleKey(p220, p221)
	local v222 = typeof(p221) == "EnumItem"
	assert(v222, "argument[1] must be a KeyCode EnumItem!")
	p220.bindedToggleKeys[p221] = true
	p220.toggleKeyAdded:Fire(p221)
	p220:setCaption("_hotkey_")
	return p220
end
function v_u_15.unbindToggleKey(p223, p224)
	local v225 = typeof(p224) == "EnumItem"
	assert(v225, "argument[1] must be a KeyCode EnumItem!")
	p223.bindedToggleKeys[p224] = nil
	return p223
end
function v_u_15.call(p_u_226, p_u_227, ...)
	local v_u_228 = table.pack(...)
	task.spawn(function()
		-- upvalues: (copy) p_u_227, (copy) p_u_226, (copy) v_u_228
		local v229 = v_u_228
		p_u_227(p_u_226, table.unpack(v229))
	end)
	return p_u_226
end
function v_u_15.addToJanitor(p230, p231, p232, p233)
	p230.janitor:add(p231, p232, p233)
	return p230
end
function v_u_15.lock(p234)
	p234:getInstance("ClickRegion").Visible = false
	p234.locked = true
	return p234
end
function v_u_15.unlock(p235)
	p235:getInstance("ClickRegion").Visible = true
	p235.locked = false
	return p235
end
function v_u_15.debounce(p236, p237)
	p236:lock()
	task.wait(p237)
	p236:unlock()
	return p236
end
function v_u_15.autoDeselect(p238, p239)
	p238.deselectWhenOtherIconSelected = p239 == nil and true or p239
	return p238
end
function v_u_15.oneClick(p_u_240, p241)
	local v242 = p_u_240.singleClickJanitor
	v242:clean()
	if p241 or p241 == nil then
		v242:add(p_u_240.selected:Connect(function()
			-- upvalues: (copy) p_u_240
			p_u_240:deselect("OneClick", p_u_240)
		end))
	end
	p_u_240.oneClickEnabled = true
	return p_u_240
end
function v_u_15.setCaption(p243, p244)
	-- upvalues: (copy) v_u_20
	if p244 == "_hotkey_" and p243.captionText then
		return p243
	end
	local v245 = p243.captionJanitor
	p243.captionJanitor:clean()
	if not p244 or p244 == "" then
		p243.caption = nil
		p243.captionText = nil
		return p243
	end
	local v246 = v245:add(require(v_u_20.Caption)(p243))
	v246:SetAttribute("CaptionText", p244)
	p243.caption = v246
	p243.captionText = p244
	return p243
end
function v_u_15.setCaptionHint(p247, p248)
	local v249 = typeof(p248) == "EnumItem"
	assert(v249, "argument[1] must be a KeyCode EnumItem!")
	p247.fakeToggleKey = p248
	p247.fakeToggleKeyChanged:Fire(p248)
	p247:setCaption("_hotkey_")
	return p247
end
function v_u_15.leave(p250)
	p250.joinJanitor:clean()
	return p250
end
function v_u_15.joinMenu(p251, p252)
	-- upvalues: (copy) v_u_11
	v_u_11.joinFeature(p251, p252, p252.menuIcons, p252:getInstance("Menu"))
	p252.menuChildAdded:Fire(p251)
	return p251
end
function v_u_15.setMenu(p253, p254)
	p253.menuSet:Fire(p254)
	return p253
end
function v_u_15.setFixedMenu(p255, p256)
	p255:freezeMenu(p256)
	p255:setMenu(p256)
end
v_u_15.setFrozenMenu = v_u_15.setFixedMenu
function v_u_15.freezeMenu(p_u_257)
	p_u_257:select("FrozenMenu", p_u_257)
	p_u_257:bindEvent("deselected", function(p258)
		-- upvalues: (copy) p_u_257
		p258:select("FrozenMenu", p_u_257)
	end)
	p_u_257:modifyTheme({ "IconSpot", "Visible", false })
end
function v_u_15.joinDropdown(p259, p260)
	-- upvalues: (copy) v_u_11
	p260:getDropdown()
	v_u_11.joinFeature(p259, p260, p260.dropdownIcons, p260:getInstance("DropdownScroller"))
	p260.dropdownChildAdded:Fire(p259)
	return p259
end
function v_u_15.getDropdown(p261)
	-- upvalues: (copy) v_u_20
	local v262 = p261.dropdown
	if not v262 then
		v262 = require(v_u_20.Dropdown)(p261)
		p261.dropdown = v262
		p261:clipOutside(v262)
	end
	return v262
end
function v_u_15.setDropdown(p263, p264)
	p263:getDropdown()
	p263.dropdownSet:Fire(p264)
	return p263
end
function v_u_15.clipOutside(p265, p266)
	-- upvalues: (copy) v_u_11
	local v267 = v_u_11.clipOutside(p265, p266)
	p265:refreshAppearance(p266)
	return p265, v267
end
function v_u_15.setIndicator(p268, p269)
	-- upvalues: (copy) v_u_20, (copy) v_u_15
	if not p268.indicator then
		p268.indicator = p268.janitor:add(require(v_u_20.Indicator)(p268, v_u_15))
	end
	p268.indicatorSet:Fire(p269)
end
function v_u_15.convertLabelToNumberSpinner(p_u_270, p_u_271, p_u_272)
	task.defer(function()
		-- upvalues: (copy) p_u_270, (copy) p_u_271, (copy) p_u_272
		local v_u_273 = p_u_270:getInstance("IconLabel")
		v_u_273.Transparency = 1
		p_u_271.Parent = v_u_273.Parent
		p_u_271.Size = UDim2.fromScale(1, 1)
		p_u_271.AnchorPoint = Vector2.new(0.5, 0.5)
		p_u_271.Position = UDim2.new(0.5, 0, 0.5, 0)
		p_u_271.TextXAlignment = Enum.TextXAlignment.Center
		p_u_271.ClipsDescendants = false
		for _, v_u_274 in ipairs({
			"FontFace",
			"BorderSizePixel",
			"BorderColor3",
			"Rotation",
			"TextStrokeTransparency",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextColor3"
		}) do
			p_u_271[v_u_274] = v_u_273[v_u_274]
			p_u_270:addToJanitor(v_u_273:GetPropertyChangedSignal(v_u_274):Connect(function()
				-- upvalues: (ref) p_u_271, (copy) v_u_274, (copy) v_u_273
				p_u_271[v_u_274] = v_u_273[v_u_274]
			end))
		end
		local function v_u_279()
			-- upvalues: (ref) p_u_271
			local v275 = 0
			local v276 = 0
			for _, v277 in p_u_271.Frame:GetChildren() do
				local v278 = string.lower(v277.Name)
				if v278 == "digit" then
					v275 = v275 + v277.AbsoluteSize.X
					v276 = v276 + 1
				elseif (v278 == "prefix" or (v278 == "suffix" or v278 == "comma")) and v277.Text ~= "" then
					v275 = v275 + v277.AbsoluteSize.X
					v276 = v276 + 1
				end
			end
			return v275, v276
		end
		local function v_u_288()
			-- upvalues: (copy) v_u_279, (ref) p_u_270, (ref) p_u_271, (copy) v_u_273
			local v280, v281 = v_u_279()
			if v281 < 18 then
				p_u_270:setLabel(p_u_271.Value)
			end
			local v282 = p_u_271.Frame.AbsoluteSize.X
			while v280 < v282 and p_u_270.isDestroyed ~= true do
				task.wait(0.05)
				if v281 > 0 and v281 < 8 then
					p_u_271.TextSize = v_u_273.TextSize
					break
				end
				local v283 = p_u_271
				v283.TextSize = v283.TextSize + 1
				v282 = p_u_271.Frame.AbsoluteSize.X
				v280, v281 = v_u_279()
			end
			local v284 = v_u_273.Parent
			if v284 then
				v284 = v284.Parent
			end
			local v285
			if v284 == nil then
				v285 = 0
			elseif v284.IconImage.Visible == true then
				v285 = p_u_271.Frame.AbsoluteSize.X + v_u_273.Parent.Parent.IconImage.AbsoluteSize.X
			else
				v285 = v284.AbsoluteSize.X
			end
			while v285 < v280 and p_u_270.isDestroyed ~= true do
				task.wait(0.05)
				if v281 < 8 and v281 > 0 then
					p_u_271.TextSize = v_u_273.TextSize
					return
				end
				local v286 = p_u_271
				v286.TextSize = v286.TextSize - 1
				local v287 = v_u_273.Parent
				if v287 then
					v287 = v287.Parent
				end
				if v287 == nil then
					v285 = 0
				elseif v287.IconImage.Visible == true then
					v285 = p_u_271.Frame.AbsoluteSize.X + v_u_273.Parent.Parent.IconImage.AbsoluteSize.X
				else
					v285 = v287.AbsoluteSize.X
				end
				v280, v281 = v_u_279()
			end
		end
		p_u_270:addToJanitor(p_u_271.Frame.ChildAdded:Connect(v_u_288))
		p_u_270:addToJanitor(p_u_271.Frame.ChildRemoved:Connect(v_u_288))
		p_u_270:addToJanitor(p_u_270.iconAdded:Connect(function()
			-- upvalues: (copy) v_u_288
			task.wait(1)
			v_u_288()
		end))
		p_u_270:updateParent()
		p_u_271.Name = "LabelSpinner"
		p_u_271.Prefix = "$"
		p_u_271.Commas = true
		p_u_271.Decimals = 0
		p_u_271.Duration = 0.25
		p_u_271.Value = 10
		task.wait(0.2)
		local v289 = p_u_272
		if typeof(v289) == "function" then
			p_u_272()
		end
	end)
	return p_u_270
end
function v_u_15.destroy(p290)
	-- upvalues: (copy) v_u_15
	if not p290.isDestroyed then
		p290:clearNotices()
		if p290.parentIconUID then
			p290:leave()
		end
		p290.isDestroyed = true
		p290.janitor:clean()
		v_u_15.iconRemoved:Fire(p290)
	end
end
v_u_15.Destroy = v_u_15.destroy
return v_u_15