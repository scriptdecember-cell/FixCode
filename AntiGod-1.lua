local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local CoreGui          = game:GetService("CoreGui")
local VirtualUser      = game:GetService("VirtualUser")
local Camera           = Workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

pcall(function()
    if CoreGui:FindFirstChild("AntiGod") then CoreGui:FindFirstChild("AntiGod"):Destroy() end
    if CoreGui:FindFirstChild("AntiGodESP") then CoreGui:FindFirstChild("AntiGodESP"):Destroy() end
end)

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local VP = Camera.ViewportSize
local SCALE = isMobile and math.clamp(VP.X / 800, 0.55, 0.9) or 1.0
local function S(n) return math.floor(n * SCALE) end

local CFG = {
    ESPEnabled           = false,
    ESPBoxes             = true,
    ESPBoxStyle          = "Corner",
    ESPBoxColor          = Color3.fromRGB(100, 200, 255),
    ESPBoxThickness      = 1.5,
    ESPBoxFilled         = false,
    ESPBoxFillTrans      = 0.88,
    ESPBoxCornerLen      = 6,
    ESPNames             = true,
    ESPNameSize          = 13,
    ESPNameColor         = Color3.fromRGB(255, 255, 255),
    ESPNameOutline       = true,
    ESPHealth            = true,
    ESPHealthStyle       = "Bar",
    ESPHealthBarPos      = "Left",
    ESPHealthGradient    = true,
    ESPHealthText        = false,
    ESPDistance          = true,
    ESPDistanceColor     = Color3.fromRGB(200, 200, 255),
    ESPDistanceSize      = 11,
    ESPMaxDistance       = 1000,
    ESPSkeleton          = false,
    ESPSkeletonColor     = Color3.fromRGB(255, 210, 80),
    ESPSkeletonThick     = 1.2,
    ESPChams             = false,
    ESPChamsColor        = Color3.fromRGB(100, 200, 255),
    ESPChamsFillTrans    = 0.65,
    ESPChamsWall         = true,
    ESPTeamCheck         = true,
    ESPTeamColor         = Color3.fromRGB(80, 255, 140),
    ESPShowTeammates     = false,
    ESPTracers           = false,
    ESPTracerOrigin      = "Bottom",
    ESPTracerColor       = Color3.fromRGB(100, 200, 255),
    ESPTracerThick       = 1,
    ESPTracerTeamCheck   = true,
    ESPHeadDot           = false,
    ESPHeadDotColor      = Color3.fromRGB(255, 80, 80),
    ESPHeadDotSize       = 4,
    ESPSnapline          = false,
    ESPSnapColor         = Color3.fromRGB(255, 255, 100),
    ESPWeaponLabel       = false,
    ESPArrows            = false,
    ESPArrowColor        = Color3.fromRGB(100, 200, 255),
    ESPArrowSize         = 14,

    AimbotEnabled        = false,
    AimbotFOV            = 130,
    AimbotSmooth         = 0.20,
    AimbotPart           = "Head",
    AimbotPrediction     = true,
    AimbotPredStrength   = 0.14,
    AimbotVisible        = false,
    AimbotTeamCheck      = true,
    AimbotKey            = Enum.UserInputType.MouseButton2,
    ShowFOVCircle        = true,
    FOVCircleColor       = Color3.fromRGB(255, 255, 255),
    FOVCircleThick       = 1.5,
    FOVCircleFilled      = false,
    FOVCircleSides       = 64,
    AimbotLockOn         = false,
    AimbotAutoFire       = false,
    AimbotHitChance      = 100,
    AimbotStickyAim      = false,
    AimbotStickyRange    = 45,
    AimbotHighlight      = true,
    AimbotHighlightColor = Color3.fromRGB(255, 60, 60),
    AimbotPriority       = "Nearest",
    AimbotMultiTarget    = false,

    SilentAim            = false,
    SilentAimPart        = "Head",
    SilentAimFOV         = 180,
    SilentAimCheck       = false,
    SilentAimChance      = 100,
    SilentAimTeamCheck   = true,

    NoRecoil             = false,
    NoRecoilStrength     = 1.0,
    NoRecoilX            = 0.0,
    NoRecoilY            = 1.0,
    NoSpread             = false,
    FastShoot            = false,
    InfiniteAmmo         = false,

    KillAura             = false,
    KillAuraRange        = 22,
    KillAuraTeamCheck    = true,
    KillAuraCooldown     = 0.08,
    KillAuraAutoBlock    = false,
    KillAuraPriority     = "Nearest",
    KillAuraAngles       = false,
    AutoParry            = false,
    AutoParryCooldown    = 0.15,

    SpeedEnabled         = false,
    SpeedValue           = 32,
    SpeedMode            = "WalkSpeed",
    BunnyHop             = false,
    BunnyHopStrength     = 1.0,

    InfJump              = false,
    JumpPower            = 55,
    MultiJump            = false,
    MultiJumpCount       = 2,

    Noclip               = false,
    Fly                  = false,
    FlySpeed             = 60,
    AntiKnockback        = false,
    LongNeck             = false,
    LongNeckSize         = 5,

    FullBright           = false,
    FullBrightVal        = 10,
    NoFog                = false,
    SunRemove            = false,
    NightMode            = false,
    RainbowChams         = false,
    RainbowSpeed         = 1.0,

    AntiAFK              = true,
    ShowNotif            = true,
    NotifPos             = "BottomRight",
    NotifDuration        = 2.5,
    HideKey              = Enum.KeyCode.RightShift,
    Watermark            = true,
    WatermarkPos         = "TopRight",
    FPSCounter           = false,
    Crosshair            = false,
    CrosshairColor       = Color3.fromRGB(255, 255, 255),
    CrosshairSize        = 10,
    CrosshairThick       = 1.5,
    CrosshairGap         = 4,
    CrosshairDot         = true,

    ThemeAccent          = Color3.fromRGB(80, 160, 255),
    ThemePreset          = "Blue",
}

local THEMES = {
    Blue    = {Color3.fromRGB(80,160,255),  Color3.fromRGB(40,90,180)},
    Purple  = {Color3.fromRGB(150,80,255),  Color3.fromRGB(90,40,180)},
    Red     = {Color3.fromRGB(255,60,80),   Color3.fromRGB(160,30,50)},
    Green   = {Color3.fromRGB(60,220,120),  Color3.fromRGB(30,140,70)},
    Cyan    = {Color3.fromRGB(60,220,255),  Color3.fromRGB(30,130,180)},
    Orange  = {Color3.fromRGB(255,140,40),  Color3.fromRGB(180,80,20)},
    Pink    = {Color3.fromRGB(255,100,200), Color3.fromRGB(180,50,130)},
    White   = {Color3.fromRGB(220,220,255), Color3.fromRGB(140,140,200)},
}

local C = {
    BG          = Color3.fromRGB(9, 9, 14),
    Surface     = Color3.fromRGB(14, 14, 22),
    Card        = Color3.fromRGB(19, 19, 30),
    CardHover   = Color3.fromRGB(25, 25, 40),
    CardActive  = Color3.fromRGB(22, 22, 44),
    Border      = Color3.fromRGB(38, 38, 62),
    BorderBright= Color3.fromRGB(60, 60, 90),
    Accent      = CFG.ThemeAccent,
    AccentDim   = Color3.fromRGB(30, 60, 120),
    ON          = Color3.fromRGB(70, 230, 120),
    ONDim       = Color3.fromRGB(25, 90, 50),
    OFF         = Color3.fromRGB(255, 60, 80),
    OFFDim      = Color3.fromRGB(100, 22, 35),
    Text        = Color3.fromRGB(220, 220, 250),
    SubText     = Color3.fromRGB(120, 120, 165),
    MutedText   = Color3.fromRGB(70, 70, 110),
    White       = Color3.fromRGB(255, 255, 255),
}

local function RefreshAccent()
    local t = THEMES[CFG.ThemePreset]
    if t then
        C.Accent = t[1]
        C.AccentDim = t[2]
        CFG.ThemeAccent = t[1]
    end
end

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function Round(f, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = f
    return c
end

local function Stroke(f, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or C.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = f
    return s
end

local function Padding(f, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.Parent = f
    return p
end

local function ListLayout(f, dir, align, pad)
    local l = Instance.new("UIListLayout")
    l.FillDirection      = dir   or Enum.FillDirection.Vertical
    l.HorizontalAlignment= align or Enum.HorizontalAlignment.Left
    l.Padding            = UDim.new(0, pad or 0)
    l.Parent = f
    return l
end

local function GridLayout(f, cs, cp)
    local g = Instance.new("UIGridLayout")
    g.CellSize    = cs or UDim2.new(0, 26, 0, 26)
    g.CellPadding = cp or UDim2.new(0, 4, 0, 4)
    g.Parent = f
    return g
end

local function GradientFrame(f, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c1, c2)
    g.Rotation = rot or 90
    g.Parent   = f
    return g
end

local function GetCharacter(p)  return p and p.Character end
local function GetRoot(p)       local c = GetCharacter(p) return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHumanoid(p)   local c = GetCharacter(p) return c and c:FindFirstChildOfClass("Humanoid") end
local function IsAlive(p)       local h = GetHumanoid(p) return h and h.Health > 0 end
local function IsTeammate(p)    return p.Team == LocalPlayer.Team end
local function GetDist(p)
    local r = GetRoot(p) local m = GetRoot(LocalPlayer)
    if r and m then return (r.Position - m.Position).Magnitude end
    return math.huge
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiGod"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

local W = S(680)
local H = S(500)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, W, 0, H)
MainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
MainFrame.BackgroundColor3 = C.BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Round(MainFrame, S(16))

local MainStroke = Stroke(MainFrame, C.Border, 1.5)

local BgGlow = Instance.new("Frame")
BgGlow.Size = UDim2.new(1.3, 0, 0.5, 0)
BgGlow.Position = UDim2.new(-0.15, 0, -0.15, 0)
BgGlow.BackgroundColor3 = C.Accent
BgGlow.BackgroundTransparency = 0.94
BgGlow.BorderSizePixel = 0
BgGlow.ZIndex = 0
BgGlow.Parent = MainFrame
Round(BgGlow, 80)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, S(54))
TopBar.BackgroundColor3 = C.Surface
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
TopBar.Parent = MainFrame
Round(TopBar, S(16))

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, S(16))
TopFix.Position = UDim2.new(0, 0, 1, -S(16))
TopFix.BackgroundColor3 = C.Surface
TopFix.BorderSizePixel = 0
TopFix.ZIndex = 5
TopFix.Parent = TopBar

