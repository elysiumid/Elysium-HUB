-- ELYSIUM HUB | V9 FINAL FIX
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V9"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    WalkSpeed = 16,
    InfJump = false,
    AutoPlant = false, AutoCollect = false, AutoSell = false,
    AutoHatch = false
}

-- ================= MAIN FRAME =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 420)
main.Position = UDim2.new(0.5, -290, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BackgroundTransparency = 0.2 
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 68, 68)
stroke.Thickness = 1.2

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
top.BackgroundTransparency = 0.3
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM HUB <font color='#FF4444'>V9</font> | GARDEN"
title.RichText = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)

-- ================= BUBBLE (DRAGGABLE) =================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 55, 0, 55)
bubble.Position = UDim2.new(0, 20, 0.5, -25)
bubble.Visible = false
bubble.Text = "💎"
bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
bubble.BackgroundTransparency = 0.2
bubble.Active = true
bubble.Draggable = true
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

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

-- ================= SIDEBAR & PAGES =================
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0, 0, 0, 40)
side.Size = UDim2.new(0, 140, 1, -40)
side.BackgroundTransparency = 1
local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 2)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local container = Instance.new("Frame", main)
container.Position = UDim2.new(0, 145, 0, 45)
container.Size = UDim2.new(1, -150, 1, -55)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    pages[name] = p
    return p
end

-- SEMUA MENU KIRI
local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- ================= HOME PAGE (LOCAL PLAYER FIX) =================
local function createSection(parent, name)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.98, 0, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    f.BackgroundTransparency = 0.6
    Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = "  " .. name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(0.98, 0, 0, 0)
    c.AutomaticSize = Enum.AutomaticSize.Y
    c.BackgroundTransparency = 1
    Instance.new("UIListLayout", c).Padding = UDim.new(0, 3)
    return c
end

local lpContent = createSection(homePage, "Local Player")

-- Walkspeed Display
local wsFrame = Instance.new("Frame", lpContent)
wsFrame.Size = UDim2.new(1, 0, 0, 40)
wsFrame.BackgroundTransparency = 0.8
wsFrame.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", wsFrame)

local wsLabel = Instance.new("TextLabel", wsFrame)
wsLabel.Size = UDim2.new(0.5, 0, 1, 0)
wsLabel.Text = "  Walkspeed: " .. Flags.WalkSpeed
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.BackgroundTransparency = 1
wsLabel.TextXAlignment = Enum.TextXAlignment.Left

local function createSpeedBtn(text, posX, delta)
    local b = Instance.new("TextButton", wsFrame)
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(1, posX, 0.5, -15)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags.WalkSpeed = math.clamp(Flags.WalkSpeed + delta, 0, 500)
        wsLabel.Text = "  Walkspeed: " .. Flags.WalkSpeed
    end)
end

createSpeedBtn("+", -35, 10)
createSpeedBtn("-", -70, -10)

-- Infinity Jump
local ijBtn = Instance.new("TextButton", lpContent)
ijBtn.Size = UDim2.new(1, 0, 0, 35)
ijBtn.Text = "Infinity Jump: OFF"
ijBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ijBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ijBtn)
ijBtn.MouseButton1Click:Connect(function()
    Flags.InfJump = not Flags.InfJump
    ijBtn.Text = "Infinity Jump: " .. (Flags.InfJump and "ON" or "OFF")
    ijBtn.TextColor3 = Flags.InfJump and Color3.new(0, 1, 1) or Color3.new(1,1,1)
end)

-- ================= LOGIC LOOP (WALKSPEED FIX) =================
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = Flags.WalkSpeed
            end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Text = icon .. "  " .. name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    b.BackgroundTransparency = 0.4
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
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

pages["Home"].Visible = true
