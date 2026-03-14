local NexusUI = {}
NexusUI.__index = NexusUI
NexusUI._version = "beta 0.0.1"
NexusUI._windows = {}
NexusUI._hotkeys = {}
NexusUI._plugins = {}
NexusUI._eventBus = {}
NexusUI._configCache = {}
NexusUI._tooltipDelay = 0.55
NexusUI._notifStack = {}
NexusUI._activeThemeName = "Dark"
NexusUI._commandPaletteOpen = false
NexusUI._globalCallbacks = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

local Themes = {}

Themes.Dark = {
	Name = "Dark", Background = Color3.fromRGB(10,10,10), Surface = Color3.fromRGB(17,17,17),
	Surface2 = Color3.fromRGB(24,24,24), Surface3 = Color3.fromRGB(32,32,32), Surface4 = Color3.fromRGB(42,42,42),
	Border = Color3.fromRGB(40,40,40), BorderBright = Color3.fromRGB(70,70,70),
	Text = Color3.fromRGB(240,240,240), TextDim = Color3.fromRGB(150,150,150), TextMuted = Color3.fromRGB(75,75,75),
	White = Color3.fromRGB(255,255,255), Accent = Color3.fromRGB(255,255,255), AccentDim = Color3.fromRGB(180,180,180),
	ToggleOff = Color3.fromRGB(40,40,40), SliderBack = Color3.fromRGB(30,30,30),
	Danger = Color3.fromRGB(255,70,70), Success = Color3.fromRGB(70,220,120),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(70,170,255),
	TabActive = Color3.fromRGB(38,38,38), ScrollBar = Color3.fromRGB(50,50,50),
	InputBack = Color3.fromRGB(14,14,14), CodeBack = Color3.fromRGB(8,8,8),
	BadgeRed = Color3.fromRGB(200,50,50), BadgeGreen = Color3.fromRGB(50,160,90),
	BadgeBlue = Color3.fromRGB(50,120,210), BadgeYellow = Color3.fromRGB(200,155,30),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(255,255,255),
	TagBack = Color3.fromRGB(38,38,38), TagText = Color3.fromRGB(200,200,200),
	RadioFill = Color3.fromRGB(255,255,255), CheckFill = Color3.fromRGB(255,255,255),
	TableHead = Color3.fromRGB(20,20,20), TableRow = Color3.fromRGB(17,17,17), TableRowAlt = Color3.fromRGB(22,22,22),
	StatusOnline = Color3.fromRGB(70,220,120), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(120,120,120),
	SpinnerCol = Color3.fromRGB(255,255,255), AccordHead = Color3.fromRGB(24,24,24), AccordBody = Color3.fromRGB(20,20,20),
	ContextBack = Color3.fromRGB(22,22,22), ContextHover = Color3.fromRGB(32,32,32),
	TooltipBack = Color3.fromRGB(28,28,28), TooltipText = Color3.fromRGB(200,200,200),
	CmdBack = Color3.fromRGB(18,18,18), CmdInput = Color3.fromRGB(12,12,12),
	CmdResult = Color3.fromRGB(24,24,24), CmdResultHov = Color3.fromRGB(34,34,34),
	StatusBar = Color3.fromRGB(12,12,12), StatusBarTxt = Color3.fromRGB(100,100,100),
	DebugBack = Color3.fromRGB(8,8,8), DebugText = Color3.fromRGB(0,220,80),
	DebugErr = Color3.fromRGB(255,70,70), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(70,170,255),
	RangeBack = Color3.fromRGB(30,30,30), RangeFill = Color3.fromRGB(255,255,255),
	SelectionBox = Color3.fromRGB(50,50,50), SectionHead = Color3.fromRGB(20,20,20), SectionLine = Color3.fromRGB(35,35,35),
}

Themes.Light = {
	Name = "Light", Background = Color3.fromRGB(245,245,245), Surface = Color3.fromRGB(255,255,255),
	Surface2 = Color3.fromRGB(240,240,240), Surface3 = Color3.fromRGB(228,228,228), Surface4 = Color3.fromRGB(215,215,215),
	Border = Color3.fromRGB(210,210,210), BorderBright = Color3.fromRGB(170,170,170),
	Text = Color3.fromRGB(20,20,20), TextDim = Color3.fromRGB(90,90,90), TextMuted = Color3.fromRGB(170,170,170),
	White = Color3.fromRGB(20,20,20), Accent = Color3.fromRGB(30,30,30), AccentDim = Color3.fromRGB(80,80,80),
	ToggleOff = Color3.fromRGB(200,200,200), SliderBack = Color3.fromRGB(220,220,220),
	Danger = Color3.fromRGB(220,50,50), Success = Color3.fromRGB(40,180,90),
	Warning = Color3.fromRGB(210,160,20), Info = Color3.fromRGB(40,130,220),
	TabActive = Color3.fromRGB(235,235,235), ScrollBar = Color3.fromRGB(190,190,190),
	InputBack = Color3.fromRGB(250,250,250), CodeBack = Color3.fromRGB(235,235,238),
	BadgeRed = Color3.fromRGB(220,50,50), BadgeGreen = Color3.fromRGB(40,160,80),
	BadgeBlue = Color3.fromRGB(40,110,200), BadgeYellow = Color3.fromRGB(190,140,20),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(30,30,30),
	TagBack = Color3.fromRGB(220,220,220), TagText = Color3.fromRGB(50,50,50),
	RadioFill = Color3.fromRGB(30,30,30), CheckFill = Color3.fromRGB(30,30,30),
	TableHead = Color3.fromRGB(235,235,235), TableRow = Color3.fromRGB(255,255,255), TableRowAlt = Color3.fromRGB(248,248,248),
	StatusOnline = Color3.fromRGB(40,180,90), StatusBusy = Color3.fromRGB(210,160,20), StatusOff = Color3.fromRGB(160,160,160),
	SpinnerCol = Color3.fromRGB(30,30,30), AccordHead = Color3.fromRGB(240,240,240), AccordBody = Color3.fromRGB(248,248,248),
	ContextBack = Color3.fromRGB(255,255,255), ContextHover = Color3.fromRGB(240,240,240),
	TooltipBack = Color3.fromRGB(50,50,50), TooltipText = Color3.fromRGB(240,240,240),
	CmdBack = Color3.fromRGB(255,255,255), CmdInput = Color3.fromRGB(245,245,245),
	CmdResult = Color3.fromRGB(250,250,250), CmdResultHov = Color3.fromRGB(240,240,240),
	StatusBar = Color3.fromRGB(235,235,235), StatusBarTxt = Color3.fromRGB(130,130,130),
	DebugBack = Color3.fromRGB(240,240,240), DebugText = Color3.fromRGB(20,160,60),
	DebugErr = Color3.fromRGB(200,40,40), DebugWarn = Color3.fromRGB(180,130,10), DebugInfo = Color3.fromRGB(40,120,200),
	RangeBack = Color3.fromRGB(220,220,220), RangeFill = Color3.fromRGB(30,30,30),
	SelectionBox = Color3.fromRGB(210,210,210), SectionHead = Color3.fromRGB(240,240,240), SectionLine = Color3.fromRGB(220,220,220),
}

Themes.Ocean = {
	Name = "Ocean", Background = Color3.fromRGB(8,18,30), Surface = Color3.fromRGB(12,26,42),
	Surface2 = Color3.fromRGB(16,34,56), Surface3 = Color3.fromRGB(22,44,70), Surface4 = Color3.fromRGB(28,54,84),
	Border = Color3.fromRGB(30,58,88), BorderBright = Color3.fromRGB(50,90,130),
	Text = Color3.fromRGB(200,228,255), TextDim = Color3.fromRGB(100,150,200), TextMuted = Color3.fromRGB(50,90,130),
	White = Color3.fromRGB(200,228,255), Accent = Color3.fromRGB(60,160,255), AccentDim = Color3.fromRGB(40,110,200),
	ToggleOff = Color3.fromRGB(22,50,78), SliderBack = Color3.fromRGB(18,40,64),
	Danger = Color3.fromRGB(255,80,80), Success = Color3.fromRGB(40,220,140),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(60,180,255),
	TabActive = Color3.fromRGB(20,46,74), ScrollBar = Color3.fromRGB(40,80,120),
	InputBack = Color3.fromRGB(10,22,36), CodeBack = Color3.fromRGB(6,14,24),
	BadgeRed = Color3.fromRGB(200,60,60), BadgeGreen = Color3.fromRGB(40,180,110),
	BadgeBlue = Color3.fromRGB(60,140,220), BadgeYellow = Color3.fromRGB(200,160,40),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(60,160,255),
	TagBack = Color3.fromRGB(22,50,78), TagText = Color3.fromRGB(100,160,220),
	RadioFill = Color3.fromRGB(60,160,255), CheckFill = Color3.fromRGB(60,160,255),
	TableHead = Color3.fromRGB(10,24,40), TableRow = Color3.fromRGB(12,26,42), TableRowAlt = Color3.fromRGB(16,32,50),
	StatusOnline = Color3.fromRGB(40,220,140), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(80,120,160),
	SpinnerCol = Color3.fromRGB(60,160,255), AccordHead = Color3.fromRGB(14,32,52), AccordBody = Color3.fromRGB(12,28,46),
	ContextBack = Color3.fromRGB(14,30,50), ContextHover = Color3.fromRGB(20,44,70),
	TooltipBack = Color3.fromRGB(10,24,40), TooltipText = Color3.fromRGB(150,200,255),
	CmdBack = Color3.fromRGB(12,26,42), CmdInput = Color3.fromRGB(8,18,30),
	CmdResult = Color3.fromRGB(16,34,56), CmdResultHov = Color3.fromRGB(22,44,70),
	StatusBar = Color3.fromRGB(8,18,30), StatusBarTxt = Color3.fromRGB(60,110,160),
	DebugBack = Color3.fromRGB(6,14,24), DebugText = Color3.fromRGB(60,220,150),
	DebugErr = Color3.fromRGB(255,80,80), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(60,180,255),
	RangeBack = Color3.fromRGB(18,40,64), RangeFill = Color3.fromRGB(60,160,255),
	SelectionBox = Color3.fromRGB(30,60,100), SectionHead = Color3.fromRGB(14,30,50), SectionLine = Color3.fromRGB(26,52,82),
}

Themes.Crimson = {
	Name = "Crimson", Background = Color3.fromRGB(18,6,6), Surface = Color3.fromRGB(28,10,10),
	Surface2 = Color3.fromRGB(38,14,14), Surface3 = Color3.fromRGB(50,20,20), Surface4 = Color3.fromRGB(62,26,26),
	Border = Color3.fromRGB(70,28,28), BorderBright = Color3.fromRGB(110,50,50),
	Text = Color3.fromRGB(255,220,220), TextDim = Color3.fromRGB(190,120,120), TextMuted = Color3.fromRGB(110,60,60),
	White = Color3.fromRGB(255,220,220), Accent = Color3.fromRGB(220,50,50), AccentDim = Color3.fromRGB(170,30,30),
	ToggleOff = Color3.fromRGB(55,20,20), SliderBack = Color3.fromRGB(45,16,16),
	Danger = Color3.fromRGB(255,80,80), Success = Color3.fromRGB(80,220,120),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(80,170,255),
	TabActive = Color3.fromRGB(48,18,18), ScrollBar = Color3.fromRGB(90,36,36),
	InputBack = Color3.fromRGB(22,8,8), CodeBack = Color3.fromRGB(14,4,4),
	BadgeRed = Color3.fromRGB(200,50,50), BadgeGreen = Color3.fromRGB(50,160,90),
	BadgeBlue = Color3.fromRGB(50,120,210), BadgeYellow = Color3.fromRGB(200,155,30),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(220,50,50),
	TagBack = Color3.fromRGB(55,20,20), TagText = Color3.fromRGB(200,130,130),
	RadioFill = Color3.fromRGB(220,50,50), CheckFill = Color3.fromRGB(220,50,50),
	TableHead = Color3.fromRGB(22,8,8), TableRow = Color3.fromRGB(28,10,10), TableRowAlt = Color3.fromRGB(34,12,12),
	StatusOnline = Color3.fromRGB(80,220,120), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(130,70,70),
	SpinnerCol = Color3.fromRGB(220,50,50), AccordHead = Color3.fromRGB(36,14,14), AccordBody = Color3.fromRGB(32,12,12),
	ContextBack = Color3.fromRGB(34,12,12), ContextHover = Color3.fromRGB(48,18,18),
	TooltipBack = Color3.fromRGB(30,10,10), TooltipText = Color3.fromRGB(220,180,180),
	CmdBack = Color3.fromRGB(28,10,10), CmdInput = Color3.fromRGB(18,6,6),
	CmdResult = Color3.fromRGB(36,14,14), CmdResultHov = Color3.fromRGB(50,20,20),
	StatusBar = Color3.fromRGB(16,5,5), StatusBarTxt = Color3.fromRGB(140,70,70),
	DebugBack = Color3.fromRGB(12,4,4), DebugText = Color3.fromRGB(220,80,80),
	DebugErr = Color3.fromRGB(255,50,50), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(80,170,255),
	RangeBack = Color3.fromRGB(45,16,16), RangeFill = Color3.fromRGB(220,50,50),
	SelectionBox = Color3.fromRGB(80,30,30), SectionHead = Color3.fromRGB(36,14,14), SectionLine = Color3.fromRGB(60,24,24),
}

Themes.Forest = {
	Name = "Forest", Background = Color3.fromRGB(8,16,10), Surface = Color3.fromRGB(12,24,14),
	Surface2 = Color3.fromRGB(16,32,18), Surface3 = Color3.fromRGB(22,42,24), Surface4 = Color3.fromRGB(28,52,30),
	Border = Color3.fromRGB(32,56,34), BorderBright = Color3.fromRGB(55,90,58),
	Text = Color3.fromRGB(210,240,210), TextDim = Color3.fromRGB(110,170,112), TextMuted = Color3.fromRGB(55,100,58),
	White = Color3.fromRGB(210,240,210), Accent = Color3.fromRGB(60,200,80), AccentDim = Color3.fromRGB(40,150,55),
	ToggleOff = Color3.fromRGB(26,48,28), SliderBack = Color3.fromRGB(20,38,22),
	Danger = Color3.fromRGB(255,80,80), Success = Color3.fromRGB(60,220,80),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(60,180,255),
	TabActive = Color3.fromRGB(20,42,22), ScrollBar = Color3.fromRGB(44,80,46),
	InputBack = Color3.fromRGB(10,20,12), CodeBack = Color3.fromRGB(6,14,8),
	BadgeRed = Color3.fromRGB(200,60,60), BadgeGreen = Color3.fromRGB(40,180,60),
	BadgeBlue = Color3.fromRGB(60,140,220), BadgeYellow = Color3.fromRGB(200,160,40),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(60,200,80),
	TagBack = Color3.fromRGB(22,48,24), TagText = Color3.fromRGB(100,180,105),
	RadioFill = Color3.fromRGB(60,200,80), CheckFill = Color3.fromRGB(60,200,80),
	TableHead = Color3.fromRGB(10,22,12), TableRow = Color3.fromRGB(12,24,14), TableRowAlt = Color3.fromRGB(16,30,18),
	StatusOnline = Color3.fromRGB(60,220,80), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(80,130,82),
	SpinnerCol = Color3.fromRGB(60,200,80), AccordHead = Color3.fromRGB(14,30,16), AccordBody = Color3.fromRGB(12,26,14),
	ContextBack = Color3.fromRGB(14,28,16), ContextHover = Color3.fromRGB(22,44,24),
	TooltipBack = Color3.fromRGB(10,22,12), TooltipText = Color3.fromRGB(160,220,162),
	CmdBack = Color3.fromRGB(12,24,14), CmdInput = Color3.fromRGB(8,16,10),
	CmdResult = Color3.fromRGB(16,32,18), CmdResultHov = Color3.fromRGB(22,44,24),
	StatusBar = Color3.fromRGB(8,16,10), StatusBarTxt = Color3.fromRGB(60,110,62),
	DebugBack = Color3.fromRGB(6,14,8), DebugText = Color3.fromRGB(60,220,80),
	DebugErr = Color3.fromRGB(255,80,80), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(60,180,255),
	RangeBack = Color3.fromRGB(20,38,22), RangeFill = Color3.fromRGB(60,200,80),
	SelectionBox = Color3.fromRGB(30,60,32), SectionHead = Color3.fromRGB(14,30,16), SectionLine = Color3.fromRGB(28,54,30),
}

Themes.Midnight = {
	Name = "Midnight", Background = Color3.fromRGB(6,6,20), Surface = Color3.fromRGB(10,10,30),
	Surface2 = Color3.fromRGB(14,14,40), Surface3 = Color3.fromRGB(20,20,52), Surface4 = Color3.fromRGB(26,26,64),
	Border = Color3.fromRGB(30,30,72), BorderBright = Color3.fromRGB(55,55,110),
	Text = Color3.fromRGB(210,210,255), TextDim = Color3.fromRGB(120,120,200), TextMuted = Color3.fromRGB(60,60,120),
	White = Color3.fromRGB(210,210,255), Accent = Color3.fromRGB(120,80,255), AccentDim = Color3.fromRGB(80,50,200),
	ToggleOff = Color3.fromRGB(28,28,68), SliderBack = Color3.fromRGB(22,22,58),
	Danger = Color3.fromRGB(255,80,80), Success = Color3.fromRGB(60,220,140),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(100,150,255),
	TabActive = Color3.fromRGB(20,20,56), ScrollBar = Color3.fromRGB(50,50,100),
	InputBack = Color3.fromRGB(8,8,24), CodeBack = Color3.fromRGB(4,4,16),
	BadgeRed = Color3.fromRGB(200,60,60), BadgeGreen = Color3.fromRGB(60,180,120),
	BadgeBlue = Color3.fromRGB(100,130,255), BadgeYellow = Color3.fromRGB(200,160,40),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(120,80,255),
	TagBack = Color3.fromRGB(28,28,72), TagText = Color3.fromRGB(140,120,230),
	RadioFill = Color3.fromRGB(120,80,255), CheckFill = Color3.fromRGB(120,80,255),
	TableHead = Color3.fromRGB(8,8,26), TableRow = Color3.fromRGB(10,10,30), TableRowAlt = Color3.fromRGB(14,14,38),
	StatusOnline = Color3.fromRGB(60,220,140), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(80,80,150),
	SpinnerCol = Color3.fromRGB(120,80,255), AccordHead = Color3.fromRGB(14,14,42), AccordBody = Color3.fromRGB(12,12,36),
	ContextBack = Color3.fromRGB(12,12,36), ContextHover = Color3.fromRGB(22,22,58),
	TooltipBack = Color3.fromRGB(10,10,32), TooltipText = Color3.fromRGB(180,170,255),
	CmdBack = Color3.fromRGB(10,10,30), CmdInput = Color3.fromRGB(6,6,20),
	CmdResult = Color3.fromRGB(14,14,40), CmdResultHov = Color3.fromRGB(20,20,56),
	StatusBar = Color3.fromRGB(6,6,20), StatusBarTxt = Color3.fromRGB(80,80,160),
	DebugBack = Color3.fromRGB(4,4,16), DebugText = Color3.fromRGB(120,80,255),
	DebugErr = Color3.fromRGB(255,80,80), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(100,150,255),
	RangeBack = Color3.fromRGB(22,22,58), RangeFill = Color3.fromRGB(120,80,255),
	SelectionBox = Color3.fromRGB(40,40,100), SectionHead = Color3.fromRGB(14,14,42), SectionLine = Color3.fromRGB(28,28,72),
}

