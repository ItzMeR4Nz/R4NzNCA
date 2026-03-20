--[[
    SPYMM v5.0 - Blutiger (Mobile Optimized with Full Features)
    Author: Spy
    Version: 5.0
    Fix: Makanan hanya di-pickup jika sedang pegang ransel (tidak otomatis makan)
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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SPYMM"
ScreenGui.Parent = guiContainer
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

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

local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, originalSize.X.Offset, 0, 45)

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

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local BloodLine = Instance.new("Frame")
BloodLine.Name = "BloodLine"
BloodLine.Size = UDim2.new(1, 0, 0, 2)
BloodLine.Position = UDim2.new(0, 0, 1, -2)
BloodLine.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
BloodLine.BorderSizePixel = 0
BloodLine.Parent = TopBar

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

local ContentWrapper = Instance.new("Frame")
ContentWrapper.Name = "ContentWrapper"
ContentWrapper.Size = UDim2.new(1, 0, 1, -45)
ContentWrapper.Position = UDim2.new(0, 0, 0, 45)
ContentWrapper.BackgroundTransparency = 1
ContentWrapper.Parent = MainFrame

-- Status Bar (deklarasi awal agar bisa dipakai di fungsi lain)
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

-- Minimize & Close
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(MainFrame, tweenInfo, {Size = minimizedSize}):Play()
        ContentWrapper.Visible = false
        MinimizeButton.Image = "rbxassetid://10747383595"
        StatusText.Text = "SPYMM minimized"
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(MainFrame, tweenInfo, {Size = originalSize}):Play()
        task.wait(0.3)
        ContentWrapper.Visible = true
        MinimizeButton.Image = "rbxassetid://10747383583"
        StatusText.Text = "SPYMM restored"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    unloadAll()
end)

-- Drag
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

-- Tabs
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
    return button
end

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -(TabContainer.Size.Y.Offset + StatusBar.Size.Y.Offset + 20))
ContentContainer.Position = UDim2.new(0, 10, 0, TabContainer.Size.Y.Offset + 15)
ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ContentContainer.BorderSizePixel = 2
ContentContainer.BorderColor3 = Color3.fromRGB(139, 0, 0)
ContentContainer.Parent = ContentWrapper

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

currentTab = "Visuals"
tabFrames[currentTab].Visible = true
tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabButtons[currentTab].BorderColor3 = Color3.fromRGB(200, 0, 0)

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

-- ========== Global Variables ==========
local connections = {}
local mobESPInstances = {}
local itemESPInstances = {}
local originalValues = {
    walkSpeed = nil,
    infJumpActive = false
}

local mobOptions = { ESP = false, Chams = false, Name = false, Distance = false }
local itemOptions = { ESP = false, Chams = false, Name = false, Distance = false }
local espItemFilter = {}
local espAllItems = false
local mobNames = {"Runner", "Crawler", "Riot", "Zombie"}

local itemNames = {
    "Bandage", "Medkit", "Painkillers", "Antidote", "Blood Bag", "Splint",
    "Beans", "Bloxiade", "Bloxy Cola", "Water Bottle", "Canned Food", "MRE", "Energy Drink",
    "Knife", "Machete", "Katana", "Baseball Bat", "Crowbar", "Spatula", "Golf Club", "Axe",
    "Pistol", "Revolver", "Shotgun", "Rifle", "SMG",
    "Pistol Ammo", "Revolver Ammo", "Shotgun Shells", "Rifle Ammo", "SMG Ammo",
    "Long Ammo", "Medium Ammo", "Shells",
    "Grenade", "Molotov", "C4",
    "Wood", "Metal", "Nails", "Screws", "Scrap", "Barbed Wire",
    "Battery", "Wire", "Circuit Board", "Radio",
    "Fuel", "Engine Parts", "Tire",
    "Hammer", "Wrench", "Screwdriver", "Flashlight", "Lighter",
    "Keycard", "Lockpick", "Binoculars", "Gas Mask",
    "Tray", "Compound I", "Dumbell"
}

local uniqueItemNames = {}
for _, name in ipairs(itemNames) do uniqueItemNames[name] = true end
local finalItemNames = {}
for name, _ in pairs(uniqueItemNames) do table.insert(finalItemNames, name) end
table.sort(finalItemNames)

local foodItems = {
    "Beans", "Bloxiade", "Bloxy Cola", "Water Bottle", "Canned Food", "MRE", "Energy Drink"
}

