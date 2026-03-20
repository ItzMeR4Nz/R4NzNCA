--[[
    SPYMM v5.0 - Blutiger (Mobile Optimized with Full Features)
    Author: Spy
    Version: 5.0
    Features: 
    - ESP (Mob & Item with Filter)
    - Auto Pickup (3 Mode: Direct/Backpack/Both)
    - Speed Hack with Auto Fix
    - Infinite Jump
    - Unlimited Ammo
    - Rate of Fire Brutal
    - Auto Drop Ammo (Pistol/Medium/Long)
    - Mobile Optimized (Touch Support)
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TouchEnabled = UserInputService.TouchEnabled
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Lokaler Spieler
local LocalPlayer = Players.LocalPlayer

-- Remotes
local adjustBackpackRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Tools") and ReplicatedStorage.Remotes.Tools:FindFirstChild("AdjustBackpack")
local pickUpItemRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Interaction") and ReplicatedStorage.Remotes.Interaction:FindFirstChild("PickUpItem")
local dropItemRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Inventory") and ReplicatedStorage.Remotes.Inventory:FindFirstChild("DropItem")

-- GUI Container
local guiContainer = CoreGui
local success, _err = pcall(function()
    return CoreGui:FindFirstChild("SPYMM")
end)
if not success or not guiContainer then
    guiContainer = LocalPlayer:WaitForChild("PlayerGui")
end

-- Haupt-GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SPYMM"
ScreenGui.Parent = guiContainer
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Hauptfenster – responsive size for mobile
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
local screenSize = workspace.CurrentCamera.ViewportSize
local frameWidth = math.min(450, screenSize.X - 40)
local frameHeight = math.min(550, screenSize.Y - 40)
MainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
MainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Variable untuk status minimize
local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, originalSize.X.Offset, 0, 45)

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(139, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Titel-Leiste
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Blutroter Streifen
local BloodLine = Instance.new("Frame")
BloodLine.Name = "BloodLine"
BloodLine.Size = UDim2.new(1, 0, 0, 2)
BloodLine.Position = UDim2.new(0, 0, 1, -2)
BloodLine.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
BloodLine.BorderSizePixel = 0
BloodLine.Parent = TopBar

-- Titel
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SPYMM v5.0"
Title.TextColor3 = Color3.fromRGB(180, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = TouchEnabled and 18 or 22
Title.Parent = TopBar

-- Minimalkan-Button
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, TouchEnabled and 35 or 30, 0, TouchEnabled and 35 or 30)
MinimizeButton.Position = UDim2.new(1, TouchEnabled and -75 or -70, 0.5, -15)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
MinimizeButton.BorderSizePixel = 1
MinimizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.Image = "rbxassetid://10747383583"
MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = TopBar

-- Schließen-Button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, TouchEnabled and 35 or 30, 0, TouchEnabled and 35 or 30)
CloseButton.Position = UDim2.new(1, TouchEnabled and -35 or -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
CloseButton.BorderSizePixel = 1
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.Image = "rbxassetid://10747383594"
CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TopBar

-- Container untuk konten yang akan di-minimize
local ContentWrapper = Instance.new("Frame")
ContentWrapper.Name = "ContentWrapper"
ContentWrapper.Size = UDim2.new(1, 0, 1, -45)
ContentWrapper.Position = UDim2.new(0, 0, 0, 45)
ContentWrapper.BackgroundTransparency = 1
ContentWrapper.Parent = MainFrame

-- Minimize-Funktion
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = minimizedSize})
        sizeTween:Play()
        ContentWrapper.Visible = false
        MinimizeButton.Image = "rbxassetid://10747383595"
        StatusText.Text = "SPYMM minimized"
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = originalSize})
        sizeTween:Play()
        task.wait(0.3)
        ContentWrapper.Visible = true
        MinimizeButton.Image = "rbxassetid://10747383583"
        StatusText.Text = "SPYMM restored"
    end
end)

-- Close-Funktion
CloseButton.MouseButton1Click:Connect(function()
    unloadAll()
end)

-- Drag functionality dengan touch support
local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Statusleiste
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(1, 0, 0, 30)
StatusBar.Position = UDim2.new(0, 0, 1, -30)
StatusBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = ContentWrapper

local BloodLineTop = Instance.new("Frame")
BloodLineTop.Name = "BloodLineTop"
BloodLineTop.Size = UDim2.new(1, 0, 0, 2)
BloodLineTop.Position = UDim2.new(0, 0, 0, 0)
BloodLineTop.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
BloodLineTop.BorderSizePixel = 0
BloodLineTop.Parent = StatusBar

local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1, -15, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Ready"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = TouchEnabled and 12 or 14
StatusText.Parent = StatusBar

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 0, TouchEnabled and 45 or 50)
TabContainer.Position = UDim2.new(0, 10, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = ContentWrapper

local tabButtons = {}
local tabFrames = {}
local tabs = {"Visuals", "Player", "Exploits", "Ammo", "Misc", "Info"}
local currentTab = "Visuals"

local function createTabButton(tabName, pos)
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    local btnWidth = math.min(110, (TabContainer.AbsoluteSize.X - 20) / #tabs)
    button.Size = UDim2.new(0, btnWidth, 1, 0)
    button.Position = UDim2.new(0, (pos-1) * (btnWidth + 5), 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(139, 0, 0)
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamBold
    button.TextSize = TouchEnabled and 12 or 14
    button.Parent = TabContainer

    button.MouseEnter:Connect(function()
        if currentTab ~= tabName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {BorderColor3 = Color3.fromRGB(200, 0, 0)}):Play()
        end
    end)
    button.MouseLeave:Connect(function()
        if currentTab ~= tabName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {BorderColor3 = Color3.fromRGB(139, 0, 0)}):Play()
        end
    end)

    return button
end

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -(TabContainer.Size.Y.Offset + StatusBar.Size.Y.Offset + 20))
ContentContainer.Position = UDim2.new(0, 10, 0, TabContainer.Size.Y.Offset + 15)
ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ContentContainer.BorderSizePixel = 2
ContentContainer.BorderColor3 = Color3.fromRGB(139, 0, 0)
ContentContainer.Parent = ContentWrapper

