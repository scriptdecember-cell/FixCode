local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local SCRIPT_VERSION = "1.0.0"
local RELEASE_DATE   = "22.03.2025"
local HOME_X         = 133.15
local HOME_Z         = 0.08
local SAFE_Y         = -1.20

pcall(function() setthrottleenabled(false) end)
pcall(function() sethiddenproperty(game, "ThrottleEnabled", false) end)
pcall(function() setfpscap(0) end)

local PlotActionRF = ReplicatedStorage
	:WaitForChild("Shared"):WaitForChild("Remotes")
	:WaitForChild("Networking"):WaitForChild("RF/PlotAction")

local UpgradeSpeedRF = ReplicatedStorage
	:WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed")

local FlyEnabled        = false
local AutoTrialEnabled  = false
local TrialRarity       = "Unknown"
local TrialNeed         = 0
local TrialDone         = 0
local SpeedGodEnabled   = false
local SpeedGodValue     = 50
local AutoFarmEnabled   = false
local AntiDetectEnabled = false

local GROQ_KEY        = "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"
local HS              = game:GetService("HttpService")
local AIEnabled       = false
local AIPatternIdx    = 0
local AIPatterns      = {}
local AIStepPatterns  = {}   -- per-step walk timings
local AIStepIdx       = 0
local AIHistory       = {}   -- track delay history for adaptation
local AISession       = 0    -- session counter
local AILastKick      = 0    -- last time anticheat reacted
local AIAdaptScore    = 0    -- 0=safe, higher=need change

-- Conversation memory for multi-turn AI
local AIMessages = {}

local function AIAddMsg(role, text)
	table.insert(AIMessages, {role=role, content=text})
	if #AIMessages > 12 then table.remove(AIMessages, 1) end
end

local function QueryGroq(userMsg, temp, tokens)
	temp   = temp   or 0.85
	tokens = tokens or 200
	AIAddMsg("user", userMsg)
	local ok, result = pcall(function()
		local body = HS:JSONEncode({
			model    = "llama-3.1-70b-versatile",
			messages = AIMessages,
			max_tokens  = tokens,
			temperature = temp,
		})
		local resp = game:HttpGet(
			"https://api.groq.com/openai/v1/chat/completions",
			{Method="POST", Headers={["Authorization"]="Bearer "..GROQ_KEY,["Content-Type"]="application/json"}, Body=body}
		)
		local data = HS:JSONDecode(resp)
		local txt  = data.choices[1].message.content
		AIAddMsg("assistant", txt)
		return txt
	end)
	if ok then return result end
	return nil
end

local function ParseJSONArray(txt)
	if not txt then return nil end
	local arr_str = txt:match("%[([%d%.,% ]+)%]")
	if not arr_str then return nil end
	local arr = {}
	for n in arr_str:gmatch("[%d%.]+") do
		local v = tonumber(n)
		if v then table.insert(arr, v) end
	end
	return #arr > 0 and arr or nil
end

local function AIInit()
	-- System prompt: set AI role and context
	table.insert(AIMessages, 1, {
		role = "system",
		content = [[You are an expert Roblox anti-anticheat AI engine. Your job is to generate timing patterns for a farming bot to avoid detection in the game "Escape Tsunami for Brainrots". 
Rules:
- Never explain, only output JSON arrays
- Delays must look human: vary between 0.7-3.2s, no fixed patterns
- Step timings (per movement step): 0.004-0.015s range
- Adapt based on session history provided
- If anticheat suspected: make delays longer and more irregular]]
	})
end

