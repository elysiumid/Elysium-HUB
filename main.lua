-- GAME LOCK (Grow a Garden only)
local ALLOWED_PLACE_ID = 126884695634066

if game.PlaceId ~= ALLOWED_PLACE_ID then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Elysium HUB",
            Text = "Game tidak didukung",
            Duration = 5
        })
    end)
    return
end

-- ELYSIUM HUB | SPEED X STYLE + TABS
-- Delta Safe | Purple UI

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ===== NOTIF =====
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Elysium HUB",
        Text = "UI Loaded",
        Duration = 3
    })
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ElysiumHub"
gui.ResetOnSpawn = false

-- ===== MAIN FRAME =====
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 300)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(45,20,70)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- ===== TOP BAR =====
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(100,50,170)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE
local closeBtn = Instance.new("TextButton", top)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0.5,-15)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,60,60)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE
local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-70,0.5,-15)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextScaled = true
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(130,90,200)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,8)

-- ===== TAB BAR =====
local tabBar = Instance.new("Frame", main)
tabBar.Position = UDim2.new(0,0,0,45)
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0,8)

-- ===== CONTENT HOLDER =====
local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,0,0,85)
pages.Size = UDim2.new(1,0,1,-85)
pages.BackgroundTransparency = 1

-- ===== PAGE CREATOR =====
local tabButtons = {}
local pageFrames = {}

local function createPage(name)
    local page = Instance.new("Frame", pages)
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    pageFrames[name] = page
end

local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0,80,1,0)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(80,50,120)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(pageFrames) do p.Visible = false end
        for _,b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(80,50,120)
        end
        pageFrames[name].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(150,100,230)
    end)

    tabButtons[name] = btn
end

-- ===== CREATE TABS & PAGES =====
createPage("Main")
createPage("Farm")
createPage("Player")

createTab("Main")
createTab("Farm")
createTab("Player")

-- default tab
pageFrames["Main"].Visible = true
tabButtons["Main"].BackgroundColor3 = Color3.fromRGB(150,100,230)

-- ===== TOGGLE CREATOR =====
local function createToggle(parent, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(90,60,140)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(160,110,240) or Color3.fromRGB(90,60,140)
    end)
end

-- ===== SAMPLE CONTENT =====
createToggle(pageFrames["Main"], "Example Toggle")
createToggle(pageFrames["Farm"], "Auto Harvest")
createToggle(pageFrames["Farm"], "Auto Plant")
createToggle(pageFrames["Player"], "Speed")
createToggle(pageFrames["Player"], "Jump")

-- ===== MINIMIZE LOGIC =====
local mi
