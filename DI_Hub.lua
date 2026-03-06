local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera

local function GC() return LocalPlayer.Character end
local function GHRP() local c=GC() return c and c:FindFirstChild("HumanoidRootPart") end
local function GHum() local c=GC() return c and c:FindFirstChildOfClass("Humanoid") end

local S={
    PlayerESP=false,
    SpeedBoost=false,SpeedVal=60,
    InfinityJump=false,
    JumpBoost=false,JumpVal=200,
    AutoBuy=false,
    FpsKiller=false,
    AutoLeave=false,
    Invisible=false,
    TradeFreeze=false,
    AntiSteal=false,
    AutoLock=false,
    InstantSteal=false,
    AutoSteal=false,StealRange=200,
    StealAll=false,
    AutoRebirth=false,
    AutoSell=false,
    BrainrotESP=false,
    AimAssist=false,
    AutoDuel=false,
    AntiDuel=false,
    NoClip=false,
    FlyHack=false,FlySpeed=60,
    AntiAFK=false,
    AutoCollect=false,
    AutoUpgrade=false,
    ShowDist=false,
    HighlightRare=false,
}

local Conns={}
local ESPBBs={}
local BRHighlights={}
local ActiveTab=nil
local Tabs={}

local cBG=Color3.fromRGB(11,11,18)
local cPanel=Color3.fromRGB(16,12,14)
local cSide=Color3.fromRGB(14,10,12)
local cRow=Color3.fromRGB(20,14,16)
local cPrimary=Color3.fromRGB(200,25,25)
local cOff=Color3.fromRGB(36,28,30)
local cText=Color3.fromRGB(230,210,210)
local cDim=Color3.fromRGB(130,90,90)
local cWhite=Color3.fromRGB(255,255,255)
local cGreen=Color3.fromRGB(50,210,80)
local cOrange=Color3.fromRGB(255,140,40)
local cBlue=Color3.fromRGB(60,140,255)
local cYellow=Color3.fromRGB(255,210,40)
local cPurple=Color3.fromRGB(160,60,255)
local cTrack=Color3.fromRGB(40,26,26)

local function DC(k) if Conns[k] then pcall(function() Conns[k]:Disconnect() end) Conns[k]=nil end end

local function ScanRE(cb)
    for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("RemoteEvent") then cb(v) end end
    pcall(function() for _,v in ipairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") then cb(v) end end end)
end

local function FireKW(kws)
    local n=0
    ScanRE(function(v)
        local nl=v.Name:lower()
        for _,kw in ipairs(kws) do
            if nl:find(kw) then pcall(function() v:FireServer() end) n=n+1 break end
        end
    end)
    return n
end

local function FirePrompts(kws)
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local at=v.ActionText:lower() local ot=v.ObjectText:lower()
            for _,kw in ipairs(kws) do
                if at:find(kw) or ot:find(kw) then pcall(function() fireproximityprompt(v) end) break end
            end
        end
    end
end

local function Notify(msg,col)
    col=col or cPrimary
    pcall(function()
        local old=LocalPlayer.PlayerGui:FindFirstChild("DINotif")
        if old then old:Destroy() end
    end)
    local g=Instance.new("ScreenGui")
    g.Name="DINotif" g.ResetOnSpawn=false g.Parent=LocalPlayer.PlayerGui
    local f=Instance.new("Frame",g)
    f.Size=UDim2.new(0,300,0,52) f.Position=UDim2.new(0.5,-150,0,-70)
    f.BackgroundColor3=Color3.fromRGB(12,10,12) f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local sk=Instance.new("UIStroke",f) sk.Color=col sk.Thickness=1.5
    local ico=Instance.new("Frame",f)
    ico.Size=UDim2.new(0,4,1,0) ico.BackgroundColor3=col ico.BorderSizePixel=0
    Instance.new("UICorner",ico).CornerRadius=UDim.new(0,4)
    local lb=Instance.new("TextLabel",f)
    lb.Size=UDim2.new(1,-20,1,0) lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1 lb.Text="⚡  DI Hub  |  "..msg
    lb.TextColor3=col lb.Font=Enum.Font.GothamBold lb.TextSize=13
    lb.TextXAlignment=Enum.TextXAlignment.Left
    TweenService:Create(f,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{Position=UDim2.new(0.5,-150,0,18)}):Play()
    task.delay(3,function()
        TweenService:Create(f,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{Position=UDim2.new(0.5,-150,0,-70)}):Play()
        task.wait(0.3) g:Destroy()
    end)
end

for _,g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
    if g.Name=="DI_Hub" then g:Destroy() end
end

local SG=Instance.new("ScreenGui")
SG.Name="DI_Hub" SG.ResetOnSpawn=false
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.Parent=LocalPlayer.PlayerGui

local Main=Instance.new("Frame",SG)
Main.Size=UDim2.new(0,490,0,530)
Main.Position=UDim2.new(0.5,-245,0.5,-265)
Main.BackgroundColor3=cBG Main.BorderSizePixel=0
Main.Active=true Main.Draggable=true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14)
local ms=Instance.new("UIStroke",Main) ms.Color=cPrimary ms.Thickness=1.6

local TBar=Instance.new("Frame",Main)
TBar.Size=UDim2.new(1,0,0,50) TBar.BackgroundColor3=Color3.fromRGB(16,10,10)
TBar.BorderSizePixel=0 Instance.new("UICorner",TBar).CornerRadius=UDim.new(0,14)
local TLbl=Instance.new("TextLabel",TBar)
TLbl.Size=UDim2.new(1,-60,1,0) TLbl.Position=UDim2.new(0,16,0,0)
TLbl.BackgroundTransparency=1 TLbl.Text="💀  DI Hub  —  Steal a Brainrot  |  v2.0"
TLbl.TextColor3=cPrimary TLbl.Font=Enum.Font.GothamBold TLbl.TextSize=15
TLbl.TextXAlignment=Enum.TextXAlignment.Left
local VLbl=Instance.new("TextLabel",TBar)
VLbl.Size=UDim2.new(0,50,0,20) VLbl.Position=UDim2.new(1,-120,0.5,-10)
VLbl.BackgroundTransparency=1 VLbl.Text="NO KEY"
VLbl.TextColor3=Color3.fromRGB(80,80,80) VLbl.Font=Enum.Font.Gotham VLbl.TextSize=11
local CBtn=Instance.new("TextButton",TBar)
CBtn.Size=UDim2.new(0,30,0,30) CBtn.Position=UDim2.new(1,-40,0.5,-15)
CBtn.BackgroundColor3=Color3.fromRGB(160,22,22) CBtn.BorderSizePixel=0
CBtn.Text="✕" CBtn.TextColor3=cWhite CBtn.Font=Enum.Font.GothamBold CBtn.TextSize=13
Instance.new("UICorner",CBtn).CornerRadius=UDim.new(1,0)
CBtn.MouseButton1Click:Connect(function() Main.Visible=false end)

local SideBar=Instance.new("Frame",Main)
SideBar.Size=UDim2.new(0,92,1,-58) SideBar.Position=UDim2.new(0,6,0,54)
SideBar.BackgroundColor3=cSide SideBar.BorderSizePixel=0
Instance.new("UICorner",SideBar).CornerRadius=UDim.new(0,10)
local SLL=Instance.new("UIListLayout",SideBar)
SLL.Padding=UDim.new(0,5) SLL.HorizontalAlignment=Enum.HorizontalAlignment.Center
local SLP=Instance.new("UIPadding",SideBar) SLP.PaddingTop=UDim.new(0,8)

local ContentArea=Instance.new("Frame",Main)
ContentArea.Size=UDim2.new(1,-104,1,-58) ContentArea.Position=UDim2.new(0,100,0,54)
ContentArea.BackgroundTransparency=1

local TabDefs={
    {name="Player",icon="👤",col=cBlue},
    {name="Anti",  icon="🛡",col=cGreen},
    {name="Steal", icon="🥷",col=cOrange},
    {name="Helper",icon="🔧",col=cPurple},
    {name="Finder",icon="🔍",col=cYellow},
    {name="PvP",   icon="⚔️",col=cPrimary},
}

local function SwitchTab(name)
    for n,t in pairs(Tabs) do
        t.Page.Visible=false
        TweenService:Create(t.Btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(22,14,14),TextColor3=cDim}):Play()
    end
    local t=Tabs[name]
    if t then
        t.Page.Visible=true
        TweenService:Create(t.Btn,TweenInfo.new(0.15),{BackgroundColor3=t.Col,TextColor3=cWhite}):Play()
        ActiveTab=name
    end
end

for _,def in ipairs(TabDefs) do
    local btn=Instance.new("TextButton",SideBar)
    btn.Size=UDim2.new(0,78,0,48) btn.BackgroundColor3=Color3.fromRGB(22,14,14)
    btn.BorderSizePixel=0 btn.Text=def.icon.."\n"..def.name
    btn.TextColor3=cDim btn.Font=Enum.Font.GothamBold btn.TextSize=11 btn.TextWrapped=true
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local page=Instance.new("ScrollingFrame",ContentArea)
    page.Size=UDim2.new(1,0,1,0) page.BackgroundTransparency=1
    page.BorderSizePixel=0 page.ScrollBarThickness=3
    page.ScrollBarImageColor3=def.col page.CanvasSize=UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y page.Visible=false
    local ll=Instance.new("UIListLayout",page)
    ll.Padding=UDim.new(0,7) ll.SortOrder=Enum.SortOrder.LayoutOrder
    local lp=Instance.new("UIPadding",page) lp.PaddingTop=UDim.new(0,6)
    lp.PaddingLeft=UDim.new(0,4) lp.PaddingRight=UDim.new(0,8)
    Tabs[def.name]={Btn=btn,Page=page,Col=def.col}
    btn.MouseButton1Click:Connect(function() SwitchTab(def.name) end)
end

local function MakeHeader(parent,txt,col)
    col=col or cDim
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,-4,0,22) f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
    l.Text="  ─── "..txt.." ───"
    l.TextColor3=col l.Font=Enum.Font.GothamBold l.TextSize=11
    l.TextXAlignment=Enum.TextXAlignment.Left
end

local function MakeToggle(parent,label,key,callback,col)
    col=col or cPrimary
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,-4,0,40) row.BackgroundColor3=cRow row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,9)
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-70,1,0) lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1 lbl.Text=label
    lbl.TextColor3=cText lbl.Font=Enum.Font.Gotham lbl.TextSize=13
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local tog=Instance.new("TextButton",row)
    tog.Size=UDim2.new(0,46,0,24) tog.Position=UDim2.new(1,-56,0.5,-12)
    tog.BackgroundColor3=cOff tog.BorderSizePixel=0 tog.Text=""
    Instance.new("UICorner",tog).CornerRadius=UDim.new(1,0)
    local dot=Instance.new("Frame",tog)
    dot.Size=UDim2.new(0,18,0,18) dot.Position=UDim2.new(0,3,0.5,-9)
    dot.BackgroundColor3=Color3.fromRGB(160,120,120) dot.BorderSizePixel=0
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local on=false
    tog.MouseButton1Click:Connect(function()
        on=not on S[key]=on
        if on then
            TweenService:Create(tog,TweenInfo.new(0.16),{BackgroundColor3=col}):Play()
            TweenService:Create(dot,TweenInfo.new(0.16),{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=cWhite}):Play()
            lbl.TextColor3=cWhite
        else
            TweenService:Create(tog,TweenInfo.new(0.16),{BackgroundColor3=cOff}):Play()
            TweenService:Create(dot,TweenInfo.new(0.16),{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(160,120,120)}):Play()
            lbl.TextColor3=cText
        end
        if callback then callback(on) end
        Notify(label..(on and "  ✅ ON" or "  ❌ OFF"),on and col or cDim)
    end)
    return tog
