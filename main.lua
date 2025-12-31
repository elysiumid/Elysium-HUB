-- ELYSIUM HUB UI ONLY
-- Speed Hub X style | Delta safe

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI"
gui.ResetOnSpawn = false

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,320)
main.Position = UDim2.new(0.25,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- ================= TOP BAR =================
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,38)
top.BackgroundColor3 = Color3.fromRGB(35,35,45)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,14,0,0)
title.BackgroundTransparency = 1
title.Text = "Speed Hub X | Style UI"
title.TextXAlignment = Left
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(230,230,230)

-- CLOSE
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-34,0.5,-14)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(170,60,60)
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

-- MINIMIZE
local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,28,0,28)
minimize.Position = UDim2.new(1,-68,0.5,-14)
minimize.Text = "–"
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(120,90,200)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0,0,0,38)
side.Size = UDim2.new(0,130,1,-38)
side.BackgroundColor3 = Color3.fromRGB(25,25,35)

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0,6)
sideLayout.HorizontalAlignment = Center

local function sideButton(text)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9,0,0,32)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.BackgroundColor3 = Color3.fromRGB(40,40,55)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

sideButton("Home")
sideButton("Main")
sideButton("Inventory")
sideButton("Shop")
sideButton("Misc")

-- ================= CONTENT =================
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,130,0,38)
content.Size = UDim2.new(1,-130,1,-38)
content.BackgroundTransparency = 1

local label = Instance.new("TextLabel", content)
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.Text = "Content Area"
label.Font = Enum.Font.Gotham
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(200,200,200)

-- ================= MINIMIZED BUBBLE =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,55,0,55)
bubble.Position = UDim2.new(0.05,0,0.6,0)
bubble.Visible = false
bubble.Text = "☾"
bubble.Font = Enum.Font.GothamBold
bubble.TextScaled = true
bubble.TextColor3 = Color3.fromRGB(255,255,255)
bubble.BackgroundColor3 = Color3.fromRGB(140,90,220)
bubble.Active = true
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

-- ================= LOGIC =================
minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    bubble.Visible = false
    main.Visible = true
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
