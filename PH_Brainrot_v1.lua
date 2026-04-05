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
            else return false, decoded.message; end
        elseif response.StatusCode == 429 then return false, "Rate limited. Wait 20 seconds."; end
        return false, "Failed to cache link.";
    else return true, cachedLink; end
end

cacheLink();

local generateNonce = function()
    math.randomseed(fOsTime() + math.floor(tick() * 1000) % 100000)
    local str = ""
    for _ = 1, 16 do str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97) end
    return str
end

for _ = 1, 5 do
    local oNonce = generateNonce(); task.wait(0.2)
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
        Method = "POST", Body = lEncode(body),
        Headers = {["Content-Type"] = "application/json"}
    });
    if not reqOk then return false end
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    return decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret)
                else return true end
            else return false end
        else
            if fStringSub(decoded.message,1,27) == "unique constraint violation" then return false
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
                    return decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret)
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
--  PornoHub  |  Steal a Brainrot  |  v1.0.0
-------------------------------------------------------------------------------

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Lighting       = game:GetService("Lighting")

local LP   = Players.LocalPlayer
local Cam  = workspace.CurrentCamera
local Char = LP.Character or LP.CharacterAdded:Wait()
LP.CharacterAdded:Connect(function(c) Char = c end)

local VP       = workspace.CurrentCamera.ViewportSize
local isMobile = VP.X < 700 or UserInputService.TouchEnabled

-- ── palette ──────────────────────────────────────────────────────
local PH_ORANGE = Color3.fromRGB(255,153,0)
local PH_BLACK  = Color3.fromRGB(14,14,14)
local PH_DARK   = Color3.fromRGB(22,22,22)
local PH_CARD   = Color3.fromRGB(28,28,28)
local PH_GREY   = Color3.fromRGB(90,90,90)
local PH_WHITE  = Color3.fromRGB(225,225,225)
local PH_GREEN  = Color3.fromRGB(80,220,80)
local PH_RED    = Color3.fromRGB(220,60,60)

local W = isMobile and math.clamp(math.floor(VP.X*0.92),310,440) or 440
local H = isMobile and 400 or 560

-- ── state ────────────────────────────────────────────────────────
local guiOpen      = true
local keyUnlocked  = false
local isCheckingKey = false

local KEY_FILE = "ph_brainrot_key.txt"
local function saveKey(k) pcall(writefile, KEY_FILE, k) end
local function loadKey()
    local ok, data = pcall(readfile, KEY_FILE)
    return (ok and type(data)=="string" and data~="") and data or nil
end

-- feature values
local F = {
    speedOn=false,   speedVal=28,
    jumpOn=false,    jumpVal=60,
    spinOn=false,    spinVal=8,
    antiLagOn=false,
    fpsOn=false,
    hitboxOn=false,
    espOn=false,
    xrayOn=false,
    autoClickOn=false, autoClickDelay=0.1,
    netFakeOn=false,
    antiDetectOn=false,
}

-- ── connections pool (cleanup on toggle off) ─────────────────────
local Conns = {}
local function addConn(key, c)
    if Conns[key] then pcall(function() Conns[key]:Disconnect() end) end
    Conns[key] = c
end
local function stopConn(key)
    if Conns[key] then pcall(function() Conns[key]:Disconnect() end) Conns[key] = nil end
end

-- ── defaults ─────────────────────────────────────────────────────
local DEFAULT_SPEED  = 16
local DEFAULT_JUMP   = 50
local origHitboxes   = {}   -- store {part, origSize}
local espHighlights  = {}
local xrayActive     = false
local xrayFog

-- ── helpers ──────────────────────────────────────────────────────
local function getHum()
    if Char then return Char:FindFirstChildOfClass("Humanoid") end
end
local function getHRP()
    if Char then return Char:FindFirstChild("HumanoidRootPart") end
end
local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=title,Text=text,Duration=4})
    end)
end

-- ═══════════════════════════════════════════════════════
-- FEATURE LOGIC
-- ═══════════════════════════════════════════════════════

-- ── Speed Boost ──────────────────────────────────────────────────
local function applySpeed()
    local h = getHum()
    if h then h.WalkSpeed = F.speedOn and F.speedVal or DEFAULT_SPEED end
end
LP.CharacterAdded:Connect(function(c)
    Char = c
    task.wait(0.5)
    applySpeed()
    if F.jumpOn then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = F.jumpVal end
    end
end)

-- ── Jump Boost ───────────────────────────────────────────────────
local function applyJump()
    local h = getHum()
    if h then h.JumpPower = F.jumpOn and F.jumpVal or DEFAULT_JUMP end
end

-- ── Spin ─────────────────────────────────────────────────────────
local spinAngle = 0
local function startSpin()
    addConn("spin", RunService.Heartbeat:Connect(function(dt)
        local hrp = getHRP()
        if hrp then
            spinAngle = (spinAngle + F.spinVal * dt * 60) % 360
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(F.spinVal * dt * 60), 0)
        end
    end))
end
local function stopSpin()
    stopConn("spin")
    spinAngle = 0
end

-- ── Anti-Lag (reduce physics quality & chunk requests) ───────────
local function applyAntiLag(on)
    pcall(function()
        if on then
            workspace.StreamingEnabled = workspace.StreamingEnabled -- leave as is
            Cam.FieldOfView = Cam.FieldOfView -- no change
            -- Reduce LOD via graphics
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end)
end

-- ── FPS Boost (remove decorative parts) ──────────────────────────
local removedDecor = {}
local function applyFpsBoost(on)
    if on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
                table.insert(removedDecor, v)
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e8
    else
        for _, v in ipairs(removedDecor) do
            pcall(function() v.Enabled = true end)
        end
        removedDecor = {}
        Lighting.GlobalShadows = true
    end
