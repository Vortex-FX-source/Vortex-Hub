-- ➜ PASTE YOUR UI LOADER HERE
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/Vortex-FX-UI-lua"))()

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local PlayerLevel = Player:WaitForChild("Data", 9e9):WaitForChild("Level", 9e9)
local MaxLavel = 2550
local Sea1 = game.PlaceId == 2753915549
local Sea2 = game.PlaceId == 4442272183
local Sea3 = game.PlaceId == 7447361652
local IsOwner = true
local Enemies = workspace:FindFirstChild("Enemies") or workspace
local Camera = workspace.CurrentCamera

local DATABASE_URL = "https://vortex-6af9a-default-rtdb.firebaseio.com/Servers.json"
local HttpService = game:GetService("HttpService")
local function sendFireballReport(eventName)
    local data = {
        JobId = game.JobId,
        Event = eventName,
        Sea = (Sea1 and "Sea 1") or (Sea2 and "Sea 2") or (Sea3 and "Sea 3"),
        Time = os.time()
    }
    pcall(function() HttpService:PostAsync(DATABASE_URL, HttpService:JSONEncode(data)) end)
end
local function scanLocalEvents()
    if Lighting.ClockTime >= 18 or Lighting.ClockTime <= 5 then
        if game.Lighting:FindFirstChild("FullMoon") or Lighting.ClockTime == 0 then
            sendFireballReport("Full Moon")
        else
            sendFireballReport("Night (Near Moon)")
        end
    end
    if workspace.Map:FindFirstChild("MirageIsland") then sendFireballReport("Mirage Island") end
    if workspace:FindFirstChild("Factory") and workspace.Map.Factory:FindFirstChild("Core") and workspace.Map.Factory.Core.Health > 0 then
        sendFireballReport("Factory Raid")
    end
    if workspace.Enemies:FindFirstChild("Pirate Brigade") then sendFireballReport("Pirate Raid") end
end

local BossListT = {
    "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", 
    "Chief Warden", "Swan", "Saber Expert", "Magma Admiral", "Fishman Lord", 
    "Wysper", "Franky", "Ice Admiral", "Tide Keeper", "Elephant", "Kilo Admiral", 
    "Beautiful Pirate", "Don Swan", "Awakened Ice Admiral", "Cyborg", "Longma", 
    "Captain Elephant", "Island Boy"
}
local TeleportPos = Vector3.new(0,0,0)
if not table.foreach then table.foreach = function(t, f) for k, v in pairs(t) do f(k, v) end end end
local VerifyNPC = function() return true end
local AttackDistance = function() end

function FireRemote(remoteName, ...)
    local rem = ReplicatedStorage:WaitForChild("Remotes", 9e9):WaitForChild(remoteName, 9e9)
    if rem then rem:FireServer(...) end
end

local TweenService = game:GetService("TweenService")
function PlayerTP(cframe)
    local char = Player.Character
    if char and char.PrimaryPart then
        local targ = typeof(cframe) == "Vector3" and CFrame.new(cframe) or cframe
        local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(char.PrimaryPart, info, {CFrame = targ})
        tween:Play()
        tween.Completed:Wait()
    end
end

function VerifyTool(name)
    for _,tool in pairs((Player.Character and Player.Character:GetChildren()) or {}) do
        if tool:IsA("Tool") and tool.Name == name then return true end
    end
    for _,tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == name then return true end
    end
    return false
end

function GetToolLevel(name)
    local stats = Player.Data.Stats
    local map = {["Melee"]="Melee", ["Defense"]="Defense", ["Sword"]="Sword", ["Gun"]="Gun", ["Demon Fruit"]="Demon Fruit"}
    return stats[map[name] or name].Level.Value
end

function EquipToolName(toolName)
    local char = Player.Character
    local bp = Player.Backpack
    local tool
    for _,v in pairs(bp:GetChildren()) do if v:IsA("Tool") and v.Name == toolName then tool = v; break end end
    for _,v in pairs(char:GetChildren()) do if v:IsA("Tool") and v.Name == toolName then tool = v; break end end
    if tool then char.Humanoid:EquipTool(tool) end
end

function EquipTool()
    EquipToolName(getgenv().FarmTool or "Melee")
end

function BringNPC(enemy, anchor)
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        enemy.HumanoidRootPart.CFrame = Player.Character.PrimaryPart.CFrame + Vector3.new(0,0,5)
    end
end

function ActiveHaki()
    FireRemote("ActivateBuso")
end

function PlayerClick()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.ButtonB, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, Enum.KeyCode.ButtonB, false, game)
end

function KeyboardPress(key)
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

function ServerHop()
    local ts = game:GetService("TeleportService")
    ts:TeleportToPlaceInstance(game.PlaceId, ts:GetServerId())
end

function VerifyNPC(name)
    return (workspace:FindFirstChild("Enemies") or workspace):FindFirstChild(name) ~= nil
end

function VerifyQuest(name)
    return VerifyNPC(name)
end

local Map = workspace:WaitForChild("Map", 9e9)
getgenv().FarmPos = Vector3.new(0, 15, 0)
getgenv().FarmDistance = 25

function fireclickdetector(obj)
    if obj then obj:Fire() end
end

function GetButton()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then return v end
    end
    return nil
end

function Configure(mode) return false end
function FruitFind() return nil end
function Get_Fruit(name) return name end
function QuestVisible() end
function GetEnemies() return nil end
function TweenNPCSpawn() end
function BuyFightStyle(style) FireRemote(style) end
function VerifyToolTip() return false end
function EquipToolTip() end
function AimBotPart() end
function EspFlowers() end
function EspPlayer() end
function EspFruits() end
function EspChests() end
function EspIslands() end

