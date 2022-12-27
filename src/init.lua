--!strict
local Package = script
local Packages = Package.Parent

-- Services
local RunService = game:GetService("RunService")

-- Packages
local _Maid = require(Packages:WaitForChild("Maid"))
local _Signal = require(Packages:WaitForChild("Signal"))
local _NetworkUtil = require(Packages:WaitForChild("NetworkUtil"))

local UPDATE_KEY = "GET_TIMESYNC_OFFSET"
local offset = 0
if RunService:IsServer() then
	_NetworkUtil.onServerInvoke(UPDATE_KEY, function(player: Player)
		return tick()
	end)
end
if RunService:IsClient() then
	local baseTick = _NetworkUtil.invokeServer(UPDATE_KEY)
	offset = tick() - baseTick
end

return function()
	return tick() - offset
end
