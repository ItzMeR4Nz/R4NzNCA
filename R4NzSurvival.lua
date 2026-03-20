--[[
    SPYMM v5.0 - Blutiger (Mobile Optimized)
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TouchEnabled = UserInputService.TouchEnabled

-- Lokaler Spieler
local LocalPlayer = Players.LocalPlayer

-- Remotes für Auto Pickup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local adjustBackpackRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Tools") and ReplicatedStorage.Remotes.Tools:FindFirstChild("AdjustBackpack")
local pickUpItemRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Interaction") and ReplicatedStorage.Remotes.Interaction:FindFirstChild("PickUpItem")

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

-- Hauptfenster – ukuran responsif untuk mobile
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- Ukuran disesuaikan untuk layar mobile (lebih kecil)
MainFrame.Size = UDim2.new(0, math.min(450, workspace.CurrentCamera.ViewportSize.X - 40), 0, math.min(550, workspace.CurrentCamera.ViewportSize.Y - 40))
MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
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
local originalPosition = MainFrame.Position
local minimizedSize = UDim2.new(0, originalSize.X.Offset, 0, 45) -- Hanya title bar yang tersisa

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

-- Minimize-Funktion dengan animasi
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimieren
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = minimizedSize})
        
        sizeTween:Play()
        
        -- Sembunyikan konten
        ContentWrapper.Visible = false
        
        -- Ubah icon
        MinimizeButton.Image = "rbxassetid://10747383595"
        
        StatusText.Text = "SPYMM minimized"
    else
        -- Maximieren
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = originalSize})
        
        sizeTween:Play()
        
        -- Tampilkan konten setelah animasi selesai
        task.wait(0.3)
        ContentWrapper.Visible = true
        
        -- Ubah icon kembali
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
StatusText.Text = "Status: Bereit"
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
local tabs = {"Visuals", "Player", "Exploits", "Misc", "Info"}
local currentTab = "Visuals"

local function createTabButton(tabName, pos)
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    button.Size = UDim2.new(0, math.min(120, (TabContainer.AbsoluteSize.X - 20) / #tabs), 1, 0)
    button.Position = UDim2.new(0, (pos-1) * (button.Size.X.Offset + 5), 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(139, 0, 0)
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamBold
    button.TextSize = TouchEnabled and 14 or 16
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
local connections = {}           -- Alle Event-Verbindungen
local mobESPInstances = {}       -- ESP-Objekte für Mobs
local itemESPInstances = {}      -- ESP-Objekte für Items
local originalValues = {         -- Ursprüngliche Werte für Zurücksetzen
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

-- Ziel-Namen für Mobs
local mobNames = {"Runner", "Crawler", "Riot", "Zombie"}

-- Ziel-Namen für Items
local itemNames = {
    "Bandage", "Barbed Wire", "Battery", "Beans", "Bloxiade", "Bloxy Cola",
    "Compound I", "Crowbar", "Dumbell", "Fuel", "Grenade", "Knife",
    "Long Ammo", "Medium Ammo", "Pistol Ammo", "Revolver", "Scrap",
    "Screws", "Shells", "Spatula", "Tray"
}

-- Ordner
local charactersFolder = Workspace:FindFirstChild("Characters")
local droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")

-- ========== Hilfsfunktionen für ESP (unverändert) ==========
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

    -- Chams
    if mobOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(220, 0, 0)  -- Blutrot
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 185, 185)
        highlight.OutlineTransparency = 0.8
        highlight.Parent = char
        espTable.Highlight = highlight
    end

    -- Name und Distanz
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

    local mainPart = getItemMainPart(item)
    if not mainPart then return end

    local espTable = {}

    -- Chams
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

    -- Name und Distanz
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
        StatusText.Text = "Status: Characters-Ordner nicht gefunden"
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
        StatusText.Text = "Status: DroppedItems-Ordner nicht gefunden"
        return
    end
    for _, child in ipairs(droppedItemsFolder:GetChildren()) do
        if table.find(itemNames, child.Name) then
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
        if itemOptions.ESP and table.find(itemNames, child.Name) then
            createItemESP(child)
        end
    end)
    table.insert(connections, childAddedConn)

    local childRemovedConn = droppedItemsFolder.ChildRemoved:Connect(function(child)
        removeItemESP(child)
    end)
    table.insert(connections, childRemovedConn)
end

-- ========== GUI Hilfsfunktionen mit Blut-Design ==========
local function createToggleButton(parent, text, initialValue, callback, yPos, width)
    width = width or 160
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = initialValue and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = text .. ": " .. (initialValue and "An" or "Aus")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.Parent = parent

    -- Hover-Effekt
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
        btn.Text = text .. ": " .. (state and "An" or "Aus")
        local newColor = state and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
        btn.BackgroundColor3 = newColor
        normalColor = newColor
        hoverColor = newColor:Lerp(Color3.fromRGB(139, 0, 0), 0.3)
        callback(state)
    end)
    return btn, state
end

local function createGroup(parent, title, yOffset, buttonCount)
    local groupHeight = 45 + buttonCount * 37
    local group = Instance.new("Frame")
    group.Name = title .. "Group"
    group.Size = UDim2.new(1, -20, 0, groupHeight)
    group.Position = UDim2.new(0, 10, 0, yOffset)
    group.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    group.BorderSizePixel = 2
    group.BorderColor3 = Color3.fromRGB(139, 0, 0)
    group.Parent = parent

    -- Titel
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = group

    -- Trennlinie (blutrot)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 2)
    line.Position = UDim2.new(0, 10, 0, 35)
    line.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    line.BorderSizePixel = 0
    line.Parent = group

    -- Container für Buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 1, -45)
    buttonContainer.Position = UDim2.new(0, 10, 0, 40)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = group

    return group, buttonContainer
