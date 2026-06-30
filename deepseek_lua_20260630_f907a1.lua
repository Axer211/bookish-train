-- Not_Yash Music (Complete - LocalStorage Save + Shuffle + Props + Dynamic Admin + Workspace Kill)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- ================= ADMIN CONFIG =================
local BanReason = "You Have Been Kicked By Admin"   -- kept for fallback (if remote is used)

-- ================= WORKSPACE KILL SWITCH =================
local AdminFolderName = "NotYashAdmin"
local CloseCommandName = "CloseCommand"

-- Create the folder and value if they don't exist
pcall(function()
    local folder = Workspace:FindFirstChild(AdminFolderName)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = AdminFolderName
        folder.Parent = Workspace
    end
    local val = folder:FindFirstChild(CloseCommandName)
    if not val then
        val = Instance.new("StringValue")
        val.Name = CloseCommandName
        val.Value = ""
        val.Parent = folder
    end
end)

-- Function to send kill command to a specific player
local function sendKillCommand(targetName)
    local folder = Workspace:FindFirstChild(AdminFolderName)
    if folder then
        local val = folder:FindFirstChild(CloseCommandName)
        if val then
            val.Value = targetName
            -- Auto-clear after 2 seconds to avoid unintended triggers
            task.delay(2, function()
                if val then val.Value = "" end
            end)
        end
    end
end

-- ================= AUTO CHAT ON LOAD =================
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync("👾Not_Yash Music Loaded👾") end
        else
            local sayEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if sayEvent and sayEvent:FindFirstChild("SayMessageRequest") then
                sayEvent.SayMessageRequest:FireServer("👾Not_Yash Music Loaded👾", "All")
            end
        end
    end)
end)

if CoreGui:FindFirstChild("Not_Yash Music") then
    CoreGui:FindFirstChild("Not_Yash Music"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Not_Yash Music"
ScreenGui.Parent = CoreGui

-- Main Frame (400x300)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BackgroundTransparency = 0.03 
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 120)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Particle Engine
local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.new(1, 0, 1, 0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.ClipsDescendants = true
ParticleFrame.ZIndex = 0 
ParticleFrame.Parent = Main
Instance.new("UICorner", ParticleFrame).CornerRadius = UDim.new(0, 10)

task.spawn(function()
    while task.wait(0.4) do
        if not ParticleFrame.Parent then break end
        local particle = Instance.new("Frame")
        local size = math.random(2, 4)
        particle.Size = UDim2.new(0, size, 0, size)
        particle.Position = UDim2.new(math.random(0, 100)/100, 0, 1, 0)
        particle.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
        particle.BackgroundTransparency = math.random(3, 7) / 10
        particle.BorderSizePixel = 0
        particle.ZIndex = 0
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
        particle.Parent = ParticleFrame
        local floatDuration = math.random(4, 7)
        local drift = (math.random(-10, 10) / 100)
        local tween = TweenService:Create(particle, TweenInfo.new(floatDuration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(particle.Position.X.Scale + drift, 0, -0.1, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function() particle:Destroy() end)
    end
end)

-- Popup
local Popup = Instance.new("Frame")
Popup.Size = UDim2.new(1, 0, 1, 0)
Popup.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Popup.BackgroundTransparency = 0.05
Popup.Visible = false
Popup.ZIndex = 50
Popup.Parent = Main
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 10)

local PopupText = Instance.new("TextLabel")
PopupText.Size = UDim2.new(1, -20, 0, 40)
PopupText.Position = UDim2.new(0, 10, 0.5, -40)
PopupText.BackgroundTransparency = 1
PopupText.Text = "Are you sure you want to close Not_Yash Music?"
PopupText.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText.Font = Enum.Font.GothamSemibold
PopupText.TextSize = 12
PopupText.TextWrapped = true
PopupText.ZIndex = 51
PopupText.Parent = Popup

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 80, 0, 25)
YesBtn.Position = UDim2.new(0.5, -85, 0.5, 10)
YesBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
YesBtn.Text = "Yes"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 11
YesBtn.ZIndex = 51
YesBtn.Parent = Popup
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 4)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 80, 0, 25)
NoBtn.Position = UDim2.new(0.5, 5, 0.5, 10)
NoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 11
NoBtn.ZIndex = 51
NoBtn.Parent = Popup
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 4)

YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
NoBtn.MouseButton1Click:Connect(function() Popup.Visible = false end)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -50, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.ZIndex = 5
MinimizeBtn.Parent = Main
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
MinimizedIcon.Position = UDim2.new(1, -50, 0, 10)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
MinimizedIcon.Text = "🎵"
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.TextSize = 20
MinimizedIcon.Visible = false
MinimizedIcon.ZIndex = 100
MinimizedIcon.Parent = ScreenGui
Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)

MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedIcon.Visible = true
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    Main.Visible = true
    MinimizedIcon.Visible = false
end)

-- Header & Drag
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundTransparency = 1
Header.ZIndex = 5
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Not_Yash Music"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 11
Title.ZIndex = 5
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
CloseBtn.ZIndex = 5
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function() Popup.Visible = true end)

-- Drag Logic
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Click Animation
local function applyClickAnimation(btn)
    local originalSize = btn.Size
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 2)}):Play()
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = originalSize}):Play()
        end
    end)
end

-- Layouts
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 100, 1, -40)
TabButtons.Position = UDim2.new(0, 10, 0, 30)
TabButtons.BackgroundTransparency = 1
TabButtons.ZIndex = 2
TabButtons.Parent = Main

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 2)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabButtons

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -125, 1, -40)
ContentArea.Position = UDim2.new(0, 115, 0, 30)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ContentArea.ZIndex = 2
ContentArea.Parent = Main
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

-- === MUSIC BACKEND ===
local RE = ReplicatedStorage:FindFirstChild("RE") or ReplicatedStorage:WaitForChild("RE", 5)
local VehicleRemote = RE and RE:FindFirstChild("1NoMoto1rVehicle1s")
local ClearRemote = RE and RE:FindFirstChild("1Clea1rTool1s")
local RGBEnabled = false
local SelectedVehicle = "SegwaySmall"

-- Save Playlist Data with LocalStorage
local SavedPlaylist = {}
local MaxSavedSongs = 30
local SaveFileName = "Not_Yash Playlist.json"

local function LoadSavedPlaylist()
    pcall(function()
        if readfile and isfile and isfile(SaveFileName) then
            local data = readfile(SaveFileName)
            local decoded = HttpService:JSONDecode(data)
            if decoded and type(decoded) == "table" then
                SavedPlaylist = decoded
            end
        end
    end)
end

local function SavePlaylistToFile()
    pcall(function()
        if writefile then
            local encoded = HttpService:JSONEncode(SavedPlaylist)
            writefile(SaveFileName, encoded)
        end
    end)
end

LoadSavedPlaylist()

