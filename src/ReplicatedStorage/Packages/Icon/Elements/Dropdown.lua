-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = game:GetService("TweenService")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(script.Parent.Parent.Features.Themes)
return function(p_u_4)
	-- upvalues: (copy) v_u_3, (copy) v_u_1, (copy) v_u_2
	local v_u_5 = Instance.new("Frame")
	v_u_5.Name = "Dropdown"
	v_u_5.AutomaticSize = Enum.AutomaticSize.X
	v_u_5.BackgroundTransparency = 1
	v_u_5.BorderSizePixel = 0
	v_u_5.AnchorPoint = Vector2.new(0.5, 0)
	v_u_5.Position = UDim2.new(0.5, 0, 1, 10)
	v_u_5.ZIndex = -2
	v_u_5.ClipsDescendants = true
	v_u_5.Parent = p_u_4.widget
	local v_u_6 = game:GetService("GuiService")
	p_u_4:setBehaviour("Dropdown", "BackgroundTransparency", function(p7)
		-- upvalues: (copy) v_u_6
		local v8 = p7 * v_u_6.PreferredTransparency
		if p7 == 1 then
			return p7
		else
			return v8
		end
	end)
	p_u_4.janitor:add(v_u_6:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		-- upvalues: (copy) p_u_4, (copy) v_u_5
		p_u_4:refreshAppearance(v_u_5, "BackgroundTransparency")
	end))
	local v9 = Instance.new("UICorner")
	v9.Name = "DropdownCorner"
	v9.CornerRadius = UDim.new(0, 10)
	v9.Parent = v_u_5
	local v_u_10 = Instance.new("ScrollingFrame")
	v_u_10.Name = "DropdownScroller"
	v_u_10.AutomaticSize = Enum.AutomaticSize.X
	v_u_10.BackgroundTransparency = 1
	v_u_10.BorderSizePixel = 0
	v_u_10.AnchorPoint = Vector2.new(0, 0)
	v_u_10.Position = UDim2.new(0, 0, 0, 0)
	v_u_10.ZIndex = -1
	v_u_10.ClipsDescendants = true
	v_u_10.Visible = true
	v_u_10.VerticalScrollBarInset = Enum.ScrollBarInset.None
	v_u_10.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	v_u_10.Active = false
	v_u_10.ScrollingEnabled = true
	v_u_10.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v_u_10.ScrollBarThickness = 5
	v_u_10.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	v_u_10.ScrollBarImageTransparency = 0.8
	v_u_10.CanvasSize = UDim2.new(0, 0, 0, 0)
	v_u_10.Selectable = false
	v_u_10.Active = true
	v_u_10.Parent = v_u_5
	local v_u_11 = Instance.new("NumberValue")
	v_u_11.Name = "DropdownSpeed"
	v_u_11.Value = 0.07
	v_u_11.Parent = v_u_5
	local v_u_12 = Instance.new("UIPadding")
	v_u_12.Name = "DropdownPadding"
	v_u_12.PaddingTop = UDim.new(0, 0)
	v_u_12.PaddingBottom = UDim.new(0, 0)
	v_u_12.Parent = v_u_10
	local v13 = Instance.new("UIListLayout")
	v13.Name = "DropdownList"
	v13.FillDirection = Enum.FillDirection.Vertical
	v13.SortOrder = Enum.SortOrder.LayoutOrder
	v13.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v13.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	v13.Parent = v_u_10
	local v14 = p_u_4.dropdownJanitor
	local v_u_15 = require(p_u_4.iconModule)
	p_u_4.dropdownChildAdded:Connect(function(p_u_16)
		local _, v_u_17 = p_u_16:modifyTheme({
			{ "Widget", "BorderSize", 0 },
			{ "IconCorners", "CornerRadius", UDim.new(0, 10) },
			{ "Widget", "MinimumWidth", 190 },
			{ "Widget", "MinimumHeight", 58 },
			{ "IconLabel", "TextSize", 20 },
			{ "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
			{ "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
			{ "Notice", "Position", UDim2.new(1, -24, 0, 5) },
			{ "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
			{ "Selection", "Size", UDim2.new(1, -0, 1, -0) },
			{ "Selection", "Position", UDim2.new(0, 0, 0, 0) }
		})
		task.defer(function()
			-- upvalues: (copy) p_u_16, (copy) v_u_17
			p_u_16.joinJanitor:add(function()
				-- upvalues: (ref) p_u_16, (ref) v_u_17
				p_u_16:removeModification(v_u_17)
			end)
		end)
	end)
	p_u_4.dropdownSet:Connect(function(p18)
		-- upvalues: (copy) p_u_4, (copy) v_u_15
		for _, v19 in pairs(p_u_4.dropdownIcons) do
			v_u_15.getIconByUID(v19):destroy()
		end
		if type(p18) == "table" then
			for _, v20 in pairs(p18) do
				v20:joinDropdown(p_u_4)
			end
		end
	end)
	local function v_u_32()
		-- upvalues: (copy) v_u_5, (copy) v_u_10, (copy) v_u_12
		local v21 = v_u_5:GetAttribute("MaxIcons")
		if not v21 then
			return 0
		end
		local v22 = {}
		for _, v23 in pairs(v_u_10:GetChildren()) do
			if v23:IsA("GuiObject") and v23.Visible then
				table.insert(v22, v23)
			end
		end
		table.sort(v22, function(p24, p25)
			return p24.AbsolutePosition.Y < p25.AbsolutePosition.Y
		end)
		local v26 = math.ceil(v21)
		local v27 = 0
		for v28 = 1, v26 do
			local v29 = v22[v28]
			if not v29 then
				break
			end
			local v30 = v29.AbsoluteSize.Y
			local v31
			if v28 == v26 then
				v31 = v26 ~= v21
			else
				v31 = false
			end
			if v31 then
				v30 = v30 * (v21 - v26 + 1)
			end
			v27 = v27 + v30
		end
		return v27 + (v_u_12.PaddingTop.Offset + v_u_12.PaddingBottom.Offset)
	end
	local v_u_33 = nil
	local v_u_34 = nil
	local v_u_35 = nil
	local v_u_36 = nil
	local function v40()
		-- upvalues: (ref) v_u_3, (copy) v_u_5, (ref) v_u_35, (ref) v_u_36, (copy) v_u_11, (ref) v_u_33, (ref) v_u_34, (copy) p_u_4, (copy) v_u_32, (ref) v_u_1
		local v37 = v_u_3.getInstanceValue(v_u_5, "MaxIcons") or 1
		local v38
		if v_u_35 and (v_u_35 == v37 and v_u_36) then
			v38 = v_u_36
		else
			v38 = TweenInfo.new(v_u_11.Value * v37, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
			v_u_36 = v38
			v_u_35 = v37
		end
		if v_u_33 then
			v_u_33:Cancel()
			v_u_33 = nil
		end
		if v_u_34 then
			v_u_34:Cancel()
			v_u_34 = nil
		end
		if p_u_4.isSelected then
			local v39 = v_u_32()
			v_u_5.Visible = true
			v_u_5.BackgroundTransparency = 0
			v_u_5.Size = UDim2.new(0, v_u_5.Size.X.Offset, 0, 0)
			v_u_33 = v_u_1:Create(v_u_5, v38, {
				["Size"] = UDim2.new(0, v_u_5.Size.X.Offset, 0, v39)
			})
			v_u_33:Play()
			v_u_33.Completed:Connect(function()
				-- upvalues: (ref) v_u_33
				v_u_33 = nil
			end)
		else
			v_u_34 = v_u_1:Create(v_u_5, TweenInfo.new(0), {
				["Size"] = UDim2.new(0, v_u_5.Size.X.Offset, 0, 0)
			})
			v_u_34:Play()
			v_u_34.Completed:Connect(function()
				-- upvalues: (ref) v_u_34
				v_u_34 = nil
			end)
		end
	end
	v14:add(p_u_4.toggled:Connect(v40))
	v40()
	local function v_u_44()
		-- upvalues: (ref) v_u_3, (copy) v_u_5, (ref) v_u_35, (ref) v_u_36, (copy) v_u_11, (copy) p_u_4, (ref) v_u_33, (ref) v_u_34, (ref) v_u_2, (copy) v_u_32, (ref) v_u_1
		local v41 = v_u_3.getInstanceValue(v_u_5, "MaxIcons") or 1
		local v42
		if v_u_35 and (v_u_35 == v41 and v_u_36) then
			v42 = v_u_36
		else
			v42 = TweenInfo.new(v_u_11.Value * v41, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
			v_u_36 = v42
			v_u_35 = v41
		end
		if p_u_4.isSelected then
			if v_u_33 then
				v_u_33:Cancel()
				v_u_33 = nil
			end
			if v_u_34 then
				v_u_34:Cancel()
				v_u_34 = nil
			end
			v_u_2.Heartbeat:Wait()
			local v43 = v_u_32()
			v_u_33 = v_u_1:Create(v_u_5, v42, {
				["Size"] = UDim2.new(0, v_u_5.Size.X.Offset, 0, v43)
			})
			v_u_33:Play()
			v_u_33.Completed:Connect(function()
				-- upvalues: (ref) v_u_33
				v_u_33 = nil
			end)
		end
	end
	v14:add(p_u_4.toggled:Connect(v40))
	local v_u_45 = 0
	local v_u_46 = false
	local function v_u_65()
		-- upvalues: (ref) v_u_45, (ref) v_u_46, (copy) v_u_65, (copy) v_u_5, (copy) v_u_10, (copy) v_u_15, (copy) p_u_4, (copy) v_u_12
		v_u_45 = v_u_45 + 1
		if v_u_46 then
			return
		end
		local v_u_47 = v_u_45
		v_u_46 = true
		task.defer(function()
			-- upvalues: (ref) v_u_46, (ref) v_u_45, (copy) v_u_47, (ref) v_u_65
			v_u_46 = false
			if v_u_45 ~= v_u_47 then
				v_u_65()
			end
		end)
		local v48 = v_u_5:GetAttribute("MaxIcons")
		if not v48 then
			return
		end
		local v49 = {}
		for _, v50 in pairs(v_u_10:GetChildren()) do
			if v50:IsA("GuiObject") and v50.Visible then
				local v51 = { v50, v50.AbsolutePosition.Y }
				table.insert(v49, v51)
			end
		end
		table.sort(v49, function(p52, p53)
			return p52[2] < p53[2]
		end)
		local v54 = math.ceil(v48)
		local v55 = 0
		local v56 = false
		for v57 = 1, v54 do
			local v58 = v49[v57]
			if not v58 then
				break
			end
			local v59 = v58[1]
			local v60 = v59.AbsoluteSize.Y
			local v61
			if v57 == v54 then
				v61 = v54 ~= v48
			else
				v61 = false
			end
			if v61 then
				v60 = v60 * (v48 - v54 + 1)
			end
			v55 = v55 + v60
			if not v61 then
				local v62 = v59:GetAttribute("WidgetUID")
				if v62 then
					v62 = v_u_15.getIconByUID(v62)
				end
				if v62 then
					local v63
					if v56 then
						v63 = nil
					else
						v63 = p_u_4:getInstance("ClickRegion")
						v56 = true
					end
					v62:getInstance("ClickRegion").NextSelectionUp = v63
				end
			end
		end
		local v64 = v55 + (v_u_12.PaddingTop.Offset + v_u_12.PaddingBottom.Offset)
		v_u_10.Size = UDim2.fromOffset(0, v64)
	end
	v14:add(v_u_10:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v_u_65))
	v14:add(v_u_10.ChildAdded:Connect(v_u_65))
	v14:add(v_u_10.ChildRemoved:Connect(v_u_44))
	v14:add(v_u_10.ChildRemoved:Connect(v_u_65))
	v14:add(v_u_5:GetAttributeChangedSignal("MaxIcons"):Connect(v_u_65))
	v14:add(v_u_5:GetAttributeChangedSignal("MaxIcons"):Connect(v_u_44))
	v14:add(p_u_4.childThemeModified:Connect(v_u_65))
	v_u_65()
	for _, v66 in pairs(v_u_10:GetChildren()) do
		if v66:IsA("GuiObject") then
			v66:GetPropertyChangedSignal("Visible"):Connect(v_u_44)
			v66:GetPropertyChangedSignal("Size"):Connect(v_u_44)
		end
	end
	v_u_10.ChildAdded:Connect(function(p67)
		-- upvalues: (ref) v_u_2, (copy) v_u_44
		v_u_2.Heartbeat:Wait()
		if p67:IsA("GuiObject") then
			p67:GetPropertyChangedSignal("Visible"):Connect(v_u_44)
			p67:GetPropertyChangedSignal("Size"):Connect(v_u_44)
		end
		v_u_44()
	end)
	v_u_5.Visible = false
	return v_u_5
end