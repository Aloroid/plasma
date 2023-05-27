local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param key

	Specify a key by which to store all future state in this scope. This is similar to React's `key` prop.

	This is important to use to prevent state from one source being still being applied when it should actually reset.
]=]
local function useKey(key: string | number)
	local frame = stack[#stack]

	frame.discriminator = key
end

return useKey
