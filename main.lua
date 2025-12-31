-- ELYSIUM HUB | V6 REFINED EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_Refined"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    AutoPlant = false, AutoCollect = false, AutoSell = false,
    WalkSpeed = 16, JumpPower = 50,
    MenuOpened = {Home = true, Main = true, Player = true, Shop = true}
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 550, 0, 380)
main.Position = UDim2.new(0.5, -275, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.fromRGB(45, 45, 55)

-- TOP BAR (HEADER)
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

-- ================= WINDOW CONTROLS =================
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

-- Bubble/Minimize Icon
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 50, 0, 50)
bubble.Position = UDim2.new(0, 20, 0.5, -25)
bubble.Visible = false
bubble.Text = "💎"
bubble.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

createWinBtn("X", -35, Color3.fromRGB(200, 50, 50), function() gui:Destroy() end)
createWinBtn("–", -65, Color3.fromRGB(60, 60, 80), function() main.Visible = false; bubble.Visible = true end)
bubble.MouseButton1Click:Connect(function() main.Visible = true; bubble.Visible = false end)

-- ================= SIDEBAR & PAGES =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 0, 0, 40)
side.Size = UDim2.new(0, 130, 1, -40)
side.BackgroundTransparency = 1
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 135, 0, 45)
container.Size = UDim2.new(1, -140, 1, -50)
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

-- ================= COLLAPSIBLE SECTION SYSTEM =================
local function createSection(parent, name)
    local sectionFrame = Instance.new("Frame", parent)
    sectionFrame.Size = UDim2.new(1, 0, 0, 35)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Instance.new("UICorner", sectionFrame)

    local titleBtn = Instance.new("TextButton", sectionFrame)
    titleBtn.Size = UDim2.new(1, 0, 1, 0)
    titleBtn.BackgroundTransparency = 1
    titleBtn.Text = "  " .. name
    titleBtn.TextColor3 = Color3.new(1, 1, 1)
    titleBtn.Font = Enum.Font.GothamBold
    titleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", sectionFrame)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.BackgroundTransparency = 1

    -- Container untuk isi section
    local content = Instance.new("Frame", parent)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 2)

    titleBtn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)

    return content
end

-- ================= CREATE CONTENT =================
local homePage = createPage("Home")
local mainPage = createPage("Main")
local playerPage = createPage("Player")

-- HOME SECTION
local discSection = createSection(homePage, "Discord")
local discBtn = Instance.new("TextButton", discSection)
discBtn.Size = UDim2.new(1, 0, 0, 35)
discBtn.Text = "Copy Discord Link"
discBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", discBtn)

-- MAIN SECTION
local farmSection = createSection(mainPage, "Auto Farming")
local function quickToggle(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        b.Text = text .. (Flags[flag] and ": ON" or ": OFF")
        b.TextColor3 = Flags[flag] and Color3.new(0, 1, 1) or Color3.new(1,1,1)
    end)
end

quickToggle(farmSection, "Auto Plant", "AutoPlant")
quickToggle(farmSection, "Auto Collect", "AutoCollect")
quickToggle(farmSection, "Auto Sell", "AutoSell")

-- PLAYER SECTION
local moveSection = createSection(playerPage, "Movement")
-- (Tambahkan slider speed di sini nanti)

-- ================= NAVIGATION =================
local function openPage(name)
    for _, v in pairs(pages) do v.Visible = false end
    pages[name].Visible = true
end

local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Text = icon .. " " .. name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() openPage(name) end)
end

sideBtn("Home", "🏠")
sideBtn("Main", "🔥")
sideBtn("Player", "⚡")

openPage("Home")
