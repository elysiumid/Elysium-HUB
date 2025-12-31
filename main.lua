-- ELYSIUM HUB | V16 FINAL INTEGRATED (NO FEATURES REMOVED)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V16_Final"
gui.ResetOnSpawn = false

-- ================= GLOBAL FLAGS (SEMUA FITUR) =================
local Flags = {
    WalkSpeed = 16, InfJump = false,
    -- Auto Plant
    AutoPlant = false, SelectedSeed = "", PlantPos = "Player Location",
    -- Auto Collect
    AutoCollect = false, SelectedCollect = "", SelectedMutation = "",
    -- Auto Water
    AutoWater = false, SelectedWater = "",
    -- Auto Shovel
    ShovelFruit = "", ShovelPlant = "", ShovelSprinkler = "",
    -- Auto Sell
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
title.Text = "ELYSIUM <font color='#FF4444'>HUB</font> | V16 INTEGRATED"
title.RichText = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- ================= BUBBLE (MINIMIZE) =================
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
side.Position = UDim2.new(0, 8, 0, 55)
side.Size = UDim2.new(0, 130, 1, -65)
side.BackgroundTransparency = 1
Instance.new("UIListLayout", side).Padding = UDim.new(0, 5)

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
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
    pages[name] = p
    return p
end

-- ================= UI BUILDERS (FIXED HIERARCHY) =================

-- Header Section (Arrow Expand)
local function createSection(parent, name, defaultVisible)
    local sectionContainer = Instance.new("Frame", parent)
    sectionContainer.Size = UDim2.new(0.98, 0, 0, 0)
    sectionContainer.AutomaticSize = Enum.AutomaticSize.Y
    sectionContainer.BackgroundTransparency = 1

    local f = Instance.new("Frame", sectionContainer)
    f.Size = UDim2.new(1, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    f.BackgroundTransparency = 0.65
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

    local content = Instance.new("Frame", sectionContainer)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 38)
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

-- Row with Label + Input di Pojok Kanan
local function createRow(parent, text, type, flag, options)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.98, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    f.BackgroundTransparency = 0.5
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.4, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.fromRGB(210, 210, 210)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham

    if type == "Toggle" then
        local sw = Instance.new("TextButton", f)
        sw.Size = UDim2.new(0, 40, 0, 20)
        sw.Position = UDim2.new(1, -50, 0.5, -10)
        sw.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        sw.Text = ""
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", sw)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 2, 0.5, -8)
        dot.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", dot)
        sw.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            TweenService:Create(dot, TweenInfo.new(0.2), {Position = Flags[flag] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = Flags[flag] and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(50, 50, 60)}):Play()
        end)
    elseif type == "Search" then
        local input = Instance.new("TextBox", f)
        input.Size = UDim2.new(0, 120, 0, 24)
        input.Position = UDim2.new(1, -10, 0.5, -12)
        input.AnchorPoint = Vector2.new(1, 0)
        input.PlaceholderText = "Search..."
        input.Text = ""
        input.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        input.TextColor3 = Color3.new(1, 1, 1)
        input.Font = Enum.Font.Gotham; input.TextSize = 11
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
        input.FocusLost:Connect(function() Flags[flag] = input.Text end)
    elseif type == "Cycle" then
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0, 120, 0, 24)
        btn.Position = UDim2.new(1, -10, 0.5, -12)
        btn.AnchorPoint = Vector2.new(1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = options[1]
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham; btn.TextSize = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        local idx = 1
        btn.MouseButton1Click:Connect(function()
            idx = idx % #options + 1
            Flags[flag] = options[idx]
            btn.Text = Flags[flag]
        end)
    end
end

-- ================= INITIALIZE ALL PAGES =================
local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- --- HOME (LOCAL PLAYER) ---
local lp = createSection(homePage, "Local Player", true)
createRow(lp, "Infinite Jump", "Toggle", "InfJump")
-- Walkspeed Special Row
local wsRow = Instance.new("Frame", lp); wsRow.Size = UDim2.new(0.98,0,0,35); wsRow.BackgroundTransparency = 1
local wsL = Instance.new("TextLabel", wsRow); wsL.Size = UDim2.new(0.4,0,1,0); wsL.Position = UDim2.new(0,12,0,0); wsL.Text = "Walkspeed: 16"; wsL.TextColor3 = Color3.new(1,1,1); wsL.BackgroundTransparency = 1; wsL.Font = Enum.Font.Gotham; wsL.TextXAlignment = Enum.TextXAlignment.Left
local function addWS(t, x, d)
    local b = Instance.new("TextButton", wsRow); b.Size = UDim2.new(0,24,0,24); b.Position = UDim2.new(1,x,0.5,-12); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(50,50,60); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(function() Flags.WalkSpeed = math.clamp(Flags.WalkSpeed + d, 16, 500); wsL.Text = "Walkspeed: "..Flags.WalkSpeed end)
end
addWS("+", -34, 10); addWS("-", -65, -10)

-- --- MAIN (FARMING) ---
local plantS = createSection(mainPage, "Auto Plant Seed", true)
createRow(plantS, "Plant Select", "Search", "SelectedSeed")
createRow(plantS, "Plant Position", "Cycle", "PlantPos", {"Player Location", "Random Location", "Good Location"})
createRow(plantS, "Auto Plant", "Toggle", "AutoPlant")

local collectS = createSection(mainPage, "Auto Collect", false)
createRow(collectS, "Auto Collect Plant", "Search", "SelectedCollect")
createRow(collectS, "Auto Collect Mutation", "Search", "SelectedMutation")

local waterS = createSection(mainPage, "Auto Water", false)
createRow(waterS, "Auto Water Plant", "Search", "SelectedWater")

local shovelS = createSection(mainPage, "Auto Shovel", false)
createRow(shovelS, "Shovel Fruit", "Search", "ShovelFruit")
createRow(shovelS, "Shovel Plant", "Search", "ShovelPlant")
createRow(shovelS, "Shovel Sprinkler", "Search", "ShovelSprinkler")

local sellS = createSection(mainPage, "Auto Sell Plant", false)
createRow(sellS, "Auto Sell All", "Toggle", "AutoSellAll")

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    b.BackgroundTransparency = 0.5
    b.Text = "  " .. icon .. "  " .. name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
    end)
end

sideBtn("Home", "🏠"); sideBtn("Main", "🔥"); sideBtn("Auto Hatch", "🥚"); sideBtn("Shop", "🛒"); sideBtn("Inventory", "📦"); sideBtn("Misc", "⚙️"); sideBtn("Webhook", "🔗")

-- ================= CORE PERSISTENT LOGIC =================
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
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
