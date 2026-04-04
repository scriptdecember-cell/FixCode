local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local VP = workspace.CurrentCamera.ViewportSize
local isMobile = VP.X < 700 or UserInputService.TouchEnabled

local W = isMobile and math.clamp(math.floor(VP.X * 0.88), 300, 430) or 420
local H = isMobile and 340 or 530

local PH_ORANGE = Color3.fromRGB(255, 153, 0)
local PH_BLACK  = Color3.fromRGB(14, 14, 14)
local PH_DARK   = Color3.fromRGB(22, 22, 22)
local PH_CARD   = Color3.fromRGB(28, 28, 28)
local PH_GREY   = Color3.fromRGB(90, 90, 90)
local PH_WHITE  = Color3.fromRGB(225, 225, 225)

local isSearching  = false
local foundCount   = 0
local checkedCount = 0
local entryOrder   = 0
local currentMode  = "Public"
local selectedSort = "Asc"
local guiOpen      = true
local foundServers = {} -- { jobId, playing, maxP, ping }
local maxPingFilter = 9999 -- 9999 = any (no limit)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PH_SF"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

-- FIX: forward declare Main so ToggleBtn callback can reference it
local Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(44, 44)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
ToggleBtn.BackgroundColor3 = PH_ORANGE
ToggleBtn.Text = "PH"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.TextColor3 = PH_BLACK
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 20
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

local TDrag = false
local TDragStart, TDragOrigin

ToggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        TDrag = false
        TDragStart = inp.Position
        TDragOrigin = ToggleBtn.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                if not TDrag then
                    guiOpen = not guiOpen
                    Main.Visible = guiOpen  -- works now because Main is forward declared
                    ToggleBtn.Text = guiOpen and "PH" or "PH"
                end
                TDrag = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if TDragStart and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local dx = inp.Position.X - TDragStart.X
        local dy = inp.Position.Y - TDragStart.Y
        if math.abs(dx) > 6 or math.abs(dy) > 6 then
            TDrag = true
        end
        if TDrag then
            local nx = math.clamp(TDragOrigin.X.Offset + dx, 0, VP.X - 44)
            local ny = math.clamp(TDragOrigin.Y.Offset + dy, 0, VP.Y - 44)
            ToggleBtn.Position = UDim2.fromOffset(nx, ny)
        end
    end
end)

-- FIX: assign Main (no 'local' keyword — uses the forward-declared upvalue)
Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
Main.BackgroundColor3 = PH_BLACK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.4
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ZIndex = 0
Shadow.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 46)
TopBar.BackgroundColor3 = PH_ORANGE
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)
local tf = Instance.new("Frame", TopBar)
tf.Size = UDim2.new(1, 0, 0, 14)
tf.Position = UDim2.new(0, 0, 1, -14)
tf.BackgroundColor3 = PH_ORANGE
tf.BorderSizePixel = 0
tf.ZIndex = 5

local LogoW = Instance.new("TextLabel", TopBar)
LogoW.Size = UDim2.new(0, 68, 1, 0)
LogoW.Position = UDim2.new(0, 10, 0, 0)
LogoW.BackgroundTransparency = 1
LogoW.Text = "porno"
LogoW.Font = Enum.Font.GothamBold
LogoW.TextSize = 19
LogoW.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoW.TextXAlignment = Enum.TextXAlignment.Left
LogoW.ZIndex = 6

local LogoBadge = Instance.new("TextLabel", TopBar)
LogoBadge.Size = UDim2.new(0, 44, 0, 22)
LogoBadge.Position = UDim2.new(0, 72, 0.5, -11)
LogoBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoBadge.Text = "hub"
LogoBadge.Font = Enum.Font.GothamBold
LogoBadge.TextSize = 14
LogoBadge.TextColor3 = PH_ORANGE
LogoBadge.ZIndex = 6
Instance.new("UICorner", LogoBadge).CornerRadius = UDim.new(0, 5)

local SubT = Instance.new("TextLabel", TopBar)
SubT.Size = UDim2.new(0, 110, 1, 0)
SubT.Position = UDim2.new(0, 122, 0, 0)
SubT.BackgroundTransparency = 1
SubT.Text = "Server Finder"
SubT.Font = Enum.Font.Gotham
SubT.TextSize = 11
SubT.TextColor3 = Color3.fromRGB(30, 30, 30)
SubT.TextXAlignment = Enum.TextXAlignment.Left
SubT.ZIndex = 6

-- FIX: close button now uses ❌ emoji
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 32, 0, 26)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CloseBtn.Text = "❌"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = PH_WHITE
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 7
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function()
    guiOpen = false
    Main.Visible = false
    ToggleBtn.Text = "PH"
end)

local dragging = false
local dragStart, frameStart

TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        frameStart = Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        Main.Position = UDim2.fromOffset(
            math.clamp(frameStart.X.Offset + dx, 0, VP.X - W),
            math.clamp(frameStart.Y.Offset + dy, 0, VP.Y - 46)
        )
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -46)
Content.Position = UDim2.new(0, 0, 0, 46)
Content.BackgroundTransparency = 1

-- Helper: join best server (lowest ping)
local function JoinBestServer(setStatus)
    if #foundServers == 0 then
        setStatus("No servers found!", Color3.fromRGB(255,60,60))
        return
    end
    local best = foundServers[1]
    for _, sv in ipairs(foundServers) do
        if sv.ping < best.ping then best = sv end
    end
    setStatus("Joining best (" .. best.ping .. "ms)...", Color3.fromRGB(255,200,0))
    TeleportService:TeleportToPlaceInstance(PlaceId, best.jobId, LocalPlayer)
end

