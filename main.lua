-- ELYSIUM HUB UI | V6 ULTIMATE EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V6"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    -- Main
    AutoPlant = false,
    AutoCollect = false,
    AutoSell = false,
    AutoShovel = false,
    AutoWater = false,
    -- Hatch
    AutoHatch = false,
    -- Local Player
    WalkSpeed = 16,
    JumpPower = 50
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 380)
main.Position = UDim2.new(0.5, -290, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 60, 255)
stroke.Thickness = 2

-- TOP BAR (HEADER)
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB <font color='#00FFFF'>X</font> | GROW A GARDEN"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 0, 0, 45)
side.Size = UDim2.new(0, 130, 1, -45)
side.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= CONTAINER =================
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 140, 0, 55)
container.Size = UDim2.new(1, -150, 1, -65)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 8)
    pages[name] = p
    return p
end

-- Create All Pages
local homePage = createPage("Home")
local mainPage = createPage("Main")
local shopPage = createPage("Shop")
local playerPage = createPage("Player")

-- ================= UNIVERSAL COMPONENTS =================
local function createToggle(parent, text, flagName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        btn.Text = text .. (Flags[flagName] and ": ON" or ": OFF")
        btn.TextColor3 = Flags[flagName] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
        btn.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 40)
    end)
end

local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- ================= HOME PAGE =================
local profile = Instance.new("TextLabel", homePage)
profile.Size = UDim2.new(0.95, 0, 0, 60)
profile.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
profile.Text = "User: " .. player.Name .. "\nStatus: Premium User"
profile.TextColor3 = Color3.new(1, 1, 1)
profile.Font = Enum.Font.GothamBold
Instance.new("UICorner", profile)

createButton(homePage, "Join Discord Community", Color3.fromRGB(88, 101, 242), function()
    -- Copy link to clipboard (Hanya bekerja di beberapa executor)
    if setclipboard then setclipboard("https://discord.gg/elysium-hub") end
    print("Link Discord Copied!")
end)

-- ================= PLAYER PAGE (WALKSPEED & JUMP) =================
local function createSlider(parent, text, min, max, flagName)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0.95, 0, 0, 20)
    label.Text = text .. ": " .. Flags[flagName]
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(Flags[flagName])
    box.TextColor3 = Color3.new(0, 1, 1)
    Instance.new("UICorner", box)
    
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            Flags[flagName] = val
            label.Text = text .. ": " .. val
            if flagName == "WalkSpeed" then Character.Humanoid.WalkSpeed = val end
            if flagName == "JumpPower" then Character.Humanoid.JumpPower = val end
        end
    end)
end

createSlider(playerPage, "WalkSpeed", 16, 200, "WalkSpeed")
createSlider(playerPage, "JumpPower", 50, 500, "JumpPower")

-- ================= MAIN PAGE (FARMING) =================
createToggle(mainPage, "Auto Plant (Tanam)", "AutoPlant")
createToggle(mainPage, "Auto Collect (Panen)", "AutoCollect")
createToggle(mainPage, "Auto Sell (Jual)", "AutoSell")
createToggle(mainPage, "Auto Water (Siram)", "AutoWater")
createToggle(mainPage, "Auto Shovel (Gali)", "AutoShovel")
createToggle(mainPage, "Auto Favorite", "AutoFavorite")

-- ================= SHOP & HATCH =================
createToggle(shopPage, "Auto Hatch (Buka Telur)", "AutoHatch")
createToggle(shopPage, "Auto Buy Seeds", "AutoSeeds")

-- ================= AUTO LOGIC LOOP =================
task.spawn(function()
    while task.wait(0.5) do
        -- Update Humanoid terus menerus agar speed tetap
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = Flags.WalkSpeed
        end

        -- Logika Auto Farm
        if Flags.AutoCollect then
            GameEvents.HarvestPlant:FireServer("All") -- Contoh remote
        end
        
        if Flags.AutoSell then
            GameEvents.SellItems:FireServer()
        end
        
        if Flags.AutoHatch then
            GameEvents.HatchEgg:FireServer("CommonEgg", "Single")
        end
        
        -- Tambahkan logika lainnya di sini sesuai remote game kamu
    end
end)

-- ================= NAVIGATION =================
local function openPage(name)
    for _, v in pairs(pages) do v.Visible = false end
    if pages[name] then pages[name].Visible = true end
end

local function sideButton(text, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Text = icon .. " " .. text
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() openPage(text) end)
end

sideButton("Home", "🏠")
sideButton("Main", "🌿")
sideButton("Player", "⚡")
sideButton("Shop", "🛒")

-- Close/Minimize Logic (Gunakan logic yang sama dari loader sebelumnya)
openPage("Home")
