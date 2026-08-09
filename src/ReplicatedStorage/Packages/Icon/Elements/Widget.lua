-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

return function(p_u_1, p_u_2)
	local v_u_3 = Instance.new("Frame")
	v_u_3:SetAttribute("WidgetUID", p_u_1.UID)
	v_u_3.Name = "Widget"
	v_u_3.BackgroundTransparency = 1
	v_u_3.Visible = true
	v_u_3.ZIndex = 20
	v_u_3.Active = false
	v_u_3.ClipsDescendants = true
	local v_u_4 = Instance.new("Frame")
	v_u_4.Name = "IconButton"
	v_u_4.Visible = true
	v_u_4.ZIndex = 2
	v_u_4.BorderSizePixel = 0
	v_u_4.Parent = v_u_3
	v_u_4.ClipsDescendants = true
	v_u_4.Active = false
	p_u_1.deselected:Connect(function()
		-- upvalues: (copy) v_u_4, (copy) p_u_1
		v_u_4.ClipsDescendants = true
		task.delay(0.2, function()
			-- upvalues: (ref) p_u_1, (ref) v_u_4
			if p_u_1.isSelected then
				v_u_4.ClipsDescendants = false
			end
		end)
	end)
	local v_u_5 = game:GetService("GuiService")
	p_u_1:setBehaviour("IconButton", "BackgroundTransparency", function(p6)
		-- upvalues: (copy) v_u_5
		local v7 = p6 * v_u_5.PreferredTransparency
		if p6 == 1 then
			return p6
		else
			return v7
		end
	end)
	p_u_1.janitor:add(v_u_5:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		-- upvalues: (copy) p_u_1, (copy) v_u_4
		p_u_1:refreshAppearance(v_u_4, "BackgroundTransparency")
	end))
	local v8 = Instance.new("UICorner")
	v8:SetAttribute("Collective", "IconCorners")
	v8.Name = "UICorner"
	v8.Parent = v_u_4
	local v_u_9 = require(script.Parent.Menu)(p_u_1)
	local v_u_10 = v_u_9.MenuUIListLayout
	local v_u_11 = v_u_9.MenuGap
	v_u_9.Parent = v_u_4
	local v_u_12 = Instance.new("Frame")
	v_u_12.Name = "IconSpot"
	v_u_12.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
	v_u_12.BackgroundTransparency = 0.9
	v_u_12.Visible = true
	v_u_12.AnchorPoint = Vector2.new(0, 0.5)
	v_u_12.ZIndex = 5
	v_u_12.Parent = v_u_9
	v8:Clone().Parent = v_u_12
	local v13 = v_u_12:Clone()
	v13.UICorner.Name = "OverlayUICorner"
	v13.Name = "IconOverlay"
	v13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	v13.ZIndex = v_u_12.ZIndex + 1
	v13.Size = UDim2.new(1, 0, 1, 0)
	v13.Position = UDim2.new(0, 0, 0, 0)
	v13.AnchorPoint = Vector2.new(0, 0)
	v13.Visible = false
	v13.Parent = v_u_12
	local v_u_14 = Instance.new("TextButton")
	v_u_14:SetAttribute("CorrespondingIconUID", p_u_1.UID)
	v_u_14.Name = "ClickRegion"
	v_u_14.BackgroundTransparency = 1
	v_u_14.Visible = true
	v_u_14.Text = ""
	v_u_14.ZIndex = 20
	v_u_14.Selectable = true
	v_u_14.SelectionGroup = true
	v_u_14.Parent = v_u_12
	require(script.Parent.Parent.Features.Gamepad).registerButton(v_u_14)
	v8:Clone().Parent = v_u_14
	local v_u_15 = Instance.new("Frame")
	v_u_15.Name = "Contents"
	v_u_15.BackgroundTransparency = 1
	v_u_15.Size = UDim2.fromScale(1, 1)
	v_u_15.Parent = v_u_12
	local v_u_16 = Instance.new("UIListLayout")
	v_u_16.Name = "ContentsList"
	v_u_16.FillDirection = Enum.FillDirection.Horizontal
	v_u_16.VerticalAlignment = Enum.VerticalAlignment.Center
	v_u_16.SortOrder = Enum.SortOrder.LayoutOrder
	v_u_16.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
	v_u_16.Padding = UDim.new(0, 3)
	v_u_16.Parent = v_u_15
	local v_u_17 = Instance.new("Frame")
	v_u_17.Name = "PaddingLeft"
	v_u_17.LayoutOrder = 1
	v_u_17.ZIndex = 5
	v_u_17.BorderColor3 = Color3.fromRGB(0, 0, 0)
	v_u_17.BackgroundTransparency = 1
	v_u_17.BorderSizePixel = 0
	v_u_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	v_u_17.Parent = v_u_15
	local v_u_18 = Instance.new("Frame")
	v_u_18.Name = "PaddingCenter"
	v_u_18.LayoutOrder = 3
	v_u_18.ZIndex = 5
	v_u_18.Size = UDim2.new(0, 0, 1, 0)
	v_u_18.BorderColor3 = Color3.fromRGB(0, 0, 0)
	v_u_18.BackgroundTransparency = 1
	v_u_18.BorderSizePixel = 0
	v_u_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	v_u_18.Parent = v_u_15
	local v_u_19 = Instance.new("Frame")
	v_u_19.Name = "PaddingRight"
	v_u_19.LayoutOrder = 5
	v_u_19.ZIndex = 5
	v_u_19.BorderColor3 = Color3.fromRGB(0, 0, 0)
	v_u_19.BackgroundTransparency = 1
	v_u_19.BorderSizePixel = 0
	v_u_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	v_u_19.Parent = v_u_15
	local v_u_20 = Instance.new("Frame")
	v_u_20.Name = "IconLabelContainer"
	v_u_20.LayoutOrder = 4
	v_u_20.ZIndex = 3
	v_u_20.AnchorPoint = Vector2.new(0, 0.5)
	v_u_20.Size = UDim2.new(0, 0, 0.5, 0)
	v_u_20.BackgroundTransparency = 1
	v_u_20.Position = UDim2.new(0.5, 0, 0.5, 0)
	v_u_20.Parent = v_u_15
	local v_u_21 = Instance.new("TextLabel")
	local v_u_22 = workspace.CurrentCamera.ViewportSize.X + 200
	v_u_21.Name = "IconLabel"
	v_u_21.LayoutOrder = 4
	v_u_21.ZIndex = 15
	v_u_21.AnchorPoint = Vector2.new(0, 0)
	v_u_21.Size = UDim2.new(0, v_u_22, 1, 0)
	v_u_21.ClipsDescendants = false
	v_u_21.BackgroundTransparency = 1
	v_u_21.Position = UDim2.fromScale(0, 0)
	v_u_21.RichText = true
	v_u_21.TextColor3 = Color3.fromRGB(255, 255, 255)
	v_u_21.TextXAlignment = Enum.TextXAlignment.Left
	v_u_21.Text = ""
	v_u_21.TextWrapped = true
	v_u_21.TextWrap = true
	v_u_21.TextScaled = false
	v_u_21.Active = false
	v_u_21.AutoLocalize = true
	v_u_21.Parent = v_u_20
	local v_u_23 = Instance.new("ImageLabel")
	v_u_23.Name = "IconImage"
	v_u_23.LayoutOrder = 2
	v_u_23.ZIndex = 15
	v_u_23.AnchorPoint = Vector2.new(0, 0.5)
	v_u_23.Size = UDim2.new(0, 0, 0.5, 0)
	v_u_23.BackgroundTransparency = 1
	v_u_23.Position = UDim2.new(0, 11, 0.5, 0)
	v_u_23.ScaleType = Enum.ScaleType.Stretch
	v_u_23.Active = false
	v_u_23.Parent = v_u_15
	local v24 = v8:Clone()
	v24:SetAttribute("Collective", nil)
	v24.CornerRadius = UDim.new(0, 0)
	v24.Name = "IconImageCorner"
	v24.Parent = v_u_23
	local v_u_25 = game:GetService("TweenService")
	local v_u_26 = 0
	local function v64(_)
		-- upvalues: (copy) p_u_1, (copy) v_u_21, (copy) v_u_23, (copy) v_u_20, (copy) v_u_17, (copy) v_u_18, (copy) v_u_19, (copy) v_u_4, (copy) v_u_16, (copy) v_u_15, (copy) v_u_3, (copy) v_u_22, (copy) v_u_9, (copy) v_u_12, (copy) v_u_10, (copy) v_u_11, (copy) v_u_25, (copy) v_u_14, (ref) v_u_26, (copy) p_u_2
		task.defer(function()
			-- upvalues: (ref) p_u_1, (ref) v_u_21, (ref) v_u_23, (ref) v_u_20, (ref) v_u_17, (ref) v_u_18, (ref) v_u_19, (ref) v_u_4, (ref) v_u_16, (ref) v_u_15, (ref) v_u_3, (ref) v_u_22, (ref) v_u_9, (ref) v_u_12, (ref) v_u_10, (ref) v_u_11, (ref) v_u_25, (ref) v_u_14, (ref) v_u_26, (ref) p_u_2
			local v27 = p_u_1.indicator
			if v27 then
				v27 = v27.Visible
			end
			local v28 = v27 or v_u_21.Text ~= ""
			local v29
			if v_u_23.Image == "" then
				v29 = false
			else
				v29 = v_u_23.Image ~= nil
			end
			local _ = Enum.HorizontalAlignment.Center
			local v30 = UDim2.fromScale(1, 1)
			if v29 and not v28 then
				v_u_20.Visible = false
				v_u_23.Visible = true
				v_u_17.Visible = false
				v_u_18.Visible = false
				v_u_19.Visible = false
			elseif v29 or not v28 then
				if v29 and v28 then
					v_u_20.Visible = true
					v_u_23.Visible = true
					v_u_17.Visible = true
					v_u_18.Visible = not v27
					v_u_19.Visible = not v27
					local _ = Enum.HorizontalAlignment.Left
				end
			else
				v_u_20.Visible = true
				v_u_23.Visible = false
				v_u_17.Visible = true
				v_u_18.Visible = false
				v_u_19.Visible = true
			end
			v_u_4.Size = v30
			local v31 = v_u_16.Padding.Offset
			local v32 = v_u_21.TextBounds.X
			v_u_20.Size = UDim2.new(0, v32, v_u_21.Size.Y.Scale, 0)
			local v33 = v31
			for _, v34 in pairs(v_u_15:GetChildren()) do
				if v34:IsA("GuiObject") and v34.Visible == true then
					v33 = v33 + ((v34:GetAttribute("TargetWidth") or v34.AbsoluteSize.X) + v31)
				end
			end
			local v35 = v_u_3:GetAttribute("MinimumWidth")
			local v36 = v_u_3:GetAttribute("MinimumHeight")
			local v37 = v_u_3:GetAttribute("BorderSize")
			local v38 = v_u_22
			local v39 = math.clamp(v33, v35, v38)
			local v40 = 0
			local v41 = #p_u_1.menuIcons > 0
			if v41 then
				v41 = p_u_1.isSelected
			end
			if v41 then
				for _, v42 in pairs(v_u_9:GetChildren()) do
					if v42 ~= v_u_12 and (v42:IsA("GuiObject") and v42.Visible) then
						v40 = v40 + ((v42:GetAttribute("TargetWidth") or v42.AbsoluteSize.X) + v_u_10.Padding.Offset)
					end
				end
				if not v_u_12.Visible then
					local v43 = v_u_12
					v39 = v39 - ((v43:GetAttribute("TargetWidth") or v43.AbsoluteSize.X) + v_u_10.Padding.Offset * 2 + v37)
				end
				v40 = v40 - v37 * 0.5
				v39 = v39 + (v40 - v37 * 0.75)
			end
			local v44 = v_u_11
			if v41 then
				v41 = v_u_12.Visible
			end
			v44.Visible = v41
			local v45 = v_u_3:GetAttribute("DesiredWidth")
			if v45 then
				if v39 >= v45 then
					v45 = v39
				end
			else
				v45 = v39
			end
			p_u_1.updateMenu:Fire()
			local v46 = v45 - v40
			local v47 = math.max(v46, v35) - v37 * 2
			local v48 = v_u_9:GetAttribute("MenuWidth")
			if v48 then
				v48 = v48 + v47 + v_u_10.Padding.Offset + 10
			end
			if v48 then
				local v49 = v_u_9:GetAttribute("MaxWidth")
				if v49 then
					v48 = math.max(v49, v35)
				end
				v_u_9:SetAttribute("MenuCanvasWidth", v45)
				if v48 >= v45 then
					v48 = v45
				end
			else
				v48 = v45
			end
			local v50 = Enum.EasingStyle.Quint
			local v51 = Enum.EasingDirection.Out
			local v52 = v_u_12
			local v53 = v52:GetAttribute("TargetWidth") or v52.AbsoluteSize.X
			local v54 = v_u_12.AbsoluteSize.X
			local v55 = math.max(v47, v53, v54)
			local v56 = v_u_3
			local v57 = v56:GetAttribute("TargetWidth") or v56.AbsoluteSize.X
			local v58 = v_u_3.AbsoluteSize.X
			local v59 = math.max(v48, v57, v58)
			local v60 = TweenInfo.new(v55 / 750, v50, v51)
			local v61 = TweenInfo.new(v59 / 750, v50, v51)
			v_u_25:Create(v_u_12, v60, {
				["Position"] = UDim2.new(0, v37, 0.5, 0),
				["Size"] = UDim2.new(0, v47, 1, -v37 * 2)
			}):Play()
			v_u_25:Create(v_u_14, v60, {
				["Size"] = UDim2.new(0, v47, 1, 0)
			}):Play()
			local v62 = UDim2.fromOffset(v48, v36)
			if v_u_3.Size.Y.Offset ~= v36 then
				v_u_3.Size = v62
			end
			v_u_3:SetAttribute("TargetWidth", v62.X.Offset)
			v_u_25:Create(v_u_3, v61, {
				["Size"] = v62
			}):Play()
			v_u_26 = v_u_26 + 1
			for v63 = 1, v61.Time * 100 do
				task.delay(v63 / 100, function()
					-- upvalues: (ref) p_u_2, (ref) p_u_1
					p_u_2.iconChanged:Fire(p_u_1)
				end)
			end
			task.delay(v61.Time - 0.2, function()
				-- upvalues: (ref) v_u_26, (ref) p_u_1
				v_u_26 = v_u_26 - 1
				task.defer(function()
					-- upvalues: (ref) v_u_26, (ref) p_u_1
					if v_u_26 == 0 then
						p_u_1.resizingComplete:Fire()
					end
				end)
			end)
			p_u_1:updateParent()
		end)
	end
	local v_u_65 = require(script.Parent.Parent.Utility).createStagger(0.01, v64)
	local v_u_66 = true
	p_u_1:setBehaviour("IconLabel", "Text", v_u_65)
	p_u_1:setBehaviour("IconLabel", "FontFace", function(p67)
		-- upvalues: (copy) v_u_21, (copy) v_u_65, (ref) v_u_66
		if v_u_21.FontFace ~= p67 then
			task.spawn(function()
				-- upvalues: (ref) v_u_65, (ref) v_u_66
				v_u_65()
				if v_u_66 then
					v_u_66 = false
					for _ = 1, 10 do
						task.wait(1)
						v_u_65()
					end
				end
			end)
		end
	end)
	local function v71()
		-- upvalues: (copy) v_u_3, (copy) p_u_1, (copy) v_u_12, (copy) v_u_9, (copy) v_u_11, (copy) v_u_10, (copy) v_u_65
		task.defer(function()
			-- upvalues: (ref) v_u_3, (ref) p_u_1, (ref) v_u_12, (ref) v_u_9, (ref) v_u_11, (ref) v_u_10, (ref) v_u_65
			local v68 = v_u_3:GetAttribute("BorderSize")
			local v69 = p_u_1.alignment
			local v70
			if v_u_12.Visible == false then
				v70 = 0
			elseif v69 == "Right" then
				v70 = -v68 or v68
			else
				v70 = v68
			end
			v_u_9.Position = UDim2.new(0, v70, 0, 0)
			v_u_11.Size = UDim2.fromOffset(v68, 0)
			v_u_10.Padding = UDim.new(0, 0)
			v_u_65()
		end)
	end
	p_u_1:setBehaviour("Widget", "BorderSize", v71)
	p_u_1:setBehaviour("IconSpot", "Visible", v71)
	p_u_1.startMenuUpdate:Connect(v_u_65)
	p_u_1.updateSize:Connect(v_u_65)
	p_u_1:setBehaviour("ContentsList", "HorizontalAlignment", v_u_65)
	p_u_1:setBehaviour("Widget", "Visible", v_u_65)
	p_u_1:setBehaviour("Widget", "DesiredWidth", v_u_65)
	p_u_1:setBehaviour("Widget", "MinimumWidth", v_u_65)
	p_u_1:setBehaviour("Widget", "MinimumHeight", v_u_65)
	p_u_1:setBehaviour("Indicator", "Visible", v_u_65)
	p_u_1:setBehaviour("IconImageRatio", "AspectRatio", v_u_65)
	p_u_1:setBehaviour("IconImage", "Image", function(p72)
		-- upvalues: (copy) v_u_23, (copy) v_u_65
		local v73 = tonumber(p72) and "http://www.roblox.com/asset/?id=" .. p72 or (p72 or "")
		if v_u_23.Image ~= v73 then
			v_u_65()
		end
		return v73
	end)
	p_u_1.alignmentChanged:Connect(function(p74)
		-- upvalues: (copy) v_u_10, (copy) v_u_3, (copy) p_u_1, (copy) v_u_12, (copy) v_u_9, (copy) v_u_11, (copy) v_u_65
		local v75 = p74 == "Center" and "Left" or p74
		v_u_10.HorizontalAlignment = Enum.HorizontalAlignment[v75]
		task.defer(function()
			-- upvalues: (ref) v_u_3, (ref) p_u_1, (ref) v_u_12, (ref) v_u_9, (ref) v_u_11, (ref) v_u_10, (ref) v_u_65
			local v76 = v_u_3:GetAttribute("BorderSize")
			local v77 = p_u_1.alignment
			local v78
			if v_u_12.Visible == false then
				v78 = 0
			elseif v77 == "Right" then
				v78 = -v76 or v76
			else
				v78 = v76
			end
			v_u_9.Position = UDim2.new(0, v78, 0, 0)
			v_u_11.Size = UDim2.fromOffset(v76, 0)
			v_u_10.Padding = UDim.new(0, 0)
			v_u_65()
		end)
	end)
	local v_u_79 = game:GetService("Players").LocalPlayer
	local v_u_80 = v_u_79.LocaleId
	p_u_1.janitor:add(v_u_79:GetPropertyChangedSignal("LocaleId"):Connect(function()
		-- upvalues: (copy) v_u_79, (ref) v_u_80, (copy) p_u_1
		task.delay(0.2, function()
			-- upvalues: (ref) v_u_79, (ref) v_u_80, (ref) p_u_1
			local v81 = v_u_79.LocaleId
			if v81 ~= v_u_80 then
				v_u_80 = v81
				p_u_1:refresh()
				task.wait(0.5)
				p_u_1:refresh()
			end
		end)
	end))
	local v_u_82 = Instance.new("NumberValue")
	v_u_82.Name = "IconImageScale"
	v_u_82.Parent = v_u_23
	v_u_82:GetPropertyChangedSignal("Value"):Connect(function()
		-- upvalues: (copy) v_u_23, (copy) v_u_82
		v_u_23.Size = UDim2.new(v_u_82.Value, 0, v_u_82.Value, 0)
	end)
	local v83 = Instance.new("UIAspectRatioConstraint")
	v83.Name = "IconImageRatio"
	v83.AspectType = Enum.AspectType.FitWithinMaxSize
	v83.DominantAxis = Enum.DominantAxis.Height
	v83.Parent = v_u_23
	local v84 = Instance.new("UIGradient")
	v84.Name = "IconGradient"
	v84.Enabled = true
	v84.Parent = v_u_4
	local v85 = Instance.new("UIGradient")
	v85.Name = "IconSpotGradient"
	v85.Enabled = true
	v85.Parent = v_u_12
	return v_u_3
end