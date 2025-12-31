-- ELYSIUM HUB | V14 MINIMALIST UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V14"
gui.ResetOnSpawn = false

local Flags = {
    WalkSpeed = 16, InfJump = false,
    SelectedSeed = "", PlantPos = "Player", AutoPlant = false,
    SelectedCollect = "", SelectedMutation = "",
    SelectedWater = "", ShovelFruit = "", ShovelPlant = "", ShovelSprinkler = "",
    AutoSellAll = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 560, 0, 400)
main.Position = UDim2.new(0.5, -280, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BackgroundTransparency = 0.15
main.Draggable = true
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 68, 68)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundTransparency = 1
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "ELYSIUM <font color='#FF4444'>V14</font>"
title.RichText = true
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 10, 0, 45)
side.Size = UDim2.new(0, 120, 1, -55)
side.BackgroundTransparency = 1
Instance.new("UIListLayout", side).Padding = UDim.new(0, 4)

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 140, 0, 45)
container.Size = UDim2.new(1, -150, 1, -55)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 1, 1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

-- ================= COMPONENT BUILDERS (COMPACT) =================

-- 1. Simple Section (Header)
local function createSection(parent, name)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 25)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = name:upper()
    l.TextColor3 = Color3.fromRGB(255, 68, 68)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    return f
end

-- 2. Row Item (Container for Label + Right Input)
local function createRow(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    f.BackgroundTransparency = 0.5
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.4, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    
    return f
end

-- 3. Toggle Right
local function addToggle(row, flag)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 35, 0, 18)
    btn.Position = UDim2.new(1, -45, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        TweenService:Create(dot, TweenInfo.new(0.2), {Position = Flags[flag] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Flags[flag] and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(50, 50, 60)}):Play()
    end)
end

-- 4. Search Right
local function addSearch(row, placeholder, flag)
    local input = Instance.new("TextBox", row)
    input.Size = UDim2.new(0.5, 0, 0, 25)
    input.Position = UDim2.new(1, -10, 0.5, -12.5)
    input.AnchorPoint = Vector2.new(1, 0)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 11
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
    input.FocusLost:Connect(function() Flags[flag] = input.Text end)
end

-- 5. Multi-Option Right (Cycles through options)
local function addCycle(row, options, flag)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0.5, 0, 0, 25)
    btn.Position = UDim2.new(1, -10, 0.5, -12.5)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = Flags[flag]
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local index = 1
    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        Flags[flag] = options[index]
        btn.Text = Flags[flag]
    end)
end

-- ================= INITIALIZE PAGES =================
local mainPage = createPage("Main")
local homePage = createPage("Home")

-- --- HOME (LOCAL PLAYER) ---
createSection(homePage, "Character")
local wsRow = createRow(homePage, "Walkspeed")
addSearch(wsRow, "Value (16-500)", "WalkSpeed") -- Search box di kanan untuk speed

local ijRow = createRow(homePage, "Infinite Jump")
addToggle(ijRow, "InfJump")

-- --- MAIN (FARMING) ---
createSection(mainPage, "Auto Planting")
local pSeed = createRow(mainPage, "Seed Type")
addSearch(pSeed, "Search Seed...", "SelectedSeed")

local pPos = createRow(mainPage, "Plant Position")
addCycle(pPos, {"Player", "Random", "Good"}, "PlantPos")

local pToggle = createRow(mainPage, "Start Auto Plant")
addToggle(pToggle, "AutoPlant")

createSection(mainPage, "Auto Collection")
local cRow = createRow(mainPage, "Collect Plant")
addSearch(cRow, "Plant Name...", "SelectedCollect")

local mRow = createRow(mainPage, "Mutation")
addSearch(mRow, "Mutation Name...", "SelectedMutation")

createSection(mainPage, "Utility")
local wRow = createRow(mainPage, "Auto Water")
addSearch(wRow, "Target Name...", "SelectedWater")

local sRow = createRow(mainPage, "Sell All")
addToggle(sRow, "AutoSellAll")

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundTransparency = 1
    b.Text = icon .. "  " .. name
    b.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
        for _, v in pairs(side:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(0.6,0.6,0.6) end end
        b.TextColor3 = Color3.new(1, 1, 1)
    end)
end

sideBtn("Home", "🏠")
sideBtn("Main", "🔥")
sideBtn("Auto Hatch", "🥚")
sideBtn("Shop", "🛒")
sideBtn("Inventory", "📦")
sideBtn("Misc", "⚙️")
sideBtn("Webhook", "🔗")

pages["Home"].Visible = true
