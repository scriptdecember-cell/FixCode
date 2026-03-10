-- ╔══════════════════════════════════════╗
-- ║        Anti God  |  BloxStrike       ║
-- ║             v5.0  by AG              ║
-- ╚══════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local VirtualUser      = game:GetService("VirtualUser")
local CoreGui          = game:GetService("CoreGui")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Camera           = Workspace.CurrentCamera
local LP               = Players.LocalPlayer
local Mouse            = LP:GetMouse()

local function getChar(p)  return p and p.Character end
local function getRoot(p)  local c=getChar(p) return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum(p)   local c=getChar(p) return c and c:FindFirstChildOfClass("Humanoid") end
local function alive(p)    local h=getHum(p) return h and h.Health>0 end
local function isteam(p)   return p.Team==LP.Team end
local function dist(p)
    local r=getRoot(p) local m=getRoot(LP)
    if r and m then return (r.Position-m.Position).Magnitude end
    return math.huge
end

local C = {
    ESPOn=false,ESPBoxes=true,ESPBoxStyle="Corner",ESPBoxCol=Color3.fromRGB(80,200,255),
    ESPBoxThick=2,ESPFilled=false,ESPFillTrans=0.85,ESPCornerLen=8,
    ESPNames=true,ESPNameSz=13,ESPNameCol=Color3.fromRGB(255,255,255),ESPNameOut=true,
    ESPHp=true,ESPHPGrad=true,ESPHPPos="Left",
    ESPDist=true,ESPDistSz=11,ESPDistCol=Color3.fromRGB(180,180,255),
    ESPMaxDist=1000,ESPTeamChk=true,ESPTeamCol=Color3.fromRGB(60,230,100),ESPShowTeam=false,
    ESPSkel=false,ESPSkelCol=Color3.fromRGB(255,200,60),ESPSkelThick=1,
    ESPChams=false,ESPChamsCol=Color3.fromRGB(80,200,255),ESPChamsTrans=0.65,
    ESPTracer=false,ESPTracerOrig="Bottom",ESPTracerCol=Color3.fromRGB(80,200,255),ESPTracerThick=1,
    ESPHDot=false,ESPHDotCol=Color3.fromRGB(255,60,60),ESPHDotSz=4,
    ESPArrows=false,ESPArrowCol=Color3.fromRGB(255,220,60),ESPArrowSz=14,
    AimOn=false,AimFOV=130,AimSmooth=20,AimPart="Head",AimPred=true,AimPredStr=14,
    AimVisChk=false,AimTeamChk=true,AimKey=Enum.UserInputType.MouseButton2,
    AimLockOn=false,AimAutoFire=false,AimHitChance=100,AimSticky=false,AimStickyRng=45,
    AimHL=true,AimHLCol=Color3.fromRGB(255,60,60),AimPrio="Nearest",
    FOVShow=true,FOVCol=Color3.fromRGB(255,255,255),FOVThick=2,FOVFill=false,
    NoRecoil=false,NoRecoilStr=100,NoSpread=false,
    SilentOn=false,SilentPart="Head",SilentFOV=180,SilentVisChk=false,
    SilentChance=100,SilentTeamChk=true,
    FastShoot=false,InfAmmo=false,AutoReload=false,
    KAOn=false,KARange=22,KATeamChk=true,KACool=80,KAAutoBlock=false,KAPrio="Nearest",KAHitbox=1,
    AutoParry=false,AutoParryCool=150,AutoDodge=false,
    SpeedOn=false,SpeedVal=32,SpeedMode="WalkSpeed",BHop=false,
    InfJump=false,JumpPow=55,MultiJump=false,MultiJumpN=2,
    Noclip=false,FlyOn=false,FlySp=60,AntiKB=false,LowGrav=false,GravVal=50,
    FullBright=false,FBVal=10,NoFog=false,NightMode=false,
    RainbowChams=false,RainbowSpd=10,Watermark=true,FPSCtr=false,
    CHOn=false,CHStyle="Cross",CHCol=Color3.fromRGB(255,255,255),
    CHSz=10,CHTh=2,CHGap=4,CHDot=true,CHDotSz=3,CHOutline=true,
    AntiAFK=true,Notifs=true,
}

local flyBV,flyBG
local jmpN=0
local auraT=0
local lockedT=nil
local rHue=0
local fpsBuf={}
local ESPObjs={}
local chHUD=nil
local wmHUD=nil
local fpsHUD=nil

local hasDrawing=false
pcall(function() local t=Drawing.new("Square") t:Remove() hasDrawing=true end)
local function mkDraw(t)
    if not hasDrawing then return {Visible=false,Remove=function()end} end
    local ok,d=pcall(function() return Drawing.new(t) end)
    return ok and d or {Visible=false,Remove=function()end}
end