Themes.Sunset = {
	Name = "Sunset", Background = Color3.fromRGB(20,10,6), Surface = Color3.fromRGB(30,14,8),
	Surface2 = Color3.fromRGB(40,20,10), Surface3 = Color3.fromRGB(52,26,12), Surface4 = Color3.fromRGB(64,32,14),
	Border = Color3.fromRGB(72,36,16), BorderBright = Color3.fromRGB(120,66,30),
	Text = Color3.fromRGB(255,228,200), TextDim = Color3.fromRGB(200,140,90), TextMuted = Color3.fromRGB(120,72,36),
	White = Color3.fromRGB(255,228,200), Accent = Color3.fromRGB(255,120,40), AccentDim = Color3.fromRGB(210,80,20),
	ToggleOff = Color3.fromRGB(60,30,12), SliderBack = Color3.fromRGB(48,24,10),
	Danger = Color3.fromRGB(255,60,60), Success = Color3.fromRGB(60,220,120),
	Warning = Color3.fromRGB(255,200,60), Info = Color3.fromRGB(80,170,255),
	TabActive = Color3.fromRGB(50,24,10), ScrollBar = Color3.fromRGB(100,52,22),
	InputBack = Color3.fromRGB(22,10,4), CodeBack = Color3.fromRGB(16,6,2),
	BadgeRed = Color3.fromRGB(220,60,40), BadgeGreen = Color3.fromRGB(60,180,80),
	BadgeBlue = Color3.fromRGB(60,140,220), BadgeYellow = Color3.fromRGB(230,170,30),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(255,120,40),
	TagBack = Color3.fromRGB(62,28,12), TagText = Color3.fromRGB(220,150,80),
	RadioFill = Color3.fromRGB(255,120,40), CheckFill = Color3.fromRGB(255,120,40),
	TableHead = Color3.fromRGB(24,10,4), TableRow = Color3.fromRGB(30,14,8), TableRowAlt = Color3.fromRGB(38,18,10),
	StatusOnline = Color3.fromRGB(60,220,120), StatusBusy = Color3.fromRGB(255,200,60), StatusOff = Color3.fromRGB(140,80,40),
	SpinnerCol = Color3.fromRGB(255,120,40), AccordHead = Color3.fromRGB(38,18,8), AccordBody = Color3.fromRGB(34,16,6),
	ContextBack = Color3.fromRGB(34,16,8), ContextHover = Color3.fromRGB(52,26,12),
	TooltipBack = Color3.fromRGB(26,12,4), TooltipText = Color3.fromRGB(240,200,160),
	CmdBack = Color3.fromRGB(30,14,8), CmdInput = Color3.fromRGB(20,10,4),
	CmdResult = Color3.fromRGB(40,20,10), CmdResultHov = Color3.fromRGB(54,26,12),
	StatusBar = Color3.fromRGB(18,8,4), StatusBarTxt = Color3.fromRGB(160,90,40),
	DebugBack = Color3.fromRGB(14,6,2), DebugText = Color3.fromRGB(255,120,40),
	DebugErr = Color3.fromRGB(255,60,60), DebugWarn = Color3.fromRGB(255,200,60), DebugInfo = Color3.fromRGB(80,170,255),
	RangeBack = Color3.fromRGB(48,24,10), RangeFill = Color3.fromRGB(255,120,40),
	SelectionBox = Color3.fromRGB(90,44,16), SectionHead = Color3.fromRGB(38,18,8), SectionLine = Color3.fromRGB(68,34,14),
}

Themes.Neon = {
	Name = "Neon", Background = Color3.fromRGB(5,5,5), Surface = Color3.fromRGB(10,10,10),
	Surface2 = Color3.fromRGB(15,15,15), Surface3 = Color3.fromRGB(20,20,20), Surface4 = Color3.fromRGB(26,26,26),
	Border = Color3.fromRGB(30,30,30), BorderBright = Color3.fromRGB(60,60,60),
	Text = Color3.fromRGB(200,255,200), TextDim = Color3.fromRGB(100,200,100), TextMuted = Color3.fromRGB(40,100,40),
	White = Color3.fromRGB(200,255,200), Accent = Color3.fromRGB(0,255,120), AccentDim = Color3.fromRGB(0,180,80),
	ToggleOff = Color3.fromRGB(22,22,22), SliderBack = Color3.fromRGB(18,18,18),
	Danger = Color3.fromRGB(255,50,50), Success = Color3.fromRGB(0,255,120),
	Warning = Color3.fromRGB(255,200,0), Info = Color3.fromRGB(0,200,255),
	TabActive = Color3.fromRGB(20,20,20), ScrollBar = Color3.fromRGB(40,80,40),
	InputBack = Color3.fromRGB(8,8,8), CodeBack = Color3.fromRGB(4,4,4),
	BadgeRed = Color3.fromRGB(255,50,50), BadgeGreen = Color3.fromRGB(0,220,100),
	BadgeBlue = Color3.fromRGB(0,180,255), BadgeYellow = Color3.fromRGB(220,200,0),
	ModalOverlay = Color3.fromRGB(0,0,0), ProgressFill = Color3.fromRGB(0,255,120),
	TagBack = Color3.fromRGB(20,20,20), TagText = Color3.fromRGB(0,200,100),
	RadioFill = Color3.fromRGB(0,255,120), CheckFill = Color3.fromRGB(0,255,120),
	TableHead = Color3.fromRGB(8,8,8), TableRow = Color3.fromRGB(10,10,10), TableRowAlt = Color3.fromRGB(14,14,14),
	StatusOnline = Color3.fromRGB(0,255,120), StatusBusy = Color3.fromRGB(255,200,0), StatusOff = Color3.fromRGB(60,60,60),
	SpinnerCol = Color3.fromRGB(0,255,120), AccordHead = Color3.fromRGB(14,14,14), AccordBody = Color3.fromRGB(12,12,12),
	ContextBack = Color3.fromRGB(12,12,12), ContextHover = Color3.fromRGB(22,22,22),
	TooltipBack = Color3.fromRGB(10,10,10), TooltipText = Color3.fromRGB(160,255,180),
	CmdBack = Color3.fromRGB(10,10,10), CmdInput = Color3.fromRGB(5,5,5),
	CmdResult = Color3.fromRGB(15,15,15), CmdResultHov = Color3.fromRGB(22,22,22),
	StatusBar = Color3.fromRGB(5,5,5), StatusBarTxt = Color3.fromRGB(0,160,80),
	DebugBack = Color3.fromRGB(4,4,4), DebugText = Color3.fromRGB(0,255,120),
	DebugErr = Color3.fromRGB(255,50,50), DebugWarn = Color3.fromRGB(255,200,0), DebugInfo = Color3.fromRGB(0,200,255),
	RangeBack = Color3.fromRGB(18,18,18), RangeFill = Color3.fromRGB(0,255,120),
	SelectionBox = Color3.fromRGB(0,80,40), SectionHead = Color3.fromRGB(14,14,14), SectionLine = Color3.fromRGB(28,28,28),
}

local Theme = Themes.Dark

local function SetTheme(name)
	if Themes[name] then
		Theme = Themes[name]
		NexusUI._activeThemeName = name
	end
end

NexusUI.Themes = Themes
NexusUI.SetTheme = SetTheme
NexusUI.GetTheme = function() return Theme end

local function Tween(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function TweenCallback(obj, props, t, style, dir, cb)
	local tw = TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
	if cb then tw.Completed:Connect(cb) end
	tw:Play()
	return tw
end

local function New(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	if parent then obj.Parent = parent end
	return obj
end

local function MakeDraggable(frame, handle)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true dragStart = input.Position startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

local function Clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end
local function Round(v, step) return math.floor(v / step + 0.5) * step end
local function Lerp(a, b, t) return a + (b - a) * t end
local function DeepCopy(t) if type(t) ~= "table" then return t end local c = {} for k,v in pairs(t) do c[k] = DeepCopy(v) end return c end
local function TableContains(t, val) for _,v in ipairs(t) do if v == val then return true end end return false end
local function TableRemove(t, val) for i,v in ipairs(t) do if v == val then table.remove(t, i) return end end end
local function ColorToHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end
local function HexToColor(hex) hex = hex:gsub("#","") if #hex ~= 6 then return Color3.new(1,1,1) end return Color3.fromRGB(tonumber(hex:sub(1,2),16) or 255, tonumber(hex:sub(3,4),16) or 255, tonumber(hex:sub(5,6),16) or 255) end
local function FormatNumber(n) local s=tostring(math.floor(n)) local r="" local l=#s for i=1,l do r=r..s:sub(i,i) if (l-i)%3==0 and i~=l then r=r.."," end end return r end

function NexusUI:On(name, callback)
	if not self._eventBus[name] then self._eventBus[name] = {} end
	table.insert(self._eventBus[name], callback)
	return function() TableRemove(self._eventBus[name], callback) end
end

function NexusUI:RegisterHotkey(keyCode, callback, description)
	table.insert(self._hotkeys, { Key = keyCode, Callback = callback, Desc = description or "" })
end

function NexusUI:SaveConfig(key, data)
	local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if ok then
		self._configCache[key] = encoded
		pcall(function()
			if not isfolder("NexusUI") then makefolder("NexusUI") end
			writefile("NexusUI/" .. key .. ".json", encoded)
		end)
	end
end

function NexusUI:LoadConfig(key)
	if self._configCache[key] then
		local ok, data = pcall(function() return HttpService:JSONDecode(self._configCache[key]) end)
		if ok then return data end
	end
	local ok, raw = pcall(function() return readfile("NexusUI/" .. key .. ".json") end)
	if ok and raw then
		local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if ok2 then self._configCache[key] = raw return data end
	end
	return nil
end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	for _, hk in ipairs(NexusUI._hotkeys) do
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == hk.Key then
			pcall(hk.Callback)
		end
	end
end)

local _tooltipGui = nil
local _tooltipLabel = nil
local _tooltipThread = nil

local function EnsureTooltipGui()
	if _tooltipGui and _tooltipGui.Parent then return end
	_tooltipGui = New("ScreenGui", { Name = "NexusUITooltip", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999 }, CoreGui)
	local frame = New("Frame", { Size = UDim2.new(0,0,0,24), BackgroundColor3 = Theme.TooltipBack, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, Visible = false, ZIndex = 999 }, _tooltipGui)
	New("UICorner", { CornerRadius = UDim.new(0,5) }, frame)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, frame)
	New("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8) }, frame)
	_tooltipLabel = New("TextLabel", { Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = "", TextColor3 = Theme.TooltipText, TextSize = 12, Font = Enum.Font.Gotham, ZIndex = 999 }, frame)
	_tooltipGui._frame = frame
end

local function ShowTooltip(text)
	EnsureTooltipGui()
	if _tooltipThread then task.cancel(_tooltipThread) end
	_tooltipThread = task.delay(NexusUI._tooltipDelay, function()
		_tooltipLabel.Text = text
		_tooltipGui._frame.Visible = true
	end)
	RunService.RenderStepped:Connect(function()
		if _tooltipGui and _tooltipGui.Parent and _tooltipGui._frame.Visible then
			local mp = UserInputService:GetMouseLocation()
			_tooltipGui._frame.Position = UDim2.new(0, mp.X + 14, 0, mp.Y + 18)
		end
	end)
end

local function HideTooltip()
	if _tooltipThread then task.cancel(_tooltipThread) _tooltipThread = nil end
	if _tooltipGui and _tooltipGui.Parent then _tooltipGui._frame.Visible = false end
end

local function AddTooltip(instance, text)
	instance.MouseEnter:Connect(function() ShowTooltip(text) end)
	instance.MouseLeave:Connect(function() HideTooltip() end)
end

local _notifGui = nil
local function EnsureNotifGui()
	if _notifGui and _notifGui.Parent then return end
	_notifGui = New("ScreenGui", { Name = "NexusUINotifications", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 998 }, CoreGui)
end

local function PushNotification(cfg)
	EnsureNotifGui()
	cfg = cfg or {}
	local nType = cfg.Type or "Info"
	local accent = Theme.Info
	if nType == "Success" then accent = Theme.Success elseif nType == "Warning" then accent = Theme.Warning elseif nType == "Error" then accent = Theme.Danger end
	local W, H = 290, 66
	local idx = #NexusUI._notifStack + 1
	local startY = -(H + 8) * (idx - 1) - H
	local nf = New("Frame", { Size = UDim2.new(0,W,0,H), Position = UDim2.new(1,W+20,1,startY-8), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, ZIndex = 200 }, _notifGui)
	New("UICorner", { CornerRadius = UDim.new(0,10) }, nf)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, nf)
	local bar = New("Frame", { Size = UDim2.new(0,3,0,38), Position = UDim2.new(0,10,0.5,-19), BackgroundColor3 = accent, BorderSizePixel = 0 }, nf)
	New("UICorner", { CornerRadius = UDim.new(1,0) }, bar)
	New("TextLabel", { Size = UDim2.new(1,-34,0,24), Position = UDim2.new(0,22,0,8), BackgroundTransparency = 1, Text = cfg.Title or "Notification", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 201 }, nf)
	New("TextLabel", { Size = UDim2.new(1,-34,0,20), Position = UDim2.new(0,22,0,34), BackgroundTransparency = 1, Text = cfg.Text or "", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 201 }, nf)
	local prog = New("Frame", { Size = UDim2.new(1,0,0,2), Position = UDim2.new(0,0,1,-2), BackgroundColor3 = accent, BorderSizePixel = 0, ZIndex = 202 }, nf)
	table.insert(NexusUI._notifStack, nf)
	local dur = cfg.Duration or 3.5
	Tween(nf, { Position = UDim2.new(1,-(W+12),1,startY-8) }, 0.4, Enum.EasingStyle.Back)
	Tween(prog, { Size = UDim2.new(0,0,0,2) }, dur, Enum.EasingStyle.Linear)
	task.delay(dur, function()
		Tween(nf, { Position = UDim2.new(1,W+20,1,startY-8) }, 0.3, Enum.EasingStyle.Quart)
		task.delay(0.35, function() TableRemove(NexusUI._notifStack, nf) nf:Destroy() end)
	end)
end

NexusUI.Notify = PushNotification

local _contextGui = nil
local function ShowContextMenu(items, x, y)
	if _contextGui then _contextGui:Destroy() end
	_contextGui = New("ScreenGui", { Name = "NexusUIContext", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 997 }, CoreGui)
	local H = #items * 32 + 10
	local frame = New("Frame", { Size = UDim2.new(0,160,0,0), Position = UDim2.new(0,x,0,y), BackgroundColor3 = Theme.ContextBack, BorderSizePixel = 0, ZIndex = 300 }, _contextGui)
	New("UICorner", { CornerRadius = UDim.new(0,8) }, frame)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, frame)
	local list = New("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1 }, frame)
	New("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	New("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4) }, list)
	Tween(frame, { Size = UDim2.new(0,160,0,H) }, 0.18, Enum.EasingStyle.Back)
	for _, item in ipairs(items) do
		if item.Separator then
			New("Frame", { Size = UDim2.new(1,0,0,1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 301 }, list)
		else
			local btn = New("TextButton", { Size = UDim2.new(1,0,0,28), BackgroundColor3 = Theme.ContextBack, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 301 }, list)
			New("UICorner", { CornerRadius = UDim.new(0,5) }, btn)
			New("TextLabel", { Size = UDim2.new(0,20,1,0), Position = UDim2.new(0,6,0,0), BackgroundTransparency = 1, Text = item.Icon or "", TextColor3 = item.Color or Theme.TextDim, TextSize = 13, Font = Enum.Font.Gotham, ZIndex = 302 }, btn)
			New("TextLabel", { Size = UDim2.new(1,-30,1,0), Position = UDim2.new(0,28,0,0), BackgroundTransparency = 1, Text = item.Label or "", TextColor3 = item.Color or Theme.Text, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 302 }, btn)
			btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = Theme.ContextHover }, 0.1) end)
			btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = Theme.ContextBack }, 0.1) end)
			btn.MouseButton1Click:Connect(function() _contextGui:Destroy() _contextGui = nil if item.Callback then item.Callback() end end)
		end
	end
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
			if _contextGui then _contextGui:Destroy() _contextGui = nil end conn:Disconnect()
		end
	end)
end

NexusUI.ShowContextMenu = ShowContextMenu

