-- ELYSIUM HUB | V28 SMART SPEED (NO SPAM)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ElysiumUI_V28"
gui.ResetOnSpawn = false

-- ================= GAME DATA =================
local SeedList = {
    "Carrot", "Strawberry", "Blueberry", "Buttercup", "Tomato", "Corn",
    "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut",
    "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper",
    "Cacao", "Sunflower", "Beanstalk", "Ember Lily", "Sugar Apple",
    "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco",
    "Crimson Thorn", "Zebrazinkle", "Octobloom", "Firework Fern"
}
local EggList = {"Common Egg", "Uncommon Egg", "Rare Egg", "Epic Egg", "Legendary Egg", "Mythic Egg"} 
local PetList = {"Cat", "Dog", "Bunny", "Bear", "Dragon", "Slime", "Titan"}
local Slots = {"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6"}

-- ================= CONFIGURATION =================
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local Remotes = {
    Buy = GameEvents:WaitForChild("BuySeedStock"),
    Plant = GameEvents:FindFirstChild("PlantSeed") or GameEvents:FindFirstChild("PlaceItem"),
    Harvest = GameEvents:FindFirstChild("HarvestPlant") or GameEvents:FindFirstChild("Collect"),
    Water = GameEvents:FindFirstChild("WaterPlant"),
    Sell = GameEvents:FindFirstChild("SellItems"),
    Equip = GameEvents:FindFirstChild("EquipPet")
}

local Flags = {
    WalkSpeed = 16, InfJump = false,
    -- FARMING
    AutoPlant = false, SelectedSeed = SeedList[1], PlantPos = "Player Location",
    AutoCollect = false, SelectedCollect = "", SelectedMutation = "",
    AutoWater = false, SelectedWater = "",
    AutoShovel = false, ShovelFruit = "", ShovelPlant = "", ShovelSprinkler = "",
    AutoSellAll = false,
    -- HATCHING & PETS
    AutoPlaceEgg = false, SelectedEggPlace = EggList[1], EggPosition = "Random", EggAmount = "1",
    AutoHatch = false, SelectedEggHatch = EggList[1], HatchMaxWeight = "", HatchMaxAge = "", BlacklistPet = "",
    AutoSellPet = false, SelectedSellPet = "", DontSellPet = "", SellAge = "", SellWeight = "",
    -- SHOP (SMART)
    AutoBuySeeds = false, AutoBuyGear = false, AutoBuyEggs = false,
    -- MISC
    EggESP = false, FruitESP = false,
    -- TEAMS
    LoadoutPlace = "Slot 1", LoadoutHatch = "Slot 1", LoadoutSell = "Slot 1",
    TeamNameInput = "", SavedTeams = {}
}
local TeamDropdowns = {}

-- ================= UI CONSTRUCTION =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 500)
main.Position = UDim2.new(0.5, -290, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.BackgroundTransparency = 0.15
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 68, 68)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
top.BackgroundTransparency = 0.2
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELYSIUM <font color='#FF4444'>HUB</font> | V28 SMART"
title.RichText = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left

local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 55, 0, 55)
bubble.Position = UDim2.new(0, 20, 0.5, -25)
bubble.Visible = false; bubble.Text = "🧠"; bubble.BackgroundColor3 = Color3.fromRGB(255, 68, 68); Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

local function createWinBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton", top); btn.Size = UDim2.new(0, 25, 0, 25); btn.Position = UDim2.new(1, pos, 0.5, -12); btn.Text = text; btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6); btn.MouseButton1Click:Connect(callback)
end
createWinBtn("X", -35, Color3.fromRGB(200, 50, 50), function() gui:Destroy() end)
createWinBtn("–", -65, Color3.fromRGB(60, 60, 80), function() main.Visible = false; bubble.Visible = true end)
bubble.MouseButton1Click:Connect(function() main.Visible = true; bubble.Visible = false end)

local side = Instance.new("Frame", main); side.Position = UDim2.new(0, 8, 0, 55); side.Size = UDim2.new(0, 130, 1, -65); side.BackgroundTransparency = 1; Instance.new("UIListLayout", side).Padding = UDim.new(0, 5)
local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 145, 0, 55); container.Size = UDim2.new(1, -155, 1, -65); container.BackgroundTransparency = 1
local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", p).Padding = UDim.new(0, 6); pages[name] = p; return p
end