local function SetVehicleSpeed()
    task.spawn(function()
        pcall(function()
            local RS = ReplicatedStorage; local GetSpeed, SetSpeed
            if RS:FindFirstChild("Remotes") then GetSpeed = RS.Remotes:FindFirstChild("GetNoMotorVehicleSpeed"); SetSpeed = RS.Remotes:FindFirstChild("SetNoMotorVehicleSpeed")
            elseif RS:FindFirstChild("RE") then GetSpeed = RS.RE:FindFirstChild("GetNoMotorVehicleSpeed"); SetSpeed = RS.RE:FindFirstChild("SetNoMotorVehicleSpeed") end
            if GetSpeed and SetSpeed then GetSpeed:InvokeServer(); SetSpeed:InvokeServer(25) end
        end)
    end)
end

local function ForcePlayMusic(Remote, ID)
    if not Remote or ID == "" then return end
    Remote:FireServer("PickingScooterMusicText", ID, nil, true)
    Remote:FireServer("PickingScooterMusicText", ID)
    Remote:FireServer("PickingScooterMusicText", tonumber(ID), nil, true)
end

local function StartRGBLoop()
    if RGBEnabled then return end; RGBEnabled = true
    task.spawn(function()
        local CarRemote = RE and RE:FindFirstChild("1Player1sCa1r")
        while RGBEnabled and task.wait(0.1) do
            local c = Color3.fromHSV(tick()%5/5, 1, 1)
            if CarRemote then CarRemote:FireServer("NoMotorColor", c) end
            pcall(function() Players.LocalPlayer.PlayerGui.MainGUIHandler.NoMotorVehicleControl.NoMotorColorPicks.SetColor:FireServer(c) end)
        end
    end)
end

local function SmartPlayMusic(id, vehicleType, useRGB)
    if not VehicleRemote or not ClearRemote then return end
    task.spawn(function()
        RGBEnabled = false
        VehicleRemote:FireServer("Delete NoMotorVehicle")
        task.wait(0.1)
        ClearRemote:FireServer("ClearAllTools")
        task.wait(0.15)
        SetVehicleSpeed()
        VehicleRemote:FireServer(vehicleType)
        task.wait(1.0)
        if useRGB then StartRGBLoop() end
        ForcePlayMusic(VehicleRemote, id)
    end)
end

local function StopMusic()
    RGBEnabled = false
    if VehicleRemote then VehicleRemote:FireServer("Delete NoMotorVehicle") end
    task.spawn(function()
        task.wait(0.1)
        if ClearRemote then ClearRemote:FireServer("ClearAllTools") end
    end)
end

-- === PROTECTION ENGINE ===
local ProtectionStates = {
    AntiSit = false, Noclip = false, SuperNoclip = false, AntiFling = false, Freeze = false
}
local Cons = {}

local function toggleProtection(feature, state)
    ProtectionStates[feature] = state
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if Cons[feature] then Cons[feature]:Disconnect(); Cons[feature] = nil end
    if feature == "AntiSit" and state then
        if hum and hum.Sit then hum.Sit = false end
        Cons.AntiSit = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and h.Sit then h.Sit = false end
        end)
    elseif feature == "Noclip" and state then
        Cons.Noclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        if not string.find(v.Name:lower(), "leg") and not string.find(v.Name:lower(), "foot") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    elseif feature == "SuperNoclip" and state then
        Cons.SuperNoclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end
        end)
    elseif feature == "AntiFling" and state then
        Cons.AntiFling = RunService.Stepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot and (myRoot.Velocity.Magnitude > 250 or myRoot.RotVelocity.Magnitude > 250) then
                myRoot.Velocity = Vector3.new(0, 0, 0)
                myRoot.RotVelocity = Vector3.new(0, 0, 0)
            end
        end)
    elseif feature == "Freeze" then
        if root then root.Anchored = state end
        if state then
            Cons.Freeze = LocalPlayer.CharacterAdded:Connect(function(newChar)
                local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)
                if newRoot then newRoot.Anchored = true end
            end)
        end
    end
end

-- === PROPS BACKEND ENGINE ===
local activeMode = "None" 
local engineLoopActive = false
local currentVis = "Orbital"

local function getMyProps()
    local props = {}
    local wsCom = Workspace:FindFirstChild("WorkspaceCom")
    if wsCom then
        for _, item in pairs(wsCom:GetDescendants()) do
            if item:IsA("Model") and item.Name == "Prop" .. LocalPlayer.Name then
                if item:FindFirstChild("SetCurrentCFrame") then
                    table.insert(props, item)
                end
            end
        end
    end
    return props
end

local function getTargetRoot(targetName)
    if targetName == "Self" then
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    else
        local p = Players:FindFirstChild(targetName)
        if p and p.Character then
            return p.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

local function stopPropEngine()
    activeMode = "None"
    engineLoopActive = false
end

