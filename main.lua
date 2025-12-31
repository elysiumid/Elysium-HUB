-- ELYSIUM HUB UI | SHOP AUTO-BUY EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI"
gui.ResetOnSpawn = false

-- ================= CONFIG AUTO BUY =================
local Flags = {
    AutoSeeds = false,
    AutoGear = false,
    AutoEggs = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,550,0,350)
main.Position = UDim2.new(0.5, -275, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", main).Color = Color3.fromRGB(45, 45, 55)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Elysium Hub X | <font color='#FF4444'>Garden v5.5.2</font>"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,255,255)

-- CLOSE & MINIMIZE
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,24,0,24)
close.Position = UDim2.new(1,-35,0.5,-12)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,24,0,24)
minimize.Position = UDim2.new(1,-65,0.5,-12)
minimize.Text = "–"
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0,0,0,40)
side.Size = UDim2.new(0,140,1,-40)
side.BackgroundTransparency = 1
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0,8)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= PAGES CONTAINER =================
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,145,0,50)
container.Size = UDim2.new(1,-155,1,-60)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0,10)
    pages[name] = p
    return p
end

local shopPage = createPage("Shop")
createPage("Home")
createPage("Main")
createPage("Inventory")

-- ================= TOGGLE SYSTEM (Untuk Shop) =================
local function createToggle(parent, text, flagName, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        btn.Text = text .. (Flags[flagName] and ": ON" or ": OFF")
        btn.TextColor3 = Flags[flagName] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
        callback(Flags[flagName])
    end)
end

-- ================= DAFTAR ITEM SHOP =================
-- Tambahkan nama item lain di sini sesuai yang ada di game kamu
local ShopItems = {
    Seeds = {"Carrot", "Tomato", "Potato", "Wheat", "Corn"},
    Gear = {"BasicWateringCan", "GoldShovel", "SpeedBoots"},
    Eggs = {"CommonEgg", "RareEgg", "LegendaryEgg"}
}

-- ================= AUTO BUY LOGIC (BUY ALL) =================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local SeedRemote = GameEvents:WaitForChild("BuySeedStock")

task.spawn(function()
    while task.wait(1) do -- Interval 1 detik agar tidak lag
        
        -- Beli Semua Seeds
        if Flags.AutoSeeds then
            for _, seedName in pairs(ShopItems.Seeds) do
                SeedRemote:FireServer("Shop", seedName)
            end
        end
        
        -- Beli Semua Gear
        if Flags.AutoGear then
            for _, gearName in pairs(ShopItems.Gear) do
                -- Menggunakan remote yang sama karena biasanya polanya serupa
                SeedRemote:FireServer("Shop", gearName) 
            end
        end
        
        -- Beli Semua Eggs
        if Flags.AutoEggs then
            for _, eggName in pairs(ShopItems.Eggs) do
                SeedRemote:FireServer("Shop", eggName)
            end
        end
        
    end
end)

-- Isi Halaman Shop
createToggle(shopPage, "Auto Buy Seeds", "AutoSeeds", function(v) end)
createToggle(shopPage, "Auto Buy Gear", "AutoGear", function(v) end)
createToggle(shopPage, "Auto Buy Eggs", "AutoEggs", function(v) end)

-- ================= NAV LOGIC =================
local function openPage(name)
    for _, v in pairs(pages) do v.Visible = false end
    if pages[name] then pages[name].Visible = true end
end

local function sideButton(text)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9,0,0,35)
    b.Text = " " .. text
    b.BackgroundColor3 = Color3.fromRGB(30,30,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() openPage(text) end)
end

sideButton("Home")
sideButton("Main")
sideButton("Inventory")
sideButton("Shop")

-- BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,50,0,50)
bubble.Position = UDim2.new(0,20,0.5,-25)
bubble.Visible = false
bubble.Text = "💎"
bubble.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

minimize.MouseButton1Click:Connect(function() main.Visible = false; bubble.Visible = true end)
bubble.MouseButton1Click:Connect(function() bubble.Visible = false; main.Visible = true end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

openPage("Home")