local function isFoodItem(itemName)
    for _, food in ipairs(foodItems) do
        if itemName == food then return true end
    end
    return false
end

-- ========== FIX: Cek apakah player sedang EQUIP/PEGANG ransel ==========
local function isHoldingBackpack()
    local char = LocalPlayer.Character
    if not char then return false end
    -- Cek di character (tool yang sedang di-equip ada di dalam char, bukan Backpack folder)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local nameLower = tool.Name:lower()
            if nameLower:find("backpack") or nameLower:find("bag") or nameLower:find("pack") then
                return true
            end
        end
    end
    return false
end

local charactersFolder = Workspace:FindFirstChild("Characters")
local droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")

local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then return child end
    end
    return nil
end

-- ========== ESP Functions ==========
local function removeMobESP(char)
    local esp = mobESPInstances[char]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
        mobESPInstances[char] = nil
    end
end

local function removeItemESP(item)
    local esp = itemESPInstances[item]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
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
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = char.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = mobOptions.Name
        nameLabel.Parent = frame
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = mobOptions.Distance
        distLabel.Parent = frame
        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent then connection:Disconnect() return end
            if distLabel and distLabel.Visible then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                if myRoot then distLabel.Text = math.floor((myRoot.Position - root.Position).Magnitude) .. "m" end
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
    if not espAllItems and not espItemFilter[item.Name] then return end
    local mainPart = getItemMainPart(item)
    if not mainPart then return end
    local espTable = {}
    if itemOptions.Chams then
        local highlight = Instance.new("Highlight")
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
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = item.Name
        nameLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = itemOptions.Name
        nameLabel.Parent = frame
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = itemOptions.Distance
        distLabel.Parent = frame
        espTable.Billboard = billboard
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not item or not item.Parent then connection:Disconnect() return end
            if distLabel and distLabel.Visible then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                if myRoot then distLabel.Text = math.floor((myRoot.Position - mainPart.Position).Magnitude) .. "m" end
            end
        end)
        espTable.DistanceConnection = connection
        table.insert(connections, connection)
    end
    itemESPInstances[item] = espTable
end

local function refreshMobESP()
    for char, _ in pairs(mobESPInstances) do removeMobESP(char) end
    if not mobOptions.ESP then return end
    if not charactersFolder then return end
    for _, child in ipairs(charactersFolder:GetChildren()) do
        if table.find(mobNames, child.Name) then createMobESP(child) end
    end
end

local function refreshItemESP()
    for item, _ in pairs(itemESPInstances) do removeItemESP(item) end
    if not itemOptions.ESP then return end
    if not droppedItemsFolder then return end
    for _, child in ipairs(droppedItemsFolder:GetChildren()) do
        if espAllItems or espItemFilter[child.Name] then createItemESP(child) end
    end
end

if charactersFolder then
    table.insert(connections, charactersFolder.ChildAdded:Connect(function(child)
        if mobOptions.ESP and table.find(mobNames, child.Name) then createMobESP(child) end
    end))
    table.insert(connections, charactersFolder.ChildRemoved:Connect(function(child)
        removeMobESP(child)
    end))
end

if droppedItemsFolder then
    table.insert(connections, droppedItemsFolder.ChildAdded:Connect(function(child)
        if itemOptions.ESP and (espAllItems or espItemFilter[child.Name]) then createItemESP(child) end
    end))
    table.insert(connections, droppedItemsFolder.ChildRemoved:Connect(function(child)
        removeItemESP(child)
    end))
end

-- ========== GUI Helpers ==========
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
    local state = initialValue
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "On" or "Off")
        btn.BackgroundColor3 = state and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
        callback(state)
    end)
    return btn, state
end

local function createGroup(parent, title, yOffset, buttonCount)
    local groupHeight = 45 + buttonCount * (TouchEnabled and 39 or 37)
    local group = Instance.new("Frame")
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

local mobGroup, mobContainer = createGroup(visuals, "Mob ESP", yOffsetVis, 4)
yOffsetVis = yOffsetVis + mobGroup.Size.Y.Offset + 10
createToggleButton(mobContainer, "Mob ESP", mobOptions.ESP, function(s)
    mobOptions.ESP = s; refreshMobESP()
    StatusText.Text = s and "Mob ESP enabled" or "Mob ESP disabled"
end, 0, 140)
local subY = 40
createToggleButton(mobContainer, "Chams", mobOptions.Chams, function(s) mobOptions.Chams = s; refreshMobESP() end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)
createToggleButton(mobContainer, "Name", mobOptions.Name, function(s) mobOptions.Name = s; refreshMobESP() end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)
createToggleButton(mobContainer, "Distance", mobOptions.Distance, function(s) mobOptions.Distance = s; refreshMobESP() end, subY, 100)

