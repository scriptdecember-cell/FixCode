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
end)

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local VP       = Camera.ViewportSize

local GW = isMobile and math.min(VP.X - 20, 420) or 580
local GH = isMobile and math.min(VP.Y - 60, 380) or 450
local FS = isMobile and 11 or 13
local TS = isMobile and 9  or 11

local CFG = {
    ESPEnabled        = false, ESPBoxes = true, ESPBoxStyle = "Corner",
    ESPBoxColor       = Color3.fromRGB(80,200,255), ESPBoxThickness = 1.5,
    ESPBoxFilled      = false, ESPBoxFillTrans = 0.85, ESPBoxCornerLen = 6,
    ESPNames          = true, ESPNameSize = 13, ESPNameColor = Color3.fromRGB(255,255,255),
    ESPNameOutline    = true, ESPHealth = true, ESPHealthGradient = true,
    ESPHealthBarPos   = "Left", ESPDistance = true,
    ESPDistanceColor  = Color3.fromRGB(180,180,255), ESPDistanceSize = 11,
    ESPMaxDistance    = 1000, ESPSkeleton = false,
    ESPSkeletonColor  = Color3.fromRGB(255,200,60), ESPSkeletonThick = 1.2,
    ESPChams          = false, ESPChamsColor = Color3.fromRGB(80,200,255), ESPChamsTrans = 0.65,
    ESPTeamCheck      = true, ESPTeamColor = Color3.fromRGB(60,230,100), ESPShowTeammates = false,
    ESPTracers        = false, ESPTracerOrigin = "Bottom",
    ESPTracerColor    = Color3.fromRGB(80,200,255), ESPTracerThick = 1,
    ESPHeadDot        = false, ESPHeadDotColor = Color3.fromRGB(255,60,60), ESPHeadDotSize = 4,
    ESPArrows         = false, ESPArrowColor = Color3.fromRGB(80,200,255), ESPArrowSize = 14,

    AimbotEnabled     = false, AimbotFOV = 130, AimbotSmooth = 0.20,
    AimbotPart        = "Head", AimbotPrediction = true, AimbotPredStrength = 0.14,
    AimbotVisible     = false, AimbotTeamCheck = true,
    AimbotKey         = Enum.UserInputType.MouseButton2,
    ShowFOVCircle     = true, FOVCircleColor = Color3.fromRGB(255,255,255),
    FOVCircleThick    = 1.5, FOVCircleFilled = false,
    AimbotLockOn      = false, AimbotAutoFire = false, AimbotHitChance = 100,
    AimbotStickyAim   = false, AimbotStickyRange = 45,
    AimbotHighlight   = true, AimbotHighlightColor = Color3.fromRGB(255,60,60),
    AimbotPriority    = "Nearest",

    SilentAim         = false, SilentAimPart = "Head", SilentAimFOV = 180,
    SilentAimCheck    = false, SilentAimChance = 100, SilentAimTeamCheck = true,

    NoRecoil          = false, NoRecoilStrength = 1.0, NoSpread = false,
    FastShoot         = false, InfiniteAmmo = false,

    KillAura          = false, KillAuraRange = 22, KillAuraTeamCheck = true,
    KillAuraCooldown  = 0.08, KillAuraAutoBlock = false, KillAuraPriority = "Nearest",
    AutoParry         = false, AutoParryCooldown = 0.15,

    SpeedEnabled      = false, SpeedValue = 32, SpeedMode = "WalkSpeed",
    BunnyHop          = false, BunnyHopStr = 1.0,
    InfJump           = false, JumpPower = 55,
    MultiJump         = false, MultiJumpCount = 2,
    Noclip            = false, Fly = false, FlySpeed = 60,
    AntiKnockback     = false,

    FullBright        = false, FullBrightVal = 10, NoFog = false,
    NightMode         = false, RainbowChams = false, RainbowSpeed = 1.0,
    Watermark         = true, FPSCounter = false,
    Crosshair         = false, CrosshairColor = Color3.fromRGB(255,255,255),
    CrosshairSize     = 10, CrosshairThick = 1.5, CrosshairGap = 4, CrosshairDot = true,

    AntiAFK           = true, ShowNotif = true,
    HideKey           = Enum.KeyCode.RightShift,
    ThemePreset       = "Blue",
}

local THEMES = {
    Blue   = Color3.fromRGB(70,150,255),
    Purple = Color3.fromRGB(140,70,255),
    Red    = Color3.fromRGB(255,55,75),
    Green  = Color3.fromRGB(50,215,110),
    Cyan   = Color3.fromRGB(50,210,255),
    Orange = Color3.fromRGB(255,135,35),
    Pink   = Color3.fromRGB(255,90,190),
}

local ACC = THEMES[CFG.ThemePreset]

local BG1 = Color3.fromRGB(10,10,16)
local BG2 = Color3.fromRGB(16,16,26)
local BG3 = Color3.fromRGB(22,22,34)
local BG4 = Color3.fromRGB(28,28,42)
local BDR = Color3.fromRGB(40,40,62)
local TXT = Color3.fromRGB(220,220,250)
local SUB = Color3.fromRGB(120,120,160)
local MUT = Color3.fromRGB(65,65,100)
local WHT = Color3.fromRGB(255,255,255)
local CON = Color3.fromRGB(65,225,115)
local COF = Color3.fromRGB(255,60,80)

