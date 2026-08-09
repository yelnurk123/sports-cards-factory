-- Saved by Zyler Pro v2 (Join to Decompile in Highest Quality) https://discord.gg/uncopylocked

local v_u_1 = game:GetService("RunService").Heartbeat
local v_u_2 = newproxy(true)
getmetatable(v_u_2).__tostring = function()
	return "IndicesReference"
end
local v_u_3 = newproxy(true)
getmetatable(v_u_3).__tostring = function()
	return "LinkToInstanceIndex"
end
local v_u_4 = {
	["IGNORE_MEMORY_DEBUG"] = true,
	["ClassName"] = "Janitor",
	["__index"] = {
		["CurrentlyCleaning"] = true,
		[v_u_2] = nil
	}
}
local v_u_5 = {
	["function"] = true,
	["Promise"] = "cancel",
	["RBXScriptConnection"] = "Disconnect"
}
function v_u_4.new()
	-- upvalues: (copy) v_u_2, (copy) v_u_4
	local v6 = {
		["CurrentlyCleaning"] = false,
		[v_u_2] = nil
	}
	local v7 = v_u_4
	return setmetatable(v6, v7)
end
function v_u_4.Is(p8)
	-- upvalues: (copy) v_u_4
	local v9
	if type(p8) == "table" then
		v9 = getmetatable(p8) == v_u_4
	else
		v9 = false
	end
	return v9
end
v_u_4.is = v_u_4.Is
function v_u_4.__index.Add(p10, p11, p12, p13)
	-- upvalues: (copy) v_u_2, (copy) v_u_5
	if p13 then
		p10:Remove(p13)
		local v14 = p10[v_u_2]
		if not v14 then
			v14 = {}
			p10[v_u_2] = v14
		end
		v14[p13] = p11
	end
	local v15 = typeof(p11)
	local v16 = p12 or (v_u_5[v15 == "table" and string.match(tostring(p11), "Promise") and "Promise" or v15] or "Destroy")
	if type(p11) ~= "function" and not p11[v16] then
		warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p11), tostring(v16), debug.traceback(nil, 2)))
	end
	p10[p11] = { v16, (debug.traceback("")) }
	return p11
end
v_u_4.__index.Give = v_u_4.__index.Add
function v_u_4.__index.AddPromise(p17, p_u_18)
	local v19 = false
	if not v19 then
		return p_u_18
	end
	if not v19.is(p_u_18) then
		error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s))", typeof(p_u_18), (tostring(p_u_18))))
	end
	if p_u_18:getStatus() ~= v19.Status.Started then
		return p_u_18
	end
	local v20 = newproxy(false)
	local v23 = p17:Add(v19.new(function(p21, _, p22)
		-- upvalues: (copy) p_u_18
		if not p22(function()
			-- upvalues: (ref) p_u_18
			p_u_18:cancel()
		end) then
			p21(p_u_18)
		end
	end), "cancel", v20)
	v23:finallyCall(p17.Remove, p17, v20)
	return v23
end
v_u_4.__index.GivePromise = v_u_4.__index.AddPromise
function v_u_4.__index.AddObject(p24, p25)
	local v26 = newproxy(false)
	local v27 = false
	if not (v27 and v27.is(p25)) then
		return p24:Add(p25, false, v26), v26
	end
	if p25:getStatus() ~= v27.Status.Started then
		return p25
	end
	local v28 = p24:Add(v27.resolve(p25), "cancel", v26)
	v28:finallyCall(p24.Remove, p24, v26)
	return v28, v26
end
v_u_4.__index.GiveObject = v_u_4.__index.AddObject
function v_u_4.__index.Remove(p29, p30)
	-- upvalues: (copy) v_u_2
	local v31 = p29[v_u_2]
	local v32 = v31 and v31[p30]
	if v32 then
		local v33 = p29[v32]
		if v33 then
			v33 = v33[1]
		end
		if v33 then
			if v33 == true then
				v32()
			else
				local v34 = v32[v33]
				if v34 then
					v34(v32)
				end
			end
			p29[v32] = nil
		end
		v31[p30] = nil
	end
	return p29
end
function v_u_4.__index.Get(p35, p36)
	-- upvalues: (copy) v_u_2
	local v37 = p35[v_u_2]
	if v37 then
		return v37[p36]
	else
		return nil
	end