-- Tabs erstellen
for i, tabName in ipairs(tabs) do
    local btn = createTabButton(tabName, i)
    tabButtons[tabName] = btn

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -20)
    contentFrame.Position = UDim2.new(0, 10, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = TouchEnabled and 4 or 8
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false
    contentFrame.Parent = ContentContainer

    tabFrames[tabName] = contentFrame
end

-- Default Tab
currentTab = "Visuals"
tabFrames[currentTab].Visible = true
tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabButtons[currentTab].BorderColor3 = Color3.fromRGB(200, 0, 0)

-- Tab Switching
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        if currentTab == tabName then return end
        tabFrames[currentTab].Visible = false
        tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        tabButtons[currentTab].BorderColor3 = Color3.fromRGB(139, 0, 0)
        currentTab = tabName
        tabFrames[currentTab].Visible = true
        tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButtons[currentTab].BorderColor3 = Color3.fromRGB(200, 0, 0)
    end)
end

-- ========== Globale Variablen ==========
local connections = {}
local mobESPInstances = {}
local itemESPInstances = {}
local originalValues = {
    walkSpeed = nil,
    infJumpActive = false
}

-- ========== ESP Optionen ==========
local mobOptions = {
    ESP = false,
    Chams = false,
    Name = false,
    Distance = false
}

local itemOptions = {
    ESP = false,
    Chams = false,
    Name = false,
    Distance = false
}

-- ESP Item Filter
local espItemFilter = {}
local espAllItems = false

-- Ziel-Namen für Mobs
local mobNames = {"Runner", "Crawler", "Riot", "Zombie"}

-- ========== Item List Lengkap ==========
local itemNames = {
    -- Medical Items
    "Bandage", "Medkit", "Painkillers", "Antidote", "Blood Bag", "Splint",
    -- Food & Drinks
    "Beans", "Bloxiade", "Bloxy Cola", "Water Bottle", "Canned Food", "MRE", "Energy Drink",
    -- Weapons & Melee
    "Knife", "Machete", "Katana", "Baseball Bat", "Crowbar", "Spatula", "Golf Club", "Axe",
    -- Guns & Ammo
    "Pistol", "Revolver", "Shotgun", "Rifle", "SMG",
    "Pistol Ammo", "Revolver Ammo", "Shotgun Shells", "Rifle Ammo", "SMG Ammo",
    "Long Ammo", "Medium Ammo", "Shells",
    -- Explosives
    "Grenade", "Molotov", "C4",
    -- Building Materials
    "Wood", "Metal", "Nails", "Screws", "Scrap", "Barbed Wire",
    -- Electronics
    "Battery", "Wire", "Circuit Board", "Radio",
    -- Vehicle Parts
    "Fuel", "Engine Parts", "Tire",
    -- Tools
    "Hammer", "Wrench", "Screwdriver", "Flashlight", "Lighter",
    -- Special Items
    "Keycard", "Lockpick", "Binoculars", "Gas Mask",
    -- Miscellaneous
    "Tray", "Compound I", "Dumbell"
}

-- Hapus duplikat
local uniqueItemNames = {}
for _, name in ipairs(itemNames) do
    uniqueItemNames[name] = true
end
local finalItemNames = {}
for name, _ in pairs(uniqueItemNames) do
    table.insert(finalItemNames, name)
end
table.sort(finalItemNames)

-- Daftar item makanan (akan di-pickup, tidak dimakan otomatis)
local foodItems = {
    "Beans", "Bloxiade", "Bloxy Cola", "Water Bottle", "Canned Food", "MRE", "Energy Drink"
}

-- Fungsi untuk cek apakah item makanan
local function isFoodItem(itemName)
    for _, food in ipairs(foodItems) do
        if itemName == food then
            return true
        end
    end
    return false
end

-- Ordner
local charactersFolder = Workspace:FindFirstChild("Characters")
local droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")

-- ========== Hilfsfunktionen für ESP ==========
local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

local function removeMobESP(char)
    local esp = mobESPInstances[char]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then
            esp.DistanceConnection:Disconnect()
        end
        mobESPInstances[char] = nil
    end
end

local function removeItemESP(item)
    local esp = itemESPInstances[item]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then
            esp.DistanceConnection:Disconnect()
        end
        itemESPInstances[item] = nil
    end
end

local function createMobESP(char)
    if not char:IsA("Model") then return end
    if mobESPInstances[char] then return end

    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end

    local espTable = {}

    if mobOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(220, 0, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 185, 185)
        highlight.OutlineTransparency = 0.8
        highlight.Parent = char
        espTable.Highlight = highlight
    end

    if mobOptions.Name or mobOptions.Distance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MobESP_NameDistance"
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = char.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = mobOptions.Name
        nameLabel.Parent = frame

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.TextStrokeTransparency = 0.3
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = mobOptions.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent then
                connection:Disconnect()
                return
            end
            if distLabel and distLabel.Visible then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                if myRoot then
                    local dist = (myRoot.Position - root.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. "m"
                end
            end
        end)
        espTable.DistanceConnection = connection
        table.insert(connections, connection)
    end

    mobESPInstances[char] = espTable
end

