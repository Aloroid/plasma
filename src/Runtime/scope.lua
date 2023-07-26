local Package = script.Parent.Parent

local sharedState = require(Package.Runtime.sharedState)
local newNode = require(Package.Runtime.newNode)
local newStackFrame = require(Package.Runtime.newStackFrame)
local destroyNode = require(Package.Runtime.destroyNode)
local errorWidget = require(Package.widgets.error)

local stack = sharedState.stack

local function scope<R, T...>(level: number, scopeKey: string, fn: (T...) -> R?, ...: T...): R
	local parentFrame = stack[#stack]
	local parentNode = parentFrame.node

	local file = debug.info(1 + level, "s")
	local line = debug.info(1 + level, "l")
	local baseKey = string.format("%s:%s:%s:%d", scopeKey, tostring(parentFrame.discriminator) or "", file, line)

	parentFrame.childCounts[baseKey] = (parentFrame.childCounts[baseKey] or 0) + 1
	local key = string.format("%s:%d", baseKey, parentFrame.childCounts[baseKey])

	local currentNode = parentNode.children[key]

	if currentNode == nil then
		currentNode = newNode()
		parentNode.children[key] = currentNode
	end

	currentNode.generation = parentNode.generation

	table.insert(stack, newStackFrame(currentNode))
	local thread = coroutine.create(fn)

	local success, widgetHandle = coroutine.resume(thread, ...)

	if coroutine.status(thread) ~= "dead" then
		success = false
		widgetHandle =
			"Plasma: Handler passed to Plasma.start yielded! Yielding is not allowed and the handler thread has been closed."

		coroutine.close(thread)
	end

	if not success then
		if os.clock() - sharedState.recentErrorLastTime > 10 then
			sharedState.recentErrorLastTime = os.clock()
			sharedState.recentErrors = {}
		end

		local errorValue = debug.traceback(thread, tostring(widgetHandle))

		if not sharedState.recentErrors[errorValue] then
			task.spawn(error, tostring(errorValue))
			warn("Plasma: The above error will be suppressed for the next 10 seconds")
			sharedState.recentErrors[errorValue] = true
		end

		errorWidget(tostring(errorValue))
	end

	table.remove(stack)

	for childKey, childNode in pairs(currentNode.children) do
		if childNode.generation ~= currentNode.generation then
			destroyNode(childNode)
			currentNode.children[childKey] = nil
		end
	end

	return widgetHandle
end

-- hacky solution to stop cyclic requires, wraps error
-- inside a widget with it's own widget function.
local function widget(fn)
	local file, line = debug.info(2, "sl")
	local scopeKey = string.format("%s+%d", file, line)

	return function(...)
		return scope(2, scopeKey, fn, ...)
	end
end

errorWidget = widget(errorWidget)

return scope