local TopBottomLine = Instance.new("Frame")
TopBottomLine.Size = UDim2.new(1, 0, 0, 1)
TopBottomLine.Position = UDim2.new(0, 0, 1, -1)
TopBottomLine.BackgroundColor3 = C.Border
TopBottomLine.BorderSizePixel = 0
TopBottomLine.ZIndex = 5
TopBottomLine.Parent = TopBar

local LogoBg = Instance.new("Frame")
LogoBg.Size = UDim2.new(0, S(38), 0, S(38))
LogoBg.Position = UDim2.new(0, S(12), 0.5, -S(19))
LogoBg.BackgroundColor3 = C.Accent
LogoBg.BorderSizePixel = 0
LogoBg.ZIndex = 6
LogoBg.Parent = TopBar
Round(LogoBg, S(10))

local LogoGrad = GradientFrame(LogoBg, C.Accent, C.AccentDim, 135)

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(1, 0, 1, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "⚡"
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.TextSize = S(20)
LogoIcon.TextColor3 = C.White
LogoIcon.ZIndex = 7
LogoIcon.Parent = LogoBg

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, S(160), 0, S(22))
TitleLabel.Position = UDim2.new(0, S(58), 0.5, -S(13))
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Anti God"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = S(20)
TitleLabel.TextColor3 = C.White
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 6
TitleLabel.Parent = TopBar

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(0, S(200), 0, S(14))
SubLabel.Position = UDim2.new(0, S(59), 0.5, S(10))
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "BloxStrike  •  v3.0"
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = S(11)
SubLabel.TextColor3 = C.SubText
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 6
SubLabel.Parent = TopBar

local function WinBtn(txt, col, ox)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, S(28), 0, S(28))
    b.Position = UDim2.new(1, ox, 0.5, -S(14))
    b.BackgroundColor3 = col
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = S(13)
    b.TextColor3 = C.White
    b.BorderSizePixel = 0
    b.ZIndex = 7
    b.Parent = TopBar
    Round(b, S(7))
    b.MouseEnter:Connect(function() Tween(b, {BackgroundTransparency = 0.2}, 0.1) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundTransparency = 0}, 0.1) end)
    return b
end

local CloseBtn = WinBtn("✕", Color3.fromRGB(255, 60, 80), -S(42))
local MinBtn   = WinBtn("–", Color3.fromRGB(255, 185, 40), -S(78))
local HideBtn  = WinBtn("◉", Color3.fromRGB(50, 200, 100), -S(114))

local minimized = false
local hidden = false
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -S(54))
ContentFrame.Position = UDim2.new(0, 0, 0, S(54))
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Position = UDim2.new(0.5, -W/2, 1.5, 0), Size = UDim2.new(0, W, 0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function() ScreenGui:Destroy() end)
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        Tween(MainFrame, {Size = UDim2.new(0, W, 0, S(54))}, 0.25, Enum.EasingStyle.Quart)
    else
        ContentFrame.Visible = true
        Tween(MainFrame, {Size = UDim2.new(0, W, 0, H)}, 0.28, Enum.EasingStyle.Back)
    end
end)

HideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    Tween(MainFrame, {BackgroundTransparency = hidden and 0.95 or 0}, 0.2)
    ContentFrame.Visible = not hidden
    TopBar.BackgroundTransparency = hidden and 0.9 or 0
end)

local dragging, dragStart, startPos
local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
end
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        startDrag(i)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + d.X, 0, VP.X - W)
        local newY = math.clamp(startPos.Y.Offset + d.Y, 0, VP.Y - H)
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputBegan:Connect(function(i, sink)
    if not sink and i.KeyCode == CFG.HideKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local TabBarW = S(148)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, TabBarW, 1, -S(14))
TabBar.Position = UDim2.new(0, S(8), 0, S(7))
TabBar.BackgroundColor3 = C.Surface
TabBar.BorderSizePixel = 0
TabBar.Parent = ContentFrame
Round(TabBar, S(12))
Stroke(TabBar, C.Border, 1)

local TabTop = Instance.new("Frame")
TabTop.Size = UDim2.new(1, -S(16), 0, S(36))
TabTop.Position = UDim2.new(0, S(8), 0, S(10))
TabTop.BackgroundTransparency = 1
TabTop.Parent = TabBar

local TabTopLabel = Instance.new("TextLabel")
TabTopLabel.Size = UDim2.new(1, 0, 1, 0)
TabTopLabel.BackgroundTransparency = 1
TabTopLabel.Text = "NAVIGATION"
TabTopLabel.Font = Enum.Font.GothamBold
TabTopLabel.TextSize = S(9)
TabTopLabel.TextColor3 = C.MutedText
TabTopLabel.TextXAlignment = Enum.TextXAlignment.Left
TabTopLabel.LetterSpacingPx = 1
TabTopLabel.Parent = TabTop

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, -S(16), 1, -S(54))
TabScroll.Position = UDim2.new(0, S(8), 0, S(46))
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.Parent = TabBar
ListLayout(TabScroll, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, S(4))

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -(TabBarW + S(24)), 1, -S(14))
PageHolder.Position = UDim2.new(0, TabBarW + S(16), 0, S(7))
PageHolder.BackgroundColor3 = C.Surface
PageHolder.BorderSizePixel = 0
PageHolder.Parent = ContentFrame
Round(PageHolder, S(12))
Stroke(PageHolder, C.Border, 1)

local PageHeaderFrame = Instance.new("Frame")
PageHeaderFrame.Size = UDim2.new(1, 0, 0, S(44))
PageHeaderFrame.BackgroundColor3 = C.Card
PageHeaderFrame.BorderSizePixel = 0
PageHeaderFrame.ZIndex = 2
PageHeaderFrame.Parent = PageHolder
Round(PageHeaderFrame, S(12))
local PHFix = Instance.new("Frame")
PHFix.Size = UDim2.new(1,0,0,S(12))
PHFix.Position = UDim2.new(0,0,1,-S(12))
PHFix.BackgroundColor3 = C.Card
PHFix.BorderSizePixel = 0
PHFix.ZIndex = 2
PHFix.Parent = PageHeaderFrame
local PHLine = Instance.new("Frame")
PHLine.Size = UDim2.new(1,0,0,1)
PHLine.Position = UDim2.new(0,0,1,-1)
PHLine.BackgroundColor3 = C.Border
PHLine.BorderSizePixel = 0
PHLine.ZIndex = 3
PHLine.Parent = PageHeaderFrame

local PageHeaderIcon = Instance.new("TextLabel")
PageHeaderIcon.Size = UDim2.new(0, S(24), 0, S(24))
PageHeaderIcon.Position = UDim2.new(0, S(14), 0.5, -S(12))
PageHeaderIcon.BackgroundTransparency = 1
PageHeaderIcon.Text = "👁"
PageHeaderIcon.Font = Enum.Font.GothamBold
PageHeaderIcon.TextSize = S(18)
PageHeaderIcon.TextColor3 = C.Accent
PageHeaderIcon.ZIndex = 3
PageHeaderIcon.Parent = PageHeaderFrame

local PageHeaderTitle = Instance.new("TextLabel")
PageHeaderTitle.Size = UDim2.new(0, S(200), 0, S(22))
PageHeaderTitle.Position = UDim2.new(0, S(44), 0.5, -S(11))
PageHeaderTitle.BackgroundTransparency = 1
PageHeaderTitle.Text = "ESP"
PageHeaderTitle.Font = Enum.Font.GothamBold
PageHeaderTitle.TextSize = S(16)
PageHeaderTitle.TextColor3 = C.Text
PageHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
PageHeaderTitle.ZIndex = 3
PageHeaderTitle.Parent = PageHeaderFrame

local ScrollBase = Instance.new("ScrollingFrame")
ScrollBase.Size = UDim2.new(1, -S(8), 1, -S(52))
ScrollBase.Position = UDim2.new(0, S(4), 0, S(48))
ScrollBase.BackgroundTransparency = 1
ScrollBase.BorderSizePixel = 0
ScrollBase.ScrollBarThickness = S(3)
ScrollBase.ScrollBarImageColor3 = C.Accent
ScrollBase.ScrollBarImageTransparency = 0.4
ScrollBase.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollBase.Parent = PageHolder

local Pages = {}
local TabBtns = {}
local ActiveTab = nil

local TABS = {
    {name="ESP",      icon="👁",  label="ESP"},
    {name="Aimbot",   icon="🎯",  label="Aimbot"},
    {name="Silent",   icon="🔇",  label="Silent Aim"},
    {name="Combat",   icon="⚔",  label="Combat"},
    {name="Movement", icon="🏃",  label="Movement"},
    {name="Visuals",  icon="✨",  label="Visuals"},
    {name="Crosshair",icon="⊕",  label="Crosshair"},
    {name="Theme",    icon="🎨",  label="Theme"},
    {name="Config",   icon="⚙",  label="Config"},
}

local function MakePage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ScrollBase
    local layout = ListLayout(page, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, S(5))
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local newH = layout.AbsoluteContentSize.Y + S(16)
        page.Size = UDim2.new(1, 0, 0, newH)
        if page.Visible then
            ScrollBase.CanvasSize = UDim2.new(0, 0, 0, newH)
        end
    end)
    Padding(page, S(6), S(8), S(6), S(6))
    Pages[name] = page
    return page