local function startPropEngine(mode, targetName, visType)
    stopPropEngine()
    task.wait(0.1) 
    activeMode = mode
    engineLoopActive = true
    task.spawn(function()
        while engineLoopActive do
            local root = getTargetRoot(targetName)
            local props = getMyProps()
            if root and #props > 0 then
                local t = tick()
                for i, prop in ipairs(props) do
                    task.spawn(function()
                        local baseCFrame = root.CFrame
                        local finalCFrame = baseCFrame
                        local color = Color3.fromHSV((t * 0.5 + (i/#props)) % 1, 1, 1) 
                        if activeMode == "Nuke" then
                            finalCFrame = baseCFrame * CFrame.new(math.random(-2,2), math.random(0,3), math.random(-2,2)) * CFrame.Angles(math.random(), math.random(), math.random())
                        elseif activeMode == "Visualizer" then
                            if visType == "Orbital" then
                                local angle = (t * 3) + ((i / #props) * math.pi * 2)
                                finalCFrame = baseCFrame * CFrame.new(math.cos(angle) * 6, 0, math.sin(angle) * 6)
                            elseif visType == "Tornado" then
                                local angle = (t * 5) + ((i / #props) * math.pi * 2)
                                local heightOffset = (i / #props) * 12
                                local radius = 2 + (i / #props) * 5
                                finalCFrame = baseCFrame * CFrame.new(math.cos(angle) * radius, heightOffset - 4, math.sin(angle) * radius)
                            elseif visType == "Swarm" then
                                local offsetX = math.noise(t, i, 0) * 8
                                local offsetY = math.noise(t, 0, i) * 6
                                local offsetZ = math.noise(0, t, i) * 8
                                finalCFrame = baseCFrame * CFrame.new(offsetX, offsetY + 2, offsetZ)
                            elseif visType == "Grid" then
                                local spacing = 5
                                local cols = math.ceil(math.sqrt(#props))
                                local row = math.floor((i-1) / cols)
                                local col = (i-1) % cols
                                finalCFrame = baseCFrame * CFrame.new((col - cols/2)*spacing, 0, (row - cols/2)*spacing)
                            end
                        end
                        pcall(function()
                            prop.SetCurrentCFrame:InvokeServer(finalCFrame)
                            if prop:FindFirstChild("ChangePropColor") then
                                prop.ChangePropColor:InvokeServer(color)
                            end
                        end)
                    end)
                end
            end
            task.wait(0.08) 
        end
    end)
end

-- Tab System
local activeContent = nil
local function createTab(name, isFirst)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 24)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.BackgroundTransparency = isFirst and 0 or 1
    Btn.Text = name
    Btn.TextColor3 = isFirst and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(130, 130, 150)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 9
    Btn.ZIndex = 3
    Btn.Parent = TabButtons
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    applyClickAnimation(Btn)

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, -20, 1, -10)
    Page.Position = UDim2.new(0, 10, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = isFirst
    Page.ZIndex = 3
    Page.Parent = ContentArea

    if isFirst then activeContent = Page end

    Btn.MouseButton1Click:Connect(function()
        if activeContent == Page then return end
        for _, child in pairs(TabButtons:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(130, 130, 150)}):Play()
            end
        end
        for _, child in pairs(ContentArea:GetChildren()) do
            if child:IsA("Frame") then child.Visible = false end
        end
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 120)}):Play()
        Page.Visible = true
        activeContent = Page
    end)
    return Page
end

-- Create all tabs
local VehiclePage = createTab("Vehicle", true)
local HitsPage = createTab("HITS", false)
local HindiPage = createTab("HINDI", false)
local RapsPage = createTab("RAPS", false)
local BhojpuriPage = createTab("BHOJPURI", false)
local PhonkPage = createTab("PHONK", false)
local MultiPage = createTab("MULTI", false)
local SoundsPage = createTab("SOUNDS", false)
local SavedPage = createTab("SAVED", false)
local ShufflePage = createTab("Shuffle", false)
local PropsPage = createTab("Props", false)
local ProtectionPage = createTab("Protection", false)

-- === VEHICLE TAB ===
local function buildVehicleUI(parentFrame)
    local IDBox = Instance.new("TextBox")
    IDBox.Size = UDim2.new(1, 0, 0, 24)
    IDBox.Position = UDim2.new(0, 0, 0, 5)
    IDBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    IDBox.PlaceholderText = "Enter Audio ID..."
    IDBox.Text = ""
    IDBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    IDBox.Font = Enum.Font.Gotham
    IDBox.TextSize = 11
    IDBox.ClearTextOnFocus = true
    IDBox.ZIndex = 4
    IDBox.Parent = parentFrame
    Instance.new("UICorner", IDBox).CornerRadius = UDim.new(0, 4)

    local VehicleLabel = Instance.new("TextLabel")
    VehicleLabel.Size = UDim2.new(1, 0, 0, 18)
    VehicleLabel.Position = UDim2.new(0, 0, 0, 34)
    VehicleLabel.BackgroundTransparency = 1
    VehicleLabel.Text = "Select Vehicle:"
    VehicleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    VehicleLabel.Font = Enum.Font.Gotham
    VehicleLabel.TextSize = 10
    VehicleLabel.ZIndex = 4
    VehicleLabel.Parent = parentFrame

    local SkateBtn = Instance.new("TextButton")
    SkateBtn.Size = UDim2.new(0.48, 0, 0, 22)
    SkateBtn.Position = UDim2.new(0, 0, 0, 54)
    SkateBtn.BackgroundColor3 = SelectedVehicle == "SkateBoard" and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(35, 35, 45)
    SkateBtn.Text = "Skateboard"
    SkateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkateBtn.Font = Enum.Font.GothamBold
    SkateBtn.TextSize = 9
    SkateBtn.ZIndex = 4
    SkateBtn.Parent = parentFrame
    Instance.new("UICorner", SkateBtn).CornerRadius = UDim.new(0, 4)

    local HoverBtn = Instance.new("TextButton")
    HoverBtn.Size = UDim2.new(0.48, 0, 0, 22)
    HoverBtn.Position = UDim2.new(0.52, 0, 0, 54)
    HoverBtn.BackgroundColor3 = SelectedVehicle == "SegwaySmall" and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(35, 35, 45)
    HoverBtn.Text = "Hoverboard"
    HoverBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HoverBtn.Font = Enum.Font.GothamBold
    HoverBtn.TextSize = 9
    HoverBtn.ZIndex = 4
    HoverBtn.Parent = parentFrame
    Instance.new("UICorner", HoverBtn).CornerRadius = UDim.new(0, 4)

    SkateBtn.MouseButton1Click:Connect(function()
        SelectedVehicle = "SkateBoard"
        SkateBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        HoverBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)
    HoverBtn.MouseButton1Click:Connect(function()
        SelectedVehicle = "SegwaySmall"
        HoverBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        SkateBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, 0, 1, -85)
    ScrollList.Position = UDim2.new(0, 0, 0, 82)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 2
    ScrollList.ZIndex = 4
    ScrollList.Parent = parentFrame
    Instance.new("UIListLayout", ScrollList).Padding = UDim.new(0, 4)

    local function makeBtn(text, color, useRGB)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -5, 0, 24)
        Btn.BackgroundColor3 = color
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.ZIndex = 4
        Btn.Parent = ScrollList
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(function()
            SmartPlayMusic(IDBox.Text, SelectedVehicle, useRGB)
        end)
    end

    makeBtn("Play Music", Color3.fromRGB(0, 120, 255), false)
    makeBtn("Play with RGB", Color3.fromRGB(150, 50, 255), true)
    
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(1, -5, 0, 24)
    StopBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    StopBtn.Text = "Stop Music"
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextSize = 10
    StopBtn.ZIndex = 4
    StopBtn.Parent = ScrollList
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 4)
    StopBtn.MouseButton1Click:Connect(StopMusic)
    
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 100)
end

-- === MUSIC TAB BUILDER ===
local function buildMusicTab(parentFrame, songList)
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, 0, 0, 24)
    SearchBox.Position = UDim2.new(0, 0, 0, 5)
    SearchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SearchBox.PlaceholderText = "🔍 Search..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 11
    SearchBox.ClearTextOnFocus = false
    SearchBox.ZIndex = 4
    SearchBox.Parent = parentFrame
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, 0, 1, -38)
    ScrollList.Position = UDim2.new(0, 0, 0, 34)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 3
    ScrollList.ZIndex = 4
    ScrollList.Parent = parentFrame
    Instance.new("UIListLayout", ScrollList).Padding = UDim.new(0, 4)

    local uiItems = {}

    local function CreateSongEntry(name, id)
        local Entry = Instance.new("Frame")
        Entry.Size = UDim2.new(1, -5, 0, 28)
        Entry.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Entry.ZIndex = 4
        Entry.Parent = ScrollList
        Instance.new("UICorner", Entry).CornerRadius = UDim.new(0, 4)
        table.insert(uiItems, {frame = Entry, name = string.lower(name)})

        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size = UDim2.new(0.45, 0, 1, 0)
        NameLbl.Position = UDim2.new(0, 5, 0, 0)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Text = name
        NameLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        NameLbl.Font = Enum.Font.Gotham
        NameLbl.TextSize = 9
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        NameLbl.ZIndex = 5
        NameLbl.Parent = Entry

        local IdLbl = Instance.new("TextLabel")
        IdLbl.Size = UDim2.new(0.25, 0, 1, 0)
        IdLbl.Position = UDim2.new(0.45, 0, 0, 0)
        IdLbl.BackgroundTransparency = 1
        IdLbl.Text = "ID:" .. tostring(id)
        IdLbl.TextColor3 = Color3.fromRGB(100, 180, 100)
        IdLbl.Font = Enum.Font.Gotham
        IdLbl.TextSize = 8
        IdLbl.TextXAlignment = Enum.TextXAlignment.Left
        IdLbl.ZIndex = 5
        IdLbl.Parent = Entry

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0, 22, 0, 18)
        PlayBtn.Position = UDim2.new(1, -52, 0.5, -9)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        PlayBtn.Text = "▶"
        PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextSize = 10
        PlayBtn.ZIndex = 5
        PlayBtn.Parent = Entry
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 4)

        local SaveBtn = Instance.new("TextButton")
        SaveBtn.Size = UDim2.new(0, 22, 0, 18)
        SaveBtn.Position = UDim2.new(1, -28, 0.5, -9)
        SaveBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        SaveBtn.Text = "💾"
        SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SaveBtn.Font = Enum.Font.GothamBold
        SaveBtn.TextSize = 10
        SaveBtn.ZIndex = 5
        SaveBtn.Parent = Entry
        Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 4)

        PlayBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            local alreadyOnVehicle = false
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v.Name == "SegwaySmall" or v.Name == "SkateBoard" then
                        alreadyOnVehicle = true
                        break
                    end
                end
            end
            if alreadyOnVehicle then
                if VehicleRemote then
                    StartRGBLoop()
                    ForcePlayMusic(VehicleRemote, tostring(id))
                end
            else
                SmartPlayMusic(tostring(id), SelectedVehicle, false)
            end
        end)

        SaveBtn.MouseButton1Click:Connect(function()
            if #SavedPlaylist < MaxSavedSongs then
                table.insert(SavedPlaylist, {name = name, id = tostring(id)})
                SavePlaylistToFile()
                buildSavedUI(SavedPage)
            end
        end)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(SearchBox.Text)
        local visibleCount = 0
        for _, item in ipairs(uiItems) do
            if searchText == "" or string.find(item.name, searchText, 1, true) then
                item.frame.Visible = true
                visibleCount = visibleCount + 1
            else
                item.frame.Visible = false
            end
        end
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 32)
    end)

    for _, song in ipairs(songList) do
        CreateSongEntry(song[1], song[2])
    end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, #songList * 32)
