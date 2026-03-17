local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local abilitiesFolder = character:WaitForChild("Abilities")
local UserInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local heartbeatConnection
local upgrades = localPlayer.Upgrades
local UseRage = false
local sliderValue = 20
local focusedBall = nil
local stayspawnshit = false
local autoGrabbing = false
local autoDashing = false
local autoAbility = false
local infiniteJump = false

local function onCharacterAdded(newCharacter)
    character = newCharacter
    abilitiesFolder = character:WaitForChild("Abilities")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

local TruValue = Instance.new("StringValue")
if workspace:FindFirstChild("AbilityThingyk1212") then
    workspace:FindFirstChild("AbilityThingyk1212"):Remove()
    task.wait(0.1)
    TruValue.Parent = game:GetService("Workspace")
    TruValue.Name = "AbilityThingyk1212"
    TruValue.Value = "Dash"
else
    TruValue.Parent = game:GetService("Workspace")
    TruValue.Name = "AbilityThingyk1212"
    TruValue.Value = "Dash"
end

local Window = Rayfield:CreateWindow({
   Name = "Blueberry",
   LoadingTitle = "Blueberry",
   LoadingSubtitle = "by Fix Code",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BlueberryConfig",
      FileName = "Configuration"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false,
   KeySettings = {
      Title = "Blueberry",
      Subtitle = "Key System",
      Note = "No key needed",
      FileName = "BlueberryKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = ""
   }
})

local AutoParry = Window:CreateTab("Auto Parry", 13014537525)
local Main = Window:CreateTab("Main", 13014546637)
local Misc = Window:CreateTab("Misc", 13014546637)
local AutoOpen = Window:CreateTab("Auto Open", 13014546637)
local Misc2 = Window:CreateTab("Misc2", 13014546637)
local Skins = Window:CreateTab("Skins", 13014546637)

local function startAutoParry()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local ballsFolder = workspace:WaitForChild("Balls")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local abilityButtonPress = replicatedStorage.Remotes.AbilityButtonPress

    print("Script successfully ran.")

    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end
    localPlayer.CharacterAdded:Connect(onCharacterAdded)

    if character then
        print("Character found.")
    else
        print("Character not found.")
        return
    end
    
    local function chooseNewFocusedBall()
        local balls = ballsFolder:GetChildren()
        for _, ball in ipairs(balls) do
            if ball:GetAttribute("realBall") ~= nil and ball:GetAttribute("realBall") == true then
                focusedBall = ball
                print(focusedBall.Name)
                break
            elseif ball:GetAttribute("target") ~= nil then
                focusedBall = ball
                print(focusedBall.Name)
                break
            end
        end
        
        if focusedBall == nil then
            print("Debug: Could not find a ball that's the realBall or has a target.")
        end
        return focusedBall
    end

    chooseNewFocusedBall()

    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR_FAST = 0.050
    local VELOCITY_SCALING_FACTOR_SLOW = 0.1

    local function getDynamicThreshold(ballVelocityMagnitude)
        if ballVelocityMagnitude > 60 then
            print("Going Fast!")
            return math.max(0.20, BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_FAST))
        else
            return math.min(0.01, BASE_THRESHOLD + (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_SLOW))
        end
    end

    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
        
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
        
        return (distanceToPlayer - sliderValue) / velocityTowardsPlayer
    end

    local function isWalkSpeedZero()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return humanoid.WalkSpeed == 0
        end
        return false
    end

    local function checkBallDistance()
        if not character or not character:FindFirstChild("Highlight") then return end

        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity

        if focusedBall and not focusedBall.Parent then
            print("Focused ball lost parent. Choosing a new focused ball.")
            chooseNewFocusedBall()
        end
        if not focusedBall then 
            print("No focused ball.")
            chooseNewFocusedBall()
        end

        local ball = focusedBall
        if not ball then return end
        
        local distanceToPlayer = (ball.Position - charPos).Magnitude
        local ballVelocityTowardsPlayer = ball.Velocity:Dot((charPos - ball.Position).Unit)
        
        if distanceToPlayer < 10 then
            parryButtonPress:Fire()
        end
        local isCheckingRage = false

        if timeUntilImpact(ball.Velocity, distanceToPlayer, charVel) < getDynamicThreshold(ballVelocityTowardsPlayer) then
            if character.Abilities["Raging Deflection"].Enabled and UseRage == true then
                if not isCheckingRage then
                    isCheckingRage = true
                    abilityButtonPress:Fire()
                    if not isWalkSpeedZero() then
                        parryButtonPress:Fire()
                    end
                    isCheckingRage = false
                end
            else
                parryButtonPress:Fire()
            end
        end
    end

    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopAutoParry()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