end

-- ── Big Hitbox 30% ───────────────────────────────────────────────
local function applyHitbox(on)
    if not Char then return end
    if on then
        for _, p in ipairs(Char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                origHitboxes[p] = p.Size
                p.Size = p.Size * 1.3
            end
        end
    else
        for p, sz in pairs(origHitboxes) do
            pcall(function() p.Size = sz end)
        end
        origHitboxes = {}
    end
end

-- ── ESP Players ───────────────────────────────────────────────────
local function clearESP()
    for _, h in pairs(espHighlights) do pcall(function() h:Destroy() end) end
    espHighlights = {}
end
local function rebuildESP()
    clearESP()
    if not F.espOn then return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local hl = Instance.new("Highlight")
            hl.Adornee = pl.Character
            hl.FillColor = PH_ORANGE
            hl.OutlineColor = PH_WHITE
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = pl.Character
            espHighlights[pl.UserId] = hl
        end
    end
end
local function startESP()
    rebuildESP()
    addConn("esp_join", Players.PlayerAdded:Connect(function(pl)
        pl.CharacterAdded:Connect(function(c)
            if not F.espOn then return end
            task.wait(0.5)
            local hl = Instance.new("Highlight")
            hl.Adornee = c
            hl.FillColor = PH_ORANGE
            hl.OutlineColor = PH_WHITE
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = c
            espHighlights[pl.UserId] = hl
        end)
    end))
end

-- ── Xray ─────────────────────────────────────────────────────────
local function applyXray(on)
    if on then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                for _, p in ipairs(pl.Character:GetDescendants()) do
                    if p:IsA("BasePart") or p:IsA("MeshPart") then
                        p.CastShadow = false
                        p.Material = Enum.Material.Neon
                    end
                end
            end
        end
        Lighting.FogEnd = 10
        Lighting.FogStart = 0
        Lighting.FogColor = PH_BLACK
        xrayActive = true
    else
        xrayActive = false
        Lighting.FogEnd = 9e8
        Lighting.FogStart = 0
    end
end

-- ── Auto Click / Auto Hit ─────────────────────────────────────────
local autoClickConn
local function startAutoClick()
    local lastHit = 0
    addConn("autoclk", RunService.Heartbeat:Connect(function()
        if not F.autoClickOn then return end
        local now = tick()
        if now - lastHit < F.autoClickDelay then return end
        lastHit = now
        -- Find nearest player and simulate tool hit
        local hrp = getHRP()
        if not hrp then return end
        local nearest, nearDist = nil, 20  -- 20 stud range
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then
                local tHRP = pl.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local d = (tHRP.Position - hrp.Position).Magnitude
                    if d < nearDist then nearDist = d; nearest = pl end
                end
            end
        end
        if nearest and nearest.Character then
            -- fire equipped tool if any
            local tool = Char:FindFirstChildOfClass("Tool")
            if tool then
                local remote = tool:FindFirstChildOfClass("RemoteEvent")
                    or tool:FindFirstChild("HitEvent")
                    or tool:FindFirstChild("DamageRemote")
                if remote then
                    local tHRP = nearest.Character:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        -- Anti-detect: small random offset on timing
                        if F.antiDetectOn then task.wait(math.random(1,8)*0.01) end
                        pcall(function() remote:FireServer(tHRP.Position) end)
                    end
                end
                -- Also simulate mouse click for tools using mouse
                local mse = LP:GetMouse()
                pcall(function()
                    tool:Activate()
                end)
            end
        end
    end))
end

-- ── Network Fake / Anti-Detect ────────────────────────────────────
-- Hooks RemoteEvent FireServer to add noise and delay
local origFireServer = Instance.new("RemoteEvent").FireServer  -- reference type
local netFakeConn
local function applyNetFake(on)
    -- This injects random harmless pings to mask real action timing
    if on then
        addConn("netfake", RunService.Heartbeat:Connect(function()
            -- Every ~3 seconds send a ghost event if a decoy remote exists
            if math.random(1,180) == 1 then
                local remotes = {}
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("RemoteEvent") then table.insert(remotes, v) end
                end
                if #remotes > 0 then
                    local r = remotes[math.random(1,#remotes)]
                    pcall(function() r:FireServer() end)
                end
            end
        end))
    else
        stopConn("netfake")
    end
end

-- ═══════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PH_Brainrot"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local Main

-- ───────────────────────────────────────────────────────
-- KEY GATE  (PlatoBoost — identical to SF)
-- ───────────────────────────────────────────────────────
local KeyGate

do
    local saved = loadKey()
    if saved then
        task.spawn(function()
            local trimmed = saved:match("^%s*(.-)%s*$")
            if trimmed ~= "" and verifyKey(trimmed) then
                keyUnlocked = true
                task.wait(0.05)
                if KeyGate and KeyGate.Parent then KeyGate:Destroy() end
            else
                pcall(function() writefile(KEY_FILE,"") end)
            end
        end)
    end
end

KeyGate = Instance.new("Frame")
KeyGate.Size = UDim2.new(1,0,1,0)
KeyGate.BackgroundColor3 = Color3.fromRGB(8,8,8)
KeyGate.BackgroundTransparency = 0.1
KeyGate.BorderSizePixel = 0
KeyGate.ZIndex = 100
KeyGate.Parent = ScreenGui

local KeyCard = Instance.new("Frame", KeyGate)
KeyCard.Size = UDim2.fromOffset(340,220)
KeyCard.Position = UDim2.new(0.5,-170,0.5,-110)
KeyCard.BackgroundColor3 = PH_BLACK
KeyCard.BorderSizePixel = 0; KeyCard.ZIndex = 101
Instance.new("UICorner", KeyCard).CornerRadius = UDim.new(0,14)
local kcs = Instance.new("UIStroke", KeyCard)
kcs.Color = PH_ORANGE; kcs.Thickness = 1.5; kcs.Transparency = 0.4

local KLW = Instance.new("TextLabel", KeyCard)
KLW.Size=UDim2.new(0,56,0,26); KLW.Position=UDim2.new(0.5,-56,0,18)
KLW.BackgroundTransparency=1; KLW.Text="porno"
KLW.Font=Enum.Font.GothamBold; KLW.TextSize=19
KLW.TextColor3=PH_WHITE; KLW.TextXAlignment=Enum.TextXAlignment.Right; KLW.ZIndex=102

local KLB = Instance.new("TextLabel", KeyCard)
KLB.Size=UDim2.new(0,40,0,20); KLB.Position=UDim2.new(0.5,2,0,21)
KLB.BackgroundColor3=PH_ORANGE; KLB.Text="hub"
KLB.Font=Enum.Font.GothamBold; KLB.TextSize=13
KLB.TextColor3=PH_BLACK; KLB.ZIndex=102
Instance.new("UICorner",KLB).CornerRadius=UDim.new(0,5)

local KSub = Instance.new("TextLabel", KeyCard)
KSub.Size=UDim2.new(1,-20,0,14); KSub.Position=UDim2.new(0,10,0,52)
KSub.BackgroundTransparency=1; KSub.Text="Get key -> paste below"
KSub.Font=Enum.Font.Gotham; KSub.TextSize=11
KSub.TextColor3=PH_GREY; KSub.ZIndex=102

local KeyBox = Instance.new("TextBox", KeyCard)
KeyBox.Size=UDim2.new(1,-24,0,36); KeyBox.Position=UDim2.new(0,12,0,74)
KeyBox.BackgroundColor3=PH_DARK; KeyBox.Text=""
KeyBox.PlaceholderText="KEY_xxxxxxxxxxxx"
KeyBox.PlaceholderColor3=Color3.fromRGB(55,55,55)
KeyBox.Font=Enum.Font.GothamBold; KeyBox.TextSize=13
KeyBox.TextColor3=PH_ORANGE; KeyBox.BorderSizePixel=0
KeyBox.ClearTextOnFocus=false; KeyBox.ZIndex=102
Instance.new("UICorner",KeyBox).CornerRadius=UDim.new(0,8)
local KBS = Instance.new("UIStroke",KeyBox)
KBS.Color=PH_GREY; KBS.Thickness=1

local KeyError = Instance.new("TextLabel", KeyCard)
KeyError.Size=UDim2.new(1,-20,0,14); KeyError.Position=UDim2.new(0,10,0,114)
KeyError.BackgroundTransparency=1; KeyError.Text=""
KeyError.Font=Enum.Font.Gotham; KeyError.TextSize=11
KeyError.TextColor3=Color3.fromRGB(255,80,80); KeyError.ZIndex=102

local KBF = Instance.new("Frame", KeyCard)
KBF.Size=UDim2.new(1,-24,0,36); KBF.Position=UDim2.new(0,12,0,132)
KBF.BackgroundTransparency=1; KBF.ZIndex=102
local KBL = Instance.new("UIListLayout",KBF)
KBL.FillDirection=Enum.FillDirection.Horizontal; KBL.Padding=UDim.new(0,8)

local GetKeyBtn = Instance.new("TextButton", KBF)
GetKeyBtn.Size=UDim2.new(0.45,0,1,0); GetKeyBtn.BackgroundColor3=PH_DARK
GetKeyBtn.Text="🔑 Get Key"; GetKeyBtn.Font=Enum.Font.GothamBold
GetKeyBtn.TextSize=12; GetKeyBtn.TextColor3=PH_ORANGE
GetKeyBtn.BorderSizePixel=0; GetKeyBtn.ZIndex=102
Instance.new("UICorner",GetKeyBtn).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",GetKeyBtn).Color=PH_ORANGE

local KeySubmit = Instance.new("TextButton", KBF)
KeySubmit.Size=UDim2.new(0.53,0,1,0); KeySubmit.BackgroundColor3=PH_ORANGE
KeySubmit.Text="UNLOCK"; KeySubmit.Font=Enum.Font.GothamBold
KeySubmit.TextSize=13; KeySubmit.TextColor3=PH_BLACK
KeySubmit.BorderSizePixel=0; KeySubmit.ZIndex=102
Instance.new("UICorner",KeySubmit).CornerRadius=UDim.new(0,8)

GetKeyBtn.MouseButton1Click:Connect(function()
    GetKeyBtn.Text="..."
    task.spawn(function()
        copyLink()
        GetKeyBtn.Text="✓ Copied!"
        local ok, link = cacheLink()
        if ok then notify("PornoHub Key","Link copied! Paste in browser.") end
        task.wait(2); GetKeyBtn.Text="🔑 Get Key"
    end)
end)

local function TryUnlock()
    if isCheckingKey then return end
    local entered = KeyBox.Text:match("^%s*(.-)%s*$")
    if entered=="" then KeyError.Text="❌  Paste your key first"; return end
    isCheckingKey=true; KeySubmit.Text="..."
    KeySubmit.BackgroundColor3=Color3.fromRGB(180,110,0); KeyError.Text=""
    task.spawn(function()
        local valid = verifyKey(entered)
        if valid then
            keyUnlocked=true; saveKey(entered); KeyGate:Destroy()
        else
            KeyError.Text="❌  Invalid or expired key"
            KBS.Color=Color3.fromRGB(200,60,60)
            task.delay(1.8, function()
                if KeyError and KeyError.Parent then
                    KeyError.Text=""; KBS.Color=PH_GREY
                end
            end)
        end
        isCheckingKey=false
        if KeySubmit and KeySubmit.Parent then
            KeySubmit.Text="UNLOCK"; KeySubmit.BackgroundColor3=PH_ORANGE
        end
    end)
end

KeySubmit.MouseButton1Click:Connect(TryUnlock)
KeyBox.FocusLost:Connect(function(enter) if enter then TryUnlock() end end)
KeySubmit.MouseEnter:Connect(function() KeySubmit.BackgroundColor3=Color3.fromRGB(220,130,0) end)
KeySubmit.MouseLeave:Connect(function() KeySubmit.BackgroundColor3=PH_ORANGE end)

-- ───────────────────────────────────────────────────────
-- TOGGLE BUTTON (draggable PH pill)
-- ───────────────────────────────────────────────────────

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size=UDim2.fromOffset(44,44)
ToggleBtn.Position=UDim2.new(0,10,0.5,-22)
ToggleBtn.BackgroundColor3=PH_ORANGE; ToggleBtn.Text="PH"
ToggleBtn.Font=Enum.Font.GothamBold; ToggleBtn.TextSize=13
ToggleBtn.TextColor3=PH_BLACK; ToggleBtn.BorderSizePixel=0
ToggleBtn.ZIndex=20; ToggleBtn.Parent=ScreenGui
Instance.new("UICorner",ToggleBtn).CornerRadius=UDim.new(0,10)

local tActive,tDrag,tStart,tOrigin=false,false
ToggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then
        tActive=true; tDrag=false
        tStart=inp.Position; tOrigin=ToggleBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if not tActive then return end
    if inp.UserInputType==Enum.UserInputType.MouseMovement
    or inp.UserInputType==Enum.UserInputType.Touch then
        local dx=inp.Position.X-tStart.X; local dy=inp.Position.Y-tStart.Y
        if math.abs(dx)>8 or math.abs(dy)>8 then tDrag=true end
        if tDrag then
            ToggleBtn.Position=UDim2.fromOffset(
                math.clamp(tOrigin.X.Offset+dx,0,VP.X-44),
                math.clamp(tOrigin.Y.Offset+dy,0,VP.Y-44))
        end
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if not tActive then return end
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then
        if not tDrag and keyUnlocked then
            guiOpen=not guiOpen; Main.Visible=guiOpen
        end
        tActive=false; tDrag=false
    end
end)

-- ───────────────────────────────────────────────────────
-- MAIN FRAME
-- ───────────────────────────────────────────────────────

Main = Instance.new("Frame")
Main.Name="Main"; Main.Size=UDim2.fromOffset(W,H)
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
Main.BackgroundColor3=PH_BLACK; Main.BorderSizePixel=0
Main.ClipsDescendants=true; Main.Parent=ScreenGui
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14)

local Shadow=Instance.new("ImageLabel")
Shadow.Size=UDim2.new(1,40,1,40); Shadow.Position=UDim2.new(0,-20,0,-20)
Shadow.BackgroundTransparency=1; Shadow.Image="rbxassetid://6014261993"
Shadow.ImageColor3=Color3.fromRGB(0,0,0); Shadow.ImageTransparency=0.4
Shadow.ScaleType=Enum.ScaleType.Slice; Shadow.SliceCenter=Rect.new(49,49,450,450)
Shadow.ZIndex=0; Shadow.Parent=Main

-- TopBar
local TopBar=Instance.new("Frame")
TopBar.Size=UDim2.new(1,0,0,46); TopBar.BackgroundColor3=PH_ORANGE
TopBar.BorderSizePixel=0; TopBar.ZIndex=5; TopBar.Parent=Main
Instance.new("UICorner",TopBar).CornerRadius=UDim.new(0,14)
local tf=Instance.new("Frame",TopBar)
tf.Size=UDim2.new(1,0,0,14); tf.Position=UDim2.new(0,0,1,-14)
tf.BackgroundColor3=PH_ORANGE; tf.BorderSizePixel=0; tf.ZIndex=5

local LogoW=Instance.new("TextLabel",TopBar)
LogoW.Size=UDim2.new(0,68,1,0); LogoW.Position=UDim2.new(0,10,0,0)
LogoW.BackgroundTransparency=1; LogoW.Text="porno"
LogoW.Font=Enum.Font.GothamBold; LogoW.TextSize=19
LogoW.TextColor3=Color3.fromRGB(255,255,255)
LogoW.TextXAlignment=Enum.TextXAlignment.Left; LogoW.ZIndex=6

local LogoBadge=Instance.new("TextLabel",TopBar)
LogoBadge.Size=UDim2.new(0,44,0,22); LogoBadge.Position=UDim2.new(0,72,0.5,-11)
LogoBadge.BackgroundColor3=Color3.fromRGB(255,255,255); LogoBadge.Text="hub"
LogoBadge.Font=Enum.Font.GothamBold; LogoBadge.TextSize=14
LogoBadge.TextColor3=PH_ORANGE; LogoBadge.ZIndex=6
Instance.new("UICorner",LogoBadge).CornerRadius=UDim.new(0,5)

local SubT=Instance.new("TextLabel",TopBar)
SubT.Size=UDim2.new(0,160,1,0); SubT.Position=UDim2.new(0,122,0,0)
SubT.BackgroundTransparency=1; SubT.Text="Steal a Brainrot  v1.0.0"
SubT.Font=Enum.Font.Gotham; SubT.TextSize=10
SubT.TextColor3=Color3.fromRGB(30,30,30)
SubT.TextXAlignment=Enum.TextXAlignment.Left; SubT.ZIndex=6

local CloseBtn=Instance.new("TextButton",TopBar)
CloseBtn.Size=UDim2.new(0,32,0,26); CloseBtn.Position=UDim2.new(1,-38,0.5,-13)
CloseBtn.BackgroundColor3=Color3.fromRGB(18,18,18); CloseBtn.Text="❌"
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=14
CloseBtn.TextColor3=PH_WHITE; CloseBtn.BorderSizePixel=0; CloseBtn.ZIndex=7
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,5)
CloseBtn.MouseButton1Click:Connect(function() guiOpen=false; Main.Visible=false end)

