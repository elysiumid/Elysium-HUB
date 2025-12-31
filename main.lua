-- ELYSIUM HUB UI | UPDATED VERSION
-- Style: Speed Hub X | Features: Page Navigation & Minimize Bubble

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI"
gui.ResetOnSpawn = false

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,550,0,350)
main.Position = UDim2.new(0.5, -275, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- Border Glow/Stroke (Agar lebih estetik)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(45, 45, 55)
stroke.Thickness = 1.5

-- ================= TOP BAR =================
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Elysium Hub X | <font color='#FF4444'>v1</font>"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Tombol Close & Minimize
local function createTopBtn(text, pos, color)
    local btn = Instance.new("TextButton", top)
    btn.Size = UDim2.new(0,24,0,24)
    btn.Position = pos
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = color
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    return btn
end

local close = createTopBtn("X", UDim2.new(1,-35,0.5,-12), Color3.fromRGB(200, 50, 50))
local minimize = createTopBtn("–", UDim2.new(1,-65,0.5,-12), Color3.fromRGB(60, 60, 80))

-- ================= SIDEBAR =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0,0,0,40)
side.Size = UDim2.new(0,140,1,-40)
side.BackgroundTransparency = 1

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0,8)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", side).PaddingTop = UDim.new(0,10)

-- ================= CONTENT PAGES =================
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,145,0,50)
container.Size = UDim2.new(1,-155,1,-60)
container.BackgroundTransparency = 1

local pages = {}

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.CanvasSize = UDim2.new(0,0,2,0)
    p.ScrollBarThickness = 2
    
    local l = Instance.new("TextLabel", p)
    l.Size = UDim2.new(1,0,0,30)
    l.Text = "Menu: " .. name
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.new(1,1,1)
    l.BackgroundTransparency = 1
    l.TextSize = 18
    
    pages[name] = p
    return p
end

-- Buat Halaman
createPage("Home")
createPage("Main")
createPage("Inventory")
createPage("Shop")
createPage("Misc")

-- Fungsi Navigasi
local function openPage(name)
    for i, v in pairs(pages) do v.Visible = false end
    if pages[name] then pages[name].Visible = true end
end

local function sideButton(text)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9,0,0,35)
    b.Text = "  " .. text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(180,180,180)
    b.BackgroundColor3 = Color3.fromRGB(30,30,40)
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    
    b.MouseButton1Click:Connect(function()
        openPage(text)
    end)
end

sideButton("Home")
sideButton("Main")
sideButton("Inventory")
sideButton("Shop")
sideButton("Misc")

-- ================= MINIMIZED BUBBLE (Diamond/Moon) =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,50,0,50)
bubble.Position = UDim2.new(0,20,0.5,-25)
bubble.Visible = false
bubble.Text = "💎" -- Kamu bisa ganti dengan emoji bulan ☾
bubble.TextSize = 25
bubble.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", bubble).Color = Color3.fromRGB(120, 90, 220)

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

-- Start Page
openPage("Home")
