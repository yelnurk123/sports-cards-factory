-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = false
local v_u_2 = 0
return function(p_u_3)
	-- upvalues: (ref) v_u_1, (ref) v_u_2
	local v_u_4 = game:GetService("GuiService")
	local v_u_5 = game:GetService("Players")
	local v_u_6 = game:GetService("UserInputService")
	local v7 = {}
	local v_u_8 = require(script.Parent.Parent.Packages.GoodSignal).new()
	local v_u_9 = v_u_4:GetGuiInset()
	local v_u_10 = 0
	local v_u_11 = 0
	local v_u_12 = 0
	local v_u_13 = 0
	local v_u_14 = false
	local v_u_15 = false
	local function v_u_23(p16)
		-- upvalues: (copy) v_u_4, (ref) v_u_14, (ref) v_u_15, (copy) v_u_6, (copy) p_u_3, (ref) v_u_13, (copy) v_u_23, (copy) v_u_5, (ref) v_u_1, (ref) v_u_9, (ref) v_u_10, (ref) v_u_11, (ref) v_u_12, (copy) v_u_8, (ref) v_u_2
		local v17 = v_u_4.TopbarInset.Height
		local v18 = v17 <= 36
		v_u_14 = v_u_4:IsTenFootInterface()
		v_u_15 = v_u_6.VREnabled
		p_u_3.isOldTopbar = v18
		v_u_13 = v_u_13 + 1
		if v17 == 0 and p16 == nil then
			task.defer(function()
				-- upvalues: (ref) v_u_23
				task.wait(8)
				v_u_23("ForceConvertToOld")
			end)
		elseif v_u_13 == 1 then
			task.delay(5, function()
				-- upvalues: (ref) v_u_5, (ref) v_u_13, (ref) v_u_23
				v_u_5.LocalPlayer:WaitForChild("PlayerGui")
				if v_u_13 == 1 then
					v_u_23()
				end
			end)
		end
		if p_u_3.isOldTopbar and (not v_u_14 and (not v_u_15 and (v_u_1 == false and (v17 ~= 0 or p16 == "ForceConvertToOld")))) then
			v_u_1 = true
			task.defer(function()
				-- upvalues: (ref) p_u_3, (ref) v_u_4
				local v19 = script.Parent.Parent.Features.Themes
				local v20 = require(v19.Classic)
				p_u_3.modifyBaseTheme(v20)
				local function v21()
					-- upvalues: (ref) v_u_4, (ref) p_u_3
					if v_u_4.MenuIsOpen then
						p_u_3.setTopbarEnabled(false, true)
					else
						p_u_3.setTopbarEnabled()
					end
				end
				v_u_4:GetPropertyChangedSignal("MenuIsOpen"):Connect(v21)
				if v_u_4.MenuIsOpen then
					p_u_3.setTopbarEnabled(false, true)
				else
					p_u_3.setTopbarEnabled()
				end
			end)
		end
		v_u_9 = v_u_4:GetGuiInset()
		v_u_10 = v18 and 12 or v_u_9.Y - 50
		v_u_11 = v18 and 2 or 0
		v_u_12 = -2
		if v_u_14 then
			v_u_10 = 10
			v_u_11 = 0
		end
		if v_u_4.TopbarInset.Height == 0 and not v_u_1 then
			v_u_11 = v_u_11 + 13
			v_u_12 = 50
		end
		v_u_8:Fire(v_u_9)
		local v_u_22 = v_u_9.Y
		if v_u_22 ~= v_u_2 then
			v_u_2 = v_u_22
			task.defer(function()
				-- upvalues: (ref) p_u_3, (copy) v_u_22
				p_u_3.insetHeightChanged:Fire(v_u_22)
			end)
		end
	end
	v_u_4:GetPropertyChangedSignal("TopbarInset"):Connect(v_u_23)
	v_u_23("FirstTime")
	local v_u_24 = Instance.new("ScreenGui")
	v_u_8:Connect(function()
		-- upvalues: (copy) v_u_24, (ref) v_u_10
		v_u_24:SetAttribute("StartInset", v_u_10)
	end)
	v_u_24.Name = "TopbarStandard"
	v_u_24.Enabled = true
	v_u_24.DisplayOrder = p_u_3.baseDisplayOrder
	v_u_24.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	v_u_24.IgnoreGuiInset = true
	v_u_24.ResetOnSpawn = false
	v_u_24.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	v7[v_u_24.Name] = v_u_24
	p_u_3.baseDisplayOrderChanged:Connect(function()
		-- upvalues: (copy) v_u_24, (copy) p_u_3
		v_u_24.DisplayOrder = p_u_3.baseDisplayOrder
	end)
	local v_u_25 = Instance.new("Frame")
	v_u_25.Name = "Holders"
	v_u_25.BackgroundTransparency = 1
	v_u_8:Connect(function()
		-- upvalues: (ref) v_u_15, (ref) v_u_14, (ref) v_u_12, (copy) v_u_25, (ref) v_u_11
		local v26 = v_u_15 and 36 or 56
		local v27
		if v_u_14 then
			v27 = UDim2.new(1, 0, 0, v26)
		else
			v27 = UDim2.new(1, 0, 1, v_u_12)
		end
		v_u_25.Position = UDim2.new(0, 0, 0, v_u_11)
		v_u_25.Size = v27
	end)
	v_u_25.Visible = true
	v_u_25.ZIndex = 1
	v_u_25.Parent = v_u_24
	local v_u_28 = v_u_24:Clone()
	local v_u_29 = v_u_28.Holders
	local function v30()
		-- upvalues: (copy) v_u_29, (copy) v_u_4, (ref) v_u_12
		v_u_29.Size = UDim2.new(1, 0, 0, v_u_4.TopbarInset.Height + v_u_12)
	end
	v_u_28.Name = "TopbarCentered"
	v_u_28.DisplayOrder = p_u_3.baseDisplayOrder
	v_u_28.ScreenInsets = Enum.ScreenInsets.None
	p_u_3.baseDisplayOrderChanged:Connect(function()
		-- upvalues: (copy) v_u_28, (copy) p_u_3
		v_u_28.DisplayOrder = p_u_3.baseDisplayOrder
	end)
	v7[v_u_28.Name] = v_u_28
	v_u_8:Connect(v30)
	v_u_29.Size = UDim2.new(1, 0, 0, v_u_4.TopbarInset.Height + v_u_12)
	local v_u_31 = v_u_24:Clone()
	v_u_31.Name = v_u_31.Name .. "Clipped"
	v_u_31.DisplayOrder = p_u_3.baseDisplayOrder + 1
	p_u_3.baseDisplayOrderChanged:Connect(function()
		-- upvalues: (copy) v_u_31, (copy) p_u_3
		v_u_31.DisplayOrder = p_u_3.baseDisplayOrder + 1
	end)
	v7[v_u_31.Name] = v_u_31
	local v_u_32 = v_u_28:Clone()
	v_u_32.Name = v_u_32.Name .. "Clipped"
	v_u_32.DisplayOrder = p_u_3.baseDisplayOrder + 1
	p_u_3.baseDisplayOrderChanged:Connect(function()
		-- upvalues: (copy) v_u_32, (copy) p_u_3
		v_u_32.DisplayOrder = p_u_3.baseDisplayOrder + 1
	end)
	v7[v_u_32.Name] = v_u_32
	local v_u_33 = Instance.new("ScrollingFrame")
	v_u_33:SetAttribute("IsAHolder", true)
	v_u_33.Name = "Left"
	v_u_8:Connect(function()
		-- upvalues: (copy) v_u_33, (ref) v_u_10
		v_u_33.Position = UDim2.fromOffset(v_u_10, 0)
	end)
	v_u_33.Size = UDim2.new(1, -24, 1, 0)
	v_u_33.BackgroundTransparency = 1
	v_u_33.Visible = true
	v_u_33.ZIndex = 1
	v_u_33.Active = false
	v_u_33.ClipsDescendants = true
	v_u_33.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	v_u_33.CanvasSize = UDim2.new(0, 0, 1, -1)
	v_u_33.AutomaticCanvasSize = Enum.AutomaticSize.X
	v_u_33.ScrollingDirection = Enum.ScrollingDirection.X
	v_u_33.ScrollBarThickness = 0
	v_u_33.BorderSizePixel = 0
	v_u_33.Selectable = false
	v_u_33.ScrollingEnabled = false
	v_u_33.ElasticBehavior = Enum.ElasticBehavior.Never
	v_u_33.Parent = v_u_25
	local v_u_34 = Instance.new("UIListLayout")
	v_u_8:Connect(function()
		-- upvalues: (copy) v_u_34, (ref) v_u_10
		v_u_34.Padding = UDim.new(0, v_u_10)
	end)
	v_u_34.FillDirection = Enum.FillDirection.Horizontal
	v_u_34.SortOrder = Enum.SortOrder.LayoutOrder
	v_u_34.VerticalAlignment = Enum.VerticalAlignment.Bottom
	v_u_34.HorizontalAlignment = Enum.HorizontalAlignment.Left
	v_u_34.Parent = v_u_33
	local v_u_35 = v_u_33:Clone()
	v_u_8:Connect(function()
		-- upvalues: (copy) v_u_35, (ref) v_u_10
		v_u_35.UIListLayout.Padding = UDim.new(0, v_u_10)
	end)
	v_u_35.ScrollingEnabled = false
	v_u_35.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v_u_35.Name = "Center"
	v_u_35.Parent = v_u_29
	local v_u_36 = v_u_33:Clone()
	v_u_8:Connect(function()
		-- upvalues: (copy) v_u_36, (ref) v_u_10
		v_u_36.UIListLayout.Padding = UDim.new(0, v_u_10)
	end)
	v_u_36.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v_u_36.Name = "Right"
	v_u_36.AnchorPoint = Vector2.new(1, 0)
	v_u_36.Position = UDim2.new(1, -12, 0, 0)
	v_u_36.Parent = v_u_25
	v_u_8:Fire(v_u_9)
	return v7
end