local BONES={
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function mkESP(p)
    if p==LP then return end
    local o={Box=mkDraw("Square"),Name=mkDraw("Text"),HP=mkDraw("Square"),HPF=mkDraw("Square"),
             Dst=mkDraw("Text"),Tracer=mkDraw("Line"),HDot=mkDraw("Circle"),Bones={}}
    for i=1,#BONES do o.Bones[i]=mkDraw("Line") end
    ESPObjs[p]=o
end
local function hideESP(o)
    if not o then return end
    pcall(function()
        o.Box.Visible=false o.Name.Visible=false o.HP.Visible=false
        o.HPF.Visible=false o.Dst.Visible=false o.Tracer.Visible=false o.HDot.Visible=false
    end)
    for _,b in pairs(o.Bones) do pcall(function() b.Visible=false end) end
end
local function delESP(p)
    local o=ESPObjs[p] if not o then return end
    pcall(function()
        o.Box:Remove() o.Name:Remove() o.HP:Remove() o.HPF:Remove()
        o.Dst:Remove() o.Tracer:Remove() o.HDot:Remove()
    end)
    for _,b in pairs(o.Bones) do pcall(function() b:Remove() end) end
    ESPObjs[p]=nil
end

for _,p in ipairs(Players:GetPlayers()) do mkESP(p) end
Players.PlayerAdded:Connect(mkESP)
Players.PlayerRemoving:Connect(delESP)

local FOVC=mkDraw("Circle")

local ESPSg=Instance.new("ScreenGui")
ESPSg.Name="AGespSg" ESPSg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ESPSg.ResetOnSpawn=false ESPSg.DisplayOrder=998 ESPSg.IgnoreGuiInset=true
pcall(function() ESPSg.Parent=CoreGui end)
if not ESPSg.Parent then ESPSg.Parent=LP.PlayerGui end

local HUDSg=Instance.new("ScreenGui")
HUDSg.Name="AGhudSg" HUDSg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
HUDSg.ResetOnSpawn=false HUDSg.DisplayOrder=997 HUDSg.IgnoreGuiInset=true
pcall(function() HUDSg.Parent=CoreGui end)
if not HUDSg.Parent then HUDSg.Parent=LP.PlayerGui end

local wmF=Instance.new("Frame")
wmF.Size=UDim2.new(0,220,0,38) wmF.Position=UDim2.new(1,-230,0,8)
wmF.BackgroundColor3=Color3.fromRGB(12,12,20) wmF.BorderSizePixel=0 wmF.ZIndex=50
wmF.Visible=C.Watermark wmF.Parent=HUDSg
local wmCr=Instance.new("UICorner") wmCr.CornerRadius=UDim.new(0,10) wmCr.Parent=wmF
local wmSt=Instance.new("UIStroke") wmSt.Color=Color3.fromRGB(80,200,255)
wmSt.Thickness=1.5 wmSt.ApplyStrokeMode=Enum.ApplyStrokeMode.Border wmSt.Parent=wmF
local wmTxt=Instance.new("TextLabel")
wmTxt.Size=UDim2.new(0.65,0,1,0) wmTxt.Position=UDim2.new(0,12,0,0)
wmTxt.BackgroundTransparency=1 wmTxt.Text="⚡ Anti God  |  BloxStrike"
wmTxt.Font=Enum.Font.GothamBold wmTxt.TextSize=12
wmTxt.TextColor3=Color3.fromRGB(220,220,255) wmTxt.TextXAlignment=Enum.TextXAlignment.Left
wmTxt.ZIndex=51 wmTxt.Parent=wmF
fpsHUD=Instance.new("TextLabel")
fpsHUD.Name="FPS" fpsHUD.Size=UDim2.new(0.35,0,1,0) fpsHUD.Position=UDim2.new(0.65,0,0,0)
fpsHUD.BackgroundTransparency=1 fpsHUD.Text="60 FPS"
fpsHUD.Font=Enum.Font.GothamBold fpsHUD.TextSize=11
fpsHUD.TextColor3=Color3.fromRGB(80,200,255) fpsHUD.TextXAlignment=Enum.TextXAlignment.Right
fpsHUD.Visible=false fpsHUD.ZIndex=51 fpsHUD.Parent=wmF
wmHUD=wmF

local function buildCH()
    if chHUD then chHUD:Destroy() chHUD=nil end
    if not C.CHOn then return end
    local f=Instance.new("Frame")
    f.Size=UDim2.new(1,0,1,0) f.BackgroundTransparency=1 f.ZIndex=90 f.Parent=HUDSg
    chHUD=f
    local vp=Camera.ViewportSize
    local cx,cy=vp.X/2,vp.Y/2
    local sz,th,gap=C.CHSz,math.max(1,C.CHTh),C.CHGap
    local col=C.CHCol
    local function mkR(px,py,sw,sh)
        local r=Instance.new("Frame")
        r.Size=UDim2.new(0,sw,0,sh) r.Position=UDim2.new(0,cx+px-sw/2,0,cy+py-sh/2)
        r.BackgroundColor3=col r.BorderSizePixel=0 r.ZIndex=91 r.Parent=f
        if C.CHOutline then
            local s=Instance.new("UIStroke") s.Color=Color3.fromRGB(0,0,0)
            s.Thickness=1 s.Transparency=0.45 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=r
        end
        return r
    end
    if C.CHStyle=="Cross" or C.CHStyle=="Cross+Dot" or C.CHStyle=="T-Shape" then
        mkR(-(sz+gap),0,sz,th) mkR(gap,0,sz,th) mkR(0,-(sz+gap),th,sz)
        if C.CHStyle~="T-Shape" then mkR(0,gap,th,sz) end
    elseif C.CHStyle=="Circle" then
        local c2=Instance.new("Frame")
        c2.Size=UDim2.new(0,sz*2,0,sz*2) c2.Position=UDim2.new(0,cx-sz,0,cy-sz)
        c2.BackgroundTransparency=1 c2.ZIndex=91 c2.Parent=f
        local sc=Instance.new("UIStroke") sc.Color=col sc.Thickness=th
        sc.ApplyStrokeMode=Enum.ApplyStrokeMode.Border sc.Parent=c2
        local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(0,sz) rc.Parent=c2
    end
    if C.CHDot and C.CHStyle~="Circle" then
        local ds=C.CHDotSz
        local dot=mkR(0,0,ds,ds)
        local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(0,math.ceil(ds/2)) dc.Parent=dot
    end
end

local function findTarget(fov)
    fov=fov or C.AimFOV
    local vp=Camera.ViewportSize
    local ctr=Vector2.new(vp.X/2,vp.Y/2)
    local best,bscore,bpart=nil,fov,nil
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        if C.AimTeamChk and isteam(p) then continue end
        if not alive(p) then continue end
        local ch=getChar(p) if not ch then continue end
        local pt=ch:FindFirstChild(C.AimPart) or ch:FindFirstChild("Head") if not pt then continue end
        if C.AimVisChk then
            local ray=Ray.new(Camera.CFrame.Position,(pt.Position-Camera.CFrame.Position).Unit*9999)
            local hit=Workspace:FindPartOnRayWithIgnoreList(ray,{getChar(LP)})
            if hit and not hit:IsDescendantOf(ch) then continue end
        end
        local sp,vis=Camera:WorldToViewportPoint(pt.Position)
        if not vis then continue end
        local d=(Vector2.new(sp.X,sp.Y)-ctr).Magnitude
        local score=d
        if C.AimPrio=="Lowest HP" then
            if d>fov then continue end
            local h=getHum(p) score=h and h.Health or 9999
        elseif C.AimPrio=="Highest HP" then
            if d>fov then continue end
            local h=getHum(p) score=h and (9999-h.Health) or 0
        elseif C.AimPrio=="Random" then
            if d>fov then continue end
            score=math.random()
        end
        if score<bscore then best=p bscore=score bpart=pt end
    end
    return best,bpart
end

local Rayfield=loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
task.wait(0.3)

local function notify(title,msg,dur)
    if not C.Notifs then return end
    pcall(function() Rayfield:Notify({Title=title,Content=msg,Duration=dur or 3,Image="zap"}) end)
end

local Win=Rayfield:CreateWindow({
    Name="Anti God  |  BloxStrike",
    LoadingTitle="Anti God",
    LoadingSubtitle="BloxStrike Hub v5.0",
    ConfigurationSaving={Enabled=false},
    Discord={Enabled=false},
    KeySystem=false,
})
task.wait(0.2)

local TbESP=Win:CreateTab("ESP","eye")
local TbAim=Win:CreateTab("Aimbot","crosshair")
local TbSil=Win:CreateTab("Silent","volume-x")
local TbCom=Win:CreateTab("Combat","swords")
local TbMov=Win:CreateTab("Movement","zap")
local TbVis=Win:CreateTab("Visuals","sparkles")
local TbCH=Win:CreateTab("Crosshair","plus-circle")
local TbCfg=Win:CreateTab("Config","settings")
task.wait(0.1)

TbESP:CreateSection("General")
TbESP:CreateToggle({Name="ESP Master",CurrentValue=false,Flag="g_ESPOn",Callback=function(v) C.ESPOn=v end})
TbESP:CreateToggle({Name="Team Check",CurrentValue=true,Flag="g_ESPTChk",Callback=function(v) C.ESPTeamChk=v end})
TbESP:CreateToggle({Name="Show Teammates",CurrentValue=false,Flag="g_ESPSTm",Callback=function(v) C.ESPShowTeam=v end})
TbESP:CreateSlider({Name="Max Distance",Range={50,3000},Increment=50,Suffix=" st",CurrentValue=1000,Flag="g_ESPDist",Callback=function(v) C.ESPMaxDist=v end})
TbESP:CreateSection("Boxes")
TbESP:CreateToggle({Name="Show Boxes",CurrentValue=true,Flag="g_ESPBox",Callback=function(v) C.ESPBoxes=v end})
TbESP:CreateDropdown({Name="Box Style",Options={"2D Box","Corner Box","Filled Box"},CurrentOption={"Corner Box"},Flag="g_ESPBSt",Callback=function(v) C.ESPBoxStyle=type(v)=="table" and v[1] or v end})
TbESP:CreateSlider({Name="Box Thickness",Range={1,5},Increment=1,CurrentValue=2,Flag="g_ESPBTh",Callback=function(v) C.ESPBoxThick=v end})
TbESP:CreateToggle({Name="Filled Box",CurrentValue=false,Flag="g_ESPFil",Callback=function(v) C.ESPFilled=v end})
TbESP:CreateSlider({Name="Fill Transparency",Range={10,95},Increment=5,Suffix="%",CurrentValue=85,Flag="g_ESPFT",Callback=function(v) C.ESPFillTrans=v/100 end})
TbESP:CreateSlider({Name="Corner Length",Range={3,25},Increment=1,CurrentValue=8,Flag="g_ESPCL",Callback=function(v) C.ESPCornerLen=v end})
TbESP:CreateColorPicker({Name="Enemy Box Color",Color=Color3.fromRGB(80,200,255),Flag="g_ESPBCol",Callback=function(v) C.ESPBoxCol=v end})
TbESP:CreateColorPicker({Name="Team Box Color",Color=Color3.fromRGB(60,230,100),Flag="g_ESPTCol",Callback=function(v) C.ESPTeamCol=v end})
TbESP:CreateSection("Names & Info")
TbESP:CreateToggle({Name="Player Names",CurrentValue=true,Flag="g_ESPNm",Callback=function(v) C.ESPNames=v end})
TbESP:CreateSlider({Name="Name Size",Range={8,22},Increment=1,CurrentValue=13,Flag="g_ESPNSz",Callback=function(v) C.ESPNameSz=v end})
TbESP:CreateToggle({Name="Name Outline",CurrentValue=true,Flag="g_ESPNO",Callback=function(v) C.ESPNameOut=v end})
TbESP:CreateColorPicker({Name="Name Color",Color=Color3.fromRGB(255,255,255),Flag="g_ESPNCol",Callback=function(v) C.ESPNameCol=v end})
TbESP:CreateToggle({Name="Health Bar",CurrentValue=true,Flag="g_ESPHP",Callback=function(v) C.ESPHp=v end})
TbESP:CreateToggle({Name="HP Gradient",CurrentValue=true,Flag="g_ESPHPGr",Callback=function(v) C.ESPHPGrad=v end})
TbESP:CreateDropdown({Name="HP Bar Side",Options={"Left","Right","Top","Bottom"},CurrentOption={"Left"},Flag="g_ESPHPPos",Callback=function(v) C.ESPHPPos=type(v)=="table" and v[1] or v end})
TbESP:CreateToggle({Name="Distance Label",CurrentValue=true,Flag="g_ESPDl",Callback=function(v) C.ESPDist=v end})
TbESP:CreateSlider({Name="Distance Size",Range={8,18},Increment=1,CurrentValue=11,Flag="g_ESPDSz",Callback=function(v) C.ESPDistSz=v end})
TbESP:CreateColorPicker({Name="Distance Color",Color=Color3.fromRGB(180,180,255),Flag="g_ESPDCol",Callback=function(v) C.ESPDistCol=v end})
TbESP:CreateSection("Skeleton")
TbESP:CreateToggle({Name="Skeleton ESP",CurrentValue=false,Flag="g_ESPSk",Callback=function(v) C.ESPSkel=v end})
TbESP:CreateSlider({Name="Skeleton Thickness",Range={1,4},Increment=1,CurrentValue=1,Flag="g_ESPSkTh",Callback=function(v) C.ESPSkelThick=v end})
TbESP:CreateColorPicker({Name="Skeleton Color",Color=Color3.fromRGB(255,200,60),Flag="g_ESPSkCol",Callback=function(v) C.ESPSkelCol=v end})
TbESP:CreateSection("Chams & Highlights")
TbESP:CreateToggle({Name="Chams (Wall Highlight)",CurrentValue=false,Flag="g_ESPCh",Callback=function(v)
    C.ESPChams=v
    if not v then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP then
                local ch=getChar(p) if not ch then continue end
                for _,part in ipairs(ch:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local hl=part:FindFirstChild("_AGHL") if hl then hl:Destroy() end
                    end
                end
            end
        end
    end
end})
TbESP:CreateSlider({Name="Chams Transparency",Range={10,90},Increment=5,Suffix="%",CurrentValue=65,Flag="g_ESPChTr",Callback=function(v) C.ESPChamsTrans=v/100 end})
TbESP:CreateColorPicker({Name="Chams Color",Color=Color3.fromRGB(80,200,255),Flag="g_ESPChCol",Callback=function(v) C.ESPChamsCol=v end})
TbESP:CreateSection("Tracers & Dots")
TbESP:CreateToggle({Name="Tracers",CurrentValue=false,Flag="g_ESPTr",Callback=function(v) C.ESPTracer=v end})
TbESP:CreateDropdown({Name="Tracer Origin",Options={"Bottom","Top","Center","Mouse"},CurrentOption={"Bottom"},Flag="g_ESPTrO",Callback=function(v) C.ESPTracerOrig=type(v)=="table" and v[1] or v end})
TbESP:CreateSlider({Name="Tracer Thickness",Range={1,4},Increment=1,CurrentValue=1,Flag="g_ESPTrTh",Callback=function(v) C.ESPTracerThick=v end})
TbESP:CreateColorPicker({Name="Tracer Color",Color=Color3.fromRGB(80,200,255),Flag="g_ESPTrCol",Callback=function(v) C.ESPTracerCol=v end})
TbESP:CreateToggle({Name="Head Dot",CurrentValue=false,Flag="g_ESPHd",Callback=function(v) C.ESPHDot=v end})
TbESP:CreateSlider({Name="Head Dot Size",Range={2,14},Increment=1,CurrentValue=4,Flag="g_ESPHdSz",Callback=function(v) C.ESPHDotSz=v end})
TbESP:CreateColorPicker({Name="Head Dot Color",Color=Color3.fromRGB(255,60,60),Flag="g_ESPHdCol",Callback=function(v) C.ESPHDotCol=v end})
TbESP:CreateToggle({Name="Off-Screen Arrows",CurrentValue=false,Flag="g_ESPArr",Callback=function(v) C.ESPArrows=v end})
TbESP:CreateSlider({Name="Arrow Size",Range={8,30},Increment=1,CurrentValue=14,Flag="g_ESPArrSz",Callback=function(v) C.ESPArrowSz=v end})
TbESP:CreateColorPicker({Name="Arrow Color",Color=Color3.fromRGB(255,220,60),Flag="g_ESPArrCol",Callback=function(v) C.ESPArrowCol=v end})

TbAim:CreateSection("Aimbot")
TbAim:CreateToggle({Name="Aimbot",CurrentValue=false,Flag="g_AimOn",Callback=function(v) C.AimOn=v end})
TbAim:CreateToggle({Name="Visible Check",CurrentValue=false,Flag="g_AimVis",Callback=function(v) C.AimVisChk=v end})
TbAim:CreateToggle({Name="Team Check",CurrentValue=true,Flag="g_AimTm",Callback=function(v) C.AimTeamChk=v end})
TbAim:CreateToggle({Name="Lock On",CurrentValue=false,Flag="g_AimLock",Callback=function(v) C.AimLockOn=v end})
TbAim:CreateToggle({Name="Auto Fire",CurrentValue=false,Flag="g_AimAF",Callback=function(v) C.AimAutoFire=v end})
TbAim:CreateDropdown({Name="Target Priority",Options={"Nearest","Lowest HP","Highest HP","Random"},CurrentOption={"Nearest"},Flag="g_AimPrio",Callback=function(v) C.AimPrio=type(v)=="table" and v[1] or v end})
TbAim:CreateDropdown({Name="Target Part",Options={"Head","HumanoidRootPart","UpperTorso","LowerTorso","LeftArm","RightArm"},CurrentOption={"Head"},Flag="g_AimPart",Callback=function(v) C.AimPart=type(v)=="table" and v[1] or v end})
TbAim:CreateSection("FOV & Smoothing")
TbAim:CreateSlider({Name="FOV Radius",Range={5,600},Increment=5,Suffix=" px",CurrentValue=130,Flag="g_AimFOV",Callback=function(v) C.AimFOV=v end})
TbAim:CreateSlider({Name="Smoothness",Range={1,100},Increment=1,Suffix="%",CurrentValue=20,Flag="g_AimSm",Callback=function(v) C.AimSmooth=v end})
TbAim:CreateSlider({Name="Hit Chance",Range={5,100},Increment=5,Suffix="%",CurrentValue=100,Flag="g_AimHC",Callback=function(v) C.AimHitChance=v end})
TbAim:CreateToggle({Name="Show FOV Circle",CurrentValue=true,Flag="g_FOVSh",Callback=function(v) C.FOVShow=v end})
TbAim:CreateToggle({Name="Filled FOV",CurrentValue=false,Flag="g_FOVFil",Callback=function(v) C.FOVFill=v end})
TbAim:CreateSlider({Name="FOV Thickness",Range={1,5},Increment=1,CurrentValue=2,Flag="g_FOVTh",Callback=function(v) C.FOVThick=v end})
TbAim:CreateColorPicker({Name="FOV Color",Color=Color3.fromRGB(255,255,255),Flag="g_FOVCol",Callback=function(v) C.FOVCol=v end})
TbAim:CreateToggle({Name="Highlight Target",CurrentValue=true,Flag="g_AimHL",Callback=function(v) C.AimHL=v end})
TbAim:CreateColorPicker({Name="Highlight Color",Color=Color3.fromRGB(255,60,60),Flag="g_AimHLCol",Callback=function(v) C.AimHLCol=v end})
TbAim:CreateSection("Prediction & Sticky")
TbAim:CreateToggle({Name="Aim Prediction",CurrentValue=true,Flag="g_AimPred",Callback=function(v) C.AimPred=v end})
TbAim:CreateSlider({Name="Prediction Strength",Range={1,80},Increment=1,CurrentValue=14,Flag="g_AimPS",Callback=function(v) C.AimPredStr=v end})
TbAim:CreateToggle({Name="Sticky Aim",CurrentValue=false,Flag="g_AimStk",Callback=function(v) C.AimSticky=v end})
TbAim:CreateSlider({Name="Sticky Range",Range={5,200},Increment=5,Suffix=" px",CurrentValue=45,Flag="g_AimStkR",Callback=function(v) C.AimStickyRng=v end})
TbAim:CreateSection("Recoil Control")
TbAim:CreateToggle({Name="No Recoil",CurrentValue=false,Flag="g_NoRec",Callback=function(v) C.NoRecoil=v end})
TbAim:CreateSlider({Name="Recoil Reduction",Range={10,100},Increment=5,Suffix="%",CurrentValue=100,Flag="g_NoRecStr",Callback=function(v) C.NoRecoilStr=v end})
TbAim:CreateToggle({Name="No Spread",CurrentValue=false,Flag="g_NoSprd",Callback=function(v) C.NoSpread=v end})

TbSil:CreateSection("Silent Aim")
TbSil:CreateToggle({Name="Silent Aim",CurrentValue=false,Flag="g_SilOn",Callback=function(v)
    C.SilentOn=v if v then notify("Silent Aim","Bullets redirect to target",3) end
end})
TbSil:CreateToggle({Name="Team Check",CurrentValue=true,Flag="g_SilTm",Callback=function(v) C.SilentTeamChk=v end})
TbSil:CreateToggle({Name="Visible Check",CurrentValue=false,Flag="g_SilVis",Callback=function(v) C.SilentVisChk=v end})
TbSil:CreateDropdown({Name="Target Part",Options={"Head","HumanoidRootPart","UpperTorso","Neck"},CurrentOption={"Head"},Flag="g_SilPart",Callback=function(v) C.SilentPart=type(v)=="table" and v[1] or v end})
TbSil:CreateSlider({Name="Silent FOV",Range={5,360},Increment=5,Suffix="°",CurrentValue=180,Flag="g_SilFOV",Callback=function(v) C.SilentFOV=v end})
TbSil:CreateSlider({Name="Hit Chance",Range={5,100},Increment=5,Suffix="%",CurrentValue=100,Flag="g_SilChance",Callback=function(v) C.SilentChance=v end})
TbSil:CreateSection("Weapon Mods")
TbSil:CreateToggle({Name="Fast Shoot",CurrentValue=false,Flag="g_FShoot",Callback=function(v) C.FastShoot=v end})
TbSil:CreateToggle({Name="Infinite Ammo",CurrentValue=false,Flag="g_InfAmmo",Callback=function(v)
    C.InfAmmo=v
    if v then
        local ch=LP.Character
        if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") then
            for _,iv in ipairs(t:GetDescendants()) do
                if iv:IsA("IntValue") and iv.Name:lower():find("ammo") then iv.Value=9999 end
            end
        end end end
    end
end})
TbSil:CreateToggle({Name="Auto Reload",CurrentValue=false,Flag="g_AutoRld",Callback=function(v) C.AutoReload=v end})

TbCom:CreateSection("Kill Aura")
TbCom:CreateToggle({Name="Kill Aura",CurrentValue=false,Flag="g_KAOn",Callback=function(v) C.KAOn=v end})
TbCom:CreateToggle({Name="Team Check",CurrentValue=true,Flag="g_KATm",Callback=function(v) C.KATeamChk=v end})
TbCom:CreateToggle({Name="Auto Block",CurrentValue=false,Flag="g_KAABlock",Callback=function(v) C.KAAutoBlock=v end})
TbCom:CreateSlider({Name="Kill Aura Range",Range={5,120},Increment=5,Suffix=" st",CurrentValue=22,Flag="g_KARng",Callback=function(v) C.KARange=v end})
TbCom:CreateSlider({Name="Attack Cooldown",Range={20,2000},Increment=10,Suffix=" ms",CurrentValue=80,Flag="g_KACool",Callback=function(v) C.KACool=v end})
TbCom:CreateSlider({Name="Hitbox Multiplier",Range={1,20},Increment=1,Suffix="x",CurrentValue=1,Flag="g_KAHitbox",Callback=function(v)
    C.KAHitbox=v
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then local rt=getRoot(p) if rt then pcall(function() rt.Size=Vector3.new(v,v,v) end) end end
    end
end})
TbCom:CreateDropdown({Name="Target Priority",Options={"Nearest","Lowest HP","Highest HP","Random"},CurrentOption={"Nearest"},Flag="g_KAPrio",Callback=function(v) C.KAPrio=type(v)=="table" and v[1] or v end})
TbCom:CreateSection("Auto Combat")
TbCom:CreateToggle({Name="Auto Parry",CurrentValue=false,Flag="g_AParry",Callback=function(v) C.AutoParry=v end})
TbCom:CreateSlider({Name="Parry Cooldown",Range={50,1000},Increment=25,Suffix=" ms",CurrentValue=150,Flag="g_AParryCool",Callback=function(v) C.AutoParryCool=v end})
TbCom:CreateToggle({Name="Auto Dodge",CurrentValue=false,Flag="g_ADodge",Callback=function(v) C.AutoDodge=v end})

TbMov:CreateSection("Speed")
TbMov:CreateToggle({Name="Speed Hack",CurrentValue=false,Flag="g_SpOn",Callback=function(v)
    C.SpeedOn=v
    if not v then
        local h=getHum(LP) if h then h.WalkSpeed=16 end
        local rt=getRoot(LP) if rt then local bv=rt:FindFirstChild("_AGSBV") if bv then bv:Destroy() end end
    end
end})
TbMov:CreateSlider({Name="Speed Value",Range={16,500},Increment=2,CurrentValue=32,Flag="g_SpVal",Callback=function(v) C.SpeedVal=v end})
TbMov:CreateDropdown({Name="Speed Mode",Options={"WalkSpeed","BodyVelocity"},CurrentOption={"WalkSpeed"},Flag="g_SpMode",Callback=function(v) C.SpeedMode=type(v)=="table" and v[1] or v end})
TbMov:CreateToggle({Name="Bunny Hop",CurrentValue=false,Flag="g_BHop",Callback=function(v) C.BHop=v end})
TbMov:CreateSection("Jump")
TbMov:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="g_InfJ",Callback=function(v) C.InfJump=v end})
TbMov:CreateToggle({Name="Multi-Jump",CurrentValue=false,Flag="g_MJump",Callback=function(v) C.MultiJump=v end})
TbMov:CreateSlider({Name="Multi-Jump Count",Range={2,10},Increment=1,CurrentValue=2,Flag="g_MJumpN",Callback=function(v) C.MultiJumpN=v end})
TbMov:CreateSlider({Name="Jump Power",Range={10,500},Increment=5,CurrentValue=55,Flag="g_JumpPow",Callback=function(v)
    C.JumpPow=v local h=getHum(LP) if h then h.JumpPower=v end
end})
TbMov:CreateSection("Advanced")
TbMov:CreateToggle({Name="Noclip",CurrentValue=false,Flag="g_Noclip",Callback=function(v) C.Noclip=v end})
TbMov:CreateToggle({Name="Fly  [WASD + Space / Ctrl]",CurrentValue=false,Flag="g_Fly",Callback=function(v)
    C.FlyOn=v
    if not v then
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        if flyBG and flyBG.Parent then flyBG:Destroy() end
        local h=getHum(LP) if h then h.PlatformStand=false end
    end
end})
TbMov:CreateSlider({Name="Fly Speed",Range={10,500},Increment=10,CurrentValue=60,Flag="g_FlySp",Callback=function(v) C.FlySp=v end})
TbMov:CreateToggle({Name="Anti-Knockback",CurrentValue=false,Flag="g_AntiKB",Callback=function(v) C.AntiKB=v end})
TbMov:CreateToggle({Name="Low Gravity",CurrentValue=false,Flag="g_LowGrav",Callback=function(v)
    C.LowGrav=v Workspace.Gravity=v and C.GravVal or 196.2
end})
TbMov:CreateSlider({Name="Gravity Value",Range={5,196},Increment=5,CurrentValue=50,Flag="g_GravVal",Callback=function(v)
    C.GravVal=v if C.LowGrav then Workspace.Gravity=v end
end})

