--!nocheck
--[[
	NOTE:
	In order to preserve the names of the function arguments, we need to use a
 	generic to store the function. Widget returns a wrapped function though,
 	which the Luau typechecker determines to not be the same type and as result
 	causing a error.
	
	We're using --!nocheck to cancel the typechecking error here.
]]
local Package = script.Parent.Parent

local scope = require(Package.Runtime.scope)

--[=[
	@within Plasma
	@param fn (...: T) -> () -- The widget function
	@return (...: T) -> () -- A function which can be called to create the widget

	This function takes a widget function and returns a function that automatically starts a new scope when the function
	is called.
]=]
local function widget<T>(fn: T & (...any) -> unknown?): T
	local file, line = debug.info(2, "sl")
	local scopeKey = string.format("%s+%d", file, line)

	return function(...)
		return scope(2, scopeKey, fn, ...)
	end
end

return widget
