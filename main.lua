-- ELYSIUM HUB | V7 REFINED EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V7"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    -- Home/Player
    WalkSpeed = 16, JumpPower = 50,
    -- Toggles
    AutoPlant = false, AutoCollect = false, AutoSell = false,
    AutoHatch = false, AutoShovel = false, AutoFavorite = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 400)
main.Position = UDim2.new(0.5, -290, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true -- Main frame bisa digeser
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(45, 45, 55)
stroke.Thickness = 1.5

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB <font color='#FF4444'>X</font> | GARDEN"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)

-- ================= DRAGGABLE BUBBLE (MINIMIZE LOGO) =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 55, 0, 55)
bubble.Position = UDim2.new(0, 20, 0.5, -25)
bubble.Visible = false
bubble.Text = "💎"
bubble.TextSize = 25
bubble.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bubble.Active = true
bubble.Draggable = true -- Ikon bisa digeser pengguna kemana saja
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(255, 68, 68)
bStroke.Thickness = 2

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

-- ================= SIDEBAR & NAVIGATION =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 0, 0, 40)
side.Size = UDim2.new(0, 140, 1, -40)
side.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 4)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 145, 0, 45)
container.Size = UDim2.new(1, -150, 1, -50)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

-- ================= UI BUILDER TOOLS =================
local function createSection(parent, name)
    local sectionFrame = Instance.new("Frame", parent)
    sectionFrame.Size = UDim2.new(0.98, 0, 0, 32)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", sectionFrame)

    local titleBtn = Instance.new("TextButton", sectionFrame)
    titleBtn.Size = UDim2.new(1, 0, 1, 0)
    titleBtn.BackgroundTransparency = 1
    titleBtn.Text = "  " .. name
    titleBtn.TextColor3 = Color3.new(1, 1, 1)
    titleBtn.Font = Enum.Font.GothamBold
    titleBtn.TextSize = 13
    titleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", sectionFrame)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.BackgroundTransparency = 1

    local content = Instance.new("Frame", parent)
    content.Size = UDim2.new(0.98, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Visible = true
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 3)

    titleBtn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)
    return content
end

local function createToggle(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = "  " .. text .. ": OFF"
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        b.Text = "  " .. text .. (Flags[flag] and ": ON" or ": OFF")
        b.TextColor3 = Flags[flag] and Color3.new(0, 1, 1) or Color3.fromRGB(200, 200, 200)
    end)
end

-- ================= CREATE ALL PAGES =================
local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- HOME PAGE (With Local Player)
local profileSection = createSection(homePage, "User Info")
local userInfo = Instance.new("TextLabel", profileSection)
userInfo.Size = UDim2.new(1, 0, 0, 30)
userInfo.Text = "Player: " .. player.Name
userInfo.TextColor3 = Color3.new(0.8, 0.8, 0.8)
userInfo.BackgroundTransparency = 1

local lpSection = createSection(homePage, "Local Player")
-- Walkspeed Input
local wsInput = Instance.new("TextBox", lpSection)
wsInput.Size = UDim2.new(1, 0, 0, 30)
wsInput.PlaceholderText = "Set Walkspeed..."
wsInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
wsInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", wsInput)
wsInput.FocusLost:Connect(function()
    Flags.WalkSpeed = tonumber(wsInput.Text) or 16
end)

-- Discord Invite
local discSection = createSection(homePage, "Community")
local dBtn = Instance.new("TextButton", discSection)
dBtn.Size = UDim2.new(1, 0, 0, 30)
dBtn.Text = "Copy Discord Link"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", dBtn)

-- MAIN PAGE
local fSection = createSection(mainPage, "Automation")
createToggle(fSection, "Auto Plant", "AutoPlant")
createToggle(fSection, "Auto Collect", "AutoCollect")
createToggle(fSection, "Auto Sell", "AutoSell")

-- AUTO HATCH PAGE
local hSection = createSection(hatchPage, "Egg System")
createToggle(hSection, "Auto Hatch", "AutoHatch")

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Text = icon .. "  " .. name
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
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

-- ================= LOGIC LOOP =================
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = Flags.WalkSpeed
            end
        end)
    end
end)

pages["Home"].Visible = true
