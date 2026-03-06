local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")
local Cam = workspace.CurrentCamera

LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
    Hum = c:WaitForChild("Humanoid")
end)

local State = {
    AutoStrength    = false,
    AutoPushup      = false,
    AutoSitup       = false,
    AutoPunch       = false,
    AutoRebirth     = false,
    AutoChests      = false,
    AutoWheel       = false,
    AutoKillPlayers = false,
    AutoGlitchPet   = false,
    AutoBrawl       = false,
    ServerHop       = false,
    Fly             = false,
    NoClip          = false,
    InfJump         = false,
    AntiAFK         = false,
    ESP             = false,
    RebirthStop     = 50,
    KillRange       = 40,
    FlySpeed        = 80,
    WalkSpeed       = 16,
    JumpPower       = 50,
    KillWhitelist   = {},
    KillBlacklist   = {},
}

local Connections = {}

local function SafeCall(fn)
    local ok, err = pcall(fn)
    if not ok then end
end

local function GetRemote(name)
    local rem = ReplicatedStorage:FindFirstChild(name, true)
    if not rem then
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v.Name:lower():find(name:lower()) then return v end
        end
    end
    return rem
end

local function FireRemote(name, ...)
    local rem = GetRemote(name)
    if rem and rem:IsA("RemoteEvent") then
        rem:FireServer(...)
    elseif rem and rem:IsA("RemoteFunction") then
        rem:InvokeServer(...)
    end
end

local GymPositions = {
    KingsGym   = CFrame.new(915.095215, 37.5268936, 349.808533),
    JungleGym  = CFrame.new(243.039078, 4.8158493, 361.3414),
    DesertGym  = CFrame.new(4298.60059, 1121.89404, -3898.68066),
    IceGym     = CFrame.new(2386.89038, 139.607956, 1094.26367),
    Chests     = CFrame.new(200, 5, 300),
    FortuneWheel = CFrame.new(100, 5, 200),
    BrawlArena = CFrame.new(500, 5, 600),
    SafeZone   = CFrame.new(0, 5, 0),
}

local function TeleportTo(cf)
    SafeCall(function()
        HRP.CFrame = cf
    end)
end

local function DoStrength()
    SafeCall(function()
        FireRemote("Train")
        FireRemote("DoWorkout")
        FireRemote("Strength")
        local args = {[1] = "Strength"}
        local rem = GetRemote("Train")
        if rem then
            if rem:IsA("RemoteEvent") then rem:FireServer(unpack(args)) end
        end
    end)
end

local function DoPushup()
    SafeCall(function()
        FireRemote("Pushup")
        FireRemote("DoPushup")
        local rem = GetRemote("Pushup")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
    end)
end

local function DoSitup()
    SafeCall(function()
        FireRemote("Situp")
        FireRemote("DoSitup")
        local rem = GetRemote("Situp")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
    end)
end

local function DoPunch()
    SafeCall(function()
        FireRemote("Punch")
        FireRemote("Attack")
        local rem = GetRemote("Punch")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
    end)
end

local function GetStrengthValue()
    local gui = LP.PlayerGui:FindFirstChild("MainGui", true)
    if gui then
        local lbl = gui:FindFirstChild("StrengthLabel", true)
        if lbl then return tonumber(lbl.Text:match("%d+")) or 0 end
    end
    local stats = LP:FindFirstChild("leaderstats") or LP:FindFirstChild("Stats")
    if stats then
        local str = stats:FindFirstChild("Strength") or stats:FindFirstChild("Rebirths")
        if str then return str.Value end
    end
    return 0
end

local function DoRebirth()
    SafeCall(function()
        TeleportTo(GymPositions.KingsGym)
        wait(0.5)
        FireRemote("Rebirth")
        FireRemote("DoRebirth")
        local rem = GetRemote("Rebirth")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
        if rem and rem:IsA("RemoteFunction") then rem:InvokeServer() end
    end)
end

local function ClaimChests()
    SafeCall(function()
        TeleportTo(GymPositions.Chests)
        wait(0.3)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("chest") and obj:IsA("Model") or obj:IsA("Part") then
                local rem = GetRemote("OpenChest") or GetRemote("ClaimChest")
                if rem and rem:IsA("RemoteEvent") then rem:FireServer(obj) end
                if rem and rem:IsA("RemoteFunction") then rem:InvokeServer(obj) end
                wait(0.1)
            end
        end
    end)
