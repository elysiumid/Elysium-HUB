-- ELYSIUM HUB | STABLE VERSION
-- Delta Safe | Grow a Garden

-- ===== SERVICES =====
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ===== WAIT PLAYER =====
repeat task.wait() until player and player:FindFirstChild("PlayerGui")

-- ===== GAME LOCK =====
local ALLOWED_PLACE_ID = 126884695634066
if game.PlaceId ~= ALLOWED_PLACE_ID then
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title = "Elysium HUB",
            Text = "Game tidak didukung",
            Duration = 5
        })
    end)
    return
end

-- ===== HUMANOID =====
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end
local humanoid = getHumanoid()
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
end)

-- ===== NOTIF =====
pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title = "Elysium HUB",
        Text = "Loaded successfully",
        Duration = 3
    })
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ElysiumHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- ===== MAIN FRAME =====
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,360)
main.Position = UDim2.new(0.05,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(45,20,70)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- ===== TOP BAR =====
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(110,60,180)
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
closeBtn.BackgroundColor3 = Color3.fromRGB(180,70,70)
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
minBtn.BackgroundColor3 = Color3.fromRGB(140,90,220)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,8)

-- ===== CONTENT =====
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,45)
content.Size = UDim2.new(1,0,1,-45)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ===== MINIMIZE LOGIC =====
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.new(0,280,0,45) or UDim2.new(0,280,0,360)
    minBtn.Text = minimized and "+" or "-"
end)

-- ===== TOGGLE MAKER =====
local function toggleButton(text, onEnable, onDisable)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9,0,0,38)
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(90,60,140)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..(state and " : ON" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(160,110,240) or Color3.fromRGB(90,60,140)
        if state then onEnable() else onDisable() end
    end)
end

-- ===== DROPDOWN =====
local function dropdown(titleText, options, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(0.9,0,0,36)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(70,45,120)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local index = 1
    btn.Text = titleText..": "..options[index]

    btn.MouseButton1Click:Connect(function()
        index += 1
        if index > #options then index = 1 end
        btn.Text = titleText..": "..options[index]
        callback(options[index])
    end)
end

-- ===== PLAYER FEATURES =====
toggleButton("Speed", function()
    humanoid.WalkSpeed = 60
end, function()
    humanoid.WalkSpeed = 16
end)

toggleButton("Jump", function()
    humanoid.JumpPower = 120
end, function()
    humanoid.JumpPower = 50
end)

-- =================================================
-- ============ AUTO BUY SEED (STABLE) ==============
-- =================================================

local buySeedRemote = ReplicatedStorage.GameEvents:WaitForChild("BuySeedStock")
local autoBuySeed = false
local selectedSeed = "Carrot"
local seedPrice = 10

dropdown("Seed", {"Carrot","Potato"}, function(v)
    selectedSeed = v
    seedPrice = (v == "Carrot") and 10 or 20
end)

toggleButton("Auto Buy Seed", function()
    autoBuySeed = true
    task.spawn(function()
        while autoBuySeed do
            pcall(function()
                local coins = player:FindFirstChild("leaderstats")
                    and player.leaderstats:FindFirstChild("Coins")
                if coins and coins.Value >= seedPrice then
                    buySeedRemote:FireServer("Shop", selectedSeed)
                end
            end)
            task.wait(5) -- DELAY AMAN
        end
    end)
end, function()
    autoBuySeed = false
end)