local function AIGenerateDelays()
	task.spawn(function()
		AISession += 1
		local histStr = ""
		if #AIHistory > 0 then
			local last = math.min(6, #AIHistory)
			local recent = {}
			for i = #AIHistory - last + 1, #AIHistory do
				table.insert(recent, tostring(AIHistory[i]))
			end
			histStr = " Recent used delays: ["..table.concat(recent,",").."]."
		end
		local adaptStr = AIAdaptScore > 3 and " ANTICHEAT DETECTED - make delays MUCH more irregular and longer!" or ""
		local msg = "Session "..AISession..". Generate a JSON array of 16 human-like delay values (0.7-3.2s) for farming steps."..histStr..adaptStr.." Only output the array."
		local result = QueryGroq(msg, 0.9, 120)
		local arr = ParseJSONArray(result)
		if arr then
			AIPatterns = arr
			AIPatternIdx = 0
			
		else
			AIPatterns = {1.1,0.9,1.5,1.2,0.85,1.8,1.0,1.3,2.0,0.95,1.4,1.7,0.8,1.6,1.1,0.9}
			
		end
	end)
end

local function AIGenerateStepTimings()
	task.spawn(function()
		local msg = "Generate a JSON array of 20 step timing values (0.004-0.015s) for smooth bot movement that avoids velocity-based anticheat detection. Vary the values naturally. Only output the array."
		local result = QueryGroq(msg, 0.8, 100)
		local arr = ParseJSONArray(result)
		if arr then
			AIStepPatterns = arr
			AIStepIdx = 0
			
		end
	end)
end

local function GetAIDelay()
	if not AIEnabled or #AIPatterns == 0 then
		return FarmDelay + math.random(2,8)/10
	end
	AIPatternIdx = (AIPatternIdx % #AIPatterns) + 1
	local base = AIPatterns[AIPatternIdx]
	if type(base) ~= "number" then base = FarmDelay end
	local val = math.max(0.7, base + math.random(-8,8)/100)
	table.insert(AIHistory, val)
	if #AIHistory > 30 then table.remove(AIHistory, 1) end
	return val
end

local function GetAIStepTime()
	if not AIEnabled or #AIStepPatterns == 0 then
		return 0.007 + math.random(0,3)/1000
	end
	AIStepIdx = (AIStepIdx % #AIStepPatterns) + 1
	local base = AIStepPatterns[AIStepIdx]
	if type(base) ~= "number" then base = 0.007 end
	return math.max(0.004, base + math.random(-1,1)/1000)
end

local function AIReportSuspicion()
	AIAdaptScore += 1
	AILastKick = tick()
	if AIAdaptScore >= 2 then
		
		AIAdaptScore = 0
		AIGenerateDelays()
		AIGenerateStepTimings()
	end
end

local function FloodACDetector()
	-- Rapid pattern switching to overload pattern-recognition anticheat
	task.spawn(function()
		local rapidPatterns = {}
		for i = 1, 8 do
			local p = {}
			for j = 1, 16 do
				table.insert(p, 0.7 + math.random(0, 250)/100)
			end
			table.insert(rapidPatterns, p)
		end
		local idx = 0
		while AIEnabled do
			idx = (idx % #rapidPatterns) + 1
			for k, v in ipairs(rapidPatterns[idx]) do
				if AIPatterns[k] then
					AIPatterns[k] = AIPatterns[k] * 0.7 + v * 0.3
				end
			end
			task.wait(0.8 + math.random(0,40)/100)
		end
	end)
end

local function AIAdaptLoop()
	task.spawn(function()
		FloodACDetector()
		while AIEnabled do
			task.wait(75 + math.random(0,25))
			if not AIEnabled then break end
			local timeSinceKick = tick() - AILastKick
			if timeSinceKick > 180 then
				AIAdaptScore = math.max(0, AIAdaptScore - 1)
			end
			AIGenerateDelays()
			if AISession % 2 == 0 then
				AIGenerateStepTimings()
			end
			-- Re-flood with new randomized base
			FloodACDetector()
		end
	end)
end


local FlySpeed          = 50
local FarmDelay         = 1.4
local CarryCount        = 1
local FarmCount         = 0
local nowe              = false
local tpwalking         = false
local isFarming         = false
local MenuOpen          = true
local ActiveTab         = "Main"
local LogLines          = {}
local MAX_LOGS          = 6
local LANG              = "EN"
local flyUpHeld         = false
local flyDownHeld       = false

local SelectedRarities = {
	Common=true, Uncommon=true, Rare=true, Epic=true,
	Legendary=false, Mythical=false, Cosmic=false,
	Secret=false, Celestial=false, Divine=false, Infinity=false
}
local RARITIES = {
	"Common","Uncommon","Rare","Epic","Legendary",
	"Mythical","Cosmic","Secret","Celestial","Divine","Infinity"
}

local L = {
	EN = {
		main="Main", farm="Farm", trial="Trial", info="Info", close="✕ Close",
		fly="Fly", flyDesc="Fly freely with WASD",
		flySpeed="Fly Speed", vertical="Vertical",
		autoFarm="Auto Farm", autoFarmDesc="Auto collect brainrots safely",
		antidetect="Anti-Detect", antidetectDesc="Randomize delay & jitter",
		godmode="God Mode", godmodeDesc="Load external god mode script",
		speedgod="Speed God", speedgodDesc="Set unlimited walk speed",
		rarityFilter="RARITY FILTER",
		logs="LOGS", version="Version", released="Released",
		username="Username", displayName="Display Name",
		playerId="Player ID", accountAge="Account Age", days=" days",
		chooselang="Select Language",
	},
	RU = {
		main="Главная", farm="Фарм", trial="Триал", info="Инфо", close="✕ Закрыть",
		fly="Полёт", flyDesc="Летать свободно WASD",
		flySpeed="Скорость", vertical="Вертикаль",
		autoFarm="Авто Фарм", autoFarmDesc="Авто сбор брейнротов",
		antidetect="Антидетект", antidetectDesc="Рандомизация задержки",
		godmode="Бог Мод", godmodeDesc="Загрузить внешний god mode",
		speedgod="Скорость Бога", speedgodDesc="Установить любую скорость",
		rarityFilter="ФИЛЬТР РАРИТИ",
		logs="ЛОГИ", version="Версия", released="Дата выхода",
		username="Юзернейм", displayName="Имя",
		playerId="ID игрока", accountAge="Возраст", days=" дней",
		chooselang="Выберите язык",
	}
}
local function T(k) return L[LANG][k] or k end

local GUI = Instance.new("ScreenGui")
GUI.Name = "StarHub"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999
GUI.IgnoreGuiInset = true
GUI.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

local function Corner(r,p)
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p
end
local function Stroke(col,th,p)
	local s=Instance.new("UIStroke") s.Color=col s.Thickness=th s.Parent=p
end
local function Tw(obj,t,props)
	TweenService:Create(obj,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
end
local function MakeTxt(props,parent)
	local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.BorderSizePixel=0
	for k,v in pairs(props) do l[k]=v end l.Parent=parent return l
end
local function MakeBtn(props,parent)
	local b=Instance.new("TextButton") b.BorderSizePixel=0
	for k,v in pairs(props) do b[k]=v end b.Parent=parent return b
end
local function MakeCard(parent,y,h)
	local c=Instance.new("Frame")
	c.Size=UDim2.new(1,0,0,h) c.Position=UDim2.new(0,0,0,y)
	c.BackgroundColor3=Color3.fromRGB(11,11,11) c.BorderSizePixel=0 c.ZIndex=7 c.Parent=parent
	Corner(10,c) Stroke(Color3.fromRGB(30,30,30),1,c) return c
end
local function MakeToggle(parent,y,titleTxt,descTxt,onToggle)
	local card=MakeCard(parent,y,60)
	local tl=MakeTxt({Size=UDim2.new(1,-72,0,20),Position=UDim2.new(0,14,0,8),Text=titleTxt,TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},card)
	local dl=MakeTxt({Size=UDim2.new(1,-72,0,13),Position=UDim2.new(0,14,0,31),Text=descTxt,TextColor3=Color3.fromRGB(68,68,68),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},card)
	local bg=Instance.new("Frame") bg.Size=UDim2.new(0,44,0,24) bg.Position=UDim2.new(1,-54,0.5,-12) bg.BackgroundColor3=Color3.fromRGB(20,20,20) bg.BorderSizePixel=0 bg.ZIndex=9 bg.Parent=card
	Corner(12,bg) Stroke(Color3.fromRGB(46,46,46),1,bg)
	local knob=Instance.new("Frame") knob.Size=UDim2.new(0,18,0,18) knob.Position=UDim2.new(0,3,0.5,-9) knob.BackgroundColor3=Color3.fromRGB(88,88,88) knob.BorderSizePixel=0 knob.ZIndex=10 knob.Parent=bg
	Corner(9,knob)
	local hb=MakeBtn({Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=11},bg)
	local state=false
	hb.MouseButton1Click:Connect(function()
		state=not state
		if state then
			Tw(bg,0.18,{BackgroundColor3=Color3.fromRGB(36,36,36)})
			Tw(knob,0.18,{Position=UDim2.new(0,23,0.5,-9),BackgroundColor3=Color3.fromRGB(255,255,255)})
		else
			Tw(bg,0.18,{BackgroundColor3=Color3.fromRGB(20,20,20)})
			Tw(knob,0.18,{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(88,88,88)})
		end
		onToggle(state)
	end)
	return {card=card,title=tl,desc=dl}
end

local ShimmerColors = {
	Color3.fromRGB(255,255,255), Color3.fromRGB(180,220,255),
	Color3.fromRGB(120,190,255), Color3.fromRGB(200,235,255),
	Color3.fromRGB(90,170,255),  Color3.fromRGB(255,255,255),
	Color3.fromRGB(150,205,255), Color3.fromRGB(255,255,255),
}

local LoadScreen = Instance.new("Frame")
LoadScreen.Size=UDim2.new(1,0,1,0) LoadScreen.BackgroundColor3=Color3.fromRGB(0,0,0)
LoadScreen.BorderSizePixel=0 LoadScreen.ZIndex=50 LoadScreen.Parent=GUI

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size=UDim2.new(0,340,0,54) LoadTitle.Position=UDim2.new(0.5,-170,0.5,-52)
LoadTitle.BackgroundTransparency=1 LoadTitle.Text="Star Hub"
LoadTitle.TextColor3=Color3.fromRGB(255,255,255) LoadTitle.TextTransparency=1
LoadTitle.TextSize=48 LoadTitle.Font=Enum.Font.GothamBold
LoadTitle.TextXAlignment=Enum.TextXAlignment.Center LoadTitle.ZIndex=51 LoadTitle.Parent=LoadScreen

local ShimmerBar = Instance.new("Frame")
ShimmerBar.Size=UDim2.new(0,340,0,54) ShimmerBar.Position=UDim2.new(0.5,-170,0.5,-52)
ShimmerBar.BackgroundTransparency=1 ShimmerBar.BorderSizePixel=0
ShimmerBar.ClipsDescendants=true ShimmerBar.ZIndex=52 ShimmerBar.Parent=LoadScreen

local ShimmerLabels = {}
for i=1,8 do
	local lbl=Instance.new("TextLabel")
	lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.Text="Star Hub"
	lbl.TextColor3=ShimmerColors[i] lbl.TextTransparency=1 lbl.TextSize=48
	lbl.Font=Enum.Font.GothamBold lbl.TextXAlignment=Enum.TextXAlignment.Center
	lbl.ZIndex=52+i lbl.Parent=ShimmerBar ShimmerLabels[i]=lbl
end

local LoadGame = MakeTxt({
	Size=UDim2.new(0,340,0,16), Position=UDim2.new(0.5,-170,0.5,10),
	Text="Escape Tsunami for Brainrots", TextColor3=Color3.fromRGB(65,65,65),
	TextTransparency=1, TextSize=11, Font=Enum.Font.Gotham,
	TextXAlignment=Enum.TextXAlignment.Center, ZIndex=51,
}, LoadScreen)
local LoadSub = MakeTxt({
	Size=UDim2.new(0,260,0,14), Position=UDim2.new(0.5,-130,0.5,34),
	Text="Loading...", TextColor3=Color3.fromRGB(85,85,85),
	TextTransparency=1, TextSize=11, Font=Enum.Font.Gotham,
	TextXAlignment=Enum.TextXAlignment.Center, ZIndex=51,
}, LoadScreen)

local BarBg = Instance.new("Frame")
BarBg.Size=UDim2.new(0,220,0,3) BarBg.Position=UDim2.new(0.5,-110,0.5,58)
BarBg.BackgroundColor3=Color3.fromRGB(18,18,18) BarBg.BackgroundTransparency=1
BarBg.BorderSizePixel=0 BarBg.ZIndex=51 BarBg.Parent=LoadScreen Corner(2,BarBg)
local BarFill = Instance.new("Frame")
BarFill.Size=UDim2.new(0,0,1,0) BarFill.BackgroundColor3=Color3.fromRGB(100,180,255)
BarFill.BorderSizePixel=0 BarFill.ZIndex=52 BarFill.Parent=BarBg Corner(2,BarFill)

local function StartShimmer()
	task.spawn(function()
		local idx=1
		while LoadScreen.Parent do
			for i,lbl in ipairs(ShimmerLabels) do
				TweenService:Create(lbl,TweenInfo.new(0.1),{TextTransparency=math.clamp(math.abs(i-idx)/3.5,0,1)}):Play()
			end
			idx=(idx%#ShimmerLabels)+1
			task.wait(0.07)
		end
	end)
end

local LangScreen = Instance.new("Frame")
LangScreen.Size=UDim2.new(1,0,1,0) LangScreen.BackgroundColor3=Color3.fromRGB(0,0,0)
LangScreen.BorderSizePixel=0 LangScreen.ZIndex=45 LangScreen.Visible=false LangScreen.Parent=GUI

local LangCard = Instance.new("Frame")
LangCard.Size=UDim2.new(0,320,0,228) LangCard.Position=UDim2.new(0.5,-160,0.5,-114)
LangCard.BackgroundColor3=Color3.fromRGB(8,8,8) LangCard.BorderSizePixel=0
LangCard.BackgroundTransparency=1 LangCard.ZIndex=46 LangCard.Parent=LangScreen
Corner(16,LangCard) Stroke(Color3.fromRGB(40,40,40),1,LangCard)

local LangTop = Instance.new("Frame")
LangTop.Size=UDim2.new(1,0,0,56) LangTop.BackgroundColor3=Color3.fromRGB(5,5,5)
LangTop.BorderSizePixel=0 LangTop.ZIndex=47 LangTop.Parent=LangCard Corner(16,LangTop)
local _ltf=Instance.new("Frame") _ltf.Size=UDim2.new(1,0,0.5,0) _ltf.Position=UDim2.new(0,0,0.5,0) _ltf.BackgroundColor3=Color3.fromRGB(5,5,5) _ltf.BorderSizePixel=0 _ltf.ZIndex=47 _ltf.Parent=LangTop

local LangSTBox = Instance.new("Frame")
LangSTBox.Size=UDim2.new(0,38,0,38) LangSTBox.Position=UDim2.new(0,12,0.5,-19)
LangSTBox.BackgroundColor3=Color3.fromRGB(12,12,12) LangSTBox.BorderSizePixel=0
LangSTBox.ZIndex=48 LangSTBox.Parent=LangTop Corner(10,LangSTBox) Stroke(Color3.fromRGB(48,48,48),1,LangSTBox)
local _lst=Instance.new("TextLabel") _lst.Size=UDim2.new(1,0,1,0) _lst.BackgroundTransparency=1 _lst.Text="ST" _lst.TextColor3=Color3.fromRGB(255,255,255) _lst.TextSize=14 _lst.Font=Enum.Font.GothamBold _lst.TextXAlignment=Enum.TextXAlignment.Center _lst.ZIndex=49 _lst.Parent=LangSTBox

local _lh=Instance.new("TextLabel") _lh.Size=UDim2.new(0,200,0,22) _lh.Position=UDim2.new(0,58,0.5,-18) _lh.BackgroundTransparency=1 _lh.Text="Star Hub" _lh.TextColor3=Color3.fromRGB(255,255,255) _lh.TextSize=16 _lh.Font=Enum.Font.GothamBold _lh.TextXAlignment=Enum.TextXAlignment.Left _lh.ZIndex=48 _lh.Parent=LangTop
local _lg=Instance.new("TextLabel") _lg.Size=UDim2.new(0,230,0,13) _lg.Position=UDim2.new(0,58,0.5,4) _lg.BackgroundTransparency=1 _lg.Text="Escape Tsunami for Brainrots" _lg.TextColor3=Color3.fromRGB(65,65,65) _lg.TextSize=9 _lg.Font=Enum.Font.Gotham _lg.TextXAlignment=Enum.TextXAlignment.Left _lg.ZIndex=48 _lg.Parent=LangTop

local LangDiv = Instance.new("Frame")
LangDiv.Size=UDim2.new(1,-32,0,1) LangDiv.Position=UDim2.new(0,16,0,56)
LangDiv.BackgroundColor3=Color3.fromRGB(25,25,25) LangDiv.BorderSizePixel=0 LangDiv.ZIndex=47 LangDiv.Parent=LangCard

local LangTitleLbl = MakeTxt({
	Size=UDim2.new(1,-32,0,16), Position=UDim2.new(0,16,0,66),
	Text="Select Language", TextColor3=Color3.fromRGB(90,90,90),
	TextSize=10, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=47,
}, LangCard)

local function MakeLangBtn(emoji,label,sub,x)
	local btn=MakeBtn({
		Size=UDim2.new(0,132,0,80), Position=UDim2.new(0,x,0,90),
		BackgroundColor3=Color3.fromRGB(13,13,13), BackgroundTransparency=1,
		Text="", ZIndex=48,
	}, LangCard)
	Corner(12,btn) Stroke(Color3.fromRGB(38,38,38),1,btn)
	local ef=Instance.new("TextLabel") ef.Size=UDim2.new(1,0,0,36) ef.Position=UDim2.new(0,0,0,8) ef.BackgroundTransparency=1 ef.Text=emoji ef.TextColor3=Color3.fromRGB(255,255,255) ef.TextSize=28 ef.Font=Enum.Font.GothamBold ef.TextXAlignment=Enum.TextXAlignment.Center ef.ZIndex=49 ef.Parent=btn
	local ll=Instance.new("TextLabel") ll.Size=UDim2.new(1,0,0,18) ll.Position=UDim2.new(0,0,0,46) ll.BackgroundTransparency=1 ll.Text=label ll.TextColor3=Color3.fromRGB(220,220,220) ll.TextSize=13 ll.Font=Enum.Font.GothamBold ll.TextXAlignment=Enum.TextXAlignment.Center ll.ZIndex=49 ll.Parent=btn
	local sl=Instance.new("TextLabel") sl.Size=UDim2.new(1,0,0,12) sl.Position=UDim2.new(0,0,0,65) sl.BackgroundTransparency=1 sl.Text=sub sl.TextColor3=Color3.fromRGB(60,60,60) sl.TextSize=8 sl.Font=Enum.Font.Gotham sl.TextXAlignment=Enum.TextXAlignment.Center sl.ZIndex=49 sl.Parent=btn
	return btn
end
local BtnEN = MakeLangBtn("EN","English","Continue in English",16)
local BtnRU = MakeLangBtn("RU","Русский","Продолжить на русском",164)

local ToggleBtn = MakeBtn({
	Size=UDim2.new(0,44,0,44), Position=UDim2.new(0,14,0.5,-22),
	BackgroundColor3=Color3.fromRGB(8,8,8), Text="", ZIndex=20, Visible=false,
}, GUI)
Corner(10,ToggleBtn) Stroke(Color3.fromRGB(60,60,60),1.5,ToggleBtn)
local _tst=Instance.new("TextLabel") _tst.Size=UDim2.new(1,0,1,0) _tst.BackgroundTransparency=1 _tst.Text="ST" _tst.TextColor3=Color3.fromRGB(255,255,255) _tst.TextSize=15 _tst.Font=Enum.Font.GothamBold _tst.TextXAlignment=Enum.TextXAlignment.Center _tst.ZIndex=21 _tst.Parent=ToggleBtn

local Win = Instance.new("Frame")
Win.Name="Win" Win.Size=UDim2.new(0,580,0,0)
Win.Position=UDim2.new(0.5,-290,0.5,-230)
Win.BackgroundColor3=Color3.fromRGB(7,7,7) Win.BorderSizePixel=0
Win.Active=true Win.Draggable=true Win.ClipsDescendants=true
Win.ZIndex=5 Win.Visible=false Win.Parent=GUI
Corner(14,Win) Stroke(Color3.fromRGB(42,42,42),1,Win)

local StarCanvas = Instance.new("Frame")
StarCanvas.Size=UDim2.new(1,0,1,0) StarCanvas.BackgroundTransparency=1
StarCanvas.BorderSizePixel=0 StarCanvas.ZIndex=1 StarCanvas.Parent=Win
for i,pos in ipairs({
	{0.05,0.1},{0.14,0.55},{0.22,0.08},{0.3,0.72},{0.38,0.28},
	{0.45,0.9},{0.52,0.18},{0.6,0.6},{0.67,0.38},{0.75,0.82},
	{0.82,0.14},{0.9,0.68},{0.95,0.42},{0.08,0.78},{0.5,0.5},{0.78,0.95}
}) do
	local d=Instance.new("Frame")
	d.Size=UDim2.new(0,(i%5==0) and 2 or 1,0,(i%5==0) and 2 or 1)
	d.Position=UDim2.new(pos[1],0,pos[2],0) d.BackgroundColor3=Color3.fromRGB(255,255,255)
	d.BackgroundTransparency=0.7 d.BorderSizePixel=0 d.ZIndex=1 d.Parent=StarCanvas Corner(1,d)
	task.spawn(function()
		while GUI.Parent do
			TweenService:Create(d,TweenInfo.new(math.random(20,45)/10,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=math.random(3,9)/10}):Play()
			task.wait(math.random(10,28)/10)
		end
	end)
end

local Sidebar = Instance.new("Frame")
Sidebar.Size=UDim2.new(0,130,1,0) Sidebar.BackgroundColor3=Color3.fromRGB(5,5,5)
Sidebar.BorderSizePixel=0 Sidebar.ZIndex=6 Sidebar.Parent=Win Corner(14,Sidebar)
local _sbf=Instance.new("Frame") _sbf.Size=UDim2.new(0,14,1,0) _sbf.Position=UDim2.new(1,-14,0,0) _sbf.BackgroundColor3=Color3.fromRGB(5,5,5) _sbf.BorderSizePixel=0 _sbf.ZIndex=6 _sbf.Parent=Sidebar
local _sbd=Instance.new("Frame") _sbd.Size=UDim2.new(0,1,0.8,0) _sbd.Position=UDim2.new(1,0,0.1,0) _sbd.BackgroundColor3=Color3.fromRGB(26,26,26) _sbd.BorderSizePixel=0 _sbd.ZIndex=7 _sbd.Parent=Sidebar

local LogoF = Instance.new("Frame")
LogoF.Size=UDim2.new(0,50,0,50) LogoF.Position=UDim2.new(0.5,-25,0,12)
LogoF.BackgroundColor3=Color3.fromRGB(12,12,12) LogoF.BorderSizePixel=0 LogoF.ZIndex=8 LogoF.Parent=Sidebar
Corner(12,LogoF) Stroke(Color3.fromRGB(48,48,48),1.5,LogoF)
local _sst=Instance.new("TextLabel") _sst.Size=UDim2.new(1,0,1,0) _sst.BackgroundTransparency=1 _sst.Text="ST" _sst.TextColor3=Color3.fromRGB(255,255,255) _sst.TextSize=19 _sst.Font=Enum.Font.GothamBold _sst.TextXAlignment=Enum.TextXAlignment.Center _sst.ZIndex=9 _sst.Parent=LogoF
MakeTxt({Size=UDim2.new(1,-8,0,17),Position=UDim2.new(0,4,0,68),Text="Star Hub",TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},Sidebar)
MakeTxt({Size=UDim2.new(1,-8,0,12),Position=UDim2.new(0,4,0,86),Text="v"..SCRIPT_VERSION,TextColor3=Color3.fromRGB(65,65,65),TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},Sidebar)
local _sdh=Instance.new("Frame") _sdh.Size=UDim2.new(1,-24,0,1) _sdh.Position=UDim2.new(0,12,0,106) _sdh.BackgroundColor3=Color3.fromRGB(24,24,24) _sdh.BorderSizePixel=0 _sdh.ZIndex=7 _sdh.Parent=Sidebar

local function MakeSideTab(txt,y,active)
	local b=MakeBtn({
		Size=UDim2.new(1,-16,0,30), Position=UDim2.new(0,8,0,y),
		BackgroundColor3=active and Color3.fromRGB(17,17,17) or Color3.fromRGB(5,5,5),
		Text=txt, TextColor3=active and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80),
		TextSize=12, Font=Enum.Font.GothamBold, ZIndex=9,
	}, Sidebar)
	Corner(8,b) if active then Stroke(Color3.fromRGB(48,48,48),1,b) end return b
end
local SideTabMain = MakeSideTab(T("main"),116,true)
local SideTabFarm = MakeSideTab(T("farm"),152,false)
local SideTabTrial = MakeSideTab(T("trial"),188,false)
local SideTabInfo = MakeSideTab(T("info"),224,false)
local CloseBtn = MakeBtn({
	Size=UDim2.new(1,-16,0,26), Position=UDim2.new(0,8,1,-36),
	BackgroundColor3=Color3.fromRGB(12,12,12), Text=T("close"),
	TextColor3=Color3.fromRGB(115,115,115), TextSize=11,
	Font=Enum.Font.GothamBold, ZIndex=9,
}, Sidebar)
Corner(7,CloseBtn) Stroke(Color3.fromRGB(33,33,33),1,CloseBtn)

local CW = 580-142-16
local ContentArea = Instance.new("Frame")
ContentArea.Size=UDim2.new(1,-142,1,-16) ContentArea.Position=UDim2.new(0,138,0,8)
ContentArea.BackgroundTransparency=1 ContentArea.BorderSizePixel=0
ContentArea.ClipsDescendants=true ContentArea.ZIndex=6 ContentArea.Parent=Win

local MainPage = Instance.new("Frame") MainPage.Size=UDim2.new(1,0,1,0) MainPage.BackgroundTransparency=1 MainPage.BorderSizePixel=0 MainPage.ZIndex=6 MainPage.Parent=ContentArea
local FarmPage = Instance.new("Frame") FarmPage.Size=UDim2.new(1,0,1,0) FarmPage.BackgroundTransparency=1 FarmPage.BorderSizePixel=0 FarmPage.ZIndex=6 FarmPage.Visible=false FarmPage.Parent=ContentArea
local InfoPage = Instance.new("Frame") InfoPage.Size=UDim2.new(1,0,1,0) InfoPage.BackgroundTransparency=1 InfoPage.BorderSizePixel=0 InfoPage.ZIndex=6 InfoPage.Visible=false InfoPage.Parent=ContentArea
local TrialPage = Instance.new("Frame") TrialPage.Size=UDim2.new(1,0,1,0) TrialPage.BackgroundTransparency=1 TrialPage.BorderSizePixel=0 TrialPage.ZIndex=6 TrialPage.Visible=false TrialPage.Parent=ContentArea

local LogCard = MakeCard(MainPage,0,50)
MakeTxt({Size=UDim2.new(1,-28,0,12),Position=UDim2.new(0,12,0,4),Text=T("logs"),TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},LogCard)
local LogCont = Instance.new("Frame") LogCont.Size=UDim2.new(1,-24,0,30) LogCont.Position=UDim2.new(0,12,0,16) LogCont.BackgroundTransparency=1 LogCont.BorderSizePixel=0 LogCont.ClipsDescendants=true LogCont.ZIndex=8 LogCont.Parent=LogCard
local LogLayout = Instance.new("UIListLayout") LogLayout.SortOrder=Enum.SortOrder.LayoutOrder LogLayout.Padding=UDim.new(0,1) LogLayout.Parent=LogCont

local function AddLog(msg)
	local l=Instance.new("TextLabel") l.Size=UDim2.new(1,0,0,9) l.BackgroundTransparency=1
	l.Text="["..os.date("%H:%M:%S").."] "..msg l.TextColor3=Color3.fromRGB(100,100,100)
	l.TextSize=9 l.Font=Enum.Font.Code l.TextXAlignment=Enum.TextXAlignment.Left
	l.ZIndex=9 l.LayoutOrder=#LogLines+1 l.Parent=LogCont
	table.insert(LogLines,l)
	if #LogLines>MAX_LOGS then LogLines[1]:Destroy() table.remove(LogLines,1) end
end

local function GetHRP()
	local chr=LocalPlayer.Character
	return chr and chr:FindFirstChild("HumanoidRootPart")
end

local function SetY(y)
	local hrp=GetHRP()
	if hrp then hrp.CFrame=CFrame.new(hrp.Position.X, y, hrp.Position.Z) end
end

local function LerpToPos(hrp,target,steps,dt)
	local start=hrp.Position
	for i=1,steps do
		if not hrp or not hrp.Parent then break end
		hrp.CFrame=CFrame.new(start:Lerp(target,i/steps))
		task.wait(dt)
	end
end

local flyRefs = MakeToggle(MainPage,58,T("fly"),T("flyDesc"),function(val)
	FlyEnabled=val
	if val then
		AddLog("Fly ON")
		nowe=true
		local chr=LocalPlayer.Character if not chr then return end
		local hum=chr:FindFirstChildOfClass("Humanoid") if not hum then return end
		local sts={
			Enum.HumanoidStateType.Climbing,Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.Flying,Enum.HumanoidStateType.Freefall,
			Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
			Enum.HumanoidStateType.Landed,Enum.HumanoidStateType.Physics,
			Enum.HumanoidStateType.PlatformStanding,Enum.HumanoidStateType.Ragdoll,
			Enum.HumanoidStateType.Running,Enum.HumanoidStateType.RunningNoPhysics,
			Enum.HumanoidStateType.Seated,Enum.HumanoidStateType.StrafingNoPhysics,
			Enum.HumanoidStateType.Swimming
		}
		for _,s in ipairs(sts) do hum:SetStateEnabled(s,false) end
		hum:ChangeState(Enum.HumanoidStateType.Swimming)
		pcall(function() chr.Animate.Disabled=true end)
		for _,v in next,hum:GetPlayingAnimationTracks() do pcall(function() v:AdjustSpeed(0) end) end
		tpwalking=true
		for i=1,math.max(1,math.floor(FlySpeed/10)) do
			task.spawn(function()
				while tpwalking do
					RunService.Heartbeat:Wait()
					local c=LocalPlayer.Character local h=c and c:FindFirstChildOfClass("Humanoid")
					if c and h and h.Parent and h.MoveDirection.Magnitude>0 then c:TranslateBy(h.MoveDirection) end
				end
			end)
		end
		local isR6 = hum.RigType==Enum.HumanoidRigType.R6
		local torso = isR6 and chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
		if not torso then return end
		local bg=Instance.new("BodyGyro",torso) bg.P=9e4 bg.maxTorque=Vector3.new(9e9,9e9,9e9) bg.cframe=torso.CFrame
		local bv=Instance.new("BodyVelocity",torso) bv.velocity=Vector3.new(0,0.1,0) bv.maxForce=Vector3.new(9e9,9e9,9e9)
		hum.PlatformStand=true
		local ctrl={f=0,b=0,l=0,r=0} local lc={f=0,b=0,l=0,r=0} local spd=0
		local ic=UserInputService.InputBegan:Connect(function(i,gp)
			if gp then return end
			if i.KeyCode==Enum.KeyCode.W then ctrl.f=1 elseif i.KeyCode==Enum.KeyCode.S then ctrl.b=-1
			elseif i.KeyCode==Enum.KeyCode.A then ctrl.l=-1 elseif i.KeyCode==Enum.KeyCode.D then ctrl.r=1 end
		end)
		local ie=UserInputService.InputEnded:Connect(function(i)
			if i.KeyCode==Enum.KeyCode.W then ctrl.f=0 elseif i.KeyCode==Enum.KeyCode.S then ctrl.b=0
			elseif i.KeyCode==Enum.KeyCode.A then ctrl.l=0 elseif i.KeyCode==Enum.KeyCode.D then ctrl.r=0 end
		end)
		task.spawn(function()
			while nowe do
				RunService.RenderStepped:Wait()
				local ms=FlySpeed
				if ctrl.l+ctrl.r~=0 or ctrl.f+ctrl.b~=0 then spd=math.min(spd+0.5+spd/ms,ms)
				elseif spd~=0 then spd=math.max(spd-1,0) end
				local cam=game.Workspace.CurrentCamera.CoordinateFrame
				if (ctrl.l+ctrl.r)~=0 or (ctrl.f+ctrl.b)~=0 then
					bv.velocity=((cam.LookVector*(ctrl.f+ctrl.b))+((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*0.2,0).p)-cam.p))*spd
					lc={f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
				elseif spd~=0 then
					bv.velocity=((cam.LookVector*(lc.f+lc.b))+((cam*CFrame.new(lc.l+lc.r,(lc.f+lc.b)*0.2,0).p)-cam.p))*spd
				else bv.velocity=Vector3.new(0,0,0) end
				bg.cframe=cam*CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/ms),0,0)
			end
			ctrl={f=0,b=0,l=0,r=0} spd=0 bg:Destroy() bv:Destroy() ic:Disconnect() ie:Disconnect()
		end)
	else
		nowe=false tpwalking=false
		AddLog("Fly OFF")
		local chr=LocalPlayer.Character if not chr then return end
		local hum=chr:FindFirstChildOfClass("Humanoid") if not hum then return end
		local sts={
			Enum.HumanoidStateType.Climbing,Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.Flying,Enum.HumanoidStateType.Freefall,
			Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
			Enum.HumanoidStateType.Landed,Enum.HumanoidStateType.Physics,
			Enum.HumanoidStateType.PlatformStanding,Enum.HumanoidStateType.Ragdoll,
			Enum.HumanoidStateType.Running,Enum.HumanoidStateType.RunningNoPhysics,
			Enum.HumanoidStateType.Seated,Enum.HumanoidStateType.StrafingNoPhysics,
			Enum.HumanoidStateType.Swimming
		}
		for _,s in ipairs(sts) do hum:SetStateEnabled(s,true) end
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		hum.PlatformStand=false pcall(function() chr.Animate.Disabled=false end)
	end
end)

local FlySpeedCard = MakeCard(MainPage,126,42)
MakeTxt({Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,14,0,0),Text=T("flySpeed"),TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},FlySpeedCard)
local FlySpeedVal=MakeTxt({Size=UDim2.new(0.2,0,1,0),Position=UDim2.new(0.45,0,0,0),Text=tostring(FlySpeed),TextColor3=Color3.fromRGB(185,185,185),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},FlySpeedCard)
local FlyMinus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-78,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="−",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},FlySpeedCard) Corner(7,FlyMinus) Stroke(Color3.fromRGB(38,38,38),1,FlyMinus)
local FlyPlus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-38,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="+",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},FlySpeedCard) Corner(7,FlyPlus) Stroke(Color3.fromRGB(38,38,38),1,FlyPlus)