end

local function SpinWheel()
    SafeCall(function()
        TeleportTo(GymPositions.FortuneWheel)
        wait(0.3)
        FireRemote("SpinWheel")
        FireRemote("Spin")
        local rem = GetRemote("Wheel") or GetRemote("Fortune")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
        if rem and rem:IsA("RemoteFunction") then rem:InvokeServer() end
    end)
end

local function KillPlayer(target)
    SafeCall(function()
        if not target or not target.Character then return end
        local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
        if not tHRP then return end
        local dist = (HRP.Position - tHRP.Position).Magnitude
        if dist > State.KillRange then
            TeleportTo(tHRP.CFrame)
        end
        FireRemote("Attack", target.Character)
        FireRemote("Kill", target.Character)
        FireRemote("Punch", target.Character)
    end)
end

local function GlitchPet()
    SafeCall(function()
        local rem = GetRemote("GlitchPet") or GetRemote("Glitch")
        for _, v in ipairs(LP:WaitForChild("Backpack"):GetChildren()) do
            if rem and rem:IsA("RemoteEvent") then rem:FireServer(v) end
            wait(0.05)
        end
        local petFolder = LP:FindFirstChild("Pets") or LP:FindFirstChild("OwnedPets")
        if petFolder then
            for _, pet in ipairs(petFolder:GetChildren()) do
                if rem and rem:IsA("RemoteEvent") then rem:FireServer(pet) end
                wait(0.05)
            end
        end
    end)
end

local function JoinBrawl()
    SafeCall(function()
        TeleportTo(GymPositions.BrawlArena)
        wait(0.5)
        FireRemote("JoinBrawl")
        FireRemote("Brawl")
        local rem = GetRemote("Brawl") or GetRemote("Battle")
        if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
        if rem and rem:IsA("RemoteFunction") then rem:InvokeServer() end
    end)
end

local FlyBody = {}
local CONTROL = {F=0, B=0, L=0, R=0}

local function StartFly()
    local root = HRP
    if not root then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = root.CFrame
    bg.Parent = root
    FlyBody = {bv, bg}

    Connections["FlyUpdate"] = RunService.Heartbeat:Connect(function()
        if not State.Fly then return end
        local cf = Cam.CFrame
        local dir = (cf.LookVector * (CONTROL.F + CONTROL.B)) + ((cf * CFrame.new(CONTROL.L + CONTROL.R, 0, 0)).Position - cf.Position).Unit
        bv.Velocity = dir * State.FlySpeed
        bg.CFrame = cf
    end)

    UserInputService.InputBegan:Connect(function(inp, g)
        if g then return end
        if inp.KeyCode == Enum.KeyCode.W then CONTROL.F = 1 end
        if inp.KeyCode == Enum.KeyCode.S then CONTROL.B = -1 end
        if inp.KeyCode == Enum.KeyCode.A then CONTROL.L = -1 end
        if inp.KeyCode == Enum.KeyCode.D then CONTROL.R = 1 end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
        if inp.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
        if inp.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
        if inp.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
    end)
end

local function StopFly()
    for _, obj in ipairs(FlyBody) do
        SafeCall(function() obj:Destroy() end)
    end
    FlyBody = {}
    if Connections["FlyUpdate"] then Connections["FlyUpdate"]:Disconnect() end
end

local ESPObjects = {}

local function CreateESP(player)
    if player == LP then return end
    SafeCall(function()
        local bill = Instance.new("BillboardGui")
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 120, 0, 30)
        bill.StudsOffset = Vector3.new(0, 3, 0)
        local lbl = Instance.new("TextLabel", bill)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        lbl.TextStrokeTransparency = 0
        lbl.Font = Enum.Font.GothamBold
        lbl.TextScaled = true
        lbl.Text = player.Name

        local function attachToChar(char)
            bill.Parent = char:WaitForChild("HumanoidRootPart")
        end
        if player.Character then attachToChar(player.Character) end
        player.CharacterAdded:Connect(attachToChar)
        ESPObjects[player.Name] = bill
    end)
