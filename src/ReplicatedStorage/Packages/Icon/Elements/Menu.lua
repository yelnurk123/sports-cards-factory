-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

return function(p_u_1)
	local v_u_2 = Instance.new("ScrollingFrame")
	v_u_2.Name = "Menu"
	v_u_2.BackgroundTransparency = 1
	v_u_2.Visible = true
	v_u_2.ZIndex = 1
	v_u_2.Size = UDim2.fromScale(1, 1)
	v_u_2.ClipsDescendants = true
	v_u_2.TopImage = ""
	v_u_2.BottomImage = ""
	v_u_2.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	v_u_2.CanvasSize = UDim2.new(0, 0, 1, -1)
	v_u_2.ScrollingEnabled = true
	v_u_2.ScrollingDirection = Enum.ScrollingDirection.X
	v_u_2.ZIndex = 20
	v_u_2.ScrollBarThickness = 3
	v_u_2.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	v_u_2.ScrollBarImageTransparency = 0.8
	v_u_2.BorderSizePixel = 0
	v_u_2.Selectable = false
	local v_u_3 = require(p_u_1.iconModule)
	local v_u_4 = v_u_3.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()
	v_u_4.Name = "MenuUIListLayout"
	v_u_4.VerticalAlignment = Enum.VerticalAlignment.Center
	v_u_4.Parent = v_u_2
	local v5 = Instance.new("Frame")
	v5.Name = "MenuGap"
	v5.BackgroundTransparency = 1
	v5.Visible = false
	v5.AnchorPoint = Vector2.new(0, 0.5)
	v5.ZIndex = 5
	v5.Parent = v_u_2
	local v_u_6 = false
	local v_u_7 = require(script.Parent.Parent.Features.Themes)
	local function v35()
		-- upvalues: (copy) p_u_1, (ref) v_u_6, (copy) v_u_2, (copy) v_u_7, (copy) v_u_4
		local v_u_8 = p_u_1.menuJanitor
		local v9 = #p_u_1.menuIcons
		if v_u_6 then
			if v9 <= 0 then
				v_u_8:clean()
				v_u_6 = false
			end
		else
			v_u_6 = true
			v_u_8:add(p_u_1.toggled:Connect(function()
				-- upvalues: (ref) p_u_1
				if #p_u_1.menuIcons > 0 then
					p_u_1.updateSize:Fire()
				end
			end))
			local _, v_u_10 = p_u_1:modifyTheme({
				{ "Menu", "Active", true }
			})
			task.defer(function()
				-- upvalues: (copy) v_u_8, (ref) p_u_1, (copy) v_u_10
				v_u_8:add(function()
					-- upvalues: (ref) p_u_1, (ref) v_u_10
					p_u_1:removeModification(v_u_10)
				end)
			end)
			local v_u_11 = v_u_2.AbsoluteCanvasSize.X
			local function v14()
				-- upvalues: (ref) p_u_1, (ref) v_u_2, (ref) v_u_11
				if p_u_1.alignment == "Right" then
					local v12 = v_u_2.AbsoluteCanvasSize.X
					local v13 = v_u_11 - v12
					v_u_11 = v12
					v_u_2.CanvasPosition = Vector2.new(v_u_2.CanvasPosition.X - v13, 0)
				end
			end
			v_u_8:add(p_u_1.selected:Connect(v14))
			v_u_8:add(v_u_2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v14))
			local v15 = p_u_1:getStateGroup()
			if v_u_7.getThemeValue(v15, "IconImage", "Image", "Deselected") == v_u_7.getThemeValue(v15, "IconImage", "Image", "Selected") then
				local v16 = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)
				p_u_1:removeModificationWith("IconLabel", "Text", "Viewing")
				p_u_1:removeModificationWith("IconLabel", "Image", "Viewing")
				p_u_1:modifyTheme({
					{
						"IconLabel",
						"FontFace",
						v16,
						"Selected"
					},
					{
						"IconLabel",
						"Text",
						"X",
						"Selected"
					},
					{
						"IconLabel",
						"TextSize",
						20,
						"Selected"
					},
					{
						"IconLabel",
						"TextStrokeTransparency",
						0.8,
						"Selected"
					},
					{
						"IconImage",
						"Image",
						"",
						"Selected"
					}
				})
			end
			local v_u_17 = p_u_1:getInstance("MenuGap")
			local function v20()
				-- upvalues: (ref) p_u_1, (copy) v_u_17
				local v18, v19
				if p_u_1.alignment == "Right" then
					v18 = 99999
					v19 = 99998
				else
					v18 = -99999
					v19 = -99998
				end
				p_u_1:modifyTheme({ "IconSpot", "LayoutOrder", v18 })
				v_u_17.LayoutOrder = v19
			end
			v_u_8:add(p_u_1.alignmentChanged:Connect(v20))
			local v21, v22
			if p_u_1.alignment == "Right" then
				v21 = 99999
				v22 = 99998
			else
				v21 = -99999
				v22 = -99998
			end
			p_u_1:modifyTheme({ "IconSpot", "LayoutOrder", v21 })
			v_u_17.LayoutOrder = v22
			v_u_2:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function()
				-- upvalues: (ref) v_u_2
				local v23 = v_u_2:GetAttribute("MenuCanvasWidth")
				local v24 = v_u_2.CanvasSize.Y
				v_u_2.CanvasSize = UDim2.new(0, v23, v24.Scale, v24.Offset)
			end)
			v_u_8:add(p_u_1.updateMenu:Connect(function()
				-- upvalues: (ref) v_u_2, (ref) v_u_4
				local v25 = v_u_2:GetAttribute("MaxIcons")
				if not v25 then
					return
				end
				local v26 = {}
				for _, v27 in pairs(v_u_2:GetChildren()) do
					if v27:GetAttribute("WidgetUID") and v27.Visible then
						local v28 = { v27, v27.AbsolutePosition.X }
						table.insert(v26, v28)
					end
				end
				table.sort(v26, function(p29, p30)
					return p29[2] < p30[2]
				end)
				local v31 = 0
				for v32 = 1, v25 do
					local v33 = v26[v32]
					if not v33 then
						break
					end
					v31 = v31 + (v33[1].AbsoluteSize.X + v_u_4.Padding.Offset)
				end
				v_u_2:SetAttribute("MenuWidth", v31)
			end))
			local function v34()
				-- upvalues: (ref) p_u_1
				task.delay(0.1, function()
					-- upvalues: (ref) p_u_1
					p_u_1.startMenuUpdate:Fire()
				end)
			end
			v_u_8:add(v_u_2.ChildAdded:Connect(v34))
			v_u_8:add(v_u_2.ChildRemoved:Connect(v34))
			v_u_8:add(v_u_2:GetAttributeChangedSignal("MaxIcons"):Connect(v34))
			v_u_8:add(v_u_2:GetAttributeChangedSignal("MaxWidth"):Connect(v34))
			task.delay(0.1, function()
				-- upvalues: (ref) p_u_1
				p_u_1.startMenuUpdate:Fire()
			end)
		end
	end
	p_u_1.menuChildAdded:Connect(v35)
	p_u_1.menuSet:Connect(function(p36)
		-- upvalues: (copy) p_u_1, (copy) v_u_3
		for _, v37 in pairs(p_u_1.menuIcons) do
			v_u_3.getIconByUID(v37):destroy()
		end
		if type(p36) == "table" then
			for _, v38 in pairs(p36) do
				v38:joinMenu(p_u_1)
			end
		end
	end)
	return v_u_2
end