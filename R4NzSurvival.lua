--[[
    SPYMM v5.0 - Blutiger Edition
    Didesain ulang dengan UI R4NzDev yang modern
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== KONFIGURASI AWAL ==========
local scriptKey = "SPYMM_v5"
local isRunning = true

_G[scriptKey] = function()
    isRunning = false
    if CoreGui:FindFirstChild("SPYMM") then
        CoreGui.SPYMM:Destroy()
    end
end

-- ========== PENGATURAN UKURAN ==========
local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 380 or 520
local HEIGHT = isTouch and 320 or 420
local SIDEBAR_WIDTH = isTouch and 90 or 110
local HEADER_HEIGHT = isTouch and 42 or 46
local TAB_FONT_SIZE = isTouch and 9 or 11
local TOGGLE_HEIGHT = isTouch and 32 or 36
local TEXT_SIZE_SMALL = isTouch and 10 or 12
local TEXT_SIZE_MEDIUM = isTouch and 13 or 15

-- ========== FUNGSI UTILITAS ==========
function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

function isTouchOrMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- ========== TEMA WARNA (BLUT) ==========
local themes = {
    BLUT = {
        primary = Color3.fromRGB(180, 20, 30),
        mid = Color3.fromRGB(140, 15, 25),
        dark = Color3.fromRGB(80, 8, 16),
        headerBg = Color3.fromRGB(120, 10, 25),
        accent = Color3.fromRGB(220, 40, 60),
        glow = Color3.fromRGB(160, 25, 40),
        activeTab = Color3.fromRGB(140, 20, 35),
        logText = Color3.fromRGB(255, 80, 100)
    },
    DARK = {
        primary = Color3.fromRGB(30, 30, 40),
        mid = Color3.fromRGB(25, 25, 35),
        dark = Color3.fromRGB(15, 15, 25),
        headerBg = Color3.fromRGB(20, 20, 30),
        accent = Color3.fromRGB(180, 180, 220),
        glow = Color3.fromRGB(40, 40, 55),
        activeTab = Color3.fromRGB(35, 35, 45),
        logText = Color3.fromRGB(200, 200, 220)
    }
}

local currentTheme = "BLUT"
local uiElements = {}

-- ========== MEMBUAT GUI UTAMA ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SPYMM"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Frame efek glow
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2) - 2, 0.5, -(HEIGHT/2) - 2)
glowFrame.BackgroundColor3 = Color3.fromRGB(160, 25, 40)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = 0
glowFrame.Parent = screenGui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 18)

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
header.BackgroundColor3 = Color3.fromRGB(120, 10, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 20, 30)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(140, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 8, 16))
})

local headerDot = Instance.new("Frame")
headerDot.Size = UDim2.new(0, 7, 0, 7)
headerDot.Position = UDim2.new(0, 10, 0.5, -3.5)
headerDot.BackgroundColor3 = Color3.fromRGB(220, 60, 80)
headerDot.BorderSizePixel = 0
headerDot.Parent = header
Instance.new("UICorner", headerDot).CornerRadius = UDim.new(1, 0)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 160, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SPYMM v5.0"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = TEXT_SIZE_MEDIUM
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- ========== TOMBOL MINIMIZE ==========
local iconSize = isTouch and 18 or 26

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, iconSize, 0, iconSize)
minimizeBtn.Position = UDim2.new(1, -(iconSize*2 + 10), 0.5, -iconSize/2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
minimizeBtn.Text = "⛎"
minimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = isTouch and 11 or 16
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, iconSize, 0, iconSize)
closeBtn.Position = UDim2.new(1, -(iconSize + 6), 0.5, -iconSize/2)
closeBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = isTouch and 14 or 11
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- ========== IKON MINI (saat diminimize) ==========
local miniIcon = Instance.new("ImageButton")
miniIcon.Name = "MiniIcon"
miniIcon.Size = UDim2.new(0, isTouch and 45 or 60, 0, isTouch and 45 or 60)
miniIcon.Position = UDim2.new(0, 15, 0.5, -30)
miniIcon.BackgroundColor3 = Color3.fromRGB(120, 10, 25)
miniIcon.Image = "rbxassetid://996833752434053"
miniIcon.Visible = false
miniIcon.BorderSizePixel = 0
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 14)

-- ========== FUNGSI MINIMIZE ==========
minimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    mainFrame.Visible = false
    glowFrame.Visible = false
    miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
    playClickSound()
    mainFrame.Visible = true
    glowFrame.Visible = true
    miniIcon.Visible = false
