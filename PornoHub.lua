-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! platoboost library

--! configuration
local service = 16153;
local secret = "e7581b92-b0b1-40c7-a3d1-17eddc52a429";
local useNonce = true;

--! wait for game to load
repeat task.wait(1) until game:IsLoaded();

--! functions
local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;

local host = "https://api.platoboost.com";
local hostOk, hostResponse = pcall(fRequest, {Url = host .. "/public/connectivity", Method = "GET"});
if not hostOk or (hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429) then
    host = "https://api.platoboost.net";
end

function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local reqOk, response = pcall(fRequest, {
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({service = service, identifier = lDigest(fGetHwid())}),
            Headers = {["Content-Type"] = "application/json"}
        });
        if not reqOk then return false, "HTTP request failed: " .. tostring(response) end
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);
            if decoded.success == true then
                cachedLink = decoded.data.url;
                cachedTime = fOsTime();
                return true, cachedLink;
            else
                return false, decoded.message;
            end
        elseif response.StatusCode == 429 then
            return false, "Rate limited. Wait 20 seconds.";
        end
        return false, "Failed to cache link.";
    else
        return true, cachedLink;
    end
end

cacheLink();

local generateNonce = function()
    math.randomseed(fOsTime() + math.floor(tick() * 1000) % 100000)
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

for _ = 1, 5 do
    local oNonce = generateNonce();
    task.wait(0.2)
    if generateNonce() == oNonce then error("platoboost nonce error.") end
end

local copyLink = function()
    local success, link = cacheLink();
    if success then fSetClipboard(link) end
end

local redeemKey = function(key)
    local nonce = generateNonce();
    local body = {identifier = lDigest(fGetHwid()), key = key}
    if useNonce then body.nonce = nonce end
    local reqOk, response = pcall(fRequest, {
        Url = host .. "/public/redeem/" .. fToString(service),
        Method = "POST",
        Body = lEncode(body),
        Headers = {["Content-Type"] = "application/json"}
    });
    if not reqOk then return false end
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else return false end
                else return true end
            else return false end
        else
            if fStringSub(decoded.message,1,27) == "unique constraint violation" then
                return false
            else return false end
        end
    end
    return false;
end

local verifyKey = function(key)
    if requestSending == true then return false end
    requestSending = true;
    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;
    if useNonce then endpoint = endpoint .. "&nonce=" .. nonce end
    local reqOk, response = pcall(fRequest, {Url = endpoint, Method = "GET"});
    requestSending = false;
    if not reqOk then return false end
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else return false end
                else return true end
            else
                if fStringSub(key,1,4) == "KEY_" then return redeemKey(key) end
                return false;
            end
        else return false end
    elseif response.StatusCode == 429 then return false
    else return false end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! PornoHub Server Finder v3 + PlatoBoost Key System
-------------------------------------------------------------------------------

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

local isSearching   = false
local foundCount    = 0
local checkedCount  = 0
local entryOrder    = 0
local currentMode   = "Public"
local selectedSort  = "Asc"
local guiOpen       = true
local keyUnlocked   = false
local isCheckingKey = false
local foundServers  = {}
local maxPingFilter = 9999

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PH_SF"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local Main

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

-- ═══════════════════════════════════════════════════════
-- AUTO-SAVE KEY SYSTEM
-- ═══════════════════════════════════════════════════════
local PH_KEY_FILE = "PH_SavedKey.txt"
local function PH_SaveKey(k)
    pcall(function()
        if writefile then writefile(PH_KEY_FILE, k) end
    end)
end
local function PH_LoadKey()
    local ok, v = pcall(function()
        if readfile then return readfile(PH_KEY_FILE) end
        return ""
    end)
    return (ok and type(v)=="string" and v~="") and v:match("^%s*(.-)%s*$") or nil
end

-- KEY GATE  (PlatoBoost)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

local KeyGate = Instance.new("Frame")
KeyGate.Size = UDim2.new(1, 0, 1, 0)
KeyGate.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
KeyGate.BackgroundTransparency = 0.1
KeyGate.BorderSizePixel = 0
KeyGate.ZIndex = 100
KeyGate.Parent = ScreenGui

local KeyCard = Instance.new("Frame", KeyGate)
KeyCard.Size = UDim2.fromOffset(340, 220)
KeyCard.Position = UDim2.new(0.5, -170, 0.5, -110)
KeyCard.BackgroundColor3 = PH_BLACK
KeyCard.BorderSizePixel = 0
KeyCard.ZIndex = 101
Instance.new("UICorner", KeyCard).CornerRadius = UDim.new(0, 14)

local KeyCardStroke = Instance.new("UIStroke", KeyCard)
KeyCardStroke.Color = PH_ORANGE
KeyCardStroke.Thickness = 1.5
KeyCardStroke.Transparency = 0.4

-- Logo
local KeyLogoW = Instance.new("TextLabel", KeyCard)
KeyLogoW.Size = UDim2.new(0, 56, 0, 26)
KeyLogoW.Position = UDim2.new(0.5, -56, 0, 18)
KeyLogoW.BackgroundTransparency = 1
KeyLogoW.Text = "porno"
KeyLogoW.Font = Enum.Font.GothamBold
KeyLogoW.TextSize = 19
KeyLogoW.TextColor3 = PH_WHITE
KeyLogoW.TextXAlignment = Enum.TextXAlignment.Right
KeyLogoW.ZIndex = 102

local KeyLogoBadge = Instance.new("TextLabel", KeyCard)
KeyLogoBadge.Size = UDim2.new(0, 40, 0, 20)
KeyLogoBadge.Position = UDim2.new(0.5, 2, 0, 21)
KeyLogoBadge.BackgroundColor3 = PH_ORANGE
KeyLogoBadge.Text = "hub"
KeyLogoBadge.Font = Enum.Font.GothamBold
KeyLogoBadge.TextSize = 13
KeyLogoBadge.TextColor3 = PH_BLACK
KeyLogoBadge.ZIndex = 102
Instance.new("UICorner", KeyLogoBadge).CornerRadius = UDim.new(0, 5)

local KeySubtitle = Instance.new("TextLabel", KeyCard)
KeySubtitle.Size = UDim2.new(1, -20, 0, 14)
KeySubtitle.Position = UDim2.new(0, 10, 0, 52)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Get key → paste below"
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.TextSize = 11
KeySubtitle.TextColor3 = PH_GREY
KeySubtitle.ZIndex = 102

-- Key TextBox
local KeyBox = Instance.new("TextBox", KeyCard)
KeyBox.Size = UDim2.new(1, -24, 0, 36)
KeyBox.Position = UDim2.new(0, 12, 0, 74)
KeyBox.BackgroundColor3 = PH_DARK
KeyBox.Text = ""
KeyBox.PlaceholderText = "KEY_xxxxxxxxxxxx"
KeyBox.PlaceholderColor3 = Color3.fromRGB(55, 55, 55)
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 13
KeyBox.TextColor3 = PH_ORANGE
KeyBox.BorderSizePixel = 0
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 102
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local KeyBoxStroke = Instance.new("UIStroke", KeyBox)
KeyBoxStroke.Color = PH_GREY
KeyBoxStroke.Thickness = 1

-- Error label
local KeyError = Instance.new("TextLabel", KeyCard)
KeyError.Size = UDim2.new(1, -20, 0, 14)
KeyError.Position = UDim2.new(0, 10, 0, 114)
KeyError.BackgroundTransparency = 1
KeyError.Text = ""
KeyError.Font = Enum.Font.Gotham
KeyError.TextSize = 11
KeyError.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyError.ZIndex = 102

-- Button row
local BtnFrame = Instance.new("Frame", KeyCard)
BtnFrame.Size = UDim2.new(1, -24, 0, 36)
BtnFrame.Position = UDim2.new(0, 12, 0, 132)
BtnFrame.BackgroundTransparency = 1
BtnFrame.ZIndex = 102
local BtnLayout = Instance.new("UIListLayout", BtnFrame)
BtnLayout.FillDirection = Enum.FillDirection.Horizontal
BtnLayout.Padding = UDim.new(0, 8)

-- Get Key button (opens link via clipboard)
local GetKeyBtn = Instance.new("TextButton", BtnFrame)
GetKeyBtn.Size = UDim2.new(0.45, 0, 1, 0)
GetKeyBtn.BackgroundColor3 = PH_DARK
GetKeyBtn.Text = "🔑 Get Key"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 12
GetKeyBtn.TextColor3 = PH_ORANGE
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.ZIndex = 102
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", GetKeyBtn).Color = PH_ORANGE

-- Unlock button
local KeySubmit = Instance.new("TextButton", BtnFrame)
KeySubmit.Size = UDim2.new(0.53, 0, 1, 0)
KeySubmit.BackgroundColor3 = PH_ORANGE
KeySubmit.Text = "UNLOCK"
KeySubmit.Font = Enum.Font.GothamBold
KeySubmit.TextSize = 13
KeySubmit.TextColor3 = PH_BLACK
KeySubmit.BorderSizePixel = 0
KeySubmit.ZIndex = 102
Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 8)