TbVis:CreateSection("World Lighting")
TbVis:CreateToggle({Name="Full Bright",CurrentValue=false,Flag="g_FB",Callback=function(v) C.FullBright=v end})
TbVis:CreateSlider({Name="Brightness Level",Range={1,20},Increment=1,CurrentValue=10,Flag="g_FBVal",Callback=function(v) C.FBVal=v end})
TbVis:CreateToggle({Name="No Fog",CurrentValue=false,Flag="g_NoFog",Callback=function(v)
    C.NoFog=v if v then Lighting.FogEnd=1e9 Lighting.FogStart=1e9 end
end})
TbVis:CreateToggle({Name="Night Mode",CurrentValue=false,Flag="g_NightMode",Callback=function(v)
    C.NightMode=v
    if v then Lighting.Brightness=0 Lighting.ClockTime=0 Lighting.Ambient=Color3.new(0,0,0) Lighting.OutdoorAmbient=Color3.new(0,0,0)
    else Lighting.Brightness=2 Lighting.ClockTime=14 Lighting.Ambient=Color3.fromRGB(127,127,127) Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127) end
end})
TbVis:CreateSection("Rainbow & Effects")
TbVis:CreateToggle({Name="Rainbow Chams",CurrentValue=false,Flag="g_RainbowCh",Callback=function(v) C.RainbowChams=v end})
TbVis:CreateSlider({Name="Rainbow Speed",Range={1,50},Increment=1,CurrentValue=10,Flag="g_RainbowSpd",Callback=function(v) C.RainbowSpd=v end})
TbVis:CreateSection("HUD Elements")
TbVis:CreateToggle({Name="Watermark",CurrentValue=true,Flag="g_WM",Callback=function(v)
    C.Watermark=v if wmHUD then wmHUD.Visible=v end
end})
TbVis:CreateToggle({Name="FPS Counter",CurrentValue=false,Flag="g_FPSC",Callback=function(v)
    C.FPSCtr=v if fpsHUD then fpsHUD.Visible=v end
end})

