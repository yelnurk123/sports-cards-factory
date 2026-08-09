-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = Color3.fromRGB(39, 41, 48)
return function(p_u_2)
	-- upvalues: (copy) v_u_1
	local v_u_3 = p_u_2:getInstance("ClickRegion")
	local v_u_4 = Instance.new("CanvasGroup")
	v_u_4.Name = "Caption"
	v_u_4.AnchorPoint = Vector2.new(0.5, 0)
	v_u_4.BackgroundTransparency = 1
	v_u_4.BorderSizePixel = 0
	v_u_4.GroupTransparency = 1
	v_u_4.Position = UDim2.fromOffset(0, 0)
	v_u_4.Visible = true
	v_u_4.ZIndex = 30
	v_u_4.Parent = v_u_3
	local v_u_5 = Instance.new("Frame")
	v_u_5.Name = "Box"
	v_u_5.AutomaticSize = Enum.AutomaticSize.XY
	v_u_5.BackgroundColor3 = v_u_1
	v_u_5.Position = UDim2.fromOffset(4, 7)
	v_u_5.ZIndex = 12
	v_u_5.Parent = v_u_4
	local v6 = Instance.new("TextLabel")
	v6.Name = "Header"
	v6.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	v6.Text = "Caption"
	v6.TextColor3 = Color3.fromRGB(255, 255, 255)
	v6.TextSize = 15
	v6.TextTruncate = Enum.TextTruncate.None
	v6.TextWrapped = false
	v6.TextXAlignment = Enum.TextXAlignment.Left
	v6.AutomaticSize = Enum.AutomaticSize.X
	v6.BackgroundTransparency = 1
	v6.LayoutOrder = 1
	v6.Size = UDim2.fromOffset(0, 16)
	v6.ZIndex = 18
	v6.Parent = v_u_5
	local v7 = Instance.new("UIListLayout")
	v7.Name = "Layout"
	v7.Padding = UDim.new(0, 8)
	v7.SortOrder = Enum.SortOrder.LayoutOrder
	v7.Parent = v_u_5
	local v8 = Instance.new("UICorner")
	v8.Name = "CaptionCorner"
	v8.Parent = v_u_5
	local v9 = Instance.new("UIPadding")
	v9.Name = "Padding"
	v9.PaddingBottom = UDim.new(0, 12)
	v9.PaddingLeft = UDim.new(0, 12)
	v9.PaddingRight = UDim.new(0, 12)
	v9.PaddingTop = UDim.new(0, 12)
	v9.Parent = v_u_5
	local v_u_10 = Instance.new("Frame")
	v_u_10.Name = "Hotkeys"
	v_u_10.AutomaticSize = Enum.AutomaticSize.Y
	v_u_10.BackgroundTransparency = 1
	v_u_10.LayoutOrder = 3
	v_u_10.Size = UDim2.fromScale(1, 0)
	v_u_10.Visible = false
	v_u_10.Parent = v_u_5
	local v11 = Instance.new("UIListLayout")
	v11.Name = "Layout1"
	v11.Padding = UDim.new(0, 6)
	v11.FillDirection = Enum.FillDirection.Vertical
	v11.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v11.HorizontalFlex = Enum.UIFlexAlignment.None
	v11.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	v11.VerticalFlex = Enum.UIFlexAlignment.None
	v11.SortOrder = Enum.SortOrder.LayoutOrder
	v11.Parent = v_u_10
	local v12 = Instance.new("ImageLabel")
	v12.Name = "Key1"
	v12.Image = "rbxasset://textures/ui/Controls/key_single.png"
	v12.ImageTransparency = 0.7
	v12.ScaleType = Enum.ScaleType.Slice
	v12.SliceCenter = Rect.new(5, 5, 23, 24)
	v12.AutomaticSize = Enum.AutomaticSize.X
	v12.BackgroundTransparency = 1
	v12.LayoutOrder = 1
	v12.Size = UDim2.fromOffset(0, 30)
	v12.ZIndex = 15
	v12.Parent = v_u_10
	local v13 = Instance.new("UIPadding")
	v13.Name = "Inset"
	v13.PaddingLeft = UDim.new(0, 8)
	v13.PaddingRight = UDim.new(0, 8)
	v13.Parent = v12
	local v_u_14 = Instance.new("TextLabel")
	v_u_14.AutoLocalize = false
	v_u_14.Name = "LabelContent"
	v_u_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	v_u_14.Text = ""
	v_u_14.TextColor3 = Color3.fromRGB(189, 190, 190)
	v_u_14.TextSize = 15
	v_u_14.AutomaticSize = Enum.AutomaticSize.X
	v_u_14.BackgroundTransparency = 1
	v_u_14.Position = UDim2.fromOffset(0, -1)
	v_u_14.Size = UDim2.fromScale(1, 1)
	v_u_14.ZIndex = 16
	v_u_14.Parent = v12
	local v_u_15 = Instance.new("ImageLabel")
	v_u_15.Name = "Caret"
	v_u_15.Image = "rbxassetid://101906294438076"
	v_u_15.ImageColor3 = v_u_1
	v_u_15.AnchorPoint = Vector2.new(0, 0.5)
	v_u_15.BackgroundTransparency = 1
	v_u_15.Position = UDim2.new(0, 0, 0, 4)
	v_u_15.Size = UDim2.fromOffset(16, 8)
	v_u_15.ZIndex = 12
	v_u_15.Parent = v_u_4
	local v_u_16 = Instance.new("ImageLabel")
	v_u_16.Visible = true
	v_u_16.Name = "DropShadow"
	v_u_16.Image = "rbxassetid://124920646932671"
	v_u_16.ImageColor3 = Color3.fromRGB(0, 0, 0)
	v_u_16.ImageTransparency = 0.45
	v_u_16.ScaleType = Enum.ScaleType.Slice
	v_u_16.SliceCenter = Rect.new(12, 12, 13, 13)
	v_u_16.BackgroundTransparency = 1
	v_u_16.Position = UDim2.fromOffset(0, 5)
	v_u_16.Size = UDim2.new(1, 0, 0, 48)
	v_u_16.Parent = v_u_4
	v_u_5:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		-- upvalues: (copy) v_u_16, (copy) v_u_5
		v_u_16.Size = UDim2.new(1, 0, 0, v_u_5.AbsoluteSize.Y + 8)
	end)
	local v17 = p_u_2.captionJanitor
	local _, v_u_18 = p_u_2:clipOutside(v_u_4)
	v_u_18.AutomaticSize = Enum.AutomaticSize.None
	v17:add(v_u_4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		-- upvalues: (copy) v_u_4, (copy) v_u_18
		local v19 = v_u_4.AbsoluteSize
		v_u_18.Size = UDim2.fromOffset(v19.X, v19.Y)
	end))
	local v20 = v_u_4.AbsoluteSize
	v_u_18.Size = UDim2.fromOffset(v20.X, v20.Y)
	local v_u_21 = false
	local v_u_22 = v_u_4.Box.Header
	local v_u_23 = game:GetService("UserInputService")
	local function v28(p24)
		-- upvalues: (copy) v_u_23, (copy) v_u_4, (copy) p_u_2, (copy) v_u_22, (copy) v_u_14, (copy) v_u_10
		local v25 = v_u_23.KeyboardEnabled
		local v26 = v_u_4:GetAttribute("CaptionText") or ""
		local v27 = v26 == "_hotkey_"
		if v25 or not v27 then
			v_u_22.Text = v26
			v_u_22.Visible = not v27
			if p24 then
				v_u_14.Text = p24.Name
				v_u_10.Visible = true
			end
			if not v25 then
				v_u_10.Visible = false
			end
		else
			p_u_2:setCaption()
		end
	end
	v_u_4:GetAttributeChangedSignal("CaptionText"):Connect(v28)
	local v29 = Enum.EasingStyle.Quad
	local v_u_30 = TweenInfo.new(0.2, v29, Enum.EasingDirection.In)
	local v_u_31 = TweenInfo.new(0.2, v29, Enum.EasingDirection.Out)
	local v_u_32 = game:GetService("TweenService")
	local v_u_33 = game:GetService("RunService")
	local function v_u_48(p34)
		-- upvalues: (ref) v_u_21, (copy) v_u_15, (copy) v_u_4, (copy) v_u_3, (copy) v_u_18, (copy) v_u_30, (copy) v_u_31, (copy) v_u_32, (copy) v_u_33
		if v_u_21 then
			if p34 == nil then
				p34 = v_u_21
			end
			local v35 = not p34
			if v35 == nil then
				v35 = v_u_21
			end
			local v36 = UDim2.new(0.5, 0, 1, v35 and 10 or 2)
			local v37
			if p34 == nil then
				v37 = v_u_21
			else
				v37 = p34
			end
			local v38 = UDim2.new(0.5, 0, 1, v37 and 10 or 2)
			if p34 then
				local v39 = v_u_15.Position.Y.Offset
				v_u_15.Position = UDim2.fromOffset(0, v39)
				v_u_4.AutomaticSize = Enum.AutomaticSize.XY
				v_u_4.Size = UDim2.fromOffset(32, 53)
			else
				local v40 = v_u_4.AbsoluteSize
				v_u_4.AutomaticSize = Enum.AutomaticSize.Y
				v_u_4.Size = UDim2.fromOffset(v40.X, v40.Y)
			end
			local v_u_41 = nil
			local function v45()
				-- upvalues: (ref) v_u_3, (ref) v_u_4, (ref) v_u_15, (ref) v_u_41
				local v42 = v_u_3.AbsolutePosition.X - v_u_4.AbsolutePosition.X + v_u_3.AbsoluteSize.X / 2 - v_u_15.AbsoluteSize.X / 2
				local v43 = v_u_15.Position.Y.Offset
				local v44 = UDim2.fromOffset(v42, v43)
				if v_u_41 ~= v42 then
					v_u_41 = v42
					v_u_15.Position = UDim2.fromOffset(0, v43)
					task.wait()
				end
				v_u_15.Position = v44
			end
			v_u_18.Position = v36
			v45()
			local v46 = v_u_32:Create(v_u_18, p34 and v_u_30 or v_u_31, {
				["Position"] = v38
			})
			local v_u_47 = v_u_33.Heartbeat:Connect(v45)
			v46:Play()
			v46.Completed:Once(function()
				-- upvalues: (copy) v_u_47
				v_u_47:Disconnect()
			end)
		end
	end
	v17:add(v_u_3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		-- upvalues: (copy) v_u_48
		v_u_48()
	end))
	v_u_48(false)
	v17:add(p_u_2.toggleKeyAdded:Connect(v28))
	for v49, _ in pairs(p_u_2.bindedToggleKeys) do
		local v50 = v_u_23.KeyboardEnabled
		local v51 = v_u_4:GetAttribute("CaptionText") or ""
		local v52 = v51 == "_hotkey_"
		if v50 or not v52 then
			v_u_22.Text = v51
			v_u_22.Visible = not v52
			if v49 then
				v_u_14.Text = v49.Name
				v_u_10.Visible = true
			end
			if not v50 then
				v_u_10.Visible = false
			end
		else
			p_u_2:setCaption()
		end
		break
	end
	v17:add(p_u_2.fakeToggleKeyChanged:Connect(v28))
	local v53 = p_u_2.fakeToggleKey
	if v53 then
		local v54 = v_u_23.KeyboardEnabled
		local v55 = v_u_4:GetAttribute("CaptionText") or ""
		local v56 = v55 == "_hotkey_"
		if v54 or not v56 then
			v_u_22.Text = v55
			v_u_22.Visible = not v56
			if v53 then
				v_u_14.Text = v53.Name
				v_u_10.Visible = true
			end
			if not v54 then
				v_u_10.Visible = false
			end
		else
			p_u_2:setCaption()
		end
	end
	local function v_u_62(p57)
		-- upvalues: (ref) v_u_21, (copy) p_u_2, (copy) v_u_30, (copy) v_u_31, (copy) v_u_32, (copy) v_u_4, (copy) v_u_18, (copy) v_u_48, (copy) v_u_23, (copy) v_u_22, (copy) v_u_10
		if v_u_21 == p57 then
			return
		else
			local v58 = p_u_2.joinedFrame
			if v58 and string.match(v58.Name, "Dropdown") then
				p57 = false
			end
			v_u_21 = p57
			v_u_32:Create(v_u_4, p57 and v_u_30 or v_u_31, {
				["GroupTransparency"] = p57 and 0 or 1
			}):Play()
			if p57 then
				v_u_18:SetAttribute("ForceUpdate", true)
			end
			v_u_48()
			local v59 = v_u_23.KeyboardEnabled
			local v60 = v_u_4:GetAttribute("CaptionText") or ""
			local v61 = v60 == "_hotkey_"
			if v59 or not v61 then
				v_u_22.Text = v60
				v_u_22.Visible = not v61
				if not v59 then
					v_u_10.Visible = false
				end
			else
				p_u_2:setCaption()
			end
		end
	end
	local v_u_63 = require(p_u_2.iconModule)
	v17:add(p_u_2.stateChanged:Connect(function(p64)
		-- upvalues: (copy) v_u_63, (copy) p_u_2, (copy) v_u_62
		if p64 == "Viewing" then
			local v65 = v_u_63.captionLastClosedClock
			local v66 = (v65 and os.clock() - v65 or 999) < 0.3 and 0 or 0.5
			task.delay(v66, function()
				-- upvalues: (ref) p_u_2, (ref) v_u_62
				if p_u_2.activeState == "Viewing" then
					v_u_62(true)
				end
			end)
		else
			v_u_63.captionLastClosedClock = os.clock()
			v_u_62(false)
		end
	end))
	return v_u_4
end