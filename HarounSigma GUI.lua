--[[
COMPLETE SECRET SLAP TABLET GUI v2.3
Features:
- Fixed customization GUI spacing
- View/UnView spectate system
- /panel chat command
- Tablet-optimized UI
- All previous functionality
- Fun/UnFun buttons for SecretSlap stats
]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

-- State Variables
local looping = false
local loopConnection = nil
local currentAction = nil
local chatHook = nil
local spectating = false
local originalCamera = nil
local currentSpectateTarget = nil

-- Main GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SecretSlapGUI_Tablet"
gui.Enabled = true

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 520)
frame.Position = UDim2.new(0.5, -250, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Text = "Server GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0.2, 0, 1, 0)
closeBtn.Position = UDim2.new(0.8, 0, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold

-- Input Box
local box = Instance.new("TextBox", frame)
box.PlaceholderText = "Enter name, 'all', or 'random'"
box.Size = UDim2.new(1, -40, 0, 50)
box.Position = UDim2.new(0, 20, 0, 50)
box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
box.TextColor3 = Color3.new(1, 1, 1)
box.TextScaled = true
box.Font = Enum.Font.Gotham
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- Button Grid
local buttons = {}
local buttonNames = {
    "Slap", "Kill", "Goto", 
    "LoopSlap", "UnLoopSlap", "End", 
    "SecretSlap", "TpTroll", "View", "UnView",
    "Fun", "UnFun", "NoCD", "UnNoCD"
}
local positions = {
    UDim2.new(0, 20, 0, 110), UDim2.new(0, 180, 0, 110), UDim2.new(0, 340, 0, 110),
    UDim2.new(0, 20, 0, 180), UDim2.new(0, 180, 0, 180), UDim2.new(0, 340, 0, 180),
    UDim2.new(0, 20, 0, 250), UDim2.new(0, 180, 0, 250),
    UDim2.new(0, 340, 0, 250), UDim2.new(0, 340, 0, 320),
    UDim2.new(0, 20, 0, 320), UDim2.new(0, 180, 0, 320),
    UDim2.new(0, 20, 0, 390), UDim2.new(0, 180, 0, 390)
}

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Text = name
    btn.Size = UDim2.new(0, 150, 0, 60)
    btn.Position = positions[i]
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    buttons[name] = btn
end

-- FIXED CUSTOMIZATION GUI (Properly Spaced)
local customGui = Instance.new("Frame", gui)
customGui.Size = UDim2.new(0, 500, 0, 400)
customGui.Position = UDim2.new(0.5, -250, 0.5, -200)
customGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
customGui.Visible = false
customGui.Active = true
customGui.Draggable = true
Instance.new("UICorner", customGui).CornerRadius = UDim.new(0, 12)

-- Custom Title Bar
local customTitleBar = Instance.new("Frame", customGui)
customTitleBar.Size = UDim2.new(1, 0, 0, 40)
customTitleBar.BackgroundTransparency = 1

local customTitle = Instance.new("TextLabel", customTitleBar)
customTitle.Size = UDim2.new(0.8, 0, 1, 0)
customTitle.Text = "CUSTOMIZATION"
customTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
customTitle.BackgroundTransparency = 1
customTitle.TextScaled = true
customTitle.Font = Enum.Font.GothamBold

local customCloseBtn = Instance.new("TextButton", customTitleBar)
customCloseBtn.Size = UDim2.new(0.2, 0, 1, 0)
customCloseBtn.Position = UDim2.new(0.8, 0, 0, 0)
customCloseBtn.Text = "X"
customCloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
customCloseBtn.BackgroundTransparency = 1
customCloseBtn.TextScaled = true
customCloseBtn.Font = Enum.Font.GothamBold

-- Input Controls
local inputLabel = Instance.new("TextLabel", customGui)
inputLabel.Size = UDim2.new(1, -40, 0, 40)
inputLabel.Position = UDim2.new(0, 20, 0, 50)
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.BackgroundTransparency = 1
inputLabel.TextScaled = true
inputLabel.Font = Enum.Font.GothamBold

local inputBox = Instance.new("TextBox", customGui)
inputBox.Size = UDim2.new(1, -40, 0, 60)
inputBox.Position = UDim2.new(0, 20, 0, 100)
inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextScaled = true
inputBox.Font = Enum.Font.Gotham
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 8)
inputBox.ClearTextOnFocus = false

-- Delay Controls (Properly Spaced)
local delayLabel = Instance.new("TextLabel", customGui)
delayLabel.Size = UDim2.new(1, -40, 0, 40)
delayLabel.Position = UDim2.new(0, 20, 0, 180)
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.BackgroundTransparency = 1
delayLabel.TextScaled = true
delayLabel.Font = Enum.Font.GothamBold
delayLabel.Visible = false

local delayBox = Instance.new("TextBox", customGui)
delayBox.Size = UDim2.new(1, -40, 0, 60)
delayBox.Position = UDim2.new(0, 20, 0, 230)
delayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.TextScaled = true
delayBox.Font = Enum.Font.Gotham
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 8)
delayBox.ClearTextOnFocus = false
delayBox.Visible = false

