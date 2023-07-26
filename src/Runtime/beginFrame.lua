local Package = script.Parent.Parent

local Types = require(Package.Types)
local sharedState = require(Package.Runtime.sharedState)
local newStackFrame = require(Package.Runtime.newStackFrame)
local scope = require(Package.Runtime.scope)

local stack = sharedState.stack

type ContinueHandle = Types.StackFrame
type Node = Types.Node

--[=[
	@within Plasma
	@param rootNode Node -- A node created by `Plasma.new`.
	@param fn (...: T) -> ()
	@param ... T -- Additional parameters to `callback`
	@return ContinueHandle -- A handle to pass to `continueFrame`

	Begins a *continuable* Plasma frame. Same semantics as [Plasma.start].

	For a frame:
	- Call `beginFrame` once.
	- Call `continueFrame` any number of times.
	- Call `finishFrame` when the frame is complete.

	If this function is used, `Plasma.start` should not be used.
]=]
local function beginFrame<T...>(rootNode: Node, fn: (T...) -> (), ...: T...): ContinueHandle
	if #stack > 0 then
		error("Runtime.start cannot be called while Runtime.start is already running", 2)
	end

	debug.profilebegin("Plasma")

	if rootNode.generation == 0 then
		rootNode.generation = 1
	else
		rootNode.generation = 0
	end

	stack[1] = newStackFrame(rootNode)
	scope(2, "root", fn, ...)
	local continueHandle = table.remove(stack)

	debug.profileend()

	return continueHandle
end

return beginFrame
