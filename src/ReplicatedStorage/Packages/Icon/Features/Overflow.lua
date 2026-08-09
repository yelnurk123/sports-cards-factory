-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = {}
local v_u_2 = {}
local v_u_3 = {}
local v_u_4 = nil
local v_u_5 = workspace.CurrentCamera
local v_u_6 = {}
local v_u_7 = {}
local v_u_8 = require(script.Parent.Parent.Utility)
local v_u_9 = false
local v_u_10 = false
local v_u_11 = nil
function v_u_1.start(p12)
	-- upvalues: (ref) v_u_11, (ref) v_u_4, (copy) v_u_2, (copy) v_u_8, (copy) v_u_1, (ref) v_u_9, (copy) v_u_5
	v_u_11 = p12
	v_u_4 = v_u_11.iconsDictionary
	local v13 = nil
	for _, v14 in pairs(v_u_11.container) do
		if v13 == nil then
			if v14.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
				v13 = v14
			end
		end
		for _, v15 in pairs(v14.Holders:GetChildren()) do
			if v15:GetAttribute("IsAHolder") then
				v_u_2[v15.Name] = v15
			end
		end
	end
	local v_u_16 = false
	local v_u_18 = v_u_8.createStagger(0.1, function(p17)
		-- upvalues: (ref) v_u_16, (ref) v_u_1
		if v_u_16 then
			if not p17 then
				v_u_1.updateAvailableIcons("Center")
			end
			v_u_1.updateBoundary("Left")
			v_u_1.updateBoundary("Right")
		end
	end)
	task.delay(0.5, function()
		-- upvalues: (ref) v_u_16, (copy) v_u_18
		v_u_16 = true
		v_u_18()
	end)
	task.delay(2, function()
		-- upvalues: (ref) v_u_9, (copy) v_u_18
		v_u_9 = true
		v_u_18()
	end)
	v_u_11.iconAdded:Connect(v_u_18)
	v_u_11.iconRemoved:Connect(v_u_18)
	v_u_11.iconChanged:Connect(v_u_18)
	v_u_5:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		-- upvalues: (copy) v_u_18
		v_u_18(true)
	end)
	v13:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		-- upvalues: (copy) v_u_18
		v_u_18(true)
	end)
end
function v_u_1.getWidth(p19, _)
	local v20 = p19.widget
	return v20:GetAttribute("TargetWidth") or v20.AbsoluteSize.X
end
function v_u_1.getAvailableIcons(p21)
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	return v_u_3[p21] or v_u_1.updateAvailableIcons(p21)
end
function v_u_1.updateAvailableIcons(p22)
	-- upvalues: (ref) v_u_4, (copy) v_u_7, (copy) v_u_3
	local v23 = {}
	local v24 = 0
	for _, v25 in pairs(v_u_4) do
		local v26 = v25.parentIconUID
		local v27 = not v26 or v_u_7[v26]
		local v28 = v_u_7[v25.UID]
		if v27 and (v25.alignment == p22 and (not v28 and v25.isEnabled)) then
			table.insert(v23, v25)
			v24 = v24 + 1
		end
	end
	if v24 <= 0 then
		return {}
	end
	table.sort(v23, function(p29, p30)
		local v31 = p29.widget.LayoutOrder
		local v32 = p30.widget.LayoutOrder
		local v33 = p29.parentIconUID
		local v34 = p30.parentIconUID
		if v33 == v34 then
			if v31 < v32 then
				return true
			elseif v32 < v31 then
				return false
			else
				return p29.widget.AbsolutePosition.X < p30.widget.AbsolutePosition.X
			end
		elseif v34 then
			return false
		else
			return v33 and true or nil
		end
	end)
	v_u_3[p22] = v23
	return v23
end
function v_u_1.getRealXPositions(p35, p36)
	-- upvalues: (copy) v_u_2, (copy) v_u_8, (copy) v_u_1
	local v37 = p35 == "Left"
	local v38 = v_u_2[p35]
	local v39 = v38.AbsolutePosition.X
	local v40 = v38.AbsoluteSize.X
	local v41 = v38.UIListLayout.Padding.Offset
	local v42 = v37 and v39 and v39 or v39 + v40
	local v43 = {}
	if v37 then
		v_u_8.reverseTable(p36)
	end
	for v44 = #p36, 1, -1 do
		local v45 = p36[v44]
		local v46 = v_u_1.getWidth(v45)
		if not v37 then
			v42 = v42 - v46
		end
		v43[v45.UID] = v42
		if v37 then
			v42 = v42 + v46
		end
		v42 = v42 + (v37 and v41 and v41 or -v41)
	end
	return v43