-- Get Key → copies PlatoBoost link to clipboard + shows notification
GetKeyBtn.MouseButton1Click:Connect(function()
    GetKeyBtn.Text = "..."
    task.spawn(function()
        copyLink()
        GetKeyBtn.Text = "✓ Copied!"
        -- show roblox notification with the link
        local ok, link = cacheLink()
        if ok then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "PornoHub Key",
                Text = "Link copied! Paste in browser to get key.",
                Duration = 6
            })
        end
        task.wait(2)
        GetKeyBtn.Text = "🔑 Get Key"
    end)
end)

-- Unlock → verifyKey via PlatoBoost
local function TryUnlock()
    if isCheckingKey then return end
    local entered = KeyBox.Text:match("^%s*(.-)%s*$")
    if entered == "" then
        KeyError.Text = "✗  Paste your key first"
        return
    end
    isCheckingKey = true
    KeySubmit.Text = "..."
    KeySubmit.BackgroundColor3 = Color3.fromRGB(180, 110, 0)
    KeyError.Text = ""

    task.spawn(function()
        local valid = verifyKey(entered)
        if valid then
            keyUnlocked = true
            PH_SaveKey(entered)
            KeyGate:Destroy()
        else
            KeyError.Text = "✗  Invalid or expired key"
            KeyBoxStroke.Color = Color3.fromRGB(200, 60, 60)
            task.delay(1.8, function()
                if KeyError and KeyError.Parent then
                    KeyError.Text = ""
                    KeyBoxStroke.Color = PH_GREY
                end
            end)
        end
        isCheckingKey = false
        if KeySubmit and KeySubmit.Parent then
            KeySubmit.Text = "UNLOCK"
            KeySubmit.BackgroundColor3 = PH_ORANGE
        end
    end)
end

KeySubmit.MouseButton1Click:Connect(TryUnlock)
KeyBox.FocusLost:Connect(function(enter) if enter then TryUnlock() end end)

-- Auto-login with saved key (silent, no UI)
task.spawn(function()
    task.wait(0.3)
    local saved = PH_LoadKey()
    if saved and saved ~= "" then
        local valid = verifyKey(saved)
        if valid then
            keyUnlocked = true
            if KeyGate and KeyGate.Parent then KeyGate:Destroy() end
        end
    end
end)

KeySubmit.MouseEnter:Connect(function() KeySubmit.BackgroundColor3 = Color3.fromRGB(220,130,0) end)
KeySubmit.MouseLeave:Connect(function() KeySubmit.BackgroundColor3 = PH_ORANGE end)

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- TOGGLE BUTTON
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

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

local tActive = false
local tDrag = false
local tStart, tOrigin

ToggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        tActive = true; tDrag = false
        tStart = inp.Position; tOrigin = ToggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if not tActive then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch then
        local dx = inp.Position.X - tStart.X
        local dy = inp.Position.Y - tStart.Y
        if math.abs(dx) > 8 or math.abs(dy) > 8 then tDrag = true end
        if tDrag then
            ToggleBtn.Position = UDim2.fromOffset(
                math.clamp(tOrigin.X.Offset + dx, 0, VP.X - 44),
                math.clamp(tOrigin.Y.Offset + dy, 0, VP.Y - 44)
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if not tActive then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        if not tDrag and keyUnlocked then
            guiOpen = not guiOpen
            Main.Visible = guiOpen
        end
        tActive = false; tDrag = false
    end
end)

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- MAIN FRAME
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
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
Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.4
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49,49,450,450)
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
tf.BorderSizePixel = 0; tf.ZIndex = 5

local LogoW = Instance.new("TextLabel", TopBar)
LogoW.Size = UDim2.new(0, 68, 1, 0); LogoW.Position = UDim2.new(0, 10, 0, 0)
LogoW.BackgroundTransparency = 1; LogoW.Text = "porno"
LogoW.Font = Enum.Font.GothamBold; LogoW.TextSize = 19
LogoW.TextColor3 = Color3.fromRGB(255,255,255)
LogoW.TextXAlignment = Enum.TextXAlignment.Left; LogoW.ZIndex = 6

local LogoBadge = Instance.new("TextLabel", TopBar)
LogoBadge.Size = UDim2.new(0, 44, 0, 22); LogoBadge.Position = UDim2.new(0, 72, 0.5, -11)
LogoBadge.BackgroundColor3 = Color3.fromRGB(255,255,255); LogoBadge.Text = "hub"
LogoBadge.Font = Enum.Font.GothamBold; LogoBadge.TextSize = 14
LogoBadge.TextColor3 = PH_ORANGE; LogoBadge.ZIndex = 6
Instance.new("UICorner", LogoBadge).CornerRadius = UDim.new(0, 5)

local SubT = Instance.new("TextLabel", TopBar)
SubT.Size = UDim2.new(0, 110, 1, 0); SubT.Position = UDim2.new(0, 122, 0, 0)
SubT.BackgroundTransparency = 1; SubT.Text = "Server Finder  v1.0.1"
SubT.Font = Enum.Font.Gotham; SubT.TextSize = 11
SubT.TextColor3 = Color3.fromRGB(30,30,30)
SubT.TextXAlignment = Enum.TextXAlignment.Left; SubT.ZIndex = 6

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 32, 0, 26); CloseBtn.Position = UDim2.new(1,-38,0.5,-13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(18,18,18); CloseBtn.Text = "❌"
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.TextColor3 = PH_WHITE; CloseBtn.BorderSizePixel = 0; CloseBtn.ZIndex = 7
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() guiOpen = false; Main.Visible = false end)

local dragging = false
local dragStart, frameStart

TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; frameStart = Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch) then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        Main.Position = UDim2.fromOffset(
            math.clamp(frameStart.X.Offset + dx, 0, VP.X - W),
            math.clamp(frameStart.Y.Offset + dy, 0, VP.Y - 46)
        )
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -46)
Content.Position = UDim2.new(0, 0, 0, 46)
Content.BackgroundTransparency = 1

-- ═══════════════════════════════════════════════════════
-- SERVER INFO PANEL
-- ═══════════════════════════════════════════════════════

local InfoPanel = Instance.new("Frame", ScreenGui)
InfoPanel.Size = UDim2.fromOffset(540, 262)
InfoPanel.Position = UDim2.new(0.5,-270,0.5,-131)
InfoPanel.BackgroundColor3 = PH_BLACK
InfoPanel.BorderSizePixel = 0
InfoPanel.Visible = false
InfoPanel.ZIndex = 60
InfoPanel.ClipsDescendants = true
Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0,14)
local IPStroke = Instance.new("UIStroke", InfoPanel)
IPStroke.Color = PH_ORANGE; IPStroke.Thickness = 1.5; IPStroke.Transparency = 0.3

local IPBar = Instance.new("Frame", InfoPanel)
IPBar.Size = UDim2.new(1,0,0,42); IPBar.BackgroundColor3 = PH_ORANGE
IPBar.BorderSizePixel = 0; IPBar.ZIndex = 61
Instance.new("UICorner", IPBar).CornerRadius = UDim.new(0,14)
local IPBarFix = Instance.new("Frame", IPBar)
IPBarFix.Size = UDim2.new(1,0,0,14); IPBarFix.Position = UDim2.new(0,0,1,-14)
IPBarFix.BackgroundColor3 = PH_ORANGE; IPBarFix.BorderSizePixel = 0; IPBarFix.ZIndex = 61

local IPLogoW = Instance.new("TextLabel", IPBar)
IPLogoW.Size = UDim2.new(0,56,1,0); IPLogoW.Position = UDim2.new(0,10,0,0)
IPLogoW.BackgroundTransparency = 1; IPLogoW.Text = "porno"
IPLogoW.Font = Enum.Font.GothamBold; IPLogoW.TextSize = 17
IPLogoW.TextColor3 = Color3.fromRGB(255,255,255)
IPLogoW.TextXAlignment = Enum.TextXAlignment.Left; IPLogoW.ZIndex = 62
local IPLogoBadge = Instance.new("TextLabel", IPBar)
IPLogoBadge.Size = UDim2.new(0,40,0,20); IPLogoBadge.Position = UDim2.new(0,68,0.5,-10)
IPLogoBadge.BackgroundColor3 = Color3.fromRGB(255,255,255); IPLogoBadge.Text = "hub"
IPLogoBadge.Font = Enum.Font.GothamBold; IPLogoBadge.TextSize = 12
IPLogoBadge.TextColor3 = PH_ORANGE; IPLogoBadge.ZIndex = 62
Instance.new("UICorner", IPLogoBadge).CornerRadius = UDim.new(0,5)
local IPTitleSub = Instance.new("TextLabel", IPBar)
IPTitleSub.Size = UDim2.new(0,90,1,0); IPTitleSub.Position = UDim2.new(0,114,0,0)
IPTitleSub.BackgroundTransparency = 1; IPTitleSub.Text = "Server Info"
IPTitleSub.Font = Enum.Font.Gotham; IPTitleSub.TextSize = 10
IPTitleSub.TextColor3 = Color3.fromRGB(30,30,30)
IPTitleSub.TextXAlignment = Enum.TextXAlignment.Left; IPTitleSub.ZIndex = 62