local function tw(o,p,t,s,d) TweenService:Create(o,TweenInfo.new(t or .18,s or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p):Play() end
local function rnd(f,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=f return c end
local function str(f,c,t) local s=Instance.new("UIStroke") s.Color=c or BDR s.Thickness=t or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=f return s end
local function pad(f,t,b,l,r) local p=Instance.new("UIPadding") p.PaddingTop=UDim.new(0,t or 0) p.PaddingBottom=UDim.new(0,b or 0) p.PaddingLeft=UDim.new(0,l or 0) p.PaddingRight=UDim.new(0,r or 0) p.Parent=f return p end
local function ll(f,d,a,p) local l=Instance.new("UIListLayout") l.FillDirection=d or Enum.FillDirection.Vertical l.HorizontalAlignment=a or Enum.HorizontalAlignment.Left l.Padding=UDim.new(0,p or 0) l.Parent=f return l end
local function mk(cls,props) local o=Instance.new(cls) for k,v in pairs(props) do o[k]=v end return o end

local function getChar(p) return p and p.Character end
local function getRoot(p) local c=getChar(p) return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(p) local c=getChar(p) return c and c:FindFirstChildOfClass("Humanoid") end
local function alive(p) local h=getHum(p) return h and h.Health>0 end
local function teammate(p) return p.Team==LocalPlayer.Team end
local function dist(p) local r=getRoot(p) local m=getRoot(LocalPlayer) if r and m then return (r.Position-m.Position).Magnitude end return math.huge end

local SG = Instance.new("ScreenGui")
SG.Name="AntiGod" SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.ResetOnSpawn=false SG.DisplayOrder=999 SG.IgnoreGuiInset=true
pcall(function() SG.Parent=CoreGui end)
if not SG.Parent then SG.Parent=LocalPlayer.PlayerGui end

local TBW = isMobile and 90 or 115

local MF = mk("Frame",{
    Name="MF", Size=UDim2.new(0,GW,0,GH),
    Position=UDim2.new(0.5,-GW/2,0.5,-GH/2),
    BackgroundColor3=BG1, BorderSizePixel=0, Parent=SG,
})
rnd(MF,14) str(MF,BDR,1.5)

local TOPBAR = mk("Frame",{
    Size=UDim2.new(1,0,0,isMobile and 42 or 50),
    BackgroundColor3=BG2, BorderSizePixel=0, ZIndex=10, Parent=MF,
})
rnd(TOPBAR,14)
mk("Frame",{
    Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,1,-14),
    BackgroundColor3=BG2, BorderSizePixel=0, ZIndex=10, Parent=TOPBAR,
})
mk("Frame",{
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=BDR, BorderSizePixel=0, ZIndex=11, Parent=TOPBAR,
})

local LOGOBG = mk("Frame",{
    Size=UDim2.new(0,isMobile and 30 or 36,0,isMobile and 30 or 36),
    Position=UDim2.new(0,10,0.5,isMobile and -15 or -18),
    BackgroundColor3=ACC, BorderSizePixel=0, ZIndex=11, Parent=TOPBAR,
})
rnd(LOGOBG,9)
mk("TextLabel",{
    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="⚡",
    Font=Enum.Font.GothamBold, TextSize=isMobile and 16 or 19,
    TextColor3=WHT, ZIndex=12, Parent=LOGOBG,
})

mk("TextLabel",{
    Size=UDim2.new(0,160,0,20), Position=UDim2.new(0,isMobile and 46 or 54,0.5,isMobile and -10 or -12),
    BackgroundTransparency=1, Text="Anti God",
    Font=Enum.Font.GothamBold, TextSize=isMobile and 15 or 18,
    TextColor3=WHT, TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=11, Parent=TOPBAR,
})
mk("TextLabel",{
    Size=UDim2.new(0,160,0,12), Position=UDim2.new(0,isMobile and 47 or 55,0.5,isMobile and 11 or 9),
    BackgroundTransparency=1, Text="BloxStrike  •  v3.0",
    Font=Enum.Font.Gotham, TextSize=isMobile and 9 or 11,
    TextColor3=SUB, TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=11, Parent=TOPBAR,
})

local function winBtn(txt, col, ox)
    local bsz = isMobile and 24 or 28
    local b = mk("TextButton",{
        Size=UDim2.new(0,bsz,0,bsz), Position=UDim2.new(1,ox,0.5,-bsz/2),
        BackgroundColor3=col, Text=txt, Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 13, TextColor3=WHT,
        BorderSizePixel=0, ZIndex=12, Parent=TOPBAR,
    })
    rnd(b,7)
    return b
end

local btnOff = isMobile and -8 or -10
local CLOSEBTN = winBtn("✕", COF, btnOff - (isMobile and 28 or 34))
local MINBTN   = winBtn("–", Color3.fromRGB(255,185,40), btnOff - (isMobile and 28 or 34)*2 - (isMobile and 4 or 4))

CLOSEBTN.MouseButton1Click:Connect(function()
    tw(MF,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    task.delay(.35,function() SG:Destroy() end)
end)

local minned = false
local CONTENT = mk("Frame",{
    Size=UDim2.new(1,0,1,-(isMobile and 42 or 50)),
    Position=UDim2.new(0,0,0,isMobile and 42 or 50),
    BackgroundTransparency=1, Parent=MF,
})

MINBTN.MouseButton1Click:Connect(function()
    minned = not minned
    if minned then
        CONTENT.Visible=false
        tw(MF,{Size=UDim2.new(0,GW,0,isMobile and 42 or 50)},.22,Enum.EasingStyle.Quart)
    else
        CONTENT.Visible=true
        tw(MF,{Size=UDim2.new(0,GW,0,GH)},.26,Enum.EasingStyle.Back)
    end
end)

local drg,ds,dp=false,nil,nil
TOPBAR.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drg=true ds=i.Position dp=MF.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-ds
        MF.Position=UDim2.new(0,math.clamp(dp.X.Offset+d.X,0,VP.X-GW),0,math.clamp(dp.Y.Offset+d.Y,0,VP.Y-GH))
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=false end
end)
UserInputService.InputBegan:Connect(function(i,s)
    if not s and i.KeyCode==CFG.HideKey then MF.Visible=not MF.Visible end
end)

local TABF = mk("Frame",{
    Size=UDim2.new(0,TBW,1,-12),
    Position=UDim2.new(0,6,0,6),
    BackgroundColor3=BG2, BorderSizePixel=0, Parent=CONTENT,
})
rnd(TABF,12) str(TABF,BDR,1)

local TABSCROLL = mk("ScrollingFrame",{
    Size=UDim2.new(1,-10,1,-10), Position=UDim2.new(0,5,0,5),
    BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y,
    CanvasSize=UDim2.new(0,0,0,0), Parent=TABF,
})
ll(TABSCROLL,Enum.FillDirection.Vertical,Enum.HorizontalAlignment.Left,isMobile and 3 or 4)
pad(TABSCROLL,4,4,0,0)

local PAGEHOLDER = mk("Frame",{
    Size=UDim2.new(1,-(TBW+16),1,-12),
    Position=UDim2.new(0,TBW+10,0,6),
    BackgroundColor3=BG2, BorderSizePixel=0, Parent=CONTENT,
})
rnd(PAGEHOLDER,12) str(PAGEHOLDER,BDR,1)

local PAGEHEADER = mk("Frame",{
    Size=UDim2.new(1,0,0,isMobile and 36 or 42),
    BackgroundColor3=BG3, BorderSizePixel=0, ZIndex=2, Parent=PAGEHOLDER,
})
rnd(PAGEHEADER,12)
mk("Frame",{
    Size=UDim2.new(1,0,0,12), Position=UDim2.new(0,0,1,-12),
    BackgroundColor3=BG3, BorderSizePixel=0, ZIndex=2, Parent=PAGEHEADER,
})
mk("Frame",{
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=BDR, BorderSizePixel=0, ZIndex=3, Parent=PAGEHEADER,
})

local PHIcon = mk("TextLabel",{
    Size=UDim2.new(0,24,1,0), Position=UDim2.new(0,12,0,0),
    BackgroundTransparency=1, Text="👁",
    Font=Enum.Font.GothamBold, TextSize=isMobile and 15 or 17,
    TextColor3=ACC, ZIndex=3, Parent=PAGEHEADER,
})
local PHTitle = mk("TextLabel",{
    Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,40,0,0),
    BackgroundTransparency=1, Text="ESP",
    Font=Enum.Font.GothamBold, TextSize=isMobile and 13 or 15,
    TextColor3=TXT, TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=3, Parent=PAGEHEADER,
})

local PAGESGAP = isMobile and 40 or 46
local SCROLL = mk("ScrollingFrame",{
    Size=UDim2.new(1,-8,1,-PAGESGAP-6),
    Position=UDim2.new(0,4,0,PAGESGAP+2),
    BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=ACC,
    ScrollBarImageTransparency=0.4,
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    CanvasSize=UDim2.new(0,0,0,0), Parent=PAGEHOLDER,
})

local Pages={} local TabBtns={} local ActiveTab=nil

local TABS={
    {n="ESP",    ic="👁",  lb="ESP"},
    {n="Aimbot", ic="🎯",  lb="Aimbot"},
    {n="Silent", ic="🔇",  lb="Silent Aim"},
    {n="Combat", ic="⚔",  lb="Combat"},
    {n="Move",   ic="🏃",  lb="Movement"},
    {n="Visual", ic="✨",  lb="Visuals"},
    {n="Cross",  ic="⊕",  lb="Crosshair"},
    {n="Theme",  ic="🎨",  lb="Theme"},
    {n="Config", ic="⚙",  lb="Config"},
}