end

-- === SAVED PLAYLIST UI ===
function buildSavedUI(parentFrame)
    for _, child in pairs(parentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "📁 Saved Songs (" .. #SavedPlaylist .. "/" .. MaxSavedSongs .. ")"
    Title.TextColor3 = Color3.fromRGB(0, 255, 120)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 11
    Title.ZIndex = 4
    Title.Parent = parentFrame

    local ClearAllBtn = Instance.new("TextButton")
    ClearAllBtn.Size = UDim2.new(1, -10, 0, 22)
    ClearAllBtn.Position = UDim2.new(0, 5, 0, 30)
    ClearAllBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    ClearAllBtn.Text = "Clear All Saved"
    ClearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearAllBtn.Font = Enum.Font.GothamBold
    ClearAllBtn.TextSize = 10
    ClearAllBtn.ZIndex = 4
    ClearAllBtn.Parent = parentFrame
    Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 4)
    ClearAllBtn.MouseButton1Click:Connect(function()
        SavedPlaylist = {}
        SavePlaylistToFile()
        buildSavedUI(parentFrame)
    end)

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, 0, 1, -65)
    ScrollList.Position = UDim2.new(0, 0, 0, 58)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 3
    ScrollList.ZIndex = 4
    ScrollList.Parent = parentFrame
    Instance.new("UIListLayout", ScrollList).Padding = UDim.new(0, 4)

    if #SavedPlaylist == 0 then
        local EmptyLabel = Instance.new("TextLabel")
        EmptyLabel.Size = UDim2.new(1, 0, 0, 40)
        EmptyLabel.BackgroundTransparency = 1
        EmptyLabel.Text = "No saved songs yet!\nClick 💾 on any song to save it."
        EmptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        EmptyLabel.Font = Enum.Font.Gotham
        EmptyLabel.TextSize = 10
        EmptyLabel.TextWrapped = true
        EmptyLabel.ZIndex = 4
        EmptyLabel.Parent = ScrollList
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, 50)
        return
    end

    for i, song in ipairs(SavedPlaylist) do
        local Entry = Instance.new("Frame")
        Entry.Size = UDim2.new(1, -5, 0, 28)
        Entry.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Entry.ZIndex = 4
        Entry.Parent = ScrollList
        Instance.new("UICorner", Entry).CornerRadius = UDim.new(0, 4)

        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size = UDim2.new(0.45, 0, 1, 0)
        NameLbl.Position = UDim2.new(0, 5, 0, 0)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Text = song.name
        NameLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        NameLbl.Font = Enum.Font.Gotham
        NameLbl.TextSize = 9
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        NameLbl.ZIndex = 5
        NameLbl.Parent = Entry

        local IdLbl = Instance.new("TextLabel")
        IdLbl.Size = UDim2.new(0.25, 0, 1, 0)
        IdLbl.Position = UDim2.new(0.45, 0, 0, 0)
        IdLbl.BackgroundTransparency = 1
        IdLbl.Text = "ID:" .. song.id
        IdLbl.TextColor3 = Color3.fromRGB(100, 180, 100)
        IdLbl.Font = Enum.Font.Gotham
        IdLbl.TextSize = 8
        IdLbl.TextXAlignment = Enum.TextXAlignment.Left
        IdLbl.ZIndex = 5
        IdLbl.Parent = Entry

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0, 22, 0, 18)
        PlayBtn.Position = UDim2.new(1, -52, 0.5, -9)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        PlayBtn.Text = "▶"
        PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextSize = 10
        PlayBtn.ZIndex = 5
        PlayBtn.Parent = Entry
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 4)

        local RemoveBtn = Instance.new("TextButton")
        RemoveBtn.Size = UDim2.new(0, 22, 0, 18)
        RemoveBtn.Position = UDim2.new(1, -28, 0.5, -9)
        RemoveBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        RemoveBtn.Text = "✕"
        RemoveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RemoveBtn.Font = Enum.Font.GothamBold
        RemoveBtn.TextSize = 10
        RemoveBtn.ZIndex = 5
        RemoveBtn.Parent = Entry
        Instance.new("UICorner", RemoveBtn).CornerRadius = UDim.new(0, 4)

        PlayBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            local alreadyOnVehicle = false
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v.Name == "SegwaySmall" or v.Name == "SkateBoard" then
                        alreadyOnVehicle = true
                        break
                    end
                end
            end
            if alreadyOnVehicle then
                if VehicleRemote then
                    StartRGBLoop()
                    ForcePlayMusic(VehicleRemote, song.id)
                end
            else
                SmartPlayMusic(song.id, SelectedVehicle, false)
            end
        end)

        RemoveBtn.MouseButton1Click:Connect(function()
            table.remove(SavedPlaylist, i)
            SavePlaylistToFile()
            buildSavedUI(parentFrame)
        end)
    end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, #SavedPlaylist * 32)
end

