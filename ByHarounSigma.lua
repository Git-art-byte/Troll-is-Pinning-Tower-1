local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local looping = false
local loopThread = nil
local auraLooping = false
local auraThread = nil
local customVector = nil -- Custom slap vector

local function split(str)
	local result = {}
	for word in str:gmatch("%S+") do
		table.insert(result, word)
	end
	return result
end

local function findTargets(name)
	name = name:lower()
	local results = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end

		if name == "all" then
			table.insert(results, player)
		elseif name == "random" then
			table.insert(results, player)
		elseif player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
			table.insert(results, player)
		end
	end

	if name == "random" and #results > 0 then
		return { results[math.random(1, #results)] }
	elseif name == "all" then
		return results
	elseif #results > 0 then
		return { results[1] }
	end

	return nil
end

local function equipSlap()
	local bp = LocalPlayer:FindFirstChild("Backpack")
	if not bp then return false end
	local tool = bp:FindFirstChild("SecretSlap")
	if tool then
		tool.Parent = LocalPlayer.Character
		return true
	end
	warn("SecretSlap not found in backpack.")
	return false
end

local function slap(targetPlayer, power)
	local char = targetPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local slapDirection = customVector or Vector3.new(0, 0, power)

	local args = {
		"slash",
		char,
		slapDirection
	}

	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SecretSlap")
	if tool and tool:FindFirstChild("Event") then
		tool.Event:FireServer(unpack(args))
	end
end

local function setSlapStats(power, speed, flightSpeed)
	local char = LocalPlayer.Character
	if not char then return end

	local tool = char:FindFirstChild("SecretSlap")
	if not tool then
		warn("SecretSlap is not equipped!")
		return
	end

	local powerVal = tool:FindFirstChild("Power")
	local speedVal = tool:FindFirstChild("Speed")
	local flightVal = tool:FindFirstChild("FlightSpeed")

	if powerVal and powerVal:IsA("NumberValue") then
		powerVal.Value = power
	end
	if speedVal and speedVal:IsA("NumberValue") then
		speedVal.Value = speed
	end
	if flightVal and flightVal:IsA("NumberValue") then
		flightVal.Value = flightSpeed
	end
end

LocalPlayer.Chatted:Connect(function(msg)
	local parts = split(msg)
	local command = parts[1] and parts[1]:lower()

	if command == "!slap" then
		local targetInput = parts[2]
		local powerInput = tonumber(parts[3]) or 45

		if not targetInput then
			warn("Usage: !slap <name/random/all> [power]")
			return
		end

		local targets = findTargets(targetInput)
		if not targets or #targets == 0 then
			warn("No matching targets found.")
			return
		end

		if equipSlap() then
			task.wait(0.1)
			for _, target in ipairs(targets) do
				slap(target, powerInput)
			end
		end

	elseif command == "!fun" then
		if equipSlap() then
			task.wait(0.1)
			setSlapStats(45, 0.9, math.huge)
			customVector = Vector3.new(0, -9e9, 0)
			warn("⚡ FUN mode activated: Custom vector (0, -9e9, 0)")
		end

	elseif command == "!unfun" then
		if equipSlap() then
			task.wait(0.1)
			setSlapStats(45, 10, 0.45)
			customVector = nil
			warn("🔄 Stats reset to normal.")
		end

	elseif command == "!loopslap" then
		local targetInput = parts[2]
		local delay = tonumber(parts[3]) or 0.5
		local power = tonumber(parts[4]) or 45

		if not targetInput then
			warn("Usage: !loopslap <name/random/all> [delay] [power]")
			return
		end

		local targets = findTargets(targetInput)
		if not targets or #targets == 0 then
			warn("No targets found.")
			return
		end

		if looping then
			warn("Already looping. Use !stoploop to cancel.")
			return
		end

		if equipSlap() then
			looping = true
			loopThread = task.spawn(function()
				while looping do
					for _, target in ipairs(targets) do
						slap(target, power)
					end
					task.wait(delay)
				end
			end)
			warn("🔁 Looping slap started.")
		end

	elseif command == "!unloopslap" then
		if looping then
			looping = false
			if loopThread then
				task.cancel(loopThread)
				loopThread = nil
			end
			warn("⛔ Looping slap stopped.")
		else
			warn("Loop is not running.")
		end

	elseif command == "!slapaura" then
		local radius = tonumber(parts[2]) or 8
		local power = tonumber(parts[3]) or 45

		if not equipSlap() then
			warn("SecretSlap not equipped!")
			return
		end

		if auraLooping then
			warn("Slapaura already active! Use !stopaura to stop.")
			return
		end

		auraLooping = true
		auraThread = task.spawn(function()
			while auraLooping do
				local char = LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if not hrp then auraLooping = false break end

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer then
						local pchar = player.Character
						local phrp = pchar and pchar:FindFirstChild("HumanoidRootPart")
						if phrp and (hrp.Position - phrp.Position).Magnitude <= radius then
							slap(player, power)
						end
					end
				end
				task.wait(0.00000000001)
			end
		end)

		warn("🌀 Slapaura started with radius "..radius.." and power "..power.."!")

	elseif command == "!unslapaura" then
		if auraLooping then
			auraLooping = false
			if auraThread then
				task.cancel(auraThread)
				auraThread = nil
			end
			warn("⛔ Slapaura stopped.")
		else
			warn("Slapaura is not active.")
		end

	elseif command == "!end" then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(-219, 530, -1844)
			warn("📍 Teleported to !end location.")
		end

	elseif command == "!tptroll" then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(-385, 154, -1871)
			warn("😈 Teleported to !tptroll location.")
		end

	elseif command == "!tools" then
		local groupPath = workspace:FindFirstChild("MainGame") and workspace.MainGame:FindFirstChild("GroupDoor") and workspace.MainGame.GroupDoor:FindFirstChild("Slaps V1")
		local secretPath = workspace:FindFirstChild("MainGame") and workspace.MainGame:FindFirstChild("SecretDoor") and workspace.MainGame.SecretDoor:FindFirstChild("OpSlap")

		local toolNames = { "BlackSlap", "PinkSlap", "RedSlap", "GreenSlap", "Slap" }

		if groupPath then
			for _, name in ipairs(toolNames) do
				local tool = groupPath:FindFirstChild(name)
				if tool and tool:FindFirstChild("ProximityPrompPart") then
					local prompt = tool.ProximityPrompPart:FindFirstChildOfClass("ProximityPrompt")
					if prompt then
						fireproximityprompt(prompt)
					end
				end
			end
		else
			warn("❌ Group tool path not found!")
		end

		if secretPath and secretPath:FindFirstChild("ProximityPrompPart") then
			local secretPrompt = secretPath.ProximityPrompPart:FindFirstChild("???")
			if secretPrompt and secretPrompt:IsA("ProximityPrompt") then
				fireproximityprompt(secretPrompt)
			end
		else
			warn("❌ Secret OP Slap path not found!")
		end

		warn("🛠️ All proximity prompts fired: Tools + OP Slap.")
	end
end)
