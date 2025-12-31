-- ELYSIUM HUB UI | BACK TO CLASSIC STYLE
-- Style: Speed Hub X | Safe & Functional

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local SeedRemote = GameEvents:WaitForChild("BuySeedStock")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI"
gui.ResetOnSpawn = false

-- ================= CONFIG =================
getgenv().AutoBuySeeds = false
local SeedList = {"Carrot", "Tomato", "Potato", "Wheat", "Corn"}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,320)
main.Position = UDim2.new(0.5,-260,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,38)
top.BackgroundColor3 = Color3.fromRGB(35,35,45)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,14,0,0)
title.BackgroundTransparency = 1
title.Text = "Speed Hub X | Elysium Edition"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(230,230,230)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE & MINIMIZE
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-34,0.5,-14)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,60,60)
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,28,0,28)
minimize.Position = UDim2.new(1,-68,0.5,-14)
minimize.Text = "–"
minimize.BackgroundColor3 = Color3.fromRGB(120,90,200)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0,0,0,38)
side.Size = UDim2.new(0,130,1,-38)
side.BackgroundColor3 = Color3.fromRGB(25,25,35)

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0,6)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= CONTENT =================
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,135,0,45)
content.Size = UDim2.new(1,-145,1,-55)
content.BackgroundTransparency = 1

local function createToggle(text)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1,0,0,40)
    b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40,40,55)
    b.TextColor3 = Color3
