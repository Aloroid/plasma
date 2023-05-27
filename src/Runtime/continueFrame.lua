local Package = script.Parent.Parent

local Types = require(Package.Types)
local sharedState = require(Package.Runtime.sharedState)
local scope = require(Package.Runtime.scope)

local stack = sharedState.stack

type ContinueHandle = Types.StackFrame

--[=[
	Continue the Plasma frame with a new handler function. Calling this will not trigger any cleanup that typically
	happens every frame.

	This is intended to be used to continue creating UI within the same frame that you started on. You should call
	[Plasma.beginFrame] once per frame, then `Plasma.continueFrame` any number of times after that, finally calling
	[Plasma.finishFrame].

	@within Plasma
	@param continueHandle ContinueHandle -- An object returned by Plasma.start
	@param fn (...: T) -> ()
	@param ... T -- Additional parameters to `callback`
]=]
local function continueFrame<T...>(continueHandle: ContinueHandle, fn: (T...) -> (), ...: T...)
	if #stack > 0 then
		error("Runtime.continue cannot be called while Runtime.start is already running", 2)
	end

	stack[1] = continueHandle

	scope(2, "root", fn, ...)

	table.remove(stack)
end

return continueFrame