local FlyUDCard = MakeCard(MainPage,176,42)
MakeTxt({Size=UDim2.new(0.35,0,1,0),Position=UDim2.new(0,14,0,0),Text=T("vertical"),TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},FlyUDCard)
local FlyUp=MakeBtn({Size=UDim2.new(0,72,0,28),Position=UDim2.new(0.5,-78,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="▲ Up",TextColor3=Color3.fromRGB(200,200,200),TextSize=11,Font=Enum.Font.GothamBold,ZIndex=9},FlyUDCard) Corner(7,FlyUp) Stroke(Color3.fromRGB(38,38,38),1,FlyUp)
local FlyDown=MakeBtn({Size=UDim2.new(0,72,0,28),Position=UDim2.new(0.5,6,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="▼ Down",TextColor3=Color3.fromRGB(200,200,200),TextSize=11,Font=Enum.Font.GothamBold,ZIndex=9},FlyUDCard) Corner(7,FlyDown) Stroke(Color3.fromRGB(38,38,38),1,FlyDown)



local antiRefs = MakeToggle(MainPage,226,T("antidetect"),T("antidetectDesc"),function(val)
	AntiDetectEnabled=val AddLog(val and "AntiDetect ON" or "AntiDetect OFF")
end)

-- Protection engine starts automatically with AutoFarm
local function StartProtectionEngine()
	if AIEnabled then return end
	AIEnabled = true
	AIInit()
	AISession = 0
	AIHistory = {}
	AIAdaptScore = 0
	AIGenerateDelays()
	AIGenerateStepTimings()
	AIAdaptLoop()
end

local function StopProtectionEngine()
	AIEnabled = false
	AIPatterns = {}
	AIStepPatterns = {}
	AIMessages = {}
end

local speedRefs = MakeToggle(MainPage,294,T("speedgod"),T("speedgodDesc"),function(val)
	SpeedGodEnabled=val
	local chr=LocalPlayer.Character
	local hum=chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		if val then
			hum.WalkSpeed=SpeedGodValue
			AddLog("SpeedGod ON - "..SpeedGodValue)
		else
			hum.WalkSpeed=16
			AddLog("SpeedGod OFF")
		end
	end
end)

local SpeedCard = MakeCard(MainPage,362,42)
MakeTxt({Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,14,0,0),Text=T("speedgod"),TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},SpeedCard)
local SpeedValLbl=MakeTxt({Size=UDim2.new(0.22,0,1,0),Position=UDim2.new(0.45,0,0,0),Text=tostring(SpeedGodValue),TextColor3=Color3.fromRGB(185,185,185),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},SpeedCard)
local SpeedMinus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-78,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="−",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},SpeedCard) Corner(7,SpeedMinus) Stroke(Color3.fromRGB(38,38,38),1,SpeedMinus)
local SpeedPlus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-38,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="+",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},SpeedCard) Corner(7,SpeedPlus) Stroke(Color3.fromRGB(38,38,38),1,SpeedPlus)

