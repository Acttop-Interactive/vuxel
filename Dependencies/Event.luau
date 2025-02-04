--!strict

local Event = {}

type Callback = (...any) -> ()

type EventConnection = {
	Disconnect: () -> ()
}

function Event.Connect(instance: Instance, eventName: string, callback: Callback): EventConnection
	--Will cause a type error because is unsafe and may cause exceptions at runtime
	local event = instance[eventName] :: RBXScriptSignal
	local connection = event:Connect(callback)
	return {
		Disconnect = function()
			connection:Disconnect()
		end
	}
end

return Event