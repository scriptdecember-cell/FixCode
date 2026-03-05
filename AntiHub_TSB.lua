local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local Workspace         = game:GetService("Workspace")
local Camera            = Workspace.CurrentCamera
local LP                = Players.LocalPlayer

if CoreGui:FindFirstChild("AntiHub") then CoreGui.AntiHub:Destroy() end
for _, v in pairs(Workspace:GetDescendants()) do
    if v.Name == "AH_CustomAura" then v:Destroy() end
end

local Cfg = {
    KillAura         = false,
    KillAuraRange    = 30,
    KillAuraDelay    = 0.05,

    AutoBlock        = false,
    AutoBlockHP      = 60,
    InstantBlock     = false,

    CustomAura       = false,
    AuraColor        = Color3.fromRGB(80, 160, 255),
    AuraSize         = 30,
    AuraTransparency = 0.4,

    ESP              = false,
    ESPBoxes         = true,
    ESPNames         = true,
    ESPHealth        = true,
    ESPDistance      = true,
    ESPColor         = Color3.fromRGB(80, 160, 255),

    Wallhack         = false,

    AimBot           = false,
    AimBotFOV        = 120,
    AimBotSmooth     = 0.15,
    AimBotPart       = "Head",

    AimLock          = false,
    AimLockKey       = Enum.KeyCode.Q,

    SilentAim        = false,
    ACBypass         = false,
    NoFOV            = false,

    BG       = Color3.fromRGB(12, 12, 18),
    BG2      = Color3.fromRGB(18, 18, 28),
    BG3      = Color3.fromRGB(24, 24, 38),
    Accent   = Color3.fromRGB(80, 130, 255),
    Green    = Color3.fromRGB(50, 210, 110),
    Red      = Color3.fromRGB(220, 60, 60),
    TextMain = Color3.fromRGB(215, 215, 235),
    TextDim  = Color3.fromRGB(90, 90, 120),
}

local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Corner(r, p)
    local c = New("UICorner", {CornerRadius = UDim.new(0, r)})
    c.Parent = p
    return c
end

