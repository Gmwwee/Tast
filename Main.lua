local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Rep = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local GS = game:GetService("GuiService")
local RS = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local UserSettings = UserSettings()
local GameSettings = UserSettings:GetService("UserGameSettings")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local plr = Players.LocalPlayer
local RS = ReplicatedStorage
local VIM = VirtualInputManager
local GS = GuiService

_G.AutoFish = false
_G.UltraSpeed = true


local BossFolder = Workspace.Main.Characters["Throne Isle"].Boss

_G.AutoFarmBoss = false
_G.SelectedBoss = nil

local Config = {
    BossOffset = Vector3.new(0, 0, 3)
}

-- ==============================
--  Teleport Function
-- ==============================
local function TP(cf)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = cf
    end
end


-- ==============================
--  Ultra Click (แทน Fire())
-- ==============================
local function ultraClick(obj, times)
    if not obj or not obj.Visible then return end
    GS.SelectedCoreObject = obj

    for i = 1, (times or 10) do
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait()
    end
end


-- ==============================
--  Spawn Boss Function
-- ==============================
local function SpawnBoss(name)
    local frame = Player.PlayerGui.Button["Boss Spawn"].Frame

    if name == "Sukuna" then
        ultraClick(frame.Sukuna.Button, 2)
    elseif name == "Gojo" then
        ultraClick(frame.Gojo.Button, 2)
    elseif name == "Akaza" then
        ultraClick(frame.Akaza.Button, 2)
    elseif name == "David" then
        ultraClick(frame.David.Button, 2)
    end

    task.wait(0.1)

    -- ปุ่ม Spawn
    ultraClick(frame.Parent.Spawn.Button, 3)
end


-- ==============================
--  Auto Farm Boss Loop
-- ==============================
task.spawn(function()
    while task.wait() do
        if not _G.AutoFarmBoss or not _G.SelectedBoss then
            continue
        end

        -- 1) วาร์ปไปจุดเสกบอส
        TP(CFrame.new(457, 3, -631))
        task.wait(0.5)

        -- 2) เสกบอส
        SpawnBoss(_G.SelectedBoss)
        task.wait(1)

        -- 3) รอให้บอสเกิด
        local boss
        repeat
            task.wait()
            boss = BossFolder:FindFirstChildWhichIsA("Model")
        until boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid")

        local hrp = boss.HumanoidRootPart
        local hum = boss.Humanoid

        -- 4) ตีบอสจนตาย
        while hum.Health > 0 and _G.AutoFarmBoss do
            TP(hrp.CFrame * CFrame.new(Config.BossOffset))
            getgenv().FastAttack = true
            task.wait()
        end

        getgenv().FastAttack = false
        task.wait(0.5)
        -- 5) วนกลับไปเริ่มใหม่
    end
end)

----------------------------------------------------------------
-- SPAM REMOTE OBSERVATION
----------------------------------------------------------------

_G.SpamRemote = false

local ObservationArgs = {
    "Server",
    "Misc",
    "Observation",
    1
}

task.spawn(function()
    while task.wait() do
        if _G.SpamRemote then
            pcall(function()
                Rep.Remotes.Serverside:FireServer(unpack(ObservationArgs))
            end)
        end
    end
end)

----------------------------------------------------------------
-- AUTO ATTACK SYSTEM
----------------------------------------------------------------

_G.AutoAttack = false
_G.AttackType = nil
_G.SelectedWeapon = nil
_G.AutoEquipWeapon = true

local function GetWeapons()
    local tools = {}

    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool.Name)
        end
    end

    if Player.Character then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            table.insert(tools, tool.Name)
        end
    end

    return tools
end

local function AutoEquipSelectedWeapon()
    if not _G.SelectedWeapon then return end
    if not _G.AutoEquipWeapon then return end

    local char = Player.Character
    if not char then return end

    -- ถ้ามีอาวุธในมืออยู่แล้ว และตรงกับที่เลือก → ไม่ต้องทำอะไร
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.Name == _G.SelectedWeapon then
        return
    end

    -- หาอาวุธใน Backpack
    local backpackTool = Player.Backpack:FindFirstChild(_G.SelectedWeapon)
    if backpackTool then
        backpackTool.Parent = char -- equip
    end
end
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            AutoEquipSelectedWeapon()
        end)
    end
end)




-- ลูปยิงรีโมตโจมตี
task.spawn(function()
    while task.wait() do
        if _G.AutoAttack and _G.SelectedWeapon then
            local args = {
                "Server",
                _G.AttackType,   -- Sword / Melee / Power / Fruit
                "M1s",
                _G.SelectedWeapon, -- ชื่อดาบจากกระเป๋า
                4
            }

            pcall(function()
                Rep.Remotes.Serverside:FireServer(unpack(args))
            end)
        end
    end
end)