end

-- ========== Visuals Tab ==========
local visuals = tabFrames["Visuals"]
local yOffset = 5

-- Mob ESP Gruppe
local mobGroup, mobContainer = createGroup(visuals, "Mob ESP", yOffset, 4)
yOffset = yOffset + mobGroup.Size.Y.Offset + 10

local _mobESPBtn, _mobESPState = createToggleButton(mobContainer, "Mob ESP", mobOptions.ESP, function(state)
    mobOptions.ESP = state
    refreshMobESP()
    StatusText.Text = state and "Mob ESP aktiviert" or "Mob ESP deaktiviert"
end, 0, 140)

local subY = 40
local _mobChamsBtn, _mobChamsState = createToggleButton(mobContainer, "Chams", mobOptions.Chams, function(state)
    mobOptions.Chams = state
    refreshMobESP()
end, subY, 100)
subY = subY + 37

local _mobNameBtn, _mobNameState = createToggleButton(mobContainer, "Name", mobOptions.Name, function(state)
    mobOptions.Name = state
    refreshMobESP()
end, subY, 100)
subY = subY + 37

local _mobDistBtn, _mobDistState = createToggleButton(mobContainer, "Distance", mobOptions.Distance, function(state)
    mobOptions.Distance = state
    refreshMobESP()
end, subY, 100)

-- Item ESP Gruppe
local itemGroup, itemContainer = createGroup(visuals, "Item ESP", yOffset, 4)
yOffset = yOffset + itemGroup.Size.Y.Offset + 10

local _itemESPBtn, _itemESPState = createToggleButton(itemContainer, "Item ESP", itemOptions.ESP, function(state)
    itemOptions.ESP = state
    refreshItemESP()
    StatusText.Text = state and "Item ESP aktiviert" or "Item ESP deaktiviert"
end, 0, 140)

subY = 40
local _itemChamsBtn, _itemChamsState = createToggleButton(itemContainer, "Chams", itemOptions.Chams, function(state)
    itemOptions.Chams = state
    refreshItemESP()
end, subY, 100)
subY = subY + 37

local _itemNameBtn, _itemNameState = createToggleButton(itemContainer, "Name", itemOptions.Name, function(state)
    itemOptions.Name = state
    refreshItemESP()
end, subY, 100)
subY = subY + 37

local _itemDistBtn, _itemDistState = createToggleButton(itemContainer, "Distance", itemOptions.Distance, function(state)
    itemOptions.Distance = state
    refreshItemESP()
end, subY, 100)