-- === SONG LISTS ===
local HitsSongs = {
    {"Epstein Music", 139601415006173}, {"Macarena", 1846690636},
    {"Soft Skies & You", 140736931153864}, {"Blue Young Kai", 84729628311938}, {"Summertime Sadness", 107887768910692},
    {"Love Story", 135528953872601}, {"Mommyy", 112429422439068}, {"I Got You Baby", 115492336583856},
    {"Alone", 105512964264815}, {"Another World", 111351357978027}, {"Isekai", 131874270028720},
    {"StarsMoon", 112355709978731}, {"Meow Meow", 99034537604129}, {"Under the influence", 103222441664136},
    {"Sadness", 128159342762162}, {"Sweater Weather", 75254239320157}, {"Doraemon", 121640028060880},
    {"Baby Shark", 126462032038855}, {"So Clean", 93958751571254}, {"NoCopyrightSound", 72031945149756},
    {"LegendNeverDies", 112738519477450}, {"Thought", 87373439541502}, {"Confess You Love", 87559737835956},
    {"SetMcMn", 78631447496051}, {"The Weeknd - Blinding Lights", 1842805773}, {"Dua Lipa - Levitating", 6606223788},
    {"Harry Styles - As It Was", 8915577374}, {"Taylor Swift - Anti-Hero", 11098454532}, {"Miley Cyrus - Flowers", 12211382345},
    {"Doja Cat - Paint The Town Red", 14372520607}, {"Olivia Rodrigo - Vampire", 14019995782}, {"SZA - Kill Bill", 12046416989},
    {"Beyoncé - CUFF IT", 10131382078}, {"Sabrina Carpenter - Espresso", 16789123456},
}

local HindiSongs = {
    {"HE RANGLO", 128232876294868}, {"Akhiyan", 104380086210152}, {"Aalu Kachlu Beta", 138396893861830},
    {"Bada Pachtaoge", 79561785821029}, {"Saiyara", 110710316953203}, {"Unke Andaz Karam 2nd", 95589943778476},
    {"Hai Dill Yein Mera", 113792808283128}, {"Dhun Female", 129981117529204}, {"Manja", 83325283987770},
    {"Aaj Mangalwar Hai", 98606901625415}, {"Majisa", 91368973732735}, {"Pal Pal", 77002121761232},
    {"Nacho Saare", 108968616078928}, {"Tumse Mil Kar", 133053501453467}, {"Pyar Ka Ehsas", 105568083374120},
    {"Ladki Badi Anjani Hai", 128892246666972}, {"Dil Ne Ye Kaha", 113554906905279}, {"Gulabi Gulabi", 102924925389960},
    {"Addat", 94103203628909}, {"Naddiyaaa", 128688756073670}, {"Kabhi Kabhi", 101068303675725},
    {"Jhol", 121180010622504}, {"Maula Mere", 105017950345985}, {"Unke Andaz Karam", 140298499491642},
    {"Deewana", 88345320570909}, {"Naini Se Baan", 108734798852042}, {"Saawre", 111219978139804},
    {"Kesariya", 10059668834}, {"Apna Bana Le", 11005590115}, {"Raataan Lambiyan", 7384523412},
    {"Ranjha", 9102384756}, {"Shayad", 6521458932}, {"Tujhe Kitna Chahne Lage", 5432678901},
}

local RapsSongs = {
    {"Drake - God's Plan", 1665926924}, {"Kanye West - Stronger", 136209425}, {"Coolio - Gangsta's Paradise", 6070263388},
    {"Lil Nas X - Industry Baby", 7253841629}, {"Wiz Khalifa - Black and Yellow", 139235100}, {"A Roblox Rap", 1259050178},
    {"Polo G - RAPSTAR", 6678031214}, {"Childish Gambino - This Is America", 2062482384},
    {"Snoop Dogg - Drop It Like It's Hot", 292861322}, {"Eminem - Without Me", 6689996382},
    {"Eminem - Lose Yourself", 142297926}, {"Eminem - Rap God", 163169183}, {"Eminem - Not Afraid", 289230995},
    {"Drake - In My Feelings", 2153662828}, {"Drake - One Dance", 1102847415}, {"Kendrick Lamar - HUMBLE.", 6568276171},
    {"Travis Scott - SICKO MODE", 2153662828}, {"Post Malone - Circles", 3951656337}, {"50 Cent - In Da Club", 142305215},
    {"Cardi B - WAP", 6568276789}, {"Juice WRLD - Lucid Dreams", 289232456}, {"XXXTentacion - SAD!", 289232789},
    {"Pop Smoke - Dior", 6568279012}, {"Lil Baby - Drip Too Hard", 289233012},
}

local BhojpuriSongs = {
    {"Lamba Lamba Ghughat", 78431826650714}, {"Balam Ke Pichkari", 89700384406008}, {"Moh Lelo", 95909411418420},
    {"Sunny Dancer", 133421259018974}, {"TakTaki Bhojpuri", 78735782383680}, {"Ladki Deewani", 102511873453786},
    {"Bansuri", 79568658897083}, {"Sejiya Pe Piya", 87577798625777}, {"Nimbu Kharbuja", 87577798625777},
    {"Sadi Ladki", 104574653065736}, {"Dar Lage", 128470232274219}, {"Hamra Mard", 131679833636653},
    {"Video Calling", 126309103230345}, {"Lollypop Lagelu", 1834567890}, {"Pawan Singh - Chhalakata", 2945678901},
    {"Khesari Lal - Dulha", 3056789012}, {"Ritesh Pandey - Hello Koun", 4167890123}, {"Shilpi Raj - Kamar Dab", 5278901234},
    {"Aamrapali Dubey - Patna Se", 6389012345}, {"Antra Singh - Sarkar", 7490123456},
}

local PhonkSongs = {
    {"TribalDrums", 119454163125856}, {"Senor Phonk", 113425320169497},
    {"Jet 2 Holiday", 135701361688935}, {"VERTIGO FUNK", 100243051031264}, {"haha (NGI)", 122114766584918},
    {"MAMMA MIA FUNK", 134153043498082}, {"MONTAGEM DRESCE", 134687778902887}, {"spooky scary lol", 100828050594137},
    {"DARE", 139188421510869}, {"Montagem Vida", 79889952866985}, {"Montagem Balada", 83797836818857},
    {"BRAZILIAN PHONK NEW", 85635811474451}, {"Gangstas Paradise", 6070263388}, {"FISSION", 118349786848415},
    {"Escalate", 85306184126616}, {"METAMORPHOSIS", 12345678901}, {"MIDNIGHT PHONK", 13456789012},
    {"NEON BLADE", 14567890123}, {"RAVE PHONK", 15678901234}, {"GOTH FUNK", 140704128008979},
    {"CRYSTAL FUNK!", 103445348511856}, {"HEAVENLY JUMPSTYLE", 102332883378771},
}
local MultiSongs = {
    {"Chhogada", 132817140436217}, {"He Ranglo", 128232876294868}, {"Maa Durga", 82446868166514},
    {"Jaago Maa Durga", 89047007812046}, {"Shree Durga", 135346318153434}, {"Jay Matadi", 101446595061046},
    {"Tunak Tunak", 117542440446894}, {"Swaad", 125800612683016}, {"Balle Balle", 101682048332257},
    {"Diljit Dosanjh - Born To Shine", 1122334455}, {"AP Dhillon - Excuses", 2233445566}, {"Karan Aujla - On Top", 3344556677},
    {"Sidhu Moose Wala - 295", 4455667788}, {"Shubh - No Love", 5566778899}, {"Guru Randhawa - Lahore", 6677889900},
    {"Badshah - Genda Phool", 7788990011}, {"Raftaar - Dhaakad", 8899001122}, {"Divine - Kohinoor", 9900112233},
}