end

local function MakeSlider(parent,label,key,mn,mx,def,col)
    col=col or cPrimary
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,-4,0,54) row.BackgroundColor3=cRow row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,9)
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-20,0,22) lbl.Position=UDim2.new(0,12,0,4)
    lbl.BackgroundTransparency=1 lbl.Text=label..": "..tostring(def)
    lbl.TextColor3=cText lbl.Font=Enum.Font.Gotham lbl.TextSize=12
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,-24,0,6) track.Position=UDim2.new(0,12,0,36)
    track.BackgroundColor3=cTrack track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new((def-mn)/(mx-mn),0,1,0)
    fill.BackgroundColor3=col fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,14,0,14) knob.AnchorPoint=Vector2.new(0.5,0.5)
    local kr=(def-mn)/(mx-mn)
    knob.Position=UDim2.new(kr,0,0.5,0)
    knob.BackgroundColor3=cWhite knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    S[key]=def
    local dragging=false
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    track.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local rel=math.clamp((UserInputService:GetMouseLocation().X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local val=math.floor(mn+rel*(mx-mn))
            S[key]=val fill.Size=UDim2.new(rel,0,1,0)
            knob.Position=UDim2.new(rel,0,0.5,0)
            lbl.Text=label..": "..tostring(val)
        end
    end)
end

local function MakeButton(parent,label,col,cb)
    col=col or cPrimary
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(1,-4,0,38) btn.BackgroundColor3=col btn.BorderSizePixel=0
    btn.Text=label btn.TextColor3=cWhite btn.Font=Enum.Font.GothamBold btn.TextSize=13
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
        task.delay(0.1,function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=col}):Play() end)
        if cb then cb() end
    end)
    return btn
end

local function MakeDualToggle(parent,label1,key1,label2,key2,cb1,cb2,col)
    col=col or cPrimary
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,-4,0,40) row.BackgroundColor3=cRow row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,9)
    local function makeHalf(lbl,key,xoff,cb)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.45,0,1,0) l.Position=UDim2.new(xoff,6,0,0)
        l.BackgroundTransparency=1 l.Text=lbl l.TextColor3=cText
        l.Font=Enum.Font.Gotham l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left
        local tog=Instance.new("TextButton",row)
        tog.Size=UDim2.new(0,40,0,22) tog.Position=UDim2.new(xoff+0.3,0,0.5,-11)
        tog.BackgroundColor3=cOff tog.BorderSizePixel=0 tog.Text=""
        Instance.new("UICorner",tog).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",tog)
        dot.Size=UDim2.new(0,16,0,16) dot.Position=UDim2.new(0,3,0.5,-8)
        dot.BackgroundColor3=Color3.fromRGB(160,120,120) dot.BorderSizePixel=0
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        tog.MouseButton1Click:Connect(function()
            on=not on S[key]=on
            if on then
                TweenService:Create(tog,TweenInfo.new(0.16),{BackgroundColor3=col}):Play()
                TweenService:Create(dot,TweenInfo.new(0.16),{Position=UDim2.new(1,-19,0.5,-8),BackgroundColor3=cWhite}):Play()
            else
                TweenService:Create(tog,TweenInfo.new(0.16),{BackgroundColor3=cOff}):Play()
                TweenService:Create(dot,TweenInfo.new(0.16),{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=Color3.fromRGB(160,120,120)}):Play()
            end
            if cb then cb(on) end
            Notify(lbl..(on and " ON ✅" or " OFF ❌"),on and col or cDim)
        end)
    end
    makeHalf(label1,key1,0,cb1)
    makeHalf(label2,key2,0.5,cb2)
end

local PP=Tabs["Player"].Page
local AP=Tabs["Anti"].Page
local SP=Tabs["Steal"].Page
local HP=Tabs["Helper"].Page
local FP=Tabs["Finder"].Page
local PvP=Tabs["PvP"].Page

MakeHeader(PP,"PLAYER SETTINGS",cBlue)

MakeToggle(PP,"Player ESP","PlayerESP",function(state)
    if state then
        local function BuildESP(p)
            if p==LocalPlayer then return end
            p.CharacterAdded:Connect(function() task.wait(1) BuildESP(p) end)
            local c=p.Character if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart") if not hrp then return end
            if ESPBBs[p.UserId] then ESPBBs[p.UserId]:Destroy() end
            local bb=Instance.new("BillboardGui",hrp)
            bb.Size=UDim2.new(0,120,0,50) bb.StudsOffset=Vector3.new(0,3.5,0)
            bb.AlwaysOnTop=true bb.MaxDistance=500
            local nl=Instance.new("TextLabel",bb)
            nl.Size=UDim2.new(1,0,0.55,0) nl.BackgroundTransparency=1
            nl.Text="👤 "..p.Name nl.TextColor3=cPrimary
            nl.Font=Enum.Font.GothamBold nl.TextSize=14
            local dl=Instance.new("TextLabel",bb)
            dl.Size=UDim2.new(1,0,0.45,0) dl.Position=UDim2.new(0,0,0.55,0)
            dl.BackgroundTransparency=1 dl.TextColor3=cOrange
            dl.Font=Enum.Font.Gotham dl.TextSize=11
            ESPBBs[p.UserId]=bb
            Conns["ESP_DIST_"..p.UserId]=RunService.RenderStepped:Connect(function()
                local mh=GHRP() local ph=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if mh and ph then dl.Text=math.floor((mh.Position-ph.Position).Magnitude).." studs"
                else dl.Text="" end
            end)
        end
        for _,p in ipairs(Players:GetPlayers()) do BuildESP(p) end
        Conns["ESP_JOIN"]=Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() task.wait(1) BuildESP(p) end)
        end)
    else
        for id,bb in pairs(ESPBBs) do
            pcall(function() bb:Destroy() end)
            DC("ESP_DIST_"..id)
        end
        ESPBBs={} DC("ESP_JOIN")
    end
end,cBlue)

MakeToggle(PP,"Speed Boost","SpeedBoost",function(state)
    if state then
        Conns["SPEED"]=RunService.RenderStepped:Connect(function()
            local h=GHum() if h then h.WalkSpeed=S.SpeedVal end
        end)
    else DC("SPEED") local h=GHum() if h then h.WalkSpeed=16 end end
end,cBlue)

MakeSlider(PP,"Скорость","SpeedVal",16,120,60,cBlue)

MakeToggle(PP,"Infinity Jump","InfinityJump",function(state)
    DC("IJUMP")
    if state then
        Conns["IJUMP"]=UserInputService.JumpRequest:Connect(function()
            local h=GHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end,cBlue)

MakeToggle(PP,"Jump Boost","JumpBoost",function(state)
    if state then
        Conns["JBOOST"]=RunService.RenderStepped:Connect(function()
            local h=GHum() if h then h.JumpPower=S.JumpVal end
        end)
    else DC("JBOOST") local h=GHum() if h then h.JumpPower=50 end end
end,cBlue)

MakeSlider(PP,"Jump Power","JumpVal",50,500,200,cBlue)

MakeToggle(PP,"Auto Buy Brainrot","AutoBuy",function(state)
    DC("AUTOBUY")
    if state then
        Conns["AUTOBUY"]=RunService.Heartbeat:Connect(function()
            FireKW({"buy","purchase","conveyor","brainrot"})
            FirePrompts({"buy","purchase","brainrot"})
        end)
    end
end,cBlue)

local fpsRow=Instance.new("Frame",PP)
fpsRow.Size=UDim2.new(1,-4,0,40) fpsRow.BackgroundColor3=cRow fpsRow.BorderSizePixel=0
Instance.new("UICorner",fpsRow).CornerRadius=UDim.new(0,9)
local fpsLbl=Instance.new("TextLabel",fpsRow)
fpsLbl.Size=UDim2.new(1,-100,1,0) fpsLbl.Position=UDim2.new(0,12,0,0)
fpsLbl.BackgroundTransparency=1 fpsLbl.Text="Fps Killer Script"
fpsLbl.TextColor3=cText fpsLbl.Font=Enum.Font.Gotham fpsLbl.TextSize=13
fpsLbl.TextXAlignment=Enum.TextXAlignment.Left
local fpsBtn=Instance.new("TextButton",fpsRow)
fpsBtn.Size=UDim2.new(0,54,0,26) fpsBtn.Position=UDim2.new(1,-62,0.5,-13)
fpsBtn.BackgroundColor3=cPrimary fpsBtn.BorderSizePixel=0
fpsBtn.Text="RUN" fpsBtn.TextColor3=cWhite fpsBtn.Font=Enum.Font.GothamBold fpsBtn.TextSize=12
Instance.new("UICorner",fpsBtn).CornerRadius=UDim.new(0,6)
local fpsOn=false
fpsBtn.MouseButton1Click:Connect(function()
    fpsOn=not fpsOn
    if fpsOn then
        fpsBtn.Text="STOP" fpsBtn.BackgroundColor3=cOrange S.FpsKiller=true
        Conns["FPSKILL"]=RunService.RenderStepped:Connect(function()
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled=false
                elseif v:IsA("SpecialMesh") then
                    pcall(function() v.LODFactor=0 end)
                end
            end
            local lc=Workspace.Terrain.WaterWaveSize
            if lc~=0 then pcall(function() Workspace.Terrain.WaterWaveSize=0 end) end
        end)
        Notify("FPS Killer активен ✅",cOrange)
    else
        fpsBtn.Text="RUN" fpsBtn.BackgroundColor3=cPrimary S.FpsKiller=false
        DC("FPSKILL")
        Notify("FPS Killer остановлен ❌",cDim)
    end
end)

MakeToggle(PP,"Auto Leave (если мало рейтинга)","AutoLeave",function(state)
    DC("AUTOLEAVE")
    if state then
        Conns["AUTOLEAVE"]=RunService.Heartbeat:Connect(function()
            local ls=LocalPlayer:FindFirstChild("leaderstats")
            if ls then
                local rating=ls:FindFirstChild("Rating") or ls:FindFirstChild("Score") or ls:FindFirstChild("Level")
                if rating and tonumber(rating.Value) and tonumber(rating.Value)<10 then
                    pcall(function() LocalPlayer:Kick("DI Hub: AutoLeave triggered") end)
                end
            end
        end)
    end
end,cBlue)

MakeHeader(AP,"ANTI CHEAT BYPASS",cGreen)

MakeToggle(AP,"Invisible (невидимость)","Invisible",function(state)
    DC("INVIS")
    local c=GC()
    if state and c then
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("SpecialMesh") then
                if p.Name~="HumanoidRootPart" then
                    pcall(function() p.Transparency=1 end)
                end
            end
        end
        Conns["INVIS"]=LocalPlayer.CharacterAdded:Connect(function(ch)
            task.wait(0.5)
            for _,p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("MeshPart") then
                    if p.Name~="HumanoidRootPart" then
                        pcall(function() p.Transparency=1 end)
                    end
                end
            end
        end)
    elseif not state and c then
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then
                if p.Name~="HumanoidRootPart" then
                    pcall(function() p.Transparency=0 end)
                end
            end
        end
    end
end,cGreen)

MakeToggle(AP,"Trade Freeze (заморозить трейд)","TradeFreeze",function(state)
    DC("TFREEZE")
    if state then
        Conns["TFREEZE"]=RunService.Heartbeat:Connect(function()
            FireKW({"trade","exchange","offer"})
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("trade") or v.Name:lower():find("offer")) then
                    pcall(function() v.OnClientEvent:Connect(function() end) end)
                end
            end
        end)
    end
end,cGreen)