for _,tab in ipairs(TABS) do
    local pg = mk("Frame",{
        Name=tab.n, Size=UDim2.new(1,0,0,0),
        BackgroundTransparency=1, Visible=false, Parent=SCROLL,
    })
    ll(pg,Enum.FillDirection.Vertical,Enum.HorizontalAlignment.Left,isMobile and 4 or 5)
    pad(pg,6,8,5,5)
    Pages[tab.n]=pg

    local TBH = isMobile and 32 or 36
    local bf = mk("Frame",{
        Size=UDim2.new(1,0,0,TBH),
        BackgroundColor3=BG3, BorderSizePixel=0, Parent=TABSCROLL,
    })
    rnd(bf,8)

    local bar = mk("Frame",{
        Size=UDim2.new(0,3,0.6,0), Position=UDim2.new(0,0,0.2,0),
        BackgroundColor3=ACC, BorderSizePixel=0,
        BackgroundTransparency=1, Parent=bf,
    })
    rnd(bar,3)

    local icL = mk("TextLabel",{
        Size=UDim2.new(0,isMobile and 20 or 24,1,0),
        Position=UDim2.new(0,isMobile and 8 or 9,0,0),
        BackgroundTransparency=1, Text=tab.ic,
        Font=Enum.Font.GothamBold, TextSize=isMobile and 13 or 15,
        TextColor3=SUB, Parent=bf,
    })

    local lbL = mk("TextLabel",{
        Size=UDim2.new(1,-(isMobile and 32 or 38),1,0),
        Position=UDim2.new(0,isMobile and 30 or 36,0,0),
        BackgroundTransparency=1, Text=tab.lb,
        Font=Enum.Font.Gotham, TextSize=isMobile and 11 or 12,
        TextColor3=SUB, TextXAlignment=Enum.TextXAlignment.Left, Parent=bf,
    })

    local hb = mk("TextButton",{
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="", Parent=bf,
    })

    hb.MouseEnter:Connect(function()
        if ActiveTab~=tab.n then tw(bf,{BackgroundColor3=BG4},.1) end
    end)
    hb.MouseLeave:Connect(function()
        if ActiveTab~=tab.n then tw(bf,{BackgroundColor3=BG3},.1) end
    end)
    hb.MouseButton1Click:Connect(function()
        if ActiveTab==tab.n then return end
        ActiveTab=tab.n
        for n,tb in pairs(TabBtns) do
            local on=(n==tab.n)
            tw(tb.f,{BackgroundColor3=on and BG4 or BG3},.15)
            tb.ic.TextColor3 = on and ACC or SUB
            tb.lb.TextColor3 = on and TXT or SUB
            tb.lb.Font = on and Enum.Font.GothamBold or Enum.Font.Gotham
            tb.bar.BackgroundTransparency = on and 0 or 1
        end
        for n,p in pairs(Pages) do
            p.Visible=(n==tab.n)
        end
        SCROLL.CanvasPosition=Vector2.new(0,0)
        PHIcon.Text=tab.ic
        PHTitle.Text=tab.lb
        PHIcon.TextColor3=ACC
    end)

    TabBtns[tab.n]={f=bf,ic=icL,lb=lbL,bar=bar}
end

local function switchTab(name)
    for _,tab in ipairs(TABS) do
        if tab.n==name then
            TabBtns[name].f.MouseButton1Click:Fire()
            break
        end
    end
end
ActiveTab="ESP"
TabBtns["ESP"].f.BackgroundColor3=BG4
TabBtns["ESP"].ic.TextColor3=ACC
TabBtns["ESP"].lb.TextColor3=TXT
TabBtns["ESP"].lb.Font=Enum.Font.GothamBold
TabBtns["ESP"].bar.BackgroundTransparency=0
Pages["ESP"].Visible=true
PHIcon.Text="👁" PHTitle.Text="ESP" PHIcon.TextColor3=ACC