local itemGroup, itemContainer = createGroup(visuals, "Item ESP", yOffsetVis, 4)
yOffsetVis = yOffsetVis + itemGroup.Size.Y.Offset + 10
createToggleButton(itemContainer, "Item ESP", itemOptions.ESP, function(s)
    itemOptions.ESP = s; refreshItemESP()
    StatusText.Text = s and "Item ESP enabled" or "Item ESP disabled"
end, 0, 140)
subY = 40
createToggleButton(itemContainer, "Chams", itemOptions.Chams, function(s) itemOptions.Chams = s; refreshItemESP() end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)
createToggleButton(itemContainer, "Name", itemOptions.Name, function(s) itemOptions.Name = s; refreshItemESP() end, subY, 100)
subY = subY + (TouchEnabled and 39 or 37)
createToggleButton(itemContainer, "Distance", itemOptions.Distance, function(s) itemOptions.Distance = s; refreshItemESP() end, subY, 100)

local espFilterGroup, espFilterContainer = createGroup(visuals, "ESP Item Filter", yOffsetVis, #finalItemNames/4 + 2)
yOffsetVis = yOffsetVis + espFilterGroup.Size.Y.Offset + 10

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
for _, itemName in ipairs(finalItemNames) do
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

-- ========== Player Tab ==========
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

local function applySpeed()
    local char = LocalPlayer.Character
    if char and speedState then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = targetSpeed end
    end
end

local function setupSpeedFix()
    if speedFixConnection then speedFixConnection:Disconnect() end
    local function onCharacterAdded(char)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedState and humanoid.WalkSpeed ~= targetSpeed then
                task.wait(0.1)
                if speedState then humanoid.WalkSpeed = targetSpeed end
            end
        end)
        humanoid.Died:Connect(function()
            if speedState then
                task.wait(2)
                local newChar = LocalPlayer.Character
                if newChar and speedState then
                    local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                    if newHumanoid then newHumanoid.WalkSpeed = targetSpeed end
                end
            end
        end)
    end
    if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
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
                speedBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                setupSpeedFix()
            else
                humanoid.WalkSpeed = originalValues.walkSpeed or 16
                speedBtn.Text = "Speed: " .. (originalValues.walkSpeed or 16)
                speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                if speedFixConnection then speedFixConnection:Disconnect(); speedFixConnection = nil end
            end
            speedState = not speedState
        end
    end
end)

yOffsetPlayer = yOffsetPlayer + (TouchEnabled and 44 or 40)

local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Size = UDim2.new(0, 90, 0, 25)
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
        if speedState then applySpeed() end
    else
        speedSlider.Text = tostring(targetSpeed)
    end
end)

yOffsetPlayer = yOffsetPlayer + 35

local _infJumpBtn = createToggleButton(player, "Inf Jump", false, function(state)
    originalValues.infJumpActive = state
    StatusText.Text = state and "Inf Jump on" or "Inf Jump off"
end, yOffsetPlayer, 180)

local jumpConn = UserInputService.JumpRequest:Connect(function()
    if originalValues.infJumpActive then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)
table.insert(connections, jumpConn)

-- ========== Exploits Tab - Auto Pickup ==========
local exploits = tabFrames["Exploits"]
local yOffsetExp = 5

local autoPickupGroup, autoPickupContainer = createGroup(exploits, "Auto Pickup", yOffsetExp, 12)
yOffsetExp = yOffsetExp + autoPickupGroup.Size.Y.Offset + 10

-- Info label tentang logika makanan
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 40)
infoLabel.Position = UDim2.new(0, 5, 0, 5)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
infoLabel.BorderSizePixel = 1
infoLabel.BorderColor3 = Color3.fromRGB(139, 0, 0)
infoLabel.Text = "⚠️ Makanan: hanya di-pickup jika sedang PEGANG RANSEL\n   Non-Makanan: pickup sesuai mode"
infoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = TouchEnabled and 10 or 11
infoLabel.TextWrapped = true
infoLabel.Parent = autoPickupContainer