if isMobile then
    local LeftCol = Instance.new("Frame", Content)
    LeftCol.Size = UDim2.new(0.48, -6, 1, 0)
    LeftCol.Position = UDim2.new(0, 8, 0, 0)
    LeftCol.BackgroundTransparency = 1

    local LeftLayout = Instance.new("UIListLayout", LeftCol)
    LeftLayout.Padding = UDim.new(0, 6)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local LeftPad = Instance.new("UIPadding", LeftCol)
    LeftPad.PaddingTop = UDim.new(0, 8)
    LeftPad.PaddingBottom = UDim.new(0, 8)

    local RightCol = Instance.new("Frame", Content)
    RightCol.Size = UDim2.new(0.52, -10, 1, 0)
    RightCol.Position = UDim2.new(0.48, 2, 0, 0)
    RightCol.BackgroundTransparency = 1

    local RightLayout = Instance.new("UIListLayout", RightCol)
    RightLayout.Padding = UDim.new(0, 6)
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local RightPad = Instance.new("UIPadding", RightCol)
    RightPad.PaddingTop = UDim.new(0, 8)
    RightPad.PaddingRight = UDim.new(0, 8)
    RightPad.PaddingBottom = UDim.new(0, 8)

    local function MiniLbl(parent, txt, lo)
        local l = Instance.new("TextLabel", parent)
        l.Size = UDim2.new(1, 0, 0, 14)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.Font = Enum.Font.GothamBold
        l.TextSize = 9
        l.TextColor3 = PH_GREY
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.LayoutOrder = lo
        return l
    end

    local function CardRow(parent, h, lo)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1, 0, 0, h)
        f.BackgroundColor3 = PH_CARD
        f.BorderSizePixel = 0
        f.LayoutOrder = lo
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        return f
    end

    MiniLbl(LeftCol, "MODE", 1)

    local ModeCard = CardRow(LeftCol, 58, 2)
    local ModeList = Instance.new("UIListLayout", ModeCard)
    ModeList.Padding = UDim.new(0, 3)
    ModeList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ModeList.VerticalAlignment = Enum.VerticalAlignment.Center
    local ModeP = Instance.new("UIPadding", ModeCard)
    ModeP.PaddingLeft = UDim.new(0, 5)
    ModeP.PaddingRight = UDim.new(0, 5)
    ModeP.PaddingTop = UDim.new(0, 5)
    ModeP.PaddingBottom = UDim.new(0, 5)

    local modes = {"Public", "Friends", "VIP"}
    local modeBtns = {}
    for _, m in ipairs(modes) do
        local mb = Instance.new("TextButton", ModeCard)
        mb.Size = UDim2.new(1, 0, 0, 14)
        mb.BackgroundColor3 = m == "Public" and PH_ORANGE or PH_DARK
        mb.Text = m
        mb.Font = Enum.Font.GothamBold
        mb.TextSize = 10
        mb.TextColor3 = m == "Public" and PH_BLACK or PH_GREY
        mb.BorderSizePixel = 0
        Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 5)
        modeBtns[m] = mb
        mb.MouseButton1Click:Connect(function()
            currentMode = m
            for _, k in ipairs(modes) do
                modeBtns[k].BackgroundColor3 = PH_DARK
                modeBtns[k].TextColor3 = PH_GREY
            end
            mb.BackgroundColor3 = PH_ORANGE
            mb.TextColor3 = PH_BLACK
        end)
    end

    MiniLbl(LeftCol, "MAX PLAYERS", 3)

    local CountCard = CardRow(LeftCol, 34, 4)
    local CountBox = Instance.new("TextBox", CountCard)
    CountBox.Size = UDim2.new(0.45, 0, 0.8, 0)
    CountBox.Position = UDim2.new(0, 6, 0.1, 0)
    CountBox.BackgroundColor3 = PH_DARK
    CountBox.Text = "10"
    CountBox.Font = Enum.Font.GothamBold
    CountBox.TextSize = 15
    CountBox.TextColor3 = PH_ORANGE
    CountBox.BorderSizePixel = 0
    CountBox.ClearTextOnFocus = false
    Instance.new("UICorner", CountBox).CornerRadius = UDim.new(0, 6)

    local qrow = Instance.new("Frame", CountCard)
    qrow.Size = UDim2.new(0.52, 0, 1, 0)
    qrow.Position = UDim2.new(0.47, 0, 0, 0)
    qrow.BackgroundTransparency = 1
    local qrl = Instance.new("UIListLayout", qrow)
    qrl.FillDirection = Enum.FillDirection.Horizontal
    qrl.Padding = UDim.new(0, 2)
    qrl.VerticalAlignment = Enum.VerticalAlignment.Center

    for _, v in ipairs({5, 10, 20}) do
        local qb = Instance.new("TextButton", qrow)
        qb.Size = UDim2.new(0, 28, 0, 22)
        qb.BackgroundColor3 = PH_DARK
        qb.Text = tostring(v)
        qb.Font = Enum.Font.GothamBold
        qb.TextSize = 10
        qb.TextColor3 = PH_ORANGE
        qb.BorderSizePixel = 0
        Instance.new("UICorner", qb).CornerRadius = UDim.new(0, 5)
        qb.MouseButton1Click:Connect(function() CountBox.Text = tostring(v) end)
    end

    MiniLbl(LeftCol, "MAX PING", 5)

    local PingCard = CardRow(LeftCol, 34, 6)
    local PingBox = Instance.new("TextBox", PingCard)
    PingBox.Size = UDim2.new(0.45, 0, 0.8, 0)
    PingBox.Position = UDim2.new(0, 6, 0.1, 0)
    PingBox.BackgroundColor3 = PH_DARK
    PingBox.Text = "any"
    PingBox.Font = Enum.Font.GothamBold
    PingBox.TextSize = 13
    PingBox.TextColor3 = Color3.fromRGB(100,220,100)
    PingBox.BorderSizePixel = 0
    PingBox.ClearTextOnFocus = false
    Instance.new("UICorner", PingBox).CornerRadius = UDim.new(0, 6)

    local pqrow = Instance.new("Frame", PingCard)
    pqrow.Size = UDim2.new(0.52, 0, 1, 0)
    pqrow.Position = UDim2.new(0.47, 0, 0, 0)
    pqrow.BackgroundTransparency = 1
    local pqrl = Instance.new("UIListLayout", pqrow)
    pqrl.FillDirection = Enum.FillDirection.Horizontal
    pqrl.Padding = UDim.new(0, 2)
    pqrl.VerticalAlignment = Enum.VerticalAlignment.Center

    for _, pv in ipairs({50, 100, 200}) do
        local pb = Instance.new("TextButton", pqrow)
        pb.Size = UDim2.new(0, 28, 0, 22)
        pb.BackgroundColor3 = PH_DARK
        pb.Text = tostring(pv)
        pb.Font = Enum.Font.GothamBold
        pb.TextSize = 10
        pb.TextColor3 = Color3.fromRGB(100,220,100)
        pb.BorderSizePixel = 0
        Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 5)
        pb.MouseButton1Click:Connect(function()
            PingBox.Text = tostring(pv)
            maxPingFilter = pv
        end)
    end

    PingBox.FocusLost:Connect(function()
        local v = tonumber(PingBox.Text)
        if v and v > 0 then
            maxPingFilter = v
        else
            maxPingFilter = 9999
            PingBox.Text = "any"
        end
    end)

    MiniLbl(LeftCol, "SORT", 7)

    local SortCard = CardRow(LeftCol, 30, 8)
    local SortRow = Instance.new("Frame", SortCard)
    SortRow.Size = UDim2.new(1, 0, 1, 0)
    SortRow.BackgroundTransparency = 1
    local srl = Instance.new("UIListLayout", SortRow)
    srl.FillDirection = Enum.FillDirection.Horizontal
    srl.Padding = UDim.new(0, 4)
    srl.VerticalAlignment = Enum.VerticalAlignment.Center
    local srp = Instance.new("UIPadding", SortRow)
    srp.PaddingLeft = UDim.new(0, 5)
    srp.PaddingTop = UDim.new(0, 4)

    local sortBtns = {}
    for _, pair in ipairs({{"Asc","↑ Few"},{"Desc","↓ Most"}}) do
        local k, lbl = pair[1], pair[2]
        local sb = Instance.new("TextButton", SortRow)
        sb.Size = UDim2.new(0, 50, 0, 22)
        sb.BackgroundColor3 = k == "Asc" and PH_ORANGE or PH_DARK
        sb.Text = lbl
        sb.Font = Enum.Font.GothamBold
        sb.TextSize = 10
        sb.TextColor3 = k == "Asc" and PH_BLACK or PH_GREY
        sb.BorderSizePixel = 0
        Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 5)
        sortBtns[k] = sb
        sb.MouseButton1Click:Connect(function()
            selectedSort = k
            for _, key in ipairs({"Asc","Desc"}) do
                sortBtns[key].BackgroundColor3 = PH_DARK
                sortBtns[key].TextColor3 = PH_GREY
            end
            sb.BackgroundColor3 = PH_ORANGE
            sb.TextColor3 = PH_BLACK
        end)
    end

    MiniLbl(LeftCol, "STATUS", 9)

    local StatusCard = CardRow(LeftCol, 30, 10)
    local StatusDot = Instance.new("Frame", StatusCard)
    StatusDot.Size = UDim2.new(0, 7, 0, 7)
    StatusDot.Position = UDim2.new(0, 8, 0.5, -3)
    StatusDot.BackgroundColor3 = PH_GREY
    StatusDot.BorderSizePixel = 0
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

    local StatusLabel = Instance.new("TextLabel", StatusCard)
    StatusLabel.Size = UDim2.new(1, -24, 1, 0)
    StatusLabel.Position = UDim2.new(0, 22, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Ready."
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 10
    StatusLabel.TextColor3 = PH_GREY
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function SetStatus(txt, col)
        StatusLabel.Text = txt
        StatusDot.BackgroundColor3 = col or PH_ORANGE
    end

    local function UpdateStatus()
        SetStatus(("✓%d / %d"):format(foundCount, checkedCount), Color3.fromRGB(100, 220, 100))
    end

    MiniLbl(RightCol, "RESULTS", 1)

    local ListScroll = Instance.new("ScrollingFrame", RightCol)
    ListScroll.Size = UDim2.new(1, 0, 0, 152)
    ListScroll.LayoutOrder = 2
    ListScroll.BackgroundColor3 = PH_DARK
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 2
    ListScroll.ScrollBarImageColor3 = PH_ORANGE
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 8)

    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local lp = Instance.new("UIPadding", ListScroll)
    lp.PaddingLeft = UDim.new(0, 5)
    lp.PaddingRight = UDim.new(0, 5)
    lp.PaddingTop = UDim.new(0, 5)
    lp.PaddingBottom = UDim.new(0, 5)

    local EmptyTxt = Instance.new("TextLabel", ListScroll)
    EmptyTxt.Size = UDim2.new(1, 0, 0, 30)
    EmptyTxt.BackgroundTransparency = 1
    EmptyTxt.Text = "No servers yet."
    EmptyTxt.Font = Enum.Font.Gotham
    EmptyTxt.TextSize = 11
    EmptyTxt.TextColor3 = Color3.fromRGB(50, 50, 50)

    local function AddEntry(jobId, playing, maxP, ping)
        EmptyTxt.Visible = false
        entryOrder += 1
        -- track for JOIN BEST
        table.insert(foundServers, { jobId = jobId, playing = playing, maxP = maxP, ping = ping or 9999 })

        local entry = Instance.new("Frame", ListScroll)
        entry.Size = UDim2.new(1, 0, 0, 36)
        entry.BackgroundColor3 = PH_CARD
        entry.BorderSizePixel = 0
        entry.LayoutOrder = entryOrder
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 6)

        local acc = Instance.new("Frame", entry)
        acc.Size = UDim2.new(0, 2, 0.6, 0)
        acc.Position = UDim2.new(0, 0, 0.2, 0)
        acc.BackgroundColor3 = PH_ORANGE
        acc.BorderSizePixel = 0
        Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)

        local plr = Instance.new("TextLabel", entry)
        plr.Size = UDim2.new(0, 44, 1, 0)
        plr.Position = UDim2.new(0, 7, 0, 0)
        plr.BackgroundTransparency = 1
        plr.Text = tostring(playing).."/"..tostring(maxP)
        plr.Font = Enum.Font.GothamBold
        plr.TextSize = 11
        plr.TextColor3 = PH_ORANGE
        plr.TextXAlignment = Enum.TextXAlignment.Left

        -- ping color: green < 80ms, orange < 150ms, red >= 150ms
        local pingC = PH_GREY
        if ping then
            pingC = ping < 80 and Color3.fromRGB(100,220,100)
                 or ping < 150 and PH_ORANGE
                 or Color3.fromRGB(220,80,80)
        end

        local pingL = Instance.new("TextLabel", entry)
        pingL.Size = UDim2.new(0, 36, 1, 0)
        pingL.Position = UDim2.new(0, 54, 0, 0)
        pingL.BackgroundTransparency = 1
        pingL.Text = ping and (tostring(ping).."ms") or "?ms"
        pingL.Font = Enum.Font.Gotham
        pingL.TextSize = 10
        pingL.TextColor3 = pingC
        pingL.TextXAlignment = Enum.TextXAlignment.Left

        local jb = Instance.new("TextButton", entry)
        jb.Size = UDim2.new(0, 44, 0, 22)
        jb.Position = UDim2.new(1, -50, 0.5, -11)
        jb.BackgroundColor3 = PH_ORANGE
        jb.Text = "JOIN"
        jb.Font = Enum.Font.GothamBold
        jb.TextSize = 10
        jb.TextColor3 = PH_BLACK
        jb.BorderSizePixel = 0
        Instance.new("UICorner", jb).CornerRadius = UDim.new(0, 5)
        jb.MouseButton1Click:Connect(function()
            jb.Text = "..."
            jb.BackgroundColor3 = Color3.fromRGB(180,110,0)
            SetStatus("Joining...", Color3.fromRGB(255,200,0))
            TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
        end)
    end

    local BtnRow = Instance.new("Frame", RightCol)
    BtnRow.Size = UDim2.new(1, 0, 0, 34)
    BtnRow.BackgroundTransparency = 1
    BtnRow.LayoutOrder = 3
    local brl = Instance.new("UIListLayout", BtnRow)
    brl.FillDirection = Enum.FillDirection.Horizontal
    brl.Padding = UDim.new(0, 5)

    local SearchBtn = Instance.new("TextButton", BtnRow)
    SearchBtn.Size = UDim2.new(0.62, 0, 1, 0)
    SearchBtn.BackgroundColor3 = PH_ORANGE
    SearchBtn.Text = "SEARCH"
    SearchBtn.Font = Enum.Font.GothamBold
    SearchBtn.TextSize = 12
    SearchBtn.TextColor3 = PH_BLACK
    SearchBtn.BorderSizePixel = 0
    Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 8)

    local ClearBtn = Instance.new("TextButton", BtnRow)
    ClearBtn.Size = UDim2.new(0.36, 0, 1, 0)
    ClearBtn.BackgroundColor3 = PH_DARK
    ClearBtn.Text = "CLEAR"
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextSize = 12
    ClearBtn.TextColor3 = PH_GREY
    ClearBtn.BorderSizePixel = 0
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

    -- JOIN BEST button row (mobile)
    local BestRow = Instance.new("Frame", RightCol)
    BestRow.Size = UDim2.new(1, 0, 0, 28)
    BestRow.BackgroundTransparency = 1
    BestRow.LayoutOrder = 4

    local BestBtn = Instance.new("TextButton", BestRow)
    BestBtn.Size = UDim2.new(1, 0, 1, 0)
    BestBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
    BestBtn.Text = "⚡ JOIN BEST (min ping)"
    BestBtn.Font = Enum.Font.GothamBold
    BestBtn.TextSize = 10
    BestBtn.TextColor3 = Color3.fromRGB(100,220,100)
    BestBtn.BorderSizePixel = 0
    Instance.new("UICorner", BestBtn).CornerRadius = UDim.new(0, 8)
    BestBtn.MouseButton1Click:Connect(function()
        JoinBestServer(SetStatus)
    end)

    local function ClearList()
        for _, c in ipairs(ListScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        foundCount = 0; checkedCount = 0; entryOrder = 0
        foundServers = {}
        EmptyTxt.Visible = true
        SetStatus("Cleared.", PH_GREY)
    end

    ClearBtn.MouseButton1Click:Connect(ClearList)

    local function FetchPublic(maxP, sort)
        local cursor = ""
        repeat
            if not isSearching then break end
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100"):format(PlaceId, sort)
            if cursor ~= "" then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
            local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
            if not ok or not res or not res.data then SetStatus("API err.", Color3.fromRGB(255,60,60)) break end
            for _, s in ipairs(res.data) do
                if not isSearching then break end
                checkedCount += 1
                local sPing = s.ping or 9999
                if s.playing and s.playing <= maxP and sPing <= maxPingFilter then
                    foundCount += 1
                    AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping)
                    UpdateStatus()
                end
            end
            cursor = res.nextPageCursor or ""
            task.wait(0.3)
        until cursor == "" or not isSearching
    end

    local function FetchOther(mode, maxP)
        local url = ("https://games.roblox.com/v1/games/%d/servers/%s?limit=100"):format(PlaceId, mode)
        local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or not res or not res.data then SetStatus("API err.", Color3.fromRGB(255,60,60)) return end
        for _, s in ipairs(res.data) do
            if not isSearching then break end
            checkedCount += 1
            local sPing = s.ping or 9999
            if s.playing and s.playing <= maxP and sPing <= maxPingFilter then
                foundCount += 1
                AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping)
                UpdateStatus()
            end
        end
    end

    SearchBtn.MouseButton1Click:Connect(function()
        if isSearching then
            isSearching = false
            SearchBtn.Text = "SEARCH"
            SearchBtn.BackgroundColor3 = PH_ORANGE
            return
        end
        local maxP = tonumber(CountBox.Text)
        if not maxP or maxP < 1 then SetStatus("Invalid!", Color3.fromRGB(255,60,60)) return end
        task.spawn(function()
            isSearching = true
            SearchBtn.Text = "■ STOP"
            SearchBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
            SetStatus("Searching...", PH_ORANGE)
            if currentMode == "Public" then FetchPublic(maxP, selectedSort)
            else FetchOther(currentMode, maxP) end
            if isSearching then
                SetStatus(foundCount == 0 and "None found." or ("Done! "..foundCount.." found."),
                    foundCount == 0 and Color3.fromRGB(255,80,80) or Color3.fromRGB(100,220,100))
            end
            isSearching = false
            SearchBtn.Text = "SEARCH"
            SearchBtn.BackgroundColor3 = PH_ORANGE
        end)
    end)

