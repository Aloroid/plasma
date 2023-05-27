local Package = script.Parent.Parent

local scope = require(Package.Runtime.scope)

--[=[
	@within Plasma
	@param fn (...: T) -> () -- The widget function
	@return (...: T) -> () -- A function which can be called to create the widget

	This function takes a widget function and returns a function that automatically starts a new scope when the function
	is called.
]=]
local function widget<R, T...>(fn: (T...) -> R)
	local file, line = debug.info(2, "sl")
	local scopeKey = string.format("%s+%d", file, line)

	return function(...: T...)
		return scope(2, scopeKey, fn, ...)
	end
end

return widget