MakeToggle(AP,"Anti Steal Protection","AntiSteal",function(state)
    DC("ANTISTEAL")
    if state then
        Conns["ANTISTEAL"]=RunService.Heartbeat:Connect(function()
            FireKW({"lock","protect","base","guard"})
            FirePrompts({"lock","protect"})
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local ph=p.Character:FindFirstChild("HumanoidRootPart")
                    local mh=GHRP()
                    if ph and mh and (ph.Position-mh.Position).Magnitude<10 then
                        FireKW({"kick","push","defend"})
                    end
                end
            end
        end)
    end
end,cGreen)

MakeToggle(AP,"Auto Lock Base","AutoLock",function(state)
    DC("AUTOLOCK")
    if state then
        Conns["AUTOLOCK"]=RunService.Heartbeat:Connect(function()
            FireKW({"lock","secure","close","base"})
            FirePrompts({"lock","secure","close"})
        end)
    end
end,cGreen)

MakeButton(AP,"🔒 Заблокировать сейчас",cGreen,function()
    local n=FireKW({"lock","secure","close","base"})
    FirePrompts({"lock","secure"})
    Notify("База заблокирована! ("..n.." remotes)",cGreen)
end)

MakeButton(AP,"👁 Стать невидимым (1 раз)",Color3.fromRGB(40,160,60),function()
    local c=GC()
    if c then
        for _,p in ipairs(c:GetDescendants()) do
            if (p:IsA("BasePart") or p:IsA("MeshPart")) and p.Name~="HumanoidRootPart" then
                pcall(function() p.Transparency=1 end)
            end
        end
        Notify("Невидим! ✅",cGreen)
    end
end)

MakeHeader(SP,"STEAL SETTINGS",cOrange)

MakeToggle(SP,"Instant Steal","InstantSteal",function(state)
    DC("INSTANT")
    if state then
        Conns["INSTANT"]=RunService.Heartbeat:Connect(function()
            local mh=GHRP() if not mh then return end
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local at=v.ActionText:lower()
                    if at:find("steal") or at:find("grab") or at:find("take") then
                        local pp=v.Parent
                        if pp then
                            local pos=pp:IsA("BasePart") and pp.Position or
                                      (pp:IsA("Model") and pp:GetPivot().Position) or nil
                            if pos then
                                local old=mh.CFrame
                                mh.CFrame=CFrame.new(pos+Vector3.new(0,2,0))
                                task.wait(0.05)
                                pcall(function() fireproximityprompt(v) end)
                                task.wait(0.05)
                                mh.CFrame=old
                            end
                        end
                    end
                end
            end
            FireKW({"steal","grab","take"})
        end)
    end
end,cOrange)

MakeToggle(SP,"Auto Steal (авто)","AutoSteal",function(state)
    DC("AUTOSTEAL")
    if state then
        Conns["AUTOSTEAL"]=RunService.Heartbeat:Connect(function()
            local mh=GHRP() if not mh then return end
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local at=v.ActionText:lower()
                    if at:find("steal") or at:find("grab") then
                        local pp=v.Parent
                        if pp then
                            local pos=pp:IsA("BasePart") and pp.Position or
                                      (pp:IsA("Model") and pp:GetPivot().Position) or nil
                            if pos and (mh.Position-pos).Magnitude<=S.StealRange then
                                pcall(function() fireproximityprompt(v) end)
                            end
                        end
                    end
                end
            end
        end)
    end
end,cOrange)

MakeSlider(SP,"Steal Range","StealRange",10,400,200,cOrange)

MakeToggle(SP,"Steal All (все brainrots)","StealAll",function(state)
    DC("STEALALL")
    if state then
        Conns["STEALALL"]=RunService.Heartbeat:Connect(function()
            local mh=GHRP() if not mh then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local ph=p.Character:FindFirstChild("HumanoidRootPart")
                    if ph and (mh.Position-ph.Position).Magnitude<500 then
                        for _,v in ipairs(p.Character:GetDescendants()) do
                            if v:IsA("ProximityPrompt") then
                                pcall(function() fireproximityprompt(v) end)
                            end
                        end
                    end
                end
            end
            FireKW({"steal","take","grab","snatch"})
        end)
    end
end,cOrange)

MakeButton(SP,"🥷 ТП к ближайшему игроку",cOrange,function()
    local mh=GHRP() if not mh then return end
    local best,bd=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local ph=p.Character:FindFirstChild("HumanoidRootPart")
            if ph then
                local d=(mh.Position-ph.Position).Magnitude
                if d<bd then bd=d best=ph end
            end
        end
    end
    if best then
        mh.CFrame=best.CFrame*CFrame.new(0,0,-4)
        Notify("ТП к игроку! ✅",cOrange)
    else Notify("Нет игроков",cDim) end
end)

MakeButton(SP,"⚡ Украсть ВСЕХ сейчас",Color3.fromRGB(200,80,0),function()
    local n=FireKW({"steal","grab","take","snatch","brainrot"})
    FirePrompts({"steal","grab","take"})
    Notify("Украл! ("..n.." fires) ✅",cOrange)
end)

MakeButton(SP,"👥 ТП ко всем игрокам поочерёдно",Color3.fromRGB(180,70,0),function()
    local mh=GHRP() if not mh then return end
    task.spawn(function()
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local ph=p.Character:FindFirstChild("HumanoidRootPart")
                if ph then
                    mh.CFrame=ph.CFrame*CFrame.new(0,0,-3)
                    FireKW({"steal","grab"})
                    FirePrompts({"steal","grab"})
                    task.wait(0.3)
                end
            end
        end
        Notify("Обошёл всех! ✅",cOrange)
    end)
end)

MakeHeader(HP,"HELPER TOOLS",cPurple)

MakeToggle(HP,"Auto Rebirth","AutoRebirth",function(state)
    DC("AUTOREBIRTH")
    if state then
        Conns["AUTOREBIRTH"]=RunService.Heartbeat:Connect(function()
            FireKW({"rebirth","prestige","reset"})
            FirePrompts({"rebirth","prestige"})
        end)
    end
end,cPurple)

MakeToggle(HP,"Auto Sell","AutoSell",function(state)
    DC("AUTOSELL")
    if state then
        Conns["AUTOSELL"]=RunService.Heartbeat:Connect(function()
            FireKW({"sell","cash","money","income"})
            FirePrompts({"sell","cash"})
        end)
    end
end,cPurple)

MakeToggle(HP,"Auto Farm (деньги)","AutoFarm",function(state)
    DC("AUTOFARM")
    if state then
        Conns["AUTOFARM"]=RunService.Heartbeat:Connect(function()
            FireKW({"collect","farm","earn","money","cash","income","coins"})
            FirePrompts({"collect","farm","earn"})
        end)
    end
end,cPurple)

MakeToggle(HP,"Auto Collect","AutoCollect",function(state)
    DC("AUTOCOLLECT")
    if state then
        Conns["AUTOCOLLECT"]=RunService.Heartbeat:Connect(function()
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local nl=v.Name:lower()
                    if nl:find("drop") or nl:find("orb") or nl:find("pickup") or nl:find("coin") then
                        local mh=GHRP()
                        if mh and (mh.Position-v.Position).Magnitude<100 then
                            pcall(function() mh.CFrame=CFrame.new(v.Position) end)
                        end
                    end
                end
            end
        end)
    end
end,cPurple)

MakeToggle(HP,"No Clip (сквозь стены)","NoClip",function(state)
    DC("NOCLIP")
    if state then
        Conns["NOCLIP"]=RunService.Stepped:Connect(function()
            local c=GC()
            if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        end)
    else
        local c=GC()
        if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end,cPurple)

MakeToggle(HP,"Fly Hack (летать)","FlyHack",function(state)
    DC("FLY")
    local c=GC() local h=c and c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    if state then
        local bg=Instance.new("BodyGyro",h) bg.Name="DIGyro"
        bg.MaxTorque=Vector3.new(1e9,1e9,1e9) bg.P=1e4
        local bv=Instance.new("BodyVelocity",h) bv.Name="DIVel"
        bv.MaxForce=Vector3.new(1e9,1e9,1e9) bv.Velocity=Vector3.zero
        Conns["FLY"]=RunService.RenderStepped:Connect(function()
            local cam=Workspace.CurrentCamera
            local dir=Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.yAxis end
            bv.Velocity=dir*S.FlySpeed bg.CFrame=cam.CFrame
        end)
    else
        if h:FindFirstChild("DIGyro") then h.DIGyro:Destroy() end
        if h:FindFirstChild("DIVel") then h.DIVel:Destroy() end
    end
end,cPurple)

MakeSlider(HP,"Fly Speed","FlySpeed",20,200,60,cPurple)

MakeToggle(HP,"Anti AFK","AntiAFK",function(state)
    DC("ANTIAFK")
    if state then
        local VirtualUser=game:GetService("VirtualUser")
        Conns["ANTIAFK"]=LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end,cPurple)

MakeButton(HP,"🏠 ТП на свою базу",cPurple,function()
    local mh=GHRP() if not mh then return end
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("base") or v.Name:lower():find("spawn")) then
            mh.CFrame=CFrame.new(v.Position+Vector3.new(0,5,0))
            Notify("ТП на базу! ✅",cPurple)
            return
        end
    end
    Notify("База не найдена",cDim)
end)

MakeButton(HP,"⚡ ТП на конвейер",Color3.fromRGB(120,40,200),function()
    local mh=GHRP() if not mh then return end
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("conveyor") or v.Name:lower():find("belt")) then
            mh.CFrame=CFrame.new(v.Position+Vector3.new(0,5,0))
            Notify("ТП на конвейер! ✅",cPurple)
            return
        end
    end
    Notify("Конвейер не найден",cDim)
end)

MakeHeader(FP,"FINDER / ESP",cYellow)

MakeToggle(FP,"Brainrot ESP (highlight)","BrainrotESP",function(state)
    DC("BRESP")
    if not state then
        for _,h in pairs(BrainrotHighlights) do pcall(function() h:Destroy() end) end
        BrainrotHighlights={}
        return
    end
    Conns["BRESP"]=RunService.Heartbeat:Connect(function()
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") then
                local nl=v.Name:lower()
                local isBR=nl:find("brainrot") or nl:find("noobini") or nl:find("tralalero") or
                            nl:find("tung") or nl:find("cappuccino") or nl:find("bombardiro") or
                            nl:find("ballerina") or nl:find("crocodilo") or nl:find("lirili") or
                            nl:find("larila") or nl:find("boneca") or nl:find("glorbo") or
                            nl:find("frutiger")
                if isBR and not v:FindFirstChildOfClass("SelectionBox") then
                    local sb=Instance.new("SelectionBox")
                    sb.Adornee=v sb.Color3=cYellow
                    sb.LineThickness=0.05 sb.SurfaceTransparency=0.8
                    sb.SurfaceColor3=cYellow sb.Parent=v
                    table.insert(BrainrotHighlights,sb)
                end
            end
        end
    end)
end,cYellow)

MakeToggle(FP,"Show Player Names (3D)","ShowNames",function(state)
    DC("SHNAMES")
    if state then
        local function AddName(p)
            if p==LocalPlayer then return end
            p.CharacterAdded:Connect(function() task.wait(1) AddName(p) end)
            local c=p.Character if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart") if not hrp then return end
            local bb=Instance.new("BillboardGui",hrp)
            bb.Name="DINameESP" bb.Size=UDim2.new(0,100,0,30)
            bb.StudsOffset=Vector3.new(0,5,0) bb.AlwaysOnTop=true
            local l=Instance.new("TextLabel",bb)
            l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
            l.Text=p.Name l.TextColor3=cYellow l.Font=Enum.Font.GothamBold l.TextSize=14
        end
        for _,p in ipairs(Players:GetPlayers()) do AddName(p) end
        Conns["SHNAMES"]=Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() task.wait(1) AddName(p) end)
        end)
    else
        for _,p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bb=hrp:FindFirstChild("DINameESP")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end,cYellow)

