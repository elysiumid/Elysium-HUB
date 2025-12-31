-- ELYSIUM HUB | V11 ULTIMATE FIX
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V11"
gui.ResetOnSpawn = false

-- ================= CONFIG / FLAGS =================
local Flags = {
    WalkSpeed = 16,
    InfJump = false,
    AutoPlant = false, AutoCollect = false, AutoSell = false
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
title.Text = "ELYSIUM HUB <font color='#FF4444'>V11</font> | GARDEN"
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

-- ================= SIDEBAR & NAVIGATION =================
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

local homePage = createPage("Home")
local mainPage = createPage("Main")
local hatchPage = createPage("Auto Hatch")
local shopPage = createPage("Shop")
local invPage = createPage("Inventory")
local miscPage = createPage("Misc")
local webhookPage = createPage("Webhook")

-- ================= NEW SECTION BUILDER (FIXED) =================
local function createSection(parent, name)
    local sectionFrame = Instance.new("Frame", parent)
    sectionFrame.Size = UDim2.new(1, 0, 0, 32)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    sectionFrame.BackgroundTransparency = 0.6
    Instance.new("UICorner", sectionFrame)

    local titleBtn = Instance.new("TextButton", sectionFrame)
    titleBtn.Size = UDim2.new(1, 0, 1, 0)
    titleBtn.BackgroundTransparency = 1
    titleBtn.Text = "  " .. name
    titleBtn.TextColor3 = Color3.new(1, 1, 1)
    titleBtn.Font = Enum.Font.GothamBold
    titleBtn.TextSize = 13
    titleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", sectionFrame)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.BackgroundTransparency = 1

    local content = Instance.new("Frame", parent)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Visible = true 
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 3)

    titleBtn.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)
    return content
end

-- ================= HOME PAGE CONTENT (WALKSPEED FIX) =================
local lpContent = createSection(homePage, "Local Player")

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
        -- Update langsung saat diklik agar responsif
        pcall(function()
            player.Character.Humanoid.WalkSpeed = Flags.WalkSpeed
        end)
    end)
end
createSpeedBtn("+", -35, 10)
createSpeedBtn("-", -70, -10)

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

-- ================= LOGIC LOOP (FORCE SPEED) =================
task.spawn(function()
    while true do
        task.wait(0.05) -- Loop lebih cepat untuk melawan anticheat
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = Flags.WalkSpeed
                end
            end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump and player.Character then
        pcall(function()
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
    end
end)

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(name, icon)
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0, 120, 0, 35)
    b.Text = icon .. "  " .. name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    b.BackgroundTransparency = 0.4
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
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
