local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param callback () -> () | () -> () -> () -- A callback function that optionally returns a cleanup function
	@param ... any -- Dependencies
	@tag hooks

	`useEffect` takes a callback as a parameter which is then only invoked if passed dependencies are different from the
	last time this function was called. The callback is always invoked the first time this code path is reached.

	If no dependencies are passed, the callback only runs once.

	This function can be used to skip expensive work if none of the dependencies have changed since the last run.
	For example, you might use this to set a bunch of properties in a widget if any of the inputs change.
]=]
local function useEffect(callback: () -> (() -> ())?, ...)
	local frame = stack[#stack]
	local effects = frame.node.effects

	local file = debug.info(2, "s")
	local line = debug.info(2, "l")
	local baseKey = string.format("%s:%s:%d", tostring(frame.discriminator) or "", file, line)

	frame.effectCounts[baseKey] = (frame.effectCounts[baseKey] or 0) + 1
	local key = string.format("%s:%d", baseKey, frame.effectCounts[baseKey])

	local existing = effects[key]
	local gottaRunIt = existing == nil -- We ain't never run this before!
		or select("#", ...) ~= existing.lastDependenciesLength -- I have altered the dependencies. Pray that I do not alter them further.

	if not gottaRunIt then
		for i = 1, select("#", ...) do
			if select(i, ...) ~= existing.lastDependencies[i] then
				gottaRunIt = true
				break
			end
		end
	end

	if gottaRunIt then
		if existing ~= nil and existing.destructor ~= nil then
			existing.destructor()
		end

		effects[key] = {
			destructor = callback(),
			lastDependencies = { ... },
			lastDependenciesLength = select("#", ...),
		}
	end
end

return useEffect :: ((callback: () -> (), ...any) -> ()) & (callback: () -> () -> (), ...any) -> ()
