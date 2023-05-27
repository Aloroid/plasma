local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param context Context -- A context object previously created with `createContext`
	@return T
	@tag hooks

	Returns the value of this context provided by the most recent ancestor that used `provideContext` with this context.
]=]
local function useContext(context)
	for i = #stack - 1, 1, -1 do
		local frame = stack[i]

		if frame.contextValues[context] ~= nil then
			return frame.contextValues[context]
		end
	end

	return nil
end

return useContext