TbCH:CreateSection("Crosshair")
TbCH:CreateToggle({Name="Show Crosshair",CurrentValue=false,Flag="g_CHOn",Callback=function(v)
    C.CHOn=v
    if v then buildCH() else if chHUD then chHUD:Destroy() chHUD=nil end end
end})
TbCH:CreateDropdown({Name="Style",Options={"Cross","Cross+Dot","Dot","Circle","T-Shape"},CurrentOption={"Cross"},Flag="g_CHSt",Callback=function(v)
    C.CHStyle=type(v)=="table" and v[1] or v if C.CHOn then buildCH() end
end})
TbCH:CreateSlider({Name="Size",Range={4,50},Increment=1,Suffix=" px",CurrentValue=10,Flag="g_CHSz",Callback=function(v) C.CHSz=v if C.CHOn then buildCH() end end})
TbCH:CreateSlider({Name="Thickness",Range={1,6},Increment=1,Suffix=" px",CurrentValue=2,Flag="g_CHTh",Callback=function(v) C.CHTh=v if C.CHOn then buildCH() end end})
TbCH:CreateSlider({Name="Gap",Range={0,25},Increment=1,Suffix=" px",CurrentValue=4,Flag="g_CHGap",Callback=function(v) C.CHGap=v if C.CHOn then buildCH() end end})
TbCH:CreateToggle({Name="Center Dot",CurrentValue=true,Flag="g_CHDot",Callback=function(v) C.CHDot=v if C.CHOn then buildCH() end end})
TbCH:CreateSlider({Name="Dot Size",Range={1,8},Increment=1,Suffix=" px",CurrentValue=3,Flag="g_CHDotSz",Callback=function(v) C.CHDotSz=v if C.CHOn then buildCH() end end})
TbCH:CreateToggle({Name="Outline",CurrentValue=true,Flag="g_CHOut",Callback=function(v) C.CHOutline=v if C.CHOn then buildCH() end end})
TbCH:CreateColorPicker({Name="Crosshair Color",Color=Color3.fromRGB(255,255,255),Flag="g_CHCol",Callback=function(v) C.CHCol=v if C.CHOn then buildCH() end end})