-- Confirm Button (Properly Spaced)
local confirmBtn = Instance.new("TextButton", customGui)
confirmBtn.Size = UDim2.new(0.4, 0, 0, 70)
confirmBtn.Position = UDim2.new(0.3, 0, 1, -90)
confirmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.Text = "CONFIRM"
confirmBtn.TextScaled = true
confirmBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

-- Helper Functions
local function getTargets(input)
    local all = Players:GetPlayers()
    local targets = {}
    input = input:lower()

    if input == "all" then
        for _, p in ipairs(all) do
            if p ~= LocalPlayer then
                table.insert(targets, p)
            end
        end
    elseif input == "random" then
        local candidates = {}
        for _, p in ipairs(all) do
            if p ~= LocalPlayer then
                table.insert(candidates, p)
            end
        end
        if #candidates > 0 then
            table.insert(targets, candidates[math.random(1, #candidates)])
        end
    else
        for _, p in ipairs(all) do
            if p ~= LocalPlayer then
                local display = p.DisplayName:lower()
                local username = p.Name:lower()
                if display:find(input, 1, true) or username:find(input, 1, true) then
                    table.insert(targets, p)
                end
            end
        end
    end

    return targets
end

local function hasSlapTool()
    return LocalPlayer.Backpack:FindFirstChild("SecretSlap") or 
           (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SecretSlap"))
end

local function equipTool()
    if not hasSlapTool() then return nil end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SecretSlap")
    if tool then return tool end
    
    tool = LocalPlayer.Backpack:FindFirstChild("SecretSlap")
    if tool then
        tool.Parent = LocalPlayer.Character
        return tool
    end
    return nil
end

local function getSlapTool()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SecretSlap")
    if not tool then
        tool = LocalPlayer.Backpack:FindFirstChild("SecretSlap")
    end
    return tool
end

local function modifyStats(power, speed, flightSpeed)
    local tool = getSlapTool()
    if not tool then
        warn("SecretSlap tool not found!")
        return
    end
    
    local powerVal = tool:FindFirstChild("Power")
    local speedVal = tool:FindFirstChild("Speed")
    local flightSpeedVal = tool:FindFirstChild("FlightSpeed")
    
    if powerVal and powerVal:IsA("NumberValue") then
        powerVal.Value = power
    end
    
    if speedVal and speedVal:IsA("NumberValue") then
        speedVal.Value = speed
    end
    
    if flightSpeedVal and flightSpeedVal:IsA("NumberValue") then
        flightSpeedVal.Value = flightSpeed
    end
end

local function slapTarget(target, force)
    if not target.Character then return end
    
    local args = {
        "slash",
        target.Character,
        Vector3.new(force, 0, force)
    }

    if currentAction == "Slap" or currentAction == "Kill" or currentAction == "LoopSlap" then
        local tool = equipTool()
        if not tool then 
            warn("SecretSlap tool not found in backpack!")
            return 
        end
        
        pcall(function()
            tool:WaitForChild("Event"):FireServer(unpack(args))
        end)
    else
        pcall(function()
            ReplicatedStorage:FindFirstChild("SlapEvent"):FireServer(unpack(args))
        end)
    end
end

local function showMainHideCustom()
    frame.Visible = true
    customGui.Visible = false
    inputBox.Text = ""
    delayBox.Text = ""
    delayLabel.Visible = false
    delayBox.Visible = false
end

local function showCustomHideMain(action)
    currentAction = action
    frame.Visible = false
    customGui.Visible = true

    if action == "Slap" then
        customTitle.Text = "SLAP CUSTOMIZATION"
        inputLabel.Text = "Force (default: 80)"
        inputBox.PlaceholderText = "Enter slap force"
        delayLabel.Visible = false
        delayBox.Visible = false
    elseif action == "LoopSlap" then
        customTitle.Text = "LOOPSLAP CUSTOMIZATION"
        inputLabel.Text = "Force (default: 20)"
        inputBox.PlaceholderText = "Enter slap force"
        delayLabel.Text = "Delay between slaps (seconds)"
        delayLabel.Visible = true
        delayBox.Visible = true
        delayBox.PlaceholderText = "Enter delay (default: 0.1)"
    end
end

local function toggleGUI()
    gui.Enabled = not gui.Enabled
end

-- Spectate Functions
local function startSpectating(target)
    if not target or not target.Character then return end
    
    originalCamera = workspace.CurrentCamera.CameraType
    workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Track
    currentSpectateTarget = target
    spectating = true
    
    StarterGui:SetCore("ResetButtonCallback", false)
    buttons["View"].Text = "VIEWING"
    buttons["View"].BackgroundColor3 = Color3.fromRGB(100, 200, 100)
end

local function stopSpectating()
    if not spectating then return end
    
    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    workspace.CurrentCamera.CameraType = originalCamera or Enum.CameraType.Custom
    currentSpectateTarget = nil
    spectating = false
    
    StarterGui:SetCore("ResetButtonCallback", true)
    buttons["View"].Text = "View"
    buttons["View"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

-- Character Handling
local function onCharacterAdded(character)
    if spectating and currentSpectateTarget and currentSpectateTarget.Character == character then
        task.wait(1)
        startSpectating(currentSpectateTarget)
    end
end

-- Chat Command
local function onChatMessage(message, recipient)
    if message:lower() == "/panel" then
        toggleGUI()
        return false
    end
end

-- Button Functions
buttons["Slap"].MouseButton1Click:Connect(function()
    if #getTargets(box.Text) == 0 then
        warn("No valid targets found")
        return
    end
    showCustomHideMain("Slap")
end)

buttons["Kill"].MouseButton1Click:Connect(function()
    local targets = getTargets(box.Text)
    for _, target in ipairs(targets) do
        slapTarget(target, math.huge)
    end
end)

buttons["Goto"].MouseButton1Click:Connect(function()
    local targets = getTargets(box.Text)
    if #targets > 0 then
        local hrp = targets[1].Character and targets[1].Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)

buttons["LoopSlap"].MouseButton1Click:Connect(function()
    if #getTargets(box.Text) == 0 then
        warn("No valid targets found")
        return
    end
    showCustomHideMain("LoopSlap")
end)

buttons["UnLoopSlap"].MouseButton1Click:Connect(function()
    if looping then
        looping = false
        buttons["LoopSlap"].Text = "LoopSlap"
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
    end
end)

buttons["End"].MouseButton1Click:Connect(function()
    if looping then
        looping = false
        buttons["LoopSlap"].Text = "LoopSlap"
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
    end
    
    stopSpectating()
    
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        myHRP.CFrame = CFrame.new(-220, 530, -1844)
    end
end)

buttons["SecretSlap"].MouseButton1Click:Connect(function()
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        myHRP.CFrame = CFrame.new(-400, 4, -1815)
    end

    task.wait(0.3)

    local promptPart = workspace:FindFirstChild("MainGame") and
        workspace.MainGame:FindFirstChild("SecretDoor") and
        workspace.MainGame.SecretDoor:FindFirstChild("OpSlap") and
        workspace.MainGame.SecretDoor.OpSlap:FindFirstChild("ProximityPrompPart") and
        workspace.MainGame.SecretDoor.OpSlap.ProximityPrompPart:FindFirstChild("???")

    if promptPart and promptPart:IsA("ProximityPrompt") then
        fireproximityprompt(promptPart)
    else
        warn("Prompt '???' not found or invalid")
    end
end)

buttons["TpTroll"].MouseButton1Click:Connect(function()
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        myHRP.CFrame = CFrame.new(-384, 154, -1872)
    end
end)

buttons["View"].MouseButton1Click:Connect(function()
    local targets = getTargets(box.Text)
    if #targets == 0 then
        warn("No valid targets found")
        return
    end
    startSpectating(targets[1])
end)

buttons["UnView"].MouseButton1Click:Connect(function()
    stopSpectating()
end)

-- NoCD/UnNoCD Button Functions
buttons["NoCD"].MouseButton1Click:Connect(function()
    local tool = getSlapTool()
    if not tool then
        warn("SecretSlap tool not found!")
        return
    end
    
    local speedVal = tool:FindFirstChild("Speed")
    if speedVal and speedVal:IsA("NumberValue") then
        speedVal.Value = 0
        buttons["NoCD"].Text = "NO CD ON"
        buttons["NoCD"].BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

buttons["UnNoCD"].MouseButton1Click:Connect(function()
    local tool = getSlapTool()
    if not tool then
        warn("SecretSlap tool not found!")
        return
    end
    
    local speedVal = tool:FindFirstChild("Speed")
    if speedVal and speedVal:IsA("NumberValue") then
        speedVal.Value = 60
        buttons["NoCD"].Text = "NoCD"
        buttons["NoCD"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)
buttons["Fun"].MouseButton1Click:Connect(function()
    modifyStats(math.huge, 0, math.huge) -- Power: inf, Speed: 0, FlightSpeed: inf
    buttons["Fun"].Text = "FUN ON"
    buttons["Fun"].BackgroundColor3 = Color3.fromRGB(100, 200, 100)
end)

buttons["UnFun"].MouseButton1Click:Connect(function()
    modifyStats(30, 60, 0.45) -- Power: 30, Speed: 60, FlightSpeed: 0.45
    buttons["Fun"].Text = "Fun"
    buttons["Fun"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

-- Close Buttons
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

customCloseBtn.MouseButton1Click:Connect(function()
    showMainHideCustom()
end)

-- Confirm Button
confirmBtn.MouseButton1Click:Connect(function()
    local targets = getTargets(box.Text)
    if #targets == 0 then
        warn("No valid targets found")
        showMainHideCustom()
        return
    end

    if currentAction == "Slap" then
        local force = tonumber(inputBox.Text) or 80
        for _, target in ipairs(targets) do
            slapTarget(target, force)
        end
    elseif currentAction == "LoopSlap" then
        local force = tonumber(inputBox.Text) or 20
        local delay = tonumber(delayBox.Text) or 0.1
        
        if loopConnection then
            loopConnection:Disconnect()
        end
        
        looping = true
        buttons["LoopSlap"].Text = "LOOPING"
        
        loopConnection = RunService.Heartbeat:Connect(function()
            if not looping then return end
            for _, target in ipairs(targets) do
                slapTarget(target, force)
            end
            task.wait(delay)
        end)
    end
    
    showMainHideCustom()
end)

-- Initialize
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if not chatHook and Players.LocalPlayer then
    chatHook = Players.LocalPlayer.Chatted:Connect(onChatMessage)
end

showMainHideCustom()