end

local function SwitchTab(name)
    if ActiveTab == name then return end
    ActiveTab = name
    for n, p in pairs(Pages) do
        if n == name then
            p.Visible = true
            ScrollBase.CanvasPosition = Vector2.new(0, 0)
            local layout = p:FindFirstChildOfClass("UIListLayout")
            if layout then
                ScrollBase.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + S(16))
            end
        else
            p.Visible = false
        end
    end
    for n, btn in pairs(TabBtns) do
        local active = n == name
        Tween(btn.Frame, {BackgroundColor3 = active and C.CardActive or C.Card}, 0.15)
        Tween(btn.Frame, {BackgroundTransparency = active and 0 or 0}, 0.15)
        btn.Icon.TextColor3 = active and C.Accent or C.SubText
        btn.Label.TextColor3 = active and C.Text or C.SubText
        btn.Label.Font = active and Enum.Font.GothamBold or Enum.Font.Gotham
        if btn.Bar then btn.Bar.BackgroundTransparency = active and 0 or 1 end
        if active then
            for _, t in ipairs(TABS) do
                if t.name == name then
                    PageHeaderIcon.Text = t.icon
                    PageHeaderTitle.Text = t.label
                    PageHeaderIcon.TextColor3 = C.Accent
                    break
                end
            end
        end
    end
end

for _, tab in ipairs(TABS) do
    MakePage(tab.name)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, 0, 0, S(38))
    btnFrame.BackgroundColor3 = C.Card
    btnFrame.BorderSizePixel = 0
    btnFrame.Parent = TabScroll
    Round(btnFrame, S(9))

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, S(3), 0.55, 0)
    bar.Position = UDim2.new(0, 0, 0.225, 0)
    bar.BackgroundColor3 = C.Accent
    bar.BorderSizePixel = 0
    bar.BackgroundTransparency = 1
    bar.Parent = btnFrame
    Round(bar, S(3))

    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, S(24), 1, 0)
    iconL.Position = UDim2.new(0, S(10), 0, 0)
    iconL.BackgroundTransparency = 1
    iconL.Text = tab.icon
    iconL.Font = Enum.Font.GothamBold
    iconL.TextSize = S(16)
    iconL.TextColor3 = C.SubText
    iconL.Parent = btnFrame

    local labelL = Instance.new("TextLabel")
    labelL.Size = UDim2.new(1, -S(40), 1, 0)
    labelL.Position = UDim2.new(0, S(36), 0, 0)
    labelL.BackgroundTransparency = 1
    labelL.Text = tab.label
    labelL.Font = Enum.Font.Gotham
    labelL.TextSize = S(12)
    labelL.TextColor3 = C.SubText
    labelL.TextXAlignment = Enum.TextXAlignment.Left
    labelL.Parent = btnFrame

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = btnFrame

    hitbox.MouseEnter:Connect(function()
        if ActiveTab ~= tab.name then Tween(btnFrame, {BackgroundColor3 = C.CardHover}, 0.12) end
    end)
    hitbox.MouseLeave:Connect(function()
        if ActiveTab ~= tab.name then Tween(btnFrame, {BackgroundColor3 = C.Card}, 0.12) end
    end)
    hitbox.MouseButton1Click:Connect(function() SwitchTab(tab.name) end)

    TabBtns[tab.name] = {Frame=btnFrame, Icon=iconL, Label=labelL, Bar=bar}
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, #TABS * (S(38) + S(4)) + S(10))
end

SwitchTab("ESP")

local function SectionLabel(page, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, S(30))
    f.BackgroundTransparency = 1
    f.Parent = page

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = C.Border
    line.BorderSizePixel = 0
    line.Parent = f

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, S(#text * 7 + 20), 1, 0)
    pill.BackgroundColor3 = C.Card
    pill.BorderSizePixel = 0
    pill.Parent = f
    Round(pill, S(5))
    Stroke(pill, C.Border, 1)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, S(3), 0.55, 0)
    accentBar.Position = UDim2.new(0, S(6), 0.225, 0)
    accentBar.BackgroundColor3 = C.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = pill
    Round(accentBar, S(2))

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -S(6), 1, 0)
    lbl.Position = UDim2.new(0, S(14), 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = S(10)
    lbl.TextColor3 = C.Accent
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = pill
    return f
end

local function Toggle(page, label, desc, cfgKey, callback)
    local fh = desc and S(56) or S(42)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, fh)
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.Parent = page
    Round(f, S(10))
    Stroke(f, C.Border, 1)

    local leftBar = Instance.new("Frame")
    leftBar.Size = UDim2.new(0, S(3), 0.5, 0)
    leftBar.Position = UDim2.new(0, 0, 0.25, 0)
    leftBar.BackgroundColor3 = CFG[cfgKey] and C.Accent or C.Border
    leftBar.BorderSizePixel = 0
    leftBar.Parent = f
    Round(leftBar, S(2))

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -S(64), 0, S(20))
    nameL.Position = UDim2.new(0, S(14), 0, desc and S(9) or S(11))
    nameL.BackgroundTransparency = 1
    nameL.Text = label
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = S(13)
    nameL.TextColor3 = C.Text
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = f

    if desc then
        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, -S(64), 0, S(15))
        dl.Position = UDim2.new(0, S(14), 0, S(30))
        dl.BackgroundTransparency = 1
        dl.Text = desc
        dl.Font = Enum.Font.Gotham
        dl.TextSize = S(11)
        dl.TextColor3 = C.SubText
        dl.TextXAlignment = Enum.TextXAlignment.Left
        dl.Parent = f
    end

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, S(44), 0, S(22))
    track.Position = UDim2.new(1, -S(56), 0.5, -S(11))
    track.BackgroundColor3 = CFG[cfgKey] and C.Accent or C.Border
    track.BorderSizePixel = 0
    track.Parent = f
    Round(track, S(11))

    local trackGrad = Instance.new("UIGradient")
    trackGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.3),
    })
    trackGrad.Rotation = 90
    trackGrad.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, S(16), 0, S(16))
    knob.Position = CFG[cfgKey] and UDim2.new(1, -S(19), 0.5, -S(8)) or UDim2.new(0, S(3), 0.5, -S(8))
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = track
    Round(knob, S(8))

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, S(6), 0, S(6))
    statusDot.Position = UDim2.new(1, -S(16), 0, S(4))
    statusDot.BackgroundColor3 = CFG[cfgKey] and C.ON or C.OFF
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 2
    statusDot.Parent = f
    Round(statusDot, S(3))

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    local function setToggle(val)
        CFG[cfgKey] = val
        Tween(track, {BackgroundColor3 = val and C.Accent or C.Border}, 0.2)
        Tween(knob, {Position = val and UDim2.new(1,-S(19),0.5,-S(8)) or UDim2.new(0,S(3),0.5,-S(8))}, 0.2)
        Tween(f, {BackgroundColor3 = val and C.CardActive or C.Card}, 0.2)
        Tween(leftBar, {BackgroundColor3 = val and C.Accent or C.Border}, 0.2)
        Tween(statusDot, {BackgroundColor3 = val and C.ON or C.OFF}, 0.15)
        if callback then callback(val) end
    end

    btn.MouseButton1Click:Connect(function() setToggle(not CFG[cfgKey]) end)
    btn.MouseEnter:Connect(function() if not CFG[cfgKey] then Tween(f, {BackgroundColor3=C.CardHover}, 0.12) end end)
    btn.MouseLeave:Connect(function() if not CFG[cfgKey] then Tween(f, {BackgroundColor3=C.Card}, 0.12) end end)
    return f, setToggle
end

