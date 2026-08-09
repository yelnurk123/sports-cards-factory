-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = {}
local v_u_2 = game:GetService("Players").LocalPlayer
function v_u_1.createStagger(p3, p_u_4, p_u_5)
	local v_u_6 = false
	local v_u_7 = false
	local v_u_8 = (not p3 or p3 == 0) and 0.01 or p3
	local function v_u_12(...)
		-- upvalues: (ref) v_u_6, (ref) v_u_7, (copy) p_u_5, (ref) v_u_8, (copy) p_u_4, (copy) v_u_12
		if v_u_6 then
			v_u_7 = true
		else
			local v_u_9 = table.pack(...)
			v_u_6 = true
			v_u_7 = false
			task.spawn(function()
				-- upvalues: (ref) p_u_5, (ref) v_u_8, (ref) p_u_4, (copy) v_u_9
				if p_u_5 then
					task.wait(v_u_8)
				end
				local v10 = v_u_9
				p_u_4(table.unpack(v10))
			end)
			task.delay(v_u_8, function()
				-- upvalues: (ref) v_u_6, (ref) v_u_7, (ref) v_u_12, (copy) v_u_9
				v_u_6 = false
				if v_u_7 then
					local v11 = v_u_9
					v_u_12(table.unpack(v11))
				end
			end)
		end
	end
	return v_u_12
end
function v_u_1.round(p13)
	local v14 = p13 + 0.5
	return math.floor(v14)
end
function v_u_1.reverseTable(p15)
	local v16 = #p15 / 2
	for v17 = 1, math.floor(v16) do
		local v18 = #p15 - v17 + 1
		local v19 = p15[v18]
		local v20 = p15[v17]
		p15[v17] = v19
		p15[v18] = v20
	end
end
function v_u_1.copyTable(p21)
	-- upvalues: (copy) v_u_1
	local v22 = type(p21) == "table"
	assert(v22, "First argument must be a table")
	local v23 = table.create(#p21)
	for v24, v25 in pairs(p21) do
		if type(v25) == "table" then
			v23[v24] = v_u_1.copyTable(v25)
		else
			v23[v24] = v25
		end
	end
	return v23
end
local v_u_26 = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	"<",
	">",
	"?",
	"@",
	"{",
	"}",
	"[",
	"]",
	"!",
	"(",
	")",
	"=",
	"+",
	"~",
	"#"
}
function v_u_1.generateUID(p27)
	-- upvalues: (copy) v_u_26
	local v28 = v_u_26
	local v29 = #v28
	local v30 = ""
	for _ = 1, p27 or 8 do
		v30 = v30 .. v28[math.random(1, v29)]
	end
	return v30
end
local v_u_31 = {}
function v_u_1.setVisible(p_u_32, p33, p34)
	-- upvalues: (copy) v_u_31
	local v35 = v_u_31[p_u_32]
	if not v35 then
		v35 = {}
		v_u_31[p_u_32] = v35
		p_u_32.Destroying:Once(function()
			-- upvalues: (ref) v_u_31, (copy) p_u_32
			v_u_31[p_u_32] = nil
		end)
	end
	if p33 then
		v35[p34] = nil
	else
		v35[p34] = true
	end
	if p33 then
		for _, _ in pairs(v35) do
			p33 = false
			break
		end
	end
	p_u_32.Visible = p33
end
function v_u_1.formatStateName(p36)
	return string.upper((string.sub(p36, 1, 1))) .. string.lower((string.sub(p36, 2)))
end
function v_u_1.localPlayerRespawned(p37)
	-- upvalues: (copy) v_u_2
	v_u_2.CharacterRemoving:Connect(p37)
end
function v_u_1.getClippedContainer(p38)
	local v39 = p38:FindFirstChild("ClippedContainer")
	if not v39 then
		v39 = Instance.new("Folder")
		v39.Name = "ClippedContainer"
		v39.Parent = p38
	end
	return v39