local IPClose = Instance.new("TextButton", IPBar)
IPClose.Size = UDim2.new(0,30,0,24); IPClose.Position = UDim2.new(1,-36,0.5,-12)
IPClose.BackgroundColor3 = Color3.fromRGB(18,18,18); IPClose.Text = "❌"
IPClose.Font = Enum.Font.GothamBold; IPClose.TextSize = 13
IPClose.TextColor3 = PH_WHITE; IPClose.BorderSizePixel = 0; IPClose.ZIndex = 62
Instance.new("UICorner", IPClose).CornerRadius = UDim.new(0,5)
IPClose.MouseButton1Click:Connect(function() liveToken += 1; InfoPanel.Visible = false end)

-- Stats row
local IPStatsRow = Instance.new("Frame", InfoPanel)
IPStatsRow.Size = UDim2.new(1,-20,0,64); IPStatsRow.Position = UDim2.new(0,10,0,50)
IPStatsRow.BackgroundColor3 = PH_DARK; IPStatsRow.BorderSizePixel = 0; IPStatsRow.ZIndex = 61
Instance.new("UICorner", IPStatsRow).CornerRadius = UDim.new(0,8)
local IPSLayout = Instance.new("UIListLayout", IPStatsRow)
IPSLayout.FillDirection = Enum.FillDirection.Horizontal
IPSLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
IPSLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local function MakeStat(icon, defaultVal)
    local f = Instance.new("Frame", IPStatsRow)
    f.Size = UDim2.new(0.33,0,1,0); f.BackgroundTransparency = 1; f.ZIndex = 62
    local ic = Instance.new("TextLabel", f)
    ic.Size = UDim2.new(1,0,0,22); ic.Position = UDim2.new(0,0,0,8)
    ic.BackgroundTransparency = 1; ic.Text = icon
    ic.Font = Enum.Font.GothamBold; ic.TextSize = 16; ic.ZIndex = 63
    local vl = Instance.new("TextLabel", f)
    vl.Size = UDim2.new(1,0,0,18); vl.Position = UDim2.new(0,0,0,30)
    vl.BackgroundTransparency = 1; vl.Text = defaultVal
    vl.Font = Enum.Font.GothamBold; vl.TextSize = 12
    vl.TextColor3 = PH_ORANGE; vl.ZIndex = 63
    return ic, vl
end
local _, IPStatPlayers = MakeStat("👥", "-/-")
local _, IPStatPing    = MakeStat("📶", "-ms")
local _, IPStatFPS     = MakeStat("🎮", "-fps")

local IPID = Instance.new("TextLabel", InfoPanel)
IPID.Size = UDim2.new(1,-20,0,14); IPID.Position = UDim2.new(0,10,0,120)
IPID.BackgroundTransparency = 1; IPID.Text = "ID: ..."
IPID.Font = Enum.Font.Gotham; IPID.TextSize = 9
IPID.TextColor3 = Color3.fromRGB(55,55,55)
IPID.TextXAlignment = Enum.TextXAlignment.Left; IPID.ZIndex = 61

local IPLiveTitle = Instance.new("TextLabel", InfoPanel)
IPLiveTitle.Size = UDim2.new(1,-20,0,14); IPLiveTitle.Position = UDim2.new(0,10,0,126)
IPLiveTitle.BackgroundTransparency = 1; IPLiveTitle.Text = "LIVE SERVER DATA"
IPLiveTitle.Font = Enum.Font.GothamBold; IPLiveTitle.TextSize = 9
IPLiveTitle.TextColor3 = PH_GREY
IPLiveTitle.TextXAlignment = Enum.TextXAlignment.Left; IPLiveTitle.ZIndex = 61

-- Live info container
local IPLiveBox = Instance.new("Frame", InfoPanel)
IPLiveBox.Size = UDim2.new(1,-20,0,78); IPLiveBox.Position = UDim2.new(0,10,0,142)
IPLiveBox.BackgroundColor3 = PH_DARK; IPLiveBox.BorderSizePixel = 0; IPLiveBox.ZIndex = 61
Instance.new("UICorner", IPLiveBox).CornerRadius = UDim.new(0,8)

-- Row 1: Uptime + LIVE badge + last refresh
local IPUptimeLbl = Instance.new("TextLabel", IPLiveBox)
IPUptimeLbl.Size = UDim2.new(0,180,0,20); IPUptimeLbl.Position = UDim2.new(0,10,0,6)
IPUptimeLbl.BackgroundTransparency = 1; IPUptimeLbl.Text = "⏱  Found 0s ago"
IPUptimeLbl.Font = Enum.Font.GothamBold; IPUptimeLbl.TextSize = 11
IPUptimeLbl.TextColor3 = PH_WHITE; IPUptimeLbl.TextXAlignment = Enum.TextXAlignment.Left; IPUptimeLbl.ZIndex = 62

local IPLiveDot = Instance.new("TextLabel", IPLiveBox)
IPLiveDot.Size = UDim2.new(0,60,0,20); IPLiveDot.Position = UDim2.new(0.5,-30,0,6)
IPLiveDot.BackgroundTransparency = 1; IPLiveDot.Text = "● LIVE"
IPLiveDot.Font = Enum.Font.GothamBold; IPLiveDot.TextSize = 11
IPLiveDot.TextColor3 = Color3.fromRGB(80,220,80); IPLiveDot.ZIndex = 62

local IPLastUpdateLbl = Instance.new("TextLabel", IPLiveBox)
IPLastUpdateLbl.Size = UDim2.new(0,150,0,20); IPLastUpdateLbl.Position = UDim2.new(1,-155,0,6)
IPLastUpdateLbl.BackgroundTransparency = 1; IPLastUpdateLbl.Text = "⟳ just now"
IPLastUpdateLbl.Font = Enum.Font.Gotham; IPLastUpdateLbl.TextSize = 10
IPLastUpdateLbl.TextColor3 = PH_GREY; IPLastUpdateLbl.TextXAlignment = Enum.TextXAlignment.Right; IPLastUpdateLbl.ZIndex = 62

-- Row 2: Fill bar + % label + trend
local IPBarBg = Instance.new("Frame", IPLiveBox)
IPBarBg.Size = UDim2.new(1,-100,0,16); IPBarBg.Position = UDim2.new(0,10,0,34)
IPBarBg.BackgroundColor3 = Color3.fromRGB(40,40,40); IPBarBg.BorderSizePixel = 0; IPBarBg.ZIndex = 62
Instance.new("UICorner", IPBarBg).CornerRadius = UDim.new(0,6)

local IPFillBar = Instance.new("Frame", IPBarBg)
IPFillBar.Size = UDim2.new(0,0,1,0); IPFillBar.BackgroundColor3 = Color3.fromRGB(100,220,100)
IPFillBar.BorderSizePixel = 0; IPFillBar.ZIndex = 63
Instance.new("UICorner", IPFillBar).CornerRadius = UDim.new(0,6)

local IPFillLbl = Instance.new("TextLabel", IPLiveBox)
IPFillLbl.Size = UDim2.new(0,42,0,18); IPFillLbl.Position = UDim2.new(1,-90,0,31)
IPFillLbl.BackgroundTransparency = 1; IPFillLbl.Text = "0%"
IPFillLbl.Font = Enum.Font.GothamBold; IPFillLbl.TextSize = 11
IPFillLbl.TextColor3 = PH_ORANGE; IPFillLbl.ZIndex = 62

local IPTrendLbl = Instance.new("TextLabel", IPLiveBox)
IPTrendLbl.Size = UDim2.new(0,42,0,18); IPTrendLbl.Position = UDim2.new(1,-46,0,31)
IPTrendLbl.BackgroundTransparency = 1; IPTrendLbl.Text = "→ 0"
IPTrendLbl.Font = Enum.Font.GothamBold; IPTrendLbl.TextSize = 11
IPTrendLbl.TextColor3 = PH_GREY; IPTrendLbl.ZIndex = 62

-- Row 3: Status message
local IPServerStatus = Instance.new("TextLabel", IPLiveBox)
IPServerStatus.Size = UDim2.new(1,-20,0,18); IPServerStatus.Position = UDim2.new(0,10,0,57)
IPServerStatus.BackgroundTransparency = 1; IPServerStatus.Text = "Waiting for data..."
IPServerStatus.Font = Enum.Font.Gotham; IPServerStatus.TextSize = 10
IPServerStatus.TextColor3 = PH_GREY; IPServerStatus.TextXAlignment = Enum.TextXAlignment.Left; IPServerStatus.ZIndex = 62