end

local function RemoveESP(player)
    if ESPObjects[player.Name] then
        SafeCall(function() ESPObjects[player.Name]:Destroy() end)
        ESPObjects[player.Name] = nil
    end
end

local function EnableESP()
    for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(RemoveESP)
end

local function DisableESP()
    for _, gui in pairs(ESPObjects) do
        SafeCall(function() gui:Destroy() end)
    end
    ESPObjects = {}
end

local NoClipConn
local function EnableNoClip()
    NoClipConn = RunService.Stepped:Connect(function()
        if not State.NoClip then return end
        for _, part in ipairs(Char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function DisableNoClip()
    if NoClipConn then NoClipConn:Disconnect() end
    for _, part in ipairs(Char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
end

local AntiAFKConn
local function StartAntiAFK()
    AntiAFKConn = RunService.Heartbeat:Connect(function()
        if not State.AntiAFK then return end
        local vjs = LP:FindFirstChild("VirtualUser") or game:GetService("VirtualUser")
        if vjs then
            SafeCall(function() vjs:CaptureController() vjs:ClickButton2(Vector2.new()) end)
        end
    end)
    LP.Idled:Connect(function()
        if State.AntiAFK then
            SafeCall(function()
                local vjs = game:GetService("VirtualUser")
                vjs:CaptureController()
                vjs:ClickButton2(Vector2.new())
            end)
        end
    end)
end

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and Hum then
        Hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local function DoServerHop()
    local PlaceID = game.PlaceId
    local ok, Site = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if not ok then return end
    for _, server in ipairs(Site.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, server.id, LP)
            return
        end
    end
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MLHub"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then syn.protect_gui(GUI) end
GUI.Parent = LP.PlayerGui or game.CoreGui

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 420, 0, 560)
Main.Position = UDim2.new(0.5, -210, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💪 MUSCLE LEGENDS HUB"
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -38, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -10, 1, -54)
Content.Position = UDim2.new(0, 5, 0, 49)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(255,80,80)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Content)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)

local Pad = Instance.new("UIPadding", Content)
Pad.PaddingTop = UDim.new(0, 6)
Pad.PaddingLeft = UDim.new(0, 6)
Pad.PaddingRight = UDim.new(0, 6)

local function MakeSection(name)
    local sec = Instance.new("TextLabel", Content)
    sec.Size = UDim2.new(1, -12, 0, 28)
    sec.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sec.Text = "  " .. name
    sec.TextColor3 = Color3.fromRGB(255, 80, 80)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 12
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.BorderSizePixel = 0
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 6)
    return sec
end

local function MakeToggle(labelText, stateKey, callback)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(1, -12, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 52, 0, 26)
    btn.Position = UDim2.new(1, -62, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        if State[stateKey] then
            btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Text = "OFF"
        end
        if callback then callback(State[stateKey]) end
    end)
    return row
end

