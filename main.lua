pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Elysium HUB",
        Text = "Script berhasil dijalankan",
        Duration = 4
    })
end)

-- PERSONAL HUB (DELTA SAFE)
-- main.lua

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- wait character
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PersonalHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "PERSONAL HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- SPEED
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0.9, 0, 0, 35)
speedBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
speedBtn.Text = "Speed ON"
speedBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBtn.TextColor3 = Color3.new(1,1,1)

local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and 60 or 16
    speedBtn.Text = speedOn and "Speed OFF" or "Speed ON"
end)

-- JUMP
local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(0.9, 0, 0, 35)
jumpBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
jumpBtn.Text = "Jump ON"
jumpBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpBtn.TextColor3 = Color3.new(1,1,1)

local jumpOn = false
jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    humanoid.JumpPower = jumpOn and 120 or 50
    jumpBtn.Text = jumpOn and "Jump OFF" or "Jump ON"
end)

-- respawn fix
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
end)
