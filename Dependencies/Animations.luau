local TweenService = game:GetService("TweenService")
local Animation = {}

-- Function to create and apply a tween animation to a UI element
function Animation.Tween(instance, properties, duration, easingStyle, easingDirection)
	local tweenInfo = TweenInfo.new(
		duration or 0.5, 
		easingStyle or Enum.EasingStyle.Quad, 
		easingDirection or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function Animation.Sequence(instance, sequenceTable)
	for _, step in ipairs(sequenceTable) do
		local tweenInfo = TweenInfo.new(step.Duration, step.EasingStyle, step.EasingDirection)
		local tween = TweenService:Create(instance, tweenInfo, step.Properties)
		tween:Play()
		tween.Completed:Wait()
	end
end

return Animation