local function Slider(page, label, cfgKey, minV, maxV, decimals, suffix, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, S(62))
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.Parent = page
    Round(f, S(10))
    Stroke(f, C.Border, 1)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -S(110), 0, S(18))
    nameL.Position = UDim2.new(0, S(14), 0, S(8))
    nameL.BackgroundTransparency = 1
    nameL.Text = label
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = S(13)
    nameL.TextColor3 = C.Text
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = f

    local fmt = decimals and decimals > 0 and ("%." .. decimals .. "f") or "%d"
    local sfx = suffix or ""

    local valBg = Instance.new("Frame")
    valBg.Size = UDim2.new(0, S(80), 0, S(22))
    valBg.Position = UDim2.new(1, -S(94), 0, S(4))
    valBg.BackgroundColor3 = C.BG
    valBg.BorderSizePixel = 0
    valBg.Parent = f
    Round(valBg, S(6))
    Stroke(valBg, C.Border, 1)

    local valL = Instance.new("TextLabel")
    valL.Size = UDim2.new(1, 0, 1, 0)
    valL.BackgroundTransparency = 1
    valL.Text = string.format(fmt, CFG[cfgKey]) .. sfx
    valL.Font = Enum.Font.GothamBold
    valL.TextSize = S(12)
    valL.TextColor3 = C.Accent
    valL.Parent = valBg

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -S(28), 0, S(6))
    trackBg.Position = UDim2.new(0, S(14), 0, S(40))
    trackBg.BackgroundColor3 = C.Border
    trackBg.BorderSizePixel = 0
    trackBg.Parent = f
    Round(trackBg, S(3))

    local fill = Instance.new("Frame")
    local pct0 = (CFG[cfgKey] - minV) / (maxV - minV)
    fill.Size = UDim2.new(math.clamp(pct0, 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel = 0
    fill.Parent = trackBg
    Round(fill, S(3))
    GradientFrame(fill, C.Accent, C.AccentDim, 90)

    local grip = Instance.new("Frame")
    grip.Size = UDim2.new(0, S(16), 0, S(16))
    grip.Position = UDim2.new(math.clamp(pct0,0,1), -S(8), 0.5, -S(8))
    grip.BackgroundColor3 = C.White
    grip.BorderSizePixel = 0
    grip.ZIndex = 3
    grip.Parent = trackBg
    Round(grip, S(8))
    Stroke(grip, C.Accent, 1.5)

    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = C.Accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 2
    ripple.Parent = trackBg
    Round(ripple, 99)

    local sliding = false
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, S(30))
    hitbox.Position = UDim2.new(0, 0, 0.5, -S(15))
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.ZIndex = 4
    hitbox.Parent = trackBg

    local function updateSlider(x)
        local abs = trackBg.AbsolutePosition.X
        local w   = trackBg.AbsoluteSize.X
        local p   = math.clamp((x - abs) / w, 0, 1)
        local raw = minV + (maxV - minV) * p
        local r = decimals and math.floor(raw * 10^decimals + 0.5) / 10^decimals or math.floor(raw + 0.5)
        CFG[cfgKey] = r
        valL.Text = string.format(fmt, r) .. sfx
        Tween(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
        Tween(grip, {Position = UDim2.new(p, -S(8), 0.5, -S(8))}, 0.05)
        if callback then callback(r) end
    end

    hitbox.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(i.Position.X)
            Tween(ripple, {Size=UDim2.new(2,0,2,0), BackgroundTransparency=1}, 0.4)
            task.delay(0.4, function() ripple.Size=UDim2.new(0,0,0,0) ripple.BackgroundTransparency=0.7 end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    f.MouseEnter:Connect(function() Tween(f, {BackgroundColor3=C.CardHover}, 0.12) end)
    f.MouseLeave:Connect(function() Tween(f, {BackgroundColor3=C.Card}, 0.12) end)
    return f
end

local function Dropdown(page, label, options, cfgKey, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, S(52))
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Parent = page
    Round(f, S(10))
    Stroke(f, C.Border, 1)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -S(130), 0, S(20))
    nameL.Position = UDim2.new(0, S(14), 0.5, -S(10))
    nameL.BackgroundTransparency = 1
    nameL.Text = label
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = S(13)
    nameL.TextColor3 = C.Text
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = f

    local selBg = Instance.new("Frame")
    selBg.Size = UDim2.new(0, S(120), 0, S(28))
    selBg.Position = UDim2.new(1, -S(132), 0.5, -S(14))
    selBg.BackgroundColor3 = C.BG
    selBg.BorderSizePixel = 0
    selBg.Parent = f
    Round(selBg, S(7))
    Stroke(selBg, C.Accent, 1)

    local selBtn = Instance.new("TextButton")
    selBtn.Size = UDim2.new(1, 0, 1, 0)
    selBtn.BackgroundTransparency = 1
    selBtn.Text = CFG[cfgKey] .. "  ▾"
    selBtn.Font = Enum.Font.GothamBold
    selBtn.TextSize = S(12)
    selBtn.TextColor3 = C.Accent
    selBtn.Parent = selBg

    local itemH = S(30)
    local dropH = #options * itemH + S(12)
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(0, S(120), 0, dropH)
    dropFrame.Position = UDim2.new(1, -S(132), 0, S(52))
    dropFrame.BackgroundColor3 = C.BG
    dropFrame.BorderSizePixel = 0
    dropFrame.ZIndex = 20
    dropFrame.Visible = false
    dropFrame.Parent = f
    Round(dropFrame, S(9))
    Stroke(dropFrame, C.Accent, 1)
    Padding(dropFrame, S(5), S(5), S(5), S(5))
    ListLayout(dropFrame, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, S(3))

    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, S(26))
        ob.BackgroundColor3 = CFG[cfgKey] == opt and C.AccentDim or C.Card
        ob.Text = opt
        ob.Font = ob.BackgroundColor3 == C.AccentDim and Enum.Font.GothamBold or Enum.Font.Gotham
        ob.TextSize = S(12)
        ob.TextColor3 = CFG[cfgKey] == opt and C.Accent or C.SubText
        ob.BorderSizePixel = 0
        ob.ZIndex = 21
        ob.Parent = dropFrame
        Round(ob, S(6))
        ob.MouseEnter:Connect(function() if CFG[cfgKey] ~= opt then Tween(ob, {BackgroundColor3=C.CardHover}, 0.1) end end)
        ob.MouseLeave:Connect(function() if CFG[cfgKey] ~= opt then Tween(ob, {BackgroundColor3=C.Card}, 0.1) end end)
        ob.MouseButton1Click:Connect(function()
            CFG[cfgKey] = opt
            selBtn.Text = opt .. "  ▾"
            for _, c in ipairs(dropFrame:GetChildren()) do
                if c:IsA("TextButton") then
                    local isActive = c.Text == opt
                    Tween(c, {BackgroundColor3 = isActive and C.AccentDim or C.Card}, 0.1)
                    c.TextColor3 = isActive and C.Accent or C.SubText
                    c.Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham
                end
            end
            dropFrame.Visible = false
            f.ClipsDescendants = true
            f.Size = UDim2.new(1, 0, 0, S(52))
            if callback then callback(opt) end
        end)
    end

    local dropOpen = false
    selBtn.MouseButton1Click:Connect(function()
        dropOpen = not dropOpen
        if dropOpen then
            f.ClipsDescendants = false
            dropFrame.Visible = true
            Tween(f, {Size=UDim2.new(1,0,0,S(52)+dropH+S(6))}, 0.2, Enum.EasingStyle.Back)
        else
            dropFrame.Visible = false
            f.ClipsDescendants = true
            Tween(f, {Size=UDim2.new(1,0,0,S(52))}, 0.18)
        end
    end)

    f.MouseEnter:Connect(function() Tween(f, {BackgroundColor3=C.CardHover}, 0.12) end)
    f.MouseLeave:Connect(function() Tween(f, {BackgroundColor3=C.Card}, 0.12) end)
    return f
end

local function ColorPicker(page, label, cfgKey, callback)
    local PRESETS = {
        Color3.fromRGB(255,60,80),  Color3.fromRGB(255,140,40),
        Color3.fromRGB(255,220,60), Color3.fromRGB(80,230,120),
        Color3.fromRGB(60,220,255), Color3.fromRGB(80,160,255),
        Color3.fromRGB(150,80,255), Color3.fromRGB(255,100,200),
        Color3.fromRGB(255,255,255),Color3.fromRGB(180,180,180),
        Color3.fromRGB(100,100,100),Color3.fromRGB(0,0,0),
    }
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, S(44))
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Parent = page
    Round(f, S(10))
    Stroke(f, C.Border, 1)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -S(80), 0, S(20))
    nameL.Position = UDim2.new(0, S(14), 0.5, -S(10))
    nameL.BackgroundTransparency = 1
    nameL.Text = label
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = S(13)
    nameL.TextColor3 = C.Text
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = f

    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, S(55), 0, S(26))
    swatch.Position = UDim2.new(1, -S(67), 0.5, -S(13))
    swatch.BackgroundColor3 = CFG[cfgKey]
    swatch.BorderSizePixel = 0
    swatch.Parent = f
    Round(swatch, S(8))
    Stroke(swatch, C.BorderBright, 1)

    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(1, 0, 1, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text = "▾"
    chevron.Font = Enum.Font.GothamBold
    chevron.TextSize = S(12)
    chevron.TextColor3 = Color3.new(1,1,1)
    chevron.TextTransparency = 0.6
    chevron.Parent = swatch

    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, -S(28), 0, S(66))
    pickerFrame.Position = UDim2.new(0, S(14), 0, S(44))
    pickerFrame.BackgroundColor3 = C.BG
    pickerFrame.BorderSizePixel = 0
    pickerFrame.ZIndex = 15
    pickerFrame.Visible = false
    pickerFrame.Parent = f
    Round(pickerFrame, S(9))
    Stroke(pickerFrame, C.Accent, 1)
    Padding(pickerFrame, S(7), S(7), S(7), S(7))
    GridLayout(pickerFrame, UDim2.new(0, S(28), 0, S(28)), UDim2.new(0, S(5), 0, S(5)))

    for _, col in ipairs(PRESETS) do
        local cb = Instance.new("TextButton")
        cb.Size = UDim2.new(0, S(28), 0, S(28))
        cb.BackgroundColor3 = col
        cb.Text = ""
        cb.BorderSizePixel = 0
        cb.ZIndex = 16
        cb.Parent = pickerFrame
        Round(cb, S(7))
        cb.MouseButton1Click:Connect(function()
            CFG[cfgKey] = col
            swatch.BackgroundColor3 = col
            pickerFrame.Visible = false
            f.ClipsDescendants = true
            f.Size = UDim2.new(1, 0, 0, S(44))
            if callback then callback(col) end
        end)
    end

    local pickerOpen = false
    local swBtn = Instance.new("TextButton")
    swBtn.Size = UDim2.new(1,0,1,0)
    swBtn.BackgroundTransparency = 1
    swBtn.Text = ""
    swBtn.ZIndex = 6
    swBtn.Parent = swatch
    swBtn.MouseButton1Click:Connect(function()
        pickerOpen = not pickerOpen
        if pickerOpen then
            f.ClipsDescendants = false
            pickerFrame.Visible = true
            Tween(f, {Size=UDim2.new(1,0,0,S(44)+S(66)+S(10))}, 0.2, Enum.EasingStyle.Back)
        else
            pickerFrame.Visible = false
            f.ClipsDescendants = true
            Tween(f, {Size=UDim2.new(1,0,0,S(44))}, 0.18)
        end
    end)

    f.MouseEnter:Connect(function() Tween(f, {BackgroundColor3=C.CardHover}, 0.12) end)
    f.MouseLeave:Connect(function() Tween(f, {BackgroundColor3=C.Card}, 0.12) end)
    return f
end