function AutoFarm_Level()
    task.spawn(function()
        while getgenv().AutoFarm_Level do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local nearest, dist = nil, math.huge
            for _, enemy in pairs(Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local d = (char.PrimaryPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; nearest = enemy end
                end
            end
            if nearest and nearest:FindFirstChild("HumanoidRootPart") then
                PlayerTP(nearest.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                EquipTool()
                ActiveHaki()
                PlayerClick()
            end
        end
    end)
end

function AutoFarmNearest()
    task.spawn(function()
        while getgenv().AutoFarmNearest do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local nearest, dist = nil, getgenv().FarmDistance or 20
            for _, enemy in pairs(Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local d = (char.PrimaryPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; nearest = enemy end
                end
            end
            if nearest and nearest:FindFirstChild("HumanoidRootPart") then
                PlayerTP(nearest.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                EquipTool()
                ActiveHaki()
                PlayerClick()
            end
        end
    end)
end

function AutoChestTween()
    task.spawn(function()
        while getgenv().AutoChestTween do
            task.wait(1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local chests = workspace:GetDescendants()
            local nearest, dist = nil, math.huge
            for _,obj in pairs(chests) do
                if (obj.Name == "Chest" or obj.Name == "Chest1" or obj.Name == "Chest2" or obj.Name == "Chest3") and obj:IsA("BasePart") then
                    local d = (char.PrimaryPart.Position - obj.Position).Magnitude
                    if d < dist then dist = d; nearest = obj end
                end
            end
            if nearest then
                PlayerTP(nearest.CFrame)
                task.wait(0.3)
                local cd = nearest:FindFirstChild("ClickDetector")
                if cd then cd:Fire() end
            end
        end
    end)
end

function AutoChestBypass() AutoChestTween() end

function AutoFarmBossSelected()
    task.spawn(function()
        while getgenv().AutoFarmBossSelected do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local bossName = getgenv().BossSelected
            if bossName then
                local boss = Enemies:FindFirstChild(bossName)
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    PlayerTP(boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                    EquipTool()
                    ActiveHaki()
                    PlayerClick()
                end
            end
        end
    end)
end

function KillAllBosses()
    task.spawn(function()
        while getgenv().KillAllBosses do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local nearest, dist = nil, math.huge
            for _,name in pairs(BossListT) do
                local boss = Enemies:FindFirstChild(name)
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    local d = (char.PrimaryPart.Position - boss.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; nearest = boss end
                end
            end
            if nearest and nearest:FindFirstChild("HumanoidRootPart") then
                PlayerTP(nearest.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                EquipTool()
                ActiveHaki()
                PlayerClick()
            end
        end
    end)
end

function KillAura()
    task.spawn(function()
        while getgenv().AutoKillAura do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local nearest, dist = nil, math.huge
            for _,target in pairs(Players:GetPlayers()) do
                if target ~= Player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                    local d = (char.PrimaryPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; nearest = target end
                end
            end
            if nearest and nearest.Character:FindFirstChild("HumanoidRootPart") then
                PlayerTP(nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                EquipTool()
                ActiveHaki()
                for _ = 1, 10 do PlayerClick(); task.wait(0.01) end
            end
        end
    end)
end

function AutoFarmSea()
    task.spawn(function()
        while getgenv().AutoFarmSea do
            task.wait(0.1)
            local char = Player.Character
            if not char or not char.PrimaryPart then continue end
            local onBoat = false
            for _,v in pairs(char:GetDescendants()) do if v:IsA("VehicleSeat") then onBoat = true; break end end
            if not onBoat then BuyNewBoat(); task.wait(2) end
            local seaCentre = Sea3 and Vector3.new(-15000,0,500) or Sea2 and Vector3.new(-3000,0,-8000) or Vector3.new(1500,0,2000)
            PlayerTP(CFrame.new(seaCentre))
            local seaEnemies = {"SeaBeast","Terrorshark","Piranha","FishCrewMember","Shark"}
            for _,name in pairs(seaEnemies) do
                local enemy = Enemies:FindFirstChild(name)
                if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                    PlayerTP(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                    EquipTool(); ActiveHaki(); PlayerClick()
                end
            end
        end
    end)
end

function AutoFarmRaid()
    task.spawn(function()
        while getgenv().AutoFarmRaid do
            task.wait(0.1)
            if not VerifyTool("Special Microchip") then FireRemote("RaidsNpc","Select",getgenv().SelectRaidChip); task.wait(1) end
            if not Player.PlayerGui.Main.Timer.Visible then
                local summon = Sea2 and workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector or workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector
                if summon then fireclickdetector(summon) end
                repeat task.wait() until Player.PlayerGui.Main.Timer.Visible; task.wait(1)
            end
            while Player.PlayerGui.Main.Timer.Visible do
                EquipTool()
                local Islands = workspace._WorldOrigin.Locations
                for i = 5,1,-1 do
                    local island = Islands:FindFirstChild("Island "..i)
                    if island then
                        PlayerTP(island.CFrame + Vector3.new(0,70,0))
                        for _,enemy in pairs(Enemies:GetChildren()) do
                            if enemy:FindFirstChild("HumanoidRootPart") and (island.Position - enemy.HumanoidRootPart.Position).Magnitude < 300 then
                                PlayerClick(); task.wait(0.05)
                            end
                        end
                    end
                end
                task.wait()
            end
            task.wait(1)
        end
    end)
end

function AutoPiratesSea() end
function AutoFactory() end
function AutoFarmBone() end
function AutoSoulReaper() end
function AutoFarmEctoplasm() end
function AutoFarmMaterial() end
function AutoFarmMastery() end
function AutoKitsuneIsland() end
function BuyNewBoat() FireRemote("ShipwrightTalk","Buy","Boat") end
function AutoSecondSea() FireRemote("TravelDressrosa") end
function AutoThirdSea() FireRemote("TravelZou") end
function AutoUnlockSaber() end
function AutoEnelBossPole() end
function AutoSawBoss() end
function AutoKillDonSwan() end
function AutoBartiloQuest() end
function AutoRengoku() end
function AutoRaceV2() end
function AutoCursedCaptain() end
function AutoDarkbeard() end
function AutoKillLawBoss() end
function AutoEliteHunter() end
function AutoTushita() end
function AutoCakePrince() end
function AutoDoughKing() end
function AutoRipIndra() end
function AutoMusketeerHat() end
function AutoRainbowHaki() end
function AutoBuyHakiColor() end

local Window = redzlib:MakeWindow({
    Title = "vortex fx  : Blox Fruits",
    SubTitle = "by syzo gamer ",
    SaveFolder = "redz Hub | Blox Fruits.lua"
})
local AFKOptions = {}
local Discord = Window:MakeTab({"Discord", "Info"})
Discord:AddDiscordInvite({
    Name = "syzo Hub | Community",
    Description = "Join our discord community to receive information about the next update",
    Logo = "rbxassetid://115490382631820",
    Invite = "https://discord.gg/sAUgSnu42T"
})
local MainFarm = Window:MakeTab({"Farm", "Home"})

if Sea2 or Sea3 then
    local AutoSea = Window:MakeTab({"Sea", "Waves"})
    if Sea3 then
        AutoSea:AddSection({"Kitsune"})
        local KILabel = AutoSea:AddParagraph({"Kitsune Island : not spawn"})
        AutoSea:AddToggle({Name = "Auto Kitsune Island", Callback = function(Value) getgenv().AutoKitsuneIsland = Value; AutoKitsuneIsland() end})
        AutoSea:AddToggle({Name = "Auto Trade Azure Ember", Callback = function(Value) getgenv().TradeAzureEmber = Value task.spawn(function() local Modules = ReplicatedStorage:WaitForChild("Modules", 9e9) local Net = Modules:WaitForChild("Net", 9e9) local KitsuneRemote = Net:WaitForChild("RF/KitsuneStatuePray", 9e9) while getgenv().TradeAzureEmber do task.wait(1) KitsuneRemote:InvokeServer() end end) end})
        task.spawn(function() local Map = workspace:WaitForChild("Map", 9e9) while task.wait() do if Map:FindFirstChild("KitsuneIsland") then local plrPP = Player.Character and Player.Character.PrimaryPart if plrPP then local dist = tostring(math.floor((plrPP.Position - Map.KitsuneIsland.WorldPivot.p).Magnitude / 3)) KILabel:SetTitle("Kitsune Island : Spawned | Distance : " .. dist) else KILabel:SetTitle("Kitsune Island : Spawned") end else KILabel:SetTitle("Kitsune Island : not Spawn") end end end)
        AutoSea:AddSection({"Sea"})
        AutoSea:AddToggle({Name = "Auto Farm Sea", Callback = function(Value) getgenv().AutoFarmSea = Value; AutoFarmSea() end})
        AutoSea:AddButton({Name = "Buy New Boat", Callback = function() BuyNewBoat() end})
        AutoSea:AddSection({"Material"})
        AutoSea:AddToggle({"Auto Wood Planks", false, function(Value) getgenv().AutoWoodPlanks = Value task.spawn(function() local Map = workspace:WaitForChild("Map", 9e9) local BoatCastle = Map:WaitForChild("Boat Castle", 9e9) local function TreeModel() for _,Model in pairs(BoatCastle["IslandModel"]:GetChildren()) do if Model.Name == "Model" and Model:FindFirstChild("Tree") then return Model end end end local function GetTree() local Tree = TreeModel() if Tree then local Nearest = math.huge local selected for _,tree in pairs(Tree:GetChildren()) do local plrPP = Player.Character and Player.Character.PrimaryPart if tree and tree.PrimaryPart and tree.PrimaryPart.Anchored then if plrPP and (plrPP.Position - tree.PrimaryPart.Position).Magnitude < Nearest then Nearest = (plrPP.Position - tree.PrimaryPart.Position).Magnitude selected = tree end end end return selected end end local RandomEquip = "" task.spawn(function() while getgenv().AutoWoodPlanks do if VerifyToolTip("Melee") then RandomEquip = "Melee"; task.wait(2) end if VerifyToolTip("Blox Fruit") then RandomEquip = "Blox Fruit"; task.wait(3) end if VerifyToolTip("Sword") then RandomEquip = "Sword"; task.wait(2) end if VerifyToolTip("Gun") then RandomEquip = "Gun"; task.wait(2) end end end) while getgenv().AutoWoodPlanks do task.wait() local Tree = GetTree(); EquipToolTip(RandomEquip) if Tree and Tree.PrimaryPart then PlayerTP(Tree.PrimaryPart.CFrame * CFrame.new(0, 5, 0)) local plrPP = Player.Character and Player.Character.PrimaryPart if plrPP and (plrPP.Position - Tree.PrimaryPart.Position).Magnitude < 10 then if getgenv().SeaSkillZ then KeyboardPress("Z") end if getgenv().SeaSkillX then KeyboardPress("X") end if getgenv().SeaSkillC then KeyboardPress("C") end if getgenv().SeaSkillV then KeyboardPress("V") end if getgenv().SeaSkillF then KeyboardPress("F") end if getgenv().SeaAimBotSkill then AimBotPart(Tree.PrimaryPart) end end end end end) end})
    end
    AutoSea:AddSection({"Panic Mode"})
    AutoSea:AddSlider({Name = "Select Health", Min = 20, Max = 70, Default = 25, Callback = function(Value) getgenv().HealthPanic = Value end})
    AutoSea:AddToggle({Name = "Panic Mode", CurrentValue = true, Callback = function(Value) getgenv().PanicMode = Value end})
    AutoSea:AddSection({"Farm Select"})
    AutoSea:AddParagraph({"Fish"})
    AutoSea:AddToggle({Name = "Terrorshark", Flag = "Sea/TerrorShark", Default = true, Callback = function(Value) getgenv().Terrorshark = Value end})
    AutoSea:AddToggle({Name = "Piranha", Flag = "Sea/Piranha", Default = true, Callback = function(Value) getgenv().Piranha = Value end})
    AutoSea:AddToggle({Name = "Fish Crew Member", Flag = "Sea/FishCrewMember", Default = true, Callback = function(Value) getgenv().FishCrewMember = Value end})
    AutoSea:AddToggle({Name = "Shark", Flag = "Sea/Shark", Default = true, Callback = function(Value) getgenv().Shark = Value end})
    AutoSea:AddParagraph({"Boats"})
    AutoSea:AddToggle({Name = "Pirate Brigade", Flag = "Sea/PirateBrigade", Default = true, Callback = function(Value) getgenv().PirateBrigade = Value end})
    AutoSea:AddToggle({Name = "Pirate Grand Brigade", Flag = "Sea/PirateGrandBrigade", Default = true, Callback = function(Value) getgenv().PirateGrandBrigade = Value end})
    AutoSea:AddToggle({Name = "Fish Boat", Flag = "Sea/FishBoat", Default = true, Callback = function(Value) getgenv().FishBoat = Value end})
    AutoSea:AddSection({"Skill"})
    AutoSea:AddToggle({Name = "AimBot Skill Enemie", Flag = "Mastery/Aimbot", Default = true, Callback = function(Value) getgenv().SeaAimBotSkill = Value end})
    AutoSea:AddToggle({Name = "Skill Z", Flag = "Mastery/Z", Default = true, Callback = function(Value) getgenv().SeaSkillZ = Value end})
    AutoSea:AddToggle({Name = "Skill X", Flag = "Mastery/X", Default = true, Callback = function(Value) getgenv().SeaSkillX = Value end})
    AutoSea:AddToggle({Name = "Skill C", Flag = "Mastery/C", Default = true, Callback = function(Value) getgenv().SeaSkillC = Value end})
    AutoSea:AddToggle({Name = "Skill V", Flag = "Mastery/V", Default = true, Callback = function(Value) getgenv().SeaSkillV = Value end})
    AutoSea:AddToggle({Name = "Skill F", Flag = "Mastery/F", Callback = function(Value) getgenv().SeaSkillF = Value end})
    AutoSea:AddSection({"NPCs"})
    AutoSea:AddToggle({Name = "Teleport To Shark Hunter", Callback = function(Value) getgenv().NPCtween = Value task.spawn(function() while getgenv().NPCtween do task.wait() PlayerTP(CFrame.new(-16526, 108, 752)) end end) end})
    AutoSea:AddToggle({Name = "Teleport To Beast Hunter", Callback = function(Value) getgenv().NPCtween = Value task.spawn(function() while getgenv().NPCtween do task.wait() PlayerTP(CFrame.new(-16281, 73, 263)) end end) end})
    AutoSea:AddToggle({Name = "Teleport To Spy", Callback = function(Value) getgenv().NPCtween = Value task.spawn(function() while getgenv().NPCtween do task.wait() PlayerTP(CFrame.new(-16471, 528, 539)) end end) end})
    AutoSea:AddSection({"Configs"})
    AutoSea:AddDropdown({Name = "Tween Sea Level", Options = {"1","2","3","4","5","6","inf"}, Default = {"6"}, Flag = "Sea/SeaLevel", Callback = function(Value) getgenv().SeaLevelTP = Value end})
    AutoSea:AddSlider({Name = "Boat Tween Speed", Min = 100, Max = 300, Increase = 10, Default = 250, Flag = "Sea/BoatSpeed", Callback = function(Value) getgenv().SeaBoatSpeed = Value end})
end

if Sea2 or Sea3 then
    local RaceTab = Window:MakeTab({"Race", ""})
    RaceTab:AddToggle({Name = "Auto Pull Lever", CurrentValue = false, Callback = function(Value) end})
    RaceTab:AddToggle({Name = "Auto Stone Puzzle", CurrentValue = false, Callback = function(Value) end})
    RaceTab:AddSection({"Auto Mirage"})
    RaceTab:AddToggle({Name = "Auto Find Mirage", CurrentValue = false, Callback = function(Value) end})
    RaceTab:AddToggle({Name = "Auto Gear Puzzle", CurrentValue = false, Callback = function(Value) getgenv().AutoMiragePuzzle = Value local function LookToMoon() local MoonDirection = Lighting:GetMoonDirection() local LookToPos = Camera.CFrame.p + MoonDirection * 100 Camera.CFrame = CFrame.lookAt(Camera.CFrame.p, LookToPos) end local Connection = RunService.Heartbeat:Connect(LookToMoon) while getgenv().AutoMiragePuzzle do task.wait() end if Connection then Connection:Disconnect() end end})
    RaceTab:AddSection({"Auto Race"})
    RaceTab:AddToggle({Name = "Auto Finish Trial", CurrentValue = false, Callback = function(Value) getgenv().AutoFinishTrial = Value task.spawn(function() local PlayerRace while getgenv().AutoFinishTrial do task.wait() PlayerRace = Player.Data.Race.Value if PlayerRace == "Cyborg" then PlayerTP(CFrame.new(28654, 14898, -30)) elseif PlayerRace == "Ghoul" then KillAura() elseif PlayerRace == "Human" then KillAura() elseif PlayerRace == "Mink" then for _,part in pairs(workspace:GetDescendants()) do if part.Name == "StartPoint" then PlayerTP(part.CFrame) end end elseif PlayerRace == "Skypiea" then pcall(function() for _,part in pairs(workspace.Map.SkyTrial.Model:GetDescendants()) do if part.Name == "snowisland_Cylinder.081" then PlayerTP(part.CFrame) end end end) end end end) end})
end

local QuestsTabs = Window:MakeTab({"Quests/Items", "Swords"})
local FruitAndRaid = Window:MakeTab({"Fruit/Raid", "Cherry"})

if PlayerLevel.Value < MaxLavel then
    local StatsTab = Window:MakeTab({"Stats", "signal"})
    local PointsSlider, Melee, Defense, Sword, Gun, DemonFruit = 1
    local function AutoStats() local function AddStats(Stats) if Player.Data.Points.Value >= 1 then local Points = math.clamp(PointsSlider, 1, Player.Data.Points.Value) FireRemote("AddPoint", Stats, Points) end end while getgenv().AutoStats do task.wait() if Melee then AddStats("Melee") end if Defense then AddStats("Defense") end if Sword then AddStats("Sword") end if Gun then AddStats("Gun") end if DemonFruit then AddStats("Demon Fruit") end end end
    StatsTab:AddToggle({Name = "Auto Stats", Flag = "Stats/AutoStats", Callback = function(Value) getgenv().AutoStats = Value; AutoStats() end})
    StatsTab:AddSlider({Name = "Select Points", Flag = "Stats/SelectPoints", Min = 1, Max = 100, Increase = 1, Default = 1, Callback = function(Value) PointsSlider = Value end})
    StatsTab:AddSection({"Select Stats"})
    StatsTab:AddToggle({Name = "Melee", Flag = "Stats/SelectMelee", Callback = function(Value) Melee = Value end})
    StatsTab:AddToggle({Name = "Defense", Flag = "Stats/SelectDefense", Callback = function(Value) Defense = Value end})
    StatsTab:AddToggle({Name = "Sword", Flag = "Stats/SelectSword", Callback = function(Value) Sword = Value end})
    StatsTab:AddToggle({Name = "Gun", Flag = "Stats/SelectGun", Callback = function(Value) Gun = Value end})
    StatsTab:AddToggle({Name = "Demon Fruit", Flag = "Stats/SelectDemonFruit", Callback = function(Value) DemonFruit = Value end})
end

local Teleport = Window:MakeTab({"Teleport", "Locate"})
local Visual = Window:MakeTab({"Visual", "User"})
local Shop = Window:MakeTab({"Shop", "ShoppingCart"})
local Misc = Window:MakeTab({"Misc", "Settings"})

local PvPTab = Window:MakeTab({"PvP", "Crosshair"})
PvPTab:AddToggle({Name = "Kill Aura (Players)", Callback = function(Value) getgenv().AutoKillAura = Value KillAura() end})
PvPTab:AddToggle({Name = "Teleport to Nearest Player", Callback = function(Value) getgenv().TeleportToPlayer = Value task.spawn(function() while getgenv().TeleportToPlayer do task.wait(1) local nearest, dist = nil, math.huge for _,p in pairs(Players:GetPlayers()) do if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (Player.Character.PrimaryPart.Position - p.Character.HumanoidRootPart.Position).Magnitude if d < dist then dist = d; nearest = p end end end if nearest then PlayerTP(nearest.Character.HumanoidRootPart.CFrame) end end end) end})

local SpecialTab = Window:MakeTab({"Special", "Star"})
SpecialTab:AddSection({"Global Fireball Tracker"})
SpecialTab:AddToggle({Name = "Auto-Report My Server", Description = "Shares your server's Moon/Mirage with all Vortex users", Callback = function(Value) getgenv().Reporting = Value task.spawn(function() while getgenv().Reporting do pcall(function() scanLocalEvents() end) task.wait(300) end end) end})
SpecialTab:AddSection({"Server Finder (Teleport)"})
local function fetchFireball(targetEvent) local success, result = pcall(function() return game:GetService("HttpService"):GetAsync("https://vortex-6af9a-default-rtdb.firebaseio.com/Servers.json") end) if success and result and result ~= "null" then local data = game:GetService("HttpService"):JSONDecode(result) local found = false for _, info in pairs(data) do if info.Event == targetEvent then found = true redzlib:MakeNotify({Name = "Vortex Finder", Text = "Found "..targetEvent.."! Joining...", Time = 5}) task.wait(1) game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, info.JobId, Player) break end end if not found then redzlib:MakeNotify({Name = "Vortex", Text = "No "..targetEvent.." found in database.", Time = 5}) end else redzlib:MakeNotify({Name = "Vortex Error", Text = "Database is empty or offline.", Time = 5}) end end
SpecialTab:AddButton({Name = "Find Mirage Island Server", Callback = function() fetchFireball("Mirage Island") end})
SpecialTab:AddButton({Name = "Find Full Moon Server", Callback = function() fetchFireball("Full Moon") end})
SpecialTab:AddButton({Name = "Find Near Full Moon Server", Callback = function() fetchFireball("Night (Near Moon)") end})
SpecialTab:AddButton({Name = "Find Factory / Pirate Raid", Callback = function() fetchFireball("Factory Raid") fetchFireball("Pirate Raid") end})
SpecialTab:AddSection({"Super Fast Attack (One Shot)"})
SpecialTab:AddToggle({ Name = "Super Fast Attack (One Shot)", Description = "Rapidly attacks nearby enemies/bosses. Can one-shot even Rip Indra / Uzoth if you stay close. (Use at your own risk)", Callback = function(Value) getgenv().SuperFastAttack = Value if Value then task.spawn(function() while getgenv().SuperFastAttack do task.wait(0.05) local char = Player.Character if char and char.PrimaryPart then local nearest, dist = nil, 100 for _, enemy in pairs(Enemies:GetChildren()) do if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then local d = (char.PrimaryPart.Position - enemy.HumanoidRootPart.Position).Magnitude if d < dist then dist = d; nearest = enemy end end end if nearest then PlayerTP(nearest.HumanoidRootPart.CFrame * CFrame.new(0,0,3)) EquipTool() ActiveHaki() for _ = 1, 10 do PlayerClick() task.wait(0.01) end end end end end) end end})
SpecialTab:AddSection({"Script Management"})
SpecialTab:AddButton({Name = "Copy Discord Invite", Callback = function() setclipboard("https://discord.gg/sAUgSnu42T") redzlib:MakeNotify({Name = "Vortex", Text = "Invite copied!", Time = 3}) end})
SpecialTab:AddButton({Name = "Unload Vortex Hub", Callback = function() redzlib:Destroy() end})
SpecialTab:AddSection({"Credits"})
SpecialTab:AddParagraph({"Vortex FX Hub by Syzo Gamer", "Thanks for using! Join our Discord for updates."})

MainFarm:AddDropdown({Name = "Farm Tool", Options = {"Melee", "Sword", "Blox Fruit"}, Default = {"Melee"}, Flag = "Main/FarmTool", Callback = function(Value) getgenv().FarmTool = Value end})
if PlayerLevel.Value >= MaxLavel and Sea3 then MainFarm:AddToggle({Name = "Start Multi Farm  BETA", Callback = function(Value) table.foreach(AFKOptions, function(_,Val) task.spawn(function() Val:Set(Value) end) end) end}) end
MainFarm:AddSection({"Farm"})
MainFarm:AddToggle({Name = "Auto Farm Level", Callback = function(Value) getgenv().AutoFarm_Level = Value; AutoFarm_Level() end})
MainFarm:AddToggle({Name = "Auto Farm Nearest", Callback = function(Value) getgenv().AutoFarmNearest = Value; AutoFarmNearest() end})
if Sea3 then table.insert(AFKOptions, MainFarm:AddToggle({Name = "Auto Pirates Sea", Callback = function(Value) getgenv().AutoPiratesSea = Value; AutoPiratesSea() end})) elseif Sea2 then MainFarm:AddToggle({Name = "Auto Factory", Callback = function(Value) getgenv().AutoFactory = Value; AutoFactory() end}) end
if Sea3 then
    MainFarm:AddSection({"Bone"})
    table.insert(AFKOptions, MainFarm:AddToggle({Name = "Auto Farm Bone", Callback = function(Value) getgenv().AutoFarmBone = Value; AutoFarmBone() end}))
    table.insert(AFKOptions, MainFarm:AddToggle({Name = "Auto Hallow Scythe", Callback = function(Value) getgenv().AutoSoulReaper = Value; AutoSoulReaper() end}))
    table.insert(AFKOptions, MainFarm:AddToggle({Name = "Auto Trade Bone", Callback = function(Value) getgenv().AutoTradeBone = Value; while getgenv().AutoTradeBone do task.wait() FireRemote("Bones", "Buy", 1, 1) end end}))
elseif Sea2 then
    MainFarm:AddSection({"Ectoplasm"})
    MainFarm:AddToggle({Name = "Auto Farm Ectoplasm", Callback = function(Value) getgenv().AutoFarmEctoplasm = Value; AutoFarmEctoplasm() end})
end
MainFarm:AddSection({"Chest"})
MainFarm:AddToggle({Name = "Auto Chest  Tween ", Callback = function(Value) getgenv().AutoChestTween = Value; AutoChestTween() end})
MainFarm:AddToggle({Name = "Auto Chest  Bypass ", Callback = function(Value) getgenv().AutoChestBypass = Value; AutoChestBypass() end})
MainFarm:AddSection({"Bosses"})
MainFarm:AddButton({Name = "Update Boss List", Callback = function() pcall(function() UpdateBossList() end) end})
local BossList = MainFarm:AddDropdown({Name = "Boss List", Callback = function(Value) getgenv().BossSelected = Value end})
function UpdateBossList() local NewOptions = {} for ___,NameBoss in pairs(BossListT) do if VerifyNPC(NameBoss) then table.insert(NewOptions, NameBoss) end end BossList:Set(NewOptions, true) end
UpdateBossList()
MainFarm:AddToggle({Name = "Auto Farm Boss Selected", Callback = function(Value) getgenv().AutoFarmBossSelected = Value; AutoFarmBossSelected() end})
MainFarm:AddToggle({Name = "Auto Farm All Boss", Callback = function(Value) getgenv().KillAllBosses = Value; KillAllBosses() end})
MainFarm:AddToggle({Name = "Take Quest", Default = true, Callback = function(Value) getgenv().TakeQuestBoss = Value end})
MainFarm:AddButton({Name = "Server HOP", Callback = function() ServerHop() end})
MainFarm:AddSection({"Material"})
local MaterialList = {}
if Sea1 then MaterialList = {"Angel Wings", "Leather + Scrap Metal", "Magma Ore", "Fish Tail"} elseif Sea2 then MaterialList = {"Leather + Scrap Metal", "Magma Ore", "Mystic Droplet", "Radiactive Material", "Vampire Fang"} elseif Sea3 then MaterialList = {"Leather + Scrap Metal", "Fish Tail", "Gunpowder", "Mini Tusk", "Conjured Cocoa", "Dragon Scale"} end
MainFarm:AddDropdown({Name = "Material List", Options = MaterialList, Flag = "Material/Selected", Callback = function(Value) getgenv().MaterialSelected = Value end})
MainFarm:AddToggle({Name = "Auto Farm Material", Callback = function(Value) getgenv().AutoFarmMaterial = Value; AutoFarmMaterial() end})
MainFarm:AddSection({"Mastery"})
MainFarm:AddSlider({Name = "Select Health", Min = 10, Max = 100, Default = 25, Callback = function(Value) getgenv().HealthSkill = Value end})
MainFarm:AddDropdown({Name = "Select Tool", Options = {"Blox Fruit"}, Default = {"Blox Fruit"}, Callback = function(Value) getgenv().ToolMastery = Value end})
MainFarm:AddToggle({Name = "Auto Farm Mastery", Callback = function(Value) getgenv().AutoFarmMastery = Value; AutoFarmMastery() end})
MainFarm:AddSection({"Skill"})
MainFarm:AddToggle({Name = "AimBot Skill Enemie", Flag = "Sea/Aimbot", Default = true, Callback = function(Value) getgenv().AimBotSkill = Value end})
MainFarm:AddToggle({Name = "Skill Z", Flag = "Sea/Z", Default = true, Callback = function(Value) getgenv().SkillZ = Value end})
MainFarm:AddToggle({Name = "Skill X", Flag = "Sea/X", Default = true, Callback = function(Value) getgenv().SkillX = Value end})
MainFarm:AddToggle({Name = "Skill C", Flag = "Sea/C", Default = true, Callback = function(Value) getgenv().SkillC = Value end})
MainFarm:AddToggle({Name = "Skill V", Flag = "Sea/V", Default = true, Callback = function(Value) getgenv().SkillV = Value end})
MainFarm:AddToggle({Name = "Skill F", Flag = "Sea/F", Callback = function(Value) getgenv().SkillF = Value end})

FruitAndRaid:AddSection({"Fruits"})
local Fruit_BlackList = {}
FruitAndRaid:AddToggle({ Name = "Auto Store Fruits", Flag = "Fruits/AutoStore", Callback = function(Value) getgenv().AutoStoreFruits = Value task.spawn(function() local Remote = ReplicatedStorage:WaitForChild("Remotes", 9e9):WaitForChild("CommF_", 9e9) while getgenv().AutoStoreFruits do task.wait() local plrBag = Player.Backpack local plrChar = Player.Character if plrChar then for _,Fruit in pairs(plrChar:GetChildren()) do if not table.find(Fruit_BlackList, Fruit.Name) and Fruit:IsA("Tool") and Fruit:FindFirstChild("Fruit") then if Remote:InvokeServer("StoreFruit", Get_Fruit(Fruit.Name), Fruit) ~= true then table.insert(Fruit_BlackList, Fruit.Name) end end end end for _,Fruit in pairs(plrBag:GetChildren()) do if not table.find(Fruit_BlackList, Fruit.Name) and Fruit:IsA("Tool") and Fruit:FindFirstChild("Fruit") then if Remote:InvokeServer("StoreFruit", Get_Fruit(Fruit.Name), Fruit) ~= true then table.insert(Fruit_BlackList, Fruit.Name) end end end end end) end })
table.insert(AFKOptions, FruitAndRaid:AddToggle({ Name = "Teleport to Fruits", Flag = "Fruits/Teleport", Callback = function(Value) getgenv().TeleportToFruit = Value task.spawn(function() while getgenv().TeleportToFruit do task.wait() if Configure("Fruit") then getgenv().TeleportingToFruit = false else local Fruit = FruitFind() if Fruit then PlayerTP(Fruit.CFrame); getgenv().TeleportingToFruit = true else getgenv().TeleportingToFruit = false end end end end) end }))
FruitAndRaid:AddToggle({ Name = "Auto Random Fruit", Flag = "Fruits/AutoRandom", Callback = function(Value) getgenv().AutoRandomFruit = Value task.spawn(function() while getgenv().AutoRandomFruit do task.wait(1) FireRemote("Cousin", "Buy") end end) end })
FruitAndRaid:AddSection({"Raid"})
if Sea1 then FruitAndRaid:AddParagraph({"Only on Sea 2 and 3"})
elseif Sea2 or Sea3 then
    Raids_Chip = {}
    local Raids = require(ReplicatedStorage.Raids)
    table.foreach(Raids.advancedRaids, function(a, b) table.insert(Raids_Chip, b) end)
    table.foreach(Raids.raids, function(a, b) table.insert(Raids_Chip, b) end)
    FruitAndRaid:AddDropdown({ Name = "Select Raid", Options = Raids_Chip, Flag = "Raid/SelectedChip", Callback = function(Value) getgenv().SelectRaidChip = Value end })
    FruitAndRaid:AddToggle({ Name = "Auto Farm Raid", Callback = function(Value) getgenv().AutoFarmRaid = Value; AutoFarmRaid() end })
    FruitAndRaid:AddToggle({"Auto Buy Chip", false, function(Value) getgenv().AutoBuyChip = Value task.spawn(function() while getgenv().AutoBuyChip do task.wait() if not VerifyTool("Special Microchip") then FireRemote("RaidsNpc", "Select", getgenv().SelectRaidChip); task.wait(1) end end end) end})
end

if Sea1 then
    QuestsTabs:AddSection({"Second Sea"})
    QuestsTabs:AddToggle({Name = "Auto Second Sea", Callback = function(Value) getgenv().AutoSecondSea = Value; AutoSecondSea() end})
    QuestsTabs:AddSection({"Saber"})
    QuestsTabs:AddToggle({Name = "Auto Unlock Saber  Level +200 ", Callback = function(Value) getgenv().AutoUnlockSaber = Value; AutoUnlockSaber() end})
    QuestsTabs:AddSection({"God Boss"})
    QuestsTabs:AddToggle({Name = "Auto Pole V1", Callback = function(Value) getgenv().AutoEnelBossPole = Value; AutoEnelBossPole() end})
    QuestsTabs:AddSection({"The Saw"})
    QuestsTabs:AddToggle({Name = "Auto Saw Sword", Callback = function(Value) getgenv().AutoSawBoss = Value; AutoSawBoss() end})
elseif Sea2 then
    QuestsTabs:AddSection({"Third Sea"})
    QuestsTabs:AddToggle({Name = "Auto Third Sea", Callback = function(Value) getgenv().AutoThirdSea = Value; AutoThirdSea() end})
    QuestsTabs:AddToggle({Name = "Auto Kill Don Swan", Callback = function(Value) getgenv().AutoKillDonSwan = Value; AutoKillDonSwan() end})
    QuestsTabs:AddToggle({Name = "Auto Don Swan Hop", Callback = function(Value) getgenv().AutoDonSwanHop = Value end})
    QuestsTabs:AddSection({"Bartilo Quest"})
    QuestsTabs:AddToggle({Name = "Auto Bartilo Quest", Callback = function(Value) getgenv().AutoBartiloQuest = Value; AutoBartiloQuest() end})
    QuestsTabs:AddSection({"Rengoku"})
    QuestsTabs:AddToggle({Name = "Auto Rengoku", Callback = function(Value) getgenv().AutoRengoku = Value; AutoRengoku() end})
    QuestsTabs:AddToggle({Name = "Auto Rengoku Hop", Callback = function(Value) getgenv().AutoRengokuHop = Value end})
    QuestsTabs:AddSection({"Legendary Sword"})
    QuestsTabs:AddToggle({"Auto Buy Legendary Sword", false, function(Value) getgenv().AutoLegendarySword = Value task.spawn(function() while getgenv().AutoLegendarySword do task.wait(0.5) FireRemote("LegendarySwordDealer", "1"); FireRemote("LegendarySwordDealer", "2"); FireRemote("LegendarySwordDealer", "3") end end) end, "Buy/LegendarySword"})
    QuestsTabs:AddToggle({Name = "Auto Buy True Triple Katana", Flag = "Buy/TTK", Callback = function(Value) getgenv().AutoTTK = Value task.spawn(function() while getgenv().AutoTTK do task.wait() FireRemote("MysteriousMan", "1"); FireRemote("MysteriousMan", "2") end end) end})
    QuestsTabs:AddSection({"Race"})
    QuestsTabs:AddToggle({Name = "Auto Evo Race V2", Callback = function(Value) getgenv().AutoRaceV2 = Value; AutoRaceV2() end})
    QuestsTabs:AddSection({"Cursed Captain"})
    QuestsTabs:AddToggle({Name = "Auto Cursed Captain", Callback = function(Value) getgenv().AutoCursedCaptain = Value; AutoCursedCaptain() end})
    QuestsTabs:AddSection({"Dark Beard"})
    QuestsTabs:AddToggle({Name = "Auto Dark Beard", Callback = function(Value) getgenv().AutoDarkbeard = Value; AutoDarkbeard() end})
    QuestsTabs:AddSection({"Law"})
    QuestsTabs:AddToggle({Name = "Auto Buy Law Chip", Callback = function(Value) getgenv().AutoBuyLawChip = Value task.spawn(function() while getgenv().AutoBuyLawChip do task.wait() if not VerifyNPC("Order") and not VerifyTool("Microchip") then FireRemote("BlackbeardReward", "Microchip", "2") end end end) end})
    QuestsTabs:AddToggle({Name = "Auto Start Law Raid", Callback = function(Value) getgenv().AutoStartLawRaid = Value task.spawn(function() while getgenv().AutoStartLawRaid do task.wait() if not VerifyNPC("Order") and VerifyTool("Microchip") then pcall(function() fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector) end) end end end) end})
    QuestsTabs:AddToggle({Name = "Auto Kill Law Boss", Callback = function(Value) getgenv().AutoKillLawBoss = Value; AutoKillLawBoss() end})
elseif Sea3 then
    QuestsTabs:AddSection({"Elite Hunter"})
    local LabelElite = QuestsTabs:AddParagraph({"Elite Stats : not Spawn"})
    local LabelElit3 = QuestsTabs:AddParagraph({"Elite Hunter progress : 0"})
    task.spawn(function() while task.wait() do if VerifyNPC("Urban") or VerifyNPC("Deandre") or VerifyNPC("Diablo") then LabelElite:SetTitle("Elite Stats : Spawned") else LabelElite:SetTitle("Elite Stats : not Spawn") end end end)
    task.spawn(function() while task.wait(1) do LabelElit3:SetTitle("Elite Hunter progress : " .. FireRemote("EliteHunter", "Progress")) end end)
    table.insert(AFKOptions, QuestsTabs:AddToggle({Name = "Auto Elite Hunter", Callback = function(Value) getgenv().AutoEliteHunter = Value; AutoEliteHunter() end}))
    table.insert(AFKOptions, QuestsTabs:AddToggle({Name = "Auto Collect Yama  Need 30 ", Flag = "Collect/Yama", Callback = function(Value) getgenv().AutoCollectYama = Value task.spawn(function() while getgenv().AutoCollectYama do task.wait() pcall(function() if FireRemote("EliteHunter", "Progress") >= 30 then fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector) end end) end end) end}))
    QuestsTabs:AddToggle({Name = "Auto Elite Hunter Hop", Callback = function(Value) getgenv().AutoEliteHunterHop = Value end})
    QuestsTabs:AddSection({"Tushita"})
    local LabelRipIndra = QuestsTabs:AddParagraph({"Rip Indra Stats : not Spawn"})
    task.spawn(function() while task.wait(0.5) do if VerifyNPC("rip_indra True Form") then LabelRipIndra:SetTitle("Rip Indra Stats : Spawned") else LabelRipIndra:SetTitle("Rip Indra Stats : not Spawn") end end end)
    QuestsTabs:AddToggle({Name = "Auto Tushita", Callback = function(Value) getgenv().AutoTushita = Value task.spawn(function() local Map = workspace:WaitForChild("Map", 9e9) local Turtle = Map:WaitForChild("Turtle", 9e9) local QuestTorches = Turtle:WaitForChild("QuestTorches", 9e9) local Active1, Active2, Active3, Active4, Active5 = false, false, false, false, false while getgenv().AutoTushita do task.wait() if not Turtle:FindFirstChild("TushitaGate") then local Enemie = Enemies:FindFirstChild("Longma") if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos) pcall(function() PlayerClick(); ActiveHaki(); EquipTool() end) else PlayerTP(CFrame.new(-10218, 333, -9444)) end elseif VerifyNPC("rip_indra True Form") then if not VerifyTool("Holy Torch") then PlayerTP(CFrame.new(5152, 142, 912)) else local Torch1 = QuestTorches:FindFirstChild("Torch1") local Torch2 = QuestTorches:FindFirstChild("Torch2") local Torch3 = QuestTorches:FindFirstChild("Torch3") local Torch4 = QuestTorches:FindFirstChild("Torch4") local Torch5 = QuestTorches:FindFirstChild("Torch5") local args1 = Torch1 and Torch1:FindFirstChild("Particles") and Torch1.Particles:FindFirstChild("PointLight") and not Torch1.Particles.PointLight.Enabled local args2 = Torch2 and Torch2:FindFirstChild("Particles") and Torch2.Particles:FindFirstChild("PointLight") and not Torch2.Particles.PointLight.Enabled local args3 = Torch3 and Torch3:FindFirstChild("Particles") and Torch3.Particles:FindFirstChild("PointLight") and not Torch3.Particles.PointLight.Enabled local args4 = Torch4 and Torch4:FindFirstChild("Particles") and Torch4.Particles:FindFirstChild("PointLight") and not Torch4.Particles.PointLight.Enabled local args5 = Torch5 and Torch5:FindFirstChild("Particles") and Torch5.Particles:FindFirstChild("PointLight") and not Torch5.Particles.PointLight.Enabled if not Active1 and args1 then PlayerTP(Torch1.CFrame) elseif not Active2 and args2 then PlayerTP(Torch2.CFrame); Active1 = true elseif not Active3 and args3 then PlayerTP(Torch3.CFrame); Active2 = true elseif not Active4 and args4 then PlayerTP(Torch4.CFrame); Active3 = true elseif not Active5 and args5 then PlayerTP(Torch5.CFrame); Active4 = true else Active5 = true end end else if VerifyTool("God's Chalice") then EquipToolName("God's Chalice"); PlayerTP(CFrame.new(-5561, 314, -2663)) else local NPC = "EliteBossVerify"; QuestVisible() if VerifyQuest("Diablo") then NPC = "Diablo" elseif VerifyQuest("Deandre") then NPC = "Deandre" elseif VerifyQuest("Urban") then NPC = "Urban" else task.spawn(function() FireRemote("EliteHunter") end) end local EliteBoss = GetEnemies({NPC}) if EliteBoss and EliteBoss:FindFirstChild("HumanoidRootPart") then PlayerTP(EliteBoss.HumanoidRootPart.CFrame + getgenv().FarmPos) pcall(function() PlayerClick(); ActiveHaki(); EquipTool() end) elseif not VerifyNPC("Deandre") and not VerifyNPC("Diablo") and not VerifyNPC("Urban") then if getgenv().AutoTushitaHop then ServerHop() end end end end end end) end})
    QuestsTabs:AddToggle({Name = "Auto Tushita Hop", Callback = function(Value) getgenv().AutoTushitaHop = Value end})
    QuestsTabs:AddSection({"Cake Prince + Dough King"})
    local CakeLabel = QuestsTabs:AddParagraph({"Stats : 0"})
    task.spawn(function() while task.wait(1) do if VerifyNPC("Dough King") then CakeLabel:SetTitle("Stats : Spawned | Dough King") elseif VerifyNPC("Cake Prince") then CakeLabel:SetTitle("Stats : Spawned | Cake Prince") else local EnemiesCake = FireRemote("CakePrinceSpawner", true) CakeLabel:SetTitle("Stats : " .. string.gsub(tostring(EnemiesCake), "%D", "")) end end end)
    local CakePrinceToggle = QuestsTabs:AddToggle({"Auto Cake Prince", false, function(Value) getgenv().AutoCakePrince = Value; AutoCakePrince() end})
    local DoughKingToggle = QuestsTabs:AddToggle({"Auto Dough King", false, function(Value) getgenv().AutoDoughKing = Value; AutoDoughKing() end})
    CakePrinceToggle:Callback(function() DoughKingToggle:Set(false) end)
    DoughKingToggle:Callback(function() CakePrinceToggle:Set(false) end)
    QuestsTabs:AddSection({"Rip Indra"})
    local ActiveButtonToggle = QuestsTabs:AddToggle({"Auto Active Button Haki Color", false, function(Value) getgenv().RipIndraLegendaryHaki = Value task.spawn(function() while getgenv().RipIndraLegendaryHaki do task.wait() local plrChar = Player and Player.Character and Player.Character.PrimaryPart if (plrChar.Position - Vector3.new(-5415, 314, -2212)).Magnitude < 5 then FireRemote("activateColor", "Pure Red") elseif (plrChar.Position - Vector3.new(-4972, 336, -3720)).Magnitude < 5 then FireRemote("activateColor", "Snow White") elseif (plrChar.Position - Vector3.new(-5420, 1089, -2667)).Magnitude < 5 then FireRemote("activateColor", "Winter Sky") end end end) task.spawn(function() while getgenv().RipIndraLegendaryHaki do task.wait() if not getgenv().AutoFarm_Level and not getgenv().AutoFarmBone and not getgenv().AutoCakePrince then if GetButton() then PlayerTP(GetButton().CFrame) elseif not GetButton() and not getgenv().AutoRipIndra then PlayerTP(CFrame.new(-5119, 315, -2964)) end end end end) end})
    local RipIndraToggle = QuestsTabs:AddToggle({"Auto Rip Indra", false, function(Value) getgenv().AutoRipIndra = Value; AutoRipIndra() end})
    RipIndraToggle:Callback(function() ActiveButtonToggle:Set(false) end)
    ActiveButtonToggle:Callback(function() RipIndraToggle:Set(false) end)
    QuestsTabs:AddSection({"Musketeer Hat"})
    QuestsTabs:AddToggle({Name = "Auto Musketeer Hat", Callback = function(Value) getgenv().AutoMusketeerHat = Value; AutoMusketeerHat() end})
    QuestsTabs:AddButton({Name = "Server HOP", Callback = function() ServerHop() end})
end

if Sea2 or Sea3 then
    QuestsTabs:AddSection({"Fighting Style"})
    QuestsTabs:AddToggle({Name = "Auto Death Step", Callback = function(Value)
        getgenv().AutoDeathStep = Value
        task.spawn(function()
            local MasteryBlackLeg = 0; local KeyFind = false
            local function GetProxyNPC()
                local Distance = math.huge; local NPC = nil
                local plrChar = Player and Player.Character and Player.Character.PrimaryPart
                for _,npc in pairs(Enemies:GetChildren()) do
                    if npc.Name == "Reborn Skeleton" or npc.Name == "Living Zombie" or npc.Name == "Demonic Soul" or npc.Name == "Posessed Mummy" or npc.Name == "Water Fighter" then
                        if plrChar and npc and npc:FindFirstChild("HumanoidRootPart") and (plrChar.Position - npc.HumanoidRootPart.Position).Magnitude <= Distance then
                            Distance = (plrChar.Position - npc.HumanoidRootPart.Position).Magnitude; NPC = npc
                        end
                    end
                end
                return NPC
            end
            while getgenv().AutoDeathStep do task.wait()
                if VerifyTool("Black Leg") then MasteryBlackLeg = GetToolLevel("Black Leg") end
                if MasteryBlackLeg >= 400 and Sea3 then FireRemote("TravelDressrosa") end
                if KeyFind then FireRemote("BuyDeathStep") end
                if VerifyTool("Death Step") then EquipToolName("Death Step")
                elseif MasteryBlackLeg >= 400 then
                    local Enemie = Enemies:FindFirstChild("Awakened Ice Admiral")
                    if VerifyTool("Library Key") then KeyFind = true; EquipToolName("Library Key"); PlayerTP(CFrame.new(6373, 293, -6839))
                    elseif Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); EquipTool() end)
                    else PlayerTP(CFrame.new(6473, 297, -6944)) end
                elseif not VerifyTool("Black Leg") and MasteryBlackLeg < 400 then FireRemote("BuyBlackLeg")
                elseif VerifyTool("Black Leg") and MasteryBlackLeg < 400 then
                    EquipToolName("Black Leg")
                    local Enemie = GetProxyNPC()
                    if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); BringNPC(Enemie) end)
                    else
                        if Sea3 then PlayerTP(CFrame.new(-9513, 164, 5786)) else PlayerTP(CFrame.new(-3350, 282, -10527)) end
                    end
                end
            end
        end)
    end})
    QuestsTabs:AddToggle({Name = "Auto Electric Claw ", Callback = function(Value)
        getgenv().AutoElectricClaw = Value
        task.spawn(function()
            local MasteryElectro = 0; local MasteryElectricClaw = 0
            local function GetProxyNPC()
                local Distance = math.huge; local NPC = nil
                local plrChar = Player and Player.Character and Player.Character.PrimaryPart
                for _,npc in pairs(Enemies:GetChildren()) do
                    if npc.Name == "Reborn Skeleton" or npc.Name == "Living Zombie" or npc.Name == "Demonic Soul" or npc.Name == "Posessed Mummy" or npc.Name == "Water Fighter" then
                        if plrChar and npc and npc:FindFirstChild("HumanoidRootPart") and (plrChar.Position - npc.HumanoidRootPart.Position).Magnitude <= Distance then
                            Distance = (plrChar.Position - npc.HumanoidRootPart.Position).Magnitude; NPC = npc
                        end
                    end
                end
                return NPC
            end
            while getgenv().AutoElectricClaw do task.wait()
                if VerifyTool("Electro") then MasteryElectro = GetToolLevel("Electro")
                elseif VerifyTool("Electric Claw") then MasteryElectricClaw = GetToolLevel("Electric Claw") end
                if MasteryElectro < 400 then
                    if not VerifyTool("Electro") then FireRemote("BuyElectro") else EquipToolName("Electro") end
                elseif MasteryElectricClaw < 600 then
                    if not VerifyTool("Electric Claw") then FireRemote("BuyElectricClaw") else EquipToolName("Electric Claw") end
                end
                local Enemie = GetProxyNPC()
                if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                    PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); BringNPC(Enemie) end)
                else
                    if Sea3 then PlayerTP(CFrame.new(-9513, 164, 5786)) else PlayerTP(CFrame.new(-3350, 282, -10527)) end
                end
            end
        end)
    end})
    QuestsTabs:AddToggle({Name = "Auto Sharkman Karate", Callback = function(Value)
        getgenv().AutoSharkmanKarate = Value
        task.spawn(function()
            local MasteryFishmanKarate = 0; local MasterySharkmanKarate = 0; local SharkmanStats = 0
            task.spawn(function() while getgenv().AutoSharkmanKarate do task.wait() SharkmanStats = FireRemote("BuySharkmanKarate", true) end end)
            while getgenv().AutoSharkmanKarate do task.wait()
                if VerifyTool("Fishman Karate") then MasteryFishmanKarate = GetToolLevel("Fishman Karate")
                elseif VerifyTool("Sharkman Karate") then MasterySharkmanKarate = GetToolLevel("Sharkman Karate") end
                if SharkmanStats == 1 then FireRemote("BuySharkmanKarate")
                elseif VerifyTool("Sharkman Karate") then
                    EquipToolName("Sharkman Karate")
                    local Enemie = Enemies:FindFirstChild("Water Fighter")
                    if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); BringNPC(Enemie, true) end)
                    else TweenNPCSpawn({CFrame.new(-3339, 290, -10412), CFrame.new(-3518, 290, -10419), CFrame.new(-3536, 290, -10607), CFrame.new(-3345, 280, -10667)}, "Water Fighter") end
                elseif VerifyTool("Water Key") and MasteryFishmanKarate >= 400 then FireRemote("BuySharkmanKarate", true)
                elseif not VerifyTool("Water Key") and MasteryFishmanKarate >= 400 then
                    local Enemie = Enemies:FindFirstChild("Water Fighter")
                    if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); EquipTool(); BringNPC(Enemie, true) end)
                    else TweenNPCSpawn({CFrame.new(-3339, 290, -10412), CFrame.new(-3518, 290, -10419), CFrame.new(-3536, 290, -10607), CFrame.new(-3345, 280, -10667)}, "Water Fighter") end
                elseif not VerifyTool("Fishman Karate") and MasteryFishmanKarate < 400 then FireRemote("BuyFishmanKarate")
                elseif VerifyTool("Fishman Karate") and MasteryFishmanKarate < 400 then
                    EquipToolName("Fishman Karate")
                    local Enemie = Enemies:FindFirstChild("Water Fighter")
                    if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos); pcall(function() PlayerClick(); ActiveHaki(); BringNPC(Enemie, true) end)
                    else TweenNPCSpawn({CFrame.new(-3339, 290, -10412), CFrame.new(-3518, 290, -10419), CFrame.new(-3536, 290, -10607), CFrame.new(-3345, 280, -10667)}, "Water Fighter") end
                end
            end
        end)
    end})
    QuestsTabs:AddToggle({Name = "Auto Dragon Talon", Callback = function(Value)
        getgenv().AutoDragonTalon = Value
        task.spawn(function()
            local MasteryDragonClaw = 0; local FireEssence