MakeToggle(FP,"Show Player Values","ShowValues",function(state)
    DC("SHVALS")
    if state then
        Conns["SHVALS"]=RunService.RenderStepped:Connect(function()
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bb=hrp:FindFirstChild("DIValESP")
                        if not bb then
                            bb=Instance.new("BillboardGui",hrp) bb.Name="DIValESP"
                            bb.Size=UDim2.new(0,120,0,50) bb.StudsOffset=Vector3.new(0,7,0)
                            bb.AlwaysOnTop=true
                            local l=Instance.new("TextLabel",bb)
                            l.Name="VL" l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
                            l.TextColor3=cGreen l.Font=Enum.Font.Gotham l.TextSize=11
                        end
                        local ls=p:FindFirstChild("leaderstats")
                        if ls then
                            local txt=""
                            for _,v in ipairs(ls:GetChildren()) do
                                txt=txt..v.Name..": "..tostring(v.Value).."\n"
                            end
                            local vl=bb:FindFirstChild("VL")
                            if vl then vl.Text=txt end
                        end
                    end
                end
            end
        end)
    else
        for _,p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then local bb=hrp:FindFirstChild("DIValESP") if bb then bb:Destroy() end end
            end
        end
    end
end,cYellow)

MakeToggle(FP,"Highlight Rare Brainrots","HighlightRare",function(state)
    DC("HLRARE")
    if not state then
        for _,v in ipairs(Workspace:GetDescendants()) do
            local h=v:FindFirstChild("DIRareHL")
            if h then h:Destroy() end
        end return
    end
    local rareNames={"legendary","epic","rare","mythic","unique","special","golden","shiny","rainbow","ultra"}
    Conns["HLRARE"]=RunService.Heartbeat:Connect(function()
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and not v:FindFirstChild("DIRareHL") then
                local nl=v.Name:lower()
                for _,rn in ipairs(rareNames) do
                    if nl:find(rn) then
                        local h=Instance.new("SelectionBox",v)
                        h.Name="DIRareHL" h.Adornee=v
                        h.Color3=Color3.fromRGB(255,50,255)
                        h.LineThickness=0.07 h.SurfaceTransparency=0.75
                        h.SurfaceColor3=Color3.fromRGB(255,50,255)
                        break
                    end
                end
            end
        end
    end)
end,cYellow)

MakeButton(FP,"🔍 Найти все Brainrots",cYellow,function()
    local found=0
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local nl=v.Name:lower()
            if nl:find("brainrot") or nl:find("noobini") or nl:find("tung") or nl:find("tralalero") then
                found=found+1
            end
        end
    end
    Notify("Найдено "..found.." brainrots! 🔍",cYellow)
end)

MakeButton(FP,"📍 ТП к ближ. brainrot",Color3.fromRGB(180,160,0),function()
    local mh=GHRP() if not mh then return end
    local best,bd=nil,math.huge
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local nl=v.Name:lower()
            if nl:find("brainrot") or nl:find("noobini") or nl:find("tung") then
                local pos=v:GetPivot().Position
                local d=(mh.Position-pos).Magnitude
                if d<bd then bd=d best=pos end
            end
        end
    end
    if best then
        mh.CFrame=CFrame.new(best+Vector3.new(0,5,0))
        Notify("ТП к brainrot! ✅",cYellow)
    else Notify("Brainrot не найден",cDim) end
end)

MakeHeader(PvP,"PVP TOOLS",cPrimary)

MakeToggle(PvP,"Aim Assist","AimAssist",function(state)
    DC("AIMASSIST")
    if state then
        Conns["AIMASSIST"]=RunService.RenderStepped:Connect(function()
            local mh=GHRP() if not mh then return end
            local best,bd=nil,math.huge
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local ph=p.Character:FindFirstChild("HumanoidRootPart")
                    if ph then
                        local d=(mh.Position-ph.Position).Magnitude
                        if d<bd then bd=d best=ph end
                    end
                end
            end
            if best then
                Camera.CFrame=CFrame.new(Camera.CFrame.Position,best.Position)
            end
        end)
    end
end,cPrimary)

MakeToggle(PvP,"Auto Accept Duel","AutoDuel",function(state)
    DC("AUTODUEL")
    if state then
        Conns["AUTODUEL"]=RunService.Heartbeat:Connect(function()
            FireKW({"accept","duel","challenge","fight","battle"})
            FirePrompts({"accept","duel","fight"})
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("TextButton") then
                    local tl=v.Text:lower()
                    if tl:find("accept") or tl:find("duel") or tl:find("fight") then
                        pcall(function() v:Activate() end)
                    end
                end
            end
        end)
    end
end,cPrimary)

MakeToggle(PvP,"Anti Duel (отклонять)","AntiDuel",function(state)
    DC("ANTIDUEL")
    if state then
        Conns["ANTIDUEL"]=RunService.Heartbeat:Connect(function()
            FireKW({"decline","reject","cancel","duel"})
            FirePrompts({"decline","reject"})
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("TextButton") then
                    local tl=v.Text:lower()
                    if tl:find("decline") or tl:find("reject") or tl:find("no") then
                        pcall(function() v:Activate() end)
                    end
                end
            end
        end)
    end
end,cPrimary)

MakeToggle(PvP,"Prediction (упреждение)","Prediction",function(state)
    DC("PREDICT")
    if state then
        Conns["PREDICT"]=RunService.RenderStepped:Connect(function()
            local mh=GHRP() if not mh then return end
            local best,bd=nil,math.huge
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local ph=p.Character:FindFirstChild("HumanoidRootPart")
                    if ph then
                        local d=(mh.Position-ph.Position).Magnitude
                        if d<bd then bd=d best=ph end
                    end
                end
            end
            if best then
                local vel=best.Velocity
                local predicted=best.Position+(vel*0.15)
                Camera.CFrame=CFrame.new(Camera.CFrame.Position,predicted)
            end
        end)
    end
end,cPrimary)

MakeButton(PvP,"⚔️ ТП за спину врага",cPrimary,function()
    local mh=GHRP() if not mh then return end
    local best,bd=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local ph=p.Character:FindFirstChild("HumanoidRootPart")
            if ph then
                local d=(mh.Position-ph.Position).Magnitude
                if d<bd then bd=d best=ph end
            end
        end
    end
    if best then
        mh.CFrame=best.CFrame*CFrame.new(0,0,3)*CFrame.Angles(0,math.pi,0)
        Notify("ТП за врага! ✅",cPrimary)
    else Notify("Враг не найден",cDim) end
end)

MakeButton(PvP,"💀 Kill Aura (push)",Color3.fromRGB(150,0,0),function()
    local mh=GHRP() if not mh then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local ph=p.Character:FindFirstChild("HumanoidRootPart")
            if ph and (mh.Position-ph.Position).Magnitude<30 then
                local bv=Instance.new("BodyVelocity",ph)
                bv.MaxForce=Vector3.new(1e9,1e9,1e9)
                bv.Velocity=(ph.Position-mh.Position).Unit*100+Vector3.new(0,50,0)
                game:GetService("Debris"):AddItem(bv,0.2)
            end
        end
    end
    Notify("Kill Aura! 💀",cPrimary)
end)

SwitchTab("Player")

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.Insert then
        Main.Visible=not Main.Visible
        Notify(Main.Visible and "GUI открыт ✅" or "GUI скрыт",Main.Visible and cGreen or cDim)
    end
    if input.KeyCode==Enum.KeyCode.RightShift then
        S.AutoSteal=not S.AutoSteal
        if S.AutoSteal then
            Conns["AUTOSTEAL"]=RunService.Heartbeat:Connect(function()
                local mh=GHRP() if not mh then return end
                for _,v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        local at=v.ActionText:lower()
                        if at:find("steal") or at:find("grab") then
                            pcall(function() fireproximityprompt(v) end)
                        end
                    end
                end
            end)
        else DC("AUTOSTEAL") end
        Notify("AutoSteal [RShift]: "..(S.AutoSteal and "ON ✅" or "OFF ❌"),cOrange)
    end
    if input.KeyCode==Enum.KeyCode.F4 then
        S.InstantSteal=not S.InstantSteal
        Notify("InstantSteal [F4]: "..(S.InstantSteal and "ON ✅" or "OFF ❌"),cOrange)
    end
    if input.KeyCode==Enum.KeyCode.F5 then
        S.Invisible=not S.Invisible
        local c=GC()
        if c then
            for _,p in ipairs(c:GetDescendants()) do
                if (p:IsA("BasePart") or p:IsA("MeshPart")) and p.Name~="HumanoidRootPart" then
                    pcall(function() p.Transparency=S.Invisible and 1 or 0 end)
                end
            end
        end
        Notify("Invisible [F5]: "..(S.Invisible and "ON ✅" or "OFF ❌"),cGreen)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.8)
    if S.SpeedBoost then local h=c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=S.SpeedVal end end
    if S.JumpBoost then local h=c:FindFirstChildOfClass("Humanoid") if h then h.JumpPower=S.JumpVal end end
    if S.Invisible then
        task.wait(0.5)
        for _,p in ipairs(c:GetDescendants()) do
            if (p:IsA("BasePart") or p:IsA("MeshPart")) and p.Name~="HumanoidRootPart" then
                pcall(function() p.Transparency=1 end)
            end
        end
    end
    Notify("Respawn — DI Hub активен! ⚡",cPrimary)
end)

Players.PlayerRemoving:Connect(function(p)
    if ESPBillboards[p.UserId] then
        pcall(function() ESPBillboards[p.UserId]:Destroy() end)
        ESPBillboards[p.UserId]=nil
        DC("ESP_DIST_"..p.UserId)
    end
end)

task.wait(0.5)
Notify("DI Hub v2.0 загружен! [INSERT] — toggle GUI",cPrimary)

print("DI Hub v2.0 | Steal a Brainrot")
print("[INSERT]   — Toggle GUI")
print("[RShift]   — Toggle AutoSteal")
print("[F4]       — Toggle InstantSteal")
print("[F5]       — Toggle Invisible")