local function createItemESP(item)
    if not item:IsA("Model") then return end
    if itemESPInstances[item] then return end
    
    -- Cek filter ESP Item
    if not espAllItems and not espItemFilter[item.Name] then return end

    local mainPart = getItemMainPart(item)
    if not mainPart then return end

    local espTable = {}

    if itemOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ItemESP_Highlight"
        highlight.Adornee = item
        highlight.FillColor = Color3.fromRGB(255, 0, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(200, 180, 255)
        highlight.OutlineTransparency = 0.8
        highlight.Parent = item
        espTable.Highlight = highlight
    end

    if itemOptions.Name or itemOptions.Distance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ItemESP_NameDistance"
        billboard.Adornee = mainPart
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = item

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = item.Name
        nameLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = itemOptions.Name
        nameLabel.Parent = frame

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.TextStrokeTransparency = 0.3
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = itemOptions.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not item or not item.Parent then
                connection:Disconnect()
                return
            end
            if distLabel and distLabel.Visible then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                if myRoot then
                    local dist = (myRoot.Position - mainPart.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. "m"
                end
            end
        end)
        espTable.DistanceConnection = connection
        table.insert(connections, connection)
    end

    itemESPInstances[item] = espTable
end

local function refreshMobESP()
    for char, _ in pairs(mobESPInstances) do
        removeMobESP(char)
    end
    if not mobOptions.ESP then return end
    if not charactersFolder then
        StatusText.Text = "Status: Characters folder not found"
        return
    end
    for _, child in ipairs(charactersFolder:GetChildren()) do
        if table.find(mobNames, child.Name) then
            createMobESP(child)
        end
    end
end

local function refreshItemESP()
    for item, _ in pairs(itemESPInstances) do
        removeItemESP(item)
    end
    if not itemOptions.ESP then return end
    if not droppedItemsFolder then
        StatusText.Text = "Status: DroppedItems folder not found"
        return
    end
    for _, child in ipairs(droppedItemsFolder:GetChildren()) do
        if espAllItems or espItemFilter[child.Name] then
            createItemESP(child)
        end
    end
end

-- Listener für Mobs
if charactersFolder then
    local childAddedConn = charactersFolder.ChildAdded:Connect(function(child)
        if mobOptions.ESP and table.find(mobNames, child.Name) then
            createMobESP(child)
        end
    end)
    table.insert(connections, childAddedConn)

    local childRemovedConn = charactersFolder.ChildRemoved:Connect(function(child)
        removeMobESP(child)
    end)
    table.insert(connections, childRemovedConn)
end

-- Listener für Items
if droppedItemsFolder then
    local childAddedConn = droppedItemsFolder.ChildAdded:Connect(function(child)
        if itemOptions.ESP and (espAllItems or espItemFilter[child.Name]) then
            createItemESP(child)
        end
    end)
    table.insert(connections, childAddedConn)

    local childRemovedConn = droppedItemsFolder.ChildRemoved:Connect(function(child)
        removeItemESP(child)
    end)
    table.insert(connections, childRemovedConn)
end

-- ========== GUI Hilfsfunktionen ==========
local function createToggleButton(parent, text, initialValue, callback, yPos, width)
    width = width or 160
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, TouchEnabled and 36 or 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = initialValue and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = text .. ": " .. (initialValue and "On" or "Off")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = TouchEnabled and 13 or 14
    btn.Parent = parent

    local normalColor = btn.BackgroundColor3
    local hoverColor = normalColor:Lerp(Color3.fromRGB(139, 0, 0), 0.3)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)

    local state = initialValue
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "On" or "Off")
        local newColor = state and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
        btn.BackgroundColor3 = newColor
        normalColor = newColor
        hoverColor = newColor:Lerp(Color3.fromRGB(139, 0, 0), 0.3)
        callback(state)
    end)
    return btn, state
end

local function createGroup(parent, title, yOffset, buttonCount)
    local groupHeight = 45 + buttonCount * (TouchEnabled and 39 or 37)
    local group = Instance.new("Frame")
    group.Name = title .. "Group"
    group.Size = UDim2.new(1, -20, 0, groupHeight)
    group.Position = UDim2.new(0, 10, 0, yOffset)
    group.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    group.BorderSizePixel = 2
    group.BorderColor3 = Color3.fromRGB(139, 0, 0)
    group.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = TouchEnabled and 15 or 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = group

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 2)
    line.Position = UDim2.new(0, 10, 0, 35)
    line.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    line.BorderSizePixel = 0
    line.Parent = group

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 1, -45)
    buttonContainer.Position = UDim2.new(0, 10, 0, 40)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = group

    return group, buttonContainer
end

-- ========== Visuals Tab ==========
local visuals = tabFrames["Visuals"]
local yOffsetVis = 5

-- Mob ESP Gruppe
local mobGroup, mobContainer = createGroup(visuals, "Mob ESP", yOffsetVis, 4)
yOffsetVis = yOffsetVis + mobGroup.Size.Y.Offset + 10

local _mobESPBtn, _mobESPState = createToggleButton(mobContainer, "Mob ESP", mobOptions.ESP, function(state)
    mobOptions.ESP = state
    refreshMobESP()
    StatusText.Text = state and "Mob ESP enabled" or "Mob ESP disabled"
end, 0, 140)

local subY = 40
local _mobChamsBtn, _mobChamsState = createToggleButton(mobContainer, "Chams", mobOptions.Chams, function(state)
    mobOptions.Chams = state
    refreshMobESP()
end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)

local _mobNameBtn, _mobNameState = createToggleButton(mobContainer, "Name", mobOptions.Name, function(state)
    mobOptions.Name = state
    refreshMobESP()
end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)

local _mobDistBtn, _mobDistState = createToggleButton(mobContainer, "Distance", mobOptions.Distance, function(state)
    mobOptions.Distance = state
    refreshMobESP()
end, subY, 100)

-- Item ESP Gruppe
local itemGroup, itemContainer = createGroup(visuals, "Item ESP", yOffsetVis, 4)
yOffsetVis = yOffsetVis + itemGroup.Size.Y.Offset + 10

local _itemESPBtn, _itemESPState = createToggleButton(itemContainer, "Item ESP", itemOptions.ESP, function(state)
    itemOptions.ESP = state
    refreshItemESP()
    StatusText.Text = state and "Item ESP enabled" or "Item ESP disabled"
end, 0, 140)

subY = 40
local _itemChamsBtn, _itemChamsState = createToggleButton(itemContainer, "Chams", itemOptions.Chams, function(state)
    itemOptions.Chams = state
    refreshItemESP()
end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)

local _itemNameBtn, _itemNameState = createToggleButton(itemContainer, "Name", itemOptions.Name, function(state)
    itemOptions.Name = state
    refreshItemESP()
end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)

local _itemDistBtn, _itemDistState = createToggleButton(itemContainer, "Distance", itemOptions.Distance, function(state)
    itemOptions.Distance = state
    refreshItemESP()
end, subY, 100)