-----------------------------------------------------



--------------------------------------------------------------------------------------------------------

local _G = _G or {}
_G.AutoAnos = false

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ฟังก์ชันดึงบอส Anos แบบตรง path
local function GetAnosBoss()
    local Main = Workspace:FindFirstChild("Main")
    if not Main then return nil end

    local Characters = Main:FindFirstChild("Characters")
    if not Characters then return nil end

    local Abyss = Characters:FindFirstChild("Abyss Hill [Upper]")
    if not Abyss then return nil end

    local BossFolder = Abyss:FindFirstChild("Boss")
    if not BossFolder then return nil end

    local Anos = BossFolder:FindFirstChild("Anos")
    if Anos and Anos:IsA("Model") then
        return Anos
    end

    return nil
end

-- TP ตัวผู้เล่น
local function TP(cf)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cf
    end
end

-- Loop Auto Anos
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoAnos then
            local boss = GetAnosBoss()
            if boss 
            and boss:FindFirstChild("Humanoid")
            and boss:FindFirstChild("HumanoidRootPart") then

                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    repeat
                        if not _G.AutoAnos then break end
                        if not boss.Parent then break end

                        TP(boss.HumanoidRootPart.CFrame * CFrame.new(Config.BossOffset))
                        task.wait(0.1)
                    until humanoid.Health <= 0
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------------------

local function GetBossFolders()
    local folders = {}

    local Main = Workspace:FindFirstChild("Main")
    if not Main then return folders end

    local Characters = Main:FindFirstChild("Characters")
    if not Characters then return folders end

    local list = {
        "Rogue Town",
        "Rogue Town [Backside]"
    }

    for _, name in ipairs(list) do
        local area = Characters:FindFirstChild(name)
        if area then
            local bossFolder = area:FindFirstChild("Boss")
            if bossFolder then
                table.insert(folders, bossFolder)
            end
        end
    end

    return folders
end

local function TP(cf)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cf
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoAllBoss then
            for _, bossFolder in ipairs(GetBossFolders()) do
                for _, boss in ipairs(bossFolder:GetChildren()) do
                    if not _G.AutoAllBoss then break end

                    if boss:IsA("Model")
                    and boss:FindFirstChild("Humanoid")
                    and boss:FindFirstChild("HumanoidRootPart") then

                        local hum = boss.Humanoid
                        if hum.Health > 0 then
                            repeat
                                if not _G.AutoAllBoss then break end
                                if not boss.Parent then break end

                                TP(boss.HumanoidRootPart.CFrame * CFrame.new(Config.BossOffset))
                                task.wait(0.1)
                            until hum.Health <= 0
                        end
                    end
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------
--- AttackGod
local function GetAllTools()
    local tools = {}

    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool.Name)
        end
    end

    if Player.Character then
        for _, tool in pairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool.Name)
            end
        end
    end

    return tools
end

local function EquipTool(toolName)
    if not Player.Character then return end

    local tool = Player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = Player.Character
    end
end

local AttackTypes = {
    "Sword",
    "Combat",
    "Power",
    "Fruit"
}

task.spawn(function()
    while task.wait() do
        if _G.AutoAttackGod then
            local tools = GetAllTools()

            for _, toolName in ipairs(tools) do
                if not _G.AutoAttackGod then break end

                -- สวม Tool
                EquipTool(toolName)

                for _, attackType in ipairs(AttackTypes) do
                    if not _G.AutoAttackGod then break end

                    local args = {
                        "Server",
                        attackType,
                        "M1s",
                        toolName,
                        4
                    }

                    pcall(function()
                        Rep.Remotes.Serverside:FireServer(unpack(args))
                    end)
                end
            end
        end
    end
end)


--------------------------------------------------------------------------------------------------------

-- ==============================
--  UI SYSTEM
-- ==============================
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Gmwwee/Tast/refs/heads/main/Anity.luau.txt"
))()

local MainWindow = Library:Window({
    Title = "Aetherion",
    Desc = "Freemium | by Aet",
    Icon = 86016994073368,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400),
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Hub",
    },
})

local GeneralTab = MainWindow:Tab({
    Title = "General",
    Icon = "house",
})

GeneralTab:Section({
    Title = "Boss",
})

