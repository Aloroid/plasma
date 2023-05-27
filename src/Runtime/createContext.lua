--[=[
	@within Plasma
	@param name string -- The human-readable name of the context. This is only for debug purposes.
	@return Context -- An opqaue Context object which holds persistent state.

	Creates a [Context] object which is used to pass state downwards through the tree without needing to thread it
	through every child as props.
]=]
local function createContext(name: string)
	local fullName = string.format("PlasmaContext(%s)", name)
	return setmetatable({}, {
		__tostring = function()
			return fullName
		end,
	})
end

return createContext
