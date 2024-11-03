local State = require(script.Parent.State)
local Hooks = {}

-- `useState` hook to manage component state
function Hooks.useState(initialValue)
	return State.new(initialValue)
end

-- `useEffect` hook for side effects
function Hooks.useEffect(state, callback)
	state.Changed.Event:Connect(callback)
end

return Hooks