end
function v_u_1.updateBoundary(p_u_47)
	-- upvalues: (copy) v_u_2, (copy) v_u_1, (copy) v_u_6, (ref) v_u_11, (copy) v_u_7, (ref) v_u_10, (ref) v_u_9, (copy) v_u_8
	local v48 = v_u_2[p_u_47]
	local v49 = v48.UIListLayout
	local v50 = v48.AbsolutePosition.X
	local v51 = v48.AbsoluteSize.X
	local v_u_52 = v49.Padding.Offset
	local v53 = v49.Padding.Offset
	local v_u_54 = v_u_1.updateAvailableIcons(p_u_47)
	local v55 = 0
	local v56 = 0
	for _, v57 in pairs(v_u_54) do
		v55 = v55 + (v_u_1.getWidth(v57) + v53)
		v56 = v56 + 1
	end
	if v56 > 0 then
		local v58 = p_u_47 == "Center"
		local v_u_59 = p_u_47 == "Left"
		local v_u_60 = not v_u_59
		local v61 = v_u_6[p_u_47]
		if not v61 and (not v58 and #v_u_54 > 0) then
			v61 = v_u_11.new()
			v61:setImage(6069276526, "Deselected")
			v61:setName("Overflow" .. p_u_47)
			v61:setOrder(v_u_59 and -9999999 or 9999999)
			v61:setAlignment(p_u_47)
			v61:autoDeselect(false)
			v61.isAnOverflow = true
			v61:select("OverflowStart", v61)
			v61:setEnabled(false)
			v_u_6[p_u_47] = v61
			v_u_7[v61.UID] = true
			if not v_u_11.closeableOverflowMenus then
				v61:getInstance("IconSpot").Visible = false
			end
		end
		local v62 = p_u_47 == "Left" and "Right" or "Left"
		local v63 = v_u_1.updateAvailableIcons(v62)
		local v64 = v_u_59 and v63[1]
		if not v64 then
			if v_u_60 then
				v64 = v63[#v63]
			else
				v64 = v_u_60
			end
		end
		local v65 = v_u_6[v62]
		local v66
		if v_u_59 then
			v66 = v50 + v51 or v50
		else
			v66 = v50
		end
		if v64 then
			local v67 = v_u_1.getRealXPositions(v62, v63)[v64.UID]
			local v68 = v_u_1.getWidth(v64)
			v66 = v_u_59 and v67 - v_u_52 or v67 + v68 + v_u_52
		end
		local v_u_69 = 0
		local function v_u_78()
			-- upvalues: (ref) v_u_1, (copy) v_u_59, (ref) v_u_10, (copy) p_u_47, (copy) v_u_54, (copy) v_u_60, (copy) v_u_52, (ref) v_u_9, (ref) v_u_69, (copy) v_u_78
			local v70 = v_u_1.getAvailableIcons("Center")
			local v71 = v70[v_u_59 and 1 or #v70]
			if v71 and not v71.hasRelocatedInOverflow then
				local v72 = not (v_u_59 and v_u_54[#v_u_54]) and v_u_60
				if v72 then
					v72 = v_u_54[1]
				end
				local v73 = v71.widget.AbsolutePosition.X
				local v74 = v72.widget.AbsolutePosition.X
				local v75 = v_u_1.getWidth(v72)
				local v76 = v_u_59 and v73 - v_u_52 or v73 + v_u_1.getWidth(v71) + v_u_52
				if v_u_59 then
					v74 = v74 + v75 or v74
				end
				local v77 = false
				if v_u_59 then
					if v76 < v74 then
						if not v_u_9 then
							if not v_u_10 then
								v_u_10 = true
								task.delay(3, v_u_1.updateBoundary, p_u_47)
							end
							return
						end
						v71:align("Left")
						v71.hasRelocatedInOverflow = true
						v77 = true
					end
				elseif v_u_60 and v74 < v76 then
					if not v_u_9 or v74 < 0 then
						if not v_u_10 then
							v_u_10 = true
							task.delay(3, v_u_1.updateBoundary, p_u_47)
						end
						return
					end
					v71:align("Right")
					v71.hasRelocatedInOverflow = true
					v77 = true
				end
				if v77 then
					v_u_69 = v_u_69 + 1
					if v_u_69 <= 4 then
						v_u_1.updateAvailableIcons("Center")
						v_u_78()
					end
				end
			end
		end
		v_u_78()
		if v61 then
			local v79 = v61:getInstance("Menu")
			local v80 = v50 + v51
			if v79 and v65 then
				local v81 = v65.widget.AbsolutePosition.X
				local v82 = v_u_1.getWidth(v65)
				local v83 = v_u_59 and v81 - v_u_52 or v81 + v82 + v_u_52
				local v84 = v65:getInstance("Menu")
				local v85 = v79.AbsoluteCanvasSize.X >= v84.AbsoluteCanvasSize.X
				local v86 = v50 + v51 / 2
				local v87 = v_u_59 and v86 - v_u_52 / 2 or v86 + v_u_52 / 2
				if v85 then
					v87 = v83
				end
				v51 = v_u_59 and v87 - v50 or v80 - v87
			end
			local v88
			if v79 then
				v88 = v79:GetAttribute("MaxWidth")
			else
				v88 = v79
			end
			local v89 = v_u_8.round(v51)
			if v79 and v88 ~= v89 then
				v79:SetAttribute("MaxWidth", v89)
			end
		end
		local v90 = v_u_1.getRealXPositions(p_u_47, v_u_54)
		local v91 = false
		for v92 = #v_u_54, 1, -1 do
			local v93 = v_u_54[v92]
			local v94 = v_u_1.getWidth(v93)
			local v95 = v90[v93.UID]
			if v_u_59 and v66 <= v95 + v94 or v_u_60 and v95 <= v66 then
				v91 = true
			end
		end
		for v96 = #v_u_54, 1, -1 do
			local v97 = v_u_54[v96]
			if not v_u_7[v97.UID] then
				if v91 and not v97.parentIconUID then
					v97:joinMenu(v61)
				elseif not v91 and v97.parentIconUID then
					v97:leave()
				end
			end
		end
		if v61.isEnabled ~= v91 then
			v61:setEnabled(v91)
		end
		if v61.isEnabled and not v61.overflowAlreadyOpened then
			v61.overflowAlreadyOpened = true
			v61:select()
		end
	end
end
return v_u_1