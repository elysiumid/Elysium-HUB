-- ELYSIUM HUB | V13 ULTIMATE UI PERFECTION
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V13_Perfect"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    WalkSpeed = 16, InfJump = false,
    SelectedSeed = "None", PlantPos = "Player Location", AutoPlant = false,
    SelectedCollect = "None", SelectedMutation = "None",
    SelectedWater = "None",
    ShovelFruit = "None", ShovelPlant = "None", ShovelSprinkler = "None",
    AutoSellAll = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 450)
main.Position = UDim2.new(0.5, -290, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BackgroundTransparency = 0.15
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 68, 68)
stroke.Thickness = 1.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
top.BackgroundTransparency = 0.2
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM <font color='#FF4444'>HUB</font> | V13 PERFECT UI"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)

-- ================= DRAGGABLE BUBBLE (MINIMIZE) =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 60, 0, 60)
bubble.Position = UDim2.new(0, 25, 0.5, -30)
bubble.Visible = false
bubble.Text = "💎"
bubble.TextSize = 28
bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
bubble.BackgroundTransparency = 0.1
bubble.Active = true
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(255, 68, 68)
bStroke.Thickness = 2

-- WINDOW CONTROLS
local function createWinBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton", top)
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, pos, 0.5, -14)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

createWinBtn("X", -40, Color3.fromRGB(200, 50, 50), function() gui:Destroy() end)
createWinBtn("–", -75, Color3.fromRGB(60, 60, 80), function() main.Visible = false; bubble.Visible = true end)
bubble.MouseButton1Click:Connect(function() main.Visible = true; bubble.Visible = false end)

-- ================= SIDEBAR & NAVIGATION =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 8, 0, 55)
side.Size = UDim2.new(0, 130, 1, -65)
side.BackgroundTransparency = 1
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 5)

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 145, 0, 55)
container.Size = UDim2.new(1, -155, 1, -65)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
    pages[name] = p
    return p
end

-- ================= UI COMPONENT BUILDERS =================

-- 1. Section with Arrow
local function createSection(parent, name, defaultVisible, isSub)
    local sectionContainer = Instance.new("Frame", parent)
    sectionContainer.Size = UDim2.new(0.98, 0, 0, 0)
    sectionContainer.AutomaticSize = Enum.AutomaticSize.Y
    sectionContainer.BackgroundTransparency = 1

    local f = Instance.new("Frame", sectionContainer)
    f.Size = UDim2.new(1, 0, 0, 35)
    f.BackgroundColor3 = isSub and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(255, 68, 68)
    f.BackgroundTransparency = isSub and 0.8 or 0.65
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", f)
    arrow.Size = UDim2.new(0, 35, 1, 0)
    arrow.Position = UDim2.new(1, -35, 0, 0)
    arrow.Text = (defaultVisible and "▼" or "▶")
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.BackgroundTransparency = 1
    arrow.TextSize = 14

    local content = Instance.new("Frame", sectionContainer)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 38)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Visible = defaultVisible or false
    local clayout = Instance.new("UIListLayout", content)
    clayout.Padding = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)
    return content
end

-- 2. Modern Toggle (Switch Right)
local function createToggle(parent, text, flag)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.98, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    f.BackgroundTransparency = 0.5
    Instance.new("UICorner", f)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.fromRGB(210, 210, 210)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham

    local switch = Instance.new("TextButton", f)
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.Position = UDim2.new(1, -52, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", switch)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = UDim2.new(0, 2, 0.5, -9)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        local targetPos = Flags[flag] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local targetColor = Flags[flag] and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(50, 50, 60)
        
        TweenService:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- 3. Modern Search Bar
local function createSearchMenu(parent, name, placeholder, flag)
    local sub = createSection(parent, name, false, true)
    local input = Instance.new("TextBox", sub)
    input.Size = UDim2.new(0.98, 0, 0, 35)
    input.PlaceholderText = "  🔍 " .. placeholder
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
    
    input.FocusLost:Connect(function() Flags[flag] = input.Text end)
end

-- 4. Selection Menu
local function createSelectionMenu(parent, name, options, flag)
    local sub = createSection(parent, name, false, true)
    for _, opt in pairs(options) do
        local b = Instance.new("TextButton", sub)
        b.Size = UDim2.new(0.98, 0, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        b.Text = opt
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.Font = Enum.Font.Gotham
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function() 
            Flags[flag] = opt 
            b.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
            task.wait(0.1)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end)
    end
end

-- ================= PAGE INITIALIZATION =================
local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- --- HOME PAGE ---
local lpSection = createSection(homePage, "Local Player", true, false)
-- Walkspeed UI (Integrated)
local wsFrame = Instance.new("Frame", lpSection)
wsFrame.Size = UDim2.new(0.98, 0, 0, 45)
wsFrame.BackgroundTransparency = 0.85
wsFrame.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", wsFrame)

local wsLabel = Instance.new("TextLabel", wsFrame)
wsLabel.Size = UDim2.new(0.5, 0, 1, 0)
wsLabel.Position = UDim2.new(0, 12, 0, 0)
wsLabel.Text = "Walkspeed: " .. Flags.WalkSpeed
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.BackgroundTransparency = 1
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Font = Enum.Font.GothamBold

local function speedBtn(text, posX, delta)
    local b = Instance.new("TextButton", wsFrame)
    b.Size = UDim2.new(0, 32, 0, 32)
    b.Position = UDim2.new(1, posX, 0.5, -16)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags.WalkSpeed = math.clamp(Flags.WalkSpeed + delta, 0, 500)
        wsLabel.Text = "Walkspeed: " .. Flags.WalkSpeed
    end)
end
speedBtn("+", -40, 10)
speedBtn("-", -80, -10)
createToggle(lpSection, "Infinity Jump", "InfJump")

-- --- MAIN PAGE ---
local plantM = createSection(mainPage, "Auto Plant Seed", true, false)
createSearchMenu(plantM, "Plant Select", "Seed Name...", "SelectedSeed")
createSelectionMenu(plantM, "Plant Position", {"Player Location", "Random Location", "Good Location"}, "PlantPos")
createToggle(plantM, "Enable Auto Plant", "AutoPlant")

local collectM = createSection(mainPage, "Auto Collect", false, false)
createSearchMenu(collectM, "Auto Collect Plant", "Plant Name...", "SelectedCollect")
createSearchMenu(collectM, "Auto Mutation", "Mutation Name...", "SelectedMutation")

local waterM = createSection(mainPage, "Auto Water", false, false)
createSearchMenu(waterM, "Target Plant", "Plant Name...", "SelectedWater")

local shovelM = createSection(mainPage, "Auto Shovel", false, false)
createSearchMenu(shovelM, "Shovel Fruit", "Fruit Name...", "ShovelFruit")
createSearchMenu(shovelM, "Shovel Plant", "Plant Name...", "ShovelPlant")
createSearchMenu(shovelM, "Shovel Sprinkler", "Sprinkler Name...", "ShovelSprinkler")

local sellM = createSection(mainPage, "Auto Sell", false, false)
createToggle(sellM, "Sell All Plants", "AutoSellAll")

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    b.BackgroundTransparency = 0.5
    b.Text = "  " .. icon .. "  " .. name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
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

-- ================= CORE LOGIC =================
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