end
function v_u_4.__index.Cleanup(p38)
	-- upvalues: (copy) v_u_2
	if not p38.CurrentlyCleaning then
		p38.CurrentlyCleaning = nil
		for v39, v40 in next, p38 do
			if v39 ~= v_u_2 then
				local v41 = type(v39)
				if v41 == "string" or v41 == "number" then
					p38[v39] = nil
				else
					local v42 = v40[1]
					local v43 = v40[2]
					if v42 == true then
						local v44, v45 = pcall(v39)
						if not v44 then
							local v46 = debug.traceback("", 3)
							warn("-------- Janitor Error --------" .. "\n" .. tostring(v45) .. "\n" .. v46 .. "" .. v43)
						end
					else
						local v47 = v39[v42]
						if v47 then
							local v48, v49 = pcall(v47, v39)
							local v50
							if typeof(v39) == "Instance" then
								v50 = v47 == "Destroy"
							else
								v50 = false
							end
							if not (v48 or v50) then
								local v51 = debug.traceback("", 3)
								warn("-------- Janitor Error --------" .. "\n" .. tostring(v49) .. "\n" .. v51 .. "" .. v43)
							end
						end
					end
					p38[v39] = nil
				end
			end
		end
		local v52 = p38[v_u_2]
		if v52 then
			for v53 in next, v52 do
				v52[v53] = nil
			end
			p38[v_u_2] = {}
		end
		p38.CurrentlyCleaning = false
	end
end
v_u_4.__index.Clean = v_u_4.__index.Cleanup
function v_u_4.__index.Destroy(p54)
	p54:Cleanup()
end
v_u_4.__call = v_u_4.__index.Cleanup
local v_u_55 = {
	["Connected"] = true
}
v_u_55.__index = v_u_55
function v_u_55.Disconnect(p56)
	if p56.Connected then
		p56.Connected = false
		p56.Connection:Disconnect()
	end
end
function v_u_55.__tostring(p57)
	local v58 = p57.Connected
	return "Disconnect<" .. tostring(v58) .. ">"
end
function v_u_4.__index.LinkToInstance(p_u_59, p60, p61)
	-- upvalues: (copy) v_u_3, (copy) v_u_55, (copy) v_u_1
	local v_u_62 = nil
	local v63 = p61 and newproxy(false) or v_u_3
	local v_u_64 = p60.Parent == nil
	local v65 = v_u_55
	local v_u_66 = setmetatable({}, v65)
	local function v68(_, p67)
		-- upvalues: (copy) v_u_66, (ref) v_u_64, (ref) v_u_1, (ref) v_u_62, (copy) p_u_59
		v_u_64 = v_u_66.Connected and p67 == nil
		if v_u_64 then
			coroutine.wrap(function()
				-- upvalues: (ref) v_u_1, (ref) v_u_66, (ref) v_u_62, (ref) p_u_59, (ref) v_u_64
				v_u_1:Wait()
				if v_u_66.Connected then
					if v_u_62.Connected then
						while v_u_64 and (v_u_62.Connected and v_u_66.Connected) do
							v_u_1:Wait()
						end
						if v_u_66.Connected and v_u_64 then
							p_u_59:Cleanup()
						end
					else
						p_u_59:Cleanup()
					end
				else
					return
				end
			end)()
		end
	end
	local v_u_69 = p60.AncestryChanged:Connect(v68)
	v_u_66.Connection = v_u_69
	if v_u_64 then
		local v70 = p60.Parent
		if v_u_66.Connected then
			if v70 == nil then
				v_u_64 = true
			else
				v_u_64 = false
			end
			if v_u_64 then
				coroutine.wrap(function()
					-- upvalues: (ref) v_u_1, (copy) v_u_66, (ref) v_u_69, (copy) p_u_59, (ref) v_u_64
					v_u_1:Wait()
					if v_u_66.Connected then
						if v_u_69.Connected then
							while v_u_64 and (v_u_69.Connected and v_u_66.Connected) do
								v_u_1:Wait()
							end
							if v_u_66.Connected and v_u_64 then
								p_u_59:Cleanup()
							end
						else
							p_u_59:Cleanup()
						end
					else
						return
					end
				end)()
			end
		end
	end
	return p_u_59:Add(v_u_66, "Disconnect", v63)
end
function v_u_4.__index.LinkToInstances(p71, ...)
	-- upvalues: (copy) v_u_4
	local v72 = v_u_4.new()
	for _, v73 in ipairs({ ... }) do
		v72:Add(p71:LinkToInstance(v73, true), "Disconnect")
	end
	return v72
end
for v74, v75 in next, v_u_4.__index do
	local v76 = string.lower(v74)
	local v77 = string.sub(v76, 1, 1) .. string.sub(v74, 2)
	v_u_4.__index[v77] = v75
end
return v_u_4