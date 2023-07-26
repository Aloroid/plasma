local sharedState = require(script.Parent.sharedState)
local nearestStackFrameWithInstance = require(script.Parent.nearestStackFrameWithInstance)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param creator (ref: {}) -> (Instance, Instance?) -- A callback which creates the widget and returns it
	@return Instance -- Returns the instance returned by `creator`
	@tag hooks

	`useInstance` takes a callback which should be used to create the initial UI for the widget.
	The callback is only ever invoked on the first time this widget runs and never again.
	The callback should return the instance it created.
	The callback can optionally return a second value, which is the instance where children of this widget should be
	placed. Otherwise, children are placed in the first instance returned.

	`useInstance` returns the `ref` table that is passed to it. You can use this to create references to objects
	you want to update in the widget body.
]=]
local function useInstance<T>(creator: (refs: T & {}) -> (Instance, Instance?)): T
	local node = stack[#stack].node
	local parentFrame = nearestStackFrameWithInstance()

	if node.instance == nil then
		local parent = parentFrame.node.containerInstance or parentFrame.node.instance

		node.refs = {}
		local instance, container = creator(node.refs)

		if instance ~= nil then
			instance.Parent = parent
			node.instance = instance
		end

		if container ~= nil then
			node.containerInstance = container
		end
	end

	if node.instance ~= nil and node.instance:IsA("GuiObject") then
		parentFrame.childrenCount += 1
		node.instance.LayoutOrder = parentFrame.childrenCount
	end

	return node.refs
end

return useInstance