local function secLabel(page,text)
    local f=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 24 or 28),BackgroundTransparency=1,Parent=page})
    mk("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,.5,0),BackgroundColor3=BDR,BorderSizePixel=0,Parent=f})
    local pill=mk("Frame",{Size=UDim2.new(0,#text*6+18,1,0),BackgroundColor3=BG2,BorderSizePixel=0,Parent=f})
    rnd(pill,5) str(pill,BDR,1)
    mk("Frame",{Size=UDim2.new(0,3,0.6,0),Position=UDim2.new(0,5,0.2,0),BackgroundColor3=ACC,BorderSizePixel=0,Parent=pill})
    mk("TextLabel",{Size=UDim2.new(1,-6,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=text,Font=Enum.Font.GothamBold,TextSize=isMobile and 9 or 10,TextColor3=ACC,TextXAlignment=Enum.TextXAlignment.Left,Parent=pill})
end

local function toggle(page,label,desc,key,cb)
    local fh = desc and (isMobile and 48 or 54) or (isMobile and 36 or 42)
    local f=mk("Frame",{Size=UDim2.new(1,0,0,fh),BackgroundColor3=BG3,BorderSizePixel=0,Parent=page})
    rnd(f,9) str(f,BDR,1)

    local acbar=mk("Frame",{Size=UDim2.new(0,3,0.55,0),Position=UDim2.new(0,0,0.225,0),BackgroundColor3=CFG[key] and ACC or BDR,BorderSizePixel=0,Parent=f})
    rnd(acbar,2)

    mk("TextLabel",{
        Size=UDim2.new(1,-58,0,isMobile and 16 or 19),
        Position=UDim2.new(0,12,0,desc and (isMobile and 6 or 8) or (isMobile and 9 or 11)),
        BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamBold,
        TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
    })

    if desc then
        mk("TextLabel",{
            Size=UDim2.new(1,-58,0,isMobile and 13 or 15),
            Position=UDim2.new(0,12,0,isMobile and 25 or 30),
            BackgroundTransparency=1,Text=desc,Font=Enum.Font.Gotham,
            TextSize=TS,TextColor3=SUB,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
        })
    end

    local trW=isMobile and 38 or 44
    local trH=isMobile and 20 or 22
    local track=mk("Frame",{
        Size=UDim2.new(0,trW,0,trH),Position=UDim2.new(1,-(trW+10),0.5,-trH/2),
        BackgroundColor3=CFG[key] and ACC or BDR,BorderSizePixel=0,Parent=f,
    })
    rnd(track,trH/2)

    local kW=isMobile and 14 or 16
    local knob=mk("Frame",{
        Size=UDim2.new(0,kW,0,kW),
        Position=CFG[key] and UDim2.new(1,-(kW+3),0.5,-kW/2) or UDim2.new(0,3,0.5,-kW/2),
        BackgroundColor3=WHT,BorderSizePixel=0,ZIndex=2,Parent=track,
    })
    rnd(knob,kW/2)

    local sdot=mk("Frame",{
        Size=UDim2.new(0,6,0,6),Position=UDim2.new(1,-14,0,4),
        BackgroundColor3=CFG[key] and CON or COF,BorderSizePixel=0,ZIndex=2,Parent=f,
    })
    rnd(sdot,3)

    local btn=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=f})
    btn.MouseButton1Click:Connect(function()
        CFG[key]=not CFG[key]
        local on=CFG[key]
        tw(track,{BackgroundColor3=on and ACC or BDR},.18)
        tw(knob,{Position=on and UDim2.new(1,-(kW+3),0.5,-kW/2) or UDim2.new(0,3,0.5,-kW/2)},.18)
        tw(f,{BackgroundColor3=on and BG4 or BG3},.18)
        tw(acbar,{BackgroundColor3=on and ACC or BDR},.18)
        tw(sdot,{BackgroundColor3=on and CON or COF},.15)
        if cb then cb(on) end
    end)
    btn.MouseEnter:Connect(function() if not CFG[key] then tw(f,{BackgroundColor3=BG4},.1) end end)
    btn.MouseLeave:Connect(function() if not CFG[key] then tw(f,{BackgroundColor3=BG3},.1) end end)
    return f
end

local function slider(page,label,key,mn,mx,dec,sfx,cb)
    local f=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 54 or 62),BackgroundColor3=BG3,BorderSizePixel=0,Parent=page})
    rnd(f,9) str(f,BDR,1)

    mk("TextLabel",{
        Size=UDim2.new(1,-100,0,isMobile and 16 or 18),Position=UDim2.new(0,12,0,isMobile and 6 or 8),
        BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamBold,
        TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
    })

    local fmt=dec and dec>0 and ("%."..dec.."f") or "%d"
    local sfxs=sfx or ""

    local vbg=mk("Frame",{
        Size=UDim2.new(0,isMobile and 68 or 80,0,isMobile and 20 or 24),
        Position=UDim2.new(1,-isMobile and 78 or 92,0,isMobile and 4 or 5),
        BackgroundColor3=BG1,BorderSizePixel=0,Parent=f,
    })
    vbg.Position=UDim2.new(1,isMobile and -80 or -94,0,isMobile and 4 or 5)
    rnd(vbg,6) str(vbg,BDR,1)

    local vl=mk("TextLabel",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Text=string.format(fmt,CFG[key])..sfxs,
        Font=Enum.Font.GothamBold,TextSize=isMobile and 11 or 12,TextColor3=ACC,Parent=vbg,
    })

    local trackY = isMobile and 36 or 42
    local tbg=mk("Frame",{
        Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,0,trackY),
        BackgroundColor3=BDR,BorderSizePixel=0,Parent=f,
    })
    rnd(tbg,3)

    local p0=math.clamp((CFG[key]-mn)/(mx-mn),0,1)
    local fill=mk("Frame",{Size=UDim2.new(p0,0,1,0),BackgroundColor3=ACC,BorderSizePixel=0,Parent=tbg})
    rnd(fill,3)

    local gW=isMobile and 14 or 16
    local grip=mk("Frame",{
        Size=UDim2.new(0,gW,0,gW),Position=UDim2.new(p0,-gW/2,0.5,-gW/2),
        BackgroundColor3=WHT,BorderSizePixel=0,ZIndex=3,Parent=tbg,
    })
    rnd(grip,gW/2) str(grip,ACC,1.5)

    local sliding=false
    local hb=mk("TextButton",{
        Size=UDim2.new(1,0,0,isMobile and 28 or 32),Position=UDim2.new(0,0,0.5,-(isMobile and 14 or 16)),
        BackgroundTransparency=1,Text="",ZIndex=4,Parent=tbg,
    })

    local function upd(x)
        local p=math.clamp((x-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X,0,1)
        local raw=mn+(mx-mn)*p
        local r=dec and math.floor(raw*10^dec+.5)/10^dec or math.floor(raw+.5)
        CFG[key]=r vl.Text=string.format(fmt,r)..sfxs
        tw(fill,{Size=UDim2.new(p,0,1,0)},.04)
        tw(grip,{Position=UDim2.new(p,-gW/2,0.5,-gW/2)},.04)
        if cb then cb(r) end
    end

    hb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sliding=true upd(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end)
    f.MouseEnter:Connect(function() tw(f,{BackgroundColor3=BG4},.1) end)
    f.MouseLeave:Connect(function() tw(f,{BackgroundColor3=BG3},.1) end)
    return f
end

local function dropdown(page,label,opts,key,cb)
    local f=mk("Frame",{
        Size=UDim2.new(1,0,0,isMobile and 44 or 50),
        BackgroundColor3=BG3,BorderSizePixel=0,ClipsDescendants=true,Parent=page,
    })
    rnd(f,9) str(f,BDR,1)

    mk("TextLabel",{
        Size=UDim2.new(1,-120,0,isMobile and 16 or 18),
        Position=UDim2.new(0,12,0.5,isMobile and -8 or -9),
        BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamBold,
        TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
    })

    local sbg=mk("Frame",{
        Size=UDim2.new(0,isMobile and 100 or 115,0,isMobile and 24 or 28),
        Position=UDim2.new(1,isMobile and -112 or -127,0.5,isMobile and -12 or -14),
        BackgroundColor3=BG1,BorderSizePixel=0,Parent=f,
    })
    rnd(sbg,7) str(sbg,ACC,1)

    local sb=mk("TextButton",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Text=CFG[key].."  ▾",Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 12,TextColor3=ACC,Parent=sbg,
    })

    local iH=isMobile and 26 or 29
    local dH=#opts*iH+10
    local df=mk("Frame",{
        Size=UDim2.new(0,isMobile and 100 or 115,0,dH),
        Position=UDim2.new(1,isMobile and -112 or -127,0,isMobile and 44 or 50),
        BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=25,Visible=false,Parent=f,
    })
    rnd(df,9) str(df,ACC,1)
    pad(df,4,4,4,4) ll(df,Enum.FillDirection.Vertical,Enum.HorizontalAlignment.Left,3)

    for _,opt in ipairs(opts) do
        local ob=mk("TextButton",{
            Size=UDim2.new(1,0,0,isMobile and 23 or 26),
            BackgroundColor3=CFG[key]==opt and Color3.fromRGB(30,50,100) or BG3,
            Text=opt,Font=CFG[key]==opt and Enum.Font.GothamBold or Enum.Font.Gotham,
            TextSize=isMobile and 11 or 12,
            TextColor3=CFG[key]==opt and ACC or SUB,
            BorderSizePixel=0,ZIndex=26,Parent=df,
        })
        rnd(ob,6)
        ob.MouseButton1Click:Connect(function()
            CFG[key]=opt sb.Text=opt.."  ▾"
            for _,c in ipairs(df:GetChildren()) do
                if c:IsA("TextButton") then
                    local on=c.Text==opt
                    tw(c,{BackgroundColor3=on and Color3.fromRGB(30,50,100) or BG3},.08)
                    c.TextColor3=on and ACC or SUB
                    c.Font=on and Enum.Font.GothamBold or Enum.Font.Gotham
                end
            end
            df.Visible=false f.ClipsDescendants=true
            tw(f,{Size=UDim2.new(1,0,0,isMobile and 44 or 50)},.15)
            if cb then cb(opt) end
        end)
    end

    local dopen=false
    sb.MouseButton1Click:Connect(function()
        dopen=not dopen
        if dopen then
            f.ClipsDescendants=false df.Visible=true
            tw(f,{Size=UDim2.new(1,0,0,(isMobile and 44 or 50)+dH+6)},.2,Enum.EasingStyle.Back)
        else
            df.Visible=false f.ClipsDescendants=true
            tw(f,{Size=UDim2.new(1,0,0,isMobile and 44 or 50)},.15)
        end
    end)
    f.MouseEnter:Connect(function() tw(f,{BackgroundColor3=BG4},.1) end)
    f.MouseLeave:Connect(function() tw(f,{BackgroundColor3=BG3},.1) end)
    return f
end

local CPRESETS={
    Color3.fromRGB(255,60,80),Color3.fromRGB(255,140,40),Color3.fromRGB(255,220,60),
    Color3.fromRGB(60,220,110),Color3.fromRGB(60,215,255),Color3.fromRGB(70,150,255),
    Color3.fromRGB(150,70,255),Color3.fromRGB(255,90,190),Color3.fromRGB(255,255,255),
    Color3.fromRGB(160,160,160),Color3.fromRGB(80,80,80),Color3.fromRGB(10,10,10),
}

local function colorpick(page,label,key,cb)
    local f=mk("Frame",{
        Size=UDim2.new(1,0,0,isMobile and 38 or 44),
        BackgroundColor3=BG3,BorderSizePixel=0,ClipsDescendants=true,Parent=page,
    })
    rnd(f,9) str(f,BDR,1)

    mk("TextLabel",{
        Size=UDim2.new(1,-72,0,isMobile and 16 or 18),
        Position=UDim2.new(0,12,0.5,isMobile and -8 or -9),
        BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamBold,
        TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
    })

    local sw=mk("Frame",{
        Size=UDim2.new(0,isMobile and 46 or 54,0,isMobile and 22 or 26),
        Position=UDim2.new(1,isMobile and -58 or -66,0.5,isMobile and -11 or -13),
        BackgroundColor3=CFG[key],BorderSizePixel=0,Parent=f,
    })
    rnd(sw,7) str(sw,BDR,1)
    mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="▾",Font=Enum.Font.GothamBold,TextSize=isMobile and 11 or 12,TextColor3=Color3.new(1,1,1),TextTransparency=0.5,Parent=sw})

    local cols=isMobile and 6 or 6
    local csz=isMobile and 24 or 28
    local cpad=4
    local rows=math.ceil(#CPRESETS/cols)
    local pickerH=rows*(csz+cpad)+cpad+8

    local pf=mk("Frame",{
        Size=UDim2.new(1,-24,0,pickerH),Position=UDim2.new(0,12,0,isMobile and 38 or 44),
        BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=15,Visible=false,Parent=f,
    })
    rnd(pf,9) str(pf,ACC,1)
    pad(pf,cpad,cpad,cpad,cpad)

    local grid=Instance.new("UIGridLayout")
    grid.CellSize=UDim2.new(0,csz,0,csz)
    grid.CellPadding=UDim2.new(0,cpad,0,cpad)
    grid.Parent=pf

    for _,col in ipairs(CPRESETS) do
        local cb2=mk("TextButton",{Size=UDim2.new(0,csz,0,csz),BackgroundColor3=col,Text="",BorderSizePixel=0,ZIndex=16,Parent=pf})
        rnd(cb2,7)
        cb2.MouseButton1Click:Connect(function()
            CFG[key]=col sw.BackgroundColor3=col
            pf.Visible=false f.ClipsDescendants=true
            tw(f,{Size=UDim2.new(1,0,0,isMobile and 38 or 44)},.15)
            if cb then cb(col) end
        end)
    end

    local popen=false
    local swbtn=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=6,Parent=sw})
    swbtn.MouseButton1Click:Connect(function()
        popen=not popen
        if popen then
            f.ClipsDescendants=false pf.Visible=true
            tw(f,{Size=UDim2.new(1,0,0,(isMobile and 38 or 44)+pickerH+8)},.2,Enum.EasingStyle.Back)
        else
            pf.Visible=false f.ClipsDescendants=true
            tw(f,{Size=UDim2.new(1,0,0,isMobile and 38 or 44)},.15)
        end
    end)
    f.MouseEnter:Connect(function() tw(f,{BackgroundColor3=BG4},.1) end)
    f.MouseLeave:Connect(function() tw(f,{BackgroundColor3=BG3},.1) end)
    return f
