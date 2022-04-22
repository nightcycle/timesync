local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if RunService:IsClient() then
	local sync = ReplicatedStorage:WaitForChild("TimeSync")
	local serverOffset
	local lastUpdate = 0
	RunService.RenderStepped:Connect(function(deltaTime)
		if tick() - lastUpdate > 5 then
			lastUpdate = tick()
			serverOffset = sync:InvokeServer(tick())
		end
	end)
	return function()
		if serverOffset then
			return tick() + serverOffset
		else
			return nil
		end
	end
else
	local sync = Instance.new("RemoteFunction", ReplicatedStorage)
	sync.Name = "TimeSync"
	sync.OnServerInvoke = function(player, proposedTick)
		local t = tick()
		local ping = math.clamp(player:GetNetworkPing(), 0, 1000)

		local pDelay = ping/1000
		local offset = t - pDelay - proposedTick

		return offset
	end
	return function ()
		return tick()
	end
end