local function ExpandedFarmLogic()
    local farmTargets = {}
    local farmHistory = {}
    local farmStats = {collected=0,bought=0,rebirths=0,steals=0,timeActive=0}
    local farmStartTime = tick()

    local function RecordFarm(action, value)
        table.insert(farmHistory, {action=action, value=value, time=tick()-farmStartTime})
        if #farmHistory > 200 then table.remove(farmHistory, 1) end
        if action == "collect" then farmStats.collected = farmStats.collected + (value or 1) end
        if action == "buy" then farmStats.bought = farmStats.bought + (value or 1) end
        if action == "rebirth" then farmStats.rebirths = farmStats.rebirths + 1 end
        if action == "steal" then farmStats.steals = farmStats.steals + (value or 1) end
        farmStats.timeActive = tick() - farmStartTime
    end

    local function ScanForFarmTargets()
        farmTargets = {}
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local nl = v.Name:lower()
                if nl:find("brainrot") or nl:find("drop") or nl:find("orb") or nl:find("money") or nl:find("cash") or nl:find("coin") then
                    local mh = GHRP()
                    if mh then
                        local dist = (mh.Position - v.Position).Magnitude
                        table.insert(farmTargets, {part=v, dist=dist, name=v.Name})
                    end
                end
            end
            if v:IsA("Model") then
                local nl = v.Name:lower()
                if nl:find("brainrot") or nl:find("noobini") or nl:find("tung") or nl:find("tralalero") or nl:find("bombardiro") or nl:find("glorbo") then
                    local mh = GHRP()
                    if mh then
                        local pos = v:GetPivot().Position
                        local dist = (mh.Position - pos).Magnitude
                        table.insert(farmTargets, {model=v, dist=dist, name=v.Name, pos=pos})
                    end
                end
            end
        end
        table.sort(farmTargets, function(a,b) return a.dist < b.dist end)
        return farmTargets
    end

    local function GetBestFarmTarget()
        local targets = ScanForFarmTargets()
        if #targets > 0 then return targets[1] end
        return nil
    end

    local function TeleportToTarget(target)
        local mh = GHRP()
        if not mh then return false end
        if target.part then
            mh.CFrame = CFrame.new(target.part.Position + Vector3.new(0, 3, 0))
            return true
        elseif target.model then
            mh.CFrame = CFrame.new(target.pos + Vector3.new(0, 3, 0))
            return true
        end
        return false
    end

    return {
        RecordFarm = RecordFarm,
        ScanTargets = ScanForFarmTargets,
        GetBest = GetBestFarmTarget,
        TeleportTo = TeleportToTarget,
        Stats = farmStats,
    }
end

local FarmSystem = ExpandedFarmLogic()

local function ExpandedESPSystem()
    local espData = {}
    local maxESPDist = 1000
    local updateInterval = 0.05
    local lastUpdate = 0

    local rarityColors = {
        common = Color3.fromRGB(200,200,200),
        uncommon = Color3.fromRGB(100,255,100),
        rare = Color3.fromRGB(60,140,255),
        epic = Color3.fromRGB(180,60,255),
        legendary = Color3.fromRGB(255,200,0),
        mythic = Color3.fromRGB(255,60,60),
    }

    local function GetRarityColor(name)
        local nl = name:lower()
        if nl:find("mythic") then return rarityColors.mythic end
        if nl:find("legendary") then return rarityColors.legendary end
        if nl:find("epic") then return rarityColors.epic end
        if nl:find("rare") then return rarityColors.rare end
        if nl:find("uncommon") then return rarityColors.uncommon end
        return rarityColors.common
    end

    local function GetHealthColor(hum)
        if not hum then return Color3.fromRGB(200,200,200) end
        local pct = hum.Health / hum.MaxHealth
        if pct > 0.7 then return Color3.fromRGB(50,220,80) end
        if pct > 0.35 then return Color3.fromRGB(255,180,0) end
        return Color3.fromRGB(255,50,50)
    end

    local function BuildPlayerESP(player)
        if player == LocalPlayer then return end
        local oldBB = espData[player.UserId]
        if oldBB then pcall(function() oldBB:Destroy() end) end
        espData[player.UserId] = nil

        local c = player.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hrp then return end

        local bb = Instance.new("BillboardGui", hrp)
        bb.Name = "DIHubESP"
        bb.Size = UDim2.new(0, 140, 0, 66)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = maxESPDist
        bb.ClipsDescendants = false

        local nameLabel = Instance.new("TextLabel", bb)
        nameLabel.Name = "NameLbl"
        nameLabel.Size = UDim2.new(1, 0, 0, 22)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        nameLabel.BackgroundTransparency = 0.4
        nameLabel.Text = "👤 " .. player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255,100,100)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        Instance.new("UICorner", nameLabel).CornerRadius = UDim.new(0, 4)

        local distLabel = Instance.new("TextLabel", bb)
        distLabel.Name = "DistLbl"
        distLabel.Size = UDim2.new(1, 0, 0, 18)
        distLabel.Position = UDim2.new(0, 0, 0, 24)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "? studs"
        distLabel.TextColor3 = Color3.fromRGB(255, 180, 60)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 11

        local healthLabel = Instance.new("TextLabel", bb)
        healthLabel.Name = "HpLbl"
        healthLabel.Size = UDim2.new(1, 0, 0, 18)
        healthLabel.Position = UDim2.new(0, 0, 0, 44)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "HP: ?"
        healthLabel.TextColor3 = Color3.fromRGB(50, 220, 80)
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextSize = 11

        espData[player.UserId] = bb

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not S.PlayerESP then conn:Disconnect() return end
            local myHRP = GHRP()
            local pHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local pHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if myHRP and pHRP then
                local dist = math.floor((myHRP.Position - pHRP.Position).Magnitude)
                distLabel.Text = dist .. " studs"
            end
            if pHum then
                local hp = math.floor(pHum.Health)
                local maxhp = math.floor(pHum.MaxHealth)
                healthLabel.Text = "HP: " .. hp .. "/" .. maxhp
                healthLabel.TextColor3 = GetHealthColor(pHum)
            end
        end)
    end

    local function ClearAll()
        for id, bb in pairs(espData) do
            pcall(function() bb:Destroy() end)
        end
        espData = {}
    end

    local function BuildAll()
        for _, p in ipairs(Players:GetPlayers()) do
            BuildPlayerESP(p)
        end
    end

    return {
        Build = BuildPlayerESP,
        BuildAll = BuildAll,
        Clear = ClearAll,
        GetRarityColor = GetRarityColor,
        Data = espData,
    }
end

local ESPSystem = ExpandedESPSystem()

local function ExpandedStealSystem()
    local stealQueue = {}
    local stealHistory = {}
    local maxHistory = 100
    local stealCount = 0
    local lastStealTime = 0
    local stealCooldown = 0.05

    local stealKeywords = {
        "steal", "grab", "take", "snatch", "pick", "collect",
        "brainrot", "noobini", "tung", "tralalero", "bombardiro",
        "cappuccino", "lirili", "larila", "boneca", "glorbo",
        "frutiger", "crocodilo", "ballerina", "shark"
    }

    local function IsStealTarget(name)
        local nl = name:lower()
        for _, kw in ipairs(stealKeywords) do
            if nl:find(kw) then return true end
        end
        return false
    end

    local function ScanStealTargets()
        stealQueue = {}
        local mh = GHRP()
        if not mh then return {} end
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local at = v.ActionText:lower()
                local ot = v.ObjectText:lower()
                if at:find("steal") or at:find("grab") or at:find("take") or ot:find("brainrot") then
                    local parent = v.Parent
                    if parent then
                        local pos = parent:IsA("BasePart") and parent.Position or
                                    parent:IsA("Model") and parent:GetPivot().Position or nil
                        if pos then
                            local dist = (mh.Position - pos).Magnitude
                            table.insert(stealQueue, {prompt=v, pos=pos, dist=dist, parent=parent})
                        end
                    end
                end
            end
        end
        table.sort(stealQueue, function(a,b) return a.dist < b.dist end)
        return stealQueue
    end

    local function ExecuteSteal(target)
        if not target then return false end
        if tick() - lastStealTime < stealCooldown then return false end
        local mh = GHRP()
        if not mh then return false end
        lastStealTime = tick()
        local oldCF = mh.CFrame
        if target.pos and (mh.Position - target.pos).Magnitude > 5 then
            mh.CFrame = CFrame.new(target.pos + Vector3.new(0, 2, 0))
            task.wait(0.03)
        end
        local success = pcall(function() fireproximityprompt(target.prompt) end)
        if success then
            stealCount = stealCount + 1
            table.insert(stealHistory, {name = target.parent and target.parent.Name or "?", time = tick()})
            if #stealHistory > maxHistory then table.remove(stealHistory, 1) end
        end
        task.wait(0.03)
        mh.CFrame = oldCF
        return success
    end

    local function ExecuteAll()
        local targets = ScanStealTargets()
        local success = 0
        for _, t in ipairs(targets) do
            if ExecuteSteal(t) then success = success + 1 end
            task.wait(0.02)
        end
        return success
    end

    local function InstantStealAll()
        local mh = GHRP()
        if not mh then return 0 end
        local count = 0
        local origCF = mh.CFrame
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local pHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if pHRP then
                    mh.CFrame = pHRP.CFrame * CFrame.new(0, 0, -3)
                    task.wait(0.02)
                    for _, v in ipairs(Workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            local at = v.ActionText:lower()
                            if at:find("steal") or at:find("grab") then
                                local pp = v.Parent
                                if pp then
                                    local pos = pp:IsA("BasePart") and pp.Position or
                                                pp:IsA("Model") and pp:GetPivot().Position or nil
                                    if pos and (mh.Position - pos).Magnitude < 20 then
                                        pcall(function() fireproximityprompt(v) end)
                                        count = count + 1
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.02)
                end
            end
        end
        task.wait(0.1)
        pcall(function() mh.CFrame = origCF end)
        return count
    end

    return {
        Scan = ScanStealTargets,
        Execute = ExecuteSteal,
        ExecuteAll = ExecuteAll,
        InstantAll = InstantStealAll,
        Count = function() return stealCount end,
        History = stealHistory,
    }
end

local StealSystem = ExpandedStealSystem()

local function ExpandedAntiSystem()
    local antiLog = {}
    local maxAntiLog = 50
    local protectedArea = nil
    local lockInterval = 0.1
    local lastLock = 0

    local lockKeywords = {"lock","protect","secure","close","base","guard","shield","block"}
    local antiStealKeywords = {"unlocked","open","unprotect"}

    local function LogAnti(event, detail)
        table.insert(antiLog, {event=event, detail=detail, time=tick()})
        if #antiLog > maxAntiLog then table.remove(antiLog, 1) end
    end

    local function SetProtectedArea(pos, radius)
        protectedArea = {center=pos, radius=radius}
    end

    local function IsInProtectedArea(pos)
        if not protectedArea then return false end
        return (pos - protectedArea.center).Magnitude <= protectedArea.radius
    end

    local function DoLock()
        if tick() - lastLock < lockInterval then return end
        lastLock = tick()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local nl = v.Name:lower()
                for _, kw in ipairs(lockKeywords) do
                    if nl:find(kw) then
                        pcall(function() v:FireServer() end)
                        LogAnti("lock_fire", v.Name)
                        break
                    end
                end
            end
            if v:IsA("ProximityPrompt") then
                local at = v.ActionText:lower()
                local ot = v.ObjectText:lower()
                for _, kw in ipairs(lockKeywords) do
                    if at:find(kw) or ot:find(kw) then
                        pcall(function() fireproximityprompt(v) end)
                        break
                    end
                end
            end
        end
    end

    local function DoInvisible(enable)
        local c = GC()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if (p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("SpecialMesh") or p:IsA("Decal")) and
               p.Name ~= "HumanoidRootPart" then
                pcall(function()
                    if enable then
                        p.Transparency = 1
                        if p:IsA("Decal") then p.Transparency = 1 end
                    else
                        p.Transparency = 0
                        if p:IsA("Decal") then p.Transparency = 0 end
                    end
                end)
            end
        end
        for _, acc in ipairs(c:GetChildren()) do
            if acc:IsA("Accessory") then
                for _, p in ipairs(acc:GetDescendants()) do
                    if p:IsA("BasePart") then
                        pcall(function() p.Transparency = enable and 1 or 0 end)
                    end
                end
            end
        end
    end

    local function FreezeTrading()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local nl = v.Name:lower()
                if nl:find("trade") or nl:find("exchange") or nl:find("offer") then
                    pcall(function()
                        local meta = getrawmetatable and getrawmetatable(v)
                        if meta then
                            setreadonly(meta, false)
                            meta.__index = function() return nil end
                            setreadonly(meta, true)
                        end
                    end)
                end
            end
        end
        for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("ScreenGui") then
                local nl = gui.Name:lower()
                if nl:find("trade") or nl:find("exchange") or nl:find("offer") then
                    pcall(function() gui.Enabled = false end)
                end
            end
        end
    end

    return {
        LogAnti = LogAnti,
        SetProtected = SetProtectedArea,
        IsProtected = IsInProtectedArea,
        DoLock = DoLock,
        DoInvisible = DoInvisible,
        FreezeTrading = FreezeTrading,
        Log = antiLog,
    }