TbCfg:CreateSection("System")
TbCfg:CreateToggle({Name="Anti AFK",CurrentValue=true,Flag="g_AntiAFK",Callback=function(v) C.AntiAFK=v end})
TbCfg:CreateToggle({Name="Notifications",CurrentValue=true,Flag="g_Notifs",Callback=function(v) C.Notifs=v end})
TbCfg:CreateButton({Name="Reset Hitboxes",Callback=function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then local rt=getRoot(p) if rt then pcall(function() rt.Size=Vector3.new(2,2,1) end) end end
    end
    notify("Config","Hitboxes reset to normal",2)
end})
TbCfg:CreateButton({Name="Destroy Script",Callback=function()
    pcall(function() Rayfield:Destroy() end)
    pcall(function() ESPSg:Destroy() HUDSg:Destroy() end)
    pcall(function() FOVC:Remove() end)
    for _,p in ipairs(Players:GetPlayers()) do delESP(p) end
end})

RunService.RenderStepped:Connect(function(dt)
    rHue=(rHue+dt*(C.RainbowSpd/10)*0.5)%1
    table.insert(fpsBuf,1/dt)
    if #fpsBuf>30 then table.remove(fpsBuf,1) end
    if C.FPSCtr and fpsHUD then
        local avg=0 for _,v in ipairs(fpsBuf) do avg=avg+v end
        avg=math.floor(avg/#fpsBuf)
        fpsHUD.Text=avg.." FPS" fpsHUD.Visible=true
        fpsHUD.TextColor3=avg>55 and Color3.fromRGB(60,230,100) or avg>30 and Color3.fromRGB(255,200,60) or Color3.fromRGB(255,60,60)
    elseif fpsHUD then fpsHUD.Visible=false end
    pcall(function()
        FOVC.Visible=C.FOVShow and C.AimOn FOVC.Radius=C.AimFOV
        local vp=Camera.ViewportSize FOVC.Position=Vector2.new(vp.X/2,vp.Y/2)
        FOVC.Color=C.FOVCol FOVC.Thickness=C.FOVThick FOVC.Filled=C.FOVFill
        FOVC.Transparency=C.FOVFill and 0.85 or 1 FOVC.NumSides=64
    end)
    for pl,o in pairs(ESPObjs) do
        local ch=getChar(pl) local rt=getRoot(pl) local hm=getHum(pl)
        if not ch or not rt or not hm or hm.Health<=0 or not C.ESPOn then hideESP(o) continue end
        if C.ESPTeamChk and not C.ESPShowTeam and isteam(pl) then hideESP(o) continue end
        local d=dist(pl) if d>C.ESPMaxDist then hideESP(o) continue end
        local ecol=(C.ESPTeamChk and isteam(pl)) and C.ESPTeamCol or C.ESPBoxCol
        if C.RainbowChams then ecol=Color3.fromHSV(rHue,1,1) end
        local head=ch:FindFirstChild("Head") local torso=ch:FindFirstChild("LowerTorso") or ch:FindFirstChild("Torso")
        if not head or not torso then hideESP(o) continue end
        local htop=head.Position+Vector3.new(0,head.Size.Y/2+0.15,0)
        local hbot=torso.Position-Vector3.new(0,torso.Size.Y/2+0.55,0)
        local hsp,hv=Camera:WorldToViewportPoint(htop) local fsp,_=Camera:WorldToViewportPoint(hbot)
        if not hv then
            if C.ESPArrows then
                local vp=Camera.ViewportSize local sp2,_=Camera:WorldToViewportPoint(rt.Position)
                local dir=Vector2.new(sp2.X-vp.X/2,sp2.Y-vp.Y/2) local ang=math.atan2(dir.Y,dir.X)
                local mx=22 local ax=math.clamp(vp.X/2+math.cos(ang)*190,mx,vp.X-mx)
                local ay=math.clamp(vp.Y/2+math.sin(ang)*190,mx,vp.Y-mx)
                pcall(function()
                    o.Tracer.Visible=true o.Tracer.From=Vector2.new(ax,ay)
                    o.Tracer.To=Vector2.new(ax+math.cos(ang)*C.ESPArrowSz,ay+math.sin(ang)*C.ESPArrowSz)
                    o.Tracer.Color=C.ESPArrowCol o.Tracer.Thickness=2.5
                end)
                pcall(function() o.Box.Visible=false o.Name.Visible=false o.HP.Visible=false o.HPF.Visible=false o.Dst.Visible=false o.HDot.Visible=false end)
                for _,b in ipairs(o.Bones) do pcall(function() b.Visible=false end) end
            else hideESP(o) end
            continue
        end
        local bh=math.abs(hsp.Y-fsp.Y) local bw=bh*0.57 local cx=hsp.X local top=math.min(hsp.Y,fsp.Y)
        pcall(function()
            o.Box.Visible=C.ESPBoxes
            o.Box.Size=Vector2.new(bw,bh) o.Box.Position=Vector2.new(cx-bw/2,top)
            o.Box.Color=ecol o.Box.Thickness=C.ESPBoxThick
            o.Box.Filled=C.ESPBoxStyle=="Filled Box"
            o.Box.Transparency=C.ESPBoxStyle=="Filled Box" and (1-C.ESPFillTrans) or 1
        end)
        pcall(function()
            o.Name.Visible=C.ESPNames o.Name.Text=pl.DisplayName o.Name.Size=C.ESPNameSz
            o.Name.Position=Vector2.new(cx,top-C.ESPNameSz-3) o.Name.Color=C.ESPNameCol
            o.Name.Center=true o.Name.Outline=C.ESPNameOut
        end)
        pcall(function()
            o.Dst.Visible=C.ESPDist o.Dst.Text=math.floor(d).." st" o.Dst.Size=C.ESPDistSz
            o.Dst.Position=Vector2.new(cx,top+bh+2) o.Dst.Color=C.ESPDistCol o.Dst.Center=true o.Dst.Outline=true
        end)
        if C.ESPHp then
            local hp=math.clamp(hm.Health/math.max(hm.MaxHealth,1),0,1)
            local rr=hp<0.5 and 1 or 2-2*hp local gg=hp>0.5 and 1 or 2*hp
            local hcol=C.ESPHPGrad and Color3.new(rr,gg,0) or ecol
            local bx=cx-bw/2-7
            pcall(function()
                o.HP.Visible=true o.HP.Size=Vector2.new(4,bh) o.HP.Position=Vector2.new(bx,top)
                o.HP.Color=Color3.fromRGB(20,20,20) o.HP.Filled=true o.HP.Transparency=0.4
                o.HPF.Visible=true o.HPF.Size=Vector2.new(4,bh*hp) o.HPF.Position=Vector2.new(bx,top+bh*(1-hp))
                o.HPF.Color=hcol o.HPF.Filled=true o.HPF.Transparency=0
            end)
        else pcall(function() o.HP.Visible=false o.HPF.Visible=false end) end
        pcall(function()
            o.HDot.Visible=C.ESPHDot o.HDot.Position=Vector2.new(cx,hsp.Y)
            o.HDot.Radius=C.ESPHDotSz o.HDot.Color=C.ESPHDotCol o.HDot.Filled=true o.HDot.Transparency=0
        end)
        pcall(function()
            o.Tracer.Visible=C.ESPTracer
            local vp=Camera.ViewportSize
            local oy=C.ESPTracerOrig=="Top" and 0 or C.ESPTracerOrig=="Center" and vp.Y/2
                or C.ESPTracerOrig=="Mouse" and Mouse.Y or vp.Y
            o.Tracer.From=Vector2.new(vp.X/2,oy) o.Tracer.To=Vector2.new(cx,top+bh/2)
            o.Tracer.Color=C.ESPTracerCol o.Tracer.Thickness=C.ESPTracerThick
        end)
        if C.ESPSkel then
            for i,pair in ipairs(BONES) do
                if o.Bones[i] then
                    local b0=ch:FindFirstChild(pair[1]) local b1=ch:FindFirstChild(pair[2])
                    if b0 and b1 then
                        local p0,v0=Camera:WorldToViewportPoint(b0.Position) local p1,v1=Camera:WorldToViewportPoint(b1.Position)
                        pcall(function()
                            o.Bones[i].Visible=v0 and v1
                            o.Bones[i].From=Vector2.new(p0.X,p0.Y) o.Bones[i].To=Vector2.new(p1.X,p1.Y)
                            o.Bones[i].Color=C.ESPSkelCol o.Bones[i].Thickness=C.ESPSkelThick
                        end)
                    else pcall(function() o.Bones[i].Visible=false end) end
                end
            end
        else for _,b in ipairs(o.Bones) do pcall(function() b.Visible=false end) end end
        if C.ESPChams then
            for _,part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then
                    local hl=part:FindFirstChild("_AGHL")
                    if not hl then
                        hl=Instance.new("SelectionBox") hl.Name="_AGHL" hl.Adornee=part
                        hl.LineThickness=0.02 hl.Parent=ESPSg
                    end
                    hl.Color3=C.RainbowChams and Color3.fromHSV(rHue,1,1) or C.ESPChamsCol
                    hl.SurfaceColor3=hl.Color3 hl.SurfaceTransparency=C.ESPChamsTrans
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    local now=tick()
    if C.AimOn then
        local holding=false
        pcall(function()
            if C.AimKey.EnumType==Enum.UserInputType then holding=UserInputService:IsMouseButtonPressed(C.AimKey)
            else holding=UserInputService:IsKeyDown(C.AimKey) end
        end)
        if holding or C.AimLockOn then
            if C.AimLockOn and (not lockedT or not alive(lockedT)) then
                local t,_=findTarget(C.AimFOV) lockedT=t
            end
            local target,part
            if C.AimLockOn and lockedT then
                local ch=getChar(lockedT)
                part=ch and (ch:FindFirstChild(C.AimPart) or ch:FindFirstChild("Head")) target=lockedT
            else target,part=findTarget(C.AimFOV) end
            if target and part then
                local pos=part.Position
                if C.AimPred then
                    local vel=part.AssemblyLinearVelocity or Vector3.new()
                    pos=pos+vel*(C.AimPredStr/100)
                end
                if math.random(1,100)<=C.AimHitChance then
                    local sp,_=Camera:WorldToViewportPoint(pos)
                    local dx=sp.X-Mouse.X local dy=sp.Y-Mouse.Y local sm=C.AimSmooth/100
                    if C.AimSticky then
                        local mag=Vector2.new(dx,dy).Magnitude
                        if mag<C.AimStickyRng then sm=sm*(0.08+0.92*(mag/C.AimStickyRng)) end
                    end
                    pcall(function() mousemoverel(dx*(1-sm),dy*(1-sm)) end)
                    if C.AimAutoFire then pcall(function() mouse1click() end) end
                end
            end
        end
    end
    if C.KAOn and now-auraT>=C.KACool/1000 then
        auraT=now local best,bv=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LP then continue end if C.KATeamChk and isteam(p) then continue end
            if not alive(p) then continue end local d=dist(p) if d>C.KARange then continue end
            local v=d
            if C.KAPrio=="Lowest HP" then local h=getHum(p) v=h and h.Health or 9999
            elseif C.KAPrio=="Highest HP" then local h=getHum(p) v=h and (9999-h.Health) or 0
            elseif C.KAPrio=="Random" then v=math.random() end
            if v<bv then best=p bv=v end
        end
        if best then
            local ch=LP.Character
            if ch then
                local tool=ch:FindFirstChildOfClass("Tool")
                if tool then
                    local rem=tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
                    if rem then local tr=getRoot(best) if tr then pcall(function() rem:FireServer(tr.Position) end) end end
                end
                if C.KAAutoBlock then pcall(function()
                    local br=ReplicatedStorage:FindFirstChild("Block",true) if br then br:FireServer(true) end
                end) end
            end
        end
    end
    if C.SpeedOn then
        local h=getHum(LP)
        if h then
            if C.SpeedMode=="WalkSpeed" then h.WalkSpeed=C.SpeedVal
            elseif C.SpeedMode=="BodyVelocity" then
                local rt=getRoot(LP)
                if rt then
                    local bv=rt:FindFirstChild("_AGSBV")
                    if not bv then bv=Instance.new("BodyVelocity") bv.Name="_AGSBV" bv.MaxForce=Vector3.new(1e6,0,1e6) bv.Parent=rt end
                    local md=h.MoveDirection bv.Velocity=md.Magnitude>0 and md*C.SpeedVal or Vector3.new()
                end
            end
        end
    else
        local h=getHum(LP) if h and h.WalkSpeed~=16 and C.SpeedMode=="WalkSpeed" then h.WalkSpeed=16 end
        local rt=getRoot(LP) if rt then local bv=rt:FindFirstChild("_AGSBV") if bv then bv:Destroy() end end
    end
    if C.FlyOn then
        local rt=getRoot(LP)
        if rt then
            local h=getHum(LP) if h then h.PlatformStand=true end
            if not flyBV or not flyBV.Parent then
                flyBV=Instance.new("BodyVelocity") flyBV.MaxForce=Vector3.new(1e9,1e9,1e9) flyBV.Velocity=Vector3.new() flyBV.Parent=rt
                flyBG=Instance.new("BodyGyro") flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9) flyBG.D=150 flyBG.CFrame=rt.CFrame flyBG.Parent=rt
            end
            local dir=Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
            flyBV.Velocity=dir.Magnitude>0 and dir.Unit*C.FlySp or Vector3.new() flyBG.CFrame=Camera.CFrame
        end
    else
        if flyBV and flyBV.Parent then flyBV:Destroy() end if flyBG and flyBG.Parent then flyBG:Destroy() end
        local h=getHum(LP) if h then h.PlatformStand=false end
    end
    if C.FullBright then
        Lighting.Brightness=C.FBVal Lighting.ClockTime=14 Lighting.FogEnd=1e9
        Lighting.GlobalShadows=false Lighting.Ambient=Color3.fromRGB(255,255,255) Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    end
    if C.NoFog then Lighting.FogEnd=1e9 Lighting.FogStart=1e9 end
    if C.AntiKB then
        local rt=getRoot(LP)
        if rt then for _,v in ipairs(rt:GetChildren()) do
            if v:IsA("BodyVelocity") and v.Name~="_AGSBV" then pcall(function() v.Velocity=Vector3.new(0,0,0) end) end
        end end
    end
    if C.AutoParry then pcall(function()
        local pr=ReplicatedStorage:FindFirstChild("Parry",true) if pr then pr:FireServer() end
    end) end
    if C.InfAmmo then
        local ch=LP.Character if ch then
            for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") then
                for _,iv in ipairs(t:GetDescendants()) do
                    if iv:IsA("IntValue") and iv.Name:lower():find("ammo") then
                        if iv.Value<100 then iv.Value=9999 end
                    end
                end
            end end
        end
    end
end)