-- ESP Item Filter Group
local espFilterGroup, espFilterContainer = createGroup(visuals, "ESP Item Filter", yOffsetVis, #finalItemNames/4 + 2)
yOffsetVis = yOffsetVis + espFilterGroup.Size.Y.Offset + 10

-- Alle Items toggle for ESP
local espAllItemsBtn = Instance.new("TextButton")
espAllItemsBtn.Size = UDim2.new(0, 140, 0, TouchEnabled and 32 or 28)
espAllItemsBtn.Position = UDim2.new(0, 5, 0, 5)
espAllItemsBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espAllItemsBtn.BorderSizePixel = 1
espAllItemsBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
espAllItemsBtn.Text = "All Items"
espAllItemsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espAllItemsBtn.Font = Enum.Font.GothamMedium
espAllItemsBtn.TextSize = TouchEnabled and 13 or 14
espAllItemsBtn.Parent = espFilterContainer

espAllItemsBtn.MouseButton1Click:Connect(function()
    espAllItems = not espAllItems
    espAllItemsBtn.BackgroundColor3 = espAllItems and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
    refreshItemESP()
end)

-- ScrollFrame for ESP item list
local espItemListFrame = Instance.new("ScrollingFrame")
espItemListFrame.Size = UDim2.new(1, -10, 0, 150)
espItemListFrame.Position = UDim2.new(0, 5, 0, 40)
espItemListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
espItemListFrame.BorderSizePixel = 1
espItemListFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
espItemListFrame.ScrollBarThickness = TouchEnabled and 4 or 6
espItemListFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
espItemListFrame.Parent = espFilterContainer

local espItemCurrentY = 5
for i, itemName in ipairs(finalItemNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, TouchEnabled and 28 or 24)
    btn.Position = UDim2.new(0, 5, 0, espItemCurrentY)
    btn.BackgroundColor3 = espItemFilter[itemName] and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = (espItemFilter[itemName] and "✓ " or "  ") .. itemName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = TouchEnabled and 11 or 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = espItemListFrame
    
    btn.MouseButton1Click:Connect(function()
        espItemFilter[itemName] = not espItemFilter[itemName]
        btn.BackgroundColor3 = espItemFilter[itemName] and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
        btn.Text = (espItemFilter[itemName] and "✓ " or "  ") .. itemName
        refreshItemESP()
    end)
    
    espItemCurrentY = espItemCurrentY + (TouchEnabled and 31 or 27)
end

espItemListFrame.CanvasSize = UDim2.new(0, 0, 0, espItemCurrentY + 10)

-- ========== Player Tab mit Auto Speed Fix ==========
local player = tabFrames["Player"]
local yOffsetPlayer = 5

local speedState = false
local targetSpeed = 50
local speedFixConnection = nil

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 180, 0, TouchEnabled and 36 or 32)
speedBtn.Position = UDim2.new(0, 5, 0, yOffsetPlayer)
speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedBtn.BorderSizePixel = 1
speedBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
speedBtn.Text = "Speed: 16"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Font = Enum.Font.GothamMedium
speedBtn.TextSize = TouchEnabled and 13 or 14
speedBtn.Parent = player

local speedNormalColor = speedBtn.BackgroundColor3

local function applySpeed()
    local char = LocalPlayer.Character
    if char and speedState then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = targetSpeed
        end
    end
end

local function setupSpeedFix()
    if speedFixConnection then
        speedFixConnection:Disconnect()
    end
    
    local function onCharacterAdded(char)
        local humanoid = char:WaitForChild("Humanoid")
        
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedState and humanoid.WalkSpeed ~= targetSpeed then
                task.wait(0.1)
                if speedState then
                    humanoid.WalkSpeed = targetSpeed
                    StatusText.Text = "Speed auto-fixed!"
                    task.wait(2)
                end
            end
        end)
        
        humanoid.Died:Connect(function()
            if speedState then
                task.wait(2)
                local newChar = LocalPlayer.Character
                if newChar and speedState then
                    local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                    if newHumanoid then
                        newHumanoid.WalkSpeed = targetSpeed
                    end
                end
            end
        end)
    end
    
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    
    speedFixConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    table.insert(connections, speedFixConnection)
end

speedBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if not speedState then
                originalValues.walkSpeed = humanoid.WalkSpeed
                targetSpeed = 50
                humanoid.WalkSpeed = targetSpeed
                speedBtn.Text = "Speed: " .. targetSpeed
                speedNormalColor = Color3.fromRGB(100, 0, 0)
                TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor}):Play()
                StatusText.Text = "Speed boost active - Auto fix enabled"
                setupSpeedFix()
            else
                humanoid.WalkSpeed = originalValues.walkSpeed or 16
                speedBtn.Text = "Speed: " .. (originalValues.walkSpeed or 16)
                speedNormalColor = Color3.fromRGB(20, 20, 20)
                TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor}):Play()
                StatusText.Text = "Speed boost inactive"
                if speedFixConnection then
                    speedFixConnection:Disconnect()
                    speedFixConnection = nil
                end
            end
            speedState = not speedState
        end
    end
end)

yOffsetPlayer = yOffsetPlayer + (TouchEnabled and 44 or 40)

local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Size = UDim2.new(0, 80, 0, 25)
speedValueLabel.Position = UDim2.new(0, 5, 0, yOffsetPlayer)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = "Speed Value:"
speedValueLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
speedValueLabel.Font = Enum.Font.Gotham
speedValueLabel.TextSize = TouchEnabled and 13 or 14
speedValueLabel.TextXAlignment = Enum.TextXAlignment.Left
speedValueLabel.Parent = player

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 80, 0, 25)
speedSlider.Position = UDim2.new(0, 100, 0, yOffsetPlayer)
speedSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedSlider.BorderSizePixel = 1
speedSlider.BorderColor3 = Color3.fromRGB(139, 0, 0)
speedSlider.Text = "50"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextSize = TouchEnabled and 13 or 14
speedSlider.Parent = player

speedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed > 0 then
        targetSpeed = newSpeed
        if speedState then
            applySpeed()
            StatusText.Text = "Speed changed to: " .. targetSpeed
        end
    else
        speedSlider.Text = tostring(targetSpeed)
    end
