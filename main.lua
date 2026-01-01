-- ELYSIUM HUB | V32 UNIVERSAL INTERACTION FIX
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V32_Fix"
gui.ResetOnSpawn = false

-- ================= REAL DATA =================
local SeedList = {
    "Carrot", "Strawberry", "Blueberry", "Buttercup", "Tomato", "Corn",
    "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut",
    "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper",
    "Cacao", "Sunflower", "Beanstalk", "Ember Lily", "Sugar Apple",
    "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco",
    "Crimson Thorn", "Zebrazinkle", "Octobloom", "Firework Fern"
}

-- ================= FLAGS =================
local Flags = {
    AutoFarmPrompt = false, -- Metode Baru (Tekan E Otomatis)
    AutoBuySeeds = false,
    SelectedSeed = SeedList[1],
    WalkSpeed = 16,
    InfJump = false,
    TeleportFarm = false,
    LowGfx = false
}

-- ================= UI BUILDER (SAMA SEPERTI SEBELUMNYA) =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 68, 68)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB V32 (UNIVERSAL FIX)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 18

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0, 0, 0, 45); scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- Fungsi Helper UI
local function createBtn(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function createToggle(text, flag)
    local b = createBtn(text .. ": OFF", function() end)
    b.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        b.Text = text .. (Flags[flag] and ": ON" or ": OFF")
        b.BackgroundColor3 = Flags[flag] and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 50)
    end)
end

-- ================= MENU =================
createToggle("AUTO FARM (PROMPT SPAM)", "AutoFarmPrompt")
createToggle("TELEPORT TO PROMPTS", "TeleportFarm")
createToggle("AUTO BUY SEEDS (BRUTAL)", "AutoBuySeeds")

-- Dropdown Seed Manual (Klik untuk ganti urutan)
local seedBtn = createBtn("Selected Seed: "..Flags.SelectedSeed, function()
    -- Simple cycle
    for i, v in ipairs(SeedList) do
        if v == Flags.SelectedSeed then
            Flags.SelectedSeed = SeedList[i+1] or SeedList[1]
            break
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do seedBtn.Text = "Selected Seed: " .. Flags.SelectedSeed end
end)

createToggle("Low GFX (Boost FPS)", "LowGfx")
createToggle("Infinity Jump", "InfJump")

-- Tombol Debug (PENTING: Cek Console F9 setelah klik ini)
createBtn("DEBUG: PRINT WORKSPACE FOLDERS", function()
    print("----- DEBUG START -----")
    for _, v in pairs(Workspace:GetChildren()) do
        print("Objek di Workspace: " .. v.Name .. " (" .. v.ClassName .. ")")
    end
    print("----- DEBUG END -----")
end)

-- ================= LOGIKA UNIVERSAL (THE FIX) =================

-- 1. AUTO FARM: PROXIMITY PROMPT
-- Metode ini mengabaikan nama Remote. Dia mencari tombol "E" di game dan menekannya secara paksa.
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() -- Loop Ultra Cepat
        if Flags.AutoFarmPrompt then
            pcall(function()
                -- Cari semua Prompt di Workspace
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        -- Cek apakah prompt aktif dan ada di dekat karakter (atau TP aktif)
                        if prompt.Enabled then
                            local part = prompt.Parent
                            if part and part:IsA("BasePart") then
                                
                                -- Teleport jika diaktifkan
                                if Flags.TeleportFarm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                                end
                                
                                -- Bypass Durasi (Biar instan)
                                prompt.HoldDuration = 0 
                                
                                -- Paksa Tekan (Fire)
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. AUTO BUY: SPECIFIC PATH
-- Menggunakan path yang kamu kirimkan: ReplicatedStorage.GameEvents.BuySeedStock
task.spawn(function()
    while task.wait(0.1) do -- Speed 0.1 agar tidak crash, bisa dicepatkan
        if Flags.AutoBuySeeds then
            pcall(function()
                -- Mencoba mencari remote di lokasi yang kamu berikan
                local remote = ReplicatedStorage:FindFirstChild("GameEvents") and ReplicatedStorage.GameEvents:FindFirstChild("BuySeedStock")
                
                if remote then
                    -- Beli item yang dipilih berulang kali
                    remote:FireServer("Shop", Flags.SelectedSeed)
                else
                    warn("REMOTE TIDAK DITEMUKAN! Cek folder GameEvents.")
                end
            end)
        end
    end
end)

-- 3. LOW GFX
task.spawn(function()
    while task.wait(1) do
        if Flags.LowGfx then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            end
        end
    end
end)

-- 4. WALKSPEED FIX
task.spawn(function()
    while task.wait() do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Flags.WalkSpeed
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump and player.Character then
        player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
    end
end)