-- drag main
local dragging,dragStart,frameStart=false
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=inp.Position; frameStart=Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement
    or inp.UserInputType==Enum.UserInputType.Touch) then
        local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
        Main.Position=UDim2.fromOffset(
            math.clamp(frameStart.X.Offset+dx,0,VP.X-W),
            math.clamp(frameStart.Y.Offset+dy,0,VP.Y-46))
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

-- ── TAB BAR (below TopBar) ────────────────────────────────────────
local TAB_H = 36
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1,0,0,TAB_H)
TabBar.Position = UDim2.new(0,0,0,46)
TabBar.BackgroundColor3 = PH_DARK
TabBar.BorderSizePixel = 0; TabBar.ZIndex = 5
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Content area (below tab bar)
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,0,1,-(46+TAB_H))
Content.Position = UDim2.new(0,0,0,46+TAB_H)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

-- ── TAB PAGES ────────────────────────────────────────────────────
local tabPages  = {}   -- tabName -> Frame
local tabBtns   = {}   -- tabName -> TextButton
local activeTab = nil

local TAB_DEFS = {
    {name="MOVEMENT", icon="🏃"},
    {name="COMBAT",   icon="⚔️"},
    {name="VISUAL",   icon="👁️"},
    {name="MISC",     icon="⚙️"},
}

