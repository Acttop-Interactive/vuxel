--!strict

-- Vuxel Module
-- Version: 0.3.2
-- Description: A lightweight component-based UI framework inspired by Vue.js for Roblox.
-- Author: OMouta

local Vuxel = {}

local successState, State = pcall(function() return require(script.State) end)
local successComponents, Components = pcall(function() return require(script.Components) end)
local successEvent, Event = pcall(function() return require(script.Event) end)
local successUtility, Utility = pcall(function() return require(script.Utility) end)
local successAnimation, Animation = pcall(function() return require(script.Animations) end)
local successHooks, Hooks = pcall(function() return require(script.Hooks) end)
local successReferences, References = pcall(function() return require(script.References) end)
local successStyle, Style = pcall(function() return require(script.Style) end)

if not successState then error("Failed to load Vuxel State module.") end
if not successComponents then error("Failed to load Vuxel Components module.") end
if not successEvent then error("Failed to load Vuxel Event module.") end
if not successUtility then error("Failed to load Vuxel Utility module.") end
if not successAnimation then error("Failed to load Vuxel Animations module.") end
if not successHooks then error("Failed to load Vuxel Hooks module.") end
if not successReferences then error("Failed to load Vuxel References module.") end
if not successStyle then error("Failed to load Vuxel Style module.") end

Vuxel.State = State
Vuxel.Components = Components
Vuxel.Event = Event
Vuxel.Utility = Utility
Vuxel.Animation = Animation
Vuxel.Hooks = Hooks
Vuxel.References = References
Vuxel.Style = Style

Vuxel.RegisterLifecycleHook = Components.RegisterLifecycleHook
Vuxel.RemoveComponent = Components.RemoveComponent
Vuxel.ConnectEvent = Event.Connect

Vuxel.Computed = Utility.Computed
Vuxel.CreateApp = Utility.CreateApp
Vuxel.Template = Components.Template

Vuxel.GetRef = function(name)
	if type(name) ~= "string" then
		error("[Vuxel] GetRef: Reference name must be a string. Got: " .. tostring(name))
	end

	local component = References.Get(name)
	if not component then
		warn("[Vuxel] GetRef: Reference '" .. name .. "' does not exist or has not been registered.")
	end
	return component
end

Vuxel.SetRef = function(name, component)
	if type(name) ~= "string" then
		error("[Vuxel] SetRef: Reference name must be a string. Got: " .. tostring(name))
	end
	if not component or not component:IsA("Instance") then
		error("[Vuxel] SetRef: Component must be a valid Roblox Instance. Got: " .. tostring(component))
	end

	References.Add(name, component)
end

Vuxel.Version = "0.3.2"

return Vuxel