local Descrip = AutoParry:CreateButton({
   Name = "Credits (Click)",
   Callback = function()
    Rayfield:Notify({
   Title = "Credits",
   Content = "Blueberry Script by Fix Code | Auto Parry By infernokarl",
   Duration = 60,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("Thanks for using Blueberry!")
      end
   },
},
})
end
})

local AutoParrySection = AutoParry:CreateSection("Auto Parry")

local AutoParryToggle = AutoParry:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "AutoParryFlag",
    Callback = function(Value)
        if Value then
            startAutoParry()
        else
            stopAutoParry()
        end
    end,
})

local AutoRagingDeflect = AutoParry:CreateToggle({
    Name = "Auto Rage Parry (MUST EQUIP RAGING DEFLECT)",
    CurrentValue = false,
    Flag = "AutoRagingDeflectFlag",
    Callback = function(Value)
        UseRage = Value
    end,
})

local HalfLegitSpawn = AutoParry:CreateToggle({
    Name = "Half Legit Stay Spawn",
    CurrentValue = false,
    Flag = "StaySpawnFlag",
    Callback = function(Value)
        stayspawnshit = Value
        task.spawn(function()
            while stayspawnshit do 
                wait()
                if stayspawnshit and character then
                    character.Parent = workspace.Alive
                end
            end
        end)
    end,
})

local ParryDistanceSlider = AutoParry:CreateSlider({
    Name = "Parry Distance",
    Min = 0,
    Max = 50,
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 20,
    Flag = "ParryDistanceFlag",
    Callback = function(Value)
        sliderValue = Value
    end,
})

local MainSection = Main:CreateSection("Main Features")

local AutoBallGrabToggle = Main:CreateToggle({
    Name = "Auto Ball Grab",
    CurrentValue = false,
    Flag = "AutoBallGrabFlag",
    Callback = function(Value)
        autoGrabbing = Value
        if Value then
            task.spawn(function()
                while autoGrabbing do
                    local ballsFolder = workspace:FindFirstChild("Balls")
                    if ballsFolder then
                        local balls = ballsFolder:GetChildren()
                        for _, ball in ipairs(balls) do
                            if ball:GetAttribute("realBall") == true then
                                local touchInterest = ball:FindFirstChild("TouchInterest")
                                if touchInterest then
                                    firetouchinterest(character.HumanoidRootPart, ball, 0)
                                    firetouchinterest(character.HumanoidRootPart, ball, 1)
                                end
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end,
})

local AutoDashToggle = Main:CreateToggle({
    Name = "Auto Dash",
    CurrentValue = false,
    Flag = "AutoDashFlag",
    Callback = function(Value)
        autoDashing = Value
        if Value then
            task.spawn(function()
                while autoDashing do
                    pcall(function()
                        local dashRemote = replicatedStorage:FindFirstChild("Remotes"):FindFirstChild("DashButtonPress")
                        if dashRemote then
                            dashRemote:Fire()
                        end
                    end)
                    wait(0.3)
                end
            end)
        end
    end,
})

local AutoAbilityToggle = Main:CreateToggle({
    Name = "Auto Ability",
    CurrentValue = false,
    Flag = "AutoAbilityFlag",
    Callback = function(Value)
        autoAbility = Value
        if Value then
            task.spawn(function()
                while autoAbility do
                    pcall(function()
                        local abilityRemote = replicatedStorage:FindFirstChild("Remotes"):FindFirstChild("AbilityButtonPress")
                        if abilityRemote and character:FindFirstChild("Abilities") then
                            for _, ability in ipairs(character.Abilities:GetChildren()) do
                                if ability:FindFirstChild("Enabled") and ability.Enabled.Value == true then
                                    abilityRemote:Fire()
                                    break
                                end
                            end
                        end
                    end)
                    wait(0.5)
                end
            end)
        end
    end,
})

local MiscSection = Misc:CreateSection("Miscellaneous")

local InfiniteJumpToggle = Misc:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpFlag",
    Callback = function(Value)
        infiniteJump = Value
        if Value then
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.Space and infiniteJump then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    end,
})

local NoclipToggle = Misc:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipFlag",
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Value do
                    wait()
                    if character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local AntiKnockbackToggle = Misc:CreateToggle({
    Name = "Anti Knockback",
    CurrentValue = false,
    Flag = "AntiKnockbackFlag",
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Value do
                    wait()
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.Velocity = Vector3.new(0, character.HumanoidRootPart.Velocity.Y, 0)
                    end
                end
            end)
        end
    end,
})

local AutoOpenSection = AutoOpen:CreateSection("Auto Open")