end)

-- ========== DRAG UNTUK WINDOW ==========
local isDragging = false
local dragStart, dragPosition

header.InputBegan:Connect(function(input)
    if isTouchOrMouse(input) then
        isDragging = true
        dragStart = input.Position
        dragPosition = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local frameSize = mainFrame.AbsoluteSize
        
        local newX = math.clamp(dragPosition.X.Offset + delta.X, 10, viewportSize.X - frameSize.X - 10)
        local newY = math.clamp(dragPosition.Y.Offset + delta.Y, 10, viewportSize.Y - frameSize.Y - 10)
        
        mainFrame.Position = UDim2.new(0, newX, 0, newY)
        glowFrame.Position = UDim2.new(0, newX - 2, 0, newY - 2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if isTouchOrMouse(input) then
        isDragging = false
    end
end)

-- ========== SIDEBAR ==========
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -HEADER_HEIGHT)
sidebar.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

local sideDivider = Instance.new("Frame")
sideDivider.Size = UDim2.new(0, 1, 1, -HEADER_HEIGHT)
sideDivider.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, HEADER_HEIGHT)
sideDivider.BackgroundColor3 = Color3.fromRGB(160, 25, 40)
sideDivider.BorderSizePixel = 0
sideDivider.Parent = mainFrame

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, isTouch and 4 or 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, isTouch and 8 or 12)

-- ========== TOMBOL TAB ==========
local tabButtons = {}
local tabFrames = {}
local currentTab = "MAIN"

local tabs = {
    { name = "MAIN", icon = "⚡", order = 0 },
    { name = "VISUALS", icon = "👁", order = 1 },
    { name = "PLAYER", icon = "👤", order = 2 },
    { name = "EXPLOITS", icon = "💀", order = 3 },
    { name = "INFO", icon = "📋", order = 4 }
}

function createTabButton(tabName, tabIcon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, isTouch and 38 or 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
    btn.Text = isTouch and (tabIcon .. "\n" .. tabName) or (tabIcon .. "  " .. tabName)
    btn.TextColor3 = Color3.fromRGB(130, 110, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TAB_FONT_SIZE
    btn.TextXAlignment = isTouch and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    btn.TextWrapped = true
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(100, 30, 45)
    btnStroke.Thickness = 1
    
    if not isTouch then
        local btnPad = Instance.new("UIPadding", btn)
        btnPad.PaddingLeft = UDim.new(0, 10)
    end
    
    return btn, btnStroke
end

-- Membuat area konten
local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX + 4), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Membuat halaman
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(220, 40, 60)
    page.Parent = contentFrame
    return page
end

-- ========== MEMBUAT SEMUA HALAMAN ==========
local mainPage = createPage()
local visualsPage = createPage()
local playerPage = createPage()
local exploitsPage = createPage()
local infoPage = createPage()

-- ========== VARIABEL GLOBAL ==========
local connections = {}
local mobESPInstances = {}
local itemESPInstances = {}
local originalValues = { walkSpeed = nil, infJumpActive = false }

-- ESP Options
local mobOptions = { ESP = false, Chams = false, Name = false, Distance = false }
local itemOptions = { ESP = false, Chams = false, Name = false, Distance = false }

-- Target names
local mobNames = {"Runner", "Crawler", "Riot", "Zombie"}
local itemNames = {
    "Bandage", "Barbed Wire", "Battery", "Beans", "Bloxiade", "Bloxy Cola",
    "Compound I", "Crowbar", "Dumbell", "Fuel", "Grenade", "Knife",
    "Long Ammo", "Medium Ammo", "Pistol Ammo", "Revolver", "Scrap",
    "Screws", "Shells", "Spatula", "Tray"
}

local charactersFolder = Workspace:FindFirstChild("Characters")
local droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")
local adjustBackpackRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Tools") and ReplicatedStorage.Remotes.Tools:FindFirstChild("AdjustBackpack")
local pickUpItemRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Interaction") and ReplicatedStorage.Remotes.Interaction:FindFirstChild("PickUpItem")

-- ========== FUNGSI ESP ==========
local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then return child end
    end
    return nil
end

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
    if not char:IsA("Model") or mobESPInstances[char] then return end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end
    
    local espTable = {}
    
    if mobOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(220, 0, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
        highlight.OutlineTransparency = 0.5
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
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = char.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = mobOptions.Name
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = mobOptions.Distance
        distLabel.Parent = billboard
        
        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
        
        local connection = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent then connection:Disconnect() return end
            if distLabel and distLabel.Visible then
                local myChar = player.Character
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
    if not item:IsA("Model") or itemESPInstances[item] then return end
    local mainPart = getItemMainPart(item)
    if not mainPart then return end
    
    local espTable = {}
    
    if itemOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ItemESP_Highlight"
        highlight.Adornee = item
        highlight.FillColor = Color3.fromRGB(255, 0, 150)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 100, 200)
        highlight.OutlineTransparency = 0.5
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
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = item.Name
        nameLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Visible = itemOptions.Name
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Visible = itemOptions.Distance
        distLabel.Parent = billboard
        
        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
        
        local connection = RunService.RenderStepped:Connect(function()
            if not item or not item.Parent then connection:Disconnect() return end
            if distLabel and distLabel.Visible then
                local myChar = player.Character
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
        if table.find(itemNames, child.Name) then createItemESP(child) end
    end
end

-- ========== FUNGSI MEMBUAT TOGGLE ==========
function createToggle(parent, label, defaultValue, callback, order)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
    toggleFrame.LayoutOrder = order or 1
    toggleFrame.BackgroundColor3 = Color3.fromRGB(13, 12, 20)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 9)
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -60, 1, 0)
    labelText.Position = UDim2.new(0, 10, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(210, 200, 230)
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = TEXT_SIZE_SMALL
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame
    
    local toggleWidth = isTouch and 48 or 44
    local toggleHeight = isTouch and 26 or 22
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleBg.Position = UDim2.new(1, -(toggleWidth + 6), 0.5, -toggleHeight / 2)
    toggleBg.BackgroundColor3 = defaultValue and Color3.fromRGB(180, 40, 60) or Color3.fromRGB(60, 30, 40)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleFrame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local knobSize = isTouch and 20 or 16
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position = defaultValue and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = toggleFrame
    
    local state = defaultValue
    hitbox.MouseButton1Click:Connect(function()
        state = not state
        toggleBg.BackgroundColor3 = state and Color3.fromRGB(180, 40, 60) or Color3.fromRGB(60, 30, 40)
        knob.Position = state and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)
    
    return toggleFrame
end

-- ========== HALAMAN MAIN ==========
local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 8)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainPage

local mainPad = Instance.new("UIPadding", mainPage)
mainPad.PaddingLeft = UDim.new(0, 8)
mainPad.PaddingRight = UDim.new(0, 8)
mainPad.PaddingTop = UDim.new(0, 8)

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 40)
welcomeLabel.LayoutOrder = 1
welcomeLabel.BackgroundColor3 = Color3.fromRGB(160, 20, 35)
welcomeLabel.Text = "⚔️ SPYMM v5.0 - BLUT EDITION ⚔️"
welcomeLabel.TextColor3 = Color3.new(1, 1, 1)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = TEXT_SIZE_MEDIUM
welcomeLabel.Parent = mainPage
Instance.new("UICorner", welcomeLabel).CornerRadius = UDim.new(0, 10)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 30)
statusText.LayoutOrder = 2
statusText.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
statusText.Text = "Status: Siap"
statusText.TextColor3 = Color3.fromRGB(200, 180, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = TEXT_SIZE_SMALL
statusText.Parent = mainPage
Instance.new("UICorner", statusText).CornerRadius = UDim.new(0, 8)

-- ========== HALAMAN VISUALS ==========
local visualsLayout = Instance.new("UIListLayout")
visualsLayout.Padding = UDim.new(0, 8)
visualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualsLayout.Parent = visualsPage

local visualsPad = Instance.new("UIPadding", visualsPage)
visualsPad.PaddingLeft = UDim.new(0, 8)
visualsPad.PaddingRight = UDim.new(0, 8)
visualsPad.PaddingTop = UDim.new(0, 8)

-- Mob ESP Group
local mobGroup = Instance.new("Frame")
mobGroup.Size = UDim2.new(1, 0, 0, isTouch and 180 or 160)
mobGroup.LayoutOrder = 1
mobGroup.BackgroundColor3 = Color3.fromRGB(13, 12, 20)
mobGroup.BorderSizePixel = 0
mobGroup.Parent = visualsPage
Instance.new("UICorner", mobGroup).CornerRadius = UDim.new(0, 12)

local mobTitle = Instance.new("TextLabel")
mobTitle.Size = UDim2.new(1, -16, 0, 28)
mobTitle.Position = UDim2.new(0, 8, 0, 4)
mobTitle.BackgroundTransparency = 1
mobTitle.Text = "👹 MOB ESP"
mobTitle.TextColor3 = Color3.fromRGB(220, 60, 80)
mobTitle.Font = Enum.Font.GothamBold
mobTitle.TextSize = TEXT_SIZE_SMALL
mobTitle.TextXAlignment = Enum.TextXAlignment.Left
mobTitle.Parent = mobGroup

createToggle(mobGroup, "Mob ESP", false, function(val)
    mobOptions.ESP = val
    refreshMobESP()
end, 1)

createToggle(mobGroup, "Chams", false, function(val)
    mobOptions.Chams = val
    refreshMobESP()
end, 2)

createToggle(mobGroup, "Name", false, function(val)
    mobOptions.Name = val
    refreshMobESP()
end, 3)

createToggle(mobGroup, "Distance", false, function(val)
    mobOptions.Distance = val
    refreshMobESP()
end, 4)

-- Item ESP Group
local itemGroup = Instance.new("Frame")
itemGroup.Size = UDim2.new(1, 0, 0, isTouch and 180 or 160)
itemGroup.LayoutOrder = 2
itemGroup.BackgroundColor3 = Color3.fromRGB(13, 12, 20)
itemGroup.BorderSizePixel = 0
itemGroup.Parent = visualsPage
Instance.new("UICorner", itemGroup).CornerRadius = UDim.new(0, 12)

local itemTitle = Instance.new("TextLabel")
itemTitle.Size = UDim2.new(1, -16, 0, 28)
itemTitle.Position = UDim2.new(0, 8, 0, 4)
itemTitle.BackgroundTransparency = 1
itemTitle.Text = "📦 ITEM ESP"
itemTitle.TextColor3 = Color3.fromRGB(220, 60, 80)
itemTitle.Font = Enum.Font.GothamBold
itemTitle.TextSize = TEXT_SIZE_SMALL
itemTitle.TextXAlignment = Enum.TextXAlignment.Left
itemTitle.Parent = itemGroup

createToggle(itemGroup, "Item ESP", false, function(val)
    itemOptions.ESP = val
    refreshItemESP()
end, 1)

createToggle(itemGroup, "Chams", false, function(val)
    itemOptions.Chams = val
    refreshItemESP()
end, 2)

createToggle(itemGroup, "Name", false, function(val)
    itemOptions.Name = val
    refreshItemESP()
end, 3)

createToggle(itemGroup, "Distance", false, function(val)
    itemOptions.Distance = val
    refreshItemESP()
end, 4)

-- ========== HALAMAN PLAYER ==========
local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 8)
playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerLayout.Parent = playerPage