else
    -- DESKTOP LAYOUT
    local Scroll = Instance.new("ScrollingFrame", Content)
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = PH_ORANGE
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local SL = Instance.new("UIListLayout", Scroll)
    SL.Padding = UDim.new(0, 8)
    SL.SortOrder = Enum.SortOrder.LayoutOrder

    local SP = Instance.new("UIPadding", Scroll)
    SP.PaddingLeft = UDim.new(0, 12)
    SP.PaddingRight = UDim.new(0, 12)
    SP.PaddingTop = UDim.new(0, 10)
    SP.PaddingBottom = UDim.new(0, 10)

    local function GF(lo)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1, 0, 0, 0)
        f.AutomaticSize = Enum.AutomaticSize.Y
        f.BackgroundTransparency = 1
        f.LayoutOrder = lo
        local l = Instance.new("UIListLayout", f)
        l.Padding = UDim.new(0, 5)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        return f
    end

    local function ML(p, t, lo)
        local l = Instance.new("TextLabel", p)
        l.Size = UDim2.new(1, 0, 0, 14); l.BackgroundTransparency = 1
        l.Text = t; l.Font = Enum.Font.GothamBold; l.TextSize = 10
        l.TextColor3 = PH_GREY; l.TextXAlignment = Enum.TextXAlignment.Left
        l.LayoutOrder = lo or 0; return l
    end

    local function CR(p, h, lo)
        local f = Instance.new("Frame", p)
        f.Size = UDim2.new(1, 0, 0, h); f.BackgroundColor3 = PH_CARD
        f.BorderSizePixel = 0; f.LayoutOrder = lo
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9); return f
    end

    local g1 = GF(1); ML(g1, "SEARCH MODE", 0)
    local ModeCard = CR(g1, 36, 1)
    local MG = Instance.new("UIGridLayout", ModeCard)
    MG.CellSize = UDim2.new(0.333, -3, 1, -8)
    MG.CellPadding = UDim2.fromOffset(3, 0)
    MG.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MG.VerticalAlignment = Enum.VerticalAlignment.Center

    local modes = {"Public", "Friends", "VIP"}
    local modeBtns = {}
    for _, m in ipairs(modes) do
        local mb = Instance.new("TextButton", ModeCard)
        mb.Text = m; mb.Font = Enum.Font.GothamBold; mb.TextSize = 12
        mb.BorderSizePixel = 0
        mb.BackgroundColor3 = m == "Public" and PH_ORANGE or PH_DARK
        mb.TextColor3 = m == "Public" and PH_BLACK or PH_GREY
        Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 6)
        modeBtns[m] = mb
        mb.MouseButton1Click:Connect(function()
            currentMode = m
            for _, k in ipairs(modes) do modeBtns[k].BackgroundColor3 = PH_DARK; modeBtns[k].TextColor3 = PH_GREY end
            mb.BackgroundColor3 = PH_ORANGE; mb.TextColor3 = PH_BLACK
        end)
    end

    local g2 = GF(2); ML(g2, "MAX PLAYERS", 0)
    local CRow = Instance.new("Frame", g2)
    CRow.Size = UDim2.new(1, 0, 0, 38); CRow.BackgroundTransparency = 1; CRow.LayoutOrder = 1
    local crl = Instance.new("UIListLayout", CRow)
    crl.FillDirection = Enum.FillDirection.Horizontal; crl.Padding = UDim.new(0, 5)
    crl.VerticalAlignment = Enum.VerticalAlignment.Center

    local CountBox = Instance.new("TextBox", CRow)
    CountBox.Size = UDim2.new(0, 65, 0, 36); CountBox.BackgroundColor3 = PH_CARD
    CountBox.Text = "10"; CountBox.Font = Enum.Font.GothamBold; CountBox.TextSize = 18
    CountBox.TextColor3 = PH_ORANGE; CountBox.BorderSizePixel = 0; CountBox.ClearTextOnFocus = false
    Instance.new("UICorner", CountBox).CornerRadius = UDim.new(0, 8)

    for _, v in ipairs({1, 5, 10, 20, 50}) do
        local qb = Instance.new("TextButton", CRow)
        qb.Size = UDim2.new(0, 40, 0, 36); qb.BackgroundColor3 = PH_DARK
        qb.Text = tostring(v); qb.Font = Enum.Font.GothamBold; qb.TextSize = 13
        qb.TextColor3 = PH_ORANGE; qb.BorderSizePixel = 0
        Instance.new("UICorner", qb).CornerRadius = UDim.new(0, 7)
        qb.MouseButton1Click:Connect(function() CountBox.Text = tostring(v) end)
        qb.MouseEnter:Connect(function() qb.BackgroundColor3 = Color3.fromRGB(38,38,38) end)
        qb.MouseLeave:Connect(function() qb.BackgroundColor3 = PH_DARK end)
    end

    local g3 = GF(3); ML(g3, "MAX PING  (ms)", 0)
    local PingCRow = Instance.new("Frame", g3)
    PingCRow.Size = UDim2.new(1, 0, 0, 38); PingCRow.BackgroundTransparency = 1; PingCRow.LayoutOrder = 1
    local pcrl = Instance.new("UIListLayout", PingCRow)
    pcrl.FillDirection = Enum.FillDirection.Horizontal; pcrl.Padding = UDim.new(0, 5)
    pcrl.VerticalAlignment = Enum.VerticalAlignment.Center

    local PingBox = Instance.new("TextBox", PingCRow)
    PingBox.Size = UDim2.new(0, 65, 0, 36); PingBox.BackgroundColor3 = PH_CARD
    PingBox.Text = "any"; PingBox.Font = Enum.Font.GothamBold; PingBox.TextSize = 16
    PingBox.TextColor3 = Color3.fromRGB(100,220,100); PingBox.BorderSizePixel = 0; PingBox.ClearTextOnFocus = false
    Instance.new("UICorner", PingBox).CornerRadius = UDim.new(0, 8)

    for _, pv in ipairs({50, 80, 100, 150, 200}) do
        local pb = Instance.new("TextButton", PingCRow)
        pb.Size = UDim2.new(0, 40, 0, 36); pb.BackgroundColor3 = PH_DARK
        pb.Text = tostring(pv); pb.Font = Enum.Font.GothamBold; pb.TextSize = 13
        pb.TextColor3 = Color3.fromRGB(100,220,100); pb.BorderSizePixel = 0
        Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 7)
        pb.MouseButton1Click:Connect(function()
            PingBox.Text = tostring(pv)
            maxPingFilter = pv
        end)
        pb.MouseEnter:Connect(function() pb.BackgroundColor3 = Color3.fromRGB(38,38,38) end)
        pb.MouseLeave:Connect(function() pb.BackgroundColor3 = PH_DARK end)
    end

    PingBox.FocusLost:Connect(function()
        local v = tonumber(PingBox.Text)
        if v and v > 0 then
            maxPingFilter = v
        else
            maxPingFilter = 9999
            PingBox.Text = "any"
        end
    end)

    local g4 = GF(4); ML(g4, "SORT ORDER", 0)
    local SortRow = Instance.new("Frame", g4)
    SortRow.Size = UDim2.new(1, 0, 0, 34); SortRow.BackgroundTransparency = 1; SortRow.LayoutOrder = 1
    local srl = Instance.new("UIListLayout", SortRow)
    srl.FillDirection = Enum.FillDirection.Horizontal; srl.Padding = UDim.new(0, 5)
    srl.VerticalAlignment = Enum.VerticalAlignment.Center

    local sortBtns = {}
    for _, pair in ipairs({{"Asc","↑ Fewest"},{"Desc","↓ Most"}}) do
        local k, lbl = pair[1], pair[2]
        local sb = Instance.new("TextButton", SortRow)
        sb.Size = UDim2.new(0, 82, 0, 32); sb.BackgroundColor3 = k == "Asc" and PH_ORANGE or PH_DARK
        sb.Text = lbl; sb.Font = Enum.Font.GothamBold; sb.TextSize = 12
        sb.TextColor3 = k == "Asc" and PH_BLACK or PH_GREY; sb.BorderSizePixel = 0
        Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 7)
        sortBtns[k] = sb
        sb.MouseButton1Click:Connect(function()
            selectedSort = k
            for _, key in ipairs({"Asc","Desc"}) do sortBtns[key].BackgroundColor3 = PH_DARK; sortBtns[key].TextColor3 = PH_GREY end
            sb.BackgroundColor3 = PH_ORANGE; sb.TextColor3 = PH_BLACK
        end)
    end

    local g5 = GF(5); ML(g5, "STATUS", 0)
    local StatusCard = CR(g5, 34, 1)
    local StatusDot = Instance.new("Frame", StatusCard)
    StatusDot.Size = UDim2.new(0, 8, 0, 8); StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
    StatusDot.BackgroundColor3 = PH_GREY; StatusDot.BorderSizePixel = 0
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    local StatusLabel = Instance.new("TextLabel", StatusCard)
    StatusLabel.Size = UDim2.new(1, -28, 1, 0); StatusLabel.Position = UDim2.new(0, 26, 0, 0)
    StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Ready."
    StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = PH_GREY; StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function SetStatus(txt, col)
        StatusLabel.Text = txt; StatusDot.BackgroundColor3 = col or PH_ORANGE
    end

    local function UpdateStatus()
        SetStatus(("Found %d  |  Checked %d"):format(foundCount, checkedCount), Color3.fromRGB(100,220,100))
    end

    local g6 = GF(6); ML(g6, "RESULTS", 0)
    local ListScroll = Instance.new("ScrollingFrame", g6)
    ListScroll.Size = UDim2.new(1, 0, 0, 180); ListScroll.LayoutOrder = 1
    ListScroll.BackgroundColor3 = PH_DARK; ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3; ListScroll.ScrollBarImageColor3 = PH_ORANGE
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; ListScroll.CanvasSize = UDim2.new(0,0,0,0)
    Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 9)
    local LL = Instance.new("UIListLayout", ListScroll)
    LL.Padding = UDim.new(0, 4); LL.SortOrder = Enum.SortOrder.LayoutOrder
    local lp = Instance.new("UIPadding", ListScroll)
    lp.PaddingLeft = UDim.new(0, 6); lp.PaddingRight = UDim.new(0, 6)
    lp.PaddingTop = UDim.new(0, 6); lp.PaddingBottom = UDim.new(0, 6)

    local EmptyTxt = Instance.new("TextLabel", ListScroll)
    EmptyTxt.Size = UDim2.new(1, 0, 0, 36); EmptyTxt.BackgroundTransparency = 1
    EmptyTxt.Text = "No servers yet."; EmptyTxt.Font = Enum.Font.Gotham
    EmptyTxt.TextSize = 12; EmptyTxt.TextColor3 = Color3.fromRGB(50,50,50)

    local function AddEntry(jobId, playing, maxP, ping)
        EmptyTxt.Visible = false; entryOrder += 1
        -- track for JOIN BEST
        table.insert(foundServers, { jobId = jobId, playing = playing, maxP = maxP, ping = ping or 9999 })

        local entry = Instance.new("Frame", ListScroll)
        entry.Size = UDim2.new(1, 0, 0, 44); entry.BackgroundColor3 = PH_CARD
        entry.BorderSizePixel = 0; entry.LayoutOrder = entryOrder
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 7)
        local acc = Instance.new("Frame", entry)
        acc.Size = UDim2.new(0, 3, 0.6, 0); acc.Position = UDim2.new(0, 0, 0.2, 0)
        acc.BackgroundColor3 = PH_ORANGE; acc.BorderSizePixel = 0
        Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)
        local plr = Instance.new("TextLabel", entry)
        plr.Size = UDim2.new(0, 58, 1, 0); plr.Position = UDim2.new(0, 10, 0, 0)
        plr.BackgroundTransparency = 1; plr.Text = tostring(playing).."/"..tostring(maxP)
        plr.Font = Enum.Font.GothamBold; plr.TextSize = 14
        plr.TextColor3 = PH_ORANGE; plr.TextXAlignment = Enum.TextXAlignment.Left

        -- ping color: green < 80ms, orange < 150ms, red >= 150ms
        local pingC = PH_GREY
        if ping then
            pingC = ping < 80 and Color3.fromRGB(100,220,100)
                 or ping < 150 and PH_ORANGE
                 or Color3.fromRGB(220,80,80)
        end
        local pingL = Instance.new("TextLabel", entry)
        pingL.Size = UDim2.new(0, 52, 1, 0); pingL.Position = UDim2.new(0, 70, 0, 0)
        pingL.BackgroundTransparency = 1; pingL.Text = ping and (tostring(ping).."ms") or "?ms"
        pingL.Font = Enum.Font.Gotham; pingL.TextSize = 12
        pingL.TextColor3 = pingC; pingL.TextXAlignment = Enum.TextXAlignment.Left
        local idL = Instance.new("TextLabel", entry)
        idL.Size = UDim2.new(1, -155, 0, 13); idL.Position = UDim2.new(0, 70, 1, -17)
        idL.BackgroundTransparency = 1; idL.Text = string.sub(jobId, 1, 18).."..."
        idL.Font = Enum.Font.Gotham; idL.TextSize = 9
        idL.TextColor3 = Color3.fromRGB(50,50,50); idL.TextXAlignment = Enum.TextXAlignment.Left
        local jb = Instance.new("TextButton", entry)
        jb.Size = UDim2.new(0, 56, 0, 26); jb.Position = UDim2.new(1, -64, 0.5, -13)
        jb.BackgroundColor3 = PH_ORANGE; jb.Text = "JOIN"
        jb.Font = Enum.Font.GothamBold; jb.TextSize = 12; jb.TextColor3 = PH_BLACK; jb.BorderSizePixel = 0
        Instance.new("UICorner", jb).CornerRadius = UDim.new(0, 6)
        jb.MouseButton1Click:Connect(function()
            jb.Text = "..."; jb.BackgroundColor3 = Color3.fromRGB(180,110,0)
            SetStatus("Joining...", Color3.fromRGB(255,200,0))
            TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
        end)
    end

    local g6 = GF(6)
    local g7 = GF(7)
    local BtnRow = Instance.new("Frame", g7)
    BtnRow.Size = UDim2.new(1, 0, 0, 40); BtnRow.BackgroundTransparency = 1; BtnRow.LayoutOrder = 1
    local brl = Instance.new("UIListLayout", BtnRow)
    brl.FillDirection = Enum.FillDirection.Horizontal; brl.Padding = UDim.new(0, 6)

    local SearchBtn = Instance.new("TextButton", BtnRow)
    SearchBtn.Size = UDim2.new(0.65, 0, 1, 0); SearchBtn.BackgroundColor3 = PH_ORANGE
    SearchBtn.Text = "SEARCH SERVERS"; SearchBtn.Font = Enum.Font.GothamBold
    SearchBtn.TextSize = 13; SearchBtn.TextColor3 = PH_BLACK; SearchBtn.BorderSizePixel = 0
    Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 9)

    local ClearBtn = Instance.new("TextButton", BtnRow)
    ClearBtn.Size = UDim2.new(0.33, 0, 1, 0); ClearBtn.BackgroundColor3 = PH_DARK
    ClearBtn.Text = "CLEAR"; ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextSize = 13; ClearBtn.TextColor3 = PH_GREY; ClearBtn.BorderSizePixel = 0
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 9)

    -- JOIN BEST button row (desktop)
    local BestRow = Instance.new("Frame", g7)
    BestRow.Size = UDim2.new(1, 0, 0, 36); BestRow.BackgroundTransparency = 1; BestRow.LayoutOrder = 2

    local BestBtn = Instance.new("TextButton", BestRow)
    BestBtn.Size = UDim2.new(1, 0, 1, 0)
    BestBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
    BestBtn.Text = "⚡  JOIN BEST SERVER  (lowest ping)"
    BestBtn.Font = Enum.Font.GothamBold
    BestBtn.TextSize = 13
    BestBtn.TextColor3 = Color3.fromRGB(100,220,100)
    BestBtn.BorderSizePixel = 0
    Instance.new("UICorner", BestBtn).CornerRadius = UDim.new(0, 9)
    BestBtn.MouseEnter:Connect(function() BestBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 30) end)
    BestBtn.MouseLeave:Connect(function() BestBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20) end)
    BestBtn.MouseButton1Click:Connect(function()
        JoinBestServer(SetStatus)
    end)

    local function ClearList()
        for _, c in ipairs(ListScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        foundCount = 0; checkedCount = 0; entryOrder = 0
        foundServers = {}
        EmptyTxt.Visible = true; SetStatus("Cleared.", PH_GREY)
    end

    ClearBtn.MouseButton1Click:Connect(ClearList)
    SearchBtn.MouseEnter:Connect(function() SearchBtn.BackgroundColor3 = Color3.fromRGB(220,130,0) end)
    SearchBtn.MouseLeave:Connect(function() if not isSearching then SearchBtn.BackgroundColor3 = PH_ORANGE end end)

    local function FetchPublic(maxP, sort)
        local cursor = ""
        repeat
            if not isSearching then break end
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100"):format(PlaceId, sort)
            if cursor ~= "" then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
            local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
            if not ok or not res or not res.data then SetStatus("API error.", Color3.fromRGB(255,60,60)) break end
            for _, s in ipairs(res.data) do
                if not isSearching then break end
                checkedCount += 1
                local sPing = s.ping or 9999
                if s.playing and s.playing <= maxP and sPing <= maxPingFilter then
                    foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping); UpdateStatus()
                end
            end
            cursor = res.nextPageCursor or ""; task.wait(0.3)
        until cursor == "" or not isSearching
    end

    local function FetchOther(mode, maxP)
        local url = ("https://games.roblox.com/v1/games/%d/servers/%s?limit=100"):format(PlaceId, mode)
        local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or not res or not res.data then SetStatus("API error.", Color3.fromRGB(255,60,60)) return end
        for _, s in ipairs(res.data) do
            if not isSearching then break end
            checkedCount += 1
            local sPing = s.ping or 9999
            if s.playing and s.playing <= maxP and sPing <= maxPingFilter then
                foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping); UpdateStatus()
            end
        end
    end

    SearchBtn.MouseButton1Click:Connect(function()
        if isSearching then
            isSearching = false; SearchBtn.Text = "SEARCH SERVERS"; SearchBtn.BackgroundColor3 = PH_ORANGE; return
        end
        local maxP = tonumber(CountBox.Text)
        if not maxP or maxP < 1 then SetStatus("Invalid number!", Color3.fromRGB(255,60,60)) return end
        task.spawn(function()
            isSearching = true; SearchBtn.Text = "■ STOP"; SearchBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
            SetStatus("Searching...", PH_ORANGE)
            if currentMode == "Public" then FetchPublic(maxP, selectedSort) else FetchOther(currentMode, maxP) end
            if isSearching then
                SetStatus(foundCount == 0 and "Nothing found." or ("Done! "..foundCount.." servers found."),
                    foundCount == 0 and Color3.fromRGB(255,80,80) or Color3.fromRGB(100,220,100))
            else SetStatus("Stopped. Found "..foundCount..".", PH_ORANGE) end
            isSearching = false; SearchBtn.Text = "SEARCH SERVERS"; SearchBtn.BackgroundColor3 = PH_ORANGE
        end)
    end)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    VP = workspace.CurrentCamera.ViewportSize
    isMobile = VP.X < 700 or UserInputService.TouchEnabled
    W = isMobile and math.clamp(math.floor(VP.X * 0.88), 300, 430) or 420
    H = isMobile and 340 or 530
    Main.Size = UDim2.fromOffset(W, H)
    Main.Position = UDim2.fromOffset(
        math.clamp(Main.Position.X.Offset, 0, VP.X - W),
        math.clamp(Main.Position.Y.Offset, 0, VP.Y - 46)
    )
    ToggleBtn.Position = UDim2.fromOffset(
        math.clamp(ToggleBtn.Position.X.Offset, 0, VP.X - 44),
        math.clamp(ToggleBtn.Position.Y.Offset, 0, VP.Y - 44)
    )
end)