local function MakeButton(labelText, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function MakeSlider(labelText, stateKey, min, max)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(1, -12, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -10, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText .. ": " .. State[stateKey]
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 36)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((State[stateKey] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local dragging = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            State[stateKey] = val
            fill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = labelText .. ": " .. val
            if stateKey == "WalkSpeed" and Hum then Hum.WalkSpeed = val end
            if stateKey == "JumpPower" and Hum then Hum.JumpPower = val end
        end
    end)
    return row
end

MakeSection("⚔️  AUTO FARM")
MakeToggle("Auto Strength", "AutoStrength", nil)
MakeToggle("Auto Pushup", "AutoPushup", nil)
MakeToggle("Auto Situp", "AutoSitup", nil)
MakeToggle("Auto Punch", "AutoPunch", nil)

MakeSection("🏆  PROGRESSION")
MakeToggle("Auto Rebirth", "AutoRebirth", nil)
MakeToggle("Auto Claim Chests", "AutoChests", nil)
MakeToggle("Auto Spin Wheel", "AutoWheel", nil)
MakeToggle("Auto Join Brawl", "AutoBrawl", nil)

MakeSection("🐾  PETS")
MakeToggle("Auto Glitch Pet", "AutoGlitchPet", nil)

MakeSection("⚡  COMBAT")
MakeToggle("Auto Kill Players", "AutoKillPlayers", nil)

MakeSection("🧭  TELEPORTS")
MakeButton("→ Kings Gym", function() TeleportTo(GymPositions.KingsGym) end)
MakeButton("→ Jungle Gym", function() TeleportTo(GymPositions.JungleGym) end)
MakeButton("→ Desert Gym", function() TeleportTo(GymPositions.DesertGym) end)
MakeButton("→ Ice Gym", function() TeleportTo(GymPositions.IceGym) end)
MakeButton("→ Chests", function() TeleportTo(GymPositions.Chests) end)
MakeButton("→ Fortune Wheel", function() TeleportTo(GymPositions.FortuneWheel) end)
MakeButton("→ Brawl Arena", function() TeleportTo(GymPositions.BrawlArena) end)
MakeButton("→ Safe Zone", function() TeleportTo(GymPositions.SafeZone) end)

MakeSection("🛠️  PLAYER")
MakeSlider("WalkSpeed", "WalkSpeed", 16, 250)
MakeSlider("JumpPower", "JumpPower", 50, 300)
MakeSlider("Kill Range", "KillRange", 10, 200)
MakeSlider("Fly Speed", "FlySpeed", 20, 300)

MakeToggle("Fly [F Key]", "Fly", function(on)
    if on then StartFly() else StopFly() end
end)
MakeToggle("NoClip", "NoClip", function(on)
    if on then EnableNoClip() else DisableNoClip() end
end)
MakeToggle("Infinite Jump", "InfJump", nil)
MakeToggle("Anti AFK", "AntiAFK", nil)
MakeToggle("ESP", "ESP", function(on)
    if on then EnableESP() else DisableESP() end
end)

MakeSection("🌐  SERVER")
MakeButton("Server Hop", function() DoServerHop() end)

local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Content.Visible = not Minimized
    Main.Size = Minimized and UDim2.new(0, 420, 0, 44) or UDim2.new(0, 420, 0, 560)
    MinBtn.Text = Minimized and "+" or "—"
end)

local Dragging, DragStart, StartPos
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = inp.Position
        StartPos = Main.Position
    end
end)
TopBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if Dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - DragStart
        Main.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputBegan:Connect(function(inp, g)
    if g then return end
    if inp.KeyCode == Enum.KeyCode.F then
        State.Fly = not State.Fly
        if State.Fly then StartFly() else StopFly() end
    end
    if inp.KeyCode == Enum.KeyCode.Insert then
        GUI.Enabled = not GUI.Enabled
    end
end)

StartAntiAFK()

RunService.Heartbeat:Connect(function()
    SafeCall(function()
        if State.AutoStrength then DoStrength() end
    end)
    SafeCall(function()
        if State.AutoPushup then DoPushup() end
    end)
    SafeCall(function()
        if State.AutoSitup then DoSitup() end
    end)
    SafeCall(function()
        if State.AutoPunch then DoPunch() end
    end)
    SafeCall(function()
        if State.AutoGlitchPet then GlitchPet() end
    end)
    SafeCall(function()
        if State.AutoKillPlayers then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and not State.KillWhitelist[p.Name] then
                    KillPlayer(p)
                end
            end
        end
    end)
    if Hum then
        if State.WalkSpeed ~= 16 then Hum.WalkSpeed = State.WalkSpeed end
        if State.JumpPower ~= 50 then Hum.JumpPower = State.JumpPower end
    end
end)

local RebirthTick = 0
local ChestTick = 0
local WheelTick = 0
local BrawlTick = 0

RunService.Heartbeat:Connect(function()
    local now = tick()
    if State.AutoRebirth and now - RebirthTick > 3 then
        RebirthTick = now
        SafeCall(DoRebirth)
    end
    if State.AutoChests and now - ChestTick > 5 then
        ChestTick = now
        SafeCall(ClaimChests)
    end
    if State.AutoWheel and now - WheelTick > 10 then
        WheelTick = now
        SafeCall(SpinWheel)
    end
    if State.AutoBrawl and now - BrawlTick > 8 then
        BrawlTick = now
        SafeCall(JoinBrawl)
    end
end)