local playerPad = Instance.new("UIPadding", playerPage)
playerPad.PaddingLeft = UDim.new(0, 8)
playerPad.PaddingRight = UDim.new(0, 8)
playerPad.PaddingTop = UDim.new(0, 8)

-- Speed Button
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1, 0, 0, TOGGLE_HEIGHT)
speedBtn.LayoutOrder = 1
speedBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
speedBtn.Text = "⚡ Speed: Normal (16)"
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = TEXT_SIZE_SMALL
speedBtn.Parent = playerPage
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 9)

local speedState = false
local originalSpeed = nil

speedBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if not speedState then
                originalSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 50
                speedBtn.Text = "⚡ Speed: 50 (Cepat)"
                speedBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 50)
            else
                humanoid.WalkSpeed = originalSpeed or 16
                speedBtn.Text = "⚡ Speed: Normal (16)"
                speedBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
            end
            speedState = not speedState
            playClickSound()
        end
    end
end)

-- Inf Jump
local infJumpState = false
createToggle(playerPage, "🦘 Infinite Jump", false, function(val)
    infJumpState = val
    originalValues.infJumpActive = val
end, 2)

local jumpConn = UserInputService.JumpRequest:Connect(function()
    if infJumpState then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)
table.insert(connections, jumpConn)

-- ========== HALAMAN EXPLOITS (Auto Pickup) ==========
local exploitsLayout = Instance.new("UIListLayout")
exploitsLayout.Padding = UDim.new(0, 8)
exploitsLayout.SortOrder = Enum.SortOrder.LayoutOrder
exploitsLayout.Parent = exploitsPage

