-- ELYSIUM HUB X | FULL SPEED HUB X VERSION
-- Style: Red Dark | Features: Auto Farm, Auto Buy, Auto Sell

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

-- ================= GLOBAL SETTINGS =================
getgenv().Config = {
    -- Farming
    AutoPlant = false,
    AutoHarvest = false,
    AutoWater = false,
    -- Shopping
    AutoSeeds = false,
    AutoGear = false,
    AutoEggs = false,
    -- Misc
    WalkSpeed = 16,
    JumpPower = 50
}

local Items = {
    Seeds = {"Carrot", "Tomato", "Potato", "Wheat", "Corn"},
    Gear = {"BasicWateringCan", "ProShovel", "GoldWateringCan"},
    Eggs = {"Common Egg", "Rare Egg", "Legendary Egg"}
}

-- ================= UI ENGINE =================
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumFull"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 550, 0, 350)
main.Position = UDim2.new(0.5, -275, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 40, 40)
stroke.Thickness = 2

-- Sidebar & Navigation
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 160, 0, 10)
container.Size = UDim2.new(1, -170, 1, -20)
container.BackgroundTransparency = 1

local pages = {}
local btnList = Instance.new("Frame", sidebar)
btnList.Position = UDim2.new(0,0,0,50)
btnList.Size = UDim2.new(1,0,1,-50)
btnList.BackgroundTransparency = 1
Instance.new("UIListLayout", btnList).HorizontalAlignment = "Center"

-- ================= FUNCTIONS =================
local function createTab(name)
    local btn = Instance.new("TextButton", btnList)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    
    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

local function createToggle(pageName, text, configKey)
    local btn = Instance.new("TextButton", pages[pageName])
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        getgenv().Config[configKey] = not getgenv().Config[configKey]
        btn.Text = text .. (getgenv().Config[configKey] and ": ON" or ": OFF")
        btn.TextColor3 = getgenv().Config[configKey] and Color3.fromRGB(0, 255, 100) or Color3.new(1,1,1)
    end)
end

-- ================= SETUP TABS =================
createTab("Main")
createTab("Shop")
createTab("Misc")

-- MAIN FEATURES
createToggle("Main", "Auto Plant Seeds", "AutoPlant")
createToggle("Main", "Auto Harvest", "AutoHarvest")
createToggle("Main", "Auto Water", "AutoWater")

-- SHOP FEATURES
createToggle("Shop", "Auto Buy Seeds", "AutoSeeds")
createToggle("Shop", "Auto Buy Gear", "AutoGear")
createToggle("Shop", "Auto Buy Eggs", "AutoEggs")

-- MISC FEATURES
local wsBtn = Instance.new("TextBox", pages["Misc"])
wsBtn.Size = UDim2.new(1,0,0,35)
wsBtn.PlaceholderText = "Set WalkSpeed (Default 16)"
wsBtn.FocusLost:Connect(function() player.Character.Humanoid.WalkSpeed = tonumber(wsBtn.Text) or 16 end)

-- ================= FARMING & SHOP LOGIC =================
task.spawn(function()
    while task.wait(0.5) do
        -- AUTO BUY
        if getgenv().Config.AutoSeeds then
            for _, item in pairs(Items.Seeds) do GameEvents.BuySeedStock:FireServer("Shop", item) end
        end
        
        -- AUTO HARVEST (Contoh Logika)
        if getgenv().Config.AutoHarvest then
            -- Script akan mencari tanaman matang dan menembak Remote Harvest
            -- GameEvents.Harvest:FireServer(Tanaman) 
        end
    end
end)

-- MINIMIZE BUTTON (Diamond)
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 50, 0, 50)
bubble.Position = UDim2.new(0, 15, 0.5, 0)
bubble.Text = "💎"; bubble.Visible = false
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
bubble.MouseButton1Click:Connect(function() main.Visible = true; bubble.Visible = false end)

local min = Instance.new("TextButton", main)
min.Size = UDim2.new(0, 30, 0, 30)
min.Position = UDim2.new(1, -35, 0, 5)
min.Text = "-"; min.MouseButton1Click:Connect(function() main.Visible = false; bubble.Visible = true end)

pages["Main"].Visible = true