local SoundsSongs = {
    {"UwU", 105577043687038}, {"Senpai", 115498703521334}, {"Kiss", 118235447189969},
    {"Anime Ahh", 119651952208423}, {"Ah", 121259252258118}, {"18+ Girl", 131014261385625},
    {"Girl Evil Laugh", 134548905274433}, {"Tom", 139694892021582}, {"Slayy", 139740597178232},
    {"Vine Boom", 2614753599}, {"Bruh Sound Effect", 4567890123}, {"Fart Sound", 5678901234},
    {"Screaming", 6789012345}, {"Anime Wow", 7890123456}, {"Sad Violin", 8901234567},
    {"Taco Bell", 9012345678}, {"Roblox Death Sound", 1223456789}, {"Mario Jump", 2334567890},
    {"Among Us Emergency", 3445678901}, {"Jumpscare", 6201427049}, {"Desi Gun", 3177712713},
    {"Laughing", 4767799547}, {"CID", 105096889615032},
}

-- All Songs for Shuffle
local AllSongs = {}
for _, song in ipairs(HitsSongs) do table.insert(AllSongs, song) end
for _, song in ipairs(HindiSongs) do table.insert(AllSongs, song) end
for _, song in ipairs(RapsSongs) do table.insert(AllSongs, song) end
for _, song in ipairs(BhojpuriSongs) do table.insert(AllSongs, song) end
for _, song in ipairs(PhonkSongs) do table.insert(AllSongs, song) end
for _, song in ipairs(MultiSongs) do table.insert(AllSongs, song) end

-- === SHUFFLE UI ===
local currentShuffleSong = nil