local IPJoin = Instance.new("TextButton", InfoPanel)
IPJoin.Size = UDim2.new(1,-20,0,36); IPJoin.Position = UDim2.new(0,10,1,-46)
IPJoin.BackgroundColor3 = PH_ORANGE; IPJoin.Text = "⚡  JOIN THIS SERVER"
IPJoin.Font = Enum.Font.GothamBold; IPJoin.TextSize = 13
IPJoin.TextColor3 = PH_BLACK; IPJoin.BorderSizePixel = 0; IPJoin.ZIndex = 62
Instance.new("UICorner", IPJoin).CornerRadius = UDim.new(0,8)
IPJoin.MouseEnter:Connect(function() IPJoin.BackgroundColor3 = Color3.fromRGB(220,130,0) end)
IPJoin.MouseLeave:Connect(function() IPJoin.BackgroundColor3 = PH_ORANGE end)

local currentInfoJobId = ""
local liveToken = 0   -- increment to stop previous refresh loop

-- ─── helper: format seconds into human time ─────────────────────
local function FmtTime(s)
    s = math.floor(s)
    if s < 60 then return s.."s"
    elseif s < 3600 then return math.floor(s/60).."m "..s%60 .."s"
    else return math.floor(s/3600).."h "..math.floor(s%3600/60).."m" end
end

-- ─── Start live auto-refresh loop ────────────────────────────────
local function StartLiveRefresh(jobId, initPlaying, initMaxP, initPing, initFps, foundTick)
    liveToken += 1
    local myToken = liveToken
    local lastPlaying = initPlaying
    local lastRefreshTick = tick()

    -- Second ticker: uptime + LIVE blink + last-refresh counter
    task.spawn(function()
        local dotOn = true
        while myToken == liveToken and InfoPanel.Visible do
            if IPUptimeLbl and IPUptimeLbl.Parent then
                IPUptimeLbl.Text = "⏱  Found "..FmtTime(tick()-foundTick).." ago"
            end
            if IPLastUpdateLbl and IPLastUpdateLbl.Parent then
                local ago = math.floor(tick()-lastRefreshTick)
                IPLastUpdateLbl.Text = "⟳ "..(ago==0 and "just now" or ago.."s ago")
            end
            dotOn = not dotOn
            if IPLiveDot and IPLiveDot.Parent then
                IPLiveDot.TextColor3 = dotOn and Color3.fromRGB(80,220,80) or Color3.fromRGB(30,90,30)
            end
            task.wait(1)
        end
    end)

    -- Data refresh: every 8 seconds, re-query Roblox API for this server
    task.spawn(function()
        task.wait(2)
        while myToken == liveToken and InfoPanel.Visible do
            if IPServerStatus and IPServerStatus.Parent then
                IPServerStatus.Text = "Refreshing data..."
                IPServerStatus.TextColor3 = PH_GREY
            end
            local found = false
            local cursor = ""
            local pages = 0
            repeat
                local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(PlaceId)
                if cursor ~= "" then url = url.."&cursor="..HttpService:UrlEncode(cursor) end
                local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
                if not ok or not res or not res.data then break end
                for _, sv in ipairs(res.data) do
                    if sv.id == jobId then
                        local newP   = sv.playing or lastPlaying
                        local newMax = sv.maxPlayers or initMaxP
                        local newPing = sv.ping or initPing
                        local newFps  = sv.fps or initFps
                        local diff   = newP - lastPlaying
                        -- update stat labels
                        if IPStatPlayers and IPStatPlayers.Parent then
                            IPStatPlayers.Text = tostring(newP).."/"..tostring(newMax)
                        end
                        if IPStatPing and IPStatPing.Parent then
                            local pc = newPing<80 and Color3.fromRGB(100,220,100) or newPing<150 and PH_ORANGE or Color3.fromRGB(220,80,80)
                            IPStatPing.Text = tostring(newPing).."ms"; IPStatPing.TextColor3 = pc
                        end
                        if IPStatFPS and IPStatFPS.Parent then
                            IPStatFPS.Text = tostring(math.floor(newFps)).."fps"
                        end
                        -- fill bar
                        local pct = newMax>0 and math.clamp(newP/newMax,0,1) or 0
                        if IPFillBar and IPFillBar.Parent then
                            IPFillBar.Size = UDim2.new(pct,0,1,0)
                            IPFillBar.BackgroundColor3 = pct>0.8 and Color3.fromRGB(220,80,80) or pct>0.5 and PH_ORANGE or Color3.fromRGB(100,220,100)
                        end
                        if IPFillLbl and IPFillLbl.Parent then
                            IPFillLbl.Text = math.floor(pct*100).."%"
                        end
                        -- trend arrow
                        if IPTrendLbl and IPTrendLbl.Parent then
                            if diff>0 then IPTrendLbl.Text="↑ +"..diff; IPTrendLbl.TextColor3=Color3.fromRGB(100,220,100)
                            elseif diff<0 then IPTrendLbl.Text="↓ "..diff; IPTrendLbl.TextColor3=Color3.fromRGB(220,80,80)
                            else IPTrendLbl.Text="→ 0"; IPTrendLbl.TextColor3=PH_GREY end
                        end
                        lastPlaying = newP
                        lastRefreshTick = tick()
                        if IPServerStatus and IPServerStatus.Parent then
                            IPServerStatus.Text = "✓ Server active  –  "..tostring(newP).."/"..tostring(newMax).." players"
                            IPServerStatus.TextColor3 = Color3.fromRGB(100,220,100)
                        end
                        found = true; break
                    end
                end
                if not found then cursor = res.nextPageCursor or ""; pages+=1; task.wait(0.25) end
            until found or cursor=="" or pages>=3
            if not found then
                if IPServerStatus and IPServerStatus.Parent then
                    IPServerStatus.Text = "⚠  Server may have closed"
                    IPServerStatus.TextColor3 = Color3.fromRGB(255,80,80)
                end
                lastRefreshTick = tick()
            end
            task.wait(8)
        end
    end)
end

-- ─── Show server info panel ───────────────────────────────────────
local function ShowServerInfo(jobId, playing, maxP, ping, fps, foundTick)
    currentInfoJobId = jobId
    -- Static initial values
    IPStatPlayers.Text = tostring(playing).."/"..tostring(maxP)
    local pingC = PH_GREY
    if ping then pingC = ping<80 and Color3.fromRGB(100,220,100) or ping<150 and PH_ORANGE or Color3.fromRGB(220,80,80) end
    IPStatPing.Text = ping and (tostring(ping).."ms") or "?ms"; IPStatPing.TextColor3 = pingC
    IPStatFPS.Text = fps and (tostring(math.floor(fps)).."fps") or "?fps"
    IPID.Text = "ID: "..tostring(jobId)
    -- Init fill bar
    local pct = maxP>0 and math.clamp(playing/maxP,0,1) or 0
    IPFillBar.Size = UDim2.new(pct,0,1,0)
    IPFillBar.BackgroundColor3 = pct>0.8 and Color3.fromRGB(220,80,80) or pct>0.5 and PH_ORANGE or Color3.fromRGB(100,220,100)
    IPFillLbl.Text = math.floor(pct*100).."%"
    IPTrendLbl.Text = "→ 0"; IPTrendLbl.TextColor3 = PH_GREY
    IPUptimeLbl.Text = "⏱  Found 0s ago"
    IPLastUpdateLbl.Text = "⟳ just now"
    IPServerStatus.Text = "Fetching live data..."; IPServerStatus.TextColor3 = PH_GREY
    IPLiveDot.TextColor3 = Color3.fromRGB(80,220,80)
    InfoPanel.Visible = true
    -- JOIN button
    local conn; conn = IPJoin.MouseButton1Click:Connect(function()
        conn:Disconnect()
        IPJoin.Text = "Joining..."
        TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
    end)
    -- Start live refresh
    StartLiveRefresh(jobId, playing, maxP, ping or 9999, fps or 60, foundTick or tick())
end

local function JoinBestServer(setStatus)
    if #foundServers == 0 then setStatus("No servers found!", Color3.fromRGB(255,60,60)) return end
    local best = foundServers[1]
    for _, sv in ipairs(foundServers) do if sv.ping < best.ping then best = sv end end
    setStatus("Joining best (" .. best.ping .. "ms)...", Color3.fromRGB(255,200,0))
    TeleportService:TeleportToPlaceInstance(PlaceId, best.jobId, LocalPlayer)
end

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- MOBILE LAYOUT
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