local function KeybindWidget(page, label, cfgKey)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,S(48))
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.Parent = page
    Round(f, S(10))
    Stroke(f, C.Border, 1)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1,-S(120),0,S(20))
    nameL.Position = UDim2.new(0,S(14),0.5,-S(10))
    nameL.BackgroundTransparency = 1
    nameL.Text = label
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = S(13)
    nameL.TextColor3 = C.Text
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = f

    local function keyName(k)
        if k == Enum.UserInputType.MouseButton2 then return "RMB"
        elseif k == Enum.UserInputType.MouseButton1 then return "LMB"
        else return tostring(k):match("%.(%w+)$") or "?" end
    end

    local kBg = Instance.new("Frame")
    kBg.Size = UDim2.new(0,S(100),0,S(28))
    kBg.Position = UDim2.new(1,-S(112),0.5,-S(14))
    kBg.BackgroundColor3 = C.BG
    kBg.BorderSizePixel = 0
    kBg.Parent = f
    Round(kBg, S(7))
    Stroke(kBg, C.Accent, 1)

    local kBtn = Instance.new("TextButton")
    kBtn.Size = UDim2.new(1,0,1,0)
    kBtn.BackgroundTransparency = 1
    kBtn.Text = keyName(CFG[cfgKey])
    kBtn.Font = Enum.Font.GothamBold
    kBtn.TextSize = S(12)
    kBtn.TextColor3 = C.Accent
    kBtn.Parent = kBg

    local listening = false
    kBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kBtn.Text = "..."
        kBtn.TextColor3 = C.White
        local conn1, conn2
        conn1 = UserInputService.InputBegan:Connect(function(i, s)
            if s then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.MouseButton2 then
                CFG[cfgKey] = i.UserInputType
                kBtn.Text = keyName(i.UserInputType)
                kBtn.TextColor3 = C.Accent
                listening = false
                conn1:Disconnect() if conn2 then conn2:Disconnect() end
            elseif i.UserInputType == Enum.UserInputType.Keyboard then
                CFG[cfgKey] = i.KeyCode
                kBtn.Text = keyName(i.KeyCode)
                kBtn.TextColor3 = C.Accent
                listening = false
                conn1:Disconnect() if conn2 then conn2:Disconnect() end
            end
        end)
    end)

    f.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.CardHover},0.12) end)
    f.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Card},0.12) end)
    return f
end

local function InfoWidget(page, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,S(38))
    f.BackgroundColor3 = Color3.fromRGB(15,25,50)
    f.BorderSizePixel = 0
    f.Parent = page
    Round(f, S(9))
    Stroke(f, Color3.fromRGB(40,80,160), 1)
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0,S(24),1,0)
    icon.Position = UDim2.new(0,S(10),0,0)
    icon.BackgroundTransparency=1
    icon.Text = "ℹ"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = S(15)
    icon.TextColor3 = Color3.fromRGB(100,160,255)
    icon.Parent = f
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-S(40),1,0)
    lbl.Position = UDim2.new(0,S(36),0,0)
    lbl.BackgroundTransparency=1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = S(11)
    lbl.TextColor3 = Color3.fromRGB(160,190,255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = f
    return f
end

local ESPPage = Pages["ESP"]
SectionLabel(ESPPage, "GENERAL")
Toggle(ESPPage, "ESP Master Switch", "Toggle all ESP overlays at once", "ESPEnabled")
Toggle(ESPPage, "Team Check", "Separate color for teammates", "ESPTeamCheck")
Toggle(ESPPage, "Show Teammates", "Render teammate ESP", "ESPShowTeammates")
Slider(ESPPage, "Max Distance", "ESPMaxDistance", 50, 3000, 0, " st")
SectionLabel(ESPPage, "BOXES")
Toggle(ESPPage, "Show Boxes", "Bounding box around players", "ESPBoxes")
Dropdown(ESPPage, "Box Style", {"2D", "Corner", "Filled", "3D"}, "ESPBoxStyle")
Toggle(ESPPage, "Filled Box", "Transparent fill inside box", "ESPBoxFilled")
Slider(ESPPage, "Box Thickness", "ESPBoxThickness", 0.5, 5, 1)
Slider(ESPPage, "Fill Transparency", "ESPBoxFillTrans", 0.5, 0.99, 2)
Slider(ESPPage, "Corner Length", "ESPBoxCornerLen", 3, 20, 0, " px")
ColorPicker(ESPPage, "Enemy Box Color", "ESPBoxColor")
ColorPicker(ESPPage, "Team Box Color", "ESPTeamColor")
SectionLabel(ESPPage, "INFO LABELS")
Toggle(ESPPage, "Player Names", "Show display names above heads", "ESPNames")
Slider(ESPPage, "Name Font Size", "ESPNameSize", 8, 22, 0)
Toggle(ESPPage, "Name Outline", "Outline text for visibility", "ESPNameOutline")
ColorPicker(ESPPage, "Name Color", "ESPNameColor")
Toggle(ESPPage, "Health Bar", "Show HP bar on characters", "ESPHealth")
Dropdown(ESPPage, "Health Style", {"Bar", "Text", "Both"}, "ESPHealthStyle")
Dropdown(ESPPage, "Health Bar Position", {"Left", "Right", "Top", "Bottom"}, "ESPHealthBarPos")
Toggle(ESPPage, "Health Gradient", "Green to red based on HP", "ESPHealthGradient")
Toggle(ESPPage, "Health as Text", "Show HP number", "ESPHealthText")
Toggle(ESPPage, "Distance Label", "Show distance in studs", "ESPDistance")
Slider(ESPPage, "Distance Font Size", "ESPDistanceSize", 8, 18, 0)
ColorPicker(ESPPage, "Distance Color", "ESPDistanceColor")
SectionLabel(ESPPage, "SKELETON")
Toggle(ESPPage, "Skeleton ESP", "Draw bone skeleton", "ESPSkeleton")
Slider(ESPPage, "Skeleton Thickness", "ESPSkeletonThick", 0.5, 4, 1)
ColorPicker(ESPPage, "Skeleton Color", "ESPSkeletonColor")
SectionLabel(ESPPage, "CHAMS & EXTRAS")
Toggle(ESPPage, "Chams", "Highlight models through walls", "ESPChams")
Toggle(ESPPage, "Chams Wall Check", "Only show through walls", "ESPChamsWall")
Slider(ESPPage, "Chams Transparency", "ESPChamsFillTrans", 0.1, 0.95, 2)
ColorPicker(ESPPage, "Chams Color", "ESPChamsColor")
Toggle(ESPPage, "Head Dot", "Dot on head position", "ESPHeadDot")
Slider(ESPPage, "Head Dot Size", "ESPHeadDotSize", 2, 12, 0)
ColorPicker(ESPPage, "Head Dot Color", "ESPHeadDotColor")
Toggle(ESPPage, "Tracers", "Line drawn to each player", "ESPTracers")
Dropdown(ESPPage, "Tracer Origin", {"Bottom", "Top", "Center", "Mouse"}, "ESPTracerOrigin")
Slider(ESPPage, "Tracer Thickness", "ESPTracerThick", 0.5, 4, 1)
ColorPicker(ESPPage, "Tracer Color", "ESPTracerColor")
Toggle(ESPPage, "Off-Screen Arrows", "Arrow pointing to offscreen players", "ESPArrows")
Slider(ESPPage, "Arrow Size", "ESPArrowSize", 8, 30, 0)
ColorPicker(ESPPage, "Arrow Color", "ESPArrowColor")

local AimPage = Pages["Aimbot"]
SectionLabel(AimPage, "AIMBOT")
Toggle(AimPage, "Aimbot", "Auto-aim at nearest target in FOV", "AimbotEnabled")
Toggle(AimPage, "Visible Check", "Only aim at visible players", "AimbotVisible")
Toggle(AimPage, "Team Check", "Ignore teammates", "AimbotTeamCheck")
Toggle(AimPage, "Lock On", "Stay locked until target dies", "AimbotLockOn")
Toggle(AimPage, "Auto Fire", "Auto-click when aimed", "AimbotAutoFire")
Toggle(AimPage, "Multi-Target", "Cycle between multiple targets", "AimbotMultiTarget")
Dropdown(AimPage, "Target Priority", {"Nearest", "Lowest HP", "Highest HP", "Random", "Crosshair"}, "AimbotPriority")
Dropdown(AimPage, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}, "AimbotPart")
KeybindWidget(AimPage, "Aimbot Hotkey", "AimbotKey")
SectionLabel(AimPage, "FOV & SMOOTHING")
Slider(AimPage, "FOV Radius", "AimbotFOV", 5, 600, 0, " px")
Slider(AimPage, "Smoothness", "AimbotSmooth", 0.01, 1.0, 2)
Slider(AimPage, "Hit Chance %", "AimbotHitChance", 5, 100, 0, "%")
Toggle(AimPage, "Show FOV Circle", "Draw FOV indicator on screen", "ShowFOVCircle")
Toggle(AimPage, "Filled FOV", "Fill FOV circle semi-transparent", "FOVCircleFilled")
Slider(AimPage, "FOV Circle Thickness", "FOVCircleThick", 0.5, 4, 1)
Slider(AimPage, "FOV Circle Sides", "FOVCircleSides", 8, 128, 0)
ColorPicker(AimPage, "FOV Circle Color", "FOVCircleColor")
Toggle(AimPage, "Highlight Target", "Show highlight on locked target", "AimbotHighlight")
ColorPicker(AimPage, "Highlight Color", "AimbotHighlightColor")
SectionLabel(AimPage, "STICKY AIM")
Toggle(AimPage, "Sticky Aim", "Slow aim speed near target", "AimbotStickyAim")
Slider(AimPage, "Sticky Range", "AimbotStickyRange", 5, 150, 0, " px")
SectionLabel(AimPage, "PREDICTION")
Toggle(AimPage, "Aim Prediction", "Lead target by velocity", "AimbotPrediction")
Slider(AimPage, "Prediction Strength", "AimbotPredStrength", 0.01, 0.8, 2)
SectionLabel(AimPage, "RECOIL")
Toggle(AimPage, "No Recoil", "Cancel weapon recoil", "NoRecoil")
Slider(AimPage, "Recoil Strength", "NoRecoilStrength", 0.1, 1.0, 2)
Slider(AimPage, "Recoil X Axis", "NoRecoilX", 0.0, 1.0, 2)
Slider(AimPage, "Recoil Y Axis", "NoRecoilY", 0.0, 1.0, 2)
Toggle(AimPage, "No Spread", "Remove bullet spread", "NoSpread")

