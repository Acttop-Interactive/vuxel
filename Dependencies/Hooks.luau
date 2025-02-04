--!strict

local State = require(script.Parent.State)
local Types = require(script.Parent.Types)

local Hooks = {}

type StateObject<T> = {
	Value: T,
	Changed: BindableEvent,
	Set: (self: StateObject<T>, newValue: T) -> (),
	Get: (self: StateObject<T>) -> T,
	BindTo: (self: StateObject<T>, instance: Instance, property: string) -> ()
}

type Callback = (...any) -> ()

function Hooks.useState<T>(initialValue: T): StateObject<T>
	local state = State.new(initialValue) :: Types.State
	return {
		Value = state.Value,
		Changed = state.Changed,
		Set = function(self: StateObject<T>, newValue: T)
			state:Set(newValue)
		end,
		Get = function(self: StateObject<T>)
			return state:Get()
		end,
		BindTo = function(self: StateObject<T>, instance: Instance, property: string)
			state:BindTo(instance, property)
		end
	}
end

function Hooks.useEffect<T>(state: StateObject<T>, callback: Callback)
	state.Changed.Event:Connect(callback)
end

return Hooks