SpeedMinus.MouseButton1Click:Connect(function()
	SpeedGodValue=math.max(1,SpeedGodValue-10)
	SpeedValLbl.Text=tostring(SpeedGodValue)
	if SpeedGodEnabled then
		local chr=LocalPlayer.Character local hum=chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed=SpeedGodValue end
	end
end)
SpeedPlus.MouseButton1Click:Connect(function()
	SpeedGodValue=SpeedGodValue+10
	SpeedValLbl.Text=tostring(SpeedGodValue)
	if SpeedGodEnabled then
		local chr=LocalPlayer.Character local hum=chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed=SpeedGodValue end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(chr)
	task.wait(0.5)
	if SpeedGodEnabled then
		local hum=chr:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed=SpeedGodValue end
	end
end)

RunService.Heartbeat:Connect(function()
	if not SpeedGodEnabled then return end
	local chr=LocalPlayer.Character
	local hum=chr and chr:FindFirstChildOfClass("Humanoid")
	if hum and hum.WalkSpeed ~= SpeedGodValue then
		hum.WalkSpeed = SpeedGodValue
	end
end)

local GodModeLoaded = false
local godRefs = MakeToggle(MainPage,362,T("godmode"),T("godmodeDesc"),function(val)
	if val then
		if not GodModeLoaded then
			AddLog("God Mode: загрузка...")
			local ok, err = pcall(function()
				local fn = loadstring(game:HttpGet("https://pastebin.com/raw/Ai5WqH8N", true))
				if fn then fn() end
			end)
			if ok then
				GodModeLoaded = true
				AddLog("God Mode: активен")
			else
				AddLog("God Mode: ошибка загрузки")
			end
		else
			AddLog("God Mode: уже активен")
		end
	else
		AddLog("God Mode: выключить через сам скрипт")
	end
end)

FlyMinus.MouseButton1Click:Connect(function() FlySpeed=math.max(5,FlySpeed-5) FlySpeedVal.Text=tostring(FlySpeed) end)
FlyPlus.MouseButton1Click:Connect(function() FlySpeed=math.min(500,FlySpeed+5) FlySpeedVal.Text=tostring(FlySpeed) end)
FlyUp.MouseButton1Down:Connect(function() flyUpHeld=true end) FlyUp.MouseButton1Up:Connect(function() flyUpHeld=false end)
FlyDown.MouseButton1Down:Connect(function() flyDownHeld=true end) FlyDown.MouseButton1Up:Connect(function() flyDownHeld=false end)

local function GetActiveBrainrots()
	local found={}
	local ws=game:GetService("Workspace")
	local folder=ws:FindFirstChild("ActiveBrainrots")
	if not folder then AddLog("ActiveBrainrots not found") return found end
	for _,rarityFolder in ipairs(folder:GetChildren()) do
		if SelectedRarities[rarityFolder.Name] then
			for _,obj in ipairs(rarityFolder:GetChildren()) do
				local pos=nil
				local prompt=nil
				pcall(function()
					if obj:IsA("BasePart") then pos=obj.Position
					elseif obj:IsA("Model") then
						local root=obj:FindFirstChildWhichIsA("BasePart")
						if root then pos=root.Position end
					end
					prompt=obj:FindFirstChildOfClass("ProximityPrompt",true)
				end)
				if pos then
					table.insert(found,{obj=obj, pos=pos, rarity=rarityFolder.Name, prompt=prompt})
				end
			end
		end
	end
	return found
end

local function FirePrompt(prompt)
	if fireproximityprompt then
		fireproximityprompt(prompt)
	else
		local hd=prompt.HoldDuration if hd<=0 then hd=1.5 end
		prompt:InputHoldBegin()
		task.wait(hd+0.2)
		prompt:InputHoldEnd()
	end
end

local FarmPlatform  = nil
local NoclipConn    = nil
local NoclipConn2   = nil
local NoclipActive  = false
-- Anti-AC noclip: randomize timing to avoid detection
local NoclipAccum   = 0
local NoclipInterval = 0.0

local function EnableNoclip()
	if NoclipActive then return end
	NoclipActive = true
	NoclipInterval = 0.008 + math.random(0,4)/1000

	-- Primary: Stepped connection
	if NoclipConn then NoclipConn:Disconnect() end
	NoclipConn = RunService.Stepped:Connect(function()
		if not NoclipActive then return end
		local chr = LocalPlayer.Character
		if not chr then return end
		for _, p in ipairs(chr:GetDescendants()) do
			if p:IsA("BasePart") then
				pcall(function()
					if p.CanCollide then
						p.CanCollide = false
					end
					-- Also clear via sethiddenproperty if available
					if sethiddenproperty then
						sethiddenproperty(p, "CanCollide", false)
					end
				end)
			end
		end
	end)

	-- Secondary: Heartbeat backup (catches frames Stepped misses)
	if NoclipConn2 then NoclipConn2:Disconnect() end
	NoclipConn2 = RunService.Heartbeat:Connect(function(dt)
		if not NoclipActive then return end
		NoclipAccum = NoclipAccum + dt
		NoclipInterval = 0.008 + math.random(0,3)/1000
		if NoclipAccum < NoclipInterval then return end
		NoclipAccum = 0
		local chr = LocalPlayer.Character
		if not chr then return end
		local hrp = chr:FindFirstChild("HumanoidRootPart")
		if hrp and hrp.CanCollide then
			pcall(function() hrp.CanCollide = false end)
		end
	end)