local AutoChestToggle = AutoOpen:CreateToggle({
    Name = "Auto Open Chest",
    CurrentValue = false,
    Flag = "AutoChestFlag",
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Value do
                    wait(0.1)
                    local chests = workspace:FindFirstChild("Chests")
                    if chests then
                        for _, chest in ipairs(chests:GetChildren()) do
                            local distance = (character.HumanoidRootPart.Position - chest.Position).Magnitude
                            if distance < 50 then
                                local touchInterest = chest:FindFirstChild("TouchInterest")
                                if touchInterest then
                                    firetouchinterest(character.HumanoidRootPart, chest, 0)
                                    firetouchinterest(character.HumanoidRootPart, chest, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local Misc2Section = Misc2:CreateSection("Advanced Settings")

local WalkSpeedSlider = Misc2:CreateSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 150,
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "WalkSpeedFlag",
    Callback = function(Value)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

local JumpPowerSlider = Misc2:CreateSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 150,
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPowerFlag",
    Callback = function(Value)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

local GravitySlider = Misc2:CreateSlider({
    Name = "Gravity",
    Min = 0,
    Max = 196.2,
    Increment = 1,
    Suffix = "",
    CurrentValue = 196.2,
    Flag = "GravityFlag",
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

local CameraZoomSlider = Misc2:CreateSlider({
    Name = "Camera Distance",
    Min = 0,
    Max = 100,
    Increment = 1,
    Suffix = "",
    CurrentValue = 15,
    Flag = "CameraZoomFlag",
    Callback = function(Value)
        local camera = workspace.CurrentCamera
        if camera and character:FindFirstChild("HumanoidRootPart") then
            camera.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, Value)
        end
    end,
})

local LimitedSkinsSection = Skins:CreateSection("Limited Skins")

local EmpyreanGreatblade = Skins:CreateButton({
   Name = "Empyrean Greatblade",
   Callback = function()
        pcall(function()
            local Empyreansword = game:GetService("ReplicatedStorage").Misc.Swords.Limited["Empyrean Greatblade"]
            local SkinSwordClone = Empyreansword:FindFirstChild("Meshes/Sword"):Clone()
            local Katanamesh = character:FindFirstChildOfClass("Model"):FindFirstChild("KatanaMesh")

            SkinSwordClone.Anchored = false
            SkinSwordClone.Parent = character:FindFirstChildOfClass("Model")
            SkinSwordClone.CFrame = Katanamesh.CFrame
            
            local weldthing = Instance.new("Weld")
            weldthing.Parent = SkinSwordClone
            weldthing.Part0 = SkinSwordClone
            weldthing.Part1 = Katanamesh
            Katanamesh.Transparency = 1

            character.HumanoidRootPart.CFrame = CFrame.new(-233.710556, 123.299973, 203.648102)
            task.wait(0.1)
            SkinSwordClone.Rotation = Vector3.new(-75.41799926757812, -90, 0)
            
            Rayfield:Notify({
               Title = "Skin Applied",
               Content = "Empyrean Greatblade equipped",
               Duration = 3,
               Image = 4483362458,
            })
        end)
   end
})

local OniClawsButton = Skins:CreateButton({
   Name = "Oni Claws",
   Callback = function()
        pcall(function()
            local claws = game:GetService("ReplicatedStorage").Misc.Swords.Limited["Oni Claws"]:Clone()
            local Katanamesh = character:FindFirstChildOfClass("Model"):FindFirstChild("KatanaMesh")
            local sword = character:FindFirstChildOfClass("Model")

            local Glove = claws
            local Cestus1 = Glove:FindFirstChild("Cestus")
            local Cestus2 = Glove:FindFirstChild("Cestus2")

            Glove.Parent = sword
            
            local leftarm = Instance.new("Weld")
            leftarm.Name = "Left Arm"
            leftarm.Parent = Cestus1
            leftarm.Part0 = Cestus1.zaza
            leftarm.Part1 = character:FindFirstChild("Left Arm")

            local rightarm = Instance.new("Weld")
            rightarm.Name = "Right Arm"
            rightarm.Parent = Cestus2
            rightarm.Part0 = Cestus2.zaza
            rightarm.Part1 = character:FindFirstChild("Right Arm")
            
            Katanamesh.Transparency = 1

            character:FindFirstChildOfClass("Model").sord:Remove()
            character:FindFirstChildOfClass("Model").handle:Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("WhiteFlameCharges"):Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("Excalibur"):Remove()
            
            Rayfield:Notify({
               Title = "Skin Applied",
               Content = "Oni Claws equipped",
               Duration = 3,
               Image = 4483362458,
            })
        end)
   end
})

local FunniOniClaws = Skins:CreateButton({
   Name = "Funni Oni Claws",
   Callback = function()
        pcall(function()
            local claws = game:GetService("ReplicatedStorage").Misc.Swords.Limited["Oni Claws"]:Clone()
            local claws2 = game:GetService("ReplicatedStorage").Misc.Swords.Limited["Oni Claws"]:Clone()
            local Katanamesh = character:FindFirstChildOfClass("Model"):FindFirstChild("KatanaMesh")
            local sword = character:FindFirstChildOfClass("Model")

            local Glove = claws
            local Glove2 = claws2
            local Cestus1 = Glove:FindFirstChild("Cestus")
            local Cestus2 = Glove:FindFirstChild("Cestus2")
            local Cestus1_2 = Glove2:FindFirstChild("Cestus")
            local Cestus2_2 = Glove2:FindFirstChild("Cestus2")

            Glove.Parent = sword
            local leftarm = Instance.new("Weld")
            leftarm.Name = "Left Arm"
            leftarm.Parent = Cestus1
            leftarm.Part0 = Cestus1.zaza
            leftarm.Part1 = character:FindFirstChild("Left Arm")

            local rightarm = Instance.new("Weld")
            rightarm.Name = "Right Arm"
            rightarm.Parent = Cestus2
            rightarm.Part0 = Cestus2.zaza
            rightarm.Part1 = character:FindFirstChild("Right Arm")

            Glove2.Parent = sword
            local lfetarm = Instance.new("Weld")
            lfetarm.Name = "Lfet Arm"
            lfetarm.Parent = Cestus2_2
            lfetarm.Part0 = Cestus2_2.zaza
            lfetarm.Part1 = character:FindFirstChild("Left Arm")

            local rarm = Instance.new("Weld")
            rarm.Name = "Rgiht Arm"
            rarm.Parent = Cestus1_2
            rarm.Part0 = Cestus1_2.zaza
            rarm.Part1 = character:FindFirstChild("Right Arm")

            Katanamesh.Transparency = 1

            character:FindFirstChildOfClass("Model").sord:Remove()
            character:FindFirstChildOfClass("Model").handle:Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("WhiteFlameCharges"):Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("Excalibur"):Remove()
            
            Rayfield:Notify({
               Title = "Skin Applied",
               Content = "Double Oni Claws equipped",
               Duration = 3,
               Image = 4483362458,
            })
        end)
   end
})

local UniqueSkinsSection = Skins:CreateSection("Unique")

local GodSaberButton = Skins:CreateButton({
   Name = "God Saber",
   Callback = function()
        pcall(function()
            local Katanamesh = character:FindFirstChildOfClass("Model"):FindFirstChild("KatanaMesh")
            local godsaber = game:GetService("ReplicatedStorage").Misc.Swords.Unique.Godsaber

            local SkinSwordClone = godsaber:Clone()
            local godkatanamesh = godsaber:FindFirstChild("KatanaMesh")
            local godhandle = godsaber:FindFirstChild("handle")
            local godsord = godsaber:FindFirstChild("sord")
            local godBlade = godsaber:FindFirstChild("Blade")
            local godMain = godBlade:FindFirstChild("Main")

            if character:FindFirstChildOfClass("Model"):FindFirstChild("Godsaber") then
                character:FindFirstChildOfClass("Model"):FindFirstChild("Godsaber"):Remove()
                task.wait(0.1)
            end

            godMain.Anchored = false
            godsord.Anchored = false
            godhandle.Anchored = false
            godkatanamesh.Anchored = false
            SkinSwordClone.Parent = character:FindFirstChildOfClass("Model")

            character.HumanoidRootPart.CFrame = CFrame.new(-233.710556, 123.299973, 203.648102)

            godsord.CFrame = Katanamesh.CFrame
            godhandle.CFrame = Katanamesh.CFrame + Vector3.new(0,0.6,-1.5)
            godkatanamesh.CFrame = Katanamesh.CFrame
            godMain.CFrame = Katanamesh.CFrame

            godkatanamesh.WeldConstraint.Part1 = character:FindFirstChild("Left Leg")

            task.wait(0.2)

            godMain.Rotation = Vector3.new(112, 0, 90)
            godhandle.Rotation = Vector3.new(-159, 0, 100)

            Katanamesh.Transparency = 1

            character:FindFirstChildOfClass("Model").sord:Remove()
            character:FindFirstChildOfClass("Model").handle:Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("WhiteFlameCharges"):Remove()
            character:FindFirstChildOfClass("Model"):FindFirstChild("Excalibur"):Remove()
            
            Rayfield:Notify({
               Title = "Skin Applied",
               Content = "God Saber equipped (if wrong position, reset and try again)",
               Duration = 5,
               Image = 4483362458,
            })
        end)
   end
})

print("Blueberry Script Loaded Successfully! 🫐")
Rayfield:Notify({
   Title = "Blueberry Loaded",
   Content = "Script by Fix Code | Ready to go!",
   Duration = 3,
   Image = 4483362458,
})