local SilentPage = Pages["Silent"]
SectionLabel(SilentPage, "SILENT AIM")
InfoWidget(SilentPage, "Bullets are redirected to target without moving your crosshair. Requires hookmetamethod.")
Toggle(SilentPage, "Silent Aim", "Redirect bullets to target", "SilentAim")
Toggle(SilentPage, "Team Check", "Ignore teammates", "SilentAimTeamCheck")
Toggle(SilentPage, "Visible Check", "Only redirect to visible targets", "SilentAimCheck")
Dropdown(SilentPage, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso", "Neck", "Chest"}, "SilentAimPart")
Slider(SilentPage, "Silent Aim FOV", "SilentAimFOV", 5, 360, 0, "°")
Slider(SilentPage, "Hit Chance %", "SilentAimChance", 5, 100, 0, "%")
SectionLabel(SilentPage, "BULLET MODS")
Toggle(SilentPage, "Fast Shoot", "Increase fire rate", "FastShoot")
Toggle(SilentPage, "Infinite Ammo", "No reload required", "InfiniteAmmo")

local CombatPage = Pages["Combat"]
SectionLabel(CombatPage, "KILL AURA")
Toggle(CombatPage, "Kill Aura", "Auto-hit all nearby enemies", "KillAura")
Toggle(CombatPage, "Team Check", "Don't attack teammates", "KillAuraTeamCheck")
Toggle(CombatPage, "Auto Block", "Block between aura attacks", "KillAuraAutoBlock")
Toggle(CombatPage, "Angle Check", "Only hit players in front", "KillAuraAngles")
Slider(CombatPage, "Kill Aura Range", "KillAuraRange", 5, 120, 0, " st")
Slider(CombatPage, "Attack Cooldown", "KillAuraCooldown", 0.02, 3.0, 2, " s")
Dropdown(CombatPage, "Target Priority", {"Nearest", "Lowest HP", "Highest HP", "Random"}, "KillAuraPriority")
SectionLabel(CombatPage, "PARRY & BLOCK")
Toggle(CombatPage, "Auto Parry", "Automatically parry incoming attacks", "AutoParry")
Slider(CombatPage, "Parry Cooldown", "AutoParryCooldown", 0.05, 2.0, 2, " s")

local MovePage = Pages["Movement"]
SectionLabel(MovePage, "SPEED")
Toggle(MovePage, "Speed Hack", "Increase movement speed", "SpeedEnabled")
Slider(MovePage, "Speed Value", "SpeedValue", 16, 300, 0)
Dropdown(MovePage, "Speed Mode", {"WalkSpeed", "BodyVelocity", "VectorForce"}, "SpeedMode")
Toggle(MovePage, "Bunny Hop", "Auto-jump for strafe speed", "BunnyHop")
Slider(MovePage, "BHop Strength", "BunnyHopStrength", 0.5, 2.0, 1)
SectionLabel(MovePage, "JUMP")
Toggle(MovePage, "Infinite Jump", "Re-jump while airborne", "InfJump")
Toggle(MovePage, "Multi-Jump", "Jump multiple times in air", "MultiJump")
Slider(MovePage, "Multi-Jump Count", "MultiJumpCount", 2, 10, 0)
Slider(MovePage, "Jump Power", "JumpPower", 10, 300, 0)
SectionLabel(MovePage, "ADVANCED")
Toggle(MovePage, "Noclip", "Walk through walls", "Noclip")
Toggle(MovePage, "Fly", "Free flight mode", "Fly")
Slider(MovePage, "Fly Speed", "FlySpeed", 10, 300, 0)
Toggle(MovePage, "Anti-Knockback", "Resist knockback forces", "AntiKnockback")
Toggle(MovePage, "Long Neck", "Extend camera neck range", "LongNeck")
Slider(MovePage, "Neck Size", "LongNeckSize", 1, 20, 0)

local VisualsPage = Pages["Visuals"]
SectionLabel(VisualsPage, "WORLD LIGHTING")
Toggle(VisualsPage, "Full Bright", "Remove darkness from map", "FullBright")
Slider(VisualsPage, "Brightness Value", "FullBrightVal", 1, 20, 0)
Toggle(VisualsPage, "No Fog", "Remove all fog", "NoFog")
Toggle(VisualsPage, "Remove Sun", "Hide sun and sky effects", "SunRemove")
Toggle(VisualsPage, "Night Mode", "Make world very dark", "NightMode")
SectionLabel(VisualsPage, "CHAMS EFFECTS")
Toggle(VisualsPage, "Rainbow Chams", "Animate chams color", "RainbowChams")
Slider(VisualsPage, "Rainbow Speed", "RainbowSpeed", 0.1, 5.0, 1)
SectionLabel(VisualsPage, "WATERMARK")
Toggle(VisualsPage, "Show Watermark", "Display script name on screen", "Watermark")
Dropdown(VisualsPage, "Watermark Position", {"TopLeft", "TopRight", "BottomLeft", "BottomRight"}, "WatermarkPos")
Toggle(VisualsPage, "FPS Counter", "Show current framerate", "FPSCounter")

local CrosshairPage = Pages["Crosshair"]
SectionLabel(CrosshairPage, "CROSSHAIR")
Toggle(CrosshairPage, "Show Crosshair", "Custom crosshair overlay", "Crosshair")
Slider(CrosshairPage, "Size", "CrosshairSize", 4, 40, 0, " px")
Slider(CrosshairPage, "Thickness", "CrosshairThick", 0.5, 4, 1)
Slider(CrosshairPage, "Gap", "CrosshairGap", 0, 20, 0, " px")
Toggle(CrosshairPage, "Center Dot", "Dot in center of crosshair", "CrosshairDot")
ColorPicker(CrosshairPage, "Crosshair Color", "CrosshairColor")

local ThemePage = Pages["Theme"]
SectionLabel(ThemePage, "ACCENT COLOR")
InfoWidget(ThemePage, "Choose a color theme. Affects all GUI highlights and active states.")
local function ThemeBtn(name)
    local t = THEMES[name]
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,S(44))
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.Parent = ThemePage
    Round(f, S(10))
    Stroke(f, C.Border, 1)
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, S(30), 0, S(30))
    sw.Position = UDim2.new(0, S(10), 0.5, -S(15))
    sw.BackgroundColor3 = t[1]
    sw.BorderSizePixel = 0
    sw.Parent = f
    Round(sw, S(8))
    GradientFrame(sw, t[1], t[2], 135)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-S(60),1,0)
    lbl.Position = UDim2.new(0,S(48),0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = S(14)
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(0,S(24),1,0)
    check.Position = UDim2.new(1,-S(34),0,0)
    check.BackgroundTransparency = 1
    check.Text = CFG.ThemePreset == name and "✓" or ""
    check.Font = Enum.Font.GothamBold
    check.TextSize = S(16)
    check.TextColor3 = t[1]
    check.Parent = f
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency=1 btn.Text="" btn.Parent=f
    btn.MouseButton1Click:Connect(function()
        CFG.ThemePreset = name
        RefreshAccent()
        for _, tb in pairs(ThemePage:GetChildren()) do
            if tb:IsA("Frame") then
                local ch = tb:FindFirstChildOfClass("TextLabel")
                if ch and ch.Name == "" then
                    ch.Text = ""
                end
            end
        end
        check.Text = "✓"
        check.TextColor3 = t[1]
        MainStroke.Color = C.Accent
        BgGlow.BackgroundColor3 = C.Accent
        LogoBg.BackgroundColor3 = C.Accent
        GradientFrame(LogoBg, C.Accent, C.AccentDim, 135)
        ScrollBase.ScrollBarImageColor3 = C.Accent
        PageHeaderIcon.TextColor3 = C.Accent
    end)
    btn.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.CardHover},0.12) end)
    btn.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Card},0.12) end)
end
for name, _ in pairs(THEMES) do ThemeBtn(name) end

local ConfigPage = Pages["Config"]
SectionLabel(ConfigPage, "NOTIFICATIONS")
Toggle(ConfigPage, "Show Notifications", "On-screen toggle feedback", "ShowNotif")
Dropdown(ConfigPage, "Notification Position", {"BottomRight", "BottomLeft", "TopRight", "TopLeft"}, "NotifPos")
Slider(ConfigPage, "Notification Duration", "NotifDuration", 0.5, 6.0, 1, " s")
SectionLabel(ConfigPage, "ANTI-CHEAT")
Toggle(ConfigPage, "Anti-AFK", "Prevent idle kick", "AntiAFK")
SectionLabel(ConfigPage, "KEYBINDS")
KeybindWidget(ConfigPage, "Hide/Show GUI", "HideKey")