-- Mode Selection
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0, 80, 0, 25)
modeLabel.Position = UDim2.new(0, 5, 0, 55)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Mode:"
modeLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = TouchEnabled and 13 or 14
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = autoPickupContainer

local pickupModeType = 1
local modeNames = {"Direct", "Backpack", "Both"}
local modeColors = {
    Color3.fromRGB(20, 20, 20),
    Color3.fromRGB(80, 0, 0),
    Color3.fromRGB(100, 50, 0)
}

local pickupMode = Instance.new("TextButton")
pickupMode.Size = UDim2.new(0, 130, 0, TouchEnabled and 32 or 28)
pickupMode.Position = UDim2.new(0, 90, 0, 53)
pickupMode.BackgroundColor3 = modeColors[1]
pickupMode.BorderSizePixel = 1
pickupMode.BorderColor3 = Color3.fromRGB(139, 0, 0)
pickupMode.Text = modeNames[1]
pickupMode.TextColor3 = Color3.fromRGB(255, 255, 255)
pickupMode.Font = Enum.Font.GothamMedium
pickupMode.TextSize = TouchEnabled and 12 or 13
pickupMode.Parent = autoPickupContainer

pickupMode.MouseButton1Click:Connect(function()
    pickupModeType = pickupModeType % 3 + 1
    pickupMode.Text = modeNames[pickupModeType]
    pickupMode.BackgroundColor3 = modeColors[pickupModeType]
end)

-- Radius
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0, 80, 0, 25)
radiusLabel.Position = UDim2.new(0, 5, 0, 95)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius:"
radiusLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = TouchEnabled and 13 or 14
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Parent = autoPickupContainer

local radiusInput = Instance.new("TextBox")
radiusInput.Size = UDim2.new(0, 80, 0, 25)
radiusInput.Position = UDim2.new(0, 90, 0, 93)
radiusInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
radiusInput.BorderSizePixel = 1
radiusInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
radiusInput.Text = "15"
radiusInput.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = TouchEnabled and 13 or 14
radiusInput.PlaceholderText = "15"
radiusInput.Parent = autoPickupContainer

-- Delay
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 80, 0, 25)
delayLabel.Position = UDim2.new(0, 5, 0, 128)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay:"
delayLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = TouchEnabled and 13 or 14
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = autoPickupContainer

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 80, 0, 25)
delayInput.Position = UDim2.new(0, 90, 0, 126)
delayInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
delayInput.BorderSizePixel = 1
delayInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
delayInput.Text = "0.05"
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = TouchEnabled and 13 or 14
delayInput.PlaceholderText = "0.05"
delayInput.Parent = autoPickupContainer

-- All Items Toggle
local allItemsCheckbox = Instance.new("TextButton")
allItemsCheckbox.Size = UDim2.new(0, 140, 0, TouchEnabled and 32 or 28)
allItemsCheckbox.Position = UDim2.new(0, 5, 0, 160)
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

-- Item List
local itemListFrame = Instance.new("ScrollingFrame")
itemListFrame.Size = UDim2.new(1, -10, 0, 180)
itemListFrame.Position = UDim2.new(0, 5, 0, 200)
itemListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
itemListFrame.BorderSizePixel = 1
itemListFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.ScrollBarThickness = TouchEnabled and 4 or 6
itemListFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.Parent = autoPickupContainer

local itemCheckboxes = {}
local currentItemY = 5

for _, itemName in ipairs(finalItemNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, TouchEnabled and 28 or 24)
    btn.Position = UDim2.new(0, 5, 0, currentItemY)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = "  " .. itemName
    btn.TextColor3 = isFoodItem(itemName) and Color3.fromRGB(255, 220, 100) or Color3.fromRGB(255, 255, 255)
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

-- ========== Auto Pickup Variables & Toggle ==========
local autoPickupActive = false
local autoPickupConnection = nil

local _autoPickupBtn = createToggleButton(autoPickupContainer, "Auto Pickup", false, function(state)
    autoPickupActive = state
    if state then
        StatusText.Text = "Auto Pickup started - Mode: " .. modeNames[pickupModeType]
    else
        StatusText.Text = "Auto Pickup stopped"
        if autoPickupConnection then
            autoPickupConnection:Disconnect()
            autoPickupConnection = nil
        end
    end
end, 390, 160)

