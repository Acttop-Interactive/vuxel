local References = {}

-- Table to store all component references
local refs = {}

-- Function to add a reference by name
function References.Add(name, component)
	if name and component then
		if refs[name] then
			error("Reference name '" .. name .. "' is already in use.")
		end
		refs[name] = component
	end
end

-- Function to get a reference by name
function References.Get(name)
	return refs[name]
end

-- Function to remove a reference by name
function References.Remove(name)
	local component = refs[name]
	if component then
		component:Destroy()
		refs[name] = nil
	end
end

-- Function to clear all references (useful for cleanup)
function References.Clear()
	table.clear(refs)
end

-- Function to list all stored references (for debugging)
function References.ListAll(printPrefix)
	printPrefix = printPrefix or ""
	for name, component in pairs(refs) do
		print(printPrefix .. name .. ": " .. tostring(component))
	end
end

return References