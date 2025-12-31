-- ELYSIUM HUB | REDESIGN VERSION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumPremiumUI"

-- ================= CONFIG =================
local Flags = {
    Walkspeed = 16,
    EnableWalkspeed = false,
    NoClip = false
}

-- ================= MAIN FRAME =================
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 15)
MainFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Judul "Home"
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Home"
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Container untuk List (Scrolling)
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)

-- ================= HELPER FUNCTIONS (UI BUILDER) =================

-- Fungsi Section Header (Bisa dibuka tutup)
local function createSection(name)
    local section = Instance.new("Frame", Container)
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
    section.BackgroundTransparency = 0.3
    
    local txt = Instance.new("TextLabel", section)
    txt.Size = UDim2.new(1, -40, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.Text = name
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.BackgroundTransparency = 1
    
    local arrow = Instance.new("TextLabel", section)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "v"
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.BackgroundTransparency = 1
    
    local line = Instance.new("Frame", section)
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Garis merah tipis
    line.BorderSizePixel = 0
    
    return section
end

-- Fungsi Item dengan Tombol/Input
local function createItem(name, hasSwitch, hasInput)
    local item = Instance.new("Frame", Container)
    item.Size = UDim2.new(1, 0, 0, 45)
    item.BackgroundTransparency = 0.8
    item.BackgroundColor3 = Color3.new(0,0,0)
    
    local label = Instance.new("TextLabel", item)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    if hasInput then
        local input = Instance.new("TextBox", item)
        input.Size = UDim2.new(0, 150, 0, 30)
        input.Position = UDim2.new(1, -160, 0.5, -15)
        input.PlaceholderText = "Write your input there"
        input.Text = ""
        input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        input.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", input)
    end

    if hasSwitch then
        local switchBase = Instance.new("Frame", item)
        switchBase.Size = UDim2.new(0, 40, 0, 20)
        switchBase.Position = UDim2.new(1, -50, 0.5, -10)
        switchBase.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        Instance.new("UICorner", switchBase).CornerRadius = UDim.new(1, 0)
        
        local dot = Instance.new("Frame", switchBase)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 2, 0.5, -8)
        dot.BackgroundColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    end
    
    return item
end

-- ================= BUILDING THE UI (Berdasarkan Gambar) =================

-- Section Discord
createSection("Discord")
local discInvite = createItem("Discord Invite")
local copyLabel = Instance.new("TextLabel", discInvite) -- Subtext kecil
copyLabel.Text = "Copy invite link"
copyLabel.Size = UDim2.new(0, 100, 0, 20)
copyLabel.Position = UDim2.new(0, 10, 0, 22)
copyLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
copyLabel.BackgroundTransparency = 1
copyLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Section LocalPlayer
createSection("LocalPlayer")
createItem("Set Speed", false, true) -- Item dengan input box
createItem("Enable Walkspeed", true, false) -- Item dengan switch
createItem("No Clip", true, false) -- Item dengan switch

-- ================= LOGIC (BOC) =================
-- Tambahkan fungsi looping kamu di sini seperti sebelumnya