local _modalGui = nil
local function ShowModal(cfg)
	if _modalGui then _modalGui:Destroy() end
	cfg = cfg or {}
	_modalGui = New("ScreenGui", { Name = "NexusUIModal", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 996 }, CoreGui)
	local overlay = New("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Theme.ModalOverlay, BackgroundTransparency = 0.5, Text = "", BorderSizePixel = 0, ZIndex = 400 }, _modalGui)
	local W, H = cfg.Width or 360, cfg.Height or 180
	local box = New("Frame", { Size = UDim2.new(0,W,0,H), Position = UDim2.new(0.5,-W/2,0.5,-H/2-20), BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, ZIndex = 401, BackgroundTransparency = 1 }, _modalGui)
	New("UICorner", { CornerRadius = UDim.new(0,12) }, box)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, box)
	Tween(box, { Position = UDim2.new(0.5,-W/2,0.5,-H/2), BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Back)
	New("TextLabel", { Size = UDim2.new(1,-24,0,36), Position = UDim2.new(0,16,0,0), BackgroundTransparency = 1, Text = cfg.Title or "Dialog", TextColor3 = Theme.Text, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 402 }, box)
	New("Frame", { Size = UDim2.new(1,-32,0,1), Position = UDim2.new(0,16,0,38), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 402 }, box)
	New("TextLabel", { Size = UDim2.new(1,-32,0,H-92), Position = UDim2.new(0,16,0,46), BackgroundTransparency = 1, Text = cfg.Text or "", TextColor3 = Theme.TextDim, TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 402 }, box)
	local buttons = cfg.Buttons or {{ Label = "OK", Primary = true }}
	local btnW = (W - 32 - (#buttons - 1) * 8) / #buttons
	for i, bCfg in ipairs(buttons) do
		local bx = 16 + (btnW + 8) * (i - 1)
		local btn = New("TextButton", { Size = UDim2.new(0,btnW,0,34), Position = UDim2.new(0,bx,0,H-48), BackgroundColor3 = bCfg.Primary and Theme.Accent or Theme.Surface3, Text = bCfg.Label or "Button", TextColor3 = bCfg.Primary and Theme.Background or Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 402 }, box)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, btn)
		btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = bCfg.Primary and Theme.AccentDim or Theme.Surface4 }, 0.12) end)
		btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = bCfg.Primary and Theme.Accent or Theme.Surface3 }, 0.12) end)
		btn.MouseButton1Click:Connect(function()
			TweenCallback(box, { Position = UDim2.new(0.5,-W/2,0.5,-H/2-20), BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
				if _modalGui then _modalGui:Destroy() _modalGui = nil end
			end)
			if bCfg.Callback then bCfg.Callback() end
		end)
	end
	if cfg.CloseOnOverlay ~= false then
		overlay.MouseButton1Click:Connect(function()
			TweenCallback(box, { Position = UDim2.new(0.5,-W/2,0.5,-H/2-20), BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
				if _modalGui then _modalGui:Destroy() _modalGui = nil end
			end)
		end)
	end
	return { Close = function() if _modalGui then _modalGui:Destroy() _modalGui = nil end end }
end

NexusUI.ShowModal = ShowModal

local _cmdGui = nil
local function CloseCmdPalette()
	if _cmdGui then _cmdGui:Destroy() _cmdGui = nil NexusUI._commandPaletteOpen = false end
end

local function OpenCmdPalette(commands)
	if NexusUI._commandPaletteOpen then CloseCmdPalette() return end
	NexusUI._commandPaletteOpen = true
	commands = commands or {}
	_cmdGui = New("ScreenGui", { Name = "NexusUICmd", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 995 }, CoreGui)
	local overlay = New("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.6, Text = "", BorderSizePixel = 0, ZIndex = 500 }, _cmdGui)
	overlay.MouseButton1Click:Connect(CloseCmdPalette)
	local W = 520
	local panel = New("Frame", { Size = UDim2.new(0,W,0,60), Position = UDim2.new(0.5,-W/2,0.28,0), BackgroundColor3 = Theme.CmdBack, BorderSizePixel = 0, ZIndex = 501, ClipsDescendants = false }, _cmdGui)
	New("UICorner", { CornerRadius = UDim.new(0,12) }, panel)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, panel)
	local inputBg = New("Frame", { Size = UDim2.new(1,-16,0,42), Position = UDim2.new(0,8,0,9), BackgroundColor3 = Theme.CmdInput, BorderSizePixel = 0, ZIndex = 502 }, panel)
	New("UICorner", { CornerRadius = UDim.new(0,8) }, inputBg)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, inputBg)
	New("TextLabel", { Size = UDim2.new(0,18,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = "⌘", TextColor3 = Theme.TextMuted, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 503 }, inputBg)
	local searchBox = New("TextBox", { Size = UDim2.new(1,-40,1,0), Position = UDim2.new(0,30,0,0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Search commands...", PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text, TextSize = 14, Font = Enum.Font.Gotham, ClearTextOnFocus = false, ZIndex = 503 }, inputBg)
	local resultPanel = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,8), BackgroundColor3 = Theme.CmdBack, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 502, Visible = false }, panel)
	New("UICorner", { CornerRadius = UDim.new(0,10) }, resultPanel)
	New("UIStroke", { Color = Theme.Border, Thickness = 1 }, resultPanel)
	local resultList = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1 }, resultPanel)
	New("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder }, resultList)
	New("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4) }, resultList)
	local function BuildResults(query)
		for _, c in ipairs(resultList:GetChildren()) do if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end end
		local q = query:lower()
		local matched = {}
		for _, cmd in ipairs(commands) do
			if q == "" or cmd.Name:lower():find(q, 1, true) then table.insert(matched, cmd) if #matched >= 6 then break end end
		end
		if #matched == 0 then resultPanel.Visible = false Tween(resultPanel, { Size = UDim2.new(1,0,0,0) }, 0.15) return end
		resultPanel.Visible = true
		local h = #matched * 40 + 8
		Tween(resultPanel, { Size = UDim2.new(1,0,0,h) }, 0.18, Enum.EasingStyle.Quart)
		for _, cmd in ipairs(matched) do
			local row = New("TextButton", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.CmdResult, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 503 }, resultList)
			New("UICorner", { CornerRadius = UDim.new(0,6) }, row)
			New("TextLabel", { Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = cmd.Name, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 504 }, row)
			if cmd.Category then New("TextLabel", { Size = UDim2.new(0,80,1,0), Position = UDim2.new(1,-86,0,0), BackgroundTransparency = 1, Text = cmd.Category, TextColor3 = Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 504 }, row) end
			row.MouseEnter:Connect(function() Tween(row, { BackgroundColor3 = Theme.CmdResultHov }, 0.1) end)
			row.MouseLeave:Connect(function() Tween(row, { BackgroundColor3 = Theme.CmdResult }, 0.1) end)
			row.MouseButton1Click:Connect(function() CloseCmdPalette() if cmd.Callback then cmd.Callback() end end)
		end
	end
	searchBox.Changed:Connect(function(prop) if prop == "Text" then BuildResults(searchBox.Text) end end)
	task.defer(function() searchBox:CaptureFocus() end)
	local escConn
	escConn = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Escape then CloseCmdPalette() escConn:Disconnect() end
	end)
end

NexusUI.OpenCommandPalette = OpenCmdPalette
NexusUI.CloseCommandPalette = CloseCmdPalette

