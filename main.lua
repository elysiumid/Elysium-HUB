-- ELYSIUM HUB | V12 FULL INTEGRATED (FARMING + LOCAL PLAYER)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V12_Final"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    WalkSpeed = 16, InfJump = false,
    -- Auto Plant
    AutoPlant = false, SelectedSeed = "None", PlantPos = "Player Location",
    -- Auto Collect
    AutoCollect = false, SelectedCollect = "None", SelectedMutation = "None",
    -- Auto Water & Shovel
    AutoWater = false, SelectedWater = "None",
    ShovelFruit = "None", ShovelPlant = "None", ShovelSprinkler = "None",
    -- Auto Sell
    AutoSellAll = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 450)
main.Position = UDim2.new(0.5, -290, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BackgroundTransparency = 0.2
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 68, 68)
stroke.Thickness = 1.2

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
top.BackgroundTransparency = 0.3
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB <font color='#FF4444'>V12</font> | GARDEN"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)

-- ================= BUBBLE (DRAGGABLE MINIMIZE) =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 55, 0, 55)
bubble.Position = UDim2.new(0, 20, 0.5, -25)
bubble.Visible = false
bubble.Text = "💎"
bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
bubble.BackgroundTransparency = 0.2
bubble.Active = true
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

-- WINDOW CONTROLS
local function createWinBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton", top)
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = UDim2.new(1, pos, 0.5, -12)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

createWinBtn("X", -35, Color3.fromRGB(200, 50, 50), function() gui:Destroy() end)
createWinBtn("–", -65, Color3.fromRGB(60, 60, 80), function() main.Visible = false; bubble.Visible = true end)
bubble.MouseButton1Click:Connect(function() main.Visible = true; bubble.Visible = false end)

-- ================= SIDEBAR & PAGE SYSTEM =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 0, 0, 40)
side.Size = UDim2.new(0, 140, 1, -40)
side.BackgroundTransparency = 1
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 2)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 145, 0, 45)
container.Size = UDim2.new(1, -150, 1, -55)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

-- Create Pages
local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- ================= HELPER UI BUILDER =================

-- 1. Section with Arrow
local function createSection(parent, name, defaultVisible)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    f.BackgroundTransparency = 0.7
    Instance.new("UICorner", f)
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", f)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = (defaultVisible and "▼" or "▶")
    arrow.TextColor3 = Color3.new(1,1,1)
    arrow.BackgroundTransparency = 1

    local content = Instance.new("Frame", parent)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Visible = defaultVisible or false
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)
    return content
end

-- 2. Toggle with Switch on Right Side
local function createToggle(parent, text, flag)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundTransparency = 0.92
    f.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", f)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("TextButton", f)
    bg.Size = UDim2.new(0, 40, 0, 20)
    bg.Position = UDim2.new(1, -50, 0.5, -10)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    bg.Text = ""
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    bg.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        dot:TweenPosition(Flags[flag] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2)
        bg.BackgroundColor3 = Flags[flag] and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(40, 40, 45)
    end)
end

-- 3. Search Menu Builder
local function createSearchMenu(parent, name, placeholder, flag)
    local sub = createSection(parent, name, false)
    local input = Instance.new("TextBox", sub)
    input.Size = UDim2.new(1, 0, 0, 30)
    input.PlaceholderText = "🔍 " .. placeholder
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    input.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", input)
    input.FocusLost:Connect(function() Flags[flag] = input.Text end)
end

-- 4. Selection Menu Builder
local function createSelectionMenu(parent, name, options, flag)
    local sub = createSection(parent, name, false)
    for _, opt in pairs(options) do
        local b = Instance.new("TextButton", sub)
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        b.Text = opt
        b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Flags[flag] = opt end)
    end
end

-- ================= HOME PAGE (LOCAL PLAYER) =================
local lpContent = createSection(homePage, "Local Player", true)

local wsFrame = Instance.new("Frame", lpContent)
wsFrame.Size = UDim2.new(1, 0, 0, 40)
wsFrame.BackgroundTransparency = 0.8
wsFrame.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", wsFrame)

local wsLabel = Instance.new("TextLabel", wsFrame)
wsLabel.Size = UDim2.new(0.5, 0, 1, 0)
wsLabel.Text = "  Walkspeed: " .. Flags.WalkSpeed
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.BackgroundTransparency = 1
wsLabel.TextXAlignment = Enum.TextXAlignment.Left

local function createSpeedBtn(text, posX, delta)
    local b = Instance.new("TextButton", wsFrame)
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(1, posX, 0.5, -15)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags.WalkSpeed = math.clamp(Flags.WalkSpeed + delta, 0, 500)
        wsLabel.Text = "  Walkspeed: " .. Flags.WalkSpeed
    end)
end
createSpeedBtn("+", -35, 10)
createSpeedBtn("-", -70, -10)

createToggle(lpContent, "Enable Infinity Jump", "InfJump")

-- ================= MAIN PAGE (FARMING) =================
-- 1. Auto Plant
local plantMain = createSection(mainPage, "Auto Plant Seed", true)
createSearchMenu(plantMain, "Plant Select", "Search Seed Name...", "SelectedSeed")
createSelectionMenu(plantMain, "Plant Position", {"Player Location", "Random Location", "Good Location"}, "PlantPos")
createToggle(plantMain, "Auto Plant", "AutoPlant")

-- 2. Auto Collect
local collectMain = createSection(mainPage, "Auto Collect", false)
createSearchMenu(collectMain, "Auto Collect Plant", "Search Plant...", "SelectedCollect")
createSearchMenu(collectMain, "Auto Collect Mutation", "Search Mutation...", "SelectedMutation")

-- 3. Auto Water
local waterMain = createSection(mainPage, "Auto Water", false)
createSearchMenu(waterMain, "Auto Water Plant", "Search Plant...", "SelectedWater")

-- 4. Auto Shovel
local shovelMain = createSection(mainPage, "Auto Shovel", false)
createSearchMenu(shovelMain, "Auto Shovel Fruit", "Search Fruit...", "ShovelFruit")
createSearchMenu(shovelMain, "Auto Shovel Plant", "Search Plant...", "ShovelPlant")
createSearchMenu(shovelMain, "Auto Shovel Sprinkler", "Search Sprinkler...", "ShovelSprinkler")

-- 5. Auto Sell
local sellMain = createSection(mainPage, "Auto Sell Plant", false)
createToggle(sellMain, "Auto Sell All Plant", "AutoSellAll")

-- ================= SIDEBAR NAVIGATION =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0, 120, 0, 35)
    b.Text = icon .. "  " .. name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    b.BackgroundTransparency = 0.4
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
    end)
end

sideBtn("Home", "🏠")
sideBtn("Main", "🔥")
sideBtn("Auto Hatch", "🥚")
sideBtn("Shop", "🛒")
sideBtn("Inventory", "📦")
sideBtn("Misc", "⚙️")
sideBtn("Webhook", "🔗")

-- ================= CORE LOOP LOGIC =================
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Flags.WalkSpeed end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

pages["Home"].Visible = true