end

local AntiSystem = ExpandedAntiSystem()

local function ExpandedMovementSystem()
    local flyActive = false
    local flySpeed = 60
    local noclipActive = false
    local savedPositions = {}
    local teleportHistory = {}
    local maxTeleHistory = 20

    local flyPhysics = {
        gyro = nil,
        velocity = nil,
        bodyForce = nil,
    }

    local function SavePosition(label)
        local mh = GHRP()
        if mh then
            savedPositions[label or ("pos"..tostring(#savedPositions+1))] = mh.CFrame
            table.insert(teleportHistory, {label=label, pos=mh.CFrame.Position, time=tick()})
            if #teleportHistory > maxTeleHistory then table.remove(teleportHistory, 1) end
        end
    end

    local function TeleportTo(label)
        local mh = GHRP()
        if mh and savedPositions[label] then
            mh.CFrame = savedPositions[label]
            return true
        end
        return false
    end

    local function TeleportToVector(pos)
        local mh = GHRP()
        if mh then
            mh.CFrame = CFrame.new(pos)
            return true
        end
        return false
    end

    local function EnableFly(speed)
        speed = speed or flySpeed
        local c = GC()
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        flyActive = true
        local hum = GHum()
        if hum then hum.PlatformStand = true end

        flyPhysics.gyro = Instance.new("BodyGyro", h)
        flyPhysics.gyro.Name = "DIFlyGyro"
        flyPhysics.gyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyPhysics.gyro.P = 1e5
        flyPhysics.gyro.D = 100

        flyPhysics.velocity = Instance.new("BodyVelocity", h)
        flyPhysics.velocity.Name = "DIFlyVel"
        flyPhysics.velocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyPhysics.velocity.Velocity = Vector3.zero

        Conns["FLY_MAIN"] = RunService.RenderStepped:Connect(function()
            if not flyActive then return end
            local cam = Workspace.CurrentCamera
            local dir = Vector3.zero
            local spd = S.FlySpeed or speed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd = spd * 2 end
            if flyPhysics.velocity then
                flyPhysics.velocity.Velocity = dir * spd
            end
            if flyPhysics.gyro then
                flyPhysics.gyro.CFrame = cam.CFrame
            end
        end)
    end

    local function DisableFly()
        flyActive = false
        DC("FLY_MAIN")
        local h = GHRP()
        if h then
            if h:FindFirstChild("DIFlyGyro") then h.DIFlyGyro:Destroy() end
            if h:FindFirstChild("DIFlyVel") then h.DIFlyVel:Destroy() end
        end
        local hum = GHum()
        if hum then hum.PlatformStand = false end
        flyPhysics = {gyro=nil,velocity=nil,bodyForce=nil}
    end

    local function EnableNoClip()
        noclipActive = true
        Conns["NOCLIP_MAIN"] = RunService.Stepped:Connect(function()
            if not noclipActive then return end
            local c = GC()
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end

    local function DisableNoClip()
        noclipActive = false
        DC("NOCLIP_MAIN")
        local c = GC()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end

    local function SetSpeed(spd)
        flySpeed = spd
        S.SpeedVal = spd
        local hum = GHum()
        if hum and S.SpeedBoost then hum.WalkSpeed = spd end
    end

    local function SetJump(jp)
        S.JumpVal = jp
        local hum = GHum()
        if hum and S.JumpBoost then hum.JumpPower = jp end
    end

    return {
        SavePos = SavePosition,
        TeleportLabel = TeleportTo,
        TeleportVec = TeleportToVector,
        EnableFly = EnableFly,
        DisableFly = DisableFly,
        EnableNoClip = EnableNoClip,
        DisableNoClip = DisableNoClip,
        SetSpeed = SetSpeed,
        SetJump = SetJump,
        History = teleportHistory,
        SavedPositions = savedPositions,
    }
end

local MovementSystem = ExpandedMovementSystem()

local function ExpandedPvPSystem()
    local aimActive = false
    local aimTarget = nil
    local aimSmoothing = 0.3
    local aimFOV = 80
    local aimBone = "HumanoidRootPart"
    local predictionStrength = 0.15
    local duelHistory = {}
    local duelStats = {won=0,lost=0,declined=0}

    local function GetClosestPlayer(fov)
        fov = fov or aimFOV
        local closest = nil
        local closestDist = math.huge
        local camCF = Camera.CFrame
        local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local c = p.Character
                local target = c:FindFirstChild(aimBone) or c:FindFirstChild("Head")
                if target then
                    local _, onScreen = Camera:WorldToScreenPoint(target.Position)
                    local screenPos = Camera:WorldToViewportPoint(target.Position)
                    local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if onScreen and dist2D < fov * 10 and dist2D < closestDist then
                        closestDist = dist2D
                        closest = target
                    end
                end
            end
        end
        return closest
    end

    local function GetPredictedPosition(target, strength)
        if not target then return nil end
        strength = strength or predictionStrength
        local vel = target.Velocity
        return target.Position + vel * strength
    end

    local function SmoothAim(target, smooth)
        smooth = smooth or aimSmoothing
        if not target then return end
        local targetPos = GetPredictedPosition(target) or target.Position
        local camCF = Camera.CFrame
        local targetCF = CFrame.new(camCF.Position, targetPos)
        Camera.CFrame = camCF:Lerp(targetCF, smooth)
    end

    local function InstantAim(target)
        if not target then return end
        local pos = GetPredictedPosition(target) or target.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
    end

    local function EnableAimAssist(smooth)
        aimActive = true
        DC("PVP_AIM")
        Conns["PVP_AIM"] = RunService.RenderStepped:Connect(function()
            if not aimActive then return end
            local target = GetClosestPlayer()
            if target then
                aimTarget = target
                SmoothAim(target, smooth or aimSmoothing)
            end
        end)
    end

    local function DisableAimAssist()
        aimActive = false
        DC("PVP_AIM")
        aimTarget = nil
    end

    local function TeleportBehindPlayer(player)
        local mh = GHRP()
        if not mh then return false end
        local target = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not target then
            target = GetClosestPlayer(1000)
        end
        if target then
            mh.CFrame = target.CFrame * CFrame.new(0, 0, 3) * CFrame.Angles(0, math.pi, 0)
            return true
        end
        return false
    end

    local function PushPlayer(player, force)
        force = force or 100
        local target = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local mh = GHRP()
        if not target or not mh then return end
        local dir = (target.Position - mh.Position).Unit
        local bv = Instance.new("BodyVelocity", target)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = dir * force + Vector3.new(0, force/2, 0)
        game:GetService("Debris"):AddItem(bv, 0.2)
    end

    local function RecordDuel(result)
        table.insert(duelHistory, {result=result, time=tick()})
        if #duelHistory > 50 then table.remove(duelHistory, 1) end
        if result == "won" then duelStats.won = duelStats.won + 1 end
        if result == "lost" then duelStats.lost = duelStats.lost + 1 end
        if result == "declined" then duelStats.declined = duelStats.declined + 1 end
    end

    return {
        GetClosest = GetClosestPlayer,
        GetPredicted = GetPredictedPosition,
        SmoothAim = SmoothAim,
        InstantAim = InstantAim,
        EnableAim = EnableAimAssist,
        DisableAim = DisableAimAssist,
        TeleportBehind = TeleportBehindPlayer,
        Push = PushPlayer,
        RecordDuel = RecordDuel,
        Stats = duelStats,
        History = duelHistory,
    }
end

local PvPSystem = ExpandedPvPSystem()

local function ExpandedFinderSystem()
    local brainrotDB = {
        "Noobini","Tralalero Tralala","Tung Tung Tung Sahur","Bombardiro Crocodilo",
        "Cappuccino Assassino","Lirili Larila","La Vaca Saturno Saturnita",
        "Ballerina Cappuccina","Brr Brr Patapim","Glorbo Frutiger",
        "Boneca Ambalabu","Tracotoco Trocoloco","Frigo Camelo","Bombombini Gusini",
        "Shrimp Brainrot","Trippi Troppi Truppi","Giogio Rublini","Burbaloni Lulilolli",
        "Chimpanzini Bananini","Lirilì Larilà","Bobritto Bandito","Trippi Troppi",
        "Pot Pot Pingpong","El Roostero Magnifico","Brrr Brrr Patapim","Udin Udin Ura",
        "Bobrito Bandito","Frr Frr Frulù","Glorbo Frutiger Aero","Piccione Macchina",
    }

    local rarityDB = {
        legendary = {"golden","shiny","rainbow","mythic","ultra","omega","divine","celestial","prismatic"},
        epic = {"epic","rare","special","unique","exclusive","limited","event"},
        uncommon = {"uncommon","uncommon","blue","green","silver"},
    }

    local function GetAllBrainrotsInWorkspace()
        local found = {}
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") then
                local nl = v.Name:lower()
                local isBR = false
                for _, n in ipairs(brainrotDB) do
                    if nl:find(n:lower()) then isBR = true break end
                end
                if not isBR then
                    isBR = nl:find("brainrot") or nl:find("noobini") or nl:find("tung") or nl:find("tralalero")
                end
                if isBR then
                    local pos = v:GetPivot().Position
                    local mh = GHRP()
                    local dist = mh and (mh.Position - pos).Magnitude or 0
                    local rarity = "common"
                    for r, keywords in pairs(rarityDB) do
                        for _, kw in ipairs(keywords) do
                            if nl:find(kw) then rarity = r break end
                        end
                    end
                    table.insert(found, {model=v, name=v.Name, pos=pos, dist=dist, rarity=rarity})
                end
            end
        end
        table.sort(found, function(a,b) return a.dist < b.dist end)
        return found
    end

    local function FindBrainrotByName(name)
        local nl = name:lower()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find(nl) then
                return v
            end
        end
        return nil
    end

    local function GetRarest()
        local all = GetAllBrainrotsInWorkspace()
        local priority = {legendary=4, epic=3, uncommon=2, common=1}
        table.sort(all, function(a,b)
            return (priority[a.rarity] or 0) > (priority[b.rarity] or 0)
        end)
        return all[1]
    end

    local function TeleportToNearest()
        local all = GetAllBrainrotsInWorkspace()
        if #all > 0 then
            local mh = GHRP()
            if mh then
                mh.CFrame = CFrame.new(all[1].pos + Vector3.new(0, 5, 0))
                return all[1]
            end
        end
        return nil
    end

    local function TeleportToRarest()
        local rarest = GetRarest()
        if rarest then
            local mh = GHRP()
            if mh then
                mh.CFrame = CFrame.new(rarest.pos + Vector3.new(0, 5, 0))
                return rarest
            end
        end
        return nil
    end

    local function BuildBrainrotESP()
        local all = GetAllBrainrotsInWorkspace()
        for _, br in ipairs(all) do
            if not br.model:FindFirstChild("DIBrainrotESP") then
                local bb = Instance.new("BillboardGui", br.model)
                bb.Name = "DIBrainrotESP"
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.StudsOffset = Vector3.new(0, 5, 0)
                bb.AlwaysOnTop = true
                local l = Instance.new("TextLabel", bb)
                l.Size = UDim2.new(1,0,1,0)
                l.BackgroundTransparency = 1
                l.Text = "🧠 " .. br.name
                l.TextColor3 = br.rarity == "legendary" and Color3.fromRGB(255,200,0) or
                               br.rarity == "epic" and Color3.fromRGB(180,60,255) or
                               Color3.fromRGB(100,255,100)
                l.Font = Enum.Font.GothamBold
                l.TextSize = 12
            end
        end
    end

    local function ClearBrainrotESP()
        for _, v in ipairs(Workspace:GetDescendants()) do
            local bb = v:FindFirstChild("DIBrainrotESP")
            if bb then bb:Destroy() end
        end
    end

    return {
        GetAll = GetAllBrainrotsInWorkspace,
        FindByName = FindBrainrotByName,
        GetRarest = GetRarest,
        TeleportNearest = TeleportToNearest,
        TeleportRarest = TeleportToRarest,
        BuildESP = BuildBrainrotESP,
        ClearESP = ClearBrainrotESP,
        DB = brainrotDB,
    }
end

local FinderSystem = ExpandedFinderSystem()

Conns["GLOBAL_HB"] = RunService.Heartbeat:Connect(function()
    if S.SpeedBoost then
        local h = GHum()
        if h and h.WalkSpeed ~= S.SpeedVal then h.WalkSpeed = S.SpeedVal end
    end
    if S.JumpBoost then
        local h = GHum()
        if h and h.JumpPower ~= S.JumpVal then h.JumpPower = S.JumpVal end
    end
    if S.AutoBuy then
        FireKW({"buy","purchase","conveyor"})
        FirePrompts({"buy","purchase","brainrot"})
    end
    if S.AutoRebirth then
        FireKW({"rebirth","prestige"})
        FirePrompts({"rebirth"})
    end
    if S.AutoSell then
        FireKW({"sell","cash","income"})
        FirePrompts({"sell"})
    end
    if S.AutoFarm then
        FireKW({"collect","farm","earn","money","cash","coins"})
    end
    if S.AutoCollect then
        local mh = GHRP()
        if mh then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local nl = v.Name:lower()
                    if (nl:find("drop") or nl:find("orb") or nl:find("coin") or nl:find("pickup")) then
                        if (mh.Position - v.Position).Magnitude < 80 then
                            pcall(function() mh.CFrame = CFrame.new(v.Position + Vector3.new(0,2,0)) end)
                        end
                    end
                end
            end
        end
    end
    if S.AutoLock then AntiSystem.DoLock() end
    if S.Invisible then AntiSystem.DoInvisible(true) end
    if S.InstantSteal then
        local targets = StealSystem.Scan()
        if #targets > 0 then StealSystem.Execute(targets[1]) end
    end
    if S.AutoSteal then
        local targets = StealSystem.Scan()
        for _, t in ipairs(targets) do
            if t.dist <= S.StealRange then
                StealSystem.Execute(t)
            end
        end
    end
    if S.StealAll then
        task.spawn(function() StealSystem.InstantAll() end)
    end
    if S.AimAssist then PvPSystem.EnableAim() end
    if S.AutoDuel then
        FireKW({"accept","duel","fight","challenge"})
        FirePrompts({"accept","duel","fight"})
    end
    if S.AntiDuel then
        FireKW({"decline","reject","cancel"})
        FirePrompts({"decline","reject"})
    end
    if S.BrainrotESP then
        FinderSystem.BuildESP()
    end
    if S.TradeFreeze then
        AntiSystem.FreezeTrading()
    end
    if S.AutoLeave then
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            for _, v in ipairs(ls:GetChildren()) do
                if (v.Name:lower():find("rating") or v.Name:lower():find("elo")) and
                   tonumber(v.Value) and tonumber(v.Value) < 5 then
                    pcall(function() LocalPlayer:Kick("DI Hub AutoLeave") end)
                end
            end
        end
    end
    if S.AntiAFK then
        pcall(function()
            local VU = game:GetService("VirtualUser")
            VU:CaptureController()
        end)
    end
    if S.NoClip then
        local c = GC()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
    if S.InfinityJump then end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    if S.PlayerESP then ESPSystem.BuildAll() end
    if S.Invisible then
        task.wait(0.3)
        AntiSystem.DoInvisible(true)
    end
    if S.SpeedBoost then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = S.SpeedVal end
    end
    if S.JumpBoost then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = S.JumpVal end
    end
    if S.InfinityJump then
        DC("IJUMP")
        Conns["IJUMP"] = UserInputService.JumpRequest:Connect(function()
            local h = GHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
    if S.FlyHack then
        task.wait(0.5)
        MovementSystem.EnableFly(S.FlySpeed)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        MovementSystem.SavePos("quicksave")
        Notify("Позиция сохранена [F6] ✅", Color3.fromRGB(100,255,100))
    end
    if input.KeyCode == Enum.KeyCode.F7 then
        if MovementSystem.TeleportLabel("quicksave") then
            Notify("ТП на сохранённую позицию [F7] ✅", Color3.fromRGB(100,255,100))
        else
            Notify("Сохранённая позиция не найдена", cDim)
        end
    end
    if input.KeyCode == Enum.KeyCode.F8 then
        local t = FinderSystem.TeleportNearest()
        if t then Notify("ТП к ближ. brainrot: "..t.name.." [F8] ✅", cYellow)
        else Notify("Brainrot не найден [F8]", cDim) end
    end
    if input.KeyCode == Enum.KeyCode.F9 then
        S.FlyHack = not S.FlyHack
        if S.FlyHack then
            MovementSystem.EnableFly(S.FlySpeed)
            Notify("Fly [F9]: ON ✅", cPurple)
        else
            MovementSystem.DisableFly()
            Notify("Fly [F9]: OFF ❌", cDim)
        end
    end
    if input.KeyCode == Enum.KeyCode.F10 then
        S.NoClip = not S.NoClip
        if S.NoClip then
            MovementSystem.EnableNoClip()
            Notify("NoClip [F10]: ON ✅", cPurple)
        else
            MovementSystem.DisableNoClip()
            Notify("NoClip [F10]: OFF ❌", cDim)
        end
    end
    if input.KeyCode == Enum.KeyCode.F11 then
        S.AimAssist = not S.AimAssist
        if S.AimAssist then
            PvPSystem.EnableAim()
            Notify("AimAssist [F11]: ON ✅", cPrimary)
        else
            PvPSystem.DisableAim()
            Notify("AimAssist [F11]: OFF ❌", cDim)
        end
    end
    if input.KeyCode == Enum.KeyCode.F12 then
        task.spawn(function()
            local count = StealSystem.InstantAll()
            Notify("InstantSteal ALL [F12]: "..count.." stolen ✅", cOrange)
        end)
    end
end)

print("=================================================")
print("  DI Hub v2.0 | Steal a Brainrot")
print("=================================================")
print("  [INSERT]  Toggle GUI")
print("  [RShift]  Toggle AutoSteal")
print("  [F4]      Toggle InstantSteal")
print("  [F5]      Toggle Invisible")
print("  [F6]      Save Position")
print("  [F7]      Teleport to Saved Pos")
print("  [F8]      Teleport to Nearest Brainrot")
print("  [F9]      Toggle Fly")
print("  [F10]     Toggle NoClip")
print("  [F11]     Toggle AimAssist")
print("  [F12]     InstantSteal ALL")
print("=================================================")

local function ExpandedUISystem()
    local notifQueue = {}
    local notifActive = false
    local notifHistory = {}
    local maxHistory = 100
    local colorThemes = {
        default = {primary=Color3.fromRGB(200,25,25), bg=Color3.fromRGB(11,11,18), text=Color3.fromRGB(230,210,210)},
        blue = {primary=Color3.fromRGB(40,120,255), bg=Color3.fromRGB(10,14,22), text=Color3.fromRGB(210,220,235)},
        green = {primary=Color3.fromRGB(40,190,80), bg=Color3.fromRGB(10,18,12), text=Color3.fromRGB(210,235,220)},
        purple = {primary=Color3.fromRGB(160,40,255), bg=Color3.fromRGB(14,10,20), text=Color3.fromRGB(220,210,235)},
        orange = {primary=Color3.fromRGB(255,120,20), bg=Color3.fromRGB(20,14,10), text=Color3.fromRGB(235,220,210)},
    }
    local activeTheme = "default"
    local function QueueNotif(msg, col)
        table.insert(notifQueue, {msg=msg, col=col})
        table.insert(notifHistory, {msg=msg, col=col, time=tick()})
        if #notifHistory > maxHistory then table.remove(notifHistory, 1) end
        if not notifActive then
            notifActive = true
            task.spawn(function()
                while #notifQueue > 0 do
                    local n = table.remove(notifQueue, 1)
                    task.wait(0.1)
                end
                notifActive = false
            end)
        end
    end
    local function SetTheme(themeName)
        local t = colorThemes[themeName]
        if not t then return end
        activeTheme = themeName
        if Main then
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundColor3=t.bg}):Play()
            local stroke = Main:FindFirstChildOfClass("UIStroke")
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), {Color=t.primary}):Play() end
        end
    end
    local function GetStatus()
        local active = {}
        for k, v in pairs(S) do
            if v == true then table.insert(active, k) end
        end
        return active
    end
    local function CountActive()
        local n = 0
        for _, v in pairs(S) do if v == true then n = n + 1 end end
        return n
    end
    local function ResetAllSettings()
        for k, v in pairs(S) do
            if type(v) == "boolean" then S[k] = false end
        end
        for k, _ in pairs(Conns) do DC(k) end
        local h = GHum()
        if h then h.WalkSpeed = 16; h.JumpPower = 50 end
        local c = GC()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true; p.Transparency = 0 end
            end
        end
        ESPSystem.Clear()
        FinderSystem.ClearESP()
        MovementSystem.DisableFly()
        PvPSystem.DisableAim()
        Notify("Все настройки сброшены ✅", Color3.fromRGB(100,200,255))
    end
    local function SaveConfig()
        local cfg = {}
        for k, v in pairs(S) do
            if type(v) == "boolean" or type(v) == "number" then
                cfg[k] = v
            end
        end
        return cfg
    end
    local function LoadConfig(cfg)
        if not cfg then return end
        for k, v in pairs(cfg) do
            if S[k] ~= nil then S[k] = v end
        end
    end
    return {
        Queue = QueueNotif,
        SetTheme = SetTheme,
        GetStatus = GetStatus,
        CountActive = CountActive,
        Reset = ResetAllSettings,
        SaveConfig = SaveConfig,
        LoadConfig = LoadConfig,
        Themes = colorThemes,
        History = notifHistory,
    }
end

local UISystem = ExpandedUISystem()

local function ExpandedRemoteLogger()
    local loggedRemotes = {}
    local remoteLog = {}
    local maxLog = 500
    local logging = false
    local filterKeywords = {}
    local ignoreKeywords = {"heartbeat","render","stepped","update","sync","ping","tick"}

    local function ShouldLog(name)
        local nl = name:lower()
        for _, kw in ipairs(ignoreKeywords) do
            if nl:find(kw) then return false end
        end
        if #filterKeywords > 0 then
            for _, kw in ipairs(filterKeywords) do
                if nl:find(kw) then return true end
            end
            return false
        end
        return true
    end

    local function LogRemote(remote, args)
        if not logging then return end
        if not ShouldLog(remote.Name) then return end
        local entry = {
            name = remote.Name,
            path = remote:GetFullName(),
            time = tick(),
            args = args or {},
        }
        table.insert(remoteLog, entry)
        if #remoteLog > maxLog then table.remove(remoteLog, 1) end
    end

    local function StartLogging()
        logging = true
        ScanRemotes(function(v)
            if not loggedRemotes[v] then
                loggedRemotes[v] = true
                local oldFire = v.FireServer
                pcall(function()
                    v.FireServer = function(self, ...)
                        LogRemote(v, {...})
                        return oldFire(self, ...)
                    end
                end)
            end
        end)
    end

    local function StopLogging()
        logging = false
    end

    local function GetLog(keyword)
        if not keyword then return remoteLog end
        local filtered = {}
        for _, e in ipairs(remoteLog) do
            if e.name:lower():find(keyword:lower()) then
                table.insert(filtered, e)
            end
        end
        return filtered
    end

    local function ClearLog()
        remoteLog = {}
        loggedRemotes = {}
    end

    local function FindStealRemotes()
        local found = {}
        ScanRemotes(function(v)
            local nl = v.Name:lower()
            if nl:find("steal") or nl:find("grab") or nl:find("take") or nl:find("brainrot") then
                table.insert(found, {name=v.Name, path=v:GetFullName(), remote=v})
            end
        end)
        return found
    end

    local function FindAllRemotes()
        local all = {}
        ScanRemotes(function(v) table.insert(all, {name=v.Name, path=v:GetFullName()}) end)
        return all
    end

    return {
        Start = StartLogging,
        Stop = StopLogging,
        GetLog = GetLog,
        Clear = ClearLog,
        FindSteal = FindStealRemotes,
        FindAll = FindAllRemotes,
        SetFilter = function(kws) filterKeywords = kws end,
    }
end

local RemoteLogger = ExpandedRemoteLogger()

local function ExpandedPlayerMonitor()
    local playerData = {}
    local joinHistory = {}
    local leaveHistory = {}
    local maxHistory = 50

    local function BuildPlayerData(player)
        local data = {
            name = player.Name,
            displayName = player.DisplayName,
            userId = player.UserId,
            accountAge = player.AccountAge,
            joinTime = tick(),
            character = nil,
            leaderstats = {},
        }
        local ls = player:FindFirstChild("leaderstats")
        if ls then
            for _, v in ipairs(ls:GetChildren()) do
                data.leaderstats[v.Name] = v.Value
            end
        end
        playerData[player.UserId] = data
        return data
    end

    local function UpdatePlayerData(player)
        if not playerData[player.UserId] then BuildPlayerData(player) end
        local data = playerData[player.UserId]
        local ls = player:FindFirstChild("leaderstats")
        if ls then
            for _, v in ipairs(ls:GetChildren()) do
                data.leaderstats[v.Name] = v.Value
            end
        end
        local c = player.Character
        if c then
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if hrp then data.lastPos = hrp.Position end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then data.health = hum.Health; data.maxHealth = hum.MaxHealth end
        end
    end

    local function GetDistanceTo(player)
        local mh = GHRP()
        if not mh then return math.huge end
        local c = player.Character
        if not c then return math.huge end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return math.huge end
        return (mh.Position - hrp.Position).Magnitude
    end

    local function GetClosestPlayer()
        local closest = nil
        local bd = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local d = GetDistanceTo(p)
                if d < bd then bd = d; closest = p end
            end
        end
        return closest, bd
    end

    local function GetRichestPlayer()
        local richest = nil
        local maxVal = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local ls = p:FindFirstChild("leaderstats")
                if ls then
                    for _, v in ipairs(ls:GetChildren()) do
                        local val = tonumber(v.Value) or 0
                        if val > maxVal then maxVal = val; richest = p end
                    end
                end
            end
        end
        return richest, maxVal
    end

    local function GetPlayerWithMostBrainrots()
        local best = nil
        local maxCount = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local count = 0
                for _, v in ipairs(p.Character:GetDescendants()) do
                    if v:IsA("Model") then
                        local nl = v.Name:lower()
                        if nl:find("brainrot") or nl:find("noobini") or nl:find("tung") then
                            count = count + 1
                        end
                    end
                end
                if count > maxCount then maxCount = count; best = p end
            end
        end
        return best, maxCount
    end

    for _, p in ipairs(Players:GetPlayers()) do BuildPlayerData(p) end

    Players.PlayerAdded:Connect(function(p)
        table.insert(joinHistory, {name=p.Name, time=tick()})
        if #joinHistory > maxHistory then table.remove(joinHistory, 1) end
        BuildPlayerData(p)
        if S.PlayerESP then
            p.CharacterAdded:Connect(function() task.wait(1) ESPSystem.Build(p) end)
        end
    end)

    Players.PlayerRemoving:Connect(function(p)
        table.insert(leaveHistory, {name=p.Name, time=tick()})
        if #leaveHistory > maxHistory then table.remove(leaveHistory, 1) end
    end)

    Conns["PLAYER_UPDATE"] = RunService.Heartbeat:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(function() UpdatePlayerData(p) end)
        end
    end)

    return {
        GetData = function(p) return playerData[p.UserId] end,
        GetAll = function() return playerData end,
        GetDist = GetDistanceTo,
        GetClosest = GetClosestPlayer,
        GetRichest = GetRichestPlayer,
        GetMostBrainrots = GetPlayerWithMostBrainrots,
        JoinHistory = joinHistory,
        LeaveHistory = leaveHistory,
    }
