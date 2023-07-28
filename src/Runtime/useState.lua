local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

--[=[
	@within Plasma
	@param initialValue T -- The value this hook returns if the set callback has never been called
	@return T -- The previously set value, or the initial value if none has been set
	@return (newValue: T) -> () -- A function which when called stores the value in this hook for the next run
	@tag hooks

	```lua
	local checked, setChecked = useState(false)

	useInstance(function()
		local TextButton = Instance.new("TextButton")

		TextButton.Activated:Connect(function()
			setChecked(not checked)
		end)

		return TextButton
	end)

	TextButton.Text = if checked then "X" else ""
	```
]=]
local function useState<T>(initialValue: T?): (T, (newValue: T) -> ())
	local frame = stack[#stack]
	local states = frame.node.states

	local file = debug.info(2, "s")
	local line = debug.info(2, "l")
	local baseKey = string.format("%s:%s:%d", tostring(frame.discriminator) or "", file, line)
	frame.stateCounts[baseKey] = (frame.stateCounts[baseKey] or 0) + 1
	local key = string.format("%s:%d", baseKey, frame.stateCounts[baseKey])

	local existing = states[key]
	if existing == nil then
		states[key] = initialValue
	end

	local function setter(newValue)
		states[key] = newValue
	end

	return states[key], setter
end

return useState
