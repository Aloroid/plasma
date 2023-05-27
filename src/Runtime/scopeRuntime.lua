local Package = script.Parent.Parent

local scope = require(Package.Runtime.scope)

--[=[
	@within Plasma
	@param fn (...: T) -> ()
	@param ... T -- Additional parameters to `callback`

	Begins a new scope. This function may only be called within a `Plasma.start` callback.
	The `callback` is invoked immediately.

	Beginning a new scope associates all further calls to Plasma APIs with a nested scope inside this one.
]=]
local function scopeRuntime<R, T...>(fn: (T...) -> R?, ...: T...): R
	return scope(2, "", fn, ...)
end

return scopeRuntime