-- ================= UI HELPERS =================
local function createSection(parent, name, defaultVisible)
    local sectionContainer = Instance.new("Frame", parent); sectionContainer.Size = UDim2.new(0.98, 0, 0, 0); sectionContainer.AutomaticSize = Enum.AutomaticSize.Y; sectionContainer.BackgroundTransparency = 1
    local f = Instance.new("Frame", sectionContainer); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundColor3 = Color3.fromRGB(255, 68, 68); f.BackgroundTransparency = 0.65; Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = "  " .. name; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = Instance.new("TextLabel", f); arrow.Size = UDim2.new(0, 35, 1, 0); arrow.Position = UDim2.new(1, -35, 0, 0); arrow.Text = (defaultVisible and "▼" or "▶"); arrow.TextColor3 = Color3.new(1, 1, 1); arrow.BackgroundTransparency = 1
    local content = Instance.new("Frame", sectionContainer); content.Size = UDim2.new(1, 0, 0, 0); content.Position = UDim2.new(0, 0, 0, 38); content.AutomaticSize = Enum.AutomaticSize.Y; content.BackgroundTransparency = 1; content.Visible = defaultVisible or false; Instance.new("UIListLayout", content).Padding = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function() content.Visible = not content.Visible; arrow.Text = content.Visible and "▼" or "▶" end)
    return content
end

local function createRow(parent, text, type, flag, options)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.98, 0, 0, 35); f.BackgroundColor3 = Color3.fromRGB(30, 30, 40); f.BackgroundTransparency = 0.5; Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.4, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(210, 210, 210); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left; l.Font = Enum.Font.Gotham
    if type == "Toggle" then
        local sw = Instance.new("TextButton", f); sw.Size = UDim2.new(0, 40, 0, 20); sw.Position = UDim2.new(1, -50, 0.5, -10); sw.BackgroundColor3 = Color3.fromRGB(50, 50, 60); sw.Text = ""; Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", sw); dot.Size = UDim2.new(0, 16, 0, 16); dot.Position = UDim2.new(0, 2, 0.5, -8); dot.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", dot)
        sw.MouseButton1Click:Connect(function() Flags[flag] = not Flags[flag]; TweenService:Create(dot, TweenInfo.new(0.2), {Position = Flags[flag] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play(); TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = Flags[flag] and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(50, 50, 60)}):Play() end)
    elseif type == "Search" or type == "Input" then
        local input = Instance.new("TextBox", f); input.Size = UDim2.new(0, 120, 0, 24); input.Position = UDim2.new(1, -10, 0.5, -12); input.AnchorPoint = Vector2.new(1, 0); input.PlaceholderText = options and options[1] or "Type..."; input.Text = ""; input.BackgroundColor3 = Color3.fromRGB(20, 20, 25); input.TextColor3 = Color3.new(1, 1, 1); input.Font = Enum.Font.Gotham; input.TextSize = 11; Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4); input.FocusLost:Connect(function() Flags[flag] = input.Text end)
    elseif type == "Cycle" then
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 120, 0, 24); btn.Position = UDim2.new(1, -10, 0.5, -12); btn.AnchorPoint = Vector2.new(1, 0); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); btn.Text = options[1]; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.Gotham; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); local idx = 1; btn.MouseButton1Click:Connect(function() idx = idx % #options + 1; Flags[flag] = options[idx]; btn.Text = Flags[flag] end)
    elseif type == "DualInput" then
        local box1 = Instance.new("TextBox", f); box1.Size = UDim2.new(0, 55, 0, 24); box1.Position = UDim2.new(1, -70, 0.5, -12); box1.AnchorPoint = Vector2.new(1, 0); box1.PlaceholderText = options[2]; box1.BackgroundColor3 = Color3.fromRGB(20, 20, 25); box1.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", box1).CornerRadius = UDim.new(0, 4); box1.FocusLost:Connect(function() Flags[flag[2]] = box1.Text end)
        local box2 = Instance.new("TextBox", f); box2.Size = UDim2.new(0, 55, 0, 24); box2.Position = UDim2.new(1, -130, 0.5, -12); box2.AnchorPoint = Vector2.new(1, 0); box2.PlaceholderText = options[1]; box2.BackgroundColor3 = Color3.fromRGB(20, 20, 25); box2.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", box2).CornerRadius = UDim.new(0, 4); box2.FocusLost:Connect(function() Flags[flag[1]] = box2.Text end)
    elseif type == "Button" then
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 120, 0, 24); btn.Position = UDim2.new(1, -10, 0.5, -12); btn.AnchorPoint = Vector2.new(1, 0); btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50); btn.Text = options[1]; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); btn.MouseButton1Click:Connect(function() options[2]() end)
    end