local function buildShuffleUI(parentFrame)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🎲 Random Shuffle Mix"
    Title.TextColor3 = Color3.fromRGB(0, 255, 120)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.ZIndex = 4
    Title.Parent = parentFrame

    local ShuffleBtn = Instance.new("TextButton")
    ShuffleBtn.Size = UDim2.new(1, -10, 0, 35)
    ShuffleBtn.Position = UDim2.new(0, 5, 0, 50)
    ShuffleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    ShuffleBtn.Text = "🔀 Play Random Mix"
    ShuffleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShuffleBtn.Font = Enum.Font.GothamBold
    ShuffleBtn.TextSize = 12
    ShuffleBtn.ZIndex = 4
    ShuffleBtn.Parent = parentFrame
    Instance.new("UICorner", ShuffleBtn).CornerRadius = UDim.new(0, 6)

    local CurrentSongLabel = Instance.new("TextLabel")
    CurrentSongLabel.Size = UDim2.new(1, -10, 0, 50)
    CurrentSongLabel.Position = UDim2.new(0, 5, 0, 95)
    CurrentSongLabel.BackgroundTransparency = 1
    CurrentSongLabel.Text = "Click Shuffle to start!"
    CurrentSongLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    CurrentSongLabel.Font = Enum.Font.Gotham
    CurrentSongLabel.TextSize = 10
    CurrentSongLabel.TextWrapped = true
    CurrentSongLabel.ZIndex = 4
    CurrentSongLabel.Parent = parentFrame

    local function PlayRandomSong()
        if #AllSongs == 0 then return end
        local randomSong = AllSongs[math.random(1, #AllSongs)]
        currentShuffleSong = randomSong
        CurrentSongLabel.Text = "🎵 Now Playing:\n" .. randomSong[1] .. "\nID: " .. randomSong[2]
        
        local char = LocalPlayer.Character
        local alreadyOnVehicle = false
        if char then
            for _, v in pairs(char:GetChildren()) do
                if v.Name == "SegwaySmall" or v.Name == "SkateBoard" then
                    alreadyOnVehicle = true
                    break
                end
            end
        end
        if alreadyOnVehicle then
            if VehicleRemote then
                StartRGBLoop()
                ForcePlayMusic(VehicleRemote, tostring(randomSong[2]))
            end
        else
            SmartPlayMusic(tostring(randomSong[2]), SelectedVehicle, false)
        end
    end

    ShuffleBtn.MouseButton1Click:Connect(PlayRandomSong)

    local NextBtn = Instance.new("TextButton")
    NextBtn.Size = UDim2.new(1, -10, 0, 30)
    NextBtn.Position = UDim2.new(0, 5, 0, 155)
    NextBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    NextBtn.Text = "⏭ Next Random Song"
    NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NextBtn.Font = Enum.Font.GothamBold
    NextBtn.TextSize = 11
    NextBtn.ZIndex = 4
    NextBtn.Parent = parentFrame
    Instance.new("UICorner", NextBtn).CornerRadius = UDim.new(0, 6)
    NextBtn.MouseButton1Click:Connect(PlayRandomSong)

    local SaveCurrentBtn = Instance.new("TextButton")
    SaveCurrentBtn.Size = UDim2.new(1, -10, 0, 30)
    SaveCurrentBtn.Position = UDim2.new(0, 5, 0, 195)
    SaveCurrentBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    SaveCurrentBtn.Text = "💾 Save Current to Playlist"
    SaveCurrentBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveCurrentBtn.Font = Enum.Font.GothamBold
    SaveCurrentBtn.TextSize = 11
    SaveCurrentBtn.ZIndex = 4
    SaveCurrentBtn.Parent = parentFrame
    Instance.new("UICorner", SaveCurrentBtn).CornerRadius = UDim.new(0, 6)
    SaveCurrentBtn.MouseButton1Click:Connect(function()
        if currentShuffleSong then
            if #SavedPlaylist < MaxSavedSongs then
                table.insert(SavedPlaylist, {name = currentShuffleSong[1], id = tostring(currentShuffleSong[2])})
                SavePlaylistToFile()
                buildSavedUI(SavedPage)
            end
        end
    end)
end

-- === PROPS UI ===
local function buildPropsUI(parentFrame)
    local Warning = Instance.new("TextLabel")
    Warning.Size = UDim2.new(1, 0, 0, 28)
    Warning.Position = UDim2.new(0, 0, 0, 0)
    Warning.BackgroundTransparency = 1
    Warning.Text = "⚠️ Place all props manually before executing! ⚠️"
    Warning.TextColor3 = Color3.fromRGB(255, 60, 60)
    Warning.Font = Enum.Font.GothamBold
    Warning.TextSize = 9
    Warning.TextWrapped = true
    Warning.ZIndex = 4
    Warning.Parent = parentFrame

    local currentTarget = "Self"
    local TargetBtn = Instance.new("TextButton")
    TargetBtn.Size = UDim2.new(1, 0, 0, 22)
    TargetBtn.Position = UDim2.new(0, 0, 0, 32)
    TargetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TargetBtn.Text = "Target: Self ▼"
    TargetBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    TargetBtn.Font = Enum.Font.Gotham
    TargetBtn.TextSize = 11
    TargetBtn.ZIndex = 4
    TargetBtn.Parent = parentFrame
    Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 4)

    local TargetScroll = Instance.new("ScrollingFrame")
    TargetScroll.Size = UDim2.new(1, 0, 0, 80)
    TargetScroll.Position = UDim2.new(0, 0, 0, 56)
    TargetScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TargetScroll.BorderSizePixel = 0
    TargetScroll.ZIndex = 15 
    TargetScroll.Visible = false
    TargetScroll.ScrollBarThickness = 3
    TargetScroll.Parent = parentFrame
    
    local TargetLayout = Instance.new("UIListLayout", TargetScroll)
    TargetLayout.SortOrder = Enum.SortOrder.Name

    local VisScroll = Instance.new("ScrollingFrame")
    
    local function refreshPlayers()
        for _, child in pairs(TargetScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local function addPlayerOpt(name)
            local Opt = Instance.new("TextButton")
            Opt.Size = UDim2.new(1, 0, 0, 18)
            Opt.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Opt.Text = " " .. name
            Opt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Opt.Font = Enum.Font.Gotham
            Opt.TextSize = 10
            Opt.TextXAlignment = Enum.TextXAlignment.Left
            Opt.ZIndex = 16
            Opt.Parent = TargetScroll
            Opt.MouseButton1Click:Connect(function()
                currentTarget = name
                TargetBtn.Text = "Target: " .. name .. " ▼"
                TargetScroll.Visible = false
                if activeMode ~= "None" then
                    startPropEngine(activeMode, currentTarget, currentVis)
                end
            end)
        end
        addPlayerOpt("Self")
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then addPlayerOpt(p.Name) end
        end
        TargetScroll.CanvasSize = UDim2.new(0, 0, 0, TargetLayout.AbsoluteContentSize.Y)
    end
    
    refreshPlayers()
    Players.PlayerAdded:Connect(refreshPlayers)
    Players.PlayerRemoving:Connect(refreshPlayers)

    TargetBtn.MouseButton1Click:Connect(function()
        TargetScroll.Visible = not TargetScroll.Visible
        VisScroll.Visible = false 
    end)

    local NukeBtn = Instance.new("TextButton")
    NukeBtn.Size = UDim2.new(1, 0, 0, 22)
    NukeBtn.Position = UDim2.new(0, 0, 0, 59)
    NukeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 50)
    NukeBtn.Text = "NUKE PROPS"
    NukeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NukeBtn.Font = Enum.Font.GothamBold
    NukeBtn.TextSize = 11
    NukeBtn.ZIndex = 4
    NukeBtn.Parent = parentFrame
    Instance.new("UICorner", NukeBtn).CornerRadius = UDim.new(0, 4)
    
    local VisBtn = Instance.new("TextButton")
    VisBtn.Size = UDim2.new(0.65, 0, 0, 22)
    VisBtn.Position = UDim2.new(0, 0, 0, 86)
    VisBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    VisBtn.Text = "Visualizer: Orbital ▼"
    VisBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    VisBtn.Font = Enum.Font.Gotham
    VisBtn.TextSize = 10
    VisBtn.ZIndex = 4
    VisBtn.Parent = parentFrame
    Instance.new("UICorner", VisBtn).CornerRadius = UDim.new(0, 4)

    local VisToggleBtn = Instance.new("TextButton")
    VisToggleBtn.Size = UDim2.new(0.32, 0, 0, 22)
    VisToggleBtn.Position = UDim2.new(0.68, 0, 0, 86)
    VisToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    VisToggleBtn.Text = "START"
    VisToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisToggleBtn.Font = Enum.Font.GothamBold
    VisToggleBtn.TextSize = 10
    VisToggleBtn.ZIndex = 4
    VisToggleBtn.Parent = parentFrame
    Instance.new("UICorner", VisToggleBtn).CornerRadius = UDim.new(0, 4)

    NukeBtn.MouseButton1Click:Connect(function()
        if activeMode == "Nuke" then
            stopPropEngine()
            NukeBtn.Text = "NUKE PROPS"
            NukeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 50)
        else
            startPropEngine("Nuke", currentTarget, currentVis)
            NukeBtn.Text = "STOP NUKE"
            NukeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            VisToggleBtn.Text = "START"
            VisToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end
    end)

    VisToggleBtn.MouseButton1Click:Connect(function()
        if activeMode == "Visualizer" then
            stopPropEngine()
            VisToggleBtn.Text = "START"
            VisToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        else
            startPropEngine("Visualizer", currentTarget, currentVis)
            VisToggleBtn.Text = "STOP"
            VisToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            NukeBtn.Text = "NUKE PROPS"
            NukeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 50)
        end
    end)

    VisScroll.Size = UDim2.new(0.65, 0, 0, 60)
    VisScroll.Position = UDim2.new(0, 0, 0, 110)
    VisScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    VisScroll.BorderSizePixel = 0
    VisScroll.ZIndex = 15
    VisScroll.Visible = false
    VisScroll.ScrollBarThickness = 3
    VisScroll.Parent = parentFrame
    
    local VisLayout = Instance.new("UIListLayout", VisScroll)
    VisLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local visOptions = {"Orbital", "Swarm", "Tornado", "Grid"}
    for _, opt in ipairs(visOptions) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 18)
        OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        OptBtn.Text = " " .. opt
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 10
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.ZIndex = 16
        OptBtn.Parent = VisScroll
        OptBtn.MouseButton1Click:Connect(function()
            currentVis = opt
            VisBtn.Text = "Visualizer: " .. opt .. " ▼"
            VisScroll.Visible = false
            if activeMode == "Visualizer" then startPropEngine("Visualizer", currentTarget, currentVis) end
        end)
    end
    VisScroll.CanvasSize = UDim2.new(0, 0, 0, #visOptions * 18)

    VisBtn.MouseButton1Click:Connect(function()
        VisScroll.Visible = not VisScroll.Visible
        TargetScroll.Visible = false 
    end)
end

-- === PROTECTION UI ===
local function buildProtectionUI(parentFrame)
    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, 0, 1, -10)
    ScrollList.Position = UDim2.new(0, 0, 0, 5)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 3
    ScrollList.ZIndex = 4
    ScrollList.Parent = parentFrame
    Instance.new("UIListLayout", ScrollList).Padding = UDim.new(0, 6)

    local function createToggleUI(name, featureKey)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -5, 0, 32)
        Container.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Container.ZIndex = 4
        Container.Parent = ScrollList
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 5
        Label.Parent = Container

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 45, 0, 20)
        ToggleBtn.Position = UDim2.new(1, -55, 0.5, -10)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        ToggleBtn.Text = "OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.TextSize = 10
        ToggleBtn.ZIndex = 5
        ToggleBtn.Parent = Container
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)

        ToggleBtn.MouseButton1Click:Connect(function()
            local newState = not ProtectionStates[featureKey]
            toggleProtection(featureKey, newState)
            if newState then
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 80)}):Play()
                ToggleBtn.Text = "ON"
            else
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
                ToggleBtn.Text = "OFF"
            end
        end)
    end

    createToggleUI("Anti-Sit", "AntiSit")
    createToggleUI("Anti-Fling", "AntiFling")
    createToggleUI("Noclip", "Noclip")
    createToggleUI("Super Noclip", "SuperNoclip")
    createToggleUI("Freeze Self", "Freeze")
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 5 * 38)
end