RunService.Stepped:Connect(function()
    if C.Noclip then
        local ch=getChar(LP) if ch then
            for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end
    end
    local h=getHum(LP)
    if h then
        if h:GetState()==Enum.HumanoidStateType.Landed then jmpN=0 end
        if C.InfJump or C.MultiJump then h.JumpPower=C.JumpPow end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if C.InfJump then local h=getHum(LP) if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    if C.MultiJump then
        local h=getHum(LP)
        if h and h:GetState()==Enum.HumanoidStateType.Freefall and jmpN<C.MultiJumpN then
            jmpN=jmpN+1 h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LP.Idled:Connect(function()
    if not C.AntiAFK then return end
    VirtualUser:Button2Down(Vector2.new(0,0),CFrame.new()) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0),CFrame.new())
end)

pcall(function()
    if hookmetamethod then
        local old old=hookmetamethod(game,"__index",function(t,k)
            if C.SilentOn and k=="Hit" and rawget(t,"ClassName")=="Mouse" then
                local _,pt=findTarget(C.SilentFOV)
                if pt then
                    local vp=Camera.ViewportSize local sp,_=Camera:WorldToViewportPoint(pt.Position)
                    local sd=Vector2.new(sp.X-vp.X/2,sp.Y-vp.Y/2).Magnitude
                    if sd<=C.SilentFOV and math.random(1,100)<=C.SilentChance then
                        if C.SilentVisChk then
                            local ray=Ray.new(Camera.CFrame.Position,(pt.Position-Camera.CFrame.Position).Unit*9999)
                            local hit=Workspace:FindPartOnRayWithIgnoreList(ray,{getChar(LP)})
                            local owner=Players:GetPlayerFromCharacter(pt.Parent)
                            if owner and hit and hit:IsDescendantOf(getChar(owner)) then return pt.CFrame end
                        else return pt.CFrame end
                    end
                end
            end
            return old(t,k)
        end)
    end
end)

notify("Anti God","v5.0 loaded — BloxStrike ready!",4)
