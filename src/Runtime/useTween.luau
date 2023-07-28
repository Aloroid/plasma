---@class Plasma
local TweenService = game:GetService("TweenService")

local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

local function getValue<T>(alpha: number, tweenInfo: TweenInfo, startingValue, targetValue)
	local trueAlpha = TweenService:GetValue(alpha, tweenInfo.EasingStyle, tweenInfo.EasingDirection)

	if typeof(startingValue) == "number" then
		return startingValue + (targetValue - startingValue) * trueAlpha
	else
		return startingValue:Lerp(targetValue, trueAlpha)
	end
end

--[=[
	@within Plasma
	@param initialValue T -- The value this hook returns if the set callback has never been called
	@param tweenInfo TweenInfo -- The TweenInfo used to animate this value
	@return T -- The resulting tweened value
	@return (newValue: T) -> () -- A function which when called starts animating the value to the 
	@tag hooks

	Alternative to useState, capable of performing tweens.

]=]
local function useTween<T>(
	initialValue: T & (number | { Lerp: (target: T, alpha: number) -> T }),
	tweenInfo: TweenInfo
): (T, (newValue: T) -> ())
	local frame = stack[#stack]
	local states = frame.node.states

	local file = debug.info(2, "s")
	local line = debug.info(2, "l")
	local baseKey = string.format("%s:%s:%d", tostring(frame.discriminator) or "", file, line)
	frame.stateCounts[baseKey] = (frame.stateCounts[baseKey] or 0) + 1
	local key = string.format("%s:%d", baseKey, frame.stateCounts[baseKey])

	local existing: {
		alpha: number,
		startingValue: T,
		targetValue: T?,
		reversing: boolean,
		count: number,
		startAt: number,
		time: number,
	} =
		states[key]
	if existing == nil then
		existing = {
			alpha = 1,
			startingValue = initialValue,
			targetValue = initialValue,
			reversing = false,
			count = 0,
			time = os.clock(),
			startAt = math.huge,
		}
		states[key] = existing
	end

	local startingValue = existing.startingValue
	local targetValue = existing.targetValue
	local alpha = existing.alpha

	local function setter(newValue)
		assert(typeof(startingValue) == typeof(newValue), "new value must have the same type as initial value")
		states[key] = {
			alpha = 0,
			startingValue = getValue(alpha, tweenInfo, startingValue, targetValue),
			targetValue = newValue,
			reversing = false,
			count = 0,
			time = os.clock(),
			startAt = os.clock(),
		}
	end

	-- update the alpha
	local passed = (os.clock() - existing.time) / tweenInfo.Time
	while passed > 0 and (existing.startAt + tweenInfo.DelayTime) < os.clock() do
		-- if the amounts we repeated exceeds the RepeatCount, stop repeating
		if existing.count > tweenInfo.RepeatCount and tweenInfo.RepeatCount ~= -1 then
			break
		end

		if existing.reversing then
			alpha = math.max(alpha - passed, 0)
		else
			alpha = math.min(alpha + passed, 1)
		end

		local difference = alpha - existing.alpha
		passed -= math.abs(difference)

		-- used to increase the count and reverse the tween
		if alpha == 1 and tweenInfo.Reverses == false then
			existing.count += 1
			if existing.count <= tweenInfo.RepeatCount or tweenInfo.RepeatCount == -1 then
				alpha = 0
			end
		elseif alpha == 1 and tweenInfo.Reverses == true then
			existing.reversing = true
		elseif alpha == 0 and tweenInfo.Reverses == true then
			existing.reversing = false
			existing.count += 1
		end
	end

	existing.time = os.clock()
	existing.alpha = alpha

	local value = getValue(alpha, tweenInfo, startingValue, targetValue)
	return value, setter
end

return useTween
