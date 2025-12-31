-- ELYSIUM HUB UI BASE (DELTA SAFE)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- NOTIF TEST
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
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 220)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- CONTAINER
local list = Instance.new("UIListLayout", main)
list.Padding = UDim.new(0,8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.VerticalAlignment = Enum.VerticalAlignment.Top
list.Padding = UDim.new(0,8)
list.Parent = main

-- SPACER
local spacer = Instance.new("Frame", main)
spacer.Size = UDim2.new(1,0,0,40)
spacer.BackgroundTransparency = 1

-- ===== TOGGLE MAKER =====
local function createToggle(text, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(60,60,60)
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

-- INFO
local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(0.9,0,0,30)
info.BackgroundTransparency = 1
info.Text = "Grow a Garden"
info.TextColor3 = Color3.fromRGB(180,180,180)
info.Font = Enum.Font.Gotham
info.TextScaled = true
