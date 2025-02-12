--!strict

local Types = require(script.Parent.Types)

local State = {}
State.__index = State

function State.new(initialValue : any)
	if initialValue == nil then
		error("Initial value cannot be nil")
	end
	local self = setmetatable({} :: Types.StateObject, State)
	self.Value = initialValue
	self.Changed = Instance.new("BindableEvent")
	return self
end

function State:Set(newValue : any)
	if newValue == nil then
		error("New value cannot be nil")
	end
	if self.Value ~= newValue then
		self.Value = newValue
		self.Changed:Fire(newValue)
	end
end

function State:Get()
	return self.Value
end

-- Bind a state to a UI property and listen for changes to update the state
function State:BindTo(instance : Types.VuxelUIInstance, property : string)
	if not instance or not instance:IsA("Instance") then
		error("Invalid instance")
	end
	if not property or type(property) ~= "string" then
		error("Invalid property")
	end
	instance:GetPropertyChangedSignal(property):Connect(function()
		self:Set(instance[property])
	end)
end

return State