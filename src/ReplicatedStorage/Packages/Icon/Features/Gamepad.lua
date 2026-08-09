-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = game:GetService("GamepadService")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = Enum.KeyCode.DPadUp
local v_u_5 = Enum.PreferredInput.Gamepad
local v_u_6 = {}
local v_u_7 = nil
function v_u_6.start(p8)
	-- upvalues: (ref) v_u_7, (copy) v_u_4, (copy) v_u_3, (copy) v_u_2, (copy) v_u_5, (copy) v_u_6, (copy) v_u_1
	v_u_7 = p8
	local v9 = v_u_7
	local v10
	if v_u_7.highlightKey == nil then
		v10 = v_u_4
	else
		v10 = v_u_7.highlightKey
	end
	v9.highlightKey = v10
	v_u_7.highlightIcon = false
	task.delay(1, function()
		-- upvalues: (ref) v_u_7, (ref) v_u_3, (ref) v_u_4, (ref) v_u_2, (ref) v_u_5, (ref) v_u_6, (ref) v_u_1
		local v_u_11 = v_u_7.iconsDictionary
		local v_u_12 = nil
		local v_u_13 = v_u_4 ~= v_u_7.highlightKey
		local v_u_14 = v_u_4 ~= v_u_7.highlightKey
		local v_u_15 = require(script.Parent.Parent.Elements.Selection)
		local function v_u_22()
			-- upvalues: (ref) v_u_3, (copy) v_u_11, (ref) v_u_2, (ref) v_u_5, (copy) v_u_15, (ref) v_u_7, (ref) v_u_12, (ref) v_u_14, (ref) v_u_13, (ref) v_u_6
			local v16 = v_u_3.SelectedObject
			if v16 then
				v16 = v16:GetAttribute("CorrespondingIconUID")
			end
			if v16 then
				v16 = v_u_11[v16]
			end
			local v17 = v_u_2.PreferredInput == v_u_5
			if v16 then
				if v17 then
					local v18 = v16:getInstance("ClickRegion")
					local v19 = v16.selection
					if not v19 then
						v19 = v16.janitor:add(v_u_15(v_u_7))
						v19:SetAttribute("IgnoreVisibilityUpdater", true)
						v19.Parent = v16.widget
						v16.selection = v19
						v16:refreshAppearance(v19)
					end
					v18.SelectionImageObject = v19.Selection
				end
				if v_u_12 and v_u_12 ~= v16 then
					v_u_12:setIndicator()
				end
				local v20
				if v17 and not (v_u_14 or v16.parentIconUID) then
					v20 = Enum.KeyCode.ButtonB
				else
					v20 = nil
				end
				v_u_12 = v16
				v_u_7.lastHighlightedIcon = v16
				v16:setIndicator(v20)
			else
				local v21
				if v17 and not v_u_13 then
					v21 = v_u_7.highlightKey
				else
					v21 = nil
				end
				if not v_u_12 then
					v_u_12 = v_u_6.getIconToHighlight()
				end
				if v21 == v_u_7.highlightKey then
					v_u_13 = true
				end
				if v_u_12 then
					v_u_12:setIndicator(v21)
				end
			end
		end
		v_u_3:GetPropertyChangedSignal("SelectedObject"):Connect(v_u_22)
		local function v23()
			-- upvalues: (ref) v_u_2, (ref) v_u_5, (ref) v_u_13, (ref) v_u_14, (copy) v_u_22
			if v_u_2.PreferredInput ~= v_u_5 then
				v_u_13 = false
				v_u_14 = false
			end
			v_u_22()
		end
		v_u_2:GetPropertyChangedSignal("PreferredInput"):Connect(v23)
		if v_u_2.PreferredInput ~= v_u_5 then
			local _ = false
			v_u_14 = false
		end
		v_u_22()
		v_u_2.InputBegan:Connect(function(p24, _)
			-- upvalues: (ref) v_u_3, (copy) v_u_11, (ref) v_u_7, (ref) v_u_6, (ref) v_u_1
			if p24.UserInputType == Enum.UserInputType.MouseButton1 then
				local v25 = v_u_3.SelectedObject
				if v25 then
					v25 = v25:GetAttribute("CorrespondingIconUID")
				end
				if v25 then
					v25 = v_u_11[v25]
				end
				if v25 then
					v_u_3.SelectedObject = nil
				end
				return
			elseif p24.KeyCode == v_u_7.highlightKey then
				local v26 = v_u_6.getIconToHighlight()
				if v26 then
					if v_u_1.GamepadCursorEnabled then
						task.wait(0.2)
						v_u_1:DisableGamepadCursor()
					end
					v_u_3.SelectedObject = v26:getInstance("ClickRegion")
				end
			end
		end)
	end)
end
function v_u_6.getIconToHighlight()
	-- upvalues: (ref) v_u_7
	local v27 = v_u_7.iconsDictionary
	local v28 = v_u_7.highlightIcon or v_u_7.lastHighlightedIcon
	if not v28 then
		local v29 = nil
		for _, v30 in pairs(v27) do
			if not v30.parentIconUID and (not v29 or v30.widget.AbsolutePosition.X < v29) then
				v29 = v30.widget.AbsolutePosition.X
				v28 = v30
			end
		end
	end
	return v28
end
function v_u_6.registerButton(p_u_31)
	-- upvalues: (copy) v_u_2, (copy) v_u_1, (copy) v_u_3
	local v_u_32 = false
	p_u_31.InputBegan:Connect(function(_)
		-- upvalues: (ref) v_u_32
		v_u_32 = true
		task.wait()
		task.wait()
		v_u_32 = false
	end)
	local v_u_36 = v_u_2.InputBegan:Connect(function(p33)
		-- upvalues: (ref) v_u_32, (ref) v_u_1, (ref) v_u_3, (copy) p_u_31
		task.wait()
		if p33.KeyCode == Enum.KeyCode.ButtonA and v_u_32 then
			task.wait(0.2)
			v_u_1:DisableGamepadCursor()
			v_u_3.SelectedObject = p_u_31
		else
			local v34 = v_u_3.SelectedObject == p_u_31
			local v35 = p33.KeyCode.Name
			if table.find({ "ButtonB", "ButtonSelect" }, v35) and (v34 and (v35 ~= "ButtonSelect" or v_u_1.GamepadCursorEnabled)) then
				v_u_3.SelectedObject = nil
			end
		end
	end)
	p_u_31.Destroying:Once(function()
		-- upvalues: (copy) v_u_36
		v_u_36:Disconnect()
	end)
end
return v_u_6