end

local function keybind(page,label,key)
    local f=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 40 or 46),BackgroundColor3=BG3,BorderSizePixel=0,Parent=page})
    rnd(f,9) str(f,BDR,1)
    mk("TextLabel",{
        Size=UDim2.new(1,-110,0,isMobile and 16 or 18),
        Position=UDim2.new(0,12,0.5,isMobile and -8 or -9),
        BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamBold,
        TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=f,
    })
    local function kname(k)
        if k==Enum.UserInputType.MouseButton2 then return "RMB"
        elseif k==Enum.UserInputType.MouseButton1 then return "LMB"
        else return tostring(k):match("%.(%w+)$") or "?" end
    end
    local kbg=mk("Frame",{
        Size=UDim2.new(0,isMobile and 88 or 100,0,isMobile and 24 or 28),
        Position=UDim2.new(1,isMobile and -100 or -112,0.5,isMobile and -12 or -14),
        BackgroundColor3=BG1,BorderSizePixel=0,Parent=f,
    })
    rnd(kbg,7) str(kbg,ACC,1)
    local kb=mk("TextButton",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Text=kname(CFG[key]),Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 12,TextColor3=ACC,Parent=kbg,
    })
    local lstn=false
    kb.MouseButton1Click:Connect(function()
        if lstn then return end lstn=true kb.Text="..." kb.TextColor3=WHT
        local c; c=UserInputService.InputBegan:Connect(function(i,s)
            if s then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.MouseButton2 then
                CFG[key]=i.UserInputType kb.Text=kname(i.UserInputType) kb.TextColor3=ACC lstn=false c:Disconnect()
            elseif i.UserInputType==Enum.UserInputType.Keyboard then
                CFG[key]=i.KeyCode kb.Text=kname(i.KeyCode) kb.TextColor3=ACC lstn=false c:Disconnect()
            end
        end)
    end)
    f.MouseEnter:Connect(function() tw(f,{BackgroundColor3=BG4},.1) end)
    f.MouseLeave:Connect(function() tw(f,{BackgroundColor3=BG3},.1) end)
end

local EP=Pages["ESP"]
secLabel(EP,"GENERAL")
toggle(EP,"ESP","Enable all ESP overlays","ESPEnabled")
toggle(EP,"Team Check","Separate color for teammates","ESPTeamCheck")
toggle(EP,"Show Teammates","Render teammate ESP","ESPShowTeammates")
slider(EP,"Max Distance","ESPMaxDistance",50,3000,0," st")
secLabel(EP,"BOXES")
toggle(EP,"Show Boxes","Bounding box","ESPBoxes")
dropdown(EP,"Box Style",{"2D","Corner","Filled"},"ESPBoxStyle")
toggle(EP,"Filled Box","Transparent fill","ESPBoxFilled")
slider(EP,"Box Thickness","ESPBoxThickness",0.5,5,1)
slider(EP,"Corner Length","ESPBoxCornerLen",3,20,0," px")
colorpick(EP,"Enemy Box Color","ESPBoxColor")
colorpick(EP,"Team Box Color","ESPTeamColor")
secLabel(EP,"INFO")
toggle(EP,"Names","Show display names","ESPNames")
slider(EP,"Name Size","ESPNameSize",8,22,0)
colorpick(EP,"Name Color","ESPNameColor")
toggle(EP,"Health Bar","HP bar on characters","ESPHealth")
dropdown(EP,"Health Bar Pos",{"Left","Right","Top","Bottom"},"ESPHealthBarPos")
toggle(EP,"HP Gradient","Green to red","ESPHealthGradient")
toggle(EP,"Distance","Show distance in studs","ESPDistance")
colorpick(EP,"Distance Color","ESPDistanceColor")
secLabel(EP,"EXTRAS")
toggle(EP,"Skeleton","Bone skeleton","ESPSkeleton")
slider(EP,"Skeleton Thickness","ESPSkeletonThick",0.5,4,1)
colorpick(EP,"Skeleton Color","ESPSkeletonColor")
toggle(EP,"Chams","Highlight through walls","ESPChams")
slider(EP,"Chams Transparency","ESPChamsTrans",0.1,0.95,2)
colorpick(EP,"Chams Color","ESPChamsColor")
toggle(EP,"Head Dot","Dot on head","ESPHeadDot")
colorpick(EP,"Head Dot Color","ESPHeadDotColor")
toggle(EP,"Tracers","Line to each player","ESPTracers")
dropdown(EP,"Tracer Origin",{"Bottom","Top","Center"},"ESPTracerOrigin")
colorpick(EP,"Tracer Color","ESPTracerColor")
toggle(EP,"Off-Screen Arrows","Arrow to offscreen players","ESPArrows")
colorpick(EP,"Arrow Color","ESPArrowColor")

local AP=Pages["Aimbot"]
secLabel(AP,"AIMBOT")
toggle(AP,"Aimbot","Auto-aim at nearest target","AimbotEnabled")
toggle(AP,"Visible Check","Only aim at visible players","AimbotVisible")
toggle(AP,"Team Check","Ignore teammates","AimbotTeamCheck")
toggle(AP,"Lock On","Stay locked until target dies","AimbotLockOn")
toggle(AP,"Auto Fire","Auto-click when aimed","AimbotAutoFire")
dropdown(AP,"Target Priority",{"Nearest","Lowest HP","Highest HP","Random"},"AimbotPriority")
dropdown(AP,"Target Part",{"Head","HumanoidRootPart","UpperTorso","LeftArm","RightArm"},"AimbotPart")
keybind(AP,"Aimbot Hotkey","AimbotKey")
secLabel(AP,"FOV & SMOOTHING")
slider(AP,"FOV Radius","AimbotFOV",5,600,0," px")
slider(AP,"Smoothness","AimbotSmooth",0.01,1.0,2)
slider(AP,"Hit Chance","AimbotHitChance",5,100,0,"%")
toggle(AP,"Show FOV Circle","Draw FOV ring","ShowFOVCircle")
toggle(AP,"Filled FOV","Fill FOV circle","FOVCircleFilled")
slider(AP,"FOV Thickness","FOVCircleThick",0.5,4,1)
colorpick(AP,"FOV Color","FOVCircleColor")
toggle(AP,"Highlight Target","Show highlight on target","AimbotHighlight")
colorpick(AP,"Highlight Color","AimbotHighlightColor")
secLabel(AP,"PREDICTION & STICKY")
toggle(AP,"Aim Prediction","Lead target by velocity","AimbotPrediction")
slider(AP,"Prediction Strength","AimbotPredStrength",0.01,0.8,2)
toggle(AP,"Sticky Aim","Slow aim near target","AimbotStickyAim")
slider(AP,"Sticky Range","AimbotStickyRange",5,150,0," px")
secLabel(AP,"RECOIL")
toggle(AP,"No Recoil","Cancel weapon recoil","NoRecoil")
slider(AP,"Recoil Strength","NoRecoilStrength",0.1,1.0,2)
toggle(AP,"No Spread","Remove bullet spread","NoSpread")

