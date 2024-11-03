local Components = {}
local State = require(script.Parent.State)
local References = require(script.Parent.References)
local Style = require(script.Parent.Style)

local lifecycleRegistry = setmetatable({}, { __mode = "k" }) -- Weak table to store lifecycle hooks

local ignoredProps = {
	ClassNames = true,
	Style = true,
	Class = true,
	Children = true,
	Events = true,
	Name = true,
	Lifecycle = true
}

-- Helper function to apply properties and bindings to instances
local function applyProps(instance, props, self)	
	for prop, value in pairs(props) do
		-- Skip any properties listed in `ignoredProps`
		if not ignoredProps[prop] then
			if typeof(value) == "table" and (getmetatable(value) == State or value.__computed) then
				value.Changed.Event:Connect(function(newValue)
					instance[prop] = newValue
				end)
				instance[prop] = value:Get() -- Assign the initial value
			else
				instance[prop] = value -- Directly assign normal properties
			end
		end
	end
end

-- Helper function to apply style properties to an instance
local function applyStyle(instance, styleProps)
	for prop, value in pairs(styleProps) do
		if typeof(value) == "table" and not instance:FindFirstChild(prop) then
			local childInstance = Instance.new(prop)
			childInstance.Parent = instance
			for childProp, childValue in pairs(value) do
				childInstance[childProp] = childValue
			end
		else
			instance[prop] = value
		end
	end
end

-- Function to register a lifecycle hook on a component
local function RegisterLifecycleHook(instance, hookName, callback)
	if not lifecycleRegistry[instance] then
		lifecycleRegistry[instance] = {}
	end
	lifecycleRegistry[instance][hookName] = callback
end

-- Function to call a specific lifecycle hook
local function CallLifecycleHook(instance, hookName, self)
	local lifecycle = lifecycleRegistry[instance]
	if lifecycle and lifecycle[hookName] then
		lifecycle[hookName](self) -- Pass `self` to the lifecycle hook
	end
end

-- Function to remove a component and call its destruction hook
local function RemoveComponent(instance)
	CallLifecycleHook(instance, "onDestroyed")
	instance:Destroy()
	lifecycleRegistry[instance] = nil -- Clean up the weak table reference
end

-- Function to create a new UI component
function Components.New(class, props, self)
	local instance = Instance.new(class)
	
	-- Fetch classNames, componentName, and inline Style prop if provided
	local classNames = props.ClassNames
	local componentName = props.Name or class
	local inlineStyle = props.Style or {}
	
	-- Merge global, scoped, class-based, and inline styles
	local styleProps = Style.GetStyle(componentName, classNames)
	for prop, value in pairs(inlineStyle) do
		styleProps[prop] = value  -- Inline styles take highest priority
	end

	-- Apply the merged styles and explicit props
	applyStyle(instance, styleProps)
	applyProps(instance, props, self)

	-- Defer the `onMounted` call until after the component is parented
	instance.AncestryChanged:Connect(function(_, parent)
		if parent then
			CallLifecycleHook(instance, "onMounted", self)
		end
	end)

	return instance
end

-- Modified `Template` function to include `self` scoping
function Components.Template(template, parentSelf)
	-- Create a new self table to hold references to child components
	local self = parentSelf or {}
	local className = template.Class or "Frame"  -- Default to "Frame" if no class is specified

	-- Create the main component instance
	local instance = Components.New(className, template, self)

	-- Store the main instance in self under its specified name (if provided)
	if template.Name then
		self[template.Name] = instance
		References.Add(template.Name, instance)
	end

	-- Recursively create child components and assign them as references in self
	if template.Children then
		for _, childTemplate in ipairs(template.Children) do
			local childInstance = Components.Template(childTemplate, self)
			childInstance.Parent = instance

			-- Assign the child component to self based on its Name
			if childTemplate.Name then
				self[childTemplate.Name] = childInstance
			end
		end
	end

	-- Apply event handlers if specified
	if template.Events then
		for event, handler in pairs(template.Events) do
			if instance[event] then
				instance[event]:Connect(function()
					handler(self) -- Pass the self table to the event handler
				end)
			end
		end
	end

	-- Register lifecycle hooks with self reference, if provided in Lifecycle property
	if template.Lifecycle then
		for hookName, callback in pairs(template.Lifecycle) do
			Components.RegisterLifecycleHook(instance, hookName, function()
				callback(self)
			end)
		end
	end

	return instance
end

-- Expose lifecycle management and component removal functions
Components.RegisterLifecycleHook = RegisterLifecycleHook
Components.RemoveComponent = RemoveComponent

return Components