GeneralTab:Dropdown({
    Title = "Select Boss",
    List = {"Sukuna", "Gojo", "Akaza", "David"},
    Value = "Sukuna",
    Callback = function(boss)
        _G.SelectedBoss = boss
    end,
})

GeneralTab:Toggle({
    Title = "Auto Farm Boss",
    Desc = "",
    Value = false,
    Callback = function(v)
        _G.AutoFarmBoss = v
   end,
})


-----------------------------------------------------
-- UI : ROGUE TOWN BOSS
-----------------------------------------------------

GeneralTab:Section({
    Title = "Event Boss",
})

local AnosToggle

AnosToggle = GeneralTab:Toggle({
    Title = "Auto Anos",
    Desc = "⏳ กำลังตรวจสอบบอส Anos...",
    Value = false,
    Callback = function(value)
        _G.AutoAnos = value
    end,
})

local function GetAnosStatus()
    local boss = GetAnosBoss()
    if not boss then
        return "❌ Anos ยังไม่เกิด"
    end

    local hum = boss:FindFirstChild("Humanoid")
    if not hum then
        return "⚠️ Anos ผิดปกติ"
    end

    if hum.Health <= 0 then
        return "☠️ Anos ตายแล้ว"
    end

    return "✅ Anos เกิดแล้ว"
end


task.spawn(function()
    while task.wait(1) do
        if AnosToggle and AnosToggle.SetDesc then
            AnosToggle:SetDesc(GetAnosStatus())
        end
    end
end)

local _G = _G or {}
_G.AutoAllBoss = false

GeneralTab:Toggle({
    Title = "Auto All Boss (Rogue Town)",
    Desc = "Auto farm all bosses",
    Value = false,
    Callback = function(v)
        _G.AutoAllBoss = v
    end,
})


------------------------------------------------------------------------------

GeneralTab:Section({
    Title = "Auto Skills",
})

-- ===============================
-- AUTO SKILL KEYBOARD (SEPARATE)
-- ===============================

local _G = _G or {}

_G.AutoZ = false
_G.AutoX = false
_G.AutoC = false
_G.AutoV = false
_G.AutoF = false

local VirtualInputManager = game:GetService("VirtualInputManager")

-- กดปุ่ม
local function PressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- Loop เดียว คุมทุกปุ่ม
task.spawn(function()
    while task.wait(0.25) do
        if _G.AutoZ then PressKey(Enum.KeyCode.Z) end
        if _G.AutoX then PressKey(Enum.KeyCode.X) end
        if _G.AutoC then PressKey(Enum.KeyCode.C) end
        if _G.AutoV then PressKey(Enum.KeyCode.V) end
        if _G.AutoF then PressKey(Enum.KeyCode.F) end
    end
end)


GeneralTab:Toggle({
    Title = "Auto Skill Z",
    Desc = "Auto press Z",
    Value = false,
    Callback = function(v)
        _G.AutoZ = v
    end,
})

GeneralTab:Toggle({
    Title = "Auto Skill X",
    Desc = "Auto press X",
    Value = false,
    Callback = function(v)
        _G.AutoX = v
    end,
})

GeneralTab:Toggle({
    Title = "Auto Skill C",
    Desc = "Auto press C",
    Value = false,
    Callback = function(v)
        _G.AutoC = v
    end,
})

GeneralTab:Toggle({
    Title = "Auto Skill V",
    Desc = "Auto press V",
    Value = false,
    Callback = function(v)
        _G.AutoV = v
    end,
})

GeneralTab:Toggle({
    Title = "Auto Skill F",
    Desc = "Auto press F",
    Value = false,
    Callback = function(v)
        _G.AutoF = v
    end,
})


--------------------------------------------------------------------------------------------------------
local Sea = MainWindow:Tab({
    Title = "Sea",
    Icon = "fish",
})

Sea:Section({
    Title = "Fishing",
})

Sea:Toggle({
    Title = "Auto Fish",
    Desc = "Auto cast fishing every 20 seconds",
    Value = false,
    Callback = function(v)
        _G.AutoFish = v
    end,
})


-- กดปุ่มตกปลาเร็ว
local function ultraClick(obj, times)
    if not obj or not obj.Visible then return end

    pcall(function()
        GS.SelectedCoreObject = obj
    end)

    for i = 1, (times or 25) do
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait()
    end
end