-- ========== Player Tab ==========
local player = tabFrames["Player"]
yOffset = 5

-- Speed
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 180, 0, 32)
speedBtn.Position = UDim2.new(0, 5, 0, yOffset)
speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedBtn.BorderSizePixel = 1
speedBtn.BorderColor3 = Color3.fromRGB(139, 0, 0)
speedBtn.Text = "Speed: 16"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Font = Enum.Font.GothamMedium
speedBtn.TextSize = 14
speedBtn.Parent = player

local speedNormalColor = speedBtn.BackgroundColor3
speedBtn.MouseEnter:Connect(function()
    TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor:Lerp(Color3.fromRGB(139,0,0),0.3)}):Play()
end)
speedBtn.MouseLeave:Connect(function()
    TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor}):Play()
end)

local speedState = false
speedBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if not speedState then
                originalValues.walkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 50
                speedBtn.Text = "Speed: 50"
                speedNormalColor = Color3.fromRGB(100, 0, 0)
                TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor}):Play()
            else
                humanoid.WalkSpeed = originalValues.walkSpeed or 16
                speedBtn.Text = "Speed: " .. (originalValues.walkSpeed or 16)
                speedNormalColor = Color3.fromRGB(20, 20, 20)
                TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = speedNormalColor}):Play()
            end
            speedState = not speedState
        end
    end
end)
yOffset = yOffset + 40

-- Inf Jump
local _infJumpBtn, _infJumpState = createToggleButton(player, "Inf Jump", false, function(state)
    originalValues.infJumpActive = state
    StatusText.Text = state and "Inf Jump an" or "Inf Jump aus"
end, yOffset, 180)

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

-- ========== Exploits Tab mit Auto Pickup ==========
local exploits = tabFrames["Exploits"]
yOffset = 5

-- Auto Pickup Gruppe
local autoPickupGroup, autoPickupContainer = createGroup(exploits, "Auto Pickup", yOffset, 8)
yOffset = yOffset + autoPickupGroup.Size.Y.Offset + 10

-- Toggle für Auto Pickup
local startAutoPickup
local autoPickupActive = false
local _autoPickupBtn, _autoPickupState = createToggleButton(autoPickupContainer, "Auto Pickup", false, function(state)
    autoPickupActive = state
    if state then
        StatusText.Text = "Auto Pickup gestartet"
        startAutoPickup()
    else
        StatusText.Text = "Auto Pickup gestoppt"
    end
end, 0, 160)

-- Radius Auswahl
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0, 80, 0, 25)
radiusLabel.Position = UDim2.new(0, 5, 0, 40)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius:"
radiusLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = 14
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Parent = autoPickupContainer

local radiusInput = Instance.new("TextBox")
radiusInput.Size = UDim2.new(0, 60, 0, 25)
radiusInput.Position = UDim2.new(0, 90, 0, 40)
radiusInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
radiusInput.BorderSizePixel = 1
radiusInput.BorderColor3 = Color3.fromRGB(139, 0, 0)
radiusInput.Text = "15"
radiusInput.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = 14
radiusInput.PlaceholderText = "15"
radiusInput.Parent = autoPickupContainer

-- Option "Alle Items"
local allItemsCheckbox = Instance.new("TextButton")
allItemsCheckbox.Size = UDim2.new(0, 140, 0, 25)
allItemsCheckbox.Position = UDim2.new(0, 5, 0, 75)
allItemsCheckbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
allItemsCheckbox.BorderSizePixel = 1
allItemsCheckbox.BorderColor3 = Color3.fromRGB(139, 0, 0)
allItemsCheckbox.Text = "Alle Items"
allItemsCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
allItemsCheckbox.Font = Enum.Font.GothamMedium
allItemsCheckbox.TextSize = 14
allItemsCheckbox.Parent = autoPickupContainer

local allSelected = false
allItemsCheckbox.MouseButton1Click:Connect(function()
    allSelected = not allSelected
    allItemsCheckbox.BackgroundColor3 = allSelected and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
end)