local function Notify(msg, col, icon)
    if not CFG.ShowNotif then return end
    col = col or C.Accent
    icon = icon or "⚡"
    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, S(280), 0, S(52))
    nf.BackgroundColor3 = C.Surface
    nf.BorderSizePixel = 0
    nf.ZIndex = 100
    nf.Parent = ScreenGui
    Round(nf, S(12))
    Stroke(nf, col, 1.5)

    local left = Instance.new("Frame")
    left.Size = UDim2.new(0, S(4), 0.7, 0)
    left.Position = UDim2.new(0, 0, 0.15, 0)
    left.BackgroundColor3 = col
    left.BorderSizePixel = 0
    left.ZIndex = 101
    left.Parent = nf
    Round(left, S(3))

    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, S(30), 1, 0)
    iconL.Position = UDim2.new(0, S(12), 0, 0)
    iconL.BackgroundTransparency = 1
    iconL.Text = icon
    iconL.Font = Enum.Font.GothamBold
    iconL.TextSize = S(18)
    iconL.TextColor3 = col
    iconL.ZIndex = 101
    iconL.Parent = nf

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -S(55), 1, 0)
    lbl.Position = UDim2.new(0, S(46), 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = msg
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = S(13)
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex = 101
    lbl.Parent = nf

    local pos = CFG.NotifPos
    local px = pos:find("Right") and UDim2.new(1, S(10), 1, 0) or UDim2.new(0, -S(290), 1, 0)
    local py = pos:find("Bottom") and UDim2.new(0, 0, 1, -S(62)) or UDim2.new(0, 0, 0, S(10))
    local destX = pos:find("Right") and UDim2.new(1, -S(290), py.Y.Scale, py.Y.Offset) or UDim2.new(0, S(10), py.Y.Scale, py.Y.Offset)

    nf.Position = UDim2.new(px.X.Scale, px.X.Offset, py.Y.Scale, py.Y.Offset)
    Tween(nf, {Position = destX}, 0.3, Enum.EasingStyle.Back)

    task.delay(CFG.NotifDuration, function()
        Tween(nf, {Position = UDim2.new(px.X.Scale, px.X.Offset, py.Y.Scale, py.Y.Offset)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function() nf:Destroy() end)
    end)
end

local WatermarkGui, WatermarkLabel, FPSLabel
local function BuildWatermark()
    if WatermarkGui then WatermarkGui:Destroy() end
    WatermarkGui = Instance.new("Frame")
    WatermarkGui.Size = UDim2.new(0, S(180), 0, S(30))
    WatermarkGui.BackgroundColor3 = C.Surface
    WatermarkGui.BorderSizePixel = 0
    WatermarkGui.ZIndex = 50
    WatermarkGui.Visible = CFG.Watermark
    WatermarkGui.Parent = ScreenGui
    Round(WatermarkGui, S(8))
    Stroke(WatermarkGui, C.Accent, 1)

    local pos = CFG.WatermarkPos
    if pos == "TopLeft" then WatermarkGui.Position = UDim2.new(0, S(10), 0, S(10))
    elseif pos == "TopRight" then WatermarkGui.Position = UDim2.new(1, -S(190), 0, S(10))
    elseif pos == "BottomLeft" then WatermarkGui.Position = UDim2.new(0, S(10), 1, -S(40))
    else WatermarkGui.Position = UDim2.new(1, -S(190), 1, -S(40)) end

    WatermarkLabel = Instance.new("TextLabel")
    WatermarkLabel.Size = UDim2.new(1, 0, 1, 0)
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.Text = "⚡ Anti God  |  BS"
    WatermarkLabel.Font = Enum.Font.GothamBold
    WatermarkLabel.TextSize = S(13)
    WatermarkLabel.TextColor3 = C.White
    WatermarkLabel.ZIndex = 51
    WatermarkLabel.Parent = WatermarkGui
end
BuildWatermark()

local CrosshairGui, CrossLines = nil, {}
local function BuildCrosshair()
    if CrosshairGui then CrosshairGui:Destroy() end
    if not CFG.Crosshair then return end
    CrosshairGui = Instance.new("Frame")
    CrosshairGui.Size = UDim2.new(1, 0, 1, 0)
    CrosshairGui.BackgroundTransparency = 1
    CrosshairGui.ZIndex = 80
    CrosshairGui.Parent = ScreenGui

    local cx = VP.X / 2
    local cy = VP.Y / 2
    local sz = CFG.CrosshairSize
    local th = CFG.CrosshairThick
    local gap = CFG.CrosshairGap
    local col = CFG.CrosshairColor

    local function mkLine(px, py, sw, sh)
        local l = Instance.new("Frame")
        l.Size = UDim2.new(0, S(sw), 0, S(sh))
        l.Position = UDim2.new(0, cx + S(px) - S(sw)/2, 0, cy + S(py) - S(sh)/2)
        l.BackgroundColor3 = col
        l.BorderSizePixel = 0
        l.ZIndex = 81
        l.Parent = CrosshairGui
        return l
    end

    mkLine(-(sz + gap), 0, sz, th)
    mkLine(gap, 0, sz, th)
    mkLine(0, -(sz + gap), th, sz)
    mkLine(0, gap, th, sz)

    if CFG.CrosshairDot then
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, S(3), 0, S(3))
        dot.Position = UDim2.new(0, cx - S(1), 0, cy - S(1))
        dot.BackgroundColor3 = col
        dot.BorderSizePixel = 0
        dot.ZIndex = 82
        dot.Parent = CrosshairGui
        Round(dot, S(2))
    end
end
BuildCrosshair()

local BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local ESPObjects = {}
local useDrawing = pcall(function() return Drawing.new("Square") end) and Drawing ~= nil
if not useDrawing then useDrawing = false end

local function MakeDrawing(dtype)
    if not useDrawing then return {Visible=false, Remove=function() end} end
    local ok, d = pcall(function() return Drawing.new(dtype) end)
    if ok then return d end
    return {Visible=false, Remove=function() end}
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    local obj = {
        Box       = MakeDrawing("Square"),
        NameTag   = MakeDrawing("Text"),
        Health    = MakeDrawing("Square"),
        HealthFill= MakeDrawing("Square"),
        HealthText= MakeDrawing("Text"),
        Distance  = MakeDrawing("Text"),
        Tracer    = MakeDrawing("Line"),
        HeadDot   = MakeDrawing("Circle"),
        Bones     = {},
    }
    for i = 1, #BONES do obj.Bones[i] = MakeDrawing("Line") end
    ESPObjects[player] = obj
end

local function HideESP(obj)
    if not obj then return end
    for _, v in pairs(obj) do
        if type(v) == "table" then
            for _, b in pairs(v) do pcall(function() b.Visible = false end) end
        else pcall(function() v.Visible = false end) end
    end
end

local function RemoveESP(player)
    local obj = ESPObjects[player]
    if not obj then return end
    for _, v in pairs(obj) do
        if type(v) == "table" then
            for _, b in pairs(v) do pcall(function() b:Remove() end) end
        else pcall(function() v:Remove() end) end
    end
    ESPObjects[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

local FOVCircle = MakeDrawing("Circle")

local rainbowHue = 0
local jumpCount = 0
local flyBV, flyBG

RunService.RenderStepped:Connect(function(dt)
    rainbowHue = (rainbowHue + dt * CFG.RainbowSpeed * 0.5) % 1

    pcall(function()
        FOVCircle.Visible    = CFG.ShowFOVCircle and CFG.AimbotEnabled
        FOVCircle.Radius     = CFG.AimbotFOV
        FOVCircle.Position   = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Color      = CFG.FOVCircleColor
        FOVCircle.Thickness  = CFG.FOVCircleThick
        FOVCircle.Filled     = CFG.FOVCircleFilled
        FOVCircle.Transparency = CFG.FOVCircleFilled and 0.88 or 1
        FOVCircle.NumSides   = CFG.FOVCircleSides
    end)

    if WatermarkGui then WatermarkGui.Visible = CFG.Watermark end

    for player, obj in pairs(ESPObjects) do
        local char   = GetCharacter(player)
        local root   = GetRoot(player)
        local hum    = GetHumanoid(player)

        if not char or not root or not hum or hum.Health <= 0 or not CFG.ESPEnabled then
            HideESP(obj) continue
        end
        if CFG.ESPTeamCheck and not CFG.ESPShowTeammates and IsTeammate(player) then
            HideESP(obj) continue
        end
        local dist = GetDist(player)
        if dist > CFG.ESPMaxDistance then HideESP(obj) continue end

        local col = (CFG.ESPTeamCheck and IsTeammate(player)) and CFG.ESPTeamColor or CFG.ESPBoxColor
        if CFG.RainbowChams then
            col = Color3.fromHSV(rainbowHue, 1, 1)
        end

        local head  = char:FindFirstChild("Head")
        local torso = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")

        if head and torso then
            local headWP = head.Position + Vector3.new(0, head.Size.Y / 2 + 0.1, 0)
            local feetWP = torso.Position - Vector3.new(0, torso.Size.Y / 2 + 0.5, 0)

            local headSP, headVis = Camera:WorldToViewportPoint(headWP)
            local feetSP, _       = Camera:WorldToViewportPoint(feetWP)

            if headVis then
                local bh = math.abs(headSP.Y - feetSP.Y)
                local bw = bh * 0.6
                local cx = headSP.X
                local top = math.min(headSP.Y, feetSP.Y)

                pcall(function()
                    obj.Box.Visible    = CFG.ESPBoxes
                    obj.Box.Size       = Vector2.new(bw, bh)
                    obj.Box.Position   = Vector2.new(cx - bw/2, top)
                    obj.Box.Color      = col
                    obj.Box.Thickness  = CFG.ESPBoxThickness
                    obj.Box.Filled     = CFG.ESPBoxFilled
                    obj.Box.Transparency = CFG.ESPBoxFilled and (1 - CFG.ESPBoxFillTrans) or 1
                end)

                pcall(function()
                    obj.NameTag.Visible  = CFG.ESPNames
                    obj.NameTag.Text     = player.DisplayName
                    obj.NameTag.Size     = CFG.ESPNameSize
                    obj.NameTag.Position = Vector2.new(cx, top - CFG.ESPNameSize - 3)
                    obj.NameTag.Color    = CFG.ESPNameColor
                    obj.NameTag.Center   = true
                    obj.NameTag.Outline  = CFG.ESPNameOutline
                    obj.NameTag.Font     = CFG.ESPNameSize > 14 and Font.fromEnum(Enum.Font.GothamBold) or nil
                end)

                pcall(function()
                    obj.Distance.Visible  = CFG.ESPDistance
                    obj.Distance.Text     = math.floor(dist) .. "st"
                    obj.Distance.Size     = CFG.ESPDistanceSize
                    obj.Distance.Position = Vector2.new(cx, top + bh + 2)
                    obj.Distance.Color    = CFG.ESPDistanceColor
                    obj.Distance.Center   = true
                    obj.Distance.Outline  = true
                end)

                if CFG.ESPHealth then
                    local hp   = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    local rr   = hp < 0.5 and 1 or (2 - 2*hp)
                    local gg   = hp > 0.5 and 1 or (2*hp)
                    local hcol = CFG.ESPHealthGradient and Color3.new(rr, gg, 0) or col
                    local bx   = cx - bw/2 - 6
                    pcall(function()
                        obj.Health.Visible     = true
                        obj.Health.Size        = Vector2.new(4, bh)
                        obj.Health.Position    = Vector2.new(bx, top)
                        obj.Health.Color       = Color3.fromRGB(30, 30, 30)
                        obj.Health.Filled      = true
                        obj.Health.Transparency= 0.5

                        obj.HealthFill.Visible     = true
                        obj.HealthFill.Size        = Vector2.new(4, bh * hp)
                        obj.HealthFill.Position    = Vector2.new(bx, top + bh * (1 - hp))
                        obj.HealthFill.Color       = hcol
                        obj.HealthFill.Filled      = true
                        obj.HealthFill.Transparency= 0
                    end)
                else
                    pcall(function() obj.Health.Visible = false obj.HealthFill.Visible = false end)
                end

                pcall(function()
                    obj.Tracer.Visible    = CFG.ESPTracers
                    local vp = Camera.ViewportSize
                    local oy = CFG.ESPTracerOrigin == "Bottom" and vp.Y or (CFG.ESPTracerOrigin == "Top" and 0 or vp.Y/2)
                    obj.Tracer.From       = Vector2.new(vp.X/2, oy)
                    obj.Tracer.To         = Vector2.new(cx, top + bh/2)
                    obj.Tracer.Color      = CFG.ESPTracerColor
                    obj.Tracer.Thickness  = CFG.ESPTracerThick
                end)

                pcall(function()
                    obj.HeadDot.Visible  = CFG.ESPHeadDot
                    obj.HeadDot.Position = Vector2.new(cx, headSP.Y)
                    obj.HeadDot.Radius   = CFG.ESPHeadDotSize
                    obj.HeadDot.Color    = CFG.ESPHeadDotColor
                    obj.HeadDot.Filled   = true
                    obj.HeadDot.Transparency = 0
                end)

                if CFG.ESPSkeleton then
                    for i, pair in ipairs(BONES) do
                        if obj.Bones[i] then
                            local b0 = char:FindFirstChild(pair[1])
                            local b1 = char:FindFirstChild(pair[2])
                            if b0 and b1 then
                                local p0, v0 = Camera:WorldToViewportPoint(b0.Position)
                                local p1, v1 = Camera:WorldToViewportPoint(b1.Position)
                                pcall(function()
                                    obj.Bones[i].Visible    = v0 and v1
                                    obj.Bones[i].From       = Vector2.new(p0.X, p0.Y)
                                    obj.Bones[i].To         = Vector2.new(p1.X, p1.Y)
                                    obj.Bones[i].Color      = CFG.ESPSkeletonColor
                                    obj.Bones[i].Thickness  = CFG.ESPSkeletonThick
                                end)
                            else
                                pcall(function() obj.Bones[i].Visible = false end)
                            end
                        end
                    end
                else
                    for _, b in ipairs(obj.Bones) do pcall(function() b.Visible = false end) end
                end
            else
                HideESP(obj)
            end
        end
    end
end)

local function GetClosestPlayer()
    local best, bestDist, bestPart = nil, CFG.AimbotFOV, nil
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if CFG.AimbotTeamCheck and IsTeammate(p) then continue end
        if not IsAlive(p) then continue end
        local char = GetCharacter(p) if not char then continue end
        local part = char:FindFirstChild(CFG.AimbotPart) or char:FindFirstChild("Head")
        if not part then continue end
        if CFG.AimbotVisible then
            local origin = Camera.CFrame.Position
            local dir = (part.Position - origin).Unit * 5000
            local ray = Ray.new(origin, dir)
            local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {GetCharacter(LocalPlayer)})
            if hit and not hit:IsDescendantOf(char) then continue end
        end
        local sp, vis = Camera:WorldToViewportPoint(part.Position)
        if not vis then continue end
        local d2 = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        local pr = CFG.AimbotPriority
        if pr == "Nearest" then
            if d2 < bestDist then best=p bestDist=d2 bestPart=part end
        elseif pr == "Lowest HP" then
            local h = GetHumanoid(p)
            if d2 <= CFG.AimbotFOV and h and h.Health < bestDist then best=p bestDist=h.Health bestPart=part end
        elseif pr == "Crosshair" then
            if d2 < bestDist then best=p bestDist=d2 bestPart=part end
        else
            if d2 < bestDist then best=p bestDist=d2 bestPart=part end
        end
    end
    return best, bestPart
end

local lastAuraTime = 0
local lastParryTime = 0
local multiJumpCount = 0

RunService.Heartbeat:Connect(function(dt)
    local now = tick()

    if CFG.AimbotEnabled then
        local holding = false
        if typeof(CFG.AimbotKey) == "EnumItem" then
            if CFG.AimbotKey.EnumType == Enum.UserInputType then
                holding = UserInputService:IsMouseButtonPressed(CFG.AimbotKey)
            else
                holding = UserInputService:IsKeyDown(CFG.AimbotKey)
            end
        end
        if holding then
            local target, part = GetClosestPlayer()
            if target and part then
                local predicted = part.Position
                if CFG.AimbotPrediction then
                    local vel = part.AssemblyLinearVelocity or Vector3.new()
                    predicted = part.Position + vel * CFG.AimbotPredStrength
                end
                if math.random(1, 100) <= CFG.AimbotHitChance then
                    local tp, _ = Camera:WorldToViewportPoint(predicted)
                    local mx = Mouse.X
                    local my = Mouse.Y
                    local dx = tp.X - mx
                    local dy = tp.Y - my
                    local smooth = CFG.AimbotSmooth
                    if CFG.AimbotStickyAim then
                        local d = Vector2.new(dx, dy).Magnitude
                        if d < CFG.AimbotStickyRange then smooth = smooth * 0.25 end
                    end
                    pcall(function()
                        mousemoverel(dx * (1 - smooth), dy * (1 - smooth))
                    end)
                end
            end
        end
    end

    if CFG.KillAura and now - lastAuraTime >= CFG.KillAuraCooldown then
        lastAuraTime = now
        local best, bestVal = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if CFG.KillAuraTeamCheck and IsTeammate(p) then continue end
            if not IsAlive(p) then continue end
            local d = GetDist(p) if d > CFG.KillAuraRange then continue end
            local hum = GetHumanoid(p)
            local v = CFG.KillAuraPriority == "Lowest HP" and (hum and hum.Health or 9999)
                   or CFG.KillAuraPriority == "Random" and math.random()
                   or d
            if v < bestVal then best = p bestVal = v end
        end
        if best then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
                    if remote then
                        local tr = GetRoot(best)
                        if tr then pcall(function() remote:FireServer(tr.Position) end) end
                    end
                end
            end
        end
    end

    if CFG.SpeedEnabled then
        local hum = GetHumanoid(LocalPlayer)
        if hum and CFG.SpeedMode == "WalkSpeed" then
            hum.WalkSpeed = CFG.SpeedValue
        end
    else
        local hum = GetHumanoid(LocalPlayer)
        if hum and hum.WalkSpeed ~= 16 and not CFG.SpeedEnabled then
            hum.WalkSpeed = 16
        end
    end

    if CFG.Fly then
        local root = GetRoot(LocalPlayer)
        if root then
            if not flyBV or not flyBV.Parent then
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
                flyBV.Velocity = Vector3.new(0,0,0)
                flyBV.Parent = root
                flyBG = Instance.new("BodyGyro")
                flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
                flyBG.CFrame = root.CFrame
                flyBG.Parent = root
            end
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * CFG.FlySpeed or Vector3.new(0,0,0)
        end
    else
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        if flyBG and flyBG.Parent then flyBG:Destroy() end
    end

    if CFG.FullBright then
        Lighting.Brightness = CFG.FullBrightVal
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e9
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    end

    if CFG.NoFog then
        Lighting.FogEnd = 1e9
        Lighting.FogStart = 1e9
    end

    if CFG.NightMode then
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
    end

    if CFG.AntiKnockback then
        local root = GetRoot(LocalPlayer)
        if root then
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            if bv and not CFG.Fly then bv.Velocity = Vector3.new(0,0,0) end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump then
        local hum = GetHumanoid(LocalPlayer)
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
    if CFG.MultiJump then
        local hum = GetHumanoid(LocalPlayer)
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall and jumpCount < CFG.MultiJumpCount then
            jumpCount = jumpCount + 1
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    if CFG.Noclip then
        local char = GetCharacter(LocalPlayer)
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
    local hum = GetHumanoid(LocalPlayer)
    if hum then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Landed then
            jumpCount = 0
        end
        if CFG.InfJump then
            hum.JumpPower = CFG.JumpPower
        end
    end
end)

if CFG.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), CFrame.new())
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), CFrame.new())
    end)
end

pcall(function()
    if hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(t, k)
            if CFG.SilentAim and k == "Hit" and rawget(t, "ClassName") == "Mouse" then
                if CFG.SilentAimTeamCheck then
                    local target, part = GetClosestPlayer()
                    if target and part then
                        local sp, _ = Camera:WorldToViewportPoint(part.Position)
                        local d = Vector2.new(sp.X - Camera.ViewportSize.X/2, sp.Y - Camera.ViewportSize.Y/2).Magnitude
                        if d <= CFG.SilentAimFOV and math.random(1,100) <= CFG.SilentAimChance then
                            return part.CFrame
                        end
                    end
                end
            end
            return oldIndex(t, k)
        end)
    end
end)

Tween(MainFrame, {Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}, 0, Enum.EasingStyle.Quart)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
Tween(MainFrame, {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}, 0.4, Enum.EasingStyle.Back)
task.delay(0.45, function()
    Notify("Anti God loaded!", C.Accent, "⚡")
end)