end
local v_u_40 = require(script.Parent.Packages.Janitor)
local v_u_41 = game:GetService("GuiService")
function v_u_1.clipOutside(p_u_42, p_u_43)
	-- upvalues: (copy) v_u_40, (copy) v_u_1, (copy) v_u_41
	local v_u_44 = p_u_42.janitor:add(v_u_40.new())
	p_u_43.Destroying:Once(function()
		-- upvalues: (copy) v_u_44
		v_u_44:Destroy()
	end)
	p_u_42.janitor:add(p_u_43)
	local v_u_45 = p_u_43.Parent
	local v_u_46 = v_u_44:add(Instance.new("Frame"))
	v_u_46:SetAttribute("IsAClippedClone", true)
	v_u_46.Name = p_u_43.Name
	v_u_46.AnchorPoint = p_u_43.AnchorPoint
	v_u_46.Size = p_u_43.Size
	v_u_46.Position = p_u_43.Position
	v_u_46.BackgroundTransparency = 1
	v_u_46.LayoutOrder = p_u_43.LayoutOrder
	v_u_46.Parent = v_u_45
	local v47 = Instance.new("ObjectValue")
	v47.Name = "OriginalInstance"
	v47.Value = p_u_43
	v47.Parent = v_u_46
	local v48 = v47:Clone()
	p_u_43:SetAttribute("HasAClippedClone", true)
	v48.Name = "ClippedClone"
	v48.Value = v_u_46
	v48.Parent = p_u_43
	local v_u_49 = nil
	local v_u_50 = require(p_u_42.iconModule)
	local v_u_51 = v_u_50.container
	local function v53()
		-- upvalues: (copy) v_u_45, (ref) v_u_49, (copy) v_u_51, (copy) p_u_43, (ref) v_u_1
		local v52 = v_u_45:FindFirstAncestorWhichIsA("ScreenGui")
		if not string.match(v52.Name, "Clipped") then
			v52 = v_u_51[v52.Name .. "Clipped"]
		end
		v_u_49 = v52
		p_u_43.AnchorPoint = Vector2.new(0, 0)
		p_u_43.Parent = v_u_1.getClippedContainer(v_u_49)
	end
	v_u_44:add(p_u_42.alignmentChanged:Connect(v53))
	v53()
	local v_u_54 = v_u_49
	for _, v55 in pairs(p_u_43:GetChildren()) do
		if v55:IsA("UIAspectRatioConstraint") then
			v55:Clone().Parent = v_u_46
		end
	end
	local v_u_56 = p_u_42.widget
	local v_u_57 = false
	local v_u_58 = p_u_43:GetAttribute("IgnoreVisibilityUpdater")
	local function v60()
		-- upvalues: (copy) v_u_58, (copy) v_u_56, (ref) v_u_57, (ref) v_u_1, (copy) p_u_43
		if not v_u_58 then
			local v59 = v_u_56.Visible
			if v_u_57 then
				v59 = false
			end
			v_u_1.setVisible(p_u_43, v59, "ClipHandler")
		end
	end
	v_u_44:add(v_u_56:GetPropertyChangedSignal("Visible"):Connect(v60))
	local v_u_61 = nil
	local function v_u_75()
		-- upvalues: (copy) p_u_42, (copy) p_u_43, (copy) v_u_50, (ref) v_u_57, (copy) v_u_58, (copy) v_u_56, (ref) v_u_1, (ref) v_u_61, (copy) v_u_75, (copy) v_u_44
		task.defer(function()
			-- upvalues: (ref) p_u_42, (ref) p_u_43, (ref) v_u_50, (ref) v_u_57, (ref) v_u_58, (ref) v_u_56, (ref) v_u_1, (ref) v_u_61, (ref) v_u_75, (ref) v_u_44
			local v62 = nil
			local v63 = p_u_42.UID
			local v64
			if p_u_43:GetAttribute("ClipToJoinedParent") then
				v64 = v63
				for _ = 1, 10 do
					local v65 = v_u_50.getIconByUID(v63)
					if not v65 then
						break
					end
					local v66 = v65.joinedFrame
					v63 = v65.parentIconUID
					if not v66 then
						break
					end
					if v66 and v66.Name == "DropdownScroller" then
						v62 = v66
						break
					end
					v62 = v66
				end
			else
				v64 = v63
			end
			if v62 then
				local v67 = p_u_43.AbsolutePosition
				local v68 = p_u_43.AbsoluteSize / 2
				local v69 = v62.AbsolutePosition
				local v70 = v62.AbsoluteSize
				local v71 = v67 + v68
				local v72 = v71.X < v69.X or (v71.X > v69.X + v70.X or (v71.Y < v69.Y or v71.Y > v69.Y + v70.Y))
				if v72 ~= v_u_57 then
					v_u_57 = v72
					if not v_u_58 then
						local v73 = v_u_56.Visible
						if v_u_57 then
							v73 = false
						end
						v_u_1.setVisible(p_u_43, v73, "ClipHandler")
					end
				end
				if v62:IsA("ScrollingFrame") and v_u_61 ~= v62 then
					v_u_61 = v62
					v_u_44:add(v62:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
						-- upvalues: (ref) v_u_75
						v_u_75()
					end), "Disconnect", "TrackUtilityScroller-" .. v64)
				end
				return
			else
				v_u_57 = false
				if not v_u_58 then
					local v74 = v_u_56.Visible
					if v_u_57 then
						v74 = false
					end
					v_u_1.setVisible(p_u_43, v74, "ClipHandler")
				end
			end
		end)
	end
	local v_u_76 = workspace.CurrentCamera
	local v_u_77 = p_u_43:GetAttribute("AdditionalOffsetX") or 0
	local function v106(p_u_78)
		-- upvalues: (copy) v_u_46, (copy) v_u_76, (copy) p_u_43, (ref) v_u_41, (ref) v_u_54, (copy) v_u_50, (copy) v_u_77, (copy) p_u_42, (ref) v_u_57, (copy) v_u_58, (copy) v_u_56, (ref) v_u_1, (ref) v_u_61, (copy) v_u_75, (copy) v_u_44
		local v_u_79 = "Absolute" .. p_u_78
		local function v103()
			-- upvalues: (ref) v_u_46, (copy) v_u_79, (copy) p_u_78, (ref) v_u_76, (ref) p_u_43, (ref) v_u_41, (ref) v_u_54, (ref) v_u_50, (ref) v_u_77, (ref) p_u_42, (ref) v_u_57, (ref) v_u_58, (ref) v_u_56, (ref) v_u_1, (ref) v_u_61, (ref) v_u_75, (ref) v_u_44
			local v80 = v_u_46[v_u_79]
			local v81 = UDim2.fromOffset(v80.X, v80.Y)
			if p_u_78 == "Position" then
				local v82 = v_u_76.ViewportSize.X - p_u_43.AbsoluteSize.X - 4
				local v83 = v81.X.Offset
				if v83 < 4 then
					v82 = 4
				elseif v82 >= v83 then
					v82 = v83
				end
				local v84 = UDim2.fromOffset(v82, v81.Y.Offset)
				local v85 = v_u_41.TopbarInset
				local v86 = workspace.CurrentCamera.ViewportSize.X
				local v87 = v_u_54.AbsoluteSize.X
				local v88 = v_u_54.AbsolutePosition.X
				if not v_u_50.isOldTopbar then
					v88 = v86 - v87 - 0
				end
				local v89 = v88 - v_u_77
				v81 = v84 + UDim2.fromOffset(-v89, v85.Height)
				task.defer(function()
					-- upvalues: (ref) p_u_42, (ref) p_u_43, (ref) v_u_50, (ref) v_u_57, (ref) v_u_58, (ref) v_u_56, (ref) v_u_1, (ref) v_u_61, (ref) v_u_75, (ref) v_u_44
					local v90 = nil
					local v91 = p_u_42.UID
					local v92
					if p_u_43:GetAttribute("ClipToJoinedParent") then
						v92 = v91
						for _ = 1, 10 do
							local v93 = v_u_50.getIconByUID(v91)
							if not v93 then
								break
							end
							local v94 = v93.joinedFrame
							v91 = v93.parentIconUID
							if not v94 then
								break
							end
							if v94 and v94.Name == "DropdownScroller" then
								v90 = v94
								break
							end
							v90 = v94
						end
					else
						v92 = v91
					end
					if v90 then
						local v95 = p_u_43.AbsolutePosition
						local v96 = p_u_43.AbsoluteSize / 2
						local v97 = v90.AbsolutePosition
						local v98 = v90.AbsoluteSize
						local v99 = v95 + v96
						local v100 = v99.X < v97.X or (v99.X > v97.X + v98.X or (v99.Y < v97.Y or v99.Y > v97.Y + v98.Y))
						if v100 ~= v_u_57 then
							v_u_57 = v100
							if not v_u_58 then
								local v101 = v_u_56.Visible
								if v_u_57 then
									v101 = false
								end
								v_u_1.setVisible(p_u_43, v101, "ClipHandler")
							end
						end
						if v90:IsA("ScrollingFrame") and v_u_61 ~= v90 then
							v_u_61 = v90
							v_u_44:add(v90:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
								-- upvalues: (ref) v_u_75
								v_u_75()
							end), "Disconnect", "TrackUtilityScroller-" .. v92)
						end
						return
					else
						v_u_57 = false
						if not v_u_58 then
							local v102 = v_u_56.Visible
							if v_u_57 then
								v102 = false
							end
							v_u_1.setVisible(p_u_43, v102, "ClipHandler")
						end
					end
				end)
			end
			p_u_43[p_u_78] = v81
		end
		local v_u_104 = v_u_1.createStagger(0.01, v103)
		v_u_44:add(v_u_46:GetPropertyChangedSignal(v_u_79):Connect(v_u_104))
		v_u_44:add(v_u_46:GetAttributeChangedSignal("ForceUpdate"):Connect(function()
			-- upvalues: (copy) v_u_104
			v_u_104()
		end))
		local v105 = v_u_1.createStagger(0.5, v103, true)
		v_u_44:add(v_u_46:GetPropertyChangedSignal(v_u_79):Connect(v105))
		if p_u_78 == "Position" then
			v_u_44:add(v_u_54:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				-- upvalues: (copy) v_u_104
				v_u_104()
			end))
		end
	end
	task.delay(0.1, v_u_75)
	task.defer(function()
		-- upvalues: (copy) p_u_42, (copy) p_u_43, (copy) v_u_50, (ref) v_u_57, (copy) v_u_58, (copy) v_u_56, (ref) v_u_1, (ref) v_u_61, (copy) v_u_75, (copy) v_u_44
		local v107 = nil
		local v108 = p_u_42.UID
		local v109
		if p_u_43:GetAttribute("ClipToJoinedParent") then
			v109 = v108
			for _ = 1, 10 do
				local v110 = v_u_50.getIconByUID(v108)
				if not v110 then
					break
				end
				local v111 = v110.joinedFrame
				v108 = v110.parentIconUID
				if not v111 then
					break
				end
				if v111 and v111.Name == "DropdownScroller" then
					v107 = v111
					break
				end
				v107 = v111
			end
		else
			v109 = v108
		end
		if v107 then
			local v112 = p_u_43.AbsolutePosition
			local v113 = p_u_43.AbsoluteSize / 2
			local v114 = v107.AbsolutePosition
			local v115 = v107.AbsoluteSize
			local v116 = v112 + v113
			local v117 = v116.X < v114.X or (v116.X > v114.X + v115.X or (v116.Y < v114.Y or v116.Y > v114.Y + v115.Y))
			if v117 ~= v_u_57 then
				v_u_57 = v117
				if not v_u_58 then
					local v118 = v_u_56.Visible
					if v_u_57 then
						v118 = false
					end
					v_u_1.setVisible(p_u_43, v118, "ClipHandler")
				end
			end
			if v107:IsA("ScrollingFrame") and v_u_61 ~= v107 then
				v_u_61 = v107
				v_u_44:add(v107:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					-- upvalues: (ref) v_u_75
					v_u_75()
				end), "Disconnect", "TrackUtilityScroller-" .. v109)
			end
			return
		else
			v_u_57 = false
			if not v_u_58 then
				local v119 = v_u_56.Visible
				if v_u_57 then
					v119 = false
				end
				v_u_1.setVisible(p_u_43, v119, "ClipHandler")
			end
		end
	end)
	if not v_u_58 then
		local v120 = v_u_56.Visible
		if v_u_57 then
			v120 = false
		end
		v_u_1.setVisible(p_u_43, v120, "ClipHandler")
	end
	v106("Position")
	v_u_44:add(p_u_43:GetPropertyChangedSignal("Visible"):Connect(function() end))
	if p_u_43:GetAttribute("TrackCloneSize") then
		v106("Size")
	else
		v_u_44:add(p_u_43:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			-- upvalues: (copy) p_u_43, (copy) v_u_46
			local v121 = p_u_43.AbsoluteSize
			v_u_46.Size = UDim2.fromOffset(v121.X, v121.Y)
		end))
	end
	return v_u_46