end)

yOffsetPlayer = yOffsetPlayer + 35

local _infJumpBtn, _infJumpState = createToggleButton(player, "Inf Jump", false, function(state)
    originalValues.infJumpActive = state
    StatusText.Text = state and "Inf Jump on" or "Inf Jump off"
end, yOffsetPlayer, 180)

local jumpConn = UserInputService.JumpRequest:Connect(function()
    if originalValues.infJumpActive then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)
table.insert(connections, jumpConn)

-- ========== Exploits Tab mit 3 Mode Auto Pickup ==========
local exploits = tabFrames["Exploits"]
local yOffsetExp = 5

local autoPickupGroup, autoPickupContainer = createGroup(exploits, "Auto Pickup", yOffsetExp, 12)
yOffsetExp = yOffsetExp + autoPickupGroup.Size.Y.Offset + 10

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0, 80, 0, 25)
modeLabel.Position = UDim2.new(0, 5, 0, 5)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Mode:"
modeLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = TouchEnabled and 13 or 14
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = autoPickupContainer

local pickupMode = Instance.new("TextButton")
pickupMode.Size = UDim2.new(0, 130, 0, TouchEnabled and 32 or 28)
pickupMode.Position = UDim2.new(0, 90, 0, 3)
pickupMode.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
pickupMode.BorderSizePixel = 1
pickupMode.BorderColor3 = Color3.fromRGB(139, 0, 0)
pickupMode.Text = "Direct"
pickupMode.TextColor3 = Color3.fromRGB(255, 255, 255)
pickupMode.Font = Enum.Font.GothamMedium
pickupMode.TextSize = TouchEnabled and 12 or 13
pickupMode.Parent = autoPickupContainer

local pickupModeType = 1
local modeNames = {"Direct", "Backpack", "Both"}
local modeColors = {
    Color3.fromRGB(20, 20, 20),
    Color3.fromRGB(80, 0, 0),
    Color3.fromRGB(100, 50, 0)
}

pickupMode.MouseButton1Click:Connect(function()
    pickupModeType = pickupModeType % 3 + 1
    pickupMode.Text = modeNames[pickupModeType]
    pickupMode.BackgroundColor3 = modeColors[pickupModeType]
    if autoPickupActive then
        StatusText.Text = "Auto Pickup - Mode: " .. modeNames[pickupModeType]
    end
end)

local startAutoPickup
local autoPickupActive = false
local _autoPickupBtn, _autoPickupState = createToggleButton(autoPickupContainer, "Auto Pickup", false, function(state)
    autoPickupActive = state
    if state then
        StatusText.Text = "Auto Pickup started - Mode: " .. modeNames[pickupModeType]
        startAutoPickup()
    else
        StatusText.Text = "Auto Pickup stopped"
    end
end, 40, 160)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0, 80, 0, 25)
radiusLabel.Position = UDim2.new(0, 5, 0, 80)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius:"
radiusLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = TouchEnabled and 13 or 14
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Parent = autoPickupContainer

local radiusInput = Instance.new("TextBox")
radiusInput.Size = UDim2.new(0, 80, 0, 25)
radiusInput.Position = UDim2.new(0, 90, 0, 80)
radiusInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
radiusInput.BorderSizePixel = 1
radiusInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
radiusInput.Text = "15"
radiusInput.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = TouchEnabled and 13 or 14
radiusInput.PlaceholderText = "15"
radiusInput.Parent = autoPickupContainer

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 80, 0, 25)
delayLabel.Position = UDim2.new(0, 5, 0, 115)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay:"
delayLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = TouchEnabled and 13 or 14
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = autoPickupContainer

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 80, 0, 25)
delayInput.Position = UDim2.new(0, 90, 0, 115)
delayInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
delayInput.BorderSizePixel = 1
delayInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
delayInput.Text = "0.05"
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = TouchEnabled and 13 or 14
delayInput.PlaceholderText = "0.05"
delayInput.Parent = autoPickupContainer

local allItemsCheckbox = Instance.new("TextButton")
allItemsCheckbox.Size = UDim2.new(0, 140, 0, TouchEnabled and 32 or 28)
allItemsCheckbox.Position = UDim2.new(0, 5, 0, 150)
allItemsCheckbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
allItemsCheckbox.BorderSizePixel = 1
allItemsCheckbox.BorderColor3 = Color3.fromRGB(139, 0, 0)
allItemsCheckbox.Text = "All Items"
allItemsCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
allItemsCheckbox.Font = Enum.Font.GothamMedium
allItemsCheckbox.TextSize = TouchEnabled and 13 or 14
allItemsCheckbox.Parent = autoPickupContainer

local allSelected = false
allItemsCheckbox.MouseButton1Click:Connect(function()
    allSelected = not allSelected
    allItemsCheckbox.BackgroundColor3 = allSelected and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
end)

local itemListFrame = Instance.new("ScrollingFrame")
itemListFrame.Size = UDim2.new(1, -10, 0, 180)
itemListFrame.Position = UDim2.new(0, 5, 0, 190)
itemListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
itemListFrame.BorderSizePixel = 1
itemListFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.ScrollBarThickness = TouchEnabled and 4 or 6
itemListFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.Parent = autoPickupContainer

local itemCheckboxes = {}
local currentItemY = 5

for i, itemName in ipairs(finalItemNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, TouchEnabled and 28 or 24)
    btn.Position = UDim2.new(0, 5, 0, currentItemY)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = "  " .. itemName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = TouchEnabled and 11 or 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = itemListFrame
    
    local selected = false
    btn.MouseButton1Click:Connect(function()
        selected = not selected
        btn.BackgroundColor3 = selected and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
        btn.Text = (selected and "✓ " or "  ") .. itemName
    end)
    
    itemCheckboxes[itemName] = function() return selected end
    currentItemY = currentItemY + (TouchEnabled and 31 or 27)
end

itemListFrame.CanvasSize = UDim2.new(0, 0, 0, currentItemY + 10)