-- Whitelist für Item-Typen (Scrollframe)
local itemListFrame = Instance.new("ScrollingFrame")
itemListFrame.Size = UDim2.new(1, -10, 0, 150)
itemListFrame.Position = UDim2.new(0, 5, 0, 110)
itemListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
itemListFrame.BorderSizePixel = 1
itemListFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.ScrollBarThickness = 6
itemListFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
itemListFrame.CanvasSize = UDim2.new(0, 0, 0, #itemNames * 30)
itemListFrame.Parent = autoPickupContainer

local itemCheckboxes = {}
local function createItemCheckbox(itemName, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(139, 0, 0)
    btn.Text = itemName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = itemListFrame

    local selected = false
    btn.MouseButton1Click:Connect(function()
        selected = not selected
        btn.BackgroundColor3 = selected and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(20, 20, 20)
    end)
    return btn, function() return selected end
end

for i, name in ipairs(itemNames) do
    local _btn, getter = createItemCheckbox(name, (i-1)*27)
    itemCheckboxes[name] = getter
end

-- Auto Pickup Funktion
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
                    if adjustBackpackRemote then
                        adjustBackpackRemote:FireServer(item)
                    elseif pickUpItemRemote then
                        pickUpItemRemote:FireServer(item)
                    end
                    task.wait(0.05)
                end
            end
        end
    end)
end

-- ========== Misc Tab ==========
local misc = tabFrames["Misc"]
local miscPlaceholder = Instance.new("TextLabel")
miscPlaceholder.Size = UDim2.new(1, -10, 0, 30)
miscPlaceholder.Position = UDim2.new(0, 5, 0, 5)
miscPlaceholder.BackgroundTransparency = 1
miscPlaceholder.Text = "Hier können später weitere Funktionen hinzugefügt werden."
miscPlaceholder.TextColor3 = Color3.fromRGB(200, 200, 200)
miscPlaceholder.Font = Enum.Font.Gotham
miscPlaceholder.TextSize = 14
miscPlaceholder.TextWrapped = true
miscPlaceholder.Parent = misc

-- ========== Info Tab mit persönlichen Daten (Blut-Design) ==========
local info = tabFrames["Info"]
yOffset = 5

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

yOffset = 5
createInfoLabel("Author: Spy", Color3.fromRGB(255, 100, 100), 18, yOffset)
yOffset = yOffset + 30
createInfoLabel("Discord: hxnrylsd", Color3.fromRGB(255, 255, 255), 16, yOffset)
yOffset = yOffset + 30
createInfoLabel("Version: 5.0", Color3.fromRGB(255, 255, 255), 16, yOffset)
yOffset = yOffset + 30
createInfoLabel("My Socials: feds.lol/spy", Color3.fromRGB(255, 255, 255), 16, yOffset)
yOffset = yOffset + 35
createInfoLabel("„Größte KI-Cheat, den ich je gesehen habe!“", Color3.fromRGB(255, 200, 200), 15, yOffset)
yOffset = yOffset + 30
createInfoLabel("Created with my favorite Slave, Deepseek.", Color3.fromRGB(200, 200, 255), 15, yOffset)
yOffset = yOffset + 40

-- Unload Button
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(0, 200, 0, 40)
unloadBtn.Position = UDim2.new(0, 5, 0, yOffset)
unloadBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
unloadBtn.BorderSizePixel = 2
unloadBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
unloadBtn.Text = "UNLOAD"
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = 18
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
    print("SPYMM entladen.")
end

unloadBtn.MouseButton1Click:Connect(unloadAll)

-- GUI-Toggle mit Einfügen-Taste
local toggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
table.insert(connections, toggleConn)

-- Status Update
local statusConn = RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    StatusText.Text = string.format("Status: Bereit | FPS: %d | Mob ESP: %s | Item ESP: %s | Inf Jump: %s | Auto: %s",
        fps,
        mobOptions.ESP and "An" or "Aus",
        itemOptions.ESP and "An" or "Aus",
        originalValues.infJumpActive and "An" or "Aus",
        autoPickupActive and "An" or "Aus")
end)
table.insert(connections, statusConn)

print("SPYMM v5.0 – Mobile Optimized geladen. Drücke Einfg (Insert) um ein-/auszublenden.")