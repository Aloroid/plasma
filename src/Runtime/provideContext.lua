local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param context Context -- A context object previously created with `createContext`
	@param value T -- Any value you want to provide for this context

	Provides a value for this context for any subsequent uses of `useContext` in this scope.
]=]
local function provideContext(context, value)
	local frame = stack[#stack]
	frame.contextValues[context] = value
end

return provideContext
