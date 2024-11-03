local Event = {}

-- Create a new event connection
function Event.Connect(instance, eventName, callback)
	return instance[eventName]:Connect(callback)
end

return Event