local exploitsPad = Instance.new("UIPadding", exploitsPage)
exploitsPad.PaddingLeft = UDim.new(0, 8)
exploitsPad.PaddingRight = UDim.new(0, 8)
exploitsPad.PaddingTop = UDim.new(0, 8)

local autoPickupActive = false
local autoPickupConnection = nil

createToggle(exploitsPage, "📦 Auto Pickup", false, function(val)
    autoPickupActive = val
    if val and not autoPickupConnection then
        autoPickupConnection = RunService.Heartbeat:Connect(function()
            if not autoPickupActive then return end
            local char = player.Character
            if not char then return end
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local radius = 15
            local pos = rootPart.Position
            
            if droppedItemsFolder then
                for _, item in ipairs(droppedItemsFolder:GetChildren()) do
                    local mainPart = item.PrimaryPart or getItemMainPart(item)
                    if mainPart and (mainPart.Position - pos).Magnitude <= radius then
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
        table.insert(connections, autoPickupConnection)
    elseif not val and autoPickupConnection then
        autoPickupConnection:Disconnect()
        autoPickupConnection = nil
    end
end, 1)

local radiusFrame = Instance.new("Frame")
radiusFrame.Size = UDim2.new(1, 0, 0, TOGGLE_HEIGHT)
radiusFrame.LayoutOrder = 2
radiusFrame.BackgroundColor3 = Color3.fromRGB(13, 12, 20)
radiusFrame.BorderSizePixel = 0
radiusFrame.Parent = exploitsPage
Instance.new("UICorner", radiusFrame).CornerRadius = UDim.new(0, 9)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0, 60, 1, 0)
radiusLabel.Position = UDim2.new(0, 10, 0, 0)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius:"
radiusLabel.TextColor3 = Color3.fromRGB(200, 180, 200)
radiusLabel.Font = Enum.Font.GothamBold
radiusLabel.TextSize = TEXT_SIZE_SMALL
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Parent = radiusFrame

local radiusInput = Instance.new("TextBox")
radiusInput.Size = UDim2.new(0, 80, 0, 28)
radiusInput.Position = UDim2.new(1, -90, 0.5, -14)
radiusInput.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
radiusInput.Text = "15"
radiusInput.TextColor3 = Color3.new(1, 1, 1)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = TEXT_SIZE_SMALL
radiusInput.Parent = radiusFrame
Instance.new("UICorner", radiusInput).CornerRadius = UDim.new(0, 7)

-- ========== HALAMAN INFO ==========
local infoLayout = Instance.new("UIListLayout")
infoLayout.Padding = UDim.new(0, 8)
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Parent = infoPage

local infoPad = Instance.new("UIPadding", infoPage)
infoPad.PaddingLeft = UDim.new(0, 8)
infoPad.PaddingRight = UDim.new(0, 8)
infoPad.PaddingTop = UDim.new(0, 8)

local infoItems = {
    { text = "⚔️ SPYMM v5.0 - Blutiger Edition", color = Color3.fromRGB(220, 60, 80), size = 14 },
    { text = "Author: Spy", color = Color3.fromRGB(255, 150, 150), size = 12 },
    { text = "Discord: hxnrylsd", color = Color3.fromRGB(200, 200, 220), size = 11 },
    { text = "My Socials: feds.lol/spy", color = Color3.fromRGB(200, 200, 220), size = 11 },
    { text = " ", color = Color3.fromRGB(100, 100, 100), size = 8 },
    { text = "Fitur:", color = Color3.fromRGB(220, 60, 80), size = 12 },
    { text = "✓ Mob ESP (Chams, Name, Distance)", color = Color3.fromRGB(180, 180, 200), size = 10 },
    { text = "✓ Item ESP (Chams, Name, Distance)", color = Color3.fromRGB(180, 180, 200), size = 10 },
    { text = "✓ Speed Hack", color = Color3.fromRGB(180, 180, 200), size = 10 },
    { text = "✓ Infinite Jump", color = Color3.fromRGB(180, 180, 200), size = 10 },
    { text = "✓ Auto Pickup Item", color = Color3.fromRGB(180, 180, 200), size = 10 },
    { text = " ", color = Color3.fromRGB(100, 100, 100), size = 8 },
    { text = "Tekan INSERT untuk toggle GUI", color = Color3.fromRGB(150, 150, 180), size = 10 }
}