end

local function createDropdown(parent, name, listItems, flag, isTeam)
    local container = Instance.new("Frame", parent); container.Size = UDim2.new(0.98, 0, 0, 35); container.AutomaticSize = Enum.AutomaticSize.Y; container.BackgroundTransparency = 1
    local header = Instance.new("TextButton", container); header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundColor3 = Color3.fromRGB(35, 35, 45); header.BackgroundTransparency = 0.5; header.Text = ""; Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", header); lbl.Size = UDim2.new(0.5, 0, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(210,210,210); lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.BackgroundTransparency = 1
    local selectedLbl = Instance.new("TextLabel", header); selectedLbl.Size = UDim2.new(0.4, 0, 1, 0); selectedLbl.Position = UDim2.new(1, -35, 0, 0); selectedLbl.AnchorPoint = Vector2.new(1,0); selectedLbl.Text = "Select..."; selectedLbl.TextColor3 = Color3.fromRGB(255, 68, 68); selectedLbl.Font = Enum.Font.Gotham; selectedLbl.TextXAlignment = Enum.TextXAlignment.Right; selectedLbl.BackgroundTransparency = 1
    local arrow = Instance.new("TextLabel", header); arrow.Size = UDim2.new(0, 30, 1, 0); arrow.Position = UDim2.new(1, 0, 0, 0); arrow.AnchorPoint = Vector2.new(1,0); arrow.Text = "▼"; arrow.TextColor3 = Color3.new(1,1,1); arrow.BackgroundTransparency = 1
    local content = Instance.new("Frame", container); content.Size = UDim2.new(1, 0, 0, 150); content.Position = UDim2.new(0, 0, 0, 40); content.BackgroundColor3 = Color3.fromRGB(25, 25, 30); content.Visible = false; Instance.new("UICorner", content)
    local search = Instance.new("TextBox", content); search.Size = UDim2.new(1, -10, 0, 25); search.Position = UDim2.new(0, 5, 0, 5); search.PlaceholderText = "Search..."; search.BackgroundColor3 = Color3.fromRGB(40, 40, 50); search.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", search)
    local scroll = Instance.new("ScrollingFrame", content); scroll.Size = UDim2.new(1, -10, 1, -35); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 2; local listLayout = Instance.new("UIListLayout", scroll); listLayout.Padding = UDim.new(0, 2)
    local function refreshList(filter, items)
        for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local targetList = items or listItems
        for _, item in pairs(targetList) do
            if filter == "" or string.find(string.lower(item), string.lower(filter)) then
                local b = Instance.new("TextButton", scroll); b.Size = UDim2.new(1, 0, 0, 25); b.BackgroundTransparency = 1; b.Text = item; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Gotham
                b.MouseButton1Click:Connect(function() Flags[flag] = item; selectedLbl.Text = item; content.Visible = false end)
            end
        end
    end
    refreshList("")
    search:GetPropertyChangedSignal("Text"):Connect(function() refreshList(search.Text, isTeam and Flags.SavedTeams or nil) end)
    header.MouseButton1Click:Connect(function() content.Visible = not content.Visible; arrow.Text = content.Visible and "▲" or "▼" end)
    if isTeam then table.insert(TeamDropdowns, function() refreshList("", Flags.SavedTeams) end) end
end

-- ================= PAGES =================
local homePage = createPage("Home"); local mainPage = createPage("Main"); local hatchPage = createPage("Auto Hatch"); local shopPage = createPage("Shop"); local invPage = createPage("Inventory"); local miscPage = createPage("Misc"); local webhookPage = createPage("Webhook")

-- HOME
local lp = createSection(homePage, "Local Player", true)
createRow(lp, "Infinite Jump", "Toggle", "InfJump")
local wsRow = Instance.new("Frame", lp); wsRow.Size = UDim2.new(0.98,0,0,35); wsRow.BackgroundTransparency = 1; local wsL = Instance.new("TextLabel", wsRow); wsL.Size = UDim2.new(0.4,0,1,0); wsL.Position = UDim2.new(0,12,0,0); wsL.Text = "Walkspeed: 16"; wsL.TextColor3 = Color3.new(1,1,1); wsL.BackgroundTransparency = 1; wsL.Font = Enum.Font.Gotham; wsL.TextXAlignment = Enum.TextXAlignment.Left; local function addWS(t, x, d) local b = Instance.new("TextButton", wsRow); b.Size = UDim2.new(0,24,0,24); b.Position = UDim2.new(1,x,0.5,-12); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(50,50,60); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner",b); b.MouseButton1Click:Connect(function() Flags.WalkSpeed = math.clamp(Flags.WalkSpeed + d, 16, 500); wsL.Text = "Walkspeed: "..Flags.WalkSpeed end) end; addWS("+", -34, 10); addWS("-", -65, -10)

-- MAIN
local plantS = createSection(mainPage, "Auto Plant Seed", true); createDropdown(plantS, "Select Seed", SeedList, "SelectedSeed"); createRow(plantS, "Plant Position", "Cycle", "PlantPos", {"Player", "Random"}); createRow(plantS, "Enable Auto Plant", "Toggle", "AutoPlant")
local collectS = createSection(mainPage, "Auto Collect", false); createRow(collectS, "Search Plant", "Search", "SelectedCollect"); createRow(collectS, "Search Mutation", "Search", "SelectedMutation"); createRow(collectS, "Enable Auto Collect", "Toggle", "AutoCollect")
local waterS = createSection(mainPage, "Auto Water", false); createRow(waterS, "Search Target", "Search", "SelectedWater"); createRow(waterS, "Enable Auto Water", "Toggle", "AutoWater")
local shovelS = createSection(mainPage, "Auto Shovel", false); createRow(shovelS, "Search Fruit", "Search", "ShovelFruit"); createRow(shovelS, "Search Plant", "Search", "ShovelPlant"); createRow(shovelS, "Search Sprinkler", "Search", "ShovelSprinkler"); createRow(shovelS, "Enable Auto Shovel", "Toggle", "AutoShovel")
local sellS = createSection(mainPage, "Auto Sell Plant", false); createRow(sellS, "Auto Sell All", "Toggle", "AutoSellAll")

-- HATCH
local loadoutS = createSection(hatchPage, "Auto Pet Loadout", true); createRow(loadoutS, "Place", "Cycle", "LoadoutPlace", Slots); createRow(loadoutS, "Hatch", "Cycle", "LoadoutHatch", Slots); createRow(loadoutS, "Sell", "Cycle", "LoadoutSell", Slots)
local teamMakeS = createSection(hatchPage, "Pet Team Manager", false); createRow(teamMakeS, "Team Name", "Input", "TeamNameInput", {"My Team 1"}); createRow(teamMakeS, "Save Current Team", "Button", nil, {"SAVE TEAM", function() if Flags.TeamNameInput ~= "" then table.insert(Flags.SavedTeams, Flags.TeamNameInput); for _, func in pairs(TeamDropdowns) do func() end end end}); createDropdown(teamMakeS, "Select Team List", Flags.SavedTeams, "SelectedTeamSpawn", true); createRow(teamMakeS, "Action", "Button", nil, {"SPAWN TEAM", function() if Remotes.Equip then Remotes.Equip:FireServer(Flags.SelectedTeamSpawn) end end})
local placeEggS = createSection(hatchPage, "Auto Place Egg", false); createDropdown(placeEggS, "Select Egg", EggList, "SelectedEggPlace"); createRow(placeEggS, "Position", "Cycle", "EggPosition", {"Random", "Good Position"}); createRow(placeEggS, "Amount", "Input", "EggAmount", {"Amount..."}); createRow(placeEggS, "Enable Place Egg", "Toggle", "AutoPlaceEgg")
local hatchEggS = createSection(hatchPage, "Auto Hatch Egg", false); createDropdown(hatchEggS, "Select Egg", EggList, "SelectedEggHatch"); createRow(hatchEggS, "Don't Hatch", "DualInput", {"HatchMaxWeight", "HatchMaxAge"}, {"KG", "Age"}); createDropdown(hatchEggS, "Blacklist Pet", PetList, "BlacklistPet"); createRow(hatchEggS, "Enable Auto Hatch", "Toggle", "AutoHatch")
local sellPetS = createSection(hatchPage, "Auto Sell Pet", false); createDropdown(sellPetS, "Select Pet to Sell", PetList, "SelectedSellPet"); createDropdown(sellPetS, "Don't Sell Pet", PetList, "DontSellPet"); createRow(sellPetS, "Threshold", "DualInput", {"SellWeight", "SellAge"}, {"KG", "Age"}); createRow(sellPetS, "Enable Sell Pet", "Toggle", "AutoSellPet")

-- SHOP
local shopS = createSection(shopPage, "Shop Automation", true); createRow(shopS, "Auto Buy All Seeds", "Toggle", "AutoBuySeeds"); createRow(shopS, "Auto Buy All Gear", "Toggle", "AutoBuyGear"); createRow(shopS, "Auto Buy All Eggs", "Toggle", "AutoBuyEggs")

-- MISC (ESP RESTORED)
local espS = createSection(miscPage, "ESP Visuals", true)
createRow(espS, "Egg ESP", "Toggle", "EggESP")
createRow(espS, "Fruit ESP", "Toggle", "FruitESP")

local function sideBtn(name, icon) local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.BackgroundTransparency = 0.5; b.Text = "  " .. icon .. "  " .. name; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); b.MouseButton1Click:Connect(function() for _, p in pairs(pages) do p.Visible = false end; pages[name].Visible = true end) end
sideBtn("Home", "🏠"); sideBtn("Main", "🔥"); sideBtn("Auto Hatch", "🥚"); sideBtn("Shop", "🛒"); sideBtn("Inventory", "📦"); sideBtn("Misc", "⚙️"); sideBtn("Webhook", "🔗"); pages["Home"].Visible = true

-- =========================================================================
-- =================== SMART CHECK & SPEED BUY =============================
-- =========================================================================

-- FUNGSI PENDETEKSI STOK PINTAR
-- Script akan membaca "PlayerGui" secara diam-diam.
-- Jika nama item terdeteksi, baru dia membeli.
-- INI ADALAH KUNCI AGAR TIDAK SPAM ERROR
local function IsItemInStock(itemName)
    local found = false
    pcall(function()
        -- Cari di seluruh UI (bahkan jika tidak visible)
        for _, v in pairs(player.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                if v.Text == itemName then
                    found = true
                    break
                end
            end
        end
    end)
    return found
end

-- AUTO BUY (SMART + FAST)
task.spawn(function()
    while task.wait(0.1) do -- Cek cepat
        if Remotes.Buy then
            -- SEEDS
            if Flags.AutoBuySeeds then
                for _, seed in pairs(SeedList) do
                    -- HANYA BELI JIKA TERDETEKSI DI GUI
                    if IsItemInStock(seed) then
                         Remotes.Buy:FireServer("Shop", seed)
                    end
                end
            end
            -- TAMBAHKAN LOGIKA EGG/GEAR DI SINI JIKA MAU
        end
    end
end)

-- AUTO FARM (INSTANT LOOP)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() -- SINKRON DENGAN FPS (TERCEPAT)
        
        if Flags.AutoPlant and Flags.SelectedSeed ~= "" and Remotes.Plant then
            local gardens = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Gardens")
            if gardens then
                for _, plot in pairs(gardens:GetChildren()) do
                    if not plot:FindFirstChild("Plant") then
                        Remotes.Plant:FireServer(Flags.SelectedSeed, plot)
                    end
                end
            end
        end

        if Flags.AutoCollect and Remotes.Harvest then
            local gardens = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Gardens")
            if gardens then
                for _, plot in pairs(gardens:GetChildren()) do
                    Remotes.Harvest:FireServer(plot)
                end
            end
        end
    end
end)

-- ESP LOGIC
task.spawn(function()
    while task.wait(1) do
        if Flags.EggESP or Flags.FruitESP then
            local drops = workspace:FindFirstChild("Drops")
            if drops then
                for _, v in pairs(drops:GetChildren()) do
                    if not v:FindFirstChild("ESP") then
                        local bg = Instance.new("BillboardGui", v); bg.Name="ESP"; bg.Size=UDim2.new(0,50,0,50); bg.AlwaysOnTop=true
                        local t = Instance.new("TextLabel", bg); t.Size=UDim2.new(1,0,1,0); t.BackgroundTransparency=1; t.Text=v.Name; t.TextColor3=Color3.new(0,1,0)
                    end
                end
            end
        end
    end
end)

-- WALKSPEED
task.spawn(function() while task.wait() do if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = Flags.WalkSpeed end end end)