-- ========== MAIN AUTO PICKUP FUNCTION (FIXED FOOD LOGIC) ==========
local function startAutoPickup()
    if autoPickupConnection then
        autoPickupConnection:Disconnect()
        autoPickupConnection = nil
    end

    autoPickupConnection = RunService.Heartbeat:Connect(function()
        if not autoPickupActive then return end

        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        if not droppedItemsFolder then return end

        local radius = tonumber(radiusInput.Text) or 15
        local delay = tonumber(delayInput.Text) or 0.05
        local pos = rootPart.Position

        for _, item in ipairs(droppedItemsFolder:GetChildren()) do
            if not autoPickupActive then break end

            -- Cek whitelist item
            if not allSelected then
                local isSelected = false
                for name, getter in pairs(itemCheckboxes) do
                    if item.Name == name and getter() then
                        isSelected = true
                        break
                    end
                end
                if not isSelected then continue end
            end

            local mainPart = item.PrimaryPart or getItemMainPart(item)
            if not mainPart then continue end

            local dist = (mainPart.Position - pos).Magnitude
            if dist > radius then continue end

            -- ================================================================
            -- LOGIKA MAKANAN (FIXED):
            -- Makanan HANYA bisa di-pickup via adjustBackpackRemote ke ransel
            -- dan HANYA jika player sedang PEGANG/EQUIP ranselnya
            -- Jika tidak pegang ransel = SKIP (tidak dipickup sama sekali)
            -- ================================================================
            if isFoodItem(item.Name) then
                if isHoldingBackpack() and adjustBackpackRemote then
                    task.spawn(function()
                        adjustBackpackRemote:FireServer(item)
                    end)
                    task.wait(delay)
                end
                -- Tidak pegang ransel = skip, jangan pickup ke inventory
                -- karena akan otomatis dimakan
            else
                -- Non-makanan: pickup sesuai mode
                if pickupModeType == 1 then
                    -- Direct: pickup ke inventory
                    if pickUpItemRemote then
                        task.spawn(function()
                            pickUpItemRemote:FireServer(item)
                        end)
                        task.wait(delay)
                    end
                elseif pickupModeType == 2 then
                    -- Backpack: pickup ke ransel
                    if adjustBackpackRemote then
                        task.spawn(function()
                            adjustBackpackRemote:FireServer(item)
                        end)
                        task.wait(delay)
                    end
                elseif pickupModeType == 3 then
                    -- Both: coba ransel dulu, lalu inventory
                    if adjustBackpackRemote then
                        task.spawn(function()
                            adjustBackpackRemote:FireServer(item)
                        end)
                        task.wait(delay * 0.5)
                    end
                    if item and item.Parent == droppedItemsFolder then
                        if pickUpItemRemote then
                            task.spawn(function()
                                pickUpItemRemote:FireServer(item)
                            end)
                            task.wait(delay * 0.5)
                        end
                    end
                end
            end
        end
    end)
end

-- Jalankan auto pickup loop saat pertama kali (idle sampai diaktifkan)
startAutoPickup()

-- ========== Unlimited Ammo ==========
local unlimitedAmmoActive = false
local ammoLoopConnection = nil

local function startUnlimitedAmmo()
    if ammoLoopConnection then ammoLoopConnection:Disconnect() end
    ammoLoopConnection = RunService.Heartbeat:Connect(function()
        if not unlimitedAmmoActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
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

-- ========== Rate of Fire ==========
local rateOfFireActive = false
local rofConnection = nil
local originalCooldowns = {}

local function modifyWeaponCooldown(tool)
    if not tool or not tool:IsA("Tool") then return end
    local cooldown = tool:FindFirstChild("Cooldown") or tool:FindFirstChild("FireCooldown") or
                     tool:FindFirstChild("AttackCooldown") or tool:FindFirstChild("ReloadTime")
    if cooldown and not originalCooldowns[tool] then
        originalCooldowns[tool] = cooldown.Value
        cooldown.Value = 0.01
    end
end

local function startRateOfFire()
    if rofConnection then rofConnection:Disconnect() end
    local function onCharacterAdded(char)
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then modifyWeaponCooldown(tool) end
        end
        table.insert(connections, char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and rateOfFireActive then modifyWeaponCooldown(child) end
        end))
    end
    if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
    rofConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    table.insert(connections, rofConnection)
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if not rateOfFireActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local cooldown = tool:FindFirstChild("Cooldown") or tool:FindFirstChild("FireCooldown") or tool:FindFirstChild("AttackCooldown")
                if cooldown and cooldown.Value > 0.05 then cooldown.Value = 0.01 end
            end
        end
    end))