-- LOOP หลัก
task.spawn(function()
    while true do
        if _G.AutoFish and _G.UltraSpeed then

            -- ยิงรีโมทตกปลา 1 ครั้ง
            pcall(function()
                RS:WaitForChild("Remotes")
                    :WaitForChild("Serverside")
                    :FireServer("Server", "Misc", "Fishing", true)
            end)

            -- หา UI ตกปลา
            local gui = plr.PlayerGui:FindFirstChild("HUD")
            local fishingUI = gui and gui:FindFirstChild("Fishing")

            if fishingUI then
                local btn = fishingUI:FindFirstChild("Button")
                if btn and btn.Visible then
                    ultraClick(btn, 30)
                end
            end

            -- รอ 20 วิ ก่อนรอบถัดไป
            for i = 1, 20 do
                if not _G.AutoFish then break end
                task.wait(1)
            end
        else
            task.wait(20)
        end
    end
end)


Sea:Button({
    Title = "Sell Fish",
    Desc = "Warp & sell all fish",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- วาร์ปไปจุดขายปลา
        hrp.CFrame = CFrame.new(-64.53, 12.27, -1339.62)

        task.wait(0.4)

        -- ProximityPrompt ขายปลา (ตรงตัว)
        local prompt = Workspace
            :WaitForChild("Main")
            :WaitForChild("NPCs")
            :WaitForChild("Sell Fish")
            :WaitForChild("{}")

        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0

            fireproximityprompt(prompt, 1)
        else
            warn("❌ ตัวที่เจอไม่ใช่ ProximityPrompt")
        end
    end,
})

-------------------------------------------------------------------------------------------------------

local Shops = MainWindow:Tab({
    Title = "Shops",
    Icon = "shopping-cart",
})

Shops:Button({
    Title = "Buy Fishing Rod",
    Desc = "Warp & buy Fishing Rod",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- วาร์ปไปที่ร้าน
        hrp.CFrame = CFrame.new(-148.36, 1.39, -240.05)

        task.wait(0.4)

        -- ProximityPrompt (ตรงตัว)
        local prompt = Workspace
            :WaitForChild("Main")
            :WaitForChild("NPCs")
            :WaitForChild("Fishing Rod")
            :WaitForChild("{}")

        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt, 1)
        else
            warn("❌ ตัวที่เจอไม่ใช่ ProximityPrompt")
        end
    end,
})

Shops:Button({
    Title = "Buy Observation",
    Desc = "Warp & buy Observation",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- วาร์ปไปที่ร้าน
        hrp.CFrame = CFrame.new(-611.26, 0.16, -277.02)

        task.wait(0.4)

        -- ProximityPrompt (ตรงตัว)
        local prompt = Workspace
            :WaitForChild("Main")
            :WaitForChild("NPCs")
            :WaitForChild("Observation Trainer")
            :WaitForChild("{}")

        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt, 1)
        else
            warn("❌ ตัวที่เจอไม่ใช่ ProximityPrompt")
        end
    end,
})


Shops:Button({
    Title = "Buy Haki",
    Desc = "Warp & buy Haki",
    Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- วาร์ปไปที่ร้าน
        hrp.CFrame = CFrame.new(21.87, -0.75, 127.10)

        task.wait(0.4)

        -- ProximityPrompt (ตรงตัว)
        local prompt = Workspace
            :WaitForChild("Main")
            :WaitForChild("NPCs")
            :WaitForChild("Haki Trainer")
            :WaitForChild("{}")

        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt, 1)
        else
            warn("❌ ตัวที่เจอไม่ใช่ ProximityPrompt")
        end
    end,
})


--------------------------------------------------------------------------------------------------------
local SettingTab = MainWindow:Tab({
    Title = "Settings",
    Icon = "settings",
})

SettingTab:Section({
    Title = "Setting Farm",
})

SettingTab:Dropdown({
    Title = "Attack Type",
    List = {"Sword", "Combat", "Power", "Fruit"},
    Value = "Sword",

    Callback = function(v)
        _G.AttackType = v
    end,
})

SettingTab:Dropdown({
    Title = "Select Weapon",
    List = GetWeapons(),
    Value = nil,

    Callback = function(v)
        _G.SelectedWeapon = v
    end,
})

SettingTab:Toggle({
    Title = "Auto Attack",
    Desc = "",
    Value = false,

    Callback = function(v)
        _G.AutoAttack = v
    end,
})

local _G = _G or {}
_G.AutoAttackGod = false

SettingTab:Toggle({
    Title = "Auto Attack (GOD)",
    Desc = "",
    Value = false,
    Callback = function(v)
        _G.AutoAttackGod = v
    end,
})



SettingTab:Toggle({
    Title = "Spam Observation",
    Desc = "",
    Value = false,
    Callback = function(v)
        _G.SpamRemote = v
    end,
})

SettingTab:Section({
    Title = "Player",
})