end
function v_u_1.joinFeature(p_u_122, p_u_123, p_u_124, p125)
	local v126 = p_u_122.joinJanitor
	v126:clean()
	if p125 then
		p_u_122.parentIconUID = p_u_123.UID
		p_u_122.joinedFrame = p125
		v126:add(p_u_123.alignmentChanged:Connect(function()
			-- upvalues: (copy) p_u_123, (copy) p_u_122
			local v127 = p_u_123.alignment
			p_u_122:setAlignment(v127 == "Center" and "Left" or v127, true)
		end))
		local v128 = p_u_123.alignment
		p_u_122:setAlignment(v128 == "Center" and "Left" or v128, true)
		p_u_122:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification")
		p_u_122:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification")
		if p_u_123.childModifications then
			task.defer(function()
				-- upvalues: (copy) p_u_122, (copy) p_u_123
				p_u_122:modifyTheme(p_u_123.childModifications, p_u_123.childModificationsUID)
			end)
		end
		local v_u_129 = p_u_122:getInstance("ClickRegion")
		local function v130()
			-- upvalues: (copy) v_u_129, (copy) p_u_123
			v_u_129.Selectable = p_u_123.isSelected
		end
		v126:add(p_u_123.toggled:Connect(v130))
		task.defer(v130)
		v126:add(function()
			-- upvalues: (copy) v_u_129
			v_u_129.Selectable = true
		end)
		local v_u_131 = p_u_122.UID
		table.insert(p_u_124, v_u_131)
		p_u_123:autoDeselect(false)
		p_u_123.childIconsDict[v_u_131] = true
		if not p_u_123.isEnabled then
			p_u_123:setEnabled(true)
		end
		p_u_122.joinedParent:Fire(p_u_123)
		v126:add(function()
			-- upvalues: (copy) p_u_122, (copy) p_u_124, (copy) v_u_131, (copy) p_u_123
			if not p_u_122.joinedFrame then
				return
			end
			for v132, v133 in pairs(p_u_124) do
				if v133 == v_u_131 then
					table.remove(p_u_124, v132)
					break
				end
			end
			local v134 = require(p_u_122.iconModule).getIconByUID(p_u_122.parentIconUID)
			if v134 then
				p_u_122:setAlignment(p_u_122.originalAlignment)
				p_u_122.parentIconUID = false
				p_u_122.joinedFrame = false
				p_u_122:removeModification("JoinModification")
				local v135 = true
				local v136 = v134.childIconsDict
				v136[v_u_131] = nil
				for _, _ in pairs(v136) do
					v135 = false
					break
				end
				if v135 and not v134.isAnOverflow then
					v134:setEnabled(false)
				end
				local v137 = p_u_123.alignment
				p_u_122:setAlignment(v137 == "Center" and "Left" or v137, true)
			end
		end)
	else
		p_u_122:leave()
	end
end
return v_u_1