local SP=Pages["Silent"]
secLabel(SP,"SILENT AIM")
toggle(SP,"Silent Aim","Redirect bullets to target","SilentAim")
toggle(SP,"Team Check","Ignore teammates","SilentAimTeamCheck")
toggle(SP,"Visible Check","Only redirect to visible","SilentAimCheck")
dropdown(SP,"Target Part",{"Head","HumanoidRootPart","UpperTorso"},"SilentAimPart")
slider(SP,"Silent Aim FOV","SilentAimFOV",5,360,0,"°")
slider(SP,"Hit Chance","SilentAimChance",5,100,0,"%")
secLabel(SP,"BULLET MODS")
toggle(SP,"Fast Shoot","Increase fire rate","FastShoot")
toggle(SP,"Infinite Ammo","No reload required","InfiniteAmmo")

local CP=Pages["Combat"]
secLabel(CP,"KILL AURA")
toggle(CP,"Kill Aura","Auto-hit nearby enemies","KillAura")
toggle(CP,"Team Check","Don't attack teammates","KillAuraTeamCheck")
toggle(CP,"Auto Block","Block between attacks","KillAuraAutoBlock")
slider(CP,"Kill Aura Range","KillAuraRange",5,120,0," st")
slider(CP,"Attack Cooldown","KillAuraCooldown",0.02,3.0,2," s")
dropdown(CP,"Target Priority",{"Nearest","Lowest HP","Highest HP","Random"},"KillAuraPriority")
secLabel(CP,"PARRY")
toggle(CP,"Auto Parry","Auto parry incoming attacks","AutoParry")
slider(CP,"Parry Cooldown","AutoParryCooldown",0.05,2.0,2," s")

local MP=Pages["Move"]
secLabel(MP,"SPEED")
toggle(MP,"Speed Hack","Increase movement speed","SpeedEnabled")
slider(MP,"Speed Value","SpeedValue",16,300,0)
dropdown(MP,"Speed Mode",{"WalkSpeed","BodyVelocity"},"SpeedMode")
toggle(MP,"Bunny Hop","Auto-jump for strafe","BunnyHop")
secLabel(MP,"JUMP")
toggle(MP,"Infinite Jump","Re-jump while airborne","InfJump")
toggle(MP,"Multi-Jump","Jump multiple times","MultiJump")
slider(MP,"Multi-Jump Count","MultiJumpCount",2,10,0)
slider(MP,"Jump Power","JumpPower",10,300,0)
secLabel(MP,"ADVANCED")
toggle(MP,"Noclip","Walk through walls","Noclip")
toggle(MP,"Fly","Free flight mode","Fly")
slider(MP,"Fly Speed","FlySpeed",10,300,0)
toggle(MP,"Anti-Knockback","Resist knockback","AntiKnockback")

local VP2=Pages["Visual"]
secLabel(VP2,"WORLD")
toggle(VP2,"Full Bright","Remove darkness","FullBright")
slider(VP2,"Brightness","FullBrightVal",1,20,0)
toggle(VP2,"No Fog","Remove all fog","NoFog")
toggle(VP2,"Night Mode","Make world dark","NightMode")
toggle(VP2,"Rainbow Chams","Animate chams color","RainbowChams")
slider(VP2,"Rainbow Speed","RainbowSpeed",0.1,5.0,1)
secLabel(VP2,"HUD")
toggle(VP2,"Watermark","Show script name","Watermark")
toggle(VP2,"FPS Counter","Show current FPS","FPSCounter")

local XP=Pages["Cross"]
secLabel(XP,"CROSSHAIR")
toggle(XP,"Show Crosshair","Custom crosshair overlay","Crosshair")
slider(XP,"Size","CrosshairSize",4,40,0," px")
slider(XP,"Thickness","CrosshairThick",0.5,4,1)
slider(XP,"Gap","CrosshairGap",0,20,0," px")
toggle(XP,"Center Dot","Dot in center","CrosshairDot")
colorpick(XP,"Crosshair Color","CrosshairColor")

