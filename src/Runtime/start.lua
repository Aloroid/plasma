local Package = script.Parent.Parent

local Types = require(Package.Types)

local beginFrame = require(Package.Runtime.beginFrame)
local finishFrame = require(Package.Runtime.finishFrame)

type Node = Types.Node

--[=[
	@within Plasma
	@param rootNode Node -- A node created by `Plasma.new`.
	@param fn (...: T) -> ()
	@param ... T -- Additional parameters to `callback`

	Begins a new frame for this Plasma instance. The `callback` is invoked immediately.
	Code run in the `callback` function that uses plasma APIs will be associated with this Plasma node.
	The `callback` function is **not allowed to yield**.

	If this function is used, `Plasma.beginFrame`, `Plasma.continueFrame`, and `Plasma.finishFrame` should not be used.
]=]
local function start<T...>(rootNode: Node, fn: (T...) -> (), ...: T...)
	beginFrame(rootNode, fn, ...)

	finishFrame(rootNode)
end

return start
