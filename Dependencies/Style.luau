local Style = {}

local globalStyles = {}
local scopedStyles = {}
local classes = {}

-- Function to define global styles
function Style.DefineGlobal(styles)
	for name, properties in pairs(styles) do
		globalStyles[name] = properties
	end
end

-- Function to define scoped styles for specific components
function Style.DefineScope(componentName, styles)
	scopedStyles[componentName] = styles
end

-- Function to define reusable class-based styles
function Style.DefineClass(className, properties)
	if classes[className] then
		warn("[Vuxel] Class '" .. className .. "' is already defined. Overwriting.")
	end
	classes[className] = properties
end

-- Function to retrieve global or scoped style properties
function Style.GetStyle(componentName, classNames)
	-- Start with global styles
	local appliedStyle = globalStyles[componentName] or {}

	-- Apply scoped style if it exists
	if scopedStyles[componentName] then
		for prop, value in pairs(scopedStyles[componentName]) do
			appliedStyle[prop] = value
		end
	end

	-- Apply class-based styles, overriding global and scoped styles
	if classNames then
		for _, className in ipairs(classNames) do
			local classProps = classes[className]
			if classProps then
				for prop, value in pairs(classProps) do
					appliedStyle[prop] = value
				end
			end
		end
	end

	return appliedStyle
end

return Style