end

local PlayerMonitor = ExpandedPlayerMonitor()

local function ExpandedAutoFarmV2()
    local farmState = {
        phase = "idle",
        target = nil,
        lastAction = 0,
        actionInterval = 0.1,
        totalFarmed = 0,
        session = {start=tick(), actions=0},
    }

    local farmPhases = {
        idle = function()
            local best = FarmSystem.GetBest()
            if best then
                farmState.phase = "approach"
                farmState.target = best
            end
        end,
        approach = function()
            local target = farmState.target
            if not target then farmState.phase = "idle" return end
            local mh = GHRP()
            if not mh then return end
            local pos = target.part and target.part.Position or target.pos
            if not pos then farmState.phase = "idle" return end
            local dist = (mh.Position - pos).Magnitude
            if dist > 10 then
                FarmSystem.TeleportTo(target)
            else
                farmState.phase = "collect"
            end
        end,
        collect = function()
            local target = farmState.target
            if not target then farmState.phase = "idle" return end
            FireKW({"collect","farm","earn","money","cash","coins","income","gain"})
            FirePrompts({"collect","farm","pickup","grab","take"})
            farmState.totalFarmed = farmState.totalFarmed + 1
            farmState.session.actions = farmState.session.actions + 1
            farmState.phase = "idle"
            farmState.target = nil
        end,
    }

    local function RunFarmCycle()
        if tick() - farmState.lastAction < farmState.actionInterval then return end
        farmState.lastAction = tick()
        local phase = farmPhases[farmState.phase]
        if phase then pcall(phase) end
    end

    local function SetActionInterval(interval)
        farmState.actionInterval = math.max(0.05, interval)
    end

    local function GetSessionStats()
        return {
            duration = tick() - farmState.session.start,
            actions = farmState.session.actions,
            totalFarmed = farmState.totalFarmed,
            phase = farmState.phase,
        }
    end

    Conns["AUTOFARM_V2"] = RunService.Heartbeat:Connect(function()
        if S.AutoFarm then RunFarmCycle() end
    end)

    return {
        SetInterval = SetActionInterval,
        GetStats = GetSessionStats,
        State = farmState,
    }
