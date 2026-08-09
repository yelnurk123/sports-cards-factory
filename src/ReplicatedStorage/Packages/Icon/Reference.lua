local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reference = {
	objectName = "TopbarPlusReference"
}

function Reference.addToReplicatedStorage()
	if ReplicatedStorage:FindFirstChild(Reference.objectName) then
		return false
	end

	local objectValue = Instance.new("ObjectValue")
	objectValue.Name = Reference.objectName
	objectValue.Value = script.Parent
	objectValue.Parent = ReplicatedStorage

	return objectValue
end

function Reference.getObject()
	local objectValue = ReplicatedStorage:FindFirstChild(Reference.objectName)
	if objectValue then
		return objectValue
	end

	return false
end

return Reference