for i, td in ipairs(TAB_DEFS) do
    -- tab button
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1/#TAB_DEFS, 0, 1, 0)
    btn.BackgroundColor3 = PH_DARK
    btn.Text = td.icon.." "..td.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = isMobile and 9 or 10
    btn.TextColor3 = PH_GREY
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.ZIndex = 6
    tabBtns[td.name] = btn

    -- page frame
    local page = Instance.new("Frame", Content)
    page.Size = UDim2.new(1,0,1,0)
    page.Position = UDim2.new(0,0,0,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    tabPages[td.name] = page

    -- scrolling frame inside page
    local scroll = Instance.new("ScrollingFrame", page)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = PH_ORANGE
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    local sll = Instance.new("UIListLayout", scroll)
    sll.Padding = UDim.new(0,6)
    sll.SortOrder = Enum.SortOrder.LayoutOrder
    local slp = Instance.new("UIPadding", scroll)
    slp.PaddingLeft = UDim.new(0,10)
    slp.PaddingRight = UDim.new(0,10)
    slp.PaddingTop = UDim.new(0,8)
    slp.PaddingBottom = UDim.new(0,8)
    page.scroll = scroll
end

-- switch tab
local function switchTab(name)
    for n, pg in pairs(tabPages) do
        pg.Visible = (n == name)
    end
    for n, btn in pairs(tabBtns) do
        if n == name then
            btn.BackgroundColor3 = PH_ORANGE
            btn.TextColor3 = PH_BLACK
        else
            btn.BackgroundColor3 = PH_DARK
            btn.TextColor3 = PH_GREY
        end
    end
    activeTab = name
end

for _, td in ipairs(TAB_DEFS) do
    tabBtns[td.name].MouseButton1Click:Connect(function() switchTab(td.name) end)
end
switchTab("MOVEMENT")

-- ═══════════════════════════════════════════════════════
-- UI COMPONENT BUILDERS
-- ═══════════════════════════════════════════════════════

-- ── section label ─────────────────────────────────────
local function MkSection(parent, text, lo)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1,0,0,16)
    lbl.BackgroundTransparency = 1
    lbl.Text = "── "..text.." ──"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = PH_ORANGE
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = lo or 0
    return lbl
