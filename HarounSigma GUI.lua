-- Enhanced Tablet GUI with UnLoopSlap and improved customization
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI SETUP (Tablet Optimized)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SecretSlapGUI_Tablet"

-- Main Frame (larger for tablets)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 350)
frame.Position = UDim2.new(0.5, -225, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥 SecretSlap Tablet GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local box = Instance.new("TextBox", frame)
box.PlaceholderText = "Enter name, 'all', or 'random'"
box.Size = UDim2.new(1, -30, 0, 50)
box.Position = UDim2.new(0, 15, 0, 45)
box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
box.TextColor3 = Color3.new(1, 1, 1)
box.TextScaled = true
box.Font = Enum.Font.Gotham
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- Button Creation
local buttons = {}
local buttonNames = {"Slap", "Kill", "Goto", "LoopSlap", "UnLoopSlap", "End", "???", "TpTroll"}
local positions = {
    UDim2.new(0, 15, 0, 105),
    UDim2.new(0, 165, 0, 105),
    UDim2.new(0, 315, 0, 105),
    UDim2.new(0, 15, 0, 165),
    UDim2.new(0, 165, 0, 165),
    UDim2.new(0, 315, 0, 165),
    UDim2.new(0, 15, 0, 225),
    UDim2.new(0, 165, 0, 225)
}

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Text = name
    btn.Size = UDim2.new(0, 120, 0, 50)
    btn.Position = positions[i]
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    buttons[name] = btn
end

-- CUSTOMIZATION GUI
local customGui = Instance.new("Frame", gui)
customGui.Size = UDim2.new(0, 450, 0, 250)
customGui.Position = UDim2.new(0.5, -225, 0.5, -125)
customGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
customGui.Visible = false
customGui.Active = true
customGui.Draggable = true
Instance.new("UICorner", customGui).CornerRadius = UDim.new(0, 12)

local customTitle = Instance.new("TextLabel", customGui)
customTitle.Size = UDim2.new(1, 0, 0, 40)
customTitle.Position = UDim2.new(0, 0, 0, 10)
customTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
customTitle.BackgroundTransparency = 1
customTitle.TextScaled = true
customTitle.Font = Enum.Font.GothamBold

local inputLabel = Instance.new("TextLabel", customGui)
inputLabel.Size = UDim2.new(1, -30, 0, 30)
inputLabel.Position = UDim2.new(0, 15, 0, 60)
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.BackgroundTransparency = 1
inputLabel.TextScaled = true
inputLabel.Font = Enum.Font.GothamBold

local inputBox = Instance.new("TextBox", customGui)
inputBox.Size = UDim2.new(1, -30, 0, 50)
inputBox.Position = UDim2.new(0, 15, 0, 95)
inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextScaled = true
inputBox.Font = Enum.Font.Gotham
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 8)
inputBox.ClearTextOnFocus = false

local delayLabel = Instance.new("TextLabel", customGui)
delayLabel.Size = UDim2.new(1, -30, 0, 30)
delayLabel.Position = UDim2.new(0, 15, 0, 155)
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.BackgroundTransparency = 1
delayLabel.TextScaled = true
delayLabel.Font = Enum.Font.GothamBold
delayLabel.Visible = false

local delayBox = Instance.new("TextBox", customGui)
delayBox.Size = UDim2.new(1, -30, 0, 50)
delayBox.Position = UDim2.new(0, 15, 0, 190)
delayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.TextScaled = true
delayBox.Font = Enum.Font.Gotham
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 8)
delayBox.ClearTextOnFocus = false
delayBox.Visible = false

local confirmBtn = Instance.new("TextButton", customGui)
confirmBtn.Size = UDim2.new(0, 150, 0, 60)
confirmBtn.Position = UDim2.new(0.5, -75, 1, -70)
confirmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.Text = "CONFIRM"
confirmBtn.TextScaled = true
confirmBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

-- Variables
local looping = false
local loopConnection = nil
local currentAction = nil

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
                if display:sub(1, #input) == input or username:sub(1, #input) == input then
                    table.insert(targets, p)
                    break
                end
            end
        end
    end

    return targets
end

local function equipTool()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SecretSlap")
    if tool then
        return tool
    end
    tool = LocalPlayer.Backpack:FindFirstChild("SecretSlap")
    if tool then
        tool.Parent = LocalPlayer.Character
        return tool
    end
    return nil
end

local function slapTarget(target, force)
    local tool = equipTool()
    if not tool or not target.Character then return end

    local args = {
        "slash",
        target.Character,
        Vector3.new(force, 0, force)
    }

    pcall(function()
        tool:WaitForChild("Event"):FireServer(unpack(args))
    end)
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

-- BUTTON FUNCTIONS
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
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        myHRP.CFrame = CFrame.new(-220, 530, -1844)
    end
end)

buttons["???"].MouseButton1Click:Connect(function()
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

-- Confirm Button Logic
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

-- Initialize GUI
showMainHideCustom()