end

local AutoFarmV2 = ExpandedAutoFarmV2()

local function ExpandedConfigSystem()
    local defaultConfig = {
        SpeedVal = 60, JumpVal = 200, StealRange = 200, FlySpeed = 60,
        PlayerESP = false, SpeedBoost = false, InfinityJump = false,
        JumpBoost = false, AutoBuy = false, AutoLeave = false,
        Invisible = false, TradeFreeze = false, AntiSteal = false,
        AutoLock = false, InstantSteal = false, AutoSteal = false,
        StealAll = false, AutoRebirth = false, AutoSell = false,
        AutoFarm = false, AutoCollect = false, BrainrotESP = false,
        ShowNames = false, ShowValues = false, AimAssist = false,
        AutoDuel = false, AntiDuel = false, NoClip = false,
        FlyHack = false, AntiAFK = false, Prediction = false,
        HighlightRare = false,
    }
    local savedConfig = {}
    local configHistory = {}
    local function SaveCurrentConfig(name)
        local cfg = {}
        for k, v in pairs(S) do
            if type(v) == "boolean" or type(v) == "number" then cfg[k] = v end
        end
        savedConfig[name or "default"] = cfg
        table.insert(configHistory, {name=name or "default", time=tick()})
        if #configHistory > 20 then table.remove(configHistory, 1) end
        return cfg
    end
    local function LoadSavedConfig(name)
        local cfg = savedConfig[name or "default"]
        if not cfg then return false end
        for k, v in pairs(cfg) do
            if S[k] ~= nil then S[k] = v end
        end
        return true
    end
    local function ResetToDefault()
        for k, v in pairs(defaultConfig) do S[k] = v end
    end
    local function ExportConfig()
        local lines = {}
        for k, v in pairs(S) do
            if type(v) == "boolean" or type(v) == "number" then
                table.insert(lines, k .. "=" .. tostring(v))
            end
        end
        return table.concat(lines, ";")
    end
    local function ImportConfig(str)
        for part in str:gmatch("[^;]+") do
            local k, v = part:match("(.+)=(.+)")
            if k and v then
                if v == "true" then S[k] = true
                elseif v == "false" then S[k] = false
                elseif tonumber(v) then S[k] = tonumber(v)
                end
            end
        end
    end
    SaveCurrentConfig("original")
    return {
        Save = SaveCurrentConfig,
        Load = LoadSavedConfig,
        Reset = ResetToDefault,
        Export = ExportConfig,
        Import = ImportConfig,
        Default = defaultConfig,
        History = configHistory,
    }
end

local ConfigSystem = ExpandedConfigSystem()

task.spawn(function()
    while true do
        task.wait(30)
        if S.AntiAFK then
            pcall(function()
                local VU = game:GetService("VirtualUser")
                VU:CaptureController()
                VU:ClickButton2(Vector2.new())
            end)
        end
        if S.PlayerESP then ESPSystem.BuildAll() end
        if S.BrainrotESP then FinderSystem.BuildESP() end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if S.AutoBuy then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Model") then
                    local nl = v.Name:lower()
                    if nl:find("shop") or nl:find("store") or nl:find("vendor") then
                        for _, btn in ipairs(v:GetDescendants()) do
                            if btn:IsA("TextButton") then
                                local tl = btn.Text:lower()
                                if tl:find("buy") or tl:find("purchase") then
                                    pcall(function() btn:Activate() end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if S.InfinityJump then
            local h = GHum()
            if h then
                h.JumpPower = math.max(h.JumpPower, 50)
            end
        end
        if S.SpeedBoost then
            local h = GHum()
            if h then h.WalkSpeed = S.SpeedVal end
        end
        if S.JumpBoost then
            local h = GHum()
            if h then h.JumpPower = S.JumpVal end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if S.AutoSteal or S.InstantSteal then
            local targets = StealSystem.Scan()
            for _, t in ipairs(targets) do
                if t.dist <= (S.StealRange or 200) then
                    StealSystem.Execute(t)
                    task.wait(0.05)
                end
            end
        end
        if S.StealAll then
            task.spawn(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local ph = p.Character:FindFirstChild("HumanoidRootPart")
                        local mh = GHRP()
                        if ph and mh then
                            local d = (mh.Position - ph.Position).Magnitude
                            if d < 500 then
                                mh.CFrame = ph.CFrame * CFrame.new(0,0,-3)
                                task.wait(0.05)
                                FireKW({"steal","grab","take"})
                                FirePrompts({"steal","grab"})
                            end
                        end
                    end
                end
            end)
        end
    end
end)