local function _buildComponent(TabFrame, compFuncs)

	function compFuncs:AddSectionHeader(cfg)
		cfg = cfg or {}
		local header = New("Frame", { Size = UDim2.new(1,0,0,30), BackgroundColor3 = Theme.SectionHead, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,6) }, header)
		New("UIStroke", { Color = Theme.SectionLine, Thickness = 1 }, header)
		New("TextLabel", { Size = UDim2.new(1,-16,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = cfg.Title or "Section", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left }, header)
		return header
	end

	function compFuncs:AddButton(cfg)
		cfg = cfg or {}
		local btn = New("TextButton", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, btn)
		New("UIStroke", { Color = Theme.Border, Thickness = 1 }, btn)
		local lbl = New("TextLabel", { Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Button", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, btn)
		local arrow = New("TextLabel", { Size = UDim2.new(0,24,1,0), Position = UDim2.new(1,-28,0,0), BackgroundTransparency = 1, Text = "›", TextColor3 = Theme.TextMuted, TextSize = 18, Font = Enum.Font.GothamBold }, btn)
		if cfg.Tooltip then AddTooltip(btn, cfg.Tooltip) end
		btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = Theme.Surface3 }, 0.12) Tween(arrow, { TextColor3 = Theme.White }, 0.12) end)
		btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = Theme.Surface2 }, 0.12) Tween(arrow, { TextColor3 = Theme.TextMuted }, 0.12) end)
		btn.MouseButton1Click:Connect(function()
			Tween(btn, { BackgroundColor3 = Theme.Surface }, 0.07)
			task.delay(0.07, function() Tween(btn, { BackgroundColor3 = Theme.Surface2 }, 0.12) end)
			if cfg.Callback then cfg.Callback() end
		end)
		if cfg.ContextMenu then
			btn.MouseButton2Click:Connect(function() local mp = UserInputService:GetMouseLocation() ShowContextMenu(cfg.ContextMenu, mp.X, mp.Y) end)
		end
		local obj = {}
		function obj:SetLabel(t) lbl.Text = t end
		function obj:SetEnabled(v) btn.Active = v Tween(btn, { BackgroundTransparency = v and 0 or 0.4 }, 0.15) Tween(lbl, { TextTransparency = v and 0 or 0.5 }, 0.15) end
		return obj
	end

	function compFuncs:AddToggle(cfg)
		cfg = cfg or {}
		local state = cfg.Default or false
		local row = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Toggle", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local track = New("Frame", { Size = UDim2.new(0,38,0,20), Position = UDim2.new(1,-52,0.5,-10), BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, track)
		local knob = New("Frame", { Size = UDim2.new(0,14,0,14), Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7), BackgroundColor3 = state and Theme.Background or Theme.TextDim, BorderSizePixel = 0 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, knob)
		local click = New("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "" }, row)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		local function SetState(v, silent)
			state = v
			Tween(track, { BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff }, 0.2)
			Tween(knob, { Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7), BackgroundColor3 = state and Theme.Background or Theme.TextDim }, 0.2, Enum.EasingStyle.Back)
			if not silent and cfg.Callback then cfg.Callback(state) end
		end
		click.MouseButton1Click:Connect(function() SetState(not state) end)
		local obj = {}
		function obj:Set(v, silent) SetState(v, silent) end
		function obj:Get() return state end
		function obj:Toggle() SetState(not state) end
		return obj
	end

	function compFuncs:AddSlider(cfg)
		cfg = cfg or {}
		local Min, Max = cfg.Min or 0, cfg.Max or 100
		local step = cfg.Step or 1
		local val = Clamp(cfg.Default or Min, Min, Max)
		local row = New("Frame", { Size = UDim2.new(1,0,0,52), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-80,0,26), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Slider", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local valLbl = New("TextLabel", { Size = UDim2.new(0,70,0,26), Position = UDim2.new(1,-80,0,0), BackgroundTransparency = 1, Text = tostring(val)..(cfg.Suffix or ""), TextColor3 = Theme.TextDim, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right }, row)
		local track = New("Frame", { Size = UDim2.new(1,-28,0,4), Position = UDim2.new(0,14,1,-14), BackgroundColor3 = Theme.SliderBack, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, track)
		local pct0 = (val - Min) / (Max - Min)
		local fill = New("Frame", { Size = UDim2.new(pct0,0,1,0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, fill)
		local knob = New("Frame", { Size = UDim2.new(0,12,0,12), Position = UDim2.new(pct0,-6,0.5,-6), BackgroundColor3 = Theme.White, BorderSizePixel = 0 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, knob)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		local dragging = false
		track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
		UserInputService.InputChanged:Connect(function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				local rel = Clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				val = Clamp(Round(Min + (Max - Min) * rel, step), Min, Max)
				local p = (val - Min) / (Max - Min)
				Tween(fill, { Size = UDim2.new(p,0,1,0) }, 0.05) Tween(knob, { Position = UDim2.new(p,-6,0.5,-6) }, 0.05)
				valLbl.Text = tostring(val)..(cfg.Suffix or "")
				if cfg.Callback then cfg.Callback(val) end
			end
		end)
		local obj = {}
		function obj:Set(v) val = Clamp(v,Min,Max) local p=(val-Min)/(Max-Min) Tween(fill,{Size=UDim2.new(p,0,1,0)},0.2) Tween(knob,{Position=UDim2.new(p,-6,0.5,-6)},0.2) valLbl.Text=tostring(val)..(cfg.Suffix or "") if cfg.Callback then cfg.Callback(val) end end
		function obj:Get() return val end
		return obj
	end

	function compFuncs:AddRangeSlider(cfg)
		cfg = cfg or {}
		local Min, Max = cfg.Min or 0, cfg.Max or 100
		local step = cfg.Step or 1
		local lo = Clamp(cfg.DefaultLow or Min, Min, Max)
		local hi = Clamp(cfg.DefaultHigh or Max, Min, Max)
		if lo > hi then lo, hi = hi, lo end
		local row = New("Frame", { Size = UDim2.new(1,0,0,52), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-120,0,26), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Range", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local rangeLbl = New("TextLabel", { Size = UDim2.new(0,110,0,26), Position = UDim2.new(1,-116,0,0), BackgroundTransparency = 1, Text = tostring(lo).." – "..tostring(hi)..(cfg.Suffix or ""), TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right }, row)
		local track = New("Frame", { Size = UDim2.new(1,-28,0,4), Position = UDim2.new(0,14,1,-14), BackgroundColor3 = Theme.RangeBack, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, track)
		local loP = (lo-Min)/(Max-Min) local hiP = (hi-Min)/(Max-Min)
		local fill = New("Frame", { Size = UDim2.new(hiP-loP,0,1,0), Position = UDim2.new(loP,0,0,0), BackgroundColor3 = Theme.RangeFill, BorderSizePixel = 0 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, fill)
		local knobLo = New("Frame", { Size = UDim2.new(0,14,0,14), Position = UDim2.new(loP,-7,0.5,-7), BackgroundColor3 = Theme.White, BorderSizePixel = 0, ZIndex = 2 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, knobLo) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, knobLo)
		local knobHi = New("Frame", { Size = UDim2.new(0,14,0,14), Position = UDim2.new(hiP,-7,0.5,-7), BackgroundColor3 = Theme.White, BorderSizePixel = 0, ZIndex = 2 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, knobHi) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, knobHi)
		local function UpdateFill()
			local lp=(lo-Min)/(Max-Min) local hp=(hi-Min)/(Max-Min)
			fill.Position=UDim2.new(lp,0,0,0) fill.Size=UDim2.new(hp-lp,0,1,0)
			knobLo.Position=UDim2.new(lp,-7,0.5,-7) knobHi.Position=UDim2.new(hp,-7,0.5,-7)
			rangeLbl.Text=tostring(lo).." – "..tostring(hi)..(cfg.Suffix or "")
		end
		local dLo, dHi = false, false
		knobLo.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dLo=true end end)
		knobHi.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dHi=true end end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dLo=false dHi=false end end)
		UserInputService.InputChanged:Connect(function(i)
			if not (dLo or dHi) or i.UserInputType~=Enum.UserInputType.MouseMovement then return end
			local rel=Clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
			local snapped=Clamp(Round(Min+(Max-Min)*rel,step),Min,Max)
			if dLo then lo=math.min(snapped,hi-step) lo=Clamp(lo,Min,Max)
			else hi=math.max(snapped,lo+step) hi=Clamp(hi,Min,Max) end
			UpdateFill() if cfg.Callback then cfg.Callback(lo,hi) end
		end)
		local obj = {}
		function obj:Set(nLo,nHi) lo=Clamp(nLo,Min,Max) hi=Clamp(nHi,Min,Max) if lo>hi then lo,hi=hi,lo end UpdateFill() if cfg.Callback then cfg.Callback(lo,hi) end end
		function obj:GetLow() return lo end function obj:GetHigh() return hi end
		return obj
	end

	function compFuncs:AddInput(cfg)
		cfg = cfg or {}
		local row = New("Frame", { Size = UDim2.new(1,0,0,52), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		local stroke = New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-16,0,22), Position = UDim2.new(0,14,0,4), BackgroundTransparency = 1, Text = cfg.Name or "Input", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local inputBg = New("Frame", { Size = UDim2.new(1,-28,0,22), Position = UDim2.new(0,14,0,26), BackgroundColor3 = Theme.InputBack, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, inputBg)
		local box = New("TextBox", { Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,6,0,0), BackgroundTransparency = 1, Text = cfg.Default or "", PlaceholderText = cfg.Placeholder or "Enter value...", PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false }, inputBg)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		box.Focused:Connect(function() Tween(stroke, { Color = Theme.BorderBright }, 0.15) end)
		box.FocusLost:Connect(function(enter) Tween(stroke, { Color = Theme.Border }, 0.15) if cfg.Callback then cfg.Callback(box.Text, enter) end end)
		local obj = {}
		function obj:Get() return box.Text end function obj:Set(v) box.Text = v end function obj:Clear() box.Text = "" end
		return obj
	end

	function compFuncs:AddNumberInput(cfg)
		cfg = cfg or {}
		local Min = cfg.Min or -math.huge local Max = cfg.Max or math.huge local step = cfg.Step or 1 local val = cfg.Default or 0
		local row = New("Frame", { Size = UDim2.new(1,0,0,52), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		local stroke = New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-100,0,22), Position = UDim2.new(0,14,0,4), BackgroundTransparency = 1, Text = cfg.Name or "Number", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local inputBg = New("Frame", { Size = UDim2.new(1,-28,0,22), Position = UDim2.new(0,14,0,26), BackgroundColor3 = Theme.InputBack, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, inputBg)
		local decBtn = New("TextButton", { Size = UDim2.new(0,22,1,0), BackgroundColor3 = Theme.Surface3, Text = "−", TextColor3 = Theme.TextDim, TextSize = 14, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false }, inputBg)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, decBtn)
		local incBtn = New("TextButton", { Size = UDim2.new(0,22,1,0), Position = UDim2.new(1,-22,0,0), BackgroundColor3 = Theme.Surface3, Text = "+", TextColor3 = Theme.TextDim, TextSize = 14, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false }, inputBg)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, incBtn)
		local box = New("TextBox", { Size = UDim2.new(1,-48,1,0), Position = UDim2.new(0,24,0,0), BackgroundTransparency = 1, Text = tostring(val), TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false }, inputBg)
		local function UpdateVal(v) val=Clamp(v,Min,Max) box.Text=tostring(val) if cfg.Callback then cfg.Callback(val) end end
		box.Focused:Connect(function() Tween(stroke, { Color = Theme.BorderBright }, 0.15) end)
		box.FocusLost:Connect(function() Tween(stroke, { Color = Theme.Border }, 0.15) local n=tonumber(box.Text) if n then UpdateVal(n) else box.Text=tostring(val) end end)
		decBtn.MouseButton1Click:Connect(function() UpdateVal(val-step) end)
		incBtn.MouseButton1Click:Connect(function() UpdateVal(val+step) end)
		local obj = {}
		function obj:Get() return val end function obj:Set(v) UpdateVal(v) end
		return obj
	end

	function compFuncs:AddDropdown(cfg)
		cfg = cfg or {}
		local opts = cfg.Options or {} local sel = cfg.Default or (opts[1] or "") local open = false
		local wrap = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false }, TabFrame)
		local row = New("TextButton", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 2 }, wrap)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(0,100,0.5,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Dropdown", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3 }, row)
		local selLbl = New("TextLabel", { Size = UDim2.new(1,-60,0.5,0), Position = UDim2.new(0,14,0.5,0), BackgroundTransparency = 1, Text = sel, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3 }, row)
		local chev = New("TextLabel", { Size = UDim2.new(0,24,1,0), Position = UDim2.new(1,-28,0,0), BackgroundTransparency = 1, Text = "⌄", TextColor3 = Theme.TextDim, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 3 }, row)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		local dropH = #opts * 32 + 12
		local drop = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,4), BackgroundColor3 = Theme.Surface3, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 10, Visible = false }, wrap)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, drop) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, drop)
		local dList = New("Frame", { Size = UDim2.new(1,0,0,dropH), BackgroundTransparency = 1 }, drop)
		New("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder }, dList)
		New("UIPadding", { PaddingTop = UDim.new(0,4), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,4) }, dList)
		local function Rebuild(newOpts)
			opts = newOpts
			for _, c in ipairs(dList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
			dropH = #opts * 32 + 12 dList.Size = UDim2.new(1,0,0,dropH)
			for _, opt in ipairs(opts) do
				local ob = New("TextButton", { Size = UDim2.new(1,0,0,30), BackgroundColor3 = Theme.Surface3, Text = opt, TextColor3 = opt==sel and Theme.White or Theme.TextDim, TextSize = 13, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 11 }, dList)
				New("UICorner", { CornerRadius = UDim.new(0,6) }, ob)
				ob.MouseEnter:Connect(function() Tween(ob, { BackgroundColor3 = Theme.Surface, TextColor3 = Theme.White }, 0.1) end)
				ob.MouseLeave:Connect(function() Tween(ob, { BackgroundColor3 = Theme.Surface3, TextColor3 = opt==sel and Theme.White or Theme.TextDim }, 0.1) end)
				ob.MouseButton1Click:Connect(function()
					sel=opt selLbl.Text=opt open=false
					Tween(drop, { Size = UDim2.new(1,0,0,0) }, 0.2, Enum.EasingStyle.Quart) Tween(chev, { Rotation = 0 }, 0.2)
					wrap.Size=UDim2.new(1,0,0,38) task.delay(0.2, function() drop.Visible=false end)
					if cfg.Callback then cfg.Callback(opt) end
				end)
			end
		end
		Rebuild(opts)
		row.MouseButton1Click:Connect(function()
			open = not open
			if open then drop.Visible=true wrap.Size=UDim2.new(1,0,0,38+dropH+4) Tween(drop,{Size=UDim2.new(1,0,0,dropH)},0.22,Enum.EasingStyle.Quart) Tween(chev,{Rotation=180},0.2)
			else Tween(drop,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart) Tween(chev,{Rotation=0},0.18) wrap.Size=UDim2.new(1,0,0,38) task.delay(0.2,function() drop.Visible=false end) end
		end)
		local obj = {}
		function obj:Get() return sel end function obj:Set(v) sel=v selLbl.Text=v end function obj:SetOptions(newOpts) Rebuild(newOpts) end
		return obj
	end

	function compFuncs:AddMultiSelect(cfg)
		cfg = cfg or {}
		local opts = cfg.Options or {} local selected = {} local open = false
		if cfg.Default then for _,v in ipairs(cfg.Default) do if TableContains(opts,v) then table.insert(selected,v) end end end
		local function SelText() if #selected==0 then return cfg.Placeholder or "Select..." end if #selected==1 then return selected[1] end return #selected.." selected" end
		local wrap = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false }, TabFrame)
		local row = New("TextButton", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 2 }, wrap)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(0,100,0.5,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "MultiSelect", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3 }, row)
		local selLbl = New("TextLabel", { Size = UDim2.new(1,-60,0.5,0), Position = UDim2.new(0,14,0.5,0), BackgroundTransparency = 1, Text = SelText(), TextColor3 = #selected>0 and Theme.Text or Theme.TextMuted, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3 }, row)
		local chev = New("TextLabel", { Size = UDim2.new(0,24,1,0), Position = UDim2.new(1,-28,0,0), BackgroundTransparency = 1, Text = "⌄", TextColor3 = Theme.TextDim, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 3 }, row)
		local dropH = #opts * 34 + 12
		local drop = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,4), BackgroundColor3 = Theme.Surface3, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 10, Visible = false }, wrap)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, drop) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, drop)
		local dList = New("Frame", { Size = UDim2.new(1,0,0,dropH), BackgroundTransparency = 1 }, drop)
		New("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder }, dList)
		New("UIPadding", { PaddingTop = UDim.new(0,4), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,4) }, dList)
		local optBtns = {}
		local function UpdateCheck(opt, btn) local isOn=TableContains(selected,opt) local chkBg=btn:FindFirstChild("_chk") if chkBg then Tween(chkBg,{BackgroundColor3=isOn and Theme.CheckFill or Theme.Surface4},0.1) end Tween(btn,{TextColor3=isOn and Theme.White or Theme.TextDim},0.1) end
		for _, opt in ipairs(opts) do
			local ob = New("TextButton", { Size = UDim2.new(1,0,0,30), BackgroundColor3 = Theme.Surface3, Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 11 }, dList)
			New("UICorner", { CornerRadius = UDim.new(0,6) }, ob)
			local isOn = TableContains(selected, opt)
			local chkBg = New("Frame", { Name = "_chk", Size = UDim2.new(0,16,0,16), Position = UDim2.new(0,8,0.5,-8), BackgroundColor3 = isOn and Theme.CheckFill or Theme.Surface4, BorderSizePixel = 0, ZIndex = 12 }, ob)
			New("UICorner", { CornerRadius = UDim.new(0,4) }, chkBg) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, chkBg)
			New("TextLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "✓", TextColor3 = Theme.Background, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 13 }, chkBg)
			New("TextLabel", { Size = UDim2.new(1,-34,1,0), Position = UDim2.new(0,30,0,0), BackgroundTransparency = 1, Text = opt, TextColor3 = isOn and Theme.White or Theme.TextDim, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12 }, ob)
			ob.MouseEnter:Connect(function() Tween(ob,{BackgroundColor3=Theme.Surface},0.1) end)
			ob.MouseLeave:Connect(function() Tween(ob,{BackgroundColor3=Theme.Surface3},0.1) end)
			ob.MouseButton1Click:Connect(function()
				if TableContains(selected,opt) then TableRemove(selected,opt) else table.insert(selected,opt) end
				UpdateCheck(opt,ob) selLbl.Text=SelText() selLbl.TextColor3=#selected>0 and Theme.Text or Theme.TextMuted
				if cfg.Callback then cfg.Callback(selected) end
			end)
			optBtns[opt] = ob
		end
		row.MouseButton1Click:Connect(function()
			open=not open
			if open then drop.Visible=true wrap.Size=UDim2.new(1,0,0,38+dropH+4) Tween(drop,{Size=UDim2.new(1,0,0,dropH)},0.22,Enum.EasingStyle.Quart) Tween(chev,{Rotation=180},0.2)
			else Tween(drop,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart) Tween(chev,{Rotation=0},0.18) wrap.Size=UDim2.new(1,0,0,38) task.delay(0.2,function() drop.Visible=false end) end
		end)
		local obj = {}
		function obj:Get() return DeepCopy(selected) end
		function obj:Set(arr) selected={} for _,v in ipairs(arr) do if TableContains(opts,v) then table.insert(selected,v) end end for opt,btn in pairs(optBtns) do UpdateCheck(opt,btn) end selLbl.Text=SelText() selLbl.TextColor3=#selected>0 and Theme.Text or Theme.TextMuted end
		function obj:Clear() selected={} for opt,btn in pairs(optBtns) do UpdateCheck(opt,btn) end selLbl.Text=SelText() selLbl.TextColor3=Theme.TextMuted end
		return obj
	end

	function compFuncs:AddColorPicker(cfg)
		cfg = cfg or {}
		local col = cfg.Default or Color3.fromRGB(255,255,255)
		local row = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-90,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Color", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local hexLbl = New("TextLabel", { Size = UDim2.new(0,52,1,0), Position = UDim2.new(1,-88,0,0), BackgroundTransparency = 1, Text = ColorToHex(col), TextColor3 = Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right }, row)
		local prev = New("Frame", { Size = UDim2.new(0,28,0,20), Position = UDim2.new(1,-42,0.5,-10), BackgroundColor3 = col, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(0,5) }, prev) New("UIStroke", { Color = Theme.BorderBright, Thickness = 1 }, prev)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		local obj = {}
		function obj:Set(c) col=c prev.BackgroundColor3=c hexLbl.Text=ColorToHex(c) if cfg.Callback then cfg.Callback(c) end end
		function obj:Get() return col end function obj:GetHex() return ColorToHex(col) end
		return obj
	end

	function compFuncs:AddKeybind(cfg)
		cfg = cfg or {}
		local key = cfg.Default or Enum.KeyCode.Unknown local listening = false
		local row = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-100,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Keybind", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local kbtn = New("TextButton", { Size = UDim2.new(0,78,0,24), Position = UDim2.new(1,-88,0.5,-12), BackgroundColor3 = Theme.Surface3, Text = key.Name, TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false }, row)
		New("UICorner", { CornerRadius = UDim.new(0,5) }, kbtn) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, kbtn)
		if cfg.Tooltip then AddTooltip(row, cfg.Tooltip) end
		kbtn.MouseButton1Click:Connect(function() listening=true kbtn.Text="..." kbtn.TextColor3=Theme.White Tween(kbtn,{BackgroundColor3=Theme.Surface4},0.1) end)
		UserInputService.InputBegan:Connect(function(i, gp)
			if listening and not gp and i.UserInputType==Enum.UserInputType.Keyboard then
				key=i.KeyCode kbtn.Text=key.Name kbtn.TextColor3=Theme.TextDim listening=false Tween(kbtn,{BackgroundColor3=Theme.Surface3},0.1)
				if cfg.Callback then cfg.Callback(key) end
			elseif not listening and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==key then
				if cfg.OnPress then cfg.OnPress() end
			end
		end)
		local obj = {}
		function obj:Get() return key end function obj:Set(k) key=k kbtn.Text=k.Name end
		return obj
	end

	function compFuncs:AddLabel(cfg)
		cfg = cfg or {}
		local lbl = New("TextLabel", { Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, Text = cfg.Text or "", RichText = cfg.RichText or false, TextColor3 = cfg.Color or Theme.TextDim, TextSize = cfg.TextSize or 12, Font = cfg.Font or Enum.Font.Gotham, TextXAlignment = cfg.Align or Enum.TextXAlignment.Left, TextWrapped = cfg.Wrap or false }, TabFrame)
		New("UIPadding", { PaddingLeft = UDim.new(0,4) }, lbl)
		local obj = {}
		function obj:Set(t) lbl.Text = t end function obj:SetColor(c) lbl.TextColor3 = c end
		return obj
	end

	function compFuncs:AddSeparator()
		New("Frame", { Size = UDim2.new(1,0,0,1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 }, TabFrame)
	end

	function compFuncs:AddParagraph(cfg)
		cfg = cfg or {}
		local row = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("UIPadding", { PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14) }, row)
		local inner = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y }, row)
		New("UIListLayout", { Padding = UDim.new(0,4) }, inner)
		if cfg.Title then New("TextLabel", { Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = cfg.Title, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left }, inner) end
		local contentLbl = New("TextLabel", { Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Text = cfg.Content or "", TextColor3 = Theme.TextDim, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y }, inner)
		local obj = {}
		function obj:SetContent(t) contentLbl.Text = t end
		return obj
	end

	function compFuncs:AddProgressBar(cfg)
		cfg = cfg or {}
		local val = Clamp(cfg.Default or 0, 0, 100)
		local row = New("Frame", { Size = UDim2.new(1,0,0,46), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-60,0,24), Position = UDim2.new(0,14,0,2), BackgroundTransparency = 1, Text = cfg.Name or "Progress", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local pctLbl = New("TextLabel", { Size = UDim2.new(0,50,0,24), Position = UDim2.new(1,-58,0,2), BackgroundTransparency = 1, Text = tostring(val).."%", TextColor3 = Theme.TextDim, TextSize = 12, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right }, row)
		local track = New("Frame", { Size = UDim2.new(1,-28,0,6), Position = UDim2.new(0,14,0,30), BackgroundColor3 = Theme.SliderBack, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, track)
		local fill = New("Frame", { Size = UDim2.new(val/100,0,1,0), BackgroundColor3 = cfg.Color or Theme.ProgressFill, BorderSizePixel = 0 }, track)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, fill)
		local obj = {}
		function obj:Set(v) val=Clamp(v,0,100) Tween(fill,{Size=UDim2.new(val/100,0,1,0)},0.25) pctLbl.Text=tostring(math.floor(val)).."%" end
		function obj:Get() return val end function obj:SetColor(c) Tween(fill,{BackgroundColor3=c},0.2) end
		return obj
	end

	function compFuncs:AddBadge(cfg)
		cfg = cfg or {}
		local colMap = { Red=Theme.BadgeRed, Green=Theme.BadgeGreen, Blue=Theme.BadgeBlue, Yellow=Theme.BadgeYellow }
		local bgCol = colMap[cfg.Color] or Theme.Surface3
		local row = New("Frame", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-90,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local badge = New("Frame", { Size = UDim2.new(0,0,0,20), Position = UDim2.new(1,-16,0.5,-10), AnchorPoint = Vector2.new(1,0), BackgroundColor3 = bgCol, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, badge)
		New("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8) }, badge)
		local badgeLbl = New("TextLabel", { Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = cfg.Label or "", TextColor3 = Theme.White, TextSize = 11, Font = Enum.Font.GothamBold }, badge)
		local obj = {}
		function obj:SetLabel(t) badgeLbl.Text=t end
		function obj:SetColor(name) Tween(badge,{BackgroundColor3=colMap[name] or Theme.Surface3},0.2) end
		return obj
	end

	function compFuncs:AddStatusIndicator(cfg)
		cfg = cfg or {}
		local states = { Online=Theme.StatusOnline, Busy=Theme.StatusBusy, Offline=Theme.StatusOff }
		local cur = cfg.Default or "Offline"
		local row = New("Frame", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-80,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Status", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local dot = New("Frame", { Size = UDim2.new(0,10,0,10), Position = UDim2.new(1,-46,0.5,-5), BackgroundColor3 = states[cur] or Theme.StatusOff, BorderSizePixel = 0 }, row)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, dot)
		local statLbl = New("TextLabel", { Size = UDim2.new(0,50,1,0), Position = UDim2.new(1,-50,0,0), BackgroundTransparency = 1, Text = cur, TextColor3 = states[cur] or Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local obj = {}
		function obj:Set(s) cur=s local c=states[s] or Theme.StatusOff Tween(dot,{BackgroundColor3=c},0.2) Tween(statLbl,{TextColor3=c},0.2) statLbl.Text=s end
		function obj:Get() return cur end
		return obj
	end

	function compFuncs:AddAccordion(cfg)
		cfg = cfg or {}
		local expanded = cfg.Expanded or false local contentH = cfg.ContentHeight or 80
		local outer = New("Frame", { Size = UDim2.new(1,0,0,expanded and 38+contentH or 38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, ClipsDescendants = true }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, outer) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, outer)
		local header = New("TextButton", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.AccordHead, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, outer)
		New("TextLabel", { Size = UDim2.new(1,-44,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Title or "Section", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left }, header)
		local chevron = New("TextLabel", { Size = UDim2.new(0,24,1,0), Position = UDim2.new(1,-30,0,0), BackgroundTransparency = 1, Text = "⌄", TextColor3 = Theme.TextDim, TextSize = 14, Font = Enum.Font.GothamBold, Rotation = expanded and 180 or 0 }, header)
		local body = New("Frame", { Size = UDim2.new(1,0,0,contentH), Position = UDim2.new(0,0,0,38), BackgroundColor3 = Theme.AccordBody, BorderSizePixel = 0 }, outer)
		New("UIPadding", { PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }, body)
		if cfg.Content then New("TextLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = cfg.Content, TextColor3 = Theme.TextDim, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true }, body) end
		header.MouseButton1Click:Connect(function()
			expanded=not expanded Tween(outer,{Size=UDim2.new(1,0,0,expanded and 38+contentH or 38)},0.25,Enum.EasingStyle.Quart) Tween(chevron,{Rotation=expanded and 180 or 0},0.2)
		end)
		header.MouseEnter:Connect(function() Tween(header,{BackgroundColor3=Theme.Surface3},0.1) end)
		header.MouseLeave:Connect(function() Tween(header,{BackgroundColor3=Theme.AccordHead},0.1) end)
		local obj = {}
		function obj:GetBody() return body end
		function obj:SetExpanded(v) expanded=v Tween(outer,{Size=UDim2.new(1,0,0,v and 38+contentH or 38)},0.25,Enum.EasingStyle.Quart) Tween(chevron,{Rotation=v and 180 or 0},0.2) end
		return obj
	end

	function compFuncs:AddTable(cfg)
		cfg = cfg or {}
		local columns = cfg.Columns or {} local rows = cfg.Rows or {} local rowH = cfg.RowHeight or 30 local headH = 32
		local totalH = headH + #rows * rowH + 2
		local container = New("Frame", { Size = UDim2.new(1,0,0,totalH), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, ClipsDescendants = true }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, container) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, container)
		local header = New("Frame", { Size = UDim2.new(1,0,0,headH), BackgroundColor3 = Theme.TableHead, BorderSizePixel = 0 }, container)
		New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder }, header)
		local colW = 1 / math.max(1, #columns)
		for _, col in ipairs(columns) do
			local lbl = New("TextLabel", { Size = UDim2.new(colW,0,1,0), BackgroundTransparency = 1, Text = col, TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, header)
			New("UIPadding", { PaddingLeft = UDim.new(0,10) }, lbl)
		end
		local listFrame = New("Frame", { Size = UDim2.new(1,0,0,#rows*rowH), Position = UDim2.new(0,0,0,headH), BackgroundTransparency = 1 }, container)
		New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, listFrame)
		for i, row in ipairs(rows) do
			local rowFrame = New("Frame", { Size = UDim2.new(1,0,0,rowH), BackgroundColor3 = i%2==0 and Theme.TableRowAlt or Theme.TableRow, BorderSizePixel = 0 }, listFrame)
			New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder }, rowFrame)
			for _, cell in ipairs(row) do
				local cellLbl = New("TextLabel", { Size = UDim2.new(colW,0,1,0), BackgroundTransparency = 1, Text = tostring(cell), TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, rowFrame)
				New("UIPadding", { PaddingLeft = UDim.new(0,10) }, cellLbl)
			end
		end
		local obj = {}
		function obj:GetContainer() return container end
		return obj
	end

	function compFuncs:AddCodeBlock(cfg)
		cfg = cfg or {}
		local code = cfg.Code or "" local H = cfg.Height or 120
		local outer = New("Frame", { Size = UDim2.new(1,0,0,H+28), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, outer) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, outer)
		local topBar = New("Frame", { Size = UDim2.new(1,0,0,28), BackgroundColor3 = Theme.CodeBack, BorderSizePixel = 0 }, outer)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, topBar)
		New("Frame", { Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0), BackgroundColor3 = Theme.CodeBack, BorderSizePixel = 0 }, topBar)
		New("TextLabel", { Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = cfg.Language or "Lua", TextColor3 = Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, topBar)
		local copyBtn = New("TextButton", { Size = UDim2.new(0,50,0,20), Position = UDim2.new(1,-56,0.5,-10), BackgroundColor3 = Theme.Surface3, Text = "Copy", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false }, topBar)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, copyBtn)
		local codeScroll = New("ScrollingFrame", { Size = UDim2.new(1,0,0,H), Position = UDim2.new(0,0,0,28), BackgroundColor3 = Theme.CodeBack, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.ScrollBar, CanvasSize = UDim2.new(0,0,0,0) }, outer)
		local codeLbl = New("TextLabel", { Size = UDim2.new(1,-16,0,0), Position = UDim2.new(0,12,0,8), BackgroundTransparency = 1, Text = code, TextColor3 = Theme.DebugText, TextSize = 12, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = false, AutomaticSize = Enum.AutomaticSize.Y }, codeScroll)
		codeLbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() codeScroll.CanvasSize=UDim2.new(0,0,0,codeLbl.AbsoluteSize.Y+16) end)
		copyBtn.MouseButton1Click:Connect(function()
			local ok=pcall(function() setclipboard(code) end)
			copyBtn.Text=ok and "Copied!" or "Error" task.delay(1.5, function() copyBtn.Text="Copy" end)
		end)
		copyBtn.MouseEnter:Connect(function() Tween(copyBtn,{BackgroundColor3=Theme.Surface4},0.1) end)
		copyBtn.MouseLeave:Connect(function() Tween(copyBtn,{BackgroundColor3=Theme.Surface3},0.1) end)
		local obj = {}
		function obj:SetCode(c) code=c codeLbl.Text=c end function obj:GetCode() return code end
		return obj
	end

	function compFuncs:AddSearchBox(cfg)
		cfg = cfg or {}
		local row = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row)
		local stroke = New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(0,20,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14, Font = Enum.Font.Gotham, TextColor3 = Theme.TextMuted }, row)
		local box = New("TextBox", { Size = UDim2.new(1,-44,1,0), Position = UDim2.new(0,34,0,0), BackgroundTransparency = 1, Text = "", PlaceholderText = cfg.Placeholder or "Search...", PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false }, row)
		local clearBtn = New("TextButton", { Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-28,0.5,-10), BackgroundTransparency = 1, Text = "✕", TextColor3 = Theme.TextMuted, TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false, Visible = false }, row)
		box.Focused:Connect(function() Tween(stroke,{Color=Theme.BorderBright},0.15) end)
		box.FocusLost:Connect(function() Tween(stroke,{Color=Theme.Border},0.15) if cfg.OnFocusLost then cfg.OnFocusLost(box.Text) end end)
		box.Changed:Connect(function(prop) if prop=="Text" then clearBtn.Visible=#box.Text>0 if cfg.Callback then cfg.Callback(box.Text) end end end)
		clearBtn.MouseButton1Click:Connect(function() box.Text="" clearBtn.Visible=false if cfg.Callback then cfg.Callback("") end end)
		local obj = {}
		function obj:Get() return box.Text end function obj:Set(v) box.Text=v clearBtn.Visible=#v>0 end function obj:Clear() box.Text="" clearBtn.Visible=false end
		return obj
	end

	function compFuncs:AddDebugConsole(cfg)
		cfg = cfg or {}
		local H = cfg.Height or 140 local lines = {} local maxLines = cfg.MaxLines or 200
		local outer = New("Frame", { Size = UDim2.new(1,0,0,H+28), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, outer) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, outer)
		local topBar = New("Frame", { Size = UDim2.new(1,0,0,28), BackgroundColor3 = Theme.DebugBack, BorderSizePixel = 0 }, outer)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, topBar)
		New("Frame", { Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0), BackgroundColor3 = Theme.DebugBack, BorderSizePixel = 0 }, topBar)
		New("TextLabel", { Size = UDim2.new(1,-90,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Debug Console", TextColor3 = Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, topBar)
		local clearBtn = New("TextButton", { Size = UDim2.new(0,50,0,20), Position = UDim2.new(1,-56,0.5,-10), BackgroundColor3 = Theme.Surface3, Text = "Clear", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false }, topBar)
		New("UICorner", { CornerRadius = UDim.new(0,4) }, clearBtn)
		local scroll = New("ScrollingFrame", { Size = UDim2.new(1,0,0,H), Position = UDim2.new(0,0,0,28), BackgroundColor3 = Theme.DebugBack, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.ScrollBar, CanvasSize = UDim2.new(0,0,0,0) }, outer)
		local listLayout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,1) }, scroll)
		New("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8) }, scroll)
		listLayout.Changed:Connect(function() scroll.CanvasSize=UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+8) scroll.CanvasPosition=Vector2.new(0,math.max(0,listLayout.AbsoluteContentSize.Y-H+8)) end)
		local colorMap = { Log=Theme.DebugText, Error=Theme.DebugErr, Warn=Theme.DebugWarn, Info=Theme.DebugInfo }
		local prefix = { Log="› ", Error="✖ ", Warn="⚠ ", Info="ℹ " }
		local function AppendLine(text, level)
			level = level or "Log"
			table.insert(lines, { text=text, level=level })
			if #lines > maxLines then table.remove(lines,1) local first=scroll:FindFirstChildWhichIsA("TextLabel") if first then first:Destroy() end end
			New("TextLabel", { Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = (prefix[level] or "  ")..text, TextColor3 = colorMap[level] or Theme.DebugText, TextSize = 11, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, LayoutOrder = #lines }, scroll)
		end
		clearBtn.MouseButton1Click:Connect(function() lines={} for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end end)
		clearBtn.MouseEnter:Connect(function() Tween(clearBtn,{BackgroundColor3=Theme.Surface4},0.1) end)
		clearBtn.MouseLeave:Connect(function() Tween(clearBtn,{BackgroundColor3=Theme.Surface3},0.1) end)
		local obj = {}
		function obj:Log(t)   AppendLine(t,"Log")   end function obj:Error(t) AppendLine(t,"Error") end
		function obj:Warn(t)  AppendLine(t,"Warn")  end function obj:Info(t)  AppendLine(t,"Info")  end
		function obj:Clear() lines={} for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end end
		function obj:GetLines() return DeepCopy(lines) end
		return obj
	end

	function compFuncs:AddSpinner(cfg)
		cfg = cfg or {}
		local row = New("Frame", { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0 }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, row) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, row)
		New("TextLabel", { Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = cfg.Name or "Loading", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, row)
		local spinLbl = New("TextLabel", { Size = UDim2.new(0,24,0,24), Position = UDim2.new(1,-36,0.5,-12), BackgroundTransparency = 1, Text = "⟳", TextColor3 = Theme.SpinnerCol, TextSize = 18, Font = Enum.Font.GothamBold }, row)
		local spinning = cfg.Active ~= false local conn = nil
		if spinning then conn = RunService.Heartbeat:Connect(function(dt) spinLbl.Rotation = spinLbl.Rotation + dt * 300 end) end
		local obj = {}
		function obj:SetActive(v)
			spinning = v
			if v and not conn then conn = RunService.Heartbeat:Connect(function(dt) spinLbl.Rotation = spinLbl.Rotation + dt * 300 end)
			elseif not v and conn then conn:Disconnect() conn = nil end
		end
		function obj:IsActive() return spinning end
		return obj
	end

	function compFuncs:AddRadioGroup(cfg)
		cfg = cfg or {}
		local opts = cfg.Options or {} local sel = cfg.Default or (opts[1] or nil)
		local container = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, container) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, container)
		if cfg.Name then New("TextLabel", { Size = UDim2.new(1,-16,0,26), Position = UDim2.new(0,14,0,4), BackgroundTransparency = 1, Text = cfg.Name, TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, container) end
		local list = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,cfg.Name and 28 or 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y }, container)
		New("UIListLayout", { Padding = UDim.new(0,0), SortOrder = Enum.SortOrder.LayoutOrder }, list)
		local radioBtns = {}
		local function UpdateRadios() for opt, parts in pairs(radioBtns) do local isOn=opt==sel Tween(parts.outer,{BackgroundColor3=isOn and Theme.RadioFill or Theme.Surface3},0.15) Tween(parts.inner,{Size=isOn and UDim2.new(0,8,0,8) or UDim2.new(0,0,0,0)},0.15) Tween(parts.lbl,{TextColor3=isOn and Theme.Text or Theme.TextDim},0.15) end end
		for i, opt in ipairs(opts) do
			local btn = New("TextButton", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = Theme.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, list)
			local outer = New("Frame", { Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,14,0.5,-9), BackgroundColor3 = opt==sel and Theme.RadioFill or Theme.Surface3, BorderSizePixel = 0 }, btn)
			New("UICorner", { CornerRadius = UDim.new(1,0) }, outer) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, outer)
			local inner = New("Frame", { Size = opt==sel and UDim2.new(0,8,0,8) or UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0 }, outer)
			New("UICorner", { CornerRadius = UDim.new(1,0) }, inner)
			local lbl = New("TextLabel", { Size = UDim2.new(1,-44,1,0), Position = UDim2.new(0,40,0,0), BackgroundTransparency = 1, Text = opt, TextColor3 = opt==sel and Theme.Text or Theme.TextDim, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, btn)
			radioBtns[opt] = { outer=outer, inner=inner, lbl=lbl }
			if i < #opts then New("Frame", { Size = UDim2.new(1,-28,0,1), Position = UDim2.new(0,14,1,-1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 }, btn) end
			btn.MouseButton1Click:Connect(function() sel=opt UpdateRadios() if cfg.Callback then cfg.Callback(sel) end end)
			btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=Theme.Surface3},0.1) end)
			btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=Theme.Surface2},0.1) end)
		end
		local obj = {}
		function obj:Get() return sel end
		function obj:Set(v) if TableContains(opts,v) then sel=v UpdateRadios() end end
		return obj
	end

	function compFuncs:AddCheckboxGroup(cfg)
		cfg = cfg or {}
		local opts = cfg.Options or {} local checked = {}
		if cfg.Default then for _,v in ipairs(cfg.Default) do if TableContains(opts,v) then checked[v]=true end end end
		local container = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y }, TabFrame)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, container) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, container)
		if cfg.Name then New("TextLabel", { Size = UDim2.new(1,-16,0,26), Position = UDim2.new(0,14,0,4), BackgroundTransparency = 1, Text = cfg.Name, TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, container) end
		local list = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,cfg.Name and 28 or 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y }, container)
		New("UIListLayout", { Padding = UDim.new(0,0), SortOrder = Enum.SortOrder.LayoutOrder }, list)
		local chkBtns = {}
		for i, opt in ipairs(opts) do
			local btn = New("TextButton", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = Theme.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, list)
			local isOn = checked[opt]==true
			local chkBg = New("Frame", { Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,14,0.5,-9), BackgroundColor3 = isOn and Theme.CheckFill or Theme.Surface3, BorderSizePixel = 0 }, btn)
			New("UICorner", { CornerRadius = UDim.new(0,4) }, chkBg) New("UIStroke", { Color = Theme.Border, Thickness = 1 }, chkBg)
			local chkMark = New("TextLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "✓", TextColor3 = Theme.Background, TextSize = 11, Font = Enum.Font.GothamBold, TextTransparency = isOn and 0 or 1 }, chkBg)
			local lbl = New("TextLabel", { Size = UDim2.new(1,-44,1,0), Position = UDim2.new(0,40,0,0), BackgroundTransparency = 1, Text = opt, TextColor3 = isOn and Theme.Text or Theme.TextDim, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, btn)
			chkBtns[opt] = { bg=chkBg, mark=chkMark, lbl=lbl }
			if i < #opts then New("Frame", { Size = UDim2.new(1,-28,0,1), Position = UDim2.new(0,14,1,-1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 }, btn) end
			btn.MouseButton1Click:Connect(function()
				checked[opt]=not checked[opt] local on=checked[opt]
				Tween(chkBg,{BackgroundColor3=on and Theme.CheckFill or Theme.Surface3},0.15) Tween(chkMark,{TextTransparency=on and 0 or 1},0.15) Tween(lbl,{TextColor3=on and Theme.Text or Theme.TextDim},0.15)
				local result={} for k,v in pairs(checked) do if v then table.insert(result,k) end end
				if cfg.Callback then cfg.Callback(result) end
			end)
			btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=Theme.Surface3},0.1) end)
			btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=Theme.Surface2},0.1) end)
		end
		local obj = {}
		function obj:Get() local r={} for k,v in pairs(checked) do if v then table.insert(r,k) end end return r end
		function obj:Set(arr) checked={} for _,v in ipairs(arr) do checked[v]=true end for opt,parts in pairs(chkBtns) do local on=checked[opt]==true Tween(parts.bg,{BackgroundColor3=on and Theme.CheckFill or Theme.Surface3},0.15) Tween(parts.mark,{TextTransparency=on and 0 or 1},0.15) Tween(parts.lbl,{TextColor3=on and Theme.Text or Theme.TextDim},0.15) end end
		return obj
	end

	return compFuncs