local ThP=Pages["Theme"]
secLabel(ThP,"COLOR THEME")
for tname,tcol in pairs(THEMES) do
    local tf=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 40 or 46),BackgroundColor3=BG3,BorderSizePixel=0,Parent=ThP})
    rnd(tf,9) str(tf,BDR,1)
    local tsw=mk("Frame",{Size=UDim2.new(0,isMobile and 26 or 32,0,isMobile and 26 or 32),Position=UDim2.new(0,8,0.5,isMobile and -13 or -16),BackgroundColor3=tcol,BorderSizePixel=0,Parent=tf})
    rnd(tsw,8)
    mk("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,isMobile and 40 or 48,0,0),BackgroundTransparency=1,Text=tname,Font=Enum.Font.GothamBold,TextSize=FS,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,Parent=tf})
    local chk=mk("TextLabel",{Size=UDim2.new(0,24,1,0),Position=UDim2.new(1,-30,0,0),BackgroundTransparency=1,Text=CFG.ThemePreset==tname and "✓" or "",Font=Enum.Font.GothamBold,TextSize=FS,TextColor3=tcol,Parent=tf})
    local tb2=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=tf})
    tb2.MouseButton1Click:Connect(function()
        CFG.ThemePreset=tname ACC=tcol
        SCROLL.ScrollBarImageColor3=ACC
        PHIcon.TextColor3=ACC LOGOBG.BackgroundColor3=ACC
        for _,b in pairs(TabBtns) do b.bar.BackgroundColor3=ACC end
        for _,c in ipairs(ThP:GetChildren()) do
            if c:IsA("Frame") then
                local cl=c:FindFirstChildOfClass("TextLabel")
                for _,lbl in ipairs(c:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text=="✓" then lbl.Text="" end
                end
            end
        end
        chk.Text="✓"
        if ActiveTab then
            local tb=TabBtns[ActiveTab]
            if tb then tw(tb.bar,{BackgroundColor3=ACC},.1) end
        end
    end)
    tb2.MouseEnter:Connect(function() tw(tf,{BackgroundColor3=BG4},.1) end)
    tb2.MouseLeave:Connect(function() tw(tf,{BackgroundColor3=BG3},.1) end)
end

local ConfP=Pages["Config"]
secLabel(ConfP,"SETTINGS")
toggle(ConfP,"Notifications","On-screen feedback","ShowNotif")
toggle(ConfP,"Anti AFK","Prevent idle kick","AntiAFK")
keybind(ConfP,"Hide GUI Key","HideKey")

local function notify(msg,col,ic)
    if not CFG.ShowNotif then return end
    col=col or ACC ic=ic or "⚡"
    local nf=mk("Frame",{
        Size=UDim2.new(0,isMobile and 220 or 260,0,isMobile and 44 or 50),
        Position=UDim2.new(1,10,1,-(isMobile and 54 or 62)),
        BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=100,Parent=SG,
    })
    rnd(nf,10) str(nf,col,1.5)
    mk("Frame",{Size=UDim2.new(0,3,0.65,0),Position=UDim2.new(0,0,0.175,0),BackgroundColor3=col,BorderSizePixel=0,ZIndex=101,Parent=nf})
    mk("TextLabel",{Size=UDim2.new(0,28,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=ic,Font=Enum.Font.GothamBold,TextSize=isMobile and 15 or 17,TextColor3=col,ZIndex=101,Parent=nf})
    mk("TextLabel",{Size=UDim2.new(1,-45,1,0),Position=UDim2.new(0,40,0,0),BackgroundTransparency=1,Text=msg,Font=Enum.Font.GothamBold,TextSize=isMobile and 11 or 13,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101,Parent=nf})
    tw(nf,{Position=UDim2.new(1,-(isMobile and 230 or 270),1,-(isMobile and 54 or 62))},.3,Enum.EasingStyle.Back)
    task.delay(2.5,function()
        tw(nf,{Position=UDim2.new(1,10,1,-(isMobile and 54 or 62))},.28,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.delay(.35,function() nf:Destroy() end)
    end)
end

local WMF
local function buildWM()
    if WMF then WMF:Destroy() end
    if not CFG.Watermark then return end
    WMF=mk("Frame",{
        Size=UDim2.new(0,isMobile and 150 or 180,0,isMobile and 26 or 30),
        Position=UDim2.new(1,isMobile and -158 or -188,0,8),
        BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=50,Parent=SG,
    })
    rnd(WMF,8) str(WMF,ACC,1)
    mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="⚡ Anti God  |  BS",Font=Enum.Font.GothamBold,TextSize=isMobile and 11 or 13,TextColor3=WHT,ZIndex=51,Parent=WMF})
end
buildWM()

local CHF
local function buildCH()
    if CHF then CHF:Destroy() end
    if not CFG.Crosshair then return end
    CHF=mk("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=80,Parent=SG})
    local vp=Camera.ViewportSize
    local cx,cy=vp.X/2,vp.Y/2
    local sz,th,gap=CFG.CrosshairSize,CFG.CrosshairThick,CFG.CrosshairGap
    local col=CFG.CrosshairColor
    local function mkL(px,py,sw,sh)
        local l=mk("Frame",{Size=UDim2.new(0,sw,0,sh),Position=UDim2.new(0,cx+px-sw/2,0,cy+py-sh/2),BackgroundColor3=col,BorderSizePixel=0,ZIndex=81,Parent=CHF})
    end
    mkL(-(sz+gap),0,sz,th) mkL(gap,0,sz,th) mkL(0,-(sz+gap),th,sz) mkL(0,gap,th,sz)
    if CFG.CrosshairDot then
        local d=mk("Frame",{Size=UDim2.new(0,3,0,3),Position=UDim2.new(0,cx-1,0,cy-1),BackgroundColor3=col,BorderSizePixel=0,ZIndex=82,Parent=CHF})
        rnd(d,2)
    end
end

local BONES={
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local ESPO={}
local useD=false
pcall(function() local t=Drawing.new("Square") t:Remove() useD=true end)

local function mkD(t)
    if not useD then return {Visible=false,Remove=function()end} end
    local ok,d=pcall(function() return Drawing.new(t) end)
    return ok and d or {Visible=false,Remove=function()end}
end

local function createESP(p)
    if p==LocalPlayer then return end
    local o={
        Box=mkD("Square"),Name=mkD("Text"),
        HP=mkD("Square"),HPF=mkD("Square"),
        Dist=mkD("Text"),Tracer=mkD("Line"),
        HDot=mkD("Circle"),Bones={},
    }
    for i=1,#BONES do o.Bones[i]=mkD("Line") end
    ESPO[p]=o
end
local function hideESP(o)
    if not o then return end
    for _,v in pairs(o) do
        if type(v)=="table" then for _,b in pairs(v) do pcall(function() b.Visible=false end) end
        else pcall(function() v.Visible=false end) end
    end
end
local function removeESP(p)
    local o=ESPO[p] if not o then return end
    for _,v in pairs(o) do
        if type(v)=="table" then for _,b in pairs(v) do pcall(function() b:Remove() end) end
        else pcall(function() v:Remove() end) end
    end
    ESPO[p]=nil
end

for _,p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

local FOVC=mkD("Circle")
local rHue=0
local flyBV,flyBG
local jmpCount=0
local auraT=0

RunService.RenderStepped:Connect(function(dt)
    rHue=(rHue+dt*CFG.RainbowSpeed*0.5)%1

    pcall(function()
        FOVC.Visible=CFG.ShowFOVCircle and CFG.AimbotEnabled
        FOVC.Radius=CFG.AimbotFOV
        local vp=Camera.ViewportSize
        FOVC.Position=Vector2.new(vp.X/2,vp.Y/2)
        FOVC.Color=CFG.FOVCircleColor
        FOVC.Thickness=CFG.FOVCircleThick
        FOVC.Filled=CFG.FOVCircleFilled
        FOVC.Transparency=CFG.FOVCircleFilled and 0.88 or 1
        FOVC.NumSides=64
    end)

    for pl,o in pairs(ESPO) do
        local ch=getChar(pl) local rt=getRoot(pl) local hm=getHum(pl)
        if not ch or not rt or not hm or hm.Health<=0 or not CFG.ESPEnabled then hideESP(o) continue end
        if CFG.ESPTeamCheck and not CFG.ESPShowTeammates and teammate(pl) then hideESP(o) continue end
        local d=dist(pl) if d>CFG.ESPMaxDistance then hideESP(o) continue end

        local col=(CFG.ESPTeamCheck and teammate(pl)) and CFG.ESPTeamColor or CFG.ESPBoxColor
        if CFG.RainbowChams then col=Color3.fromHSV(rHue,1,1) end

        local head=ch:FindFirstChild("Head")
        local torso=ch:FindFirstChild("LowerTorso") or ch:FindFirstChild("Torso")

        if head and torso then
            local hsp,hv=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,head.Size.Y/2+0.1,0))
            local fsp,_=Camera:WorldToViewportPoint(torso.Position-Vector3.new(0,torso.Size.Y/2+0.5,0))
            if hv then
                local bh=math.abs(hsp.Y-fsp.Y) local bw=bh*0.6 local cx=hsp.X
                local top=math.min(hsp.Y,fsp.Y)
                pcall(function()
                    o.Box.Visible=CFG.ESPBoxes o.Box.Size=Vector2.new(bw,bh)
                    o.Box.Position=Vector2.new(cx-bw/2,top) o.Box.Color=col
                    o.Box.Thickness=CFG.ESPBoxThickness o.Box.Filled=CFG.ESPBoxFilled
                    o.Box.Transparency=CFG.ESPBoxFilled and (1-CFG.ESPBoxFillTrans) or 1
                end)
                pcall(function()
                    o.Name.Visible=CFG.ESPNames o.Name.Text=pl.DisplayName
                    o.Name.Size=CFG.ESPNameSize o.Name.Position=Vector2.new(cx,top-CFG.ESPNameSize-3)
                    o.Name.Color=CFG.ESPNameColor o.Name.Center=true o.Name.Outline=CFG.ESPNameOutline
                end)
                pcall(function()
                    o.Dist.Visible=CFG.ESPDistance o.Dist.Text=math.floor(d).."st"
                    o.Dist.Size=CFG.ESPDistanceSize o.Dist.Position=Vector2.new(cx,top+bh+2)
                    o.Dist.Color=CFG.ESPDistanceColor o.Dist.Center=true o.Dist.Outline=true
                end)
                if CFG.ESPHealth then
                    local hp=math.clamp(hm.Health/math.max(hm.MaxHealth,1),0,1)
                    local rr=hp<0.5 and 1 or (2-2*hp) local gg=hp>0.5 and 1 or 2*hp
                    local hc=CFG.ESPHealthGradient and Color3.new(rr,gg,0) or col
                    local bx=cx-bw/2-6
                    pcall(function()
                        o.HP.Visible=true o.HP.Size=Vector2.new(4,bh) o.HP.Position=Vector2.new(bx,top)
                        o.HP.Color=Color3.fromRGB(30,30,30) o.HP.Filled=true o.HP.Transparency=0.5
                        o.HPF.Visible=true o.HPF.Size=Vector2.new(4,bh*hp)
                        o.HPF.Position=Vector2.new(bx,top+bh*(1-hp)) o.HPF.Color=hc o.HPF.Filled=true o.HPF.Transparency=0
                    end)
                else pcall(function() o.HP.Visible=false o.HPF.Visible=false end) end
                pcall(function()
                    o.Tracer.Visible=CFG.ESPTracers
                    local vp=Camera.ViewportSize
                    local oy=CFG.ESPTracerOrigin=="Bottom" and vp.Y or (CFG.ESPTracerOrigin=="Top" and 0 or vp.Y/2)
                    o.Tracer.From=Vector2.new(vp.X/2,oy) o.Tracer.To=Vector2.new(cx,top+bh/2)
                    o.Tracer.Color=CFG.ESPTracerColor o.Tracer.Thickness=CFG.ESPTracerThick
                end)
                pcall(function()
                    o.HDot.Visible=CFG.ESPHeadDot o.HDot.Position=Vector2.new(cx,hsp.Y)
                    o.HDot.Radius=CFG.ESPHeadDotSize o.HDot.Color=CFG.ESPHeadDotColor
                    o.HDot.Filled=true o.HDot.Transparency=0
                end)
                if CFG.ESPSkeleton then
                    for i,pair in ipairs(BONES) do
                        if o.Bones[i] then
                            local b0=ch:FindFirstChild(pair[1]) local b1=ch:FindFirstChild(pair[2])
                            if b0 and b1 then
                                local p0,v0=Camera:WorldToViewportPoint(b0.Position)
                                local p1,v1=Camera:WorldToViewportPoint(b1.Position)
                                pcall(function()
                                    o.Bones[i].Visible=v0 and v1
                                    o.Bones[i].From=Vector2.new(p0.X,p0.Y) o.Bones[i].To=Vector2.new(p1.X,p1.Y)
                                    o.Bones[i].Color=CFG.ESPSkeletonColor o.Bones[i].Thickness=CFG.ESPSkeletonThick
                                end)
                            else pcall(function() o.Bones[i].Visible=false end) end
                        end
                    end
                else for _,b in ipairs(o.Bones) do pcall(function() b.Visible=false end) end end
            else hideESP(o) end
        end
    end
end)

local function getTarget()
    local best,bd,bp=nil,CFG.AimbotFOV,nil
    local vp=Camera.ViewportSize
    local ctr=Vector2.new(vp.X/2,vp.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LocalPlayer then continue end
        if CFG.AimbotTeamCheck and teammate(p) then continue end
        if not alive(p) then continue end
        local ch=getChar(p) if not ch then continue end
        local pt=ch:FindFirstChild(CFG.AimbotPart) or ch:FindFirstChild("Head") if not pt then continue end
        if CFG.AimbotVisible then
            local ray=Ray.new(Camera.CFrame.Position,(pt.Position-Camera.CFrame.Position).Unit*5000)
            local hit=Workspace:FindPartOnRayWithIgnoreList(ray,{getChar(LocalPlayer)})
            if hit and not hit:IsDescendantOf(ch) then continue end
        end
        local sp,vis=Camera:WorldToViewportPoint(pt.Position) if not vis then continue end
        local d=(Vector2.new(sp.X,sp.Y)-ctr).Magnitude
        if d<bd then best=p bd=d bp=pt end
    end
    return best,bp
end

RunService.Heartbeat:Connect(function(dt)
    local now=tick()

    if CFG.AimbotEnabled then
        local holding=false
        if typeof(CFG.AimbotKey)=="EnumItem" then
            if CFG.AimbotKey.EnumType==Enum.UserInputType then
                holding=UserInputService:IsMouseButtonPressed(CFG.AimbotKey)
            else holding=UserInputService:IsKeyDown(CFG.AimbotKey) end
        end
        if holding then
            local _,pt=getTarget()
            if pt then
                local pred=pt.Position
                if CFG.AimbotPrediction then
                    local vel=pt.AssemblyLinearVelocity or Vector3.new()
                    pred=pt.Position+vel*CFG.AimbotPredStrength
                end
                if math.random(1,100)<=CFG.AimbotHitChance then
                    local tp,_=Camera:WorldToViewportPoint(pred)
                    local dx,dy=tp.X-Mouse.X,tp.Y-Mouse.Y
                    local sm=CFG.AimbotSmooth
                    if CFG.AimbotStickyAim and Vector2.new(dx,dy).Magnitude<CFG.AimbotStickyRange then sm=sm*0.25 end
                    pcall(function() mousemoverel(dx*(1-sm),dy*(1-sm)) end)
                end
            end
        end
    end

    if CFG.KillAura and now-auraT>=CFG.KillAuraCooldown then
        auraT=now
        local best,bv=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer then continue end
            if CFG.KillAuraTeamCheck and teammate(p) then continue end
            if not alive(p) then continue end
            local d=dist(p) if d>CFG.KillAuraRange then continue end
            local v=d
            if CFG.KillAuraPriority=="Lowest HP" then local h=getHum(p) v=h and h.Health or 9999
            elseif CFG.KillAuraPriority=="Random" then v=math.random() end
            if v<bv then best=p bv=v end
        end
        if best then
            local ch=LocalPlayer.Character
            if ch then
                local tool=ch:FindFirstChildOfClass("Tool")
                if tool then
                    local rem=tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
                    if rem then local tr=getRoot(best) if tr then pcall(function() rem:FireServer(tr.Position) end) end end
                end
            end
        end
    end

    if CFG.SpeedEnabled then
        local h=getHum(LocalPlayer) if h and CFG.SpeedMode=="WalkSpeed" then h.WalkSpeed=CFG.SpeedValue end
    else
        local h=getHum(LocalPlayer) if h and h.WalkSpeed~=16 then h.WalkSpeed=16 end
    end

    if CFG.Fly then
        local rt=getRoot(LocalPlayer)
        if rt then
            if not flyBV or not flyBV.Parent then
                flyBV=Instance.new("BodyVelocity") flyBV.MaxForce=Vector3.new(1e9,1e9,1e9) flyBV.Velocity=Vector3.new() flyBV.Parent=rt
                flyBG=Instance.new("BodyGyro") flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9) flyBG.CFrame=rt.CFrame flyBG.Parent=rt
            end
            local dir=Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
            flyBV.Velocity=dir.Magnitude>0 and dir.Unit*CFG.FlySpeed or Vector3.new()
        end
    else
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        if flyBG and flyBG.Parent then flyBG:Destroy() end
    end

    if CFG.FullBright then
        Lighting.Brightness=CFG.FullBrightVal Lighting.ClockTime=14
        Lighting.FogEnd=1e9 Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255) Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    end
    if CFG.NoFog then Lighting.FogEnd=1e9 Lighting.FogStart=1e9 end
    if CFG.NightMode then
        Lighting.Brightness=0 Lighting.ClockTime=0
        Lighting.Ambient=Color3.fromRGB(0,0,0) Lighting.OutdoorAmbient=Color3.fromRGB(0,0,0)
    end
    if CFG.AntiKnockback then
        local rt=getRoot(LocalPlayer)
        if rt then local bv=rt:FindFirstChildOfClass("BodyVelocity") if bv and not CFG.Fly then bv.Velocity=Vector3.new() end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump then local h=getHum(LocalPlayer) if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    if CFG.MultiJump then
        local h=getHum(LocalPlayer)
        if h and h:GetState()==Enum.HumanoidStateType.Freefall and jmpCount<CFG.MultiJumpCount then
            jmpCount=jmpCount+1 h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    if CFG.Noclip then
        local ch=getChar(LocalPlayer)
        if ch then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    end
    local h=getHum(LocalPlayer)
    if h then
        if h:GetState()==Enum.HumanoidStateType.Landed then jmpCount=0 end
        if CFG.InfJump then h.JumpPower=CFG.JumpPower end
    end
end)

if CFG.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),CFrame.new())
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),CFrame.new())
    end)
end

pcall(function()
    if hookmetamethod then
        local old; old=hookmetamethod(game,"__index",function(t,k)
            if CFG.SilentAim and k=="Hit" and rawget(t,"ClassName")=="Mouse" then
                local _,pt=getTarget()
                if pt then
                    local vp=Camera.ViewportSize
                    local sp,_=Camera:WorldToViewportPoint(pt.Position)
                    local d=Vector2.new(sp.X-vp.X/2,sp.Y-vp.Y/2).Magnitude
                    if d<=CFG.SilentAimFOV and math.random(1,100)<=CFG.SilentAimChance then
                        return pt.CFrame
                    end
                end
            end
            return old(t,k)
        end)
    end
end)

MF.Size=UDim2.new(0,0,0,0)
MF.Position=UDim2.new(0.5,0,0.5,0)
tw(MF,{Size=UDim2.new(0,GW,0,GH),Position=UDim2.new(0.5,-GW/2,0.5,-GH/2)},.38,Enum.EasingStyle.Back)
task.delay(.45,function() notify("Anti God loaded!",ACC,"⚡") end)
