-- ELYSIUM HUB | SPEED X STYLE UI
-- Delta Safe | No UI Library

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
local gui = Instance.new("ScreenGui")
gui.Name = "ElysiumHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- ===== MAIN FRAME =====
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 260)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(45, 20, 70) -- ungu gelap
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- ===== TOP BAR =====
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(95, 40, 160) -- ungu terang
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)

-- TITLE
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- ===== CLOSE BUTTON =====
local closeBtn = Instance.new("TextButton", top)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== MINIMIZE BUTTON =====
local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0.5, -15)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextScaled = true
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

-- ===== CONTENT =====
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0, 0, 0, 45)
content.Size = UDim2.new(1, 0, 1, -45)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ===== MINIMIZE LOGIC =====
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0, 260, 0, 45) or UDim2.new(0, 260, 0, 260)
    minBtn.Text = minimized and "+" or "-"
end)

-- ===== TOGGLE CREATOR =====
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = name .. " : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " : ON" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(140, 90, 220) or Color3.fromRGB(80, 50, 120)
        callback(state)
    end)
end

-- ===== FEATURE STATES =====
local AutoHarvest = false
local AutoPlant = false

-- ===== TOGGLES =====
createToggle("Auto Harvest", function(v)
    AutoHarvest = v
end)

createToggle("Auto Plant", function(v)
    AutoPlant = v
end)