end

local function DisableNoclip()
	NoclipActive = false
	if NoclipConn  then NoclipConn:Disconnect()  NoclipConn=nil  end
	if NoclipConn2 then NoclipConn2:Disconnect() NoclipConn2=nil end
	local chr = LocalPlayer.Character
	if not chr then return end
	-- Restore CanCollide except HumanoidRootPart (keep false for safety)
	for _, p in ipairs(chr:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			pcall(function() p.CanCollide = true end)
		end
	end
end

-- Persistent noclip during movement: called per-step in farm
local function NoclipStep()
	if not NoclipActive then return end
	local chr = LocalPlayer.Character
	if not chr then return end
	for _, p in ipairs(chr:GetChildren()) do
		if p:IsA("BasePart") then
			pcall(function() p.CanCollide = false end)
		end
	end
end

local function CreatePlatform(pos)
	if FarmPlatform and FarmPlatform.Parent then FarmPlatform:Destroy() end
	local plat = Instance.new("Part")
	plat.Name = "FarmPlatform"
	plat.Size = Vector3.new(6, 0.5, 6)
	plat.Anchored = true
	plat.CanCollide = true
	plat.CanTouch = false
	plat.Transparency = 0.5
	plat.BrickColor = BrickColor.new("Bright blue")
	plat.Material = Enum.Material.Neon
	plat.CFrame = CFrame.new(pos.X, SAFE_Y - 1.5, pos.Z)
	plat.Parent = game:GetService("Workspace")
	FarmPlatform = plat
	return plat
end

local function DestroyPlatform()
	if FarmPlatform and FarmPlatform.Parent then
		FarmPlatform:Destroy()
		FarmPlatform = nil
	end
end

local function SafeDropToY(targetY)
	local hrp = GetHRP()
	if not hrp then return end
	EnableNoclip()
	AddLog("Опускаюсь...")
	local startY = hrp.Position.Y
	local steps = math.max(10, math.abs(startY - targetY) * 4)
	for i = 1, steps do
		if not AutoFarmEnabled then break end
		hrp = GetHRP()
		if not hrp then break end
		local alpha = i / steps
		local newY = startY + (targetY - startY) * alpha
		hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
		task.wait(0.02)
	end
	hrp = GetHRP()
	if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) end
	DisableNoclip()
	AddLog("Готово")
	local pos = hrp and hrp.Position or Vector3.new(HOME_X, targetY, HOME_Z)
	CreatePlatform(pos)
	
end

local farmRefs = MakeToggle(FarmPage,0,T("autoFarm"),T("autoFarmDesc"),function(val)
	AutoFarmEnabled=val
	if val then
		AddLog("AutoFarm ON")
		StartProtectionEngine()

		local GodConn = nil
		local GodDiedConn = nil
		local GodHealthConn = nil

		local function ProtectHumanoid(hum)
			pcall(function()
				hum.MaxHealth = math.huge
				hum.Health    = math.huge
			end)
			pcall(function()
				sethiddenproperty(hum, "Health", math.huge)
				sethiddenproperty(hum, "MaxHealth", math.huge)
			end)
			pcall(function()
				local mt = getrawmetatable(hum)
				local old_ni = mt.__newindex
				setreadonly(mt, false)
				mt.__newindex = function(t, k, v)
					if (k=="Health" or k=="MaxHealth") and type(v)=="number" and v < math.huge then
						return old_ni(t, k, math.huge)
					end
					return old_ni(t, k, v)
				end
				setreadonly(mt, true)
			end)
			for _, st in ipairs({
				Enum.HumanoidStateType.Dead,
				Enum.HumanoidStateType.FallingDown,
				Enum.HumanoidStateType.Ragdoll,
			}) do
				pcall(function() hum:SetStateEnabled(st, false) end)
			end
			pcall(function()
				hum.BreakJointsOnDeath = false
			end)
			if GodHealthConn then GodHealthConn:Disconnect() end
			GodHealthConn = hum.HealthChanged:Connect(function()
				if not AutoFarmEnabled then return end
				task.defer(function()
					if hum and hum.Parent then
						pcall(function()
							hum.MaxHealth = math.huge
							hum.Health    = math.huge
						end)
						pcall(function()
							sethiddenproperty(hum,"Health",math.huge)
						end)
					end
				end)
			end)
			if GodDiedConn then GodDiedConn:Disconnect() end
			GodDiedConn = hum.Died:Connect(function()
				if not AutoFarmEnabled then return end
				pcall(function()
					hum.MaxHealth = math.huge
					hum.Health    = math.huge
				end)
				task.wait(0.04)
				local chr2 = LocalPlayer.Character
				local hum2 = chr2 and chr2:FindFirstChildOfClass("Humanoid")
				if hum2 then
					pcall(function()
						hum2.MaxHealth = math.huge
						hum2.Health    = math.huge
					end)
					ProtectHumanoid(hum2)
				end
			end)
		end

		local function EnableServerGodMode()
			local chr=LocalPlayer.Character
			if not chr then return end
			local hum=chr:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			ProtectHumanoid(hum)
			if GodConn then GodConn:Disconnect() end
			GodConn = RunService.Heartbeat:Connect(function()
				if not AutoFarmEnabled then
					if GodConn then GodConn:Disconnect() GodConn=nil end
					if GodHealthConn then GodHealthConn:Disconnect() GodHealthConn=nil end
					if GodDiedConn then GodDiedConn:Disconnect() GodDiedConn=nil end
					return
				end
				local c = LocalPlayer.Character
				local h = c and c:FindFirstChildOfClass("Humanoid")
				if h then
					pcall(function()
						if h.MaxHealth ~= math.huge then
							h.MaxHealth = math.huge
							sethiddenproperty(h,"MaxHealth",math.huge)
						end
						if h.Health ~= math.huge then
							h.Health = math.huge
							sethiddenproperty(h,"Health",math.huge)
						end
					end)
					for _, st in ipairs({
						Enum.HumanoidStateType.Dead,
						Enum.HumanoidStateType.Ragdoll,
					}) do
						pcall(function() h:SetStateEnabled(st,false) end)
					end
				end
			end)
			AddLog("Защита активна")
		end

		task.spawn(function()
			EnableNoclip()
			SafeDropToY(SAFE_Y)
			task.wait(0.5)
			EnableServerGodMode()
			AddLog("Начинаю фарм")
			local chr0=LocalPlayer.Character
			local hrp0=chr0 and chr0:FindFirstChild("HumanoidRootPart")
			if hrp0 then
				local hum0=chr0:FindFirstChildOfClass("Humanoid")
				if hum0 then
					hum0.PlatformStand=true
					hum0.AutoRotate=false
					hum0.WalkSpeed=0
					hum0.JumpPower=0
				end
				local bpos=Instance.new("BodyPosition")
				bpos.MaxForce=Vector3.new(1e5,1e5,1e5)
				bpos.D=500 bpos.P=10000
				bpos.Position=hrp0.Position
				bpos.Name="FarmBodyLock"
				bpos.Parent=hrp0
				local bgyro=Instance.new("BodyGyro")
				bgyro.MaxTorque=Vector3.new(1e5,1e5,1e5)
				bgyro.D=500 bgyro.P=10000
				bgyro.CFrame=hrp0.CFrame
				bgyro.Name="FarmBodyGyro"
				bgyro.Parent=hrp0
			end
			while AutoFarmEnabled do
				local hrp=GetHRP()
				if hrp then
					if math.abs(hrp.Position.Y - SAFE_Y) > 0.3 then
						hrp.CFrame=CFrame.new(hrp.Position.X, SAFE_Y, hrp.Position.Z)
					end
					if FarmPlatform and FarmPlatform.Parent then
						FarmPlatform.CFrame = CFrame.new(hrp.Position.X, SAFE_Y-1.5, hrp.Position.Z)
					end
					local bp=hrp:FindFirstChild("FarmBodyLock")
					if bp then bp.Position=hrp.Position end
				end
				-- FlyTo: same logic as Trial
				local function FlyTo(hrp, toPos)
					local sPos = hrp.Position
					local d2d = (Vector3.new(toPos.X,0,toPos.Z)-Vector3.new(sPos.X,0,sPos.Z)).Magnitude
					local steps = math.max(5, math.floor(d2d * 0.30))
					local st2 = 0
					local pi2 = 0.09+math.random(0,4)/100
					local ms2 = math.random(3,7)
					for i=1,steps do
						if not AutoFarmEnabled then return false end
						hrp=GetHRP() if not hrp then return false end
						local a=i/steps
						local np=Vector3.new(sPos.X+(toPos.X-sPos.X)*a,SAFE_Y,sPos.Z+(toPos.Z-sPos.Z)*a)
						hrp.CFrame=CFrame.new(np)
						local bp=hrp:FindFirstChild("FarmBodyLock")
						if bp then bp.Position=np end
						pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero end)
						NoclipStep()
						if i==ms2 then task.wait(0.04+math.random(0,4)/100) ms2=i+math.random(4,9) end
						local s=AIEnabled and GetAIStepTime() or (0.007+math.random(0,2)/1000)
						st2=st2+s
						if st2>=pi2 then st2=0 pi2=0.09+math.random(0,4)/100 task.wait(0.032+math.random(0,3)/100)
						else task.wait(s) end
					end
					return true
				end

				local function GoHome()
					local h=GetHRP() if not h then return end
					FlyTo(h,Vector3.new(HOME_X,SAFE_Y,HOME_Z))
					h=GetHRP()
					if h then
						h.CFrame=CFrame.new(HOME_X,SAFE_Y,HOME_Z)
						local bp=h:FindFirstChild("FarmBodyLock")
						if bp then bp.Position=Vector3.new(HOME_X,SAFE_Y,HOME_Z) end
					end
				end

				local function GetPrompt(target)
					if target.prompt and target.prompt.Parent then return target.prompt end
					if target.obj and target.obj.Parent then
						for _,v in ipairs(target.obj:GetDescendants()) do
							if v:IsA("ProximityPrompt") then return v end
						end
					end
					return nil
				end

				local brainrots = GetActiveBrainrots()
				if #brainrots == 0 then
					AddLog("Нет брейнротов, жду...")
					task.wait(3)
				else
					local takenThisRun = 0
					local idx = 1
					while AutoFarmEnabled and takenThisRun < CarryCount do
						if idx > #brainrots then
							brainrots = GetActiveBrainrots()
							idx = 1
							if #brainrots == 0 then task.wait(3) break end
						end
						local target = brainrots[idx]
						idx = idx + 1
						-- 5 attempts same as Trial
						local picked = false
						for attempt = 1, 5 do
							if not AutoFarmEnabled then break end
							if not target.obj or not target.obj.Parent then
								local fresh = GetActiveBrainrots()
								local found = false
								for _,fb in ipairs(fresh) do
									if fb.rarity==target.rarity and fb.obj and fb.obj.Parent then
										target=fb found=true break
									end
								end
								if not found then task.wait(0.8) continue end
							end
							local h2=GetHRP() if not h2 then break end
							local arrived=FlyTo(h2,Vector3.new(target.pos.X,SAFE_Y,target.pos.Z))
							if not arrived then break end
							task.wait(0.1)
							if not target.obj or not target.obj.Parent then task.wait(0.5) continue end
							local prompt=GetPrompt(target)
							if prompt and prompt.Parent then
								FirePrompt(prompt)
								task.wait(0.35)
								picked=true
								break
							end
							task.wait(0.4)
						end
						if picked then
							FarmCount+=1
							takenThisRun+=1
							if takenThisRun < CarryCount then
								local delay=AIEnabled and GetAIDelay() or (FarmDelay+math.random(2,8)/10)
								if AntiDetectEnabled then delay=math.max(1.2,delay*(0.90+math.random(0,20)/100)) end
								task.wait(delay)
							end
						end
					end
					GoHome()
					task.wait(0.2+math.random(0,3)/10)
				end
			end
		end)
	else
		StopProtectionEngine()
		AddLog("AutoFarm OFF")
		DisableNoclip()
		DestroyPlatform()
		local chr=LocalPlayer.Character
		if chr then
			local hum=chr:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.PlatformStand=false
				hum.AutoRotate=true
				hum.WalkSpeed=SpeedGodEnabled and SpeedGodValue or 16
				hum.JumpPower=50
				pcall(function()
					hum.MaxHealth=100
					hum.Health=100
				end)
			end
			local hrp=chr:FindFirstChild("HumanoidRootPart")
			if hrp then
				local bp=hrp:FindFirstChild("FarmBodyLock")
				if bp then bp:Destroy() end
				local bg=hrp:FindFirstChild("FarmBodyGyro")
				if bg then bg:Destroy() end
			end
		end
		if GodHealthConn then pcall(function() GodHealthConn:Disconnect() end) end
		if GodDiedConn   then pcall(function() GodDiedConn:Disconnect() end) end
		AddLog("Server GodMode OFF")
	end