end

-- ========== Auto Drop Ammo ==========
local autoDropActive = false
local dropAmount = 0
local dropType = "Pistol"
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
        if item:IsA("Tool") and item.Name == ammoName then return item end
    end
    return nil
end

local function dropAmmo(ammoItem, amount)
    if not ammoItem or not dropItemRemote then return false end
    local ammoCount = ammoItem:FindFirstChild("Amount") or ammoItem:FindFirstChild("Count")
    if ammoCount then
        local toDrop = amount == 0 and ammoCount.Value or math.min(amount, ammoCount.Value)
        if toDrop > 0 then
            dropItemRemote:FireServer(ammoItem, toDrop)
            return true
        end
    end
    return false
end

local function startAutoDrop()
    if dropConnection then dropConnection:Disconnect() end
    dropConnection = RunService.Heartbeat:Connect(function()
        if not autoDropActive then return end
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
        if ammoLoopConnection then ammoLoopConnection:Disconnect(); ammoLoopConnection = nil end
        StatusText.Text = "Unlimited Ammo disabled"
    end
end)

yOffsetAmmo = yOffsetAmmo + (TouchEnabled and 44 or 40)

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
            local cooldown = tool:FindFirstChild("Cooldown") or tool:FindFirstChild("FireCooldown") or tool:FindFirstChild("AttackCooldown")
            if cooldown then cooldown.Value = originalValue end
        end
        originalCooldowns = {}
        StatusText.Text = "Rate of Fire disabled"
    end
end)

yOffsetAmmo = yOffsetAmmo + (TouchEnabled and 44 or 40)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -10, 0, 2)
sep.Position = UDim2.new(0, 5, 0, yOffsetAmmo)
sep.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
sep.BorderSizePixel = 0
sep.Parent = ammo
yOffsetAmmo = yOffsetAmmo + 15

local dropGroup, dropContainer = createGroup(ammo, "Auto Drop Ammo", yOffsetAmmo, 8)
yOffsetAmmo = yOffsetAmmo + dropGroup.Size.Y.Offset + 10

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
    if value and value >= 0 then dropAmount = value
    else dropAmount = 0; amountInput.Text = "0" end
end)

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
        if dropConnection then dropConnection:Disconnect(); dropConnection = nil end
        StatusText.Text = "Drop all completed"
    end
end)

createToggleButton(dropContainer, "Auto Drop", false, function(state)
    autoDropActive = state
    if state then
        StatusText.Text = "Auto Drop started - " .. dropType
        startAutoDrop()
    else
        if dropConnection then dropConnection:Disconnect(); dropConnection = nil end
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
createInfoLabel("Created with Claude", Color3.fromRGB(200, 200, 255), TouchEnabled and 13 or 15, yOffsetInfo)
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

-- ========== Unload ==========
function unloadAll()
    for char, _ in pairs(mobESPInstances) do removeMobESP(char) end
    for item, _ in pairs(itemESPInstances) do removeItemESP(item) end
    for _, conn in ipairs(connections) do conn:Disconnect() end
    if autoPickupConnection then autoPickupConnection:Disconnect() end
    if ammoLoopConnection then ammoLoopConnection:Disconnect() end
    if dropConnection then dropConnection:Disconnect() end
    if speedState then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = originalValues.walkSpeed or 16 end
        end
    end
    ScreenGui:Destroy()
    print("SPYMM v5.0 unloaded.")
end

unloadBtn.MouseButton1Click:Connect(unloadAll)

table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end))

table.insert(connections, RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    StatusText.Text = string.format("FPS:%d | Mob:%s | Item:%s | Jump:%s | Auto:%s | Ammo:%s | ROF:%s",
        fps,
        mobOptions.ESP and "On" or "Off",
        itemOptions.ESP and "On" or "Off",
        originalValues.infJumpActive and "On" or "Off",
        autoPickupActive and "On" or "Off",
        unlimitedAmmoActive and "On" or "Off",
        rateOfFireActive and "On" or "Off")
end))

print("SPYMM v5.0 Loaded! | Press Insert to toggle GUI")
print("Food items: only pickup when holding backpack (no auto-eat)")