if isMobile then
    local LeftCol = Instance.new("Frame", Content)
    LeftCol.Size = UDim2.new(0.48, -6, 1, 0); LeftCol.Position = UDim2.new(0, 8, 0, 0)
    LeftCol.BackgroundTransparency = 1
    local LeftLayout = Instance.new("UIListLayout", LeftCol)
    LeftLayout.Padding = UDim.new(0, 6); LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local LeftPad = Instance.new("UIPadding", LeftCol)
    LeftPad.PaddingTop = UDim.new(0, 8); LeftPad.PaddingBottom = UDim.new(0, 8)

    local RightCol = Instance.new("Frame", Content)
    RightCol.Size = UDim2.new(0.52, -10, 1, 0); RightCol.Position = UDim2.new(0.48, 2, 0, 0)
    RightCol.BackgroundTransparency = 1
    local RightLayout = Instance.new("UIListLayout", RightCol)
    RightLayout.Padding = UDim.new(0, 6); RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local RightPad = Instance.new("UIPadding", RightCol)
    RightPad.PaddingTop = UDim.new(0, 8); RightPad.PaddingRight = UDim.new(0, 8); RightPad.PaddingBottom = UDim.new(0, 8)

    local function MiniLbl(parent, txt, lo)
        local l = Instance.new("TextLabel", parent)
        l.Size = UDim2.new(1, 0, 0, 14); l.BackgroundTransparency = 1
        l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 9
        l.TextColor3 = PH_GREY; l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = lo
        return l
    end
    local function CardRow(parent, h, lo)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1, 0, 0, h); f.BackgroundColor3 = PH_CARD
        f.BorderSizePixel = 0; f.LayoutOrder = lo
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
    ModeP.PaddingLeft = UDim.new(0,5); ModeP.PaddingRight = UDim.new(0,5)
    ModeP.PaddingTop = UDim.new(0,5); ModeP.PaddingBottom = UDim.new(0,5)
    local modes = {"Public","Friends","VIP"}; local modeBtns = {}
    for _, m in ipairs(modes) do
        local mb = Instance.new("TextButton", ModeCard)
        mb.Size = UDim2.new(1, 0, 0, 14); mb.BackgroundColor3 = m=="Public" and PH_ORANGE or PH_DARK
        mb.Text = m; mb.Font = Enum.Font.GothamBold; mb.TextSize = 10
        mb.TextColor3 = m=="Public" and PH_BLACK or PH_GREY; mb.BorderSizePixel = 0
        Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 5)
        modeBtns[m] = mb
        mb.MouseButton1Click:Connect(function()
            currentMode = m
            for _, k in ipairs(modes) do modeBtns[k].BackgroundColor3 = PH_DARK; modeBtns[k].TextColor3 = PH_GREY end
            mb.BackgroundColor3 = PH_ORANGE; mb.TextColor3 = PH_BLACK
        end)
    end

    MiniLbl(LeftCol, "MAX PLAYERS", 3)
    local CountCard = CardRow(LeftCol, 34, 4)
    local CountBox = Instance.new("TextBox", CountCard)
    CountBox.Size = UDim2.new(0.45,0,0.8,0); CountBox.Position = UDim2.new(0,6,0.1,0)
    CountBox.BackgroundColor3 = PH_DARK; CountBox.Text = "10"
    CountBox.Font = Enum.Font.GothamBold; CountBox.TextSize = 15
    CountBox.TextColor3 = PH_ORANGE; CountBox.BorderSizePixel = 0; CountBox.ClearTextOnFocus = false
    Instance.new("UICorner", CountBox).CornerRadius = UDim.new(0, 6)
    local qrow = Instance.new("Frame", CountCard)
    qrow.Size = UDim2.new(0.52,0,1,0); qrow.Position = UDim2.new(0.47,0,0,0); qrow.BackgroundTransparency = 1
    local qrl = Instance.new("UIListLayout", qrow)
    qrl.FillDirection = Enum.FillDirection.Horizontal; qrl.Padding = UDim.new(0,2); qrl.VerticalAlignment = Enum.VerticalAlignment.Center
    for _, v in ipairs({5,10,20}) do
        local qb = Instance.new("TextButton", qrow)
        qb.Size = UDim2.new(0,28,0,22); qb.BackgroundColor3 = PH_DARK
        qb.Text = tostring(v); qb.Font = Enum.Font.GothamBold; qb.TextSize = 10
        qb.TextColor3 = PH_ORANGE; qb.BorderSizePixel = 0
        Instance.new("UICorner", qb).CornerRadius = UDim.new(0, 5)
        qb.MouseButton1Click:Connect(function() CountBox.Text = tostring(v) end)
    end

    MiniLbl(LeftCol, "MAX PING", 5)
    local PingCard = CardRow(LeftCol, 34, 6)
    local PingBox = Instance.new("TextBox", PingCard)
    PingBox.Size = UDim2.new(0.45,0,0.8,0); PingBox.Position = UDim2.new(0,6,0.1,0)
    PingBox.BackgroundColor3 = PH_DARK; PingBox.Text = "any"
    PingBox.Font = Enum.Font.GothamBold; PingBox.TextSize = 13
    PingBox.TextColor3 = Color3.fromRGB(100,220,100); PingBox.BorderSizePixel = 0; PingBox.ClearTextOnFocus = false
    Instance.new("UICorner", PingBox).CornerRadius = UDim.new(0, 6)
    local pqrow = Instance.new("Frame", PingCard)
    pqrow.Size = UDim2.new(0.52,0,1,0); pqrow.Position = UDim2.new(0.47,0,0,0); pqrow.BackgroundTransparency = 1
    local pqrl = Instance.new("UIListLayout", pqrow)
    pqrl.FillDirection = Enum.FillDirection.Horizontal; pqrl.Padding = UDim.new(0,2); pqrl.VerticalAlignment = Enum.VerticalAlignment.Center
    for _, pv in ipairs({50,100,200}) do
        local pb = Instance.new("TextButton", pqrow)
        pb.Size = UDim2.new(0,28,0,22); pb.BackgroundColor3 = PH_DARK
        pb.Text = tostring(pv); pb.Font = Enum.Font.GothamBold; pb.TextSize = 10
        pb.TextColor3 = Color3.fromRGB(100,220,100); pb.BorderSizePixel = 0
        Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 5)
        pb.MouseButton1Click:Connect(function() PingBox.Text = tostring(pv); maxPingFilter = pv end)
    end
    PingBox.FocusLost:Connect(function()
        local v = tonumber(PingBox.Text)
        if v and v > 0 then maxPingFilter = v else maxPingFilter = 9999; PingBox.Text = "any" end
    end)

    MiniLbl(LeftCol, "SORT", 7)
    local SortCard = CardRow(LeftCol, 30, 8)
    local SortRow = Instance.new("Frame", SortCard)
    SortRow.Size = UDim2.new(1,0,1,0); SortRow.BackgroundTransparency = 1
    local srl = Instance.new("UIListLayout", SortRow)
    srl.FillDirection = Enum.FillDirection.Horizontal; srl.Padding = UDim.new(0,4); srl.VerticalAlignment = Enum.VerticalAlignment.Center
    local srp = Instance.new("UIPadding", SortRow)
    srp.PaddingLeft = UDim.new(0,5); srp.PaddingTop = UDim.new(0,4)
    local sortBtns = {}
    for _, pair in ipairs({{"Asc","↑ Few"},{"Desc","↑ Most"}}) do
        local k, lbl = pair[1], pair[2]
        local sb = Instance.new("TextButton", SortRow)
        sb.Size = UDim2.new(0,50,0,22); sb.BackgroundColor3 = k=="Asc" and PH_ORANGE or PH_DARK
        sb.Text = lbl; sb.Font = Enum.Font.GothamBold; sb.TextSize = 10
        sb.TextColor3 = k=="Asc" and PH_BLACK or PH_GREY; sb.BorderSizePixel = 0
        Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 5)
        sortBtns[k] = sb
        sb.MouseButton1Click:Connect(function()
            selectedSort = k
            for _, key in ipairs({"Asc","Desc"}) do sortBtns[key].BackgroundColor3 = PH_DARK; sortBtns[key].TextColor3 = PH_GREY end
            sb.BackgroundColor3 = PH_ORANGE; sb.TextColor3 = PH_BLACK
        end)
    end

    MiniLbl(LeftCol, "STATUS", 9)
    local StatusCard = CardRow(LeftCol, 30, 10)
    local StatusDot = Instance.new("Frame", StatusCard)
    StatusDot.Size = UDim2.new(0,7,0,7); StatusDot.Position = UDim2.new(0,8,0.5,-3)
    StatusDot.BackgroundColor3 = PH_GREY; StatusDot.BorderSizePixel = 0
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    local StatusLabel = Instance.new("TextLabel", StatusCard)
    StatusLabel.Size = UDim2.new(1,-24,1,0); StatusLabel.Position = UDim2.new(0,22,0,0)
    StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Ready."
    StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 10
    StatusLabel.TextColor3 = PH_GREY; StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function SetStatus(txt, col) StatusLabel.Text = txt; StatusDot.BackgroundColor3 = col or PH_ORANGE end
    local function UpdateStatus() SetStatus(("✓%d / %d"):format(foundCount, checkedCount), Color3.fromRGB(100,220,100)) end

    MiniLbl(RightCol, "RESULTS", 1)
    local ListScroll = Instance.new("ScrollingFrame", RightCol)
    ListScroll.Size = UDim2.new(1,0,0,152); ListScroll.LayoutOrder = 2
    ListScroll.BackgroundColor3 = PH_DARK; ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 2; ListScroll.ScrollBarImageColor3 = PH_ORANGE
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; ListScroll.CanvasSize = UDim2.new(0,0,0,0)
    Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 8)
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0,3); ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local lp = Instance.new("UIPadding", ListScroll)
    lp.PaddingLeft = UDim.new(0,5); lp.PaddingRight = UDim.new(0,5)
    lp.PaddingTop = UDim.new(0,5); lp.PaddingBottom = UDim.new(0,5)
    local EmptyTxt = Instance.new("TextLabel", ListScroll)
    EmptyTxt.Size = UDim2.new(1,0,0,30); EmptyTxt.BackgroundTransparency = 1
    EmptyTxt.Text = "No servers yet."; EmptyTxt.Font = Enum.Font.Gotham
    EmptyTxt.TextSize = 11; EmptyTxt.TextColor3 = Color3.fromRGB(50,50,50)

    local function AddEntry(jobId, playing, maxP, ping, fps, tokens)
        EmptyTxt.Visible = false; entryOrder += 1
        table.insert(foundServers, {jobId=jobId, playing=playing, maxP=maxP, ping=ping or 9999, fps=fps, tokens=tokens, foundTick=tick()})
        local entry = Instance.new("Frame", ListScroll)
        entry.Size = UDim2.new(1,0,0,36); entry.BackgroundColor3 = PH_CARD
        entry.BorderSizePixel = 0; entry.LayoutOrder = entryOrder
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 6)
        local acc = Instance.new("Frame", entry)
        acc.Size = UDim2.new(0,2,0.6,0); acc.Position = UDim2.new(0,0,0.2,0)
        acc.BackgroundColor3 = PH_ORANGE; acc.BorderSizePixel = 0
        Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)
        local plr = Instance.new("TextLabel", entry)
        plr.Size = UDim2.new(0,44,1,0); plr.Position = UDim2.new(0,7,0,0)
        plr.BackgroundTransparency = 1; plr.Text = tostring(playing).."/"..tostring(maxP)
        plr.Font = Enum.Font.GothamBold; plr.TextSize = 11
        plr.TextColor3 = PH_ORANGE; plr.TextXAlignment = Enum.TextXAlignment.Left
        local pingC = PH_GREY
        if ping then pingC = ping<80 and Color3.fromRGB(100,220,100) or ping<150 and PH_ORANGE or Color3.fromRGB(220,80,80) end
        local pingL = Instance.new("TextLabel", entry)
        pingL.Size = UDim2.new(0,36,1,0); pingL.Position = UDim2.new(0,54,0,0)
        pingL.BackgroundTransparency = 1; pingL.Text = ping and (tostring(ping).."ms") or "?ms"
        pingL.Font = Enum.Font.Gotham; pingL.TextSize = 10
        pingL.TextColor3 = pingC; pingL.TextXAlignment = Enum.TextXAlignment.Left
        -- INFO button
        local ib = Instance.new("TextButton", entry)
        ib.Size = UDim2.new(0,34,0,22); ib.Position = UDim2.new(1,-92,0.5,-11)
        ib.BackgroundColor3 = PH_DARK; ib.Text = "INFO"
        ib.Font = Enum.Font.GothamBold; ib.TextSize = 9; ib.TextColor3 = PH_GREY; ib.BorderSizePixel = 0
        Instance.new("UICorner", ib).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", ib).Color = PH_GREY
        ib.MouseButton1Click:Connect(function()
            local ft = tick()
            for _, sv in ipairs(foundServers) do if sv.jobId==jobId then ft=sv.foundTick or ft break end end
            ShowServerInfo(jobId, playing, maxP, ping, fps, ft)
        end)
        local jb = Instance.new("TextButton", entry)
        jb.Size = UDim2.new(0,44,0,22); jb.Position = UDim2.new(1,-50,0.5,-11)
        jb.BackgroundColor3 = PH_ORANGE; jb.Text = "JOIN"
        jb.Font = Enum.Font.GothamBold; jb.TextSize = 10; jb.TextColor3 = PH_BLACK; jb.BorderSizePixel = 0
        Instance.new("UICorner", jb).CornerRadius = UDim.new(0, 5)
        jb.MouseButton1Click:Connect(function()
            jb.Text = "..."; jb.BackgroundColor3 = Color3.fromRGB(180,110,0)
            SetStatus("Joining...", Color3.fromRGB(255,200,0))
            TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
        end)
    end

    local BtnRow = Instance.new("Frame", RightCol)
    BtnRow.Size = UDim2.new(1,0,0,34); BtnRow.BackgroundTransparency = 1; BtnRow.LayoutOrder = 3
    local brl = Instance.new("UIListLayout", BtnRow)
    brl.FillDirection = Enum.FillDirection.Horizontal; brl.Padding = UDim.new(0,5)
    local SearchBtn = Instance.new("TextButton", BtnRow)
    SearchBtn.Size = UDim2.new(0.62,0,1,0); SearchBtn.BackgroundColor3 = PH_ORANGE
    SearchBtn.Text = "SEARCH"; SearchBtn.Font = Enum.Font.GothamBold
    SearchBtn.TextSize = 12; SearchBtn.TextColor3 = PH_BLACK; SearchBtn.BorderSizePixel = 0
    Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 8)
    local ClearBtn = Instance.new("TextButton", BtnRow)
    ClearBtn.Size = UDim2.new(0.36,0,1,0); ClearBtn.BackgroundColor3 = PH_DARK
    ClearBtn.Text = "CLEAR"; ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextSize = 12; ClearBtn.TextColor3 = PH_GREY; ClearBtn.BorderSizePixel = 0
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)
    local BestRow2 = Instance.new("Frame", RightCol)
    BestRow2.Size = UDim2.new(1,0,0,28); BestRow2.BackgroundTransparency = 1; BestRow2.LayoutOrder = 4
    local BestBtn2 = Instance.new("TextButton", BestRow2)
    BestBtn2.Size = UDim2.new(1,0,1,0); BestBtn2.BackgroundColor3 = Color3.fromRGB(30,80,30)
    BestBtn2.Text = "⚡ JOIN BEST (min ping)"; BestBtn2.Font = Enum.Font.GothamBold
    BestBtn2.TextSize = 10; BestBtn2.TextColor3 = Color3.fromRGB(100,220,100); BestBtn2.BorderSizePixel = 0
    Instance.new("UICorner", BestBtn2).CornerRadius = UDim.new(0, 8)
    BestBtn2.MouseButton1Click:Connect(function() JoinBestServer(SetStatus) end)

    local function ClearList()
        for _, cc in ipairs(ListScroll:GetChildren()) do if cc:IsA("Frame") then cc:Destroy() end end
        foundCount=0; checkedCount=0; entryOrder=0; foundServers={}
        EmptyTxt.Visible = true; SetStatus("Cleared.", PH_GREY)
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
                    foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping, s.fps, s.playerTokens); UpdateStatus()
                end
            end
            cursor = res.nextPageCursor or ""; task.wait(0.3)
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
                foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping, s.fps, s.playerTokens); UpdateStatus()
            end
        end
    end
    SearchBtn.MouseButton1Click:Connect(function()
        if isSearching then isSearching=false; SearchBtn.Text="SEARCH"; SearchBtn.BackgroundColor3=PH_ORANGE; return end
        local maxP = tonumber(CountBox.Text)
        if not maxP or maxP < 1 then SetStatus("Invalid!", Color3.fromRGB(255,60,60)) return end
        task.spawn(function()
            isSearching=true; SearchBtn.Text="■ STOP"; SearchBtn.BackgroundColor3=Color3.fromRGB(200,60,60)
            SetStatus("Searching...", PH_ORANGE)
            if currentMode=="Public" then FetchPublic(maxP, selectedSort) else FetchOther(currentMode, maxP) end
            if isSearching then
                SetStatus(foundCount==0 and "None found." or ("Done! "..foundCount.." found."),
                    foundCount==0 and Color3.fromRGB(255,80,80) or Color3.fromRGB(100,220,100))
            end
            isSearching=false; SearchBtn.Text="SEARCH"; SearchBtn.BackgroundColor3=PH_ORANGE
        end)
    end)