end)


local CarryCard = MakeCard(FarmPage,68,62)
MakeTxt({Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,14,0,0),Text="Carry per run",TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},CarryCard)
local CarryValLbl=MakeTxt({Size=UDim2.new(0.2,0,1,0),Position=UDim2.new(0.45,0,0,0),Text="1 / 6",TextColor3=Color3.fromRGB(185,185,185),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},CarryCard)
MakeTxt({Size=UDim2.new(0.3,0,0,14),Position=UDim2.new(0,14,0,44),Text="max 6 (Carry upgrade)",TextColor3=Color3.fromRGB(55,55,55),TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},CarryCard)
local CarryMinus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-78,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="−",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},CarryCard) Corner(7,CarryMinus) Stroke(Color3.fromRGB(38,38,38),1,CarryMinus)
local CarryPlus=MakeBtn({Size=UDim2.new(0,32,0,28),Position=UDim2.new(1,-38,0.5,-14),BackgroundColor3=Color3.fromRGB(16,16,16),Text="+",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,Font=Enum.Font.GothamBold,ZIndex=9},CarryCard) Corner(7,CarryPlus) Stroke(Color3.fromRGB(38,38,38),1,CarryPlus)
CarryMinus.MouseButton1Click:Connect(function()
	CarryCount=math.max(1,CarryCount-1)
	CarryValLbl.Text=CarryCount.." / 6"
end)
CarryPlus.MouseButton1Click:Connect(function()
	CarryCount=math.min(6,CarryCount+1)
	CarryValLbl.Text=CarryCount.." / 6"
end)

local RarityCard = MakeCard(FarmPage,138,112)
MakeTxt({Size=UDim2.new(1,-28,0,13),Position=UDim2.new(0,12,0,4),Text=T("rarityFilter"),TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},RarityCard)
local cols=4
for i,rarity in ipairs(RARITIES) do
	local col=(i-1)%cols local row=math.floor((i-1)/cols)
	local bW=math.floor((CW-28-(cols-1)*4)/cols)
	local btn=MakeBtn({
		Size=UDim2.new(0,bW,0,19),
		Position=UDim2.new(0,12+col*(bW+4),0,20+row*24),
		BackgroundColor3=SelectedRarities[rarity] and Color3.fromRGB(24,24,24) or Color3.fromRGB(13,13,13),
		Text=rarity,
		TextColor3=SelectedRarities[rarity] and Color3.fromRGB(210,210,210) or Color3.fromRGB(60,60,60),
		TextSize=9, Font=Enum.Font.GothamBold, ZIndex=9,
	},RarityCard)
	Corner(5,btn)
	btn.MouseButton1Click:Connect(function()
		SelectedRarities[rarity]=not SelectedRarities[rarity]
		Tw(btn,0.15,{
			BackgroundColor3=SelectedRarities[rarity] and Color3.fromRGB(24,24,24) or Color3.fromRGB(13,13,13),
			TextColor3=SelectedRarities[rarity] and Color3.fromRGB(210,210,210) or Color3.fromRGB(60,60,60),
		})
	end)
end



-- ══════════════════════════════════════════
-- TRIAL PAGE UI + LOGIC
-- ══════════════════════════════════════════
local TOWER_POS = Vector3.new(4318.91, 6.95, -2.86)

-- Trial knowledge: rarity -> {expected_need, reward_rarity}
local TRIAL_INFO = {
	Common    = { need=10, reward="Uncommon/Rare" },
	Uncommon  = { need=10, reward="Rare/Epic" },
	Rare      = { need=10, reward="Epic/Legendary" },
	Epic      = { need=10, reward="Legendary/Mythical" },
	Legendary = { need=10, reward="Mythical/Cosmic" },
	Mythical  = { need=10, reward="Cosmic/Secret" },
	Cosmic    = { need=10, reward="Secret/Celestial" },
	Secret    = { need=10, reward="Celestial/Divine" },
	Celestial = { need=10, reward="Divine/Infinity" },
	Divine    = { need=15, reward="Infinity+" },
	Infinity  = { need=20, reward="???" },
}