local function Stroke(color, thick, p)
    local s = New("UIStroke", {Color = color, Thickness = thick, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    s.Parent = p
    return s
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function GetRoot(p) local c = p and p.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHuman(p) local c = p and p.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function IsAlive(p) local h = GetHuman(p) return h and h.Health > 0 end
local function Distance(p)
    local a, b = GetRoot(LP), GetRoot(p)
    if not a or not b then return math.huge end
    return (a.Position - b.Position).Magnitude
end

local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and IsAlive(p) then
            local d = Distance(p)
            if d < dist then dist = d closest = p end
        end
    end
    return closest, dist
end

local function WorldToViewport(pos)
    local p, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(p.X, p.Y), onScreen, p.Z
end

local ScreenGui = New("ScreenGui", {Name="AntiHub", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=CoreGui})

local MainFrame = New("Frame", {
    Size = UDim2.new(0, 480, 0, 400),
    Position = UDim2.new(0.5, -240, 0.5, -200),
    BackgroundColor3 = Cfg.BG,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
Corner(10, MainFrame)
Stroke(Cfg.Accent, 1.2, MainFrame)

local TopBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Cfg.BG2,
    BorderSizePixel = 0,
    Parent = MainFrame
})
Corner(10, TopBar)
New("Frame", {Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10), BackgroundColor3=Cfg.BG2, BorderSizePixel=0, Parent=TopBar})
New("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,0), BackgroundColor3=Cfg.Accent, BorderSizePixel=0, Parent=TopBar})

New("TextLabel", {
    Text = "ANTI HUB",
    Size = UDim2.new(0, 160, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Cfg.TextMain,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

New("TextLabel", {
    Text = "TSB  •  v2.0",
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(1, -194, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Cfg.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = TopBar
})

local MinimizeBtn = New("TextButton", {
    Text = "—",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -76, 0.5, -15),
    BackgroundColor3 = Cfg.BG3,
    TextColor3 = Cfg.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BorderSizePixel = 0,
    Parent = TopBar
})
Corner(6, MinimizeBtn)

local CloseBtn = New("TextButton", {
    Text = "✕",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = Cfg.BG3,
    TextColor3 = Cfg.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BorderSizePixel = 0,
    Parent = TopBar
})
Corner(6, CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3=Cfg.Red}) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3=Cfg.BG3}) end)
MinimizeBtn.MouseEnter:Connect(function() Tween(MinimizeBtn, {BackgroundColor3=Cfg.Accent}) end)
MinimizeBtn.MouseLeave:Connect(function() Tween(MinimizeBtn, {BackgroundColor3=Cfg.BG3}) end)

local TabBar = New("Frame", {
    Size = UDim2.new(1, -20, 0, 32),
    Position = UDim2.new(0, 10, 0, 52),
    BackgroundTransparency = 1,
    Parent = MainFrame
})
New("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), Parent=TabBar})

local ContentFrame = New("Frame", {
    Size = UDim2.new(1, -20, 1, -96),
    Position = UDim2.new(0, 10, 0, 92),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local Tabs = {}

local function CreateTab(name)
    local btn = New("TextButton", {
        Text = name,
        Size = UDim2.new(0, 88, 1, 0),
        BackgroundColor3 = Cfg.BG3,
        TextColor3 = Cfg.TextDim,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = TabBar
    })
    Corner(6, btn)

    local content = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Cfg.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = ContentFrame
    })
    New("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=content})
    New("UIPadding", {PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), Parent=content})

    Tabs[name] = {Btn=btn, Content=content}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            Tween(t.Btn, {BackgroundColor3=Cfg.BG3, TextColor3=Cfg.TextDim})
        end
        content.Visible = true
        Tween(btn, {BackgroundColor3=Cfg.Accent, TextColor3=Cfg.TextMain})
    end)

    return content
end

local function Toggle(parent, label, desc, default, callback)
    local state = default or false
    local row = New("Frame", {Size=UDim2.new(1,0,0,44), BackgroundColor3=Cfg.BG2, BorderSizePixel=0, Parent=parent})
    Corner(7, row)

    New("TextLabel", {
        Text = label,
        Size = UDim2.new(1,-60,0,20), Position = UDim2.new(0,12,0,6),
        BackgroundTransparency=1, TextColor3=Cfg.TextMain,
        Font=Enum.Font.GothamSemibold, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=row
    })

    if desc then
        New("TextLabel", {
            Text = desc,
            Size = UDim2.new(1,-60,0,14), Position=UDim2.new(0,12,0,26),
            BackgroundTransparency=1, TextColor3=Cfg.TextDim,
            Font=Enum.Font.Gotham, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
    end

    local track = New("Frame", {
        Size=UDim2.new(0,38,0,20), Position=UDim2.new(1,-50,0.5,-10),
        BackgroundColor3 = state and Cfg.Green or Cfg.BG3,
        BorderSizePixel=0, Parent=row
    })
    Corner(10, track)

    local knob = New("Frame", {
        Size=UDim2.new(0,14,0,14),
        Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3=Cfg.TextMain, BorderSizePixel=0, Parent=track
    })
    Corner(7, knob)

    local btn = New("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Parent=row})
    btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(track, {BackgroundColor3 = state and Cfg.Green or Cfg.BG3})
        Tween(knob, {Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)})
        if callback then callback(state) end
    end)

    return row
end

local function Slider(parent, label, min, max, default, callback)
    local val = default or min
    local row = New("Frame", {Size=UDim2.new(1,0,0,52), BackgroundColor3=Cfg.BG2, BorderSizePixel=0, Parent=parent})
    Corner(7, row)

    local lbl = New("TextLabel", {
        Text = label..":  "..tostring(val),
        Size=UDim2.new(1,-12,0,20), Position=UDim2.new(0,12,0,6),
        BackgroundTransparency=1, TextColor3=Cfg.TextMain,
        Font=Enum.Font.GothamSemibold, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=row
    })

    local trackBG = New("Frame", {
        Size=UDim2.new(1,-24,0,4), Position=UDim2.new(0,12,0,36),
        BackgroundColor3=Cfg.BG3, BorderSizePixel=0, Parent=row
    })
    Corner(2, trackBG)

    local fill = New("Frame", {
        Size=UDim2.new((val-min)/(max-min),0,1,0),
        BackgroundColor3=Cfg.Accent, BorderSizePixel=0, Parent=trackBG
    })
    Corner(2, fill)

    local dragging = false
    local sliderBtn = New("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Parent=trackBG})

    local function update(x)
        local rel = math.clamp((x - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * rel)
        lbl.Text = label..":  "..tostring(val)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        if callback then callback(val) end
    end

    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging then update(UserInputService:GetMouseLocation().X) end
    end)
end

local function Section(parent, text)
    New("TextLabel", {
        Text = "  "..string.upper(text),
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1,
        TextColor3=Cfg.Accent, Font=Enum.Font.GothamBold,
        TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=parent
    })
end

local tabCombat = CreateTab("Combat")
local tabVisual  = CreateTab("Visual")
local tabAim     = CreateTab("Aim")
local tabMisc    = CreateTab("Misc")

Tabs["Combat"].Content.Visible = true
Tween(Tabs["Combat"].Btn, {BackgroundColor3=Cfg.Accent, TextColor3=Cfg.TextMain})

Section(tabCombat, "Kill Aura")
Toggle(tabCombat, "Kill Aura", "Attack nearest enemy automatically", false, function(v) Cfg.KillAura = v end)
Slider(tabCombat, "Aura Range", 5, 80, 30, function(v) Cfg.KillAuraRange = v end)
Slider(tabCombat, "Aura Delay (ms)", 1, 20, 5, function(v) Cfg.KillAuraDelay = v / 100 end)

Section(tabCombat, "Auto Block")
Toggle(tabCombat, "Auto Block", "Block when HP drops below threshold", false, function(v) Cfg.AutoBlock = v end)
Toggle(tabCombat, "Instant Block", "Block instantly on hit detection", false, function(v) Cfg.InstantBlock = v end)
Slider(tabCombat, "Block HP Threshold", 10, 100, 60, function(v) Cfg.AutoBlockHP = v end)

Section(tabVisual, "ESP")
Toggle(tabVisual, "ESP", "Show enemy info through walls", false, function(v)
    Cfg.ESP = v
    if not v then
        for _, h in pairs(ScreenGui:GetDescendants()) do
            if h.Name == "AH_ESP" then h:Destroy() end
        end
    end
end)
Toggle(tabVisual, "ESP Boxes", nil, true, function(v) Cfg.ESPBoxes = v end)
Toggle(tabVisual, "ESP Names", nil, true, function(v) Cfg.ESPNames = v end)
Toggle(tabVisual, "ESP Health", nil, true, function(v) Cfg.ESPHealth = v end)
Toggle(tabVisual, "ESP Distance", nil, true, function(v) Cfg.ESPDistance = v end)

Section(tabVisual, "Wallhack")
Toggle(tabVisual, "Wallhack", "Make walls semi-transparent", false, function(v)
    Cfg.Wallhack = v
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.LocalTransparencyModifier = v and 0.7 or 0
        end
    end
end)

Section(tabVisual, "Custom Aura")
Toggle(tabVisual, "Custom Aura", "Neon ring around your character", false, function(v) Cfg.CustomAura = v end)
Slider(tabVisual, "Aura Size", 5, 80, 30, function(v) Cfg.AuraSize = v end)
Slider(tabVisual, "Aura Opacity", 1, 9, 4, function(v) Cfg.AuraTransparency = v / 10 end)

Section(tabAim, "Aim Bot")
Toggle(tabAim, "Aim Bot", "Auto aim toward nearest enemy head", false, function(v) Cfg.AimBot = v end)
Slider(tabAim, "FOV Radius", 20, 360, 120, function(v) Cfg.AimBotFOV = v end)
Slider(tabAim, "Smoothness", 1, 20, 3, function(v) Cfg.AimBotSmooth = v / 20 end)

Section(tabAim, "Aim Lock")
Toggle(tabAim, "Aim Lock", "Hold Q to hard lock camera to target", false, function(v) Cfg.AimLock = v end)

Section(tabAim, "Silent Aim")
Toggle(tabAim, "Silent Aim", "Bullets curve to target silently", false, function(v) Cfg.SilentAim = v end)

Section(tabMisc, "Anti Cheat")
Toggle(tabMisc, "AC Bypass", "Bypass anti-cheat hooks", false, function(v)
    Cfg.ACBypass = v
    if v and getrawmetatable then
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

Section(tabMisc, "Misc")
Toggle(tabMisc, "No FOV Limit", "Unlock camera field of view", false, function(v)
    Cfg.NoFOV = v
    if v then Camera.FieldOfView = 90 end
end)

local dragging_main, drag_start, drag_pos = false, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging_main = true
        drag_start = i.Position
        drag_pos = MainFrame.Position
    end
end)
TopBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging_main = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging_main and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - drag_start
        MainFrame.Position = UDim2.new(
            drag_pos.X.Scale, drag_pos.X.Offset + delta.X,
            drag_pos.Y.Scale, drag_pos.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Tween(MainFrame, {Size = minimized and UDim2.new(0,480,0,44) or UDim2.new(0,480,0,400)}, 0.25)
    ContentFrame.Visible = not minimized
    TabBar.Visible = not minimized
end)

local espObjects = {}

local function GetOrCreateESP(player)
    if espObjects[player] then return espObjects[player] end
    local container = New("Folder", {Name="AH_ESP", Parent=ScreenGui})
    local box = New("Frame", {Name="Box", BackgroundTransparency=1, BorderSizePixel=0, Parent=container})
    Stroke(Cfg.ESPColor, 1.2, box)
    local nameTag = New("TextLabel", {
        Name="NameTag", Text=player.Name, BackgroundTransparency=1,
        TextColor3=Cfg.TextMain, Font=Enum.Font.GothamBold,
        TextSize=12, TextStrokeTransparency=0.5, Parent=container
    })
    local distTag = New("TextLabel", {
        Name="DistTag", Text="", BackgroundTransparency=1,
        TextColor3=Cfg.TextDim, Font=Enum.Font.Gotham,
        TextSize=11, TextStrokeTransparency=0.5, Parent=container
    })
    local hpBarBG = New("Frame", {Name="HPBarBG", BackgroundColor3=Color3.fromRGB(30,30,30), BorderSizePixel=0, Parent=container})
    local hpBar   = New("Frame", {Name="HPBar", BackgroundColor3=Cfg.Green, BorderSizePixel=0, Parent=hpBarBG})
    espObjects[player] = {Container=container, Box=box, NameTag=nameTag, DistTag=distTag, HPBarBG=hpBarBG, HPBar=hpBar}
    return espObjects[player]
end

local function RemoveESP(player)
    if espObjects[player] then
        espObjects[player].Container:Destroy()
        espObjects[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

local auraObj = nil
local function UpdateCustomAura()
    local root = GetRoot(LP)
    if not root then if auraObj then auraObj:Destroy() auraObj = nil end return end
    if not auraObj or not auraObj.Parent then
        auraObj = New("Part", {
            Name = "AH_CustomAura",
            Shape = Enum.PartType.Cylinder,
            Anchored = false, CanCollide = false, CastShadow = false,
            Material = Enum.Material.Neon,
            Size = Vector3.new(0.1, Cfg.AuraSize*2, Cfg.AuraSize*2),
            Color = Cfg.AuraColor,
            Transparency = Cfg.AuraTransparency,
            Parent = Workspace
        })
        New("WeldConstraint", {Part0=root, Part1=auraObj, Parent=auraObj})
        auraObj.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
    end
    auraObj.Size = Vector3.new(0.1, Cfg.AuraSize*2, Cfg.AuraSize*2)
    auraObj.Transparency = Cfg.AuraTransparency
    auraObj.Color = Cfg.AuraColor
end

local lastKillAura = 0
local aimLockTarget = nil

RunService.Heartbeat:Connect(function()
    if Cfg.KillAura then
        local now = tick()
        if now - lastKillAura >= Cfg.KillAuraDelay then
            lastKillAura = now
            local closest, dist = GetClosestPlayer()
            if closest and dist <= Cfg.KillAuraRange then
                local char = closest.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if hum and tool then
                    local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                    if remote then
                        pcall(function()
                            if remote:IsA("RemoteEvent") then remote:FireServer(hum) end
                        end)
                    end
                end
            end
        end
    end

    if Cfg.AutoBlock then
        local hum = GetHuman(LP)
        if hum and hum.Health <= Cfg.AutoBlockHP then
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    local remote = tool:FindFirstChild("BlockEvent") or tool:FindFirstChild("RemoteEvent")
                    if remote and remote:IsA("RemoteEvent") then remote:FireServer("Block") end
                end)
            end
        end
    end

    if Cfg.CustomAura then
        UpdateCustomAura()
    elseif auraObj then
        auraObj:Destroy()
        auraObj = nil
    end

    if Cfg.AimBot then
        local closest = GetClosestPlayer()
        if closest then
            local part = closest.Character and closest.Character:FindFirstChild(Cfg.AimBotPart)
            if part then
                local screenPos, onScreen = WorldToViewport(part.Position)
                local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                if onScreen and (screenPos - center).Magnitude <= Cfg.AimBotFOV then
                    local target = CFrame.new(Camera.CFrame.Position, part.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(target, Cfg.AimBotSmooth)
                end
            end
        end
    end

    if Cfg.AimLock and UserInputService:IsKeyDown(Cfg.AimLockKey) then
        if not aimLockTarget or not IsAlive(aimLockTarget) then
            aimLockTarget = GetClosestPlayer()
        end
        if aimLockTarget then
            local part = aimLockTarget.Character and aimLockTarget.Character:FindFirstChild("Head")
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    else
        aimLockTarget = nil
    end

    if Cfg.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and IsAlive(player) then
                local esp  = GetOrCreateESP(player)
                local root = GetRoot(player)
                local hum  = GetHuman(player)
                if root and hum then
                    local pos2d, onScreen, depth = WorldToViewport(root.Position)
                    if onScreen and depth > 0 then
                        local h = 5 / depth * 1000
                        local w = h * 0.6
                        esp.Box.Visible = Cfg.ESPBoxes
                        if Cfg.ESPBoxes then
                            esp.Box.Size = UDim2.new(0,w,0,h)
                            esp.Box.Position = UDim2.new(0, pos2d.X-w/2, 0, pos2d.Y-h/2)
                        end
                        esp.NameTag.Visible = Cfg.ESPNames
                        if Cfg.ESPNames then
                            esp.NameTag.Size = UDim2.new(0,120,0,14)
                            esp.NameTag.Position = UDim2.new(0, pos2d.X-60, 0, pos2d.Y-h/2-16)
                        end
                        esp.DistTag.Visible = Cfg.ESPDistance
                        if Cfg.ESPDistance then
                            esp.DistTag.Text = math.floor(Distance(player)).." studs"
                            esp.DistTag.Size = UDim2.new(0,80,0,12)
                            esp.DistTag.Position = UDim2.new(0, pos2d.X-40, 0, pos2d.Y+h/2+2)
                        end
                        esp.HPBarBG.Visible = Cfg.ESPHealth
                        if Cfg.ESPHealth then
                            local ratio = hum.Health / hum.MaxHealth
                            esp.HPBarBG.Size = UDim2.new(0,4,0,h)
                            esp.HPBarBG.Position = UDim2.new(0, pos2d.X-w/2-7, 0, pos2d.Y-h/2)
                            esp.HPBar.Size = UDim2.new(1,0,ratio,0)
                            esp.HPBar.Position = UDim2.new(0,0,1-ratio,0)
                            esp.HPBar.BackgroundColor3 = Color3.fromRGB(math.floor(255*(1-ratio)), math.floor(220*ratio), 60)
                        end
                    else
                        esp.Box.Visible = false
                        esp.NameTag.Visible = false
                        esp.DistTag.Visible = false
                        esp.HPBarBG.Visible = false
                    end
                end
            else
                RemoveESP(player)
            end
        end
    else
        for p in pairs(espObjects) do RemoveESP(p) end
    end
end)
