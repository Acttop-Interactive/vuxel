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

-- Gradients
-- Lerp between two Color3 values
local function lerpColor(color1, color2, alpha)
	return Color3.new(
		color1.R + (color2.R - color1.R) * alpha,
		color1.G + (color2.G - color1.G) * alpha,
		color1.B + (color2.B - color1.B) * alpha
	)
end

-- Find color at a specific time point in a ColorSequence
local function getColorAtTime(sequence, time)
	local keypoints = sequence.Keypoints

	-- If time is at or beyond the last keypoint, return the last color
	if time >= keypoints[#keypoints].Time then
		return keypoints[#keypoints].Value
	end

	-- If time is at or before the first keypoint, return the first color
	if time <= keypoints[1].Time then
		return keypoints[1].Value
	end

	-- Find the keypoints before and after the desired time
	for i = 1, #keypoints - 1 do
		local currentKey = keypoints[i]
		local nextKey = keypoints[i + 1]

		if time >= currentKey.Time and time <= nextKey.Time then
			-- Calculate how far we are between the two keypoints (0 to 1)
			local alpha = (time - currentKey.Time) / (nextKey.Time - currentKey.Time)
			-- Interpolate between the two colors
			return lerpColor(currentKey.Value, nextKey.Value, alpha)
		end
	end

	-- Shouldn't reach here, but return the last color if we do
	return keypoints[#keypoints].Value
end

-- Create a new ColorSequence by interpolating between two ColorSequences
local function createIntermediateColorSequence(sequence1, sequence2, alpha)
	-- Combine all time points from both sequences
	local timePoints = {}
	local usedTimes = {}

	-- Add points from first sequence
	for _, keypoint in ipairs(sequence1.Keypoints) do
		table.insert(timePoints, keypoint.Time)
		usedTimes[keypoint.Time] = true
	end

	-- Add points from second sequence
	for _, keypoint in ipairs(sequence2.Keypoints) do
		if not usedTimes[keypoint.Time] then
			table.insert(timePoints, keypoint.Time)
		end
	end

	-- Sort time points
	table.sort(timePoints)

	-- Create new keypoints by interpolating colors at each time point
	local newKeypoints = {}
	for _, time in ipairs(timePoints) do
		-- Find colors at this time point in both sequences
		local color1 = getColorAtTime(sequence1, time)
		local color2 = getColorAtTime(sequence2, time)

		-- Interpolate between the colors
		local interpolatedColor = lerpColor(color1, color2, alpha)

		-- Create new keypoint
		table.insert(newKeypoints, ColorSequenceKeypoint.new(time, interpolatedColor))
	end

	return ColorSequence.new(newKeypoints)
end

-- Animate transition between two gradients
function Animation.TweenGradient(gradient, fromSequence, toSequence, duration, style)
	style = style or Enum.EasingStyle.Linear

	-- Create a number value to tween
	local alpha = Instance.new("NumberValue")
	alpha.Value = 0

	-- Connect to the alpha value's changed event
	alpha.Changed:Connect(function(value)
		gradient.Color = createIntermediateColorSequence(fromSequence, toSequence, value)
	end)

	-- Create and start the tween
	local tween = TweenService:Create(alpha, TweenInfo.new(duration, style), {Value = 1})
	tween.Completed:Connect(function()
		alpha:Destroy()
	end)
	tween:Play()

	return tween
end

return Animation