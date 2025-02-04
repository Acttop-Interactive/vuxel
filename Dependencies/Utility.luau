--!strict
local State = require(script.Parent.State)
local References = require(script.Parent.References)
local Components = require(script.Parent.Components)

local Utility = {}

-- Function to bind multiple states together
function Utility.Bind(...)
	local states = {...}
	for _, state in ipairs(states) do
		if not (getmetatable(state) == State) then
			error("Invalid state object")
		end
	end
	local outputState = require(script.Parent.State).new(nil)

	-- Update output state whenever one of the input states changes
	for _, state in ipairs(states) do
		state.Changed.Event:Connect(function()
			outputState:Set(state:Get())
		end)
	end

	return outputState
end

-- Function to initialize a root frame and register it as the root reference
function Utility.CreateApp(template : {} | Instance, screenGui : ScreenGui | nil)
	-- Check if the template is not an instance (i.e., a raw table structure).
	if typeof(template) == "table" and not template:IsA("Instance") then
		warn("[Vuxel] Received a non-templated component. Wrapping with Vuxel.Template...")
		template = Components.Template(template)  -- Automatically template the structure.
	end
	
	local root = screenGui
	
	if not screenGui then
		
		root = Instance.new("ScreenGui")
		root.Parent = game.Players.LocalPlayer.PlayerGui
		
	end
	
	root.Name = "Vuxel_" .. tostring(tick())
	template.Parent = root

	References.Add("Root", root)

	return root
end

-- Computed class and other utility methods
local Computed = {}
Computed.__index = Computed

function Computed.new(callback, ...)
	local dependencies = {...}
	local self = setmetatable({}, Computed)
	self.callback = callback
	self.dependencies = dependencies
	self.cachedValue = nil
	self.dirty = true
	self.Changed = Instance.new("BindableEvent")
	self.__computed = true

	-- Track changes in dependencies
	for _, dep in ipairs(dependencies) do
		if getmetatable(dep) == State then
			dep.Changed.Event:Connect(function()
				self.dirty = true
				self:Recompute()
			end)
		end
	end

	return self
end

function Computed:Recompute()
	if self.dirty then
		local success, result = pcall(self.callback)
		if success then
			self.cachedValue = result
			self.dirty = false
			self.Changed:Fire(self.cachedValue)
		else
			warn("Computed property error:", result)
			-- Add more robust error handling, such as logging or error reporting
		end
	end
end

function Computed:Get()
	if self.dirty then
		self:Recompute()
	end
	return self.cachedValue
end

Utility.Computed = function(callback, ...)
	local computed = Computed.new(callback, ...)
	computed:Recompute()
	return computed
end

return Utility