local TrialStatusCard = Instance.new("Frame")
TrialStatusCard.Size=UDim2.new(1,0,0,54) TrialStatusCard.Position=UDim2.new(0,0,0,0)
TrialStatusCard.BackgroundColor3=Color3.fromRGB(11,11,11) TrialStatusCard.BorderSizePixel=0
TrialStatusCard.ZIndex=7 TrialStatusCard.Parent=TrialPage
Corner(10,TrialStatusCard) Stroke(Color3.fromRGB(30,30,30),1,TrialStatusCard)
MakeTxt({Size=UDim2.new(1,-14,0,12),Position=UDim2.new(0,12,0,4),Text="СТАТУС",TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialStatusCard)
local TrialStatusVal=MakeTxt({Size=UDim2.new(1,-14,0,18),Position=UDim2.new(0,12,0,22),Text="Выключен",TextColor3=Color3.fromRGB(120,120,120),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialStatusCard)

local TrialTaskCard = Instance.new("Frame")
TrialTaskCard.Size=UDim2.new(1,0,0,54) TrialTaskCard.Position=UDim2.new(0,0,0,62)
TrialTaskCard.BackgroundColor3=Color3.fromRGB(11,11,11) TrialTaskCard.BorderSizePixel=0
TrialTaskCard.ZIndex=7 TrialTaskCard.Parent=TrialPage
Corner(10,TrialTaskCard) Stroke(Color3.fromRGB(30,30,30),1,TrialTaskCard)
MakeTxt({Size=UDim2.new(1,-14,0,12),Position=UDim2.new(0,12,0,4),Text="ЗАДАНИЕ",TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialTaskCard)
local TrialTaskVal=MakeTxt({Size=UDim2.new(1,-14,0,18),Position=UDim2.new(0,12,0,22),Text="—",TextColor3=Color3.fromRGB(255,200,80),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialTaskCard)

local TrialProgressCard = Instance.new("Frame")
TrialProgressCard.Size=UDim2.new(1,0,0,54) TrialProgressCard.Position=UDim2.new(0,0,0,124)
TrialProgressCard.BackgroundColor3=Color3.fromRGB(11,11,11) TrialProgressCard.BorderSizePixel=0
TrialProgressCard.ZIndex=7 TrialProgressCard.Parent=TrialPage
Corner(10,TrialProgressCard) Stroke(Color3.fromRGB(30,30,30),1,TrialProgressCard)
MakeTxt({Size=UDim2.new(1,-14,0,12),Position=UDim2.new(0,12,0,4),Text="ПРОГРЕСС",TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialProgressCard)
local TrialProgressVal=MakeTxt({Size=UDim2.new(1,-14,0,18),Position=UDim2.new(0,12,0,22),Text="0 / 0",TextColor3=Color3.fromRGB(100,220,100),TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},TrialProgressCard)

-- CFG Cards
local cfgCard = Instance.new("Frame")
cfgCard.Size=UDim2.new(1,0,0,68) cfgCard.Position=UDim2.new(0,0,0,186)
cfgCard.BackgroundColor3=Color3.fromRGB(11,11,11) cfgCard.BorderSizePixel=0
cfgCard.ZIndex=7 cfgCard.Parent=TrialPage
Corner(10,cfgCard) Stroke(Color3.fromRGB(30,30,30),1,cfgCard)
MakeTxt({Size=UDim2.new(1,-14,0,12),Position=UDim2.new(0,12,0,4),Text="CFG",TextColor3=Color3.fromRGB(50,50,50),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},cfgCard)

-- AutoRestart toggle
local arBg=Instance.new("Frame") arBg.Size=UDim2.new(0,44,0,22) arBg.Position=UDim2.new(1,-54,0,20) arBg.BackgroundColor3=Color3.fromRGB(24,24,24) arBg.BorderSizePixel=0 arBg.ZIndex=9 arBg.Parent=cfgCard Corner(11,arBg) Stroke(Color3.fromRGB(46,46,46),1,arBg)
local arKnob=Instance.new("Frame") arKnob.Size=UDim2.new(0,16,0,16) arKnob.Position=UDim2.new(0,23,0.5,-8) arKnob.BackgroundColor3=Color3.fromRGB(255,255,255) arKnob.BorderSizePixel=0 arKnob.ZIndex=10 arKnob.Parent=arBg Corner(8,arKnob)
Tw(arBg,0,{BackgroundColor3=Color3.fromRGB(36,36,36)})
local arHit=MakeBtn({Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=11},arBg)
MakeTxt({Size=UDim2.new(0.7,0,0,22),Position=UDim2.new(0,12,0,20),Text="Auto Restart",TextColor3=Color3.fromRGB(180,180,180),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},cfgCard)
arHit.MouseButton1Click:Connect(function()
	TrialCFG.AutoRestart = not TrialCFG.AutoRestart
	if TrialCFG.AutoRestart then
		Tw(arBg,0.15,{BackgroundColor3=Color3.fromRGB(36,36,36)})
		Tw(arKnob,0.15,{Position=UDim2.new(0,23,0.5,-8),BackgroundColor3=Color3.fromRGB(255,255,255)})
	else
		Tw(arBg,0.15,{BackgroundColor3=Color3.fromRGB(20,20,20)})
		Tw(arKnob,0.15,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=Color3.fromRGB(88,88,88)})
	end
end)

-- Speed slider
local cfgSpeedLbl=MakeTxt({Size=UDim2.new(0.35,0,0,22),Position=UDim2.new(0,12,0,44),Text="Speed",TextColor3=Color3.fromRGB(180,180,180),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},cfgCard)
local cfgSpeedVal=MakeTxt({Size=UDim2.new(0.2,0,0,22),Position=UDim2.new(0.35,0,0,44),Text="Normal",TextColor3=Color3.fromRGB(185,185,185),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=8},cfgCard)
local cfgSm=MakeBtn({Size=UDim2.new(0,26,0,20),Position=UDim2.new(1,-62,0,46),BackgroundColor3=Color3.fromRGB(16,16,16),Text="-",TextColor3=Color3.fromRGB(200,200,200),TextSize=14,Font=Enum.Font.GothamBold,ZIndex=9},cfgCard) Corner(6,cfgSm) Stroke(Color3.fromRGB(38,38,38),1,cfgSm)
local cfgSp=MakeBtn({Size=UDim2.new(0,26,0,20),Position=UDim2.new(1,-30,0,46),BackgroundColor3=Color3.fromRGB(16,16,16),Text="+",TextColor3=Color3.fromRGB(200,200,200),TextSize=14,Font=Enum.Font.GothamBold,ZIndex=9},cfgCard) Corner(6,cfgSp) Stroke(Color3.fromRGB(38,38,38),1,cfgSp)
local speedLevels = {{v=0.20,n="Fast"},{v=0.28,n="Normal"},{v=0.40,n="Slow"},{v=0.55,n="Safe"}}
local speedIdx = 2
cfgSm.MouseButton1Click:Connect(function()
	speedIdx=math.max(1,speedIdx-1)
	TrialCFG.FlySpeed=speedLevels[speedIdx].v
	cfgSpeedVal.Text=speedLevels[speedIdx].n
end)
cfgSp.MouseButton1Click:Connect(function()
	speedIdx=math.min(#speedLevels,speedIdx+1)
	TrialCFG.FlySpeed=speedLevels[speedIdx].v
	cfgSpeedVal.Text=speedLevels[speedIdx].n
end)

local trialToggleCard = Instance.new("Frame")
trialToggleCard.Size=UDim2.new(1,0,0,60) trialToggleCard.Position=UDim2.new(0,0,0,262)
trialToggleCard.BackgroundColor3=Color3.fromRGB(11,11,11) trialToggleCard.BorderSizePixel=0
trialToggleCard.ZIndex=7 trialToggleCard.Parent=TrialPage
Corner(10,trialToggleCard) Stroke(Color3.fromRGB(30,30,30),1,trialToggleCard)
local trialTitleLbl=MakeTxt({Size=UDim2.new(1,-72,0,20),Position=UDim2.new(0,14,0,8),Text="Auto Trial",TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},trialToggleCard)
local trialDescLbl=MakeTxt({Size=UDim2.new(1,-72,0,13),Position=UDim2.new(0,14,0,31),Text="Авто фарм триала башни",TextColor3=Color3.fromRGB(68,68,68),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},trialToggleCard)
local trialTogBg=Instance.new("Frame") trialTogBg.Size=UDim2.new(0,44,0,24) trialTogBg.Position=UDim2.new(1,-54,0.5,-12) trialTogBg.BackgroundColor3=Color3.fromRGB(20,20,20) trialTogBg.BorderSizePixel=0 trialTogBg.ZIndex=9 trialTogBg.Parent=trialToggleCard Corner(12,trialTogBg) Stroke(Color3.fromRGB(46,46,46),1,trialTogBg)
local trialTogKnob=Instance.new("Frame") trialTogKnob.Size=UDim2.new(0,18,0,18) trialTogKnob.Position=UDim2.new(0,3,0.5,-9) trialTogKnob.BackgroundColor3=Color3.fromRGB(88,88,88) trialTogKnob.BorderSizePixel=0 trialTogKnob.ZIndex=10 trialTogKnob.Parent=trialTogBg Corner(9,trialTogKnob)
local trialTogHit=MakeBtn({Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=11},trialTogBg)

-- Trial CFG: overrides from settings
local TrialCFG = {
	AutoRestart = true,     -- restart trial after completion
	UseNoclip   = true,     -- use noclip when flying to brainrots
	FlySpeed    = 0.28,     -- steps per stud (lower = faster)
	WaitAfterTake = 0.3,    -- wait after picking brainrot
	WaitAtTower   = 0.4,    -- wait at tower before/after deliver
}

-- Cache for fast repeated reads
local TrialCache = {rarity=nil, need=0, done=0, lastRead=0}

local function ScanPlayerGui()
	local rarity, done, need = nil, 0, 0
	local pg = LocalPlayer.PlayerGui
	-- Scan all TextLabels for "Tower Trial: X" and "D/N" pattern
	for _, obj in ipairs(pg:GetDescendants()) do
		if obj:IsA("TextLabel") then
			local t = obj.Text or ""
			if not rarity then
				-- Pattern: "Tower Trial: Common" (from screenshot)
				local r = t:match("[Tt]ower%s+[Tt]rial:%s*([A-Za-z]+)")
				if r then rarity = r end
			end
			-- Pattern: "0/20" — standalone counter
			if need == 0 then
				local d, n = t:match("^(%d+)/(%d+)$")
				if d and n then
					done = tonumber(d)
					need = tonumber(n)
				end
			end
		end
	end
	return rarity, done, need
end

local function ReadTrialTask()
	-- Use cache if recent (< 0.5s)
	if tick() - TrialCache.lastRead < 0.5 and TrialCache.rarity then
		return TrialCache.rarity, TrialCache.done, TrialCache.need
	end

	local rarity, done, need = ScanPlayerGui()

	-- Fallback: ProximityPrompt "Need: Cosmic (0/3)"
	if not rarity then
		for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
			if obj:IsA("ProximityPrompt") then
				local combined = (obj.ObjectText or "")..(obj.ActionText or "")
				local r2, d2, n2 = combined:match("Need:%s*(%a+)%s*%((%d+)/(%d+)%)")
				if r2 then
					rarity = r2
					done   = tonumber(d2)
					need   = tonumber(n2)
					break
				end
			end
		end
	end

	-- Fallback: use TRIAL_INFO if rarity found but no count
	if rarity and need == 0 then
		local info = TRIAL_INFO[rarity]
		need = info and info.need or 20
	end

	-- Update cache
	if rarity then
		TrialCache.rarity   = rarity
		TrialCache.need     = need
		TrialCache.done     = done
		TrialCache.lastRead = tick()
	end

	return rarity, done, need
end

local function IsTrialActive()
	local pg = LocalPlayer.PlayerGui
	for _, obj in ipairs(pg:GetDescendants()) do
		if obj:IsA("TextLabel") then
			local t = obj.Text or ""
			if t:find("[Tt]ower%s+[Tt]rial:") then
				return true
			end
		end
	end
	return false
end

local function GetTrialProgress()
	local pg = LocalPlayer.PlayerGui
	for _, obj in ipairs(pg:GetDescendants()) do
		if obj:IsA("TextLabel") then
			local d, n = (obj.Text or ""):match("^(%d+)/(%d+)$")
			if d and n then
				TrialCache.done = tonumber(d)
				TrialCache.need = tonumber(n)
				return tonumber(d), tonumber(n)
			end
		end
	end
	return TrialCache.done, TrialCache.need
end

local function FindStartTrialPrompt()
	for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			local at = (obj.ActionText or ""):lower()
			if at:find("start") and at:find("trial") then
				return obj
			end
			if at == "start trial!" or at:find("start trial") then
				return obj
			end
		end
	end
	return nil
end

local function FireTrialPrompt(prompt)
	if fireproximityprompt then
		fireproximityprompt(prompt)
	else
		local hd = prompt.HoldDuration
		if hd <= 0 then hd = 0.1 end
		prompt:InputHoldBegin()
		task.wait(hd + 0.1)
		prompt:InputHoldEnd()
	end
end

local function GetHRP2()
	local chr = LocalPlayer.Character
	return chr and chr:FindFirstChild("HumanoidRootPart")
end

local function TrialGetBrainrots(rarity)
	local found = {}
	local ws = game:GetService("Workspace")
	local folder = ws:FindFirstChild("ActiveBrainrots")
	if not folder then return found end
	for _, rarFolder in ipairs(folder:GetChildren()) do
		if rarFolder.Name:lower() == rarity:lower() then
			for _, obj in ipairs(rarFolder:GetChildren()) do
				local pos = nil
				local prompt = nil
				pcall(function()
					if obj:IsA("BasePart") then pos=obj.Position
					elseif obj:IsA("Model") then
						local r=obj:FindFirstChildWhichIsA("BasePart")
						if r then pos=r.Position end
					end
					prompt=obj:FindFirstChildOfClass("ProximityPrompt",true)
				end)
				if pos then table.insert(found,{obj=obj,pos=pos,prompt=prompt}) end
			end
		end
	end
	return found
end

local function TrialFlyTo(hrp, toPos)
	local sPos = hrp.Position
	local dist = (Vector3.new(toPos.X,0,toPos.Z)-Vector3.new(sPos.X,0,sPos.Z)).Magnitude
	local steps = math.max(5, math.floor(dist * TrialCFG.FlySpeed))
	local timer = 0
	local pauseInt = 0.09 + math.random(0,4)/100
	if TrialCFG.UseNoclip then
		local chr2 = LocalPlayer.Character
		if chr2 then
			for _, p in ipairs(chr2:GetChildren()) do
				if p:IsA("BasePart") then pcall(function() p.CanCollide=false end) end
			end
		end
	end
	for i = 1, steps do
		if not AutoTrialEnabled then return false end
		hrp = GetHRP2() if not hrp then return false end
		local a = i/steps
		hrp.CFrame = CFrame.new(sPos.X+(toPos.X-sPos.X)*a, SAFE_Y, sPos.Z+(toPos.Z-sPos.Z)*a)
		pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
		local st = 0.006 + math.random(0,2)/1000
		timer = timer + st
		if timer >= pauseInt then
			timer=0 pauseInt=0.09+math.random(0,4)/100
			task.wait(0.032+math.random(0,3)/100)
		else
			task.wait(st)
		end
	end
	return true
end

trialTogHit.MouseButton1Click:Connect(function()
	AutoTrialEnabled = not AutoTrialEnabled
	if AutoTrialEnabled then
		Tw(trialTogBg,0.18,{BackgroundColor3=Color3.fromRGB(36,36,36)})
		Tw(trialTogKnob,0.18,{Position=UDim2.new(0,23,0.5,-9),BackgroundColor3=Color3.fromRGB(255,255,255)})
		AddLog("Auto Trial ON")
		task.spawn(function()
			while AutoTrialEnabled do
				TrialStatusVal.Text="Иду к башне..."
				TrialStatusVal.TextColor3=Color3.fromRGB(180,180,180)

				local hrp = GetHRP2()
				if not hrp then task.wait(1) continue end

				-- Fly to tower
				TrialFlyTo(hrp, TOWER_POS)
				task.wait(0.5)

				-- Try to find "Need:" prompt first (trial already active)
				local rarity, done, need = ReadTrialTask()

				if not rarity or not IsTrialActive() then
					TrialStatusVal.Text="Начинаю Trial..."
					local startPrompt = FindStartTrialPrompt()
					if startPrompt then
						hrp = GetHRP2()
						if hrp then hrp.CFrame = CFrame.new(TOWER_POS) end
						task.wait(0.4)
						FireTrialPrompt(startPrompt)
						task.wait(2.5)
						rarity, done, need = ReadTrialTask()
					end
				end

				if not rarity then
					TrialStatusVal.Text="Триал не найден, жду..."
					TrialStatusVal.TextColor3=Color3.fromRGB(220,100,100)
					task.wait(5)
					continue
				end

				TrialRarity = rarity
				TrialNeed = need
				TrialDone = done
				local info = TRIAL_INFO[rarity]
				local rewardTxt = info and (" -> "..info.reward) or ""
				TrialTaskVal.Text = rarity.." - "..need.." шт"..rewardTxt
				TrialProgressVal.Text = tostring(done).." / "..tostring(need)
				TrialStatusVal.Text = "Фармлю "..rarity.."..."
				TrialStatusVal.TextColor3=Color3.fromRGB(100,220,100)
				AddLog("Trial: "..rarity.." x"..need)

				-- Find deliver prompt (tower drop-off)
				local function FindDeliverPrompt()
					for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
						if obj:IsA("ProximityPrompt") then
							local at = (obj.ActionText or ""):lower()
							local ot = (obj.ObjectText or ""):lower()
							if at:find("deliver") or at:find("drop") or at:find("give") or at:find("submit") then
								return obj
							end
							if ot:find("tower") and at ~= "" then
								return obj
							end
						end
					end
					return nil
				end

				local function GetBrainrotPrompt(target)
					local prompt = target.prompt
					if prompt and prompt.Parent then return prompt end
					if target.obj and target.obj.Parent then
						for _,v in ipairs(target.obj:GetDescendants()) do
							if v:IsA("ProximityPrompt") then return v end
						end
					end
					return nil
				end

				local function DoDeliver()
					hrp = GetHRP2()
					if not hrp then return false end
					TrialStatusVal.Text = "Несу к башне..."
					TrialFlyTo(hrp, TOWER_POS)
					task.wait(TrialCFG.WaitAtTower)

					-- Try up to 5 times to deliver
					for attempt = 1, 5 do
						local delPrompt = FindDeliverPrompt()
						if not delPrompt then
							-- Maybe need to stand closer to trigger
							hrp = GetHRP2()
							if hrp then
								hrp.CFrame = CFrame.new(TOWER_POS.X + math.random(-2,2), SAFE_Y, TOWER_POS.Z + math.random(-2,2))
							end
							task.wait(0.3)
							delPrompt = FindDeliverPrompt()
						end
						if delPrompt and delPrompt.Parent then
							FireTrialPrompt(delPrompt)
							task.wait(0.4)
							return true
						end
						task.wait(0.3)
					end
					-- Fallback: fire any prompt near tower
					for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
						if obj:IsA("ProximityPrompt") then
							local part = obj.Parent
							local pos = part and part:IsA("BasePart") and part.Position
							if pos and (pos - TOWER_POS).Magnitude < 20 then
								FireTrialPrompt(obj)
								task.wait(0.4)
								return true
							end
						end
					end
					return false
				end

				while AutoTrialEnabled do
					local d2, n2 = GetTrialProgress()
					TrialProgressVal.Text = tostring(d2).." / "..tostring(n2)
					if not IsTrialActive() or (n2 > 0 and d2 >= n2) then
						TrialStatusVal.Text="V Готово!"
						TrialStatusVal.TextColor3=Color3.fromRGB(80,255,120)
						AddLog("Trial done! "..d2.."/"..n2)
						TrialCache.rarity = nil
						if TrialCFG.AutoRestart then
							TrialStatusVal.Text="Рестарт..."
							task.wait(4 + math.random(0,3))
						else
							task.wait(10)
						end
						break
					end

					-- Перечитываем задание каждую итерацию чтобы поймать смену рарити
					TrialCache.rarity = nil
					local newRarity, newDone, newNeed = ReadTrialTask()
					if newRarity and newRarity ~= TrialRarity then
						TrialRarity = newRarity
						TrialNeed   = newNeed
						TrialDone   = newDone
						local info = TRIAL_INFO[newRarity]
						local rewardTxt = info and (" -> "..info.reward) or ""
						TrialTaskVal.Text = newRarity.." - "..tostring(newNeed).." шт"..rewardTxt
						TrialStatusVal.Text = "Фармлю "..newRarity.."..."
						TrialStatusVal.TextColor3 = Color3.fromRGB(100,220,100)
						AddLog("Задание сменилось: "..newRarity.." x"..tostring(newNeed))
					end

					local brainrots = TrialGetBrainrots(TrialRarity)
					if #brainrots == 0 then
						TrialStatusVal.Text="Нет "..TrialRarity..", жду..."
						task.wait(3)
					else
						-- Pick ONE brainrot, deliver, repeat
						local target = brainrots[1]
						-- Try up to 5 brainrots if one despawns
						local picked = false
						for attempt = 1, math.min(5, #brainrots) do
							target = brainrots[attempt]
							if not target.obj or not target.obj.Parent then continue end
							hrp = GetHRP2()
							if not hrp then break end
							TrialStatusVal.Text = "Иду к "..TrialRarity.."..."
							local arrived = TrialFlyTo(hrp, target.pos)
							if not arrived then break end
							task.wait(TrialCFG.WaitAfterTake)
							-- Check still exists
							if not target.obj or not target.obj.Parent then
								AddLog("Пропал, след. ("..attempt.."/5)")
								continue
							end
							local prompt = GetBrainrotPrompt(target)
							if prompt and prompt.Parent then
								TrialStatusVal.Text = "Беру "..TrialRarity.."..."
								FireTrialPrompt(prompt)
								task.wait(0.5)
								picked = true
								break
							end
						end
						if picked then
							DoDeliver()
							TrialCache.rarity = nil  -- сбрасываем кэш после сдачи чтобы сразу читать новое задание
							task.wait(0.5 + math.random(0,3)/10)
						else
							task.wait(1)
						end
					end
				end
			end
		end)
	else
		Tw(trialTogBg,0.18,{BackgroundColor3=Color3.fromRGB(20,20,20)})
		Tw(trialTogKnob,0.18,{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(88,88,88)})
		TrialStatusVal.Text="Выключен"
		TrialStatusVal.TextColor3=Color3.fromRGB(120,120,120)
		TrialTaskVal.Text="—"
		TrialProgressVal.Text="0 / 0"
		AddLog("Auto Trial OFF")
	end
end)

local halfW = math.floor((CW-6)/2)

local function MakeInfoGrid()
	local entries={
		{T("version"),"v"..SCRIPT_VERSION},{T("released"),RELEASE_DATE},
		{T("username"),LocalPlayer.Name},{T("displayName"),LocalPlayer.DisplayName},
		{T("playerId"),tostring(LocalPlayer.UserId)},{T("accountAge"),tostring(LocalPlayer.AccountAge)..T("days")},
	}
	for i,e in ipairs(entries) do
		local col=(i-1)%2 local row=math.floor((i-1)/2)
		local card=Instance.new("Frame") card.Size=UDim2.new(0,halfW,0,40) card.Position=UDim2.new(0,col*(halfW+6),0,row*46)
		card.BackgroundColor3=Color3.fromRGB(11,11,11) card.BorderSizePixel=0 card.ZIndex=7 card.Parent=InfoPage
		Corner(9,card) Stroke(Color3.fromRGB(25,25,25),1,card)
		MakeTxt({Size=UDim2.new(1,-14,0,13),Position=UDim2.new(0,12,0,4),Text=e[1],TextColor3=Color3.fromRGB(55,55,55),TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},card)
		MakeTxt({Size=UDim2.new(1,-14,0,17),Position=UDim2.new(0,12,0,20),Text=e[2],TextColor3=Color3.fromRGB(190,190,190),TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},card)
	end
end

local function SwitchTab(tab)
	ActiveTab=tab
	local tabs={Main=SideTabMain, Farm=SideTabFarm, Trial=SideTabTrial, Info=SideTabInfo}
	local pages={Main=MainPage, Farm=FarmPage, Trial=TrialPage, Info=InfoPage}
	for name,btn in pairs(tabs) do
		if name==tab then Tw(btn,0.15,{BackgroundColor3=Color3.fromRGB(17,17,17),TextColor3=Color3.fromRGB(255,255,255)})
		else Tw(btn,0.15,{BackgroundColor3=Color3.fromRGB(5,5,5),TextColor3=Color3.fromRGB(80,80,80)}) end
	end
	for name,pg in pairs(pages) do pg.Visible=(name==tab) end
end
SideTabMain.MouseButton1Click:Connect(function() SwitchTab("Main") end)
SideTabFarm.MouseButton1Click:Connect(function() SwitchTab("Farm") end)
SideTabTrial.MouseButton1Click:Connect(function() SwitchTab("Trial") end)
SideTabInfo.MouseButton1Click:Connect(function() SwitchTab("Info") end)

local WIN_H = 620
local function CloseMenu()
	MenuOpen=false Tw(Win,0.25,{Size=UDim2.new(0,580,0,0)})
	task.delay(0.28,function() Win.Visible=false Win.Size=UDim2.new(0,580,0,WIN_H) end)
end
local function OpenMenu()
	MenuOpen=true Win.Visible=true Win.Size=UDim2.new(0,580,0,0)
	Tw(Win,0.35,{Size=UDim2.new(0,580,0,WIN_H)})
end
CloseBtn.MouseButton1Click:Connect(CloseMenu)
ToggleBtn.MouseButton1Click:Connect(function() if MenuOpen then CloseMenu() else OpenMenu() end end)

RunService.Heartbeat:Connect(function()
	if flyUpHeld and FlyEnabled then
		local hrp=GetHRP() if hrp then hrp.CFrame=hrp.CFrame*CFrame.new(0,1,0) end
	end
	if flyDownHeld and FlyEnabled then
		local hrp=GetHRP() if hrp then hrp.CFrame=hrp.CFrame*CFrame.new(0,-1,0) end
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.7)
	nowe=false tpwalking=false FlyEnabled=false
	pcall(function() LocalPlayer.Character.Humanoid.PlatformStand=false end)
	pcall(function() LocalPlayer.Character.Animate.Disabled=false end)
end)

local function ShowLangScreen()
	Tw(LoadScreen,0.4,{BackgroundTransparency=1})
	task.delay(0.42,function()
		LoadScreen.Visible=false LangScreen.Visible=true
		Tw(LangCard,0.38,{BackgroundTransparency=0})
		Tw(LangTitleLbl,0.3,{TextTransparency=0})
		task.delay(0.08,function()
			Tw(BtnEN,0.28,{BackgroundTransparency=0})
			Tw(BtnRU,0.28,{BackgroundTransparency=0})
		end)
	end)
end

local function LaunchHub()
	MakeInfoGrid()
	task.delay(0.1,function()
		AddLog("Star Hub v"..SCRIPT_VERSION.." loaded")
		AddLog("Player: "..LocalPlayer.Name)
		local ab=game:GetService("Workspace"):FindFirstChild("ActiveBrainrots")
		AddLog(ab and "ActiveBrainrots: OK" or "ActiveBrainrots: NOT FOUND")
	end)
	ToggleBtn.Visible=true Win.Visible=true Win.Size=UDim2.new(0,580,0,0)
	Tw(Win,0.4,{Size=UDim2.new(0,580,0,WIN_H)})
end

local function SelectLang(lang)
	LANG=lang
	SideTabMain.Text=T("main") SideTabFarm.Text=T("farm") SideTabTrial.Text=T("trial") SideTabInfo.Text=T("info")
	CloseBtn.Text=T("close")
	flyRefs.title.Text=T("fly") flyRefs.desc.Text=T("flyDesc")
	farmRefs.title.Text=T("autoFarm") farmRefs.desc.Text=T("autoFarmDesc")
	antiRefs.title.Text=T("antidetect") antiRefs.desc.Text=T("antidetectDesc")
	speedRefs.title.Text=T("speedgod") speedRefs.desc.Text=T("speedgodDesc")
	godRefs.title.Text=T("godmode") godRefs.desc.Text=T("godmodeDesc")
	Tw(LangScreen,0.32,{BackgroundTransparency=1})
	task.delay(0.35,function() LangScreen.Visible=false LaunchHub() end)
end

BtnEN.MouseButton1Click:Connect(function() SelectLang("EN") end)
BtnRU.MouseButton1Click:Connect(function() SelectLang("RU") end)

task.spawn(function()
	Tw(LoadTitle,0.6,{TextTransparency=0})
	for _,lbl in ipairs(ShimmerLabels) do lbl.TextTransparency=0 end
	task.wait(0.7) StartShimmer()
	Tw(LoadGame,0.4,{TextTransparency=0}) Tw(LoadSub,0.4,{TextTransparency=0})
	task.delay(0.2,function() Tw(BarBg,0.3,{BackgroundTransparency=0}) end)
	local steps={0.15,0.35,0.55,0.72,0.88,1.0}
	local msgs={"Initializing...","Loading remotes...","Building GUI...","Setting up farm...","Bypassing limits...","Done!"}
	for i,pct in ipairs(steps) do
		task.wait(0.44) LoadSub.Text=msgs[i] Tw(BarFill,0.28,{Size=UDim2.new(pct,0,1,0)})
	end
	task.wait(0.3) ShowLangScreen()
end)