for i, item in ipairs(infoItems) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
    label.LayoutOrder = i
    label.BackgroundTransparency = 1
    label.Text = item.text
    label.TextColor3 = item.color
    label.Font = Enum.Font.Gotham
    label.TextSize = item.size
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = infoPage
end

-- Unload Button
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, 0, 0, 45)
unloadBtn.LayoutOrder = #infoItems + 1
unloadBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 40)
unloadBtn.Text = "UNLOAD / CLOSE"
unloadBtn.TextColor3 = Color3.new(1, 1, 1)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = TEXT_SIZE_MEDIUM
unloadBtn.Parent = infoPage
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0, 10)

unloadBtn.MouseButton1Click:Connect(function()
    if _G[scriptKey] then _G[scriptKey]() end
end)

-- ========== TAB NAVIGATION ==========
for i, tab in ipairs(tabs) do
    local btn, stroke = createTabButton(tab.name, tab.icon, tab.order)
    tabButtons[tab.name] = { btn = btn, stroke = stroke }
    
    btn.MouseButton1Click:Connect(function()
        if currentTab == tab.name then return end
        
        -- Sembunyikan semua halaman
        local pages = { mainPage, visualsPage, playerPage, exploitsPage, infoPage }
        for _, page in ipairs(pages) do
            if page then page.Visible = false end
        end
        
        -- Tampilkan halaman yang dipilih
        if tab.name == "MAIN" then mainPage.Visible = true
        elseif tab.name == "VISUALS" then visualsPage.Visible = true
        elseif tab.name == "PLAYER" then playerPage.Visible = true
        elseif tab.name == "EXPLOITS" then exploitsPage.Visible = true
        elseif tab.name == "INFO" then infoPage.Visible = true
        end
        
        -- Update tampilan tab
        for _, tb in pairs(tabButtons) do
            tb.btn.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
            tb.btn.TextColor3 = Color3.fromRGB(130, 110, 150)
            tb.stroke.Color = Color3.fromRGB(100, 30, 45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(140, 20, 35)
        btn.TextColor3 = Color3.new(1, 1, 1)
        stroke.Color = Color3.fromRGB(220, 60, 80)
        
        currentTab = tab.name
        playClickSound()
    end)
end

-- Aktifkan halaman default
mainPage.Visible = true
tabButtons["MAIN"].btn.BackgroundColor3 = Color3.fromRGB(140, 20, 35)
tabButtons["MAIN"].btn.TextColor3 = Color3.new(1, 1, 1)
tabButtons["MAIN"].stroke.Color = Color3.fromRGB(220, 60, 80)

-- ========== STATUS UPDATE ==========
local statusConn = RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    statusText.Text = string.format("Status: Ready | FPS: %d | Mob ESP: %s | Item ESP: %s | Inf Jump: %s | Auto Pickup: %s",
        fps,
        mobOptions.ESP and "ON" or "OFF",
        itemOptions.ESP and "ON" or "OFF",
        infJumpState and "ON" or "OFF",
        autoPickupActive and "ON" or "OFF")
end)
table.insert(connections, statusConn)

-- ========== INSERT TOGGLE ==========
local toggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        if mainFrame.Visible then
            mainFrame.Visible = false
            glowFrame.Visible = false
            miniIcon.Visible = true
        else
            mainFrame.Visible = true
            glowFrame.Visible = true
            miniIcon.Visible = false
        end
        playClickSound()
    end
end)
table.insert(connections, toggleConn)

-- ========== CLEANUP ON UNLOAD ==========
_G[scriptKey] = function()
    isRunning = false
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    for char, _ in pairs(mobESPInstances) do
        pcall(function() removeMobESP(char) end)
    end
    for item, _ in pairs(itemESPInstances) do
        pcall(function() removeItemESP(item) end)
    end
    if autoPickupConnection then
        pcall(function() autoPickupConnection:Disconnect() end)
    end
    if speedState then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalSpeed or 16
            end
        end
    end
    if screenGui then screenGui:Destroy() end
    print("SPYMM v5.0 - Unloaded")
end

print("✅ SPYMM v5.0 - Blutiger Edition Loaded!")
print("🔹 Tekan tombol minimize (⛎) atau INSERT untuk menyembunyikan GUI")
print("🔹 Tekan ikon mini untuk membuka kembali")