end

-- ── toggle row ────────────────────────────────────────
--    [●] Feature Name                       [ON/OFF]
local function MkToggle(parent, label, icon, lo, state, onToggle)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,44)
    row.BackgroundColor3 = PH_CARD
    row.BorderSizePixel = 0
    row.LayoutOrder = lo or 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    -- accent line
    local acc = Instance.new("Frame", row)
    acc.Size = UDim2.new(0,3,0.6,0); acc.Position = UDim2.new(0,0,0.2,0)
    acc.BackgroundColor3 = state and PH_GREEN or PH_GREY
    acc.BorderSizePixel = 0
    Instance.new("UICorner",acc).CornerRadius = UDim.new(0,2)

    local ico = Instance.new("TextLabel", row)
    ico.Size = UDim2.new(0,24,1,0); ico.Position = UDim2.new(0,10,0,0)
    ico.BackgroundTransparency = 1; ico.Text = icon or "●"
    ico.Font = Enum.Font.GothamBold; ico.TextSize = 16
    ico.TextColor3 = state and PH_GREEN or PH_GREY

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1,-110,1,0); lbl.Position = UDim2.new(0,38,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextColor3 = PH_WHITE; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tog = Instance.new("TextButton", row)
    tog.Size = UDim2.new(0,54,0,26); tog.Position = UDim2.new(1,-62,0.5,-13)
    tog.BackgroundColor3 = state and PH_GREEN or PH_DARK
    tog.Text = state and "ON" or "OFF"
    tog.Font = Enum.Font.GothamBold; tog.TextSize = 11
    tog.TextColor3 = state and PH_BLACK or PH_GREY
    tog.BorderSizePixel = 0
    Instance.new("UICorner",tog).CornerRadius = UDim.new(0,6)

    local function refresh(s)
        tog.BackgroundColor3 = s and PH_GREEN or PH_DARK
        tog.Text = s and "ON" or "OFF"
        tog.TextColor3 = s and PH_BLACK or PH_GREY
        acc.BackgroundColor3 = s and PH_GREEN or PH_GREY
        ico.TextColor3 = s and PH_GREEN or PH_GREY
    end

    tog.MouseButton1Click:Connect(function()
        local newState = not state
        state = newState
        refresh(state)
        onToggle(state)
    end)

    return row, function(s) state=s; refresh(s) end
end

-- ── slider row ────────────────────────────────────────
--    Label                              [   28   ]
--    [=========-----------]
local function MkSlider(parent, label, lo, minV, maxV, curV, fmt, onChange)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1,0,0,52)
    wrap.BackgroundColor3 = PH_CARD
    wrap.BorderSizePixel = 0
    wrap.LayoutOrder = lo or 0
    Instance.new("UICorner",wrap).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel", wrap)
    lbl.Size = UDim2.new(0.6,0,0,22); lbl.Position = UDim2.new(0,10,0,4)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
    lbl.TextColor3 = PH_GREY; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local fmt2 = fmt or "%d"
    local valLbl = Instance.new("TextLabel", wrap)
    valLbl.Size = UDim2.new(0.35,0,0,22); valLbl.Position = UDim2.new(0.65,0,0,4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = string.format(fmt2, curV)
    valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 13
    valLbl.TextColor3 = PH_ORANGE; valLbl.TextXAlignment = Enum.TextXAlignment.Right

    -- track bg
    local trackBg = Instance.new("Frame", wrap)
    trackBg.Size = UDim2.new(1,-20,0,8); trackBg.Position = UDim2.new(0,10,0,34)
    trackBg.BackgroundColor3 = PH_DARK; trackBg.BorderSizePixel=0
    Instance.new("UICorner",trackBg).CornerRadius = UDim.new(0,4)

    local fill = Instance.new("Frame", trackBg)
    fill.Size = UDim2.new((curV-minV)/(maxV-minV),0,1,0)
    fill.BackgroundColor3 = PH_ORANGE; fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius = UDim.new(0,4)

    local draggingSlider = false
    local function updateVal(absX)
        local trackAbs = trackBg.AbsolutePosition.X
        local trackW   = trackBg.AbsoluteSize.X
        local pct      = math.clamp((absX - trackAbs) / trackW, 0, 1)
        local v        = math.floor(minV + pct*(maxV-minV))
        fill.Size      = UDim2.new(pct,0,1,0)
        valLbl.Text    = string.format(fmt2, v)
        onChange(v)
    end

    trackBg.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            draggingSlider=true; updateVal(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not draggingSlider then return end
        if inp.UserInputType==Enum.UserInputType.MouseMovement
        or inp.UserInputType==Enum.UserInputType.Touch then
            updateVal(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            draggingSlider=false
        end
    end)

    return wrap
end

-- ═══════════════════════════════════════════════════════
-- TAB: MOVEMENT
-- ═══════════════════════════════════════════════════════
do
    local sc = tabPages["MOVEMENT"].scroll

    MkSection(sc, "MOVEMENT", 0)

    MkToggle(sc, "Speed Boost", "🏃", 1, F.speedOn, function(s)
        F.speedOn = s; applySpeed()
    end)
    MkSlider(sc, "Walk Speed", 2, 16, 120, F.speedVal, "%d", function(v)
        F.speedVal = v; if F.speedOn then applySpeed() end
    end)

    MkToggle(sc, "Jump Boost", "🦘", 3, F.jumpOn, function(s)
        F.jumpOn = s; applyJump()
    end)
    MkSlider(sc, "Jump Power", 4, 50, 400, F.jumpVal, "%d", function(v)
        F.jumpVal = v; if F.jumpOn then applyJump() end
    end)

    MkSection(sc, "SPIN", 8)

    MkToggle(sc, "Spin Player", "🌀", 9, F.spinOn, function(s)
        F.spinOn = s
        if s then startSpin() else stopSpin() end
    end)
    MkSlider(sc, "Spin Speed", 10, 1, 30, F.spinVal, "%d", function(v)
        F.spinVal = v
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: COMBAT
-- ═══════════════════════════════════════════════════════
do
    local sc = tabPages["COMBAT"].scroll

    MkSection(sc, "HITBOX", 0)

    MkToggle(sc, "Big Hitbox +30%", "📦", 1, F.hitboxOn, function(s)
        F.hitboxOn = s; applyHitbox(s)
    end)

    MkSection(sc, "AUTO ATTACK", 4)

    MkToggle(sc, "Auto Click / Hit", "👊", 5, F.autoClickOn, function(s)
        F.autoClickOn = s
        if s then startAutoClick() else stopConn("autoclk") end
    end)
    MkSlider(sc, "Hit Delay (sec)", 6, 1, 20, math.floor(F.autoClickDelay*100), "0.%02d", function(v)
        F.autoClickDelay = v/100
    end)

    MkSection(sc, "NETWORK", 10)

    MkToggle(sc, "Network Fake", "📡", 11, F.netFakeOn, function(s)
        F.netFakeOn = s; applyNetFake(s)
    end)

    MkToggle(sc, "Anti-Detect", "🔒", 12, F.antiDetectOn, function(s)
        F.antiDetectOn = s
        if s then notify("PornoHub","Anti-Detect ON — actions now randomized") end
    end)

    -- Info card
    local infoCard = Instance.new("Frame", sc)
    infoCard.Size = UDim2.new(1,0,0,60)
    infoCard.BackgroundColor3 = Color3.fromRGB(18,18,18)
    infoCard.BorderSizePixel = 0; infoCard.LayoutOrder = 20
    Instance.new("UICorner",infoCard).CornerRadius = UDim.new(0,8)
    local infoStroke = Instance.new("UIStroke",infoCard)
    infoStroke.Color = PH_ORANGE; infoStroke.Thickness = 1; infoStroke.Transparency = 0.6
    local infoTxt = Instance.new("TextLabel",infoCard)
    infoTxt.Size = UDim2.new(1,-16,1,0); infoTxt.Position = UDim2.new(0,8,0,0)
    infoTxt.BackgroundTransparency = 1
    infoTxt.Text = "🔒 Anti-Detect: randomizes action timing\n📡 Net Fake: sends noise packets to mask real hits"
    infoTxt.Font = Enum.Font.Gotham; infoTxt.TextSize = 10
    infoTxt.TextColor3 = PH_GREY; infoTxt.TextWrapped = true
    infoTxt.TextXAlignment = Enum.TextXAlignment.Left
    infoTxt.TextYAlignment = Enum.TextYAlignment.Center
end

-- ═══════════════════════════════════════════════════════
-- TAB: VISUAL
-- ═══════════════════════════════════════════════════════
do
    local sc = tabPages["VISUAL"].scroll

    MkSection(sc, "ESP", 0)

    MkToggle(sc, "ESP Players", "👁️", 1, F.espOn, function(s)
        F.espOn = s
        if s then startESP() else clearESP(); stopConn("esp_join") end
    end)

    MkToggle(sc, "Xray", "🔭", 2, F.xrayOn, function(s)
        F.xrayOn = s; applyXray(s)
    end)

    -- color selector for ESP
    local colorSec = Instance.new("Frame", sc)
    colorSec.Size = UDim2.new(1,0,0,44)
    colorSec.BackgroundColor3 = PH_CARD
    colorSec.BorderSizePixel = 0; colorSec.LayoutOrder = 3
    Instance.new("UICorner",colorSec).CornerRadius = UDim.new(0,8)
    local clbl = Instance.new("TextLabel",colorSec)
    clbl.Size = UDim2.new(0.5,0,1,0); clbl.Position = UDim2.new(0,10,0,0)
    clbl.BackgroundTransparency = 1; clbl.Text = "ESP Color"
    clbl.Font = Enum.Font.GothamBold; clbl.TextSize = 12
    clbl.TextColor3 = PH_WHITE; clbl.TextXAlignment = Enum.TextXAlignment.Left

    local espColors = {
        {n="Orange",  c=PH_ORANGE},
        {n="Green",   c=PH_GREEN},
        {n="Red",     c=PH_RED},
        {n="White",   c=PH_WHITE},
    }
    local clRow = Instance.new("Frame",colorSec)
    clRow.Size = UDim2.new(0.48,0,0,28); clRow.Position = UDim2.new(0.5,0,0.5,-14)
    clRow.BackgroundTransparency = 1
    local clRowL = Instance.new("UIListLayout",clRow)
    clRowL.FillDirection = Enum.FillDirection.Horizontal
    clRowL.Padding = UDim.new(0,4); clRowL.VerticalAlignment = Enum.VerticalAlignment.Center
    for _, ec in ipairs(espColors) do
        local cb = Instance.new("TextButton",clRow)
        cb.Size = UDim2.new(0,22,0,22)
        cb.BackgroundColor3 = ec.c; cb.Text = ""
        cb.BorderSizePixel = 0
        Instance.new("UICorner",cb).CornerRadius = UDim.new(1,0)
        cb.MouseButton1Click:Connect(function()
            for _, hl in pairs(espHighlights) do
                pcall(function() hl.FillColor = ec.c end)
            end
        end)
    end

    MkSection(sc, "PERFORMANCE", 6)

    MkToggle(sc, "FPS Boost", "📈", 7, F.fpsOn, function(s)
        F.fpsOn = s; applyFpsBoost(s)
        if s then notify("FPS Boost","Particles disabled, shadows off") end
    end)

    MkToggle(sc, "Anti-Lag", "⚡", 8, F.antiLagOn, function(s)
        F.antiLagOn = s; applyAntiLag(s)
        if s then notify("Anti-Lag","Quality set to minimum") end
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: MISC
-- ═══════════════════════════════════════════════════════
do
    local sc = tabPages["MISC"].scroll

    MkSection(sc, "PLAYER INFO", 0)

    -- Live stats card (updates every 2s)
    local statsCard = Instance.new("Frame", sc)
    statsCard.Size = UDim2.new(1,0,0,110)
    statsCard.BackgroundColor3 = PH_CARD
    statsCard.BorderSizePixel = 0; statsCard.LayoutOrder = 1
    Instance.new("UICorner",statsCard).CornerRadius = UDim.new(0,8)
    local sStroke = Instance.new("UIStroke",statsCard)
    sStroke.Color=PH_ORANGE; sStroke.Thickness=1; sStroke.Transparency=0.6

    local function StatLine(yOff, labelTxt)
        local row = Instance.new("Frame",statsCard)
        row.Size = UDim2.new(1,-16,0,18); row.Position = UDim2.new(0,8,0,yOff)
        row.BackgroundTransparency=1
        local lbl = Instance.new("TextLabel",row)
        lbl.Size = UDim2.new(0.45,0,1,0)
        lbl.BackgroundTransparency=1; lbl.Text=labelTxt
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
        lbl.TextColor3=PH_GREY; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local val = Instance.new("TextLabel",row)
        val.Size = UDim2.new(0.55,0,1,0); val.Position=UDim2.new(0.45,0,0,0)
        val.BackgroundTransparency=1; val.Text="..."
        val.Font=Enum.Font.GothamBold; val.TextSize=10
        val.TextColor3=PH_ORANGE; val.TextXAlignment=Enum.TextXAlignment.Right
        return val
    end

    local vSpeed  = StatLine(8,  "Walk Speed")
    local vJump   = StatLine(28, "Jump Power")
    local vHealth = StatLine(48, "Health")
    local vPos    = StatLine(68, "Position")
    local vPing   = StatLine(88, "Players Online")

    task.spawn(function()
        while task.wait(1.5) do
            pcall(function()
                local h = getHum()
                local hrp = getHRP()
                if h then
                    vSpeed.Text  = string.format("%.0f", h.WalkSpeed)
                    vJump.Text   = string.format("%.0f", h.JumpPower)
                    vHealth.Text = string.format("%.0f / %.0f", h.Health, h.MaxHealth)
                end
                if hrp then
                    local p = hrp.Position
                    vPos.Text = string.format("%.0f, %.0f, %.0f", p.X, p.Y, p.Z)
                end
                vPing.Text = tostring(#Players:GetPlayers())
            end)
        end
    end)

    MkSection(sc, "ACTIONS", 5)

    -- Teleport to random brainrot item
    local tpCard = Instance.new("TextButton", sc)
    tpCard.Size = UDim2.new(1,0,0,38)
    tpCard.BackgroundColor3 = Color3.fromRGB(20,50,20)
    tpCard.Text = "⚡  Teleport to Nearest Item"
    tpCard.Font = Enum.Font.GothamBold; tpCard.TextSize = 12
    tpCard.TextColor3 = PH_GREEN; tpCard.BorderSizePixel = 0
    tpCard.LayoutOrder = 6
    Instance.new("UICorner",tpCard).CornerRadius = UDim.new(0,8)
    tpCard.MouseButton1Click:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        -- find nearest collectible/part named with brainrot keywords
        local keywords = {"brainrot","skibidi","brain","mewing","rizz","gyatt","sigma","ohio"}
        local best, bestD = nil, 999
        for _, obj in ipairs(workspace:GetDescendants()) do
            local nm = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if nm:find(kw) and obj:IsA("BasePart") then
                    local d = (obj.Position - hrp.Position).Magnitude
                    if d < bestD then bestD=d; best=obj end
                end
            end
        end
        if best then
            hrp.CFrame = CFrame.new(best.Position + Vector3.new(0,3,0))
            notify("PornoHub","Teleported to "..best.Name)
        else
            notify("PornoHub","No brainrot item found nearby")
        end
    end)

    -- Noclip toggle
    local noclipOn = false
    local noclipRow, noclipSetState = MkToggle(sc, "Noclip", "👻", 7, false, function(s)
        noclipOn = s
        if s then
            addConn("noclip", RunService.Stepped:Connect(function()
                if not noclipOn then return end
                if Char then
                    for _, p in ipairs(Char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end))
        else
            stopConn("noclip")
            if Char then
                for _, p in ipairs(Char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end)

    -- Infinite Jump
    local ijOn = false
    local ijRow, ijSetState = MkToggle(sc, "Infinite Jump", "♾️", 8, false, function(s)
        ijOn = s
        if s then
            addConn("ijump", UserInputService.JumpRequest:Connect(function()
                if not ijOn then return end
                local h = getHum()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end))
        else
            stopConn("ijump")
        end
    end)

    MkSection(sc, "KEY INFO", 12)

    local keyInfoCard = Instance.new("Frame", sc)
    keyInfoCard.Size = UDim2.new(1,0,0,44)
    keyInfoCard.BackgroundColor3 = Color3.fromRGB(18,18,18)
    keyInfoCard.BorderSizePixel = 0; keyInfoCard.LayoutOrder = 13
    Instance.new("UICorner",keyInfoCard).CornerRadius = UDim.new(0,8)
    local kiStroke = Instance.new("UIStroke",keyInfoCard)
    kiStroke.Color=PH_ORANGE; kiStroke.Thickness=1; kiStroke.Transparency=0.6
    local kiTxt = Instance.new("TextLabel",keyInfoCard)
    kiTxt.Size = UDim2.new(1,-16,1,0); kiTxt.Position = UDim2.new(0,8,0,0)
    kiTxt.BackgroundTransparency=1
    local savedK = loadKey()
    kiTxt.Text = savedK and ("🔑 Key saved: "..string.sub(savedK,1,8).."...") or "🔑 No saved key"
    kiTxt.Font=Enum.Font.Gotham; kiTxt.TextSize=10
    kiTxt.TextColor3=PH_GREY
    kiTxt.TextXAlignment=Enum.TextXAlignment.Left
    kiTxt.TextYAlignment=Enum.TextYAlignment.Center
end

-- ═══════════════════════════════════════════════════════
-- VIEWPORT resize handler
-- ═══════════════════════════════════════════════════════
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    VP = workspace.CurrentCamera.ViewportSize
    isMobile = VP.X < 700 or UserInputService.TouchEnabled
    W = isMobile and math.clamp(math.floor(VP.X*0.92),310,440) or 440
    H = isMobile and 400 or 560
    Main.Size = UDim2.fromOffset(W,H)
    Main.Position = UDim2.fromOffset(
        math.clamp(Main.Position.X.Offset, 0, VP.X-W),
        math.clamp(Main.Position.Y.Offset, 0, VP.Y-46))
    ToggleBtn.Position = UDim2.fromOffset(
        math.clamp(ToggleBtn.Position.X.Offset, 0, VP.X-44),
        math.clamp(ToggleBtn.Position.Y.Offset, 0, VP.Y-44))
end)

notify("PornoHub","Steal a Brainrot Hub loaded! v1.0.0")