else
    -- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
    -- DESKTOP LAYOUT
    -- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

    local Scroll = Instance.new("ScrollingFrame", Content)
    Scroll.Size = UDim2.new(1,0,1,0); Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0; Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = PH_ORANGE; Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    local SL = Instance.new("UIListLayout", Scroll)
    SL.Padding = UDim.new(0,8); SL.SortOrder = Enum.SortOrder.LayoutOrder
    local SP = Instance.new("UIPadding", Scroll)
    SP.PaddingLeft = UDim.new(0,12); SP.PaddingRight = UDim.new(0,12)
    SP.PaddingTop = UDim.new(0,10); SP.PaddingBottom = UDim.new(0,10)

    local function GF(lo)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1,0,0,0); f.AutomaticSize = Enum.AutomaticSize.Y
        f.BackgroundTransparency = 1; f.LayoutOrder = lo
        local l = Instance.new("UIListLayout", f)
        l.Padding = UDim.new(0,5); l.SortOrder = Enum.SortOrder.LayoutOrder
        return f
    end
    local function ML(p, t, lo)
        local l = Instance.new("TextLabel", p)
        l.Size = UDim2.new(1,0,0,14); l.BackgroundTransparency = 1
        l.Text = t; l.Font = Enum.Font.GothamBold; l.TextSize = 10
        l.TextColor3 = PH_GREY; l.TextXAlignment = Enum.TextXAlignment.Left
        l.LayoutOrder = lo or 0; return l
    end
    local function CR(p, h, lo)
        local f = Instance.new("Frame", p)
        f.Size = UDim2.new(1,0,0,h); f.BackgroundColor3 = PH_CARD
        f.BorderSizePixel = 0; f.LayoutOrder = lo
        Instance.new("UICorner", f).CornerRadius = UDim.new(0,9); return f
    end

    local g1 = GF(1); ML(g1, "SEARCH MODE", 0)
    local ModeCard = CR(g1, 36, 1)
    local MG = Instance.new("UIGridLayout", ModeCard)
    MG.CellSize = UDim2.new(0.333,-3,1,-8); MG.CellPadding = UDim2.fromOffset(3,0)
    MG.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MG.VerticalAlignment = Enum.VerticalAlignment.Center
    local modes = {"Public","Friends","VIP"}; local modeBtns = {}
    for _, m in ipairs(modes) do
        local mb = Instance.new("TextButton", ModeCard)
        mb.Text = m; mb.Font = Enum.Font.GothamBold; mb.TextSize = 12; mb.BorderSizePixel = 0
        mb.BackgroundColor3 = m=="Public" and PH_ORANGE or PH_DARK
        mb.TextColor3 = m=="Public" and PH_BLACK or PH_GREY
        Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 6)
        modeBtns[m] = mb
        mb.MouseButton1Click:Connect(function()
            currentMode = m
            for _, k in ipairs(modes) do modeBtns[k].BackgroundColor3=PH_DARK; modeBtns[k].TextColor3=PH_GREY end
            mb.BackgroundColor3=PH_ORANGE; mb.TextColor3=PH_BLACK
        end)
    end

    local g2 = GF(2); ML(g2, "MAX PLAYERS", 0)
    local CRow = Instance.new("Frame", g2)
    CRow.Size = UDim2.new(1,0,0,38); CRow.BackgroundTransparency=1; CRow.LayoutOrder=1
    local crl = Instance.new("UIListLayout", CRow)
    crl.FillDirection = Enum.FillDirection.Horizontal; crl.Padding = UDim.new(0,5); crl.VerticalAlignment = Enum.VerticalAlignment.Center
    local CountBox = Instance.new("TextBox", CRow)
    CountBox.Size = UDim2.new(0,65,0,36); CountBox.BackgroundColor3 = PH_CARD
    CountBox.Text = "10"; CountBox.Font = Enum.Font.GothamBold; CountBox.TextSize = 18
    CountBox.TextColor3 = PH_ORANGE; CountBox.BorderSizePixel = 0; CountBox.ClearTextOnFocus = false
    Instance.new("UICorner", CountBox).CornerRadius = UDim.new(0, 8)
    for _, v in ipairs({1,5,10,20,50}) do
        local qb = Instance.new("TextButton", CRow)
        qb.Size = UDim2.new(0,40,0,36); qb.BackgroundColor3 = PH_DARK
        qb.Text = tostring(v); qb.Font = Enum.Font.GothamBold; qb.TextSize = 13
        qb.TextColor3 = PH_ORANGE; qb.BorderSizePixel = 0
        Instance.new("UICorner", qb).CornerRadius = UDim.new(0, 7)
        qb.MouseButton1Click:Connect(function() CountBox.Text = tostring(v) end)
        qb.MouseEnter:Connect(function() qb.BackgroundColor3 = Color3.fromRGB(38,38,38) end)
        qb.MouseLeave:Connect(function() qb.BackgroundColor3 = PH_DARK end)
    end

    local g3 = GF(3); ML(g3, "MAX PING  (ms)", 0)
    local PingCRow = Instance.new("Frame", g3)
    PingCRow.Size = UDim2.new(1,0,0,38); PingCRow.BackgroundTransparency=1; PingCRow.LayoutOrder=1
    local pcrl = Instance.new("UIListLayout", PingCRow)
    pcrl.FillDirection = Enum.FillDirection.Horizontal; pcrl.Padding = UDim.new(0,5); pcrl.VerticalAlignment = Enum.VerticalAlignment.Center
    local PingBox = Instance.new("TextBox", PingCRow)
    PingBox.Size = UDim2.new(0,65,0,36); PingBox.BackgroundColor3 = PH_CARD
    PingBox.Text = "any"; PingBox.Font = Enum.Font.GothamBold; PingBox.TextSize = 16
    PingBox.TextColor3 = Color3.fromRGB(100,220,100); PingBox.BorderSizePixel = 0; PingBox.ClearTextOnFocus = false
    Instance.new("UICorner", PingBox).CornerRadius = UDim.new(0, 8)
    for _, pv in ipairs({50,80,100,150,200}) do
        local pb = Instance.new("TextButton", PingCRow)
        pb.Size = UDim2.new(0,40,0,36); pb.BackgroundColor3 = PH_DARK
        pb.Text = tostring(pv); pb.Font = Enum.Font.GothamBold; pb.TextSize = 13
        pb.TextColor3 = Color3.fromRGB(100,220,100); pb.BorderSizePixel = 0
        Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 7)
        pb.MouseButton1Click:Connect(function() PingBox.Text = tostring(pv); maxPingFilter = pv end)
        pb.MouseEnter:Connect(function() pb.BackgroundColor3 = Color3.fromRGB(38,38,38) end)
        pb.MouseLeave:Connect(function() pb.BackgroundColor3 = PH_DARK end)
    end
    PingBox.FocusLost:Connect(function()
        local v = tonumber(PingBox.Text)
        if v and v > 0 then maxPingFilter = v else maxPingFilter = 9999; PingBox.Text = "any" end
    end)

    local g4 = GF(4); ML(g4, "SORT ORDER", 0)
    local SortRow = Instance.new("Frame", g4)
    SortRow.Size = UDim2.new(1,0,0,34); SortRow.BackgroundTransparency=1; SortRow.LayoutOrder=1
    local srl = Instance.new("UIListLayout", SortRow)
    srl.FillDirection = Enum.FillDirection.Horizontal; srl.Padding = UDim.new(0,5); srl.VerticalAlignment = Enum.VerticalAlignment.Center
    local sortBtns = {}
    for _, pair in ipairs({{"Asc","↑ Fewest"},{"Desc","↑ Most"}}) do
        local k, lbl = pair[1], pair[2]
        local sb = Instance.new("TextButton", SortRow)
        sb.Size = UDim2.new(0,82,0,32); sb.BackgroundColor3 = k=="Asc" and PH_ORANGE or PH_DARK
        sb.Text = lbl; sb.Font = Enum.Font.GothamBold; sb.TextSize = 12
        sb.TextColor3 = k=="Asc" and PH_BLACK or PH_GREY; sb.BorderSizePixel = 0
        Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 7)
        sortBtns[k] = sb
        sb.MouseButton1Click:Connect(function()
            selectedSort = k
            for _, key in ipairs({"Asc","Desc"}) do sortBtns[key].BackgroundColor3=PH_DARK; sortBtns[key].TextColor3=PH_GREY end
            sb.BackgroundColor3=PH_ORANGE; sb.TextColor3=PH_BLACK
        end)
    end

    local g5 = GF(5); ML(g5, "STATUS", 0)
    local StatusCard = CR(g5, 34, 1)
    local StatusDot = Instance.new("Frame", StatusCard)
    StatusDot.Size = UDim2.new(0,8,0,8); StatusDot.Position = UDim2.new(0,10,0.5,-4)
    StatusDot.BackgroundColor3 = PH_GREY; StatusDot.BorderSizePixel = 0
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    local StatusLabel = Instance.new("TextLabel", StatusCard)
    StatusLabel.Size = UDim2.new(1,-28,1,0); StatusLabel.Position = UDim2.new(0,26,0,0)
    StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Ready."
    StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = PH_GREY; StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function SetStatus(txt, col) StatusLabel.Text = txt; StatusDot.BackgroundColor3 = col or PH_ORANGE end
    local function UpdateStatus() SetStatus(("Found %d  |  Checked %d"):format(foundCount, checkedCount), Color3.fromRGB(100,220,100)) end

    local g6 = GF(6); ML(g6, "RESULTS", 0)
    local ListScroll = Instance.new("ScrollingFrame", g6)
    ListScroll.Size = UDim2.new(1,0,0,180); ListScroll.LayoutOrder = 1
    ListScroll.BackgroundColor3 = PH_DARK; ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3; ListScroll.ScrollBarImageColor3 = PH_ORANGE
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; ListScroll.CanvasSize = UDim2.new(0,0,0,0)
    Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 9)
    local LL = Instance.new("UIListLayout", ListScroll)
    LL.Padding = UDim.new(0,4); LL.SortOrder = Enum.SortOrder.LayoutOrder
    local lp = Instance.new("UIPadding", ListScroll)
    lp.PaddingLeft = UDim.new(0,6); lp.PaddingRight = UDim.new(0,6)
    lp.PaddingTop = UDim.new(0,6); lp.PaddingBottom = UDim.new(0,6)
    local EmptyTxt = Instance.new("TextLabel", ListScroll)
    EmptyTxt.Size = UDim2.new(1,0,0,36); EmptyTxt.BackgroundTransparency = 1
    EmptyTxt.Text = "No servers yet."; EmptyTxt.Font = Enum.Font.Gotham
    EmptyTxt.TextSize = 12; EmptyTxt.TextColor3 = Color3.fromRGB(50,50,50)

    local function AddEntry(jobId, playing, maxP, ping, fps, tokens)
        EmptyTxt.Visible = false; entryOrder += 1
        table.insert(foundServers, {jobId=jobId, playing=playing, maxP=maxP, ping=ping or 9999, fps=fps, tokens=tokens, foundTick=tick()})
        local entry = Instance.new("Frame", ListScroll)
        entry.Size = UDim2.new(1,0,0,44); entry.BackgroundColor3 = PH_CARD
        entry.BorderSizePixel = 0; entry.LayoutOrder = entryOrder
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 7)
        local acc = Instance.new("Frame", entry)
        acc.Size = UDim2.new(0,3,0.6,0); acc.Position = UDim2.new(0,0,0.2,0)
        acc.BackgroundColor3 = PH_ORANGE; acc.BorderSizePixel = 0
        Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)
        local plr = Instance.new("TextLabel", entry)
        plr.Size = UDim2.new(0,58,1,0); plr.Position = UDim2.new(0,10,0,0)
        plr.BackgroundTransparency = 1; plr.Text = tostring(playing).."/"..tostring(maxP)
        plr.Font = Enum.Font.GothamBold; plr.TextSize = 14
        plr.TextColor3 = PH_ORANGE; plr.TextXAlignment = Enum.TextXAlignment.Left
        local pingC = PH_GREY
        if ping then pingC = ping<80 and Color3.fromRGB(100,220,100) or ping<150 and PH_ORANGE or Color3.fromRGB(220,80,80) end
        local pingL = Instance.new("TextLabel", entry)
        pingL.Size = UDim2.new(0,52,1,0); pingL.Position = UDim2.new(0,70,0,0)
        pingL.BackgroundTransparency = 1; pingL.Text = ping and (tostring(ping).."ms") or "?ms"
        pingL.Font = Enum.Font.Gotham; pingL.TextSize = 12
        pingL.TextColor3 = pingC; pingL.TextXAlignment = Enum.TextXAlignment.Left
        local idL = Instance.new("TextLabel", entry)
        idL.Size = UDim2.new(1,-210,0,13); idL.Position = UDim2.new(0,70,1,-17)
        idL.BackgroundTransparency = 1; idL.Text = string.sub(jobId,1,18).."..."
        idL.Font = Enum.Font.Gotham; idL.TextSize = 9
        idL.TextColor3 = Color3.fromRGB(50,50,50); idL.TextXAlignment = Enum.TextXAlignment.Left
        -- INFO button
        local ib = Instance.new("TextButton", entry)
        ib.Size = UDim2.new(0,44,0,26); ib.Position = UDim2.new(1,-122,0.5,-13)
        ib.BackgroundColor3 = PH_DARK; ib.Text = "INFO"
        ib.Font = Enum.Font.GothamBold; ib.TextSize = 11; ib.TextColor3 = PH_GREY; ib.BorderSizePixel = 0
        Instance.new("UICorner", ib).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", ib).Color = PH_GREY
        ib.MouseEnter:Connect(function() ib.BackgroundColor3=Color3.fromRGB(38,38,38); ib.TextColor3=PH_WHITE end)
        ib.MouseLeave:Connect(function() ib.BackgroundColor3=PH_DARK; ib.TextColor3=PH_GREY end)
        ib.MouseButton1Click:Connect(function()
            local ft = tick()
            for _, sv in ipairs(foundServers) do if sv.jobId==jobId then ft=sv.foundTick or ft break end end
            ShowServerInfo(jobId, playing, maxP, ping, fps, ft)
        end)
        local jb = Instance.new("TextButton", entry)
        jb.Size = UDim2.new(0,56,0,26); jb.Position = UDim2.new(1,-64,0.5,-13)
        jb.BackgroundColor3 = PH_ORANGE; jb.Text = "JOIN"
        jb.Font = Enum.Font.GothamBold; jb.TextSize = 12; jb.TextColor3 = PH_BLACK; jb.BorderSizePixel = 0
        Instance.new("UICorner", jb).CornerRadius = UDim.new(0, 6)
        jb.MouseButton1Click:Connect(function()
            jb.Text = "..."; jb.BackgroundColor3 = Color3.fromRGB(180,110,0)
            SetStatus("Joining...", Color3.fromRGB(255,200,0))
            TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
        end)
    end

    local g7 = GF(7)
    local BtnRow = Instance.new("Frame", g7)
    BtnRow.Size = UDim2.new(1,0,0,40); BtnRow.BackgroundTransparency=1; BtnRow.LayoutOrder=1
    local brl = Instance.new("UIListLayout", BtnRow)
    brl.FillDirection = Enum.FillDirection.Horizontal; brl.Padding = UDim.new(0,6)
    local SearchBtn = Instance.new("TextButton", BtnRow)
    SearchBtn.Size = UDim2.new(0.65,0,1,0); SearchBtn.BackgroundColor3 = PH_ORANGE
    SearchBtn.Text = "SEARCH SERVERS"; SearchBtn.Font = Enum.Font.GothamBold
    SearchBtn.TextSize = 13; SearchBtn.TextColor3 = PH_BLACK; SearchBtn.BorderSizePixel = 0
    Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 9)
    local ClearBtn = Instance.new("TextButton", BtnRow)
    ClearBtn.Size = UDim2.new(0.33,0,1,0); ClearBtn.BackgroundColor3 = PH_DARK
    ClearBtn.Text = "CLEAR"; ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextSize = 13; ClearBtn.TextColor3 = PH_GREY; ClearBtn.BorderSizePixel = 0
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 9)
    local BestRow = Instance.new("Frame", g7)
    BestRow.Size = UDim2.new(1,0,0,36); BestRow.BackgroundTransparency=1; BestRow.LayoutOrder=2
    local BestBtn = Instance.new("TextButton", BestRow)
    BestBtn.Size = UDim2.new(1,0,1,0); BestBtn.BackgroundColor3 = Color3.fromRGB(20,60,20)
    BestBtn.Text = "⚡  JOIN BEST SERVER  (lowest ping)"; BestBtn.Font = Enum.Font.GothamBold
    BestBtn.TextSize = 13; BestBtn.TextColor3 = Color3.fromRGB(100,220,100); BestBtn.BorderSizePixel = 0
    Instance.new("UICorner", BestBtn).CornerRadius = UDim.new(0, 9)
    BestBtn.MouseEnter:Connect(function() BestBtn.BackgroundColor3 = Color3.fromRGB(30,90,30) end)
    BestBtn.MouseLeave:Connect(function() BestBtn.BackgroundColor3 = Color3.fromRGB(20,60,20) end)
    BestBtn.MouseButton1Click:Connect(function() JoinBestServer(SetStatus) end)

    local function ClearList()
        for _, cc in ipairs(ListScroll:GetChildren()) do if cc:IsA("Frame") then cc:Destroy() end end
        foundCount=0; checkedCount=0; entryOrder=0; foundServers={}
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
                    foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping, s.fps, s.playerTokens); UpdateStatus()
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
                foundCount += 1; AddEntry(s.id, s.playing, s.maxPlayers or 0, s.ping, s.fps, s.playerTokens); UpdateStatus()
            end
        end
    end
    SearchBtn.MouseButton1Click:Connect(function()
        if isSearching then isSearching=false; SearchBtn.Text="SEARCH SERVERS"; SearchBtn.BackgroundColor3=PH_ORANGE; return end
        local maxP = tonumber(CountBox.Text)
        if not maxP or maxP < 1 then SetStatus("Invalid number!", Color3.fromRGB(255,60,60)) return end
        task.spawn(function()
            isSearching=true; SearchBtn.Text="■ STOP"; SearchBtn.BackgroundColor3=Color3.fromRGB(200,60,60)
            SetStatus("Searching...", PH_ORANGE)
            if currentMode=="Public" then FetchPublic(maxP, selectedSort) else FetchOther(currentMode, maxP) end
            if isSearching then
                SetStatus(foundCount==0 and "Nothing found." or ("Done! "..foundCount.." servers found."),
                    foundCount==0 and Color3.fromRGB(255,80,80) or Color3.fromRGB(100,220,100))
            else SetStatus("Stopped. Found "..foundCount..".", PH_ORANGE) end
            isSearching=false; SearchBtn.Text="SEARCH SERVERS"; SearchBtn.BackgroundColor3=PH_ORANGE
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