-- Build all tabs
buildVehicleUI(VehiclePage)
buildMusicTab(HitsPage, HitsSongs)
buildMusicTab(HindiPage, HindiSongs)
buildMusicTab(RapsPage, RapsSongs)
buildMusicTab(BhojpuriPage, BhojpuriSongs)
buildMusicTab(PhonkPage, PhonkSongs)
buildMusicTab(MultiPage, MultiSongs)
buildMusicTab(SoundsPage, SoundsSongs)
buildSavedUI(SavedPage)
buildShuffleUI(ShufflePage)
buildPropsUI(PropsPage)
buildProtectionUI(ProtectionPage)

-- ================= DYNAMIC ADMIN SYSTEM =================
-- Now uses workspace kill switch for ;ban instead of remote kick.
-- Default admins: yash_10270 and VENUS_EDIT (loaded from file or set on first run).
-- Commands: ;ban, ;unban (clears command), ;addadmin, ;removeadmin.

local Admins = {}
local AdminFileName = "Not_Yash Admins.json"

-- Load admins from file
local function LoadAdmins()
    pcall(function()
        if readfile and isfile and isfile(AdminFileName) then
            local data = readfile(AdminFileName)
            local decoded = HttpService:JSONDecode(data)
            if type(decoded) == "table" then
                Admins = decoded
            end
        end
    end)
    if #Admins == 0 then
        Admins = {"yash_10270", "VENUS_EDIT"}
        SaveAdmins()
    end
end

local function SaveAdmins()
    pcall(function()
        if writefile then
            local encoded = HttpService:JSONEncode(Admins)
            writefile(AdminFileName, encoded)
        end
    end)
end

LoadAdmins()

local function IsAdmin(player)
    if not player then return false end
    local nameLower = string.lower(player.Name)
    for _, admin in ipairs(Admins) do
        if string.lower(admin) == nameLower then
            return true
        end
    end
    return false
end

local function sendChatMessage(msg)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync(msg) end
        else
            local sayEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if sayEvent and sayEvent:FindFirstChild("SayMessageRequest") then
                sayEvent.SayMessageRequest:FireServer(msg, "All")
            end
        end
    end)
end

-- NEW: Ban using workspace kill switch
local function banPlayer(targetName, sender)
    if not IsAdmin(sender) then 
        sendChatMessage("❌ You are not an admin.")
        return 
    end
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then
        sendChatMessage("❌ Player '" .. targetName .. "' not found.")
        return
    end
    -- Send kill command via workspace
    sendKillCommand(targetName)
    sendChatMessage("✅ " .. targetPlayer.Name .. " has been banned (script closed).")
end

-- Unban just clears the command (optional)
local function unbanPlayer(targetName, sender)
    if not IsAdmin(sender) then
        sendChatMessage("❌ You are not an admin.")
        return
    end
    local folder = Workspace:FindFirstChild(AdminFolderName)
    if folder then
        local val = folder:FindFirstChild(CloseCommandName)
        if val then val.Value = "" end
    end
    sendChatMessage("✅ Unban command sent (cleared kill signal).")
end

local function addAdmin(targetName, sender)
    if not IsAdmin(sender) then
        sendChatMessage("❌ You are not an admin.")
        return
    end
    if not Players:FindFirstChild(targetName) then
        sendChatMessage("❌ Player '" .. targetName .. "' not found.")
        return
    end
    local nameLower = string.lower(targetName)
    for _, a in ipairs(Admins) do
        if string.lower(a) == nameLower then
            sendChatMessage("⚠️ " .. targetName .. " is already an admin.")
            return
        end
    end
    table.insert(Admins, targetName)
    SaveAdmins()
    sendChatMessage("✅ " .. targetName .. " is now an admin.")
end

local function removeAdmin(targetName, sender)
    if not IsAdmin(sender) then
        sendChatMessage("❌ You are not an admin.")
        return
    end
    if targetName == sender.Name then
        sendChatMessage("❌ You cannot remove yourself.")
        return
    end
    local found = false
    for i, a in ipairs(Admins) do
        if string.lower(a) == string.lower(targetName) then
            table.remove(Admins, i)
            found = true
            break
        end
    end
    if found then
        SaveAdmins()
        sendChatMessage("✅ " .. targetName .. " is no longer an admin.")
    else
        sendChatMessage("❌ " .. targetName .. " is not an admin.")
    end
end

local function handleCommand(sender, text)
    if not sender then return end
    text = text:lower()
    local args = {}
    for word in text:gmatch("%S+") do
        table.insert(args, word)
    end
    if #args == 0 then return end
    local cmd = args[1]
    local target = args[2] and args[2] or ""

    if cmd == ";ban" and target ~= "" then
        banPlayer(target, sender)
    elseif cmd == ";unban" and target ~= "" then
        unbanPlayer(target, sender)
    elseif cmd == ";addadmin" and target ~= "" then
        addAdmin(target, sender)
    elseif cmd == ";removeadmin" and target ~= "" then
        removeAdmin(target, sender)
    end
end

-- Chat listener
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(message)
        if message.Text and message.Sender then
            handleCommand(message.Sender, message.Text)
        end
    end)
else
    LocalPlayer.Chatted:Connect(function(msg)
        handleCommand(LocalPlayer, msg)
    end)
end

-- ================= KILL COMMAND LISTENER (CLIENT SIDE) =================
-- Every client running this script monitors the workspace value.
-- When the value matches their name, they close the GUI and show a popup.

task.spawn(function()
    local folder = Workspace:FindFirstChild(AdminFolderName)
    if not folder then return end
    local val = folder:FindFirstChild(CloseCommandName)
    if not val then return end

    -- Function to show the "script has been closed" popup
    local function showClosePopup()
        -- Create a new ScreenGui for the popup (since the main one will be destroyed)
        local popupGui = Instance.new("ScreenGui")
        popupGui.Name = "ClosePopup"
        popupGui.ResetOnSpawn = false
        popupGui.Parent = CoreGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 80)
        frame.Position = UDim2.new(0.5, -100, 0.5, -40)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        frame.Parent = popupGui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "script has been closed"
        label.TextColor3 = Color3.fromRGB(255, 80, 80)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextScaled = true
        label.Parent = frame

        -- Destroy the popup after 3 seconds
        task.delay(3, function()
            popupGui:Destroy()
        end)
    end

    -- Listen for changes
    val:GetPropertyChangedSignal("Value"):Connect(function()
        if val.Value ~= "" and val.Value == LocalPlayer.Name then
            -- Clear the value to prevent repeated triggers
            val.Value = ""
            -- Destroy the main GUI
            if ScreenGui then
                ScreenGui:Destroy()
            end
            -- Show popup
            showClosePopup()
        end
    end)

    -- Also check periodically in case the event fails
    while task.wait(0.5) do
        if val and val.Value ~= "" and val.Value == LocalPlayer.Name then
            val.Value = ""
            if ScreenGui then
                ScreenGui:Destroy()
            end
            showClosePopup()
            break
        end
    end
end)