local autoPickupConnection = nil
startAutoPickup = function()
    if autoPickupConnection then
        autoPickupConnection:Disconnect()
    end
    
    autoPickupConnection = RunService.Heartbeat:Connect(function()
        if not autoPickupActive then
            return
        end

        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local radius = tonumber(radiusInput.Text) or 15
        local delay = tonumber(delayInput.Text) or 0.05
        local pos = rootPart.Position

        if not droppedItemsFolder then return end
        
        for _, item in ipairs(droppedItemsFolder:GetChildren()) do
            if not autoPickupActive then break end
            
            if not allSelected then
                local selected = false
                for name, getter in pairs(itemCheckboxes) do
                    if item.Name == name and getter() then
                        selected = true
                        break
                    end
                end
                if not selected then continue end
            end

            local mainPart = item.PrimaryPart or getItemMainPart(item)
            if mainPart then
                local dist = (mainPart.Position - pos).Magnitude
                if dist <= radius then
                    -- Makanan: pickup ke inventory (tidak langsung dimakan)
                    if isFoodItem(item.Name) then
                        if pickUpItemRemote then
                            pickUpItemRemote:FireServer(item)
                            task.wait(delay)
                        end
                    else
                        -- Non-makanan: sesuai mode yang dipilih
                        if pickupModeType == 1 then
                            if pickUpItemRemote then
                                pickUpItemRemote:FireServer(item)
                                task.wait(delay)
                            end
                        elseif pickupModeType == 2 then
                            if adjustBackpackRemote then
                                adjustBackpackRemote:FireServer(item)
                                task.wait(delay)
                            end
                        elseif pickupModeType == 3 then
                            if adjustBackpackRemote then
                                adjustBackpackRemote:FireServer(item)
                                task.wait(delay * 0.5)
                            end
                            if item and item.Parent == droppedItemsFolder then
                                if pickUpItemRemote then
                                    pickUpItemRemote:FireServer(item)
                                    task.wait(delay * 0.5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ========== Unlimited Ammo ==========
local unlimitedAmmoActive = false
local ammoLoopConnection = nil

local function startUnlimitedAmmo()
    if ammoLoopConnection then
        ammoLoopConnection:Disconnect()
    end
    
    ammoLoopConnection = RunService.Heartbeat:Connect(function()
        if not unlimitedAmmoActive then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tools = char:GetChildren()
        for _, tool in ipairs(tools) do
            if tool:IsA("Tool") then
                local ammo = tool:FindFirstChild("Ammo")
                local currentAmmo = tool:FindFirstChild("CurrentAmmo")
                local magazine = tool:FindFirstChild("Magazine")
                
                if ammo then ammo.Value = 999 end
                if currentAmmo then currentAmmo.Value = 999 end
                if magazine then magazine.Value = 999 end
            end
        end
        
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, bpTool in ipairs(backpack:GetChildren()) do
                if bpTool:IsA("Tool") then
                    local bpAmmo = bpTool:FindFirstChild("Ammo")
                    if bpAmmo then bpAmmo.Value = 999 end
                end
            end
        end
    end)
end

-- ========== Rate of Fire Brutal ==========
local rateOfFireActive = false
local rofConnection = nil
local originalCooldowns = {}

local function modifyWeaponCooldown(tool)
    if not tool or not tool:IsA("Tool") then return end
    
    local cooldown = tool:FindFirstChild("Cooldown") or 
                     tool:FindFirstChild("FireCooldown") or
                     tool:FindFirstChild("AttackCooldown") or
                     tool:FindFirstChild("ReloadTime")
    
    if cooldown and not originalCooldowns[tool] then
        originalCooldowns[tool] = cooldown.Value
        cooldown.Value = 0.01
    end
end

local function startRateOfFire()
    if rofConnection then
        rofConnection:Disconnect()
    end
    
    local function onCharacterAdded(char)
        local function checkTools()
            local tools = char:GetChildren()
            for _, tool in ipairs(tools) do
                if tool:IsA("Tool") then
                    modifyWeaponCooldown(tool)
                end
            end
        end
        
        checkTools()
        
        local childAddedConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and rateOfFireActive then
                modifyWeaponCooldown(child)
            end
        end)
        table.insert(connections, childAddedConn)
    end
    
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    
    rofConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    table.insert(connections, rofConnection)
    
    local applyLoop = RunService.Heartbeat:Connect(function()
        if not rateOfFireActive then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local cooldown = tool:FindFirstChild("Cooldown") or 
                                 tool:FindFirstChild("FireCooldown") or
                                 tool:FindFirstChild("AttackCooldown")
                if cooldown and cooldown.Value > 0.05 then
                    cooldown.Value = 0.01
                end
            end
        end
    end)
    table.insert(connections, applyLoop)
end

-- ========== Auto Drop Ammo ==========
local autoDropActive = false
local dropAmount = 0
local dropType = "Pistol" -- Pistol, Medium, Long
local dropConnection = nil

local ammoTypes = {
    Pistol = {"Pistol Ammo", "Revolver Ammo"},
    Medium = {"Medium Ammo", "SMG Ammo"},
    Long = {"Long Ammo", "Rifle Ammo", "Sniper Ammo"}
}

local function findAmmoInBackpack(ammoName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == ammoName then
            return item
        end
    end
    return nil
end

local function dropAmmo(ammoItem, amount)
    if not ammoItem or not dropItemRemote then return false end
    
    local ammoCount = ammoItem:FindFirstChild("Amount") or ammoItem:FindFirstChild("Count")
    if ammoCount then
        local toDrop = math.min(amount, ammoCount.Value)
        if toDrop > 0 then
            dropItemRemote:FireServer(ammoItem, toDrop)
            return true
        end
    end
    return false
end

local function startAutoDrop()
    if dropConnection then
        dropConnection:Disconnect()
    end
    
    dropConnection = RunService.Heartbeat:Connect(function()
        if not autoDropActive then return end
        if dropAmount <= 0 then return end
        
        local ammoList = ammoTypes[dropType]
        if not ammoList then return end
        
        for _, ammoName in ipairs(ammoList) do
            local ammoItem = findAmmoInBackpack(ammoName)
            if ammoItem then
                dropAmmo(ammoItem, dropAmount)
                task.wait(0.1)
            end
        end
    end)
end

-- ========== Ammo Tab ==========
local ammo = tabFrames["Ammo"]
local yOffsetAmmo = 5

-- Unlimited Ammo
local unlimitedAmmoBtn = Instance.new("TextButton")
unlimitedAmmoBtn.Size = UDim2.new(0, 180, 0, TouchEnabled and 36 or 32)
unlimitedAmmoBtn.Position = UDim2.new(0, 5, 0, yOffsetAmmo)
unlimitedAmmoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
unlimitedAmmoBtn.BorderSizePixel = 1
unlimitedAmmoBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
unlimitedAmmoBtn.Text = "Unlimited Ammo: Off"
unlimitedAmmoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unlimitedAmmoBtn.Font = Enum.Font.GothamMedium
unlimitedAmmoBtn.TextSize = TouchEnabled and 13 or 14
unlimitedAmmoBtn.Parent = ammo

unlimitedAmmoBtn.MouseButton1Click:Connect(function()
    unlimitedAmmoActive = not unlimitedAmmoActive
    unlimitedAmmoBtn.Text = "Unlimited Ammo: " .. (unlimitedAmmoActive and "On" or "Off")
    unlimitedAmmoBtn.BackgroundColor3 = unlimitedAmmoActive and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
    
    if unlimitedAmmoActive then
        startUnlimitedAmmo()
        StatusText.Text = "Unlimited Ammo enabled"
    else
        if ammoLoopConnection then
            ammoLoopConnection:Disconnect()
            ammoLoopConnection = nil
        end
        StatusText.Text = "Unlimited Ammo disabled"
    end
end)

yOffsetAmmo = yOffsetAmmo + (TouchEnabled and 44 or 40)

-- Rate of Fire
local rofBtn = Instance.new("TextButton")
rofBtn.Size = UDim2.new(0, 180, 0, TouchEnabled and 36 or 32)
rofBtn.Position = UDim2.new(0, 5, 0, yOffsetAmmo)
rofBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
rofBtn.BorderSizePixel = 1
rofBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
rofBtn.Text = "Rate of Fire: Off"
rofBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rofBtn.Font = Enum.Font.GothamMedium
rofBtn.TextSize = TouchEnabled and 13 or 14
rofBtn.Parent = ammo

rofBtn.MouseButton1Click:Connect(function()
    rateOfFireActive = not rateOfFireActive
    rofBtn.Text = "Rate of Fire: " .. (rateOfFireActive and "On" or "Off")
    rofBtn.BackgroundColor3 = rateOfFireActive and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
    
    if rateOfFireActive then
        startRateOfFire()
        StatusText.Text = "Rate of Fire Brutal enabled"
    else
        for tool, originalValue in pairs(originalCooldowns) do
            local cooldown = tool:FindFirstChild("Cooldown") or 
                             tool:FindFirstChild("FireCooldown") or
                             tool:FindFirstChild("AttackCooldown")
            if cooldown then
                cooldown.Value = originalValue
            end
        end
        originalCooldowns = {}
        StatusText.Text = "Rate of Fire disabled"
    end
end)

yOffsetAmmo = yOffsetAmmo + (TouchEnabled and 44 or 40)

-- Separator Line
local separator1 = Instance.new("Frame")
separator1.Size = UDim2.new(1, -10, 0, 2)
separator1.Position = UDim2.new(0, 5, 0, yOffsetAmmo)
separator1.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
separator1.BorderSizePixel = 0
separator1.Parent = ammo
yOffsetAmmo = yOffsetAmmo + 15

-- Auto Drop Ammo Group
local dropGroup, dropContainer = createGroup(ammo, "Auto Drop Ammo", yOffsetAmmo, 8)
yOffsetAmmo = yOffsetAmmo + dropGroup.Size.Y.Offset + 10

-- Ammo Type Selection
local typeLabel = Instance.new("TextLabel")
typeLabel.Size = UDim2.new(0, 80, 0, 25)
typeLabel.Position = UDim2.new(0, 5, 0, 5)
typeLabel.BackgroundTransparency = 1
typeLabel.Text = "Ammo Type:"
typeLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
typeLabel.Font = Enum.Font.Gotham
typeLabel.TextSize = TouchEnabled and 13 or 14
typeLabel.TextXAlignment = Enum.TextXAlignment.Left
typeLabel.Parent = dropContainer

local ammoTypeBtn = Instance.new("TextButton")
ammoTypeBtn.Size = UDim2.new(0, 100, 0, TouchEnabled and 32 or 28)
ammoTypeBtn.Position = UDim2.new(0, 90, 0, 3)
ammoTypeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ammoTypeBtn.BorderSizePixel = 1
ammoTypeBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
ammoTypeBtn.Text = "Pistol"
ammoTypeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ammoTypeBtn.Font = Enum.Font.GothamMedium
ammoTypeBtn.TextSize = TouchEnabled and 12 or 13
ammoTypeBtn.Parent = dropContainer

local ammoTypeList = {"Pistol", "Medium", "Long"}
local ammoTypeIndex = 1

ammoTypeBtn.MouseButton1Click:Connect(function()
    ammoTypeIndex = ammoTypeIndex % 3 + 1
    dropType = ammoTypeList[ammoTypeIndex]
    ammoTypeBtn.Text = dropType
end)

-- Drop Amount Selection
local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(0, 80, 0, 25)
amountLabel.Position = UDim2.new(0, 5, 0, 45)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "Drop Amount:"
amountLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
amountLabel.Font = Enum.Font.Gotham
amountLabel.TextSize = TouchEnabled and 13 or 14
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = dropContainer

local amountInput = Instance.new("TextBox")
amountInput.Size = UDim2.new(0, 100, 0, 25)
amountInput.Position = UDim2.new(0, 90, 0, 43)
amountInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
amountInput.BorderSizePixel = 1
amountInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
amountInput.Text = "0"
amountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
amountInput.Font = Enum.Font.Gotham
amountInput.TextSize = TouchEnabled and 13 or 14
amountInput.PlaceholderText = "0 = All"
amountInput.Parent = dropContainer

amountInput.FocusLost:Connect(function()
    local value = tonumber(amountInput.Text)
    if value and value >= 0 then
        dropAmount = value
    else
        dropAmount = 0
        amountInput.Text = "0"
    end
end)

-- Drop All Button
local dropAllBtn = Instance.new("TextButton")
dropAllBtn.Size = UDim2.new(0, 100, 0, TouchEnabled and 36 or 32)
dropAllBtn.Position = UDim2.new(0, 5, 0, 85)
dropAllBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
dropAllBtn.BorderSizePixel = 1
dropAllBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
dropAllBtn.Text = "DROP ALL"
dropAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropAllBtn.Font = Enum.Font.GothamBold
dropAllBtn.TextSize = TouchEnabled and 13 or 14
dropAllBtn.Parent = dropContainer

dropAllBtn.MouseButton1Click:Connect(function()
    dropAmount = 0
    amountInput.Text = "0"
    if not autoDropActive then
        autoDropActive = true
        startAutoDrop()
        StatusText.Text = "Dropping all ammo..."
        task.wait(2)
        autoDropActive = false
        if dropConnection then
            dropConnection:Disconnect()
            dropConnection = nil
        end
        StatusText.Text = "Drop all completed"
    end
end)

-- Auto Drop Toggle
local _autoDropBtn, _autoDropState = createToggleButton(dropContainer, "Auto Drop", false, function(state)
    autoDropActive = state
    if state then
        if dropAmount == 0 then
            StatusText.Text = "Auto Drop started - Dropping all " .. dropType .. " ammo"
        else
            StatusText.Text = "Auto Drop started - Dropping " .. dropAmount .. " " .. dropType .. " ammo"
        end
        startAutoDrop()
    else
        if dropConnection then
            dropConnection:Disconnect()
            dropConnection = nil
        end
        StatusText.Text = "Auto Drop stopped"
    end
end, 135, 160)

-- ========== Misc Tab ==========
local misc = tabFrames["Misc"]
local miscPlaceholder = Instance.new("TextLabel")
miscPlaceholder.Size = UDim2.new(1, -10, 0, 30)
miscPlaceholder.Position = UDim2.new(0, 5, 0, 5)
miscPlaceholder.BackgroundTransparency = 1
miscPlaceholder.Text = "More features coming soon..."
miscPlaceholder.TextColor3 = Color3.fromRGB(200, 200, 200)
miscPlaceholder.Font = Enum.Font.Gotham
miscPlaceholder.TextSize = TouchEnabled and 13 or 14
miscPlaceholder.TextWrapped = true
miscPlaceholder.Parent = misc

-- ========== Info Tab ==========
local info = tabFrames["Info"]
local yOffsetInfo = 5

local function createInfoLabel(text, color, fontSize, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = fontSize or 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = info
    return label
end

yOffsetInfo = 5
createInfoLabel("Author: Spy", Color3.fromRGB(255, 100, 100), TouchEnabled and 16 or 18, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 30
createInfoLabel("Discord: hxnrylsd", Color3.fromRGB(255, 255, 255), TouchEnabled and 14 or 16, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 30
createInfoLabel("Version: 5.0", Color3.fromRGB(255, 255, 255), TouchEnabled and 14 or 16, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 30
createInfoLabel("Socials: feds.lol/spy", Color3.fromRGB(255, 255, 255), TouchEnabled and 14 or 16, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 35
createInfoLabel("Best AI Cheat Ever!", Color3.fromRGB(255, 200, 200), TouchEnabled and 13 or 15, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 30
createInfoLabel("Created with Deepseek", Color3.fromRGB(200, 200, 255), TouchEnabled and 13 or 15, yOffsetInfo)
yOffsetInfo = yOffsetInfo + 40

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(0, 200, 0, TouchEnabled and 44 or 40)
unloadBtn.Position = UDim2.new(0, 5, 0, yOffsetInfo)
unloadBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
unloadBtn.BorderSizePixel = 2
unloadBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
unloadBtn.Text = "UNLOAD"
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = TouchEnabled and 16 or 18
unloadBtn.Parent = info

unloadBtn.MouseEnter:Connect(function()
    TweenService:Create(unloadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
end)
unloadBtn.MouseLeave:Connect(function()
    TweenService:Create(unloadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 0, 0)}):Play()
end)

-- ========== Unload Funktion ==========
local function unloadAll()
    for char, _ in pairs(mobESPInstances) do
        removeMobESP(char)
    end
    for item, _ in pairs(itemESPInstances) do
        removeItemESP(item)
    end
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    if autoPickupConnection then
        autoPickupConnection:Disconnect()
    end
    if ammoLoopConnection then
        ammoLoopConnection:Disconnect()
    end
    if dropConnection then
        dropConnection:Disconnect()
    end
    if speedState then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalValues.walkSpeed or 16
            end
        end
    end
    ScreenGui:Destroy()
    print("SPYMM v5.0 unloaded.")
end

unloadBtn.MouseButton1Click:Connect(unloadAll)

-- GUI-Toggle mit Insert-Taste
local toggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
table.insert(connections, toggleConn)

-- Statusleisten-Update
local statusConn = RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    StatusText.Text = string.format("Ready | FPS: %d | Mob: %s | Item: %s | Jump: %s | Auto: %s | Ammo: %s | ROF: %s",
        fps,
        mobOptions.ESP and "On" or "Off",
        itemOptions.ESP and "On" or "Off",
        originalValues.infJumpActive and "On" or "Off",
        autoPickupActive and "On" or "Off",
        unlimitedAmmoActive and "On" or "Off",
        rateOfFireActive and "On" or "Off")
end)
table.insert(connections, statusConn)

print("SPYMM v5.0 - Full Features Loaded!")
print("Press Insert to toggle GUI")
print("Features: ESP (Mob/Item with Filter) | Auto Pickup (3 Modes) | Speed Hack with Auto Fix")
print("Features: Infinite Jump | Unlimited Ammo | Rate of Fire Brutal | Auto Drop Ammo")