end

function NexusUI:CreateWindow(config)
	config = config or {}
	local Title = config.Title or "NexusUI"
	local SubTitle = config.SubTitle or ""
	local Size = config.Size or UDim2.new(0, 660, 0, 480)
	local ThemeOverride = config.Theme and Themes[config.Theme] or Theme
	local ShowStatusBar = config.StatusBar ~= false
	local Commands = config.Commands or {}
	local SBH = ShowStatusBar and 22 or 0

	local ScreenGui = New("ScreenGui", { Name = "NexusUI_"..Title, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10 }, CoreGui)

	local Main = New("Frame", { Size = Size, Position = UDim2.new(0.5,-330,0.5,-240), BackgroundColor3 = ThemeOverride.Surface, BorderSizePixel = 0 }, ScreenGui)
	New("UICorner", { CornerRadius = UDim.new(0,12) }, Main)
	New("UIStroke", { Color = ThemeOverride.Border, Thickness = 1 }, Main)
	New("ImageLabel", { Size = UDim2.new(1,80,1,80), Position = UDim2.new(0,-40,0,-30), BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Color3.new(0,0,0), ImageTransparency = 0.55, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49,49,450,450), ZIndex = 0 }, Main)

	local TitleBar = New("Frame", { Size = UDim2.new(1,0,0,46), BackgroundColor3 = ThemeOverride.Background, BorderSizePixel = 0 }, Main)
	New("UICorner", { CornerRadius = UDim.new(0,12) }, TitleBar)
	New("Frame", { Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0), BackgroundColor3 = ThemeOverride.Background, BorderSizePixel = 0 }, TitleBar)
	New("UIStroke", { Color = ThemeOverride.Border, Thickness = 1 }, TitleBar)

	local TitleLbl = New("TextLabel", { Size = UDim2.new(0,180,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = Title, TextColor3 = ThemeOverride.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left }, TitleBar)
	if SubTitle ~= "" then New("TextLabel", { Size = UDim2.new(0,200,1,0), Position = UDim2.new(0,134,0,0), BackgroundTransparency = 1, Text = "/ "..SubTitle, TextColor3 = ThemeOverride.TextMuted, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, TitleBar) end
	New("TextLabel", { Size = UDim2.new(0,80,1,0), Position = UDim2.new(1,-220,0,0), BackgroundTransparency = 1, Text = NexusUI._version, TextColor3 = ThemeOverride.TextMuted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right }, TitleBar)

	local CmdBtn = New("TextButton", { Size = UDim2.new(0,28,0,28), Position = UDim2.new(1,-122,0.5,-14), BackgroundColor3 = ThemeOverride.Surface3, Text = "⌘", TextColor3 = ThemeOverride.TextDim, TextSize = 13, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false }, TitleBar)
	New("UICorner", { CornerRadius = UDim.new(0,6) }, CmdBtn)
	AddTooltip(CmdBtn, "Command Palette")
	CmdBtn.MouseEnter:Connect(function() Tween(CmdBtn,{BackgroundColor3=ThemeOverride.BorderBright},0.15) end)
	CmdBtn.MouseLeave:Connect(function() Tween(CmdBtn,{BackgroundColor3=ThemeOverride.Surface3},0.15) end)
	CmdBtn.MouseButton1Click:Connect(function() OpenCmdPalette(Commands) end)

	local MinBtn = New("TextButton", { Size = UDim2.new(0,28,0,28), Position = UDim2.new(1,-88,0.5,-14), BackgroundColor3 = ThemeOverride.Surface3, Text = "−", TextColor3 = ThemeOverride.TextDim, TextSize = 16, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false }, TitleBar)
	New("UICorner", { CornerRadius = UDim.new(0,6) }, MinBtn)
	AddTooltip(MinBtn, "Minimize")

	local CloseBtn = New("TextButton", { Size = UDim2.new(0,28,0,28), Position = UDim2.new(1,-54,0.5,-14), BackgroundColor3 = ThemeOverride.Surface3, Text = "✕", TextColor3 = ThemeOverride.TextDim, TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0, AutoButtonColor = false }, TitleBar)
	New("UICorner", { CornerRadius = UDim.new(0,6) }, CloseBtn)
	AddTooltip(CloseBtn, "Close")

	CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,{BackgroundColor3=ThemeOverride.Danger,TextColor3=ThemeOverride.White},0.15) end)
	CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,{BackgroundColor3=ThemeOverride.Surface3,TextColor3=ThemeOverride.TextDim},0.15) end)
	MinBtn.MouseEnter:Connect(function() Tween(MinBtn,{BackgroundColor3=ThemeOverride.BorderBright},0.15) end)
	MinBtn.MouseLeave:Connect(function() Tween(MinBtn,{BackgroundColor3=ThemeOverride.Surface3},0.15) end)

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
		task.delay(0.35, function() ScreenGui:Destroy() end)
	end)

	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		Tween(Main, { Size = minimized and UDim2.new(0,Size.X.Offset,0,46) or Size }, 0.3, Enum.EasingStyle.Quart)
	end)

	MakeDraggable(Main, TitleBar)

	if ShowStatusBar then
		local sb = New("Frame", { Size = UDim2.new(1,0,0,SBH), Position = UDim2.new(0,0,1,-SBH), BackgroundColor3 = ThemeOverride.StatusBar, BorderSizePixel = 0, ZIndex = 5 }, Main)
		New("Frame", { Size = UDim2.new(1,0,0.5,0), BackgroundColor3 = ThemeOverride.StatusBar, BorderSizePixel = 0, ZIndex = 5 }, sb)
		New("TextLabel", { Size = UDim2.new(0,120,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = "Theme: "..ThemeOverride.Name, TextColor3 = ThemeOverride.StatusBarTxt, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, sb)
		New("TextLabel", { Size = UDim2.new(0,140,1,0), Position = UDim2.new(1,-148,0,0), BackgroundTransparency = 1, Text = "NexusUI "..NexusUI._version, TextColor3 = ThemeOverride.StatusBarTxt, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6 }, sb)
	end

	local TabBar = New("Frame", { Size = UDim2.new(0,154,1,-46-SBH), Position = UDim2.new(0,0,0,46), BackgroundColor3 = ThemeOverride.Background, BorderSizePixel = 0 }, Main)
	New("UIStroke", { Color = ThemeOverride.Border, Thickness = 1 }, TabBar)
	New("Frame", { Size = UDim2.new(0,1,1,0), Position = UDim2.new(1,-1,0,0), BackgroundColor3 = ThemeOverride.Border, BorderSizePixel = 0 }, TabBar)
	local TabScroll = New("ScrollingFrame", { Size = UDim2.new(1,0,1,-10), Position = UDim2.new(0,0,0,8), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = ThemeOverride.ScrollBar, CanvasSize = UDim2.new(0,0,0,0) }, TabBar)
	local TabLayout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4) }, TabScroll)
	New("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8) }, TabScroll)
	TabLayout.Changed:Connect(function() TabScroll.CanvasSize=UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y+16) end)

	local Content = New("Frame", { Size = UDim2.new(1,-154,1,-46-SBH), Position = UDim2.new(0,154,0,46), BackgroundColor3 = ThemeOverride.Surface, BorderSizePixel = 0, ClipsDescendants = true }, Main)

	local Window = { _tabs = {}, _active = nil, _screen = ScreenGui, _theme = ThemeOverride }
	Window.Notify = PushNotification

	function Window:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local Name = tabConfig.Name or "Tab"
		local Icon = tabConfig.Icon or ""
		local BadgeTxt = tabConfig.Badge or nil

		local TabBtn = New("TextButton", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeOverride.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, TabScroll)
		New("UICorner", { CornerRadius = UDim.new(0,8) }, TabBtn)
		local Indicator = New("Frame", { Size = UDim2.new(0,3,0,18), Position = UDim2.new(0,0,0.5,-9), BackgroundColor3 = ThemeOverride.Accent, BackgroundTransparency = 1, BorderSizePixel = 0 }, TabBtn)
		New("UICorner", { CornerRadius = UDim.new(1,0) }, Indicator)
		local IconLbl = New("TextLabel", { Size = UDim2.new(0,20,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = Icon, TextColor3 = ThemeOverride.TextDim, TextSize = 14, Font = Enum.Font.Gotham }, TabBtn)
		local NameLbl = New("TextLabel", { Size = UDim2.new(1,-46,1,0), Position = UDim2.new(0,34,0,0), BackgroundTransparency = 1, Text = Name, TextColor3 = ThemeOverride.TextDim, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left }, TabBtn)

		if BadgeTxt then
			local badgeFr = New("Frame", { Size = UDim2.new(0,0,0,16), Position = UDim2.new(1,-8,0.5,-8), AnchorPoint = Vector2.new(1,0), BackgroundColor3 = ThemeOverride.BadgeRed, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X }, TabBtn)
			New("UICorner", { CornerRadius = UDim.new(1,0) }, badgeFr)
			New("UIPadding", { PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5) }, badgeFr)
			New("TextLabel", { Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = tostring(BadgeTxt), TextColor3 = ThemeOverride.White, TextSize = 10, Font = Enum.Font.GothamBold }, badgeFr)
		end

		local TabFrame = New("ScrollingFrame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = ThemeOverride.ScrollBar, CanvasSize = UDim2.new(0,0,0,0), Visible = false }, Content)
		local ListLayout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6) }, TabFrame)
		New("UIPadding", { PaddingTop = UDim.new(0,12), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12), PaddingBottom = UDim.new(0,12) }, TabFrame)
		ListLayout.Changed:Connect(function() TabFrame.CanvasSize=UDim2.new(0,0,0,ListLayout.AbsoluteContentSize.Y+24) end)

		local tabData = { Btn=TabBtn, Frame=TabFrame, Name=NameLbl, Icon=IconLbl, Ind=Indicator }

		local function Activate()
			if self._active then
				local p = self._active
				Tween(p.Btn,{BackgroundColor3=ThemeOverride.Surface2},0.18) Tween(p.Name,{TextColor3=ThemeOverride.TextDim},0.18)
				Tween(p.Icon,{TextColor3=ThemeOverride.TextDim},0.18) Tween(p.Ind,{BackgroundTransparency=1},0.18)
				p.Frame.Visible = false
			end
			Tween(TabBtn,{BackgroundColor3=ThemeOverride.TabActive},0.18) Tween(NameLbl,{TextColor3=ThemeOverride.White},0.18)
			Tween(IconLbl,{TextColor3=ThemeOverride.White},0.18) Tween(Indicator,{BackgroundTransparency=0},0.18)
			TabFrame.Visible = true self._active = tabData
		end

		TabBtn.MouseEnter:Connect(function() if self._active~=tabData then Tween(TabBtn,{BackgroundColor3=ThemeOverride.Surface3},0.12) end end)
		TabBtn.MouseLeave:Connect(function() if self._active~=tabData then Tween(TabBtn,{BackgroundColor3=ThemeOverride.Surface2},0.12) end end)
		TabBtn.MouseButton1Click:Connect(Activate)
		if tabConfig.Tooltip then AddTooltip(TabBtn, tabConfig.Tooltip) end
		if #self._tabs == 0 then Activate() end
		table.insert(self._tabs, tabData)

		local Section = {}
		_buildComponent(TabFrame, Section)

		function Section:AddSubTabs(subCfg)
			subCfg = subCfg or {}
			local tabs = subCfg.Tabs or {}
			local wrapper = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundColor3 = ThemeOverride.Surface2, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y }, TabFrame)
			New("UICorner", { CornerRadius = UDim.new(0,8) }, wrapper) New("UIStroke", { Color = ThemeOverride.Border, Thickness = 1 }, wrapper)
			local subBar = New("Frame", { Size = UDim2.new(1,0,0,30), BackgroundColor3 = ThemeOverride.Background, BorderSizePixel = 0 }, wrapper)
			New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder }, subBar)
			New("UIPadding", { PaddingLeft = UDim.new(0,6), PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4) }, subBar)
			local subContent = New("Frame", { Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,30), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y }, wrapper)
			local subActive = nil
			for _, t in ipairs(tabs) do
				local sbtn = New("TextButton", { Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = ThemeOverride.Surface2, Text = "", BorderSizePixel = 0, AutoButtonColor = false }, subBar)
				New("UICorner", { CornerRadius = UDim.new(0,5) }, sbtn)
				New("UIPadding", { PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10) }, sbtn)
				local sLbl = New("TextLabel", { Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = t.Name or "Tab", TextColor3 = ThemeOverride.TextDim, TextSize = 12, Font = Enum.Font.GothamSemibold }, sbtn)
				local sFrame = New("Frame", { Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Visible = false }, subContent)
				New("UIListLayout", { Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder }, sFrame)
				New("UIPadding", { PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10) }, sFrame)
				local sData = { btn=sbtn, frame=sFrame, lbl=sLbl }
				local function ActivateSub()
					if subActive then Tween(subActive.btn,{BackgroundColor3=ThemeOverride.Surface2},0.15) Tween(subActive.lbl,{TextColor3=ThemeOverride.TextDim},0.15) subActive.frame.Visible=false end
					Tween(sbtn,{BackgroundColor3=ThemeOverride.Surface3},0.15) Tween(sLbl,{TextColor3=ThemeOverride.White},0.15)
					sFrame.Visible=true subActive=sData
				end
				sbtn.MouseButton1Click:Connect(ActivateSub)
				sbtn.MouseEnter:Connect(function() if subActive~=sData then Tween(sbtn,{BackgroundColor3=ThemeOverride.Surface3},0.1) end end)
				sbtn.MouseLeave:Connect(function() if subActive~=sData then Tween(sbtn,{BackgroundColor3=ThemeOverride.Surface2},0.1) end end)
				local subSection = {}
				_buildComponent(sFrame, subSection)
				if t.Init then t.Init(subSection) end
				if subActive == nil then ActivateSub() end
			end
			return wrapper
		end

		return Section
	end

	function Window:SetTitle(t) TitleLbl.Text = t end
	function Window:Destroy() ScreenGui:Destroy() end
	function Window:Toggle() Main.Visible = not Main.Visible end
	function Window:Show() Main.Visible=true Tween(Main,{Size=Size},0.25,Enum.EasingStyle.Back) end
	function Window:Hide() Tween(Main,{Size=UDim2.new(0,0,0,0)},0.2,Enum.EasingStyle.Quart) task.delay(0.25,function() Main.Visible=false end) end

	table.insert(NexusUI._windows, Window)
	return Window
end

NexusUI.Utils = {
	Tween = Tween, TweenCallback = TweenCallback, New = New,
	Clamp = Clamp, Round = Round, Lerp = Lerp,
	DeepCopy = DeepCopy, TableContains = TableContains, TableRemove = TableRemove,
	FormatNumber = FormatNumber, ColorToHex = ColorToHex, HexToColor = HexToColor,
	AddTooltip = AddTooltip,
}

return NexusUI

NexusUI._themeNames = { "Dark", "Light", "Ocean", "Crimson", "Forest", "Midnight", "Sunset", "Neon" }
NexusUI._componentList = {
	"AddButton", "AddToggle", "AddSlider", "AddRangeSlider", "AddInput", "AddNumberInput",
	"AddDropdown", "AddMultiSelect", "AddRadioGroup", "AddCheckboxGroup",
	"AddColorPicker", "AddKeybind", "AddLabel", "AddSeparator", "AddParagraph",
	"AddProgressBar", "AddBadge", "AddStatusIndicator", "AddAccordion",
	"AddTable", "AddCodeBlock", "AddSearchBox", "AddDebugConsole", "AddSpinner",
	"AddSectionHeader",
}
NexusUI._notifTypes = { "Info", "Success", "Warning", "Error" }
NexusUI._defaultWindowSize = UDim2.new(0, 660, 0, 480)
NexusUI._defaultTooltipDelay = 0.55
NexusUI._maxNotifStack = 5
NexusUI._animSpeed = { Fast = 0.12, Normal = 0.2, Slow = 0.35 }
NexusUI._easingStyles = {
	Default  = Enum.EasingStyle.Quart,
	Bounce   = Enum.EasingStyle.Bounce,
	Elastic  = Enum.EasingStyle.Elastic,
	Back     = Enum.EasingStyle.Back,
	Linear   = Enum.EasingStyle.Linear,
	Sine     = Enum.EasingStyle.Sine,
	Quad     = Enum.EasingStyle.Quad,
	Cubic    = Enum.EasingStyle.Cubic,
	Quint    = Enum.EasingStyle.Quint,
	Expo     = Enum.EasingStyle.Exponential,
	Circ     = Enum.EasingStyle.Circular,
}

NexusUI._fontMap = {
	Default      = Enum.Font.Gotham,
	Bold         = Enum.Font.GothamBold,
	SemiBold     = Enum.Font.GothamSemibold,
	Black        = Enum.Font.GothamBlack,
	Code         = Enum.Font.Code,
	Roboto       = Enum.Font.RobotoCondensed,
	Arial        = Enum.Font.Arial,
	ArialBold    = Enum.Font.ArialBold,
	SourceSans   = Enum.Font.SourceSans,
	SourceSansBold = Enum.Font.SourceSansBold,
}

NexusUI._iconSet = {
	Close     = "✕",
	Minimize  = "−",
	Maximize  = "□",
	Settings  = "⚙",
	Search    = "🔍",
	Bell      = "🔔",
	Star      = "★",
	Heart     = "♥",
	Check     = "✓",
	Cross     = "✖",
	Arrow     = "›",
	ArrowLeft = "‹",
	ArrowUp   = "^",
	ArrowDown = "⌄",
	Info      = "ℹ",
	Warning   = "⚠",
	Error     = "✖",
	Plus      = "+",
	Minus     = "−",
	Refresh   = "⟳",
	Home      = "⌂",
	User      = "👤",
	Lock      = "🔒",
	Unlock    = "🔓",
	Eye       = "👁",
	Trash     = "🗑",
	Edit      = "✏",
	Copy      = "⎘",
	Pin       = "📌",
	Folder    = "📁",
	File      = "📄",
	Download  = "↓",
	Upload    = "↑",
	Share     = "↗",
	Link      = "🔗",
	Globe     = "🌐",
	Palette   = "🎨",
	Code2     = "</>",
	Terminal  = ">_",
	Chart     = "📊",
	Clock     = "🕐",
	Calendar  = "📅",
	Map       = "🗺",
	Flag      = "⚑",
	Tag       = "#",
	Bookmark  = "🔖",
	Gift      = "🎁",
	Key       = "🔑",
	Shield    = "🛡",
	Zap       = "⚡",
	Fire      = "🔥",
	Gem       = "💎",
	Crown     = "♛",
	Sword     = "⚔",
	Skull     = "☠",
	Target    = "◎",
	Wifi      = "≋",
	Signal    = "▲",
	Battery   = "▮",
	Mic       = "🎙",
	Volume    = "🔊",
	Camera    = "📷",
	Image     = "🖼",
	Play      = "▶",
	Pause     = "⏸",
	Stop      = "⏹",
	Record    = "⏺",
	Skip      = "⏭",
	Back2     = "⏮",
	Loop      = "↻",
	Shuffle   = "⇌",
}

NexusUI._keyNames = {
	[Enum.KeyCode.A] = "A", [Enum.KeyCode.B] = "B", [Enum.KeyCode.C] = "C",
	[Enum.KeyCode.D] = "D", [Enum.KeyCode.E] = "E", [Enum.KeyCode.F] = "F",
	[Enum.KeyCode.G] = "G", [Enum.KeyCode.H] = "H", [Enum.KeyCode.I] = "I",
	[Enum.KeyCode.J] = "J", [Enum.KeyCode.K] = "K", [Enum.KeyCode.L] = "L",
	[Enum.KeyCode.M] = "M", [Enum.KeyCode.N] = "N", [Enum.KeyCode.O] = "O",
	[Enum.KeyCode.P] = "P", [Enum.KeyCode.Q] = "Q", [Enum.KeyCode.R] = "R",
	[Enum.KeyCode.S] = "S", [Enum.KeyCode.T] = "T", [Enum.KeyCode.U] = "U",
	[Enum.KeyCode.V] = "V", [Enum.KeyCode.W] = "W", [Enum.KeyCode.X] = "X",
	[Enum.KeyCode.Y] = "Y", [Enum.KeyCode.Z] = "Z",
	[Enum.KeyCode.Zero]  = "0", [Enum.KeyCode.One]   = "1", [Enum.KeyCode.Two]   = "2",
	[Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four]  = "4", [Enum.KeyCode.Five]  = "5",
	[Enum.KeyCode.Six]   = "6", [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine]  = "9",
	[Enum.KeyCode.F1]  = "F1",  [Enum.KeyCode.F2]  = "F2",  [Enum.KeyCode.F3]  = "F3",
	[Enum.KeyCode.F4]  = "F4",  [Enum.KeyCode.F5]  = "F5",  [Enum.KeyCode.F6]  = "F6",
	[Enum.KeyCode.F7]  = "F7",  [Enum.KeyCode.F8]  = "F8",  [Enum.KeyCode.F9]  = "F9",
	[Enum.KeyCode.F10] = "F10", [Enum.KeyCode.F11] = "F11", [Enum.KeyCode.F12] = "F12",
	[Enum.KeyCode.Return]    = "Enter",    [Enum.KeyCode.Space]     = "Space",
	[Enum.KeyCode.Tab]       = "Tab",      [Enum.KeyCode.Escape]    = "Escape",
	[Enum.KeyCode.Backspace] = "Backspace",[Enum.KeyCode.Delete]    = "Delete",
	[Enum.KeyCode.Insert]    = "Insert",   [Enum.KeyCode.Home]      = "Home",
	[Enum.KeyCode.End]       = "End",      [Enum.KeyCode.PageUp]    = "PgUp",
	[Enum.KeyCode.PageDown]  = "PgDn",     [Enum.KeyCode.CapsLock]  = "CapsLk",
	[Enum.KeyCode.LeftShift] = "LShift",   [Enum.KeyCode.RightShift]= "RShift",
	[Enum.KeyCode.LeftControl]="LCtrl",    [Enum.KeyCode.RightControl]="RCtrl",
	[Enum.KeyCode.LeftAlt]   = "LAlt",     [Enum.KeyCode.RightAlt]  = "RAlt",
	[Enum.KeyCode.Up]        = "↑",        [Enum.KeyCode.Down]      = "↓",
	[Enum.KeyCode.Left]      = "←",        [Enum.KeyCode.Right]     = "→",
	[Enum.KeyCode.Comma]     = ",",        [Enum.KeyCode.Period]    = ".",
	[Enum.KeyCode.Slash]     = "/",        [Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Semicolon] = ";",        [Enum.KeyCode.Quote]     = "'",
	[Enum.KeyCode.LeftBracket]= "[",       [Enum.KeyCode.RightBracket]="]",
	[Enum.KeyCode.Minus]     = "-",        [Enum.KeyCode.Equals]    = "=",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.KeyCode.KeypadZero]  = "Num0",   [Enum.KeyCode.KeypadOne]   = "Num1",
	[Enum.KeyCode.KeypadTwo]   = "Num2",   [Enum.KeyCode.KeypadThree] = "Num3",
	[Enum.KeyCode.KeypadFour]  = "Num4",   [Enum.KeyCode.KeypadFive]  = "Num5",
	[Enum.KeyCode.KeypadSix]   = "Num6",   [Enum.KeyCode.KeypadSeven] = "Num7",
	[Enum.KeyCode.KeypadEight] = "Num8",   [Enum.KeyCode.KeypadNine]  = "Num9",
	[Enum.KeyCode.KeypadPeriod]= "Num.",   [Enum.KeyCode.KeypadPlus]  = "Num+",
	[Enum.KeyCode.KeypadMinus] = "Num-",   [Enum.KeyCode.KeypadAsterisk]="Num*",
	[Enum.KeyCode.KeypadSlash] = "Num/",
}

function NexusUI:GetKeyName(keyCode)
	return self._keyNames[keyCode] or keyCode.Name
end

function NexusUI:GetIcon(name)
	return self._iconSet[name] or ""
end

function NexusUI:ListThemes()
	local result = {}
	for name in pairs(Themes) do table.insert(result, name) end
	table.sort(result)
	return result
end

function NexusUI:DestroyAll()
	for _, win in ipairs(self._windows) do
		pcall(function() win:Destroy() end)
	end
	self._windows = {}
end

function NexusUI:SetTooltipDelay(seconds)
	self._tooltipDelay = seconds
end

function NexusUI:SetAnimSpeed(speedTable)
	if speedTable then
		for k, v in pairs(speedTable) do
			self._animSpeed[k] = v
		end
	end
end

function NexusUI:RegisterPlugin(plugin)
	table.insert(self._plugins, plugin)
	if plugin.Init then plugin:Init(self) end
end

function NexusUI:GetVersion()
	return self._version
end

function NexusUI:GetActiveThemeName()
	return self._activeThemeName
end

function NexusUI:IsCommandPaletteOpen()
	return self._commandPaletteOpen
end

function NexusUI:GetWindowCount()
	return #self._windows
end

NexusUI._colorPresets = {
	Red        = Color3.fromRGB(255, 60,  60),
	Orange     = Color3.fromRGB(255, 140, 30),
	Yellow     = Color3.fromRGB(255, 210, 40),
	Green      = Color3.fromRGB(50,  210, 90),
	Teal       = Color3.fromRGB(30,  200, 180),
	Cyan       = Color3.fromRGB(40,  200, 255),
	Blue       = Color3.fromRGB(50,  130, 255),
	Indigo     = Color3.fromRGB(90,  80,  240),
	Violet     = Color3.fromRGB(160, 60,  255),
	Purple     = Color3.fromRGB(200, 50,  240),
	Pink       = Color3.fromRGB(255, 80,  180),
	Rose       = Color3.fromRGB(255, 50,  120),
	White      = Color3.fromRGB(255, 255, 255),
	Gray       = Color3.fromRGB(120, 120, 120),
	Black      = Color3.fromRGB(10,  10,  10),
	Gold       = Color3.fromRGB(255, 200, 50),
	Silver     = Color3.fromRGB(180, 180, 190),
	Bronze     = Color3.fromRGB(160, 100, 40),
	Lime       = Color3.fromRGB(160, 240, 30),
	Mint       = Color3.fromRGB(130, 240, 180),
	Lavender   = Color3.fromRGB(200, 170, 255),
	Peach      = Color3.fromRGB(255, 180, 140),
	Salmon     = Color3.fromRGB(250, 120, 100),
	Coral      = Color3.fromRGB(255, 100, 80),
	Maroon     = Color3.fromRGB(140, 20,  30),
	Navy       = Color3.fromRGB(20,  30,  120),
	Olive      = Color3.fromRGB(100, 110, 30),
	Cream      = Color3.fromRGB(255, 245, 220),
	Chocolate  = Color3.fromRGB(100, 50,  20),
	Sky        = Color3.fromRGB(100, 180, 255),
	Aqua       = Color3.fromRGB(40,  220, 200),
	Magenta    = Color3.fromRGB(255, 40,  200),
	Amber      = Color3.fromRGB(255, 170, 20),
	Jade       = Color3.fromRGB(40,  180, 120),
	Ruby       = Color3.fromRGB(200, 30,  60),
	Sapphire   = Color3.fromRGB(30,  80,  200),
	Emerald    = Color3.fromRGB(30,  180, 80),
	Topaz      = Color3.fromRGB(255, 200, 100),
	Turquoise  = Color3.fromRGB(30,  200, 190),
	Charcoal   = Color3.fromRGB(50,  50,  55),
	Ivory      = Color3.fromRGB(250, 248, 235),
	Wheat      = Color3.fromRGB(240, 210, 150),
	SlateBlue  = Color3.fromRGB(90,  100, 200),
	SteelBlue  = Color3.fromRGB(70,  130, 180),
	RoyalBlue  = Color3.fromRGB(50,  80,  200),
	DodgerBlue = Color3.fromRGB(30,  140, 255),
	DeepPink   = Color3.fromRGB(255, 20,  140),
	HotPink    = Color3.fromRGB(255, 100, 180),
	Crimson2   = Color3.fromRGB(200, 20,  40),
	FireBrick  = Color3.fromRGB(180, 30,  30),
	DarkRed    = Color3.fromRGB(140, 0,   0),
	Tomato     = Color3.fromRGB(255, 90,  70),
	OrangeRed  = Color3.fromRGB(255, 70,  30),
	DarkOrange = Color3.fromRGB(255, 130, 0),
	GoldRod    = Color3.fromRGB(220, 170, 20),
	DarkGreen  = Color3.fromRGB(0,   100, 0),
	ForestGreen= Color3.fromRGB(30,  140, 30),
	LimeGreen  = Color3.fromRGB(50,  200, 50),
	SpringGreen= Color3.fromRGB(0,   255, 120),
	MediumSpring = Color3.fromRGB(0,   250, 150),
	DarkCyan   = Color3.fromRGB(0,   140, 140),
	CadetBlue  = Color3.fromRGB(90,  158, 160),
	PowderBlue = Color3.fromRGB(176, 224, 230),
	LightBlue  = Color3.fromRGB(173, 216, 230),
	PaleGreen  = Color3.fromRGB(152, 251, 152),
	PaleYellow = Color3.fromRGB(255, 255, 180),
	MistyRose  = Color3.fromRGB(255, 228, 225),
	LavenderBlush = Color3.fromRGB(255, 240, 245),
	AliceBlue  = Color3.fromRGB(240, 248, 255),
	HoneyDew   = Color3.fromRGB(240, 255, 240),
	MintCream  = Color3.fromRGB(245, 255, 250),
	SeaShell   = Color3.fromRGB(255, 245, 238),
	FloralWhite = Color3.fromRGB(255, 250, 240),
	OldLace    = Color3.fromRGB(253, 245, 230),
	Bisque     = Color3.fromRGB(255, 228, 196),
	BlanchedAlmond = Color3.fromRGB(255, 235, 205),
	Moccasin   = Color3.fromRGB(255, 228, 181),
	NavajoWhite = Color3.fromRGB(255, 222, 173),
	PapayaWhip = Color3.fromRGB(255, 239, 213),
	LemonChiffon = Color3.fromRGB(255, 250, 205),
	LightGoldenRod = Color3.fromRGB(250, 250, 210),
	Khaki      = Color3.fromRGB(240, 230, 140),
	DarkKhaki  = Color3.fromRGB(189, 183, 107),
	Sienna     = Color3.fromRGB(160, 82,  45),
	SaddleBrown = Color3.fromRGB(139, 69, 19),
	Peru       = Color3.fromRGB(205, 133, 63),
	BurlyWood  = Color3.fromRGB(222, 184, 135),
	Tan        = Color3.fromRGB(210, 180, 140),
	RosyBrown  = Color3.fromRGB(188, 143, 143),
	DarkSalmon = Color3.fromRGB(233, 150, 122),
	LightSalmon = Color3.fromRGB(255, 160, 122),
	LightCoral = Color3.fromRGB(240, 128, 128),
	IndianRed  = Color3.fromRGB(205, 92,  92),
	PaleVioletRed = Color3.fromRGB(219, 112, 147),
	MediumVioletRed = Color3.fromRGB(199, 21, 133),
	Orchid     = Color3.fromRGB(218, 112, 214),
	Plum       = Color3.fromRGB(221, 160, 221),
	Thistle    = Color3.fromRGB(216, 191, 216),
	Gainsboro  = Color3.fromRGB(220, 220, 220),
	LightGray  = Color3.fromRGB(211, 211, 211),
	Silver2    = Color3.fromRGB(192, 192, 192),
	DarkGray   = Color3.fromRGB(169, 169, 169),
	Gray2      = Color3.fromRGB(128, 128, 128),
	DimGray    = Color3.fromRGB(105, 105, 105),
	LightSlateGray = Color3.fromRGB(119, 136, 153),
	SlateGray  = Color3.fromRGB(112, 128, 144),
	DarkSlateGray = Color3.fromRGB(47,  79,  79),
}

function NexusUI:GetColorPreset(name)
	return self._colorPresets[name] or Color3.new(1, 1, 1)
end

function NexusUI:GetAllColorPresets()
	return DeepCopy(self._colorPresets)
end

NexusUI._easingPresets = {
	SlideIn       = { Style = Enum.EasingStyle.Quart,       Dir = Enum.EasingDirection.Out,  Time = 0.3  },
	SlideOut      = { Style = Enum.EasingStyle.Quart,       Dir = Enum.EasingDirection.In,   Time = 0.25 },
	BounceIn      = { Style = Enum.EasingStyle.Bounce,      Dir = Enum.EasingDirection.Out,  Time = 0.5  },
	ElasticIn     = { Style = Enum.EasingStyle.Elastic,     Dir = Enum.EasingDirection.Out,  Time = 0.6  },
	BackIn        = { Style = Enum.EasingStyle.Back,        Dir = Enum.EasingDirection.Out,  Time = 0.35 },
	SmoothOpen    = { Style = Enum.EasingStyle.Sine,        Dir = Enum.EasingDirection.Out,  Time = 0.2  },
	SmoothClose   = { Style = Enum.EasingStyle.Sine,        Dir = Enum.EasingDirection.In,   Time = 0.18 },
	Instant       = { Style = Enum.EasingStyle.Linear,      Dir = Enum.EasingDirection.Out,  Time = 0.05 },
	Slow          = { Style = Enum.EasingStyle.Quart,       Dir = Enum.EasingDirection.Out,  Time = 0.6  },
	PopIn         = { Style = Enum.EasingStyle.Back,        Dir = Enum.EasingDirection.Out,  Time = 0.4  },
	FadeIn        = { Style = Enum.EasingStyle.Quad,        Dir = Enum.EasingDirection.Out,  Time = 0.3  },
	FadeOut       = { Style = Enum.EasingStyle.Quad,        Dir = Enum.EasingDirection.In,   Time = 0.25 },
	Springy       = { Style = Enum.EasingStyle.Elastic,     Dir = Enum.EasingDirection.Out,  Time = 0.55 },
	Crisp         = { Style = Enum.EasingStyle.Exponential, Dir = Enum.EasingDirection.Out,  Time = 0.22 },
	SnapOpen      = { Style = Enum.EasingStyle.Exponential, Dir = Enum.EasingDirection.Out,  Time = 0.15 },
	SnapClose     = { Style = Enum.EasingStyle.Exponential, Dir = Enum.EasingDirection.In,   Time = 0.12 },
	Wobbly        = { Style = Enum.EasingStyle.Bounce,      Dir = Enum.EasingDirection.Out,  Time = 0.7  },
	GentleSlide   = { Style = Enum.EasingStyle.Circular,    Dir = Enum.EasingDirection.Out,  Time = 0.4  },
	AccelIn       = { Style = Enum.EasingStyle.Quint,       Dir = Enum.EasingDirection.In,   Time = 0.3  },
	DecelOut      = { Style = Enum.EasingStyle.Quint,       Dir = Enum.EasingDirection.Out,  Time = 0.3  },
}

function NexusUI:TweenPreset(obj, props, presetName)
	local p = self._easingPresets[presetName] or self._easingPresets.SlideIn
	TweenService:Create(obj, TweenInfo.new(p.Time, p.Style, p.Dir), props):Play()
end

NexusUI._sizePresets = {
	Compact  = UDim2.new(0, 480, 0, 360),
	Small    = UDim2.new(0, 560, 0, 400),
	Medium   = UDim2.new(0, 660, 0, 480),
	Large    = UDim2.new(0, 760, 0, 540),
	Wide     = UDim2.new(0, 860, 0, 480),
	Tall     = UDim2.new(0, 600, 0, 620),
	Square   = UDim2.new(0, 560, 0, 560),
	Fullish  = UDim2.new(0, 960, 0, 640),
	Thin     = UDim2.new(0, 400, 0, 600),
	Panorama = UDim2.new(0,1000, 0, 440),
}

function NexusUI:GetSizePreset(name)
	return self._sizePresets[name] or self._sizePresets.Medium
end

NexusUI._layoutHelpers = {}

function NexusUI._layoutHelpers.MakeGrid(parent, columns, padding)
	columns = columns or 2
	padding = padding or 6
	local layout = Instance.new("UIGridLayout")
	layout.CellSize     = UDim2.new(1/columns, -(padding*(columns-1)/columns), 0, 36)
	layout.CellPadding  = UDim2.new(0, padding, 0, padding)
	layout.SortOrder    = Enum.SortOrder.LayoutOrder
	layout.Parent       = parent
	return layout
end

function NexusUI._layoutHelpers.MakeHorizontalList(parent, padding)
	padding = padding or 4
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding       = UDim.new(0, padding)
	layout.SortOrder     = Enum.SortOrder.LayoutOrder
	layout.Parent        = parent
	return layout
end

function NexusUI._layoutHelpers.MakeVerticalList(parent, padding)
	padding = padding or 6
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding       = UDim.new(0, padding)
	layout.SortOrder     = Enum.SortOrder.LayoutOrder
	layout.Parent        = parent
	return layout
end

function NexusUI._layoutHelpers.AddPadding(parent, top, right, bottom, left)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 8)
	p.PaddingRight  = UDim.new(0, right  or 8)
	p.PaddingBottom = UDim.new(0, bottom or 8)
	p.PaddingLeft   = UDim.new(0, left   or 8)
	p.Parent = parent
	return p
end

NexusUI._mathHelpers = {}

function NexusUI._mathHelpers.Map(v, inMin, inMax, outMin, outMax)
	return outMin + (outMax - outMin) * ((v - inMin) / (inMax - inMin))
end

function NexusUI._mathHelpers.Snap(v, step)
	return math.floor(v / step + 0.5) * step
end

function NexusUI._mathHelpers.Remap(v, inMin, inMax, outMin, outMax, clampResult)
	local result = outMin + (outMax - outMin) * ((v - inMin) / (inMax - inMin))
	if clampResult then result = math.max(outMin, math.min(outMax, result)) end
	return result
end

function NexusUI._mathHelpers.Smoothstep(edge0, edge1, x)
	local t = math.max(0, math.min(1, (x - edge0) / (edge1 - edge0)))
	return t * t * (3 - 2 * t)
end

function NexusUI._mathHelpers.Pingpong(t, length)
	local cycle = t % (length * 2)
	if cycle < length then return cycle else return length * 2 - cycle end
end

function NexusUI._mathHelpers.Damp(current, target, lambda, dt)
	return Lerp(current, target, 1 - math.exp(-lambda * dt))
end

NexusUI._colorHelpers = {}

function NexusUI._colorHelpers.Blend(c1, c2, t)
	return Color3.new(
		Lerp(c1.R, c2.R, t),
		Lerp(c1.G, c2.G, t),
		Lerp(c1.B, c2.B, t)
	)
end

function NexusUI._colorHelpers.Darken(c, amount)
	amount = amount or 0.2
	return Color3.new(
		math.max(0, c.R - amount),
		math.max(0, c.G - amount),
		math.max(0, c.B - amount)
	)
end

function NexusUI._colorHelpers.Lighten(c, amount)
	amount = amount or 0.2
	return Color3.new(
		math.min(1, c.R + amount),
		math.min(1, c.G + amount),
		math.min(1, c.B + amount)
	)
end

function NexusUI._colorHelpers.Saturate(c, amount)
	amount = amount or 0.2
	local h, s, v = Color3.toHSV(c)
	return Color3.fromHSV(h, math.min(1, s + amount), v)
end

function NexusUI._colorHelpers.Desaturate(c, amount)
	amount = amount or 0.2
	local h, s, v = Color3.toHSV(c)
	return Color3.fromHSV(h, math.max(0, s - amount), v)
end

function NexusUI._colorHelpers.Invert(c)
	return Color3.new(1 - c.R, 1 - c.G, 1 - c.B)
end

function NexusUI._colorHelpers.Grayscale(c)
	local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
	return Color3.new(lum, lum, lum)
end

function NexusUI._colorHelpers.Opacity(c, alpha)
	return { Color = c, Alpha = alpha }
end

function NexusUI._colorHelpers.FromHue(hue, saturation, value)
	saturation = saturation or 1
	value = value or 1
	return Color3.fromHSV(hue / 360, saturation, value)
end

function NexusUI._colorHelpers.Complementary(c)
	local h, s, v = Color3.toHSV(c)
	return Color3.fromHSV((h + 0.5) % 1, s, v)
end

function NexusUI._colorHelpers.Triadic(c)
	local h, s, v = Color3.toHSV(c)
	return {
		Color3.fromHSV(h, s, v),
		Color3.fromHSV((h + 0.333) % 1, s, v),
		Color3.fromHSV((h + 0.666) % 1, s, v),
	}
end

function NexusUI._colorHelpers.Analogous(c, spread)
	spread = spread or 0.083
	local h, s, v = Color3.toHSV(c)
	return {
		Color3.fromHSV((h - spread + 1) % 1, s, v),
		Color3.fromHSV(h, s, v),
		Color3.fromHSV((h + spread) % 1, s, v),
	}
end

function NexusUI._colorHelpers.SplitComplementary(c)
	local h, s, v = Color3.toHSV(c)
	return {
		Color3.fromHSV(h, s, v),
		Color3.fromHSV((h + 0.417) % 1, s, v),
		Color3.fromHSV((h + 0.583) % 1, s, v),
	}
end

NexusUI.LayoutHelpers = NexusUI._layoutHelpers
NexusUI.MathHelpers   = NexusUI._mathHelpers
NexusUI.ColorHelpers  = NexusUI._colorHelpers

NexusUI._changelog = {
	["beta 0.0.1"] = {
		"Initial beta release",
		"8 built-in themes: Dark, Light, Ocean, Crimson, Forest, Midnight, Sunset, Neon",
		"Full component suite: Button, Toggle, Slider, RangeSlider, Input, NumberInput",
		"Dropdown, MultiSelect, RadioGroup, CheckboxGroup, ColorPicker, Keybind",
		"Label, Separator, Paragraph, ProgressBar, Badge, StatusIndicator",
		"Accordion, Table, CodeBlock, SearchBox, DebugConsole, Spinner",
		"SectionHeader, SubTabs",
		"Notification system with type-based accent colors",
		"Tooltip system with configurable delay",
		"Context menu system",
		"Modal / dialog system",
		"Command palette (⌘)",
		"Event bus (pub/sub)",
		"Config save/load via HttpService + file system",
		"Hotkey registration system",
		"Plugin registration system",
		"Theme switching API",
		"Utility helpers: Math, Color, Layout",
		"100+ color presets",
		"Easing presets",
		"Size presets",
		"Icon set with 80+ symbols",
		"Key name map for all common keys",
		"Window: draggable, minimizable, closable, status bar",
		"Tab system with icons and badges",
		"Scroll-to-content ListLayout auto-sizing",
	},
}

function NexusUI:GetChangelog(version)
	return self._changelog[version or self._version] or {}
end

function NexusUI:PrintChangelog()
	local log = self:GetChangelog()
	print(string.rep("=", 50))
	print("NexusUI " .. self._version .. " Changelog")
	print(string.rep("=", 50))
	for _, entry in ipairs(log) do
		print("  • " .. entry)
	end
	print(string.rep("=", 50))
end

NexusUI._credits = {
	Library = "NexusUI",
	Version = "beta 0.0.1",
	Description = "Advanced Roblox UI Library",
	Components = 24,
	Themes = 8,
	ColorPresets = 100,
	EasingPresets = 20,
	SizePresets = 10,
	Icons = 80,
}

function NexusUI:GetCredits()
	return DeepCopy(self._credits)
end

NexusUI._defaultConfigs = {
	Button = { Name = "Button", Tooltip = nil, Callback = nil, ContextMenu = nil },
	Toggle = { Name = "Toggle", Default = false, Tooltip = nil, Callback = nil },
	Slider = { Name = "Slider", Min = 0, Max = 100, Default = 0, Step = 1, Suffix = "", Tooltip = nil, Callback = nil },
	RangeSlider = { Name = "Range", Min = 0, Max = 100, DefaultLow = 0, DefaultHigh = 100, Step = 1, Suffix = "", Callback = nil },
	Input = { Name = "Input", Default = "", Placeholder = "Enter value...", Tooltip = nil, Callback = nil },
	NumberInput = { Name = "Number", Default = 0, Min = -math.huge, Max = math.huge, Step = 1, Callback = nil },
	Dropdown = { Name = "Dropdown", Options = {}, Default = nil, Tooltip = nil, Callback = nil },
	MultiSelect = { Name = "MultiSelect", Options = {}, Default = {}, Placeholder = "Select...", Callback = nil },
	RadioGroup = { Name = nil, Options = {}, Default = nil, Callback = nil },
	CheckboxGroup = { Name = nil, Options = {}, Default = {}, Callback = nil },
	ColorPicker = { Name = "Color", Default = Color3.fromRGB(255,255,255), Tooltip = nil, Callback = nil },
	Keybind = { Name = "Keybind", Default = Enum.KeyCode.Unknown, Tooltip = nil, Callback = nil, OnPress = nil },
	Label = { Text = "", Color = nil, TextSize = 12, Font = nil, Align = nil, Wrap = false, RichText = false },
	Paragraph = { Title = nil, Content = "" },
	ProgressBar = { Name = "Progress", Default = 0, Color = nil },
	Badge = { Name = "", Label = "", Color = "Blue" },
	StatusIndicator = { Name = "Status", Default = "Offline" },
	Accordion = { Title = "Section", Expanded = false, ContentHeight = 80, Content = nil },
	Table = { Columns = {}, Rows = {}, RowHeight = 30 },
	CodeBlock = { Code = "", Language = "Lua", Height = 120 },
	SearchBox = { Placeholder = "Search...", Callback = nil, OnFocusLost = nil },
	DebugConsole = { Name = "Debug Console", Height = 140, MaxLines = 200 },
	Spinner = { Name = "Loading", Active = true },
	SectionHeader = { Title = "Section", Line = true },
}

function NexusUI:GetDefaultConfig(componentName)
	return DeepCopy(self._defaultConfigs[componentName] or {})
end

NexusUI._validators = {}

function NexusUI._validators.IsNumber(v)
	return type(v) == "number"
end

function NexusUI._validators.IsString(v)
	return type(v) == "string"
end

function NexusUI._validators.IsBool(v)
	return type(v) == "boolean"
end

function NexusUI._validators.IsColor(v)
	return typeof(v) == "Color3"
end

function NexusUI._validators.IsKeyCode(v)
	return typeof(v) == "EnumItem" and v.EnumType == Enum.KeyCode
end

function NexusUI._validators.IsInRange(v, min, max)
	return type(v) == "number" and v >= min and v <= max
end

function NexusUI._validators.IsNonEmpty(v)
	return type(v) == "string" and #v > 0
end

function NexusUI._validators.IsTable(v)
	return type(v) == "table"
end

function NexusUI._validators.IsFunction(v)
	return type(v) == "function"
end

function NexusUI._validators.IsUDim2(v)
	return typeof(v) == "UDim2"
end

function NexusUI._validators.IsVector2(v)
	return typeof(v) == "Vector2"
end

NexusUI.Validators = NexusUI._validators

NexusUI._stringHelpers = {}

function NexusUI._stringHelpers.Trim(s)
	return s:match("^%s*(.-)%s*$")
end

function NexusUI._stringHelpers.Split(s, sep)
	sep = sep or ","
	local result = {}
	for part in s:gmatch("[^" .. sep .. "]+") do
		table.insert(result, part)
	end
	return result
end

function NexusUI._stringHelpers.Join(t, sep)
	sep = sep or ", "
	return table.concat(t, sep)
end

function NexusUI._stringHelpers.StartsWith(s, prefix)
	return s:sub(1, #prefix) == prefix
end

function NexusUI._stringHelpers.EndsWith(s, suffix)
	return suffix == "" or s:sub(-#suffix) == suffix
end

function NexusUI._stringHelpers.Contains(s, sub)
	return s:find(sub, 1, true) ~= nil
end

function NexusUI._stringHelpers.PadLeft(s, len, char)
	char = char or " "
	while #s < len do s = char .. s end
	return s
end

function NexusUI._stringHelpers.PadRight(s, len, char)
	char = char or " "
	while #s < len do s = s .. char end
	return s
end

function NexusUI._stringHelpers.Repeat(s, n)
	local result = ""
	for i = 1, n do result = result .. s end
	return result
end

function NexusUI._stringHelpers.Capitalize(s)
	return s:sub(1,1):upper() .. s:sub(2):lower()
end

function NexusUI._stringHelpers.TitleCase(s)
	return s:gsub("(%a)([%w_']*)", function(a, b) return a:upper() .. b:lower() end)
end

function NexusUI._stringHelpers.CamelToSpace(s)
	return s:gsub("(%u)", function(c) return " " .. c end):gsub("^%s", "")
end

function NexusUI._stringHelpers.Truncate(s, maxLen, suffix)
	suffix = suffix or "..."
	if #s <= maxLen then return s end
	return s:sub(1, maxLen - #suffix) .. suffix
end

function NexusUI._stringHelpers.WordWrap(s, maxWidth)
	local words = {}
	for word in s:gmatch("%S+") do table.insert(words, word) end
	local lines = {}
	local currentLine = ""
	for _, word in ipairs(words) do
		if #currentLine == 0 then
			currentLine = word
		elseif #currentLine + 1 + #word <= maxWidth then
			currentLine = currentLine .. " " .. word
		else
			table.insert(lines, currentLine)
			currentLine = word
		end
	end
	if #currentLine > 0 then table.insert(lines, currentLine) end
	return lines
end

function NexusUI._stringHelpers.FormatTime(seconds)
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = math.floor(seconds % 60)
	if h > 0 then
		return string.format("%d:%02d:%02d", h, m, s)
	else
		return string.format("%d:%02d", m, s)
	end
end

function NexusUI._stringHelpers.FormatBytes(bytes)
	local units = { "B", "KB", "MB", "GB", "TB" }
	local i = 1
	while bytes >= 1024 and i < #units do
		bytes = bytes / 1024
		i = i + 1
	end
	return string.format("%.2f %s", bytes, units[i])
end

function NexusUI._stringHelpers.FormatPercent(v, decimals)
	decimals = decimals or 0
	return string.format("%." .. decimals .. "f%%", v * 100)
end

function NexusUI._stringHelpers.Random(length, charset)
	charset = charset or "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	local result = ""
	for i = 1, length do
		local idx = math.random(1, #charset)
		result = result .. charset:sub(idx, idx)
	end
	return result
end

NexusUI.StringHelpers = NexusUI._stringHelpers

NexusUI._tableHelpers = {}

function NexusUI._tableHelpers.Keys(t)
	local keys = {}
	for k in pairs(t) do table.insert(keys, k) end
	return keys
end

function NexusUI._tableHelpers.Values(t)
	local vals = {}
	for _, v in pairs(t) do table.insert(vals, v) end
	return vals
end

function NexusUI._tableHelpers.Count(t)
	local n = 0
	for _ in pairs(t) do n = n + 1 end
	return n
end

function NexusUI._tableHelpers.Filter(t, predicate)
	local result = {}
	for _, v in ipairs(t) do
		if predicate(v) then table.insert(result, v) end
	end
	return result
end

function NexusUI._tableHelpers.Map(t, fn)
	local result = {}
	for i, v in ipairs(t) do result[i] = fn(v, i) end
	return result
end

function NexusUI._tableHelpers.Reduce(t, fn, initial)
	local acc = initial
	for _, v in ipairs(t) do acc = fn(acc, v) end
	return acc
end

function NexusUI._tableHelpers.Find(t, predicate)
	for i, v in ipairs(t) do
		if predicate(v) then return v, i end
	end
	return nil, nil
end

function NexusUI._tableHelpers.Unique(t)
	local seen = {}
	local result = {}
	for _, v in ipairs(t) do
		if not seen[v] then
			seen[v] = true
			table.insert(result, v)
		end
	end
	return result
end

function NexusUI._tableHelpers.Flatten(t, depth)
	depth = depth or 1
	local result = {}
	for _, v in ipairs(t) do
		if type(v) == "table" and depth > 0 then
			local flat = NexusUI._tableHelpers.Flatten(v, depth - 1)
			for _, fv in ipairs(flat) do table.insert(result, fv) end
		else
			table.insert(result, v)
		end
	end
	return result
end

function NexusUI._tableHelpers.Reverse(t)
	local result = {}
	for i = #t, 1, -1 do table.insert(result, t[i]) end
	return result
end

function NexusUI._tableHelpers.Shuffle(t)
	local result = DeepCopy(t)
	for i = #result, 2, -1 do
		local j = math.random(1, i)
		result[i], result[j] = result[j], result[i]
	end
	return result
end

function NexusUI._tableHelpers.Chunk(t, size)
	local result = {}
	for i = 1, #t, size do
		local chunk = {}
		for j = i, math.min(i + size - 1, #t) do
			table.insert(chunk, t[j])
		end
		table.insert(result, chunk)
	end
	return result
end

function NexusUI._tableHelpers.Zip(t1, t2)
	local result = {}
	local len = math.min(#t1, #t2)
	for i = 1, len do
		result[i] = { t1[i], t2[i] }
	end
	return result
end

function NexusUI._tableHelpers.GroupBy(t, keyFn)
	local result = {}
	for _, v in ipairs(t) do
		local key = keyFn(v)
		if not result[key] then result[key] = {} end
		table.insert(result[key], v)
	end
	return result
end

function NexusUI._tableHelpers.SortBy(t, keyFn, descending)
	local result = DeepCopy(t)
	table.sort(result, function(a, b)
		local ka, kb = keyFn(a), keyFn(b)
		if descending then return ka > kb else return ka < kb end
	end)
	return result
end

function NexusUI._tableHelpers.Merge(...)
	local result = {}
	for _, t in ipairs({...}) do
		for k, v in pairs(t) do result[k] = v end
	end
	return result
end

function NexusUI._tableHelpers.Pick(t, keys)
	local result = {}
	for _, k in ipairs(keys) do result[k] = t[k] end
	return result
end

function NexusUI._tableHelpers.Omit(t, keys)
	local result = DeepCopy(t)
	for _, k in ipairs(keys) do result[k] = nil end
	return result
end

function NexusUI._tableHelpers.Sum(t)
	local s = 0
	for _, v in ipairs(t) do s = s + v end
	return s
end

function NexusUI._tableHelpers.Average(t)
	if #t == 0 then return 0 end
	return NexusUI._tableHelpers.Sum(t) / #t
end

function NexusUI._tableHelpers.Min(t)
	local m = t[1]
	for _, v in ipairs(t) do if v < m then m = v end end
	return m
end

function NexusUI._tableHelpers.Max(t)
	local m = t[1]
	for _, v in ipairs(t) do if v > m then m = v end end
	return m
end

NexusUI.TableHelpers = NexusUI._tableHelpers

NexusUI._instanceHelpers = {}

function NexusUI._instanceHelpers.FindDescendant(root, name, className)
	for _, desc in ipairs(root:GetDescendants()) do
		if (not name or desc.Name == name) and (not className or desc:IsA(className)) then
			return desc
		end
	end
	return nil
end

function NexusUI._instanceHelpers.FindAllDescendants(root, className)
	local result = {}
	for _, desc in ipairs(root:GetDescendants()) do
		if desc:IsA(className) then table.insert(result, desc) end
	end
	return result
end

function NexusUI._instanceHelpers.SetProperties(instance, props)
	for k, v in pairs(props) do
		pcall(function() instance[k] = v end)
	end
	return instance
end

function NexusUI._instanceHelpers.Clone(instance, props)
	local cloned = instance:Clone()
	if props then
		for k, v in pairs(props) do
			pcall(function() cloned[k] = v end)
		end
	end
	return cloned
end

function NexusUI._instanceHelpers.WaitForChild(parent, name, timeout)
	timeout = timeout or 5
	local child = parent:WaitForChild(name, timeout)
	return child
end

function NexusUI._instanceHelpers.GetChildren(parent, className)
	if not className then return parent:GetChildren() end
	local result = {}
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA(className) then table.insert(result, child) end
	end
	return result
end

function NexusUI._instanceHelpers.DestroyChildren(parent, className)
	for _, child in ipairs(parent:GetChildren()) do
		if not className or child:IsA(className) then child:Destroy() end
	end
end

NexusUI.InstanceHelpers = NexusUI._instanceHelpers

NexusUI._signalHelpers = {}

function NexusUI._signalHelpers.Once(signal, callback)
	local conn
	conn = signal:Connect(function(...)
		conn:Disconnect()
		callback(...)
	end)
	return conn
end

function NexusUI._signalHelpers.Debounce(fn, delay)
	local thread = nil
	return function(...)
		local args = {...}
		if thread then task.cancel(thread) end
		thread = task.delay(delay, function()
			thread = nil
			fn(table.unpack(args))
		end)
	end
end

function NexusUI._signalHelpers.Throttle(fn, interval)
	local lastCall = 0
	return function(...)
		local now = os.clock()
		if now - lastCall >= interval then
			lastCall = now
			fn(...)
		end
	end
end

function NexusUI._signalHelpers.Memoize(fn)
	local cache = {}
	return function(key)
		if cache[key] == nil then cache[key] = fn(key) end
		return cache[key]
	end
end

function NexusUI._signalHelpers.Retry(fn, maxAttempts, delay)
	maxAttempts = maxAttempts or 3
	delay = delay or 0.5
	local attempts = 0
	local function attempt()
		attempts = attempts + 1
		local ok, result = pcall(fn)
		if ok then return result end
		if attempts < maxAttempts then
			task.wait(delay)
			return attempt()
		end
		return nil
	end
	return attempt()
end

NexusUI.SignalHelpers = NexusUI._signalHelpers

NexusUI._buildInfo = {
	Name      = "NexusUI",
	Version   = "beta 0.0.1",
	BuildDate = "2025",
	Author    = "NexusUI Team",
	License   = "MIT",
	Platform  = "Roblox",
	Language  = "Luau",
	MinVersion = "Lua 5.1",
	Features = {
		"Multi-theme engine",
		"24 UI components",
		"Notification system",
		"Tooltip system",
		"Context menu system",
		"Modal system",
		"Command palette",
		"Event bus",
		"Config persistence",
		"Hotkey manager",
		"Plugin system",
		"Math helpers",
		"Color helpers",
		"String helpers",
		"Table helpers",
		"Instance helpers",
		"Signal helpers",
		"Layout helpers",
		"Easing presets",
		"Size presets",
		"Icon set",
		"Color presets",
		"Default configs",
		"Validators",
		"Sub-tab support",
		"Status bar",
		"Draggable windows",
		"Animated transitions",
	},
}

function NexusUI:GetBuildInfo()
	return DeepCopy(self._buildInfo)
end

function NexusUI:PrintBuildInfo()
	local info = self:GetBuildInfo()
	print(string.rep("-", 40))
	print(info.Name .. " " .. info.Version)
	print("Platform: " .. info.Platform)
	print("Language: " .. info.Language)
	print("Features: " .. #info.Features)
	print(string.rep("-", 40))
end
