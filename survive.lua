-- ============================================
-- R4NzDev UI + ZHub Cheat Features (FULL SCRIPT)
-- Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS | INFO
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local scriptKey = "R4NzDev_ZHub_Full"

-- ========== ANTI-DOUBLE-RUN ==========
if _G[scriptKey] then
    pcall(function() _G[scriptKey]() end)
    wait(0.5)
end

local isRunning = true
local function CleanupScript()
    isRunning = false
    
    -- Hapus GUI
    local gui = CoreGui:FindFirstChild("R4NzDev")
    if gui then gui:Destroy() end
    
    -- Hentikan semua koneksi fitur
    if espUpdateConnection then espUpdateConnection:Disconnect() end
    if fpsConnection then fpsConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if aimbotConnection then aimbotConnection:Disconnect() end
    if killAuraConnection then killAuraConnection:Disconnect() end
    if collectLoopConnection then collectLoopConnection:Disconnect() end
    if reloadLoopConnection then reloadLoopConnection:Disconnect() end
    if statusUpdateConnection then statusUpdateConnection:Disconnect() end
    if enemyMonitor then enemyMonitor:Disconnect() end
    if enemyRemovedMonitor then enemyRemovedMonitor:Disconnect() end
    
    -- Hapus fullbright connections
    for _, conn in pairs(fullbrightConnections or {}) do
        if conn then conn:Disconnect() end
    end
    
    -- Hapus visual effects
    if radiusRing then radiusRing:Destroy() end
    if fovCircle then fovCircle:Destroy() end
    
    print("✅ Script dimatikan!")
end

_G[scriptKey] = CleanupScript

-- ========================== UI SETTINGS ==========================
local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 300 or 460
local HEIGHT = isTouch and 250 or 310
local SIDEBAR_WIDTH = isTouch and 85 or 105
local HEADER_HEIGHT = isTouch and 42 or 46
local TAB_FONT_SIZE = isTouch and 9 or 11
local TOGGLE_HEIGHT = isTouch and 32 or 36
local TEXT_SIZE_SMALL = isTouch and 10 or 12
local TEXT_SIZE_MEDIUM = isTouch and 13 or 15

function isTouchOrMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- ========================== THEMES ==========================
local themes = {
    CYBERPUNK = {
        primary = Color3.fromRGB(100, 30, 220), mid = Color3.fromRGB(65, 15, 160), dark = Color3.fromRGB(30, 10, 100),
        headerBg = Color3.fromRGB(55, 15, 120), accent = Color3.fromRGB(150, 80, 255), glow = Color3.fromRGB(100, 40, 200),
        activeTab = Color3.fromRGB(65, 20, 150), logText = Color3.fromRGB(160, 100, 255)
    },
    CRIMSON = {
        primary = Color3.fromRGB(200, 20, 40), mid = Color3.fromRGB(150, 15, 30), dark = Color3.fromRGB(80, 8, 16),
        headerBg = Color3.fromRGB(120, 10, 25), accent = Color3.fromRGB(255, 80, 100), glow = Color3.fromRGB(200, 30, 50),
        activeTab = Color3.fromRGB(160, 15, 35), logText = Color3.fromRGB(255, 100, 120)
    },
    MATRIX = {
        primary = Color3.fromRGB(0, 180, 60), mid = Color3.fromRGB(0, 130, 40), dark = Color3.fromRGB(0, 60, 20),
        headerBg = Color3.fromRGB(0, 80, 25), accent = Color3.fromRGB(50, 255, 120), glow = Color3.fromRGB(0, 160, 60),
        activeTab = Color3.fromRGB(0, 110, 40), logText = Color3.fromRGB(80, 255, 140)
    },
    SAKURA = {
        primary = Color3.fromRGB(210, 60, 140), mid = Color3.fromRGB(170, 40, 110), dark = Color3.fromRGB(100, 20, 65),
        headerBg = Color3.fromRGB(130, 30, 85), accent = Color3.fromRGB(255, 130, 200), glow = Color3.fromRGB(210, 70, 150),
        activeTab = Color3.fromRGB(160, 40, 110), logText = Color3.fromRGB(255, 150, 210)
    },
    OCEAN = {
        primary = Color3.fromRGB(0, 100, 220), mid = Color3.fromRGB(0, 70, 170), dark = Color3.fromRGB(0, 35, 100),
        headerBg = Color3.fromRGB(0, 55, 130), accent = Color3.fromRGB(60, 160, 255), glow = Color3.fromRGB(0, 110, 220),
        activeTab = Color3.fromRGB(0, 75, 170), logText = Color3.fromRGB(80, 180, 255)
    },
    FLAME = {
        primary = Color3.fromRGB(220, 100, 0), mid = Color3.fromRGB(180, 70, 0), dark = Color3.fromRGB(100, 35, 0),
        headerBg = Color3.fromRGB(140, 55, 0), accent = Color3.fromRGB(255, 160, 50), glow = Color3.fromRGB(220, 110, 0),
        activeTab = Color3.fromRGB(170, 65, 0), logText = Color3.fromRGB(255, 180, 70)
    }
}

local currentTheme = "CYBERPUNK"
local uiElements = {}

function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    currentTheme = themeName
    
    if uiElements.Header then uiElements.Header.BackgroundColor3 = theme.headerBg end
    if uiElements.HeaderGrad then uiElements.HeaderGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.primary), ColorSequenceKeypoint.new(0.6, theme.mid), ColorSequenceKeypoint.new(1, theme.dark)}) end
    if uiElements.HeaderLine then uiElements.HeaderLine.BackgroundColor3 = theme.accent end
    if uiElements.GlowWrapper then uiElements.GlowWrapper.BackgroundColor3 = theme.glow end
    if uiElements.SideDivider then uiElements.SideDivider.BackgroundColor3 = theme.mid end
    if uiElements.ScrollBar then uiElements.ScrollBar.ScrollBarImageColor3 = theme.accent end
    if uiElements.UtilScrollBar then uiElements.UtilScrollBar.ScrollBarImageColor3 = theme.accent end
    if uiElements.pcStroke then uiElements.pcStroke.Color = theme.accent end
    if uiElements.scStroke then uiElements.scStroke.Color = theme.accent end
    if uiElements.vcStroke then uiElements.vcStroke.Color = theme.accent end
end

-- ========================== GUI CREATION ==========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Glow frame
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2) - 2, 0.5, -(HEIGHT/2) - 2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.Parent = screenGui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 18)
uiElements.GlowWrapper = glowFrame

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Resize handle
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 24, 0, 24)
resizeHandle.BackgroundColor3 = Color3.fromRGB(65, 15, 160)
resizeHandle.Text = "↘️"
resizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = isTouch and 12 or 14
resizeHandle.Parent = screenGui
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 8)

local resizeStroke = Instance.new("UIStroke", resizeHandle)
resizeStroke.Color = Color3.fromRGB(150, 80, 255)
resizeStroke.Thickness = 1.5
resizeStroke.Transparency = 0.1
uiElements.ResizeHandle = resizeHandle
uiElements.ResizeStroke = resizeStroke

function syncResizeHandle()
    local pos = mainFrame.Position
    local size = mainFrame.Size
    local handleSize = resizeHandle.Size.X.Offset
    resizeHandle.Position = UDim2.new(pos.X.Scale, (pos.X.Offset + size.X.Offset) - handleSize, pos.Y.Scale, (pos.Y.Offset + size.Y.Offset) - handleSize)
end

RunService.RenderStepped:Connect(syncResizeHandle)
syncResizeHandle()

function syncGlowWrapper()
    local pos = mainFrame.Position
    glowFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 2, pos.Y.Scale, pos.Y.Offset - 2)
    glowFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset + 4, 0, mainFrame.Size.Y.Offset + 4)
    syncResizeHandle()
end

-- Resize logic
local isResizing = false
local dragStart, startWidth, startHeight

function clampWindow(w, h)
    return math.clamp(w, isTouch and 260 or 300, isTouch and 500 or 720), math.clamp(h, isTouch and 200 or 230, isTouch and 480 or 600)
end

resizeHandle.InputBegan:Connect(function(input)
    if not isTouchOrMouse(input) then return end
    isResizing = true
    dragStart = input.Position
    startWidth = mainFrame.Size.X.Offset
    startHeight = mainFrame.Size.Y.Offset
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then isResizing = false end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newWidth = math.max(startWidth + delta.X, isTouch and 260 or 300)
        local newHeight = math.max(startHeight + delta.Y, isTouch and 200 or 230)
        newWidth, newHeight = clampWindow(newWidth, newHeight)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        syncGlowWrapper()
    end
end)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
header.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)
uiElements.Header = header

local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 220)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 15, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 10, 100))})
headerGrad.Rotation = 135
uiElements.HeaderGrad = headerGrad

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
headerLine.BorderSizePixel = 0
headerLine.Parent = header
uiElements.HeaderLine = headerLine

local lineGrad = Instance.new("UIGradient", headerLine)
lineGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 130, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255))})

local headerDot = Instance.new("Frame")
headerDot.Size = UDim2.new(0, 7, 0, 7)
headerDot.Position = UDim2.new(0, 10, 0.5, -3.5)
headerDot.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
headerDot.BorderSizePixel = 0
headerDot.Parent = header
Instance.new("UICorner", headerDot).CornerRadius = UDim.new(1, 0)
uiElements.HeaderDot = headerDot

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 140, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "R4NzDev"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = TEXT_SIZE_MEDIUM
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Premium badge
if not isTouch then
    local badgeFrame = Instance.new("Frame")
    badgeFrame.Size = UDim2.new(0, 64, 0, 17)
    badgeFrame.Position = UDim2.new(0, 130, 0.5, -8.5)
    badgeFrame.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
    badgeFrame.BorderSizePixel = 0
    badgeFrame.Parent = header
    Instance.new("UICorner", badgeFrame).CornerRadius = UDim.new(1, 0)
    uiElements.PremBadge = badgeFrame
    
    local badgeGrad = Instance.new("UIGradient", badgeFrame)
    badgeGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 80, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 40, 200))})
    uiElements.BadgeGrad = badgeGrad
    
    local badgeText = Instance.new("TextLabel")
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = "PREMIUM"
    badgeText.TextColor3 = Color3.new(1, 1, 1)
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 9
    badgeText.Parent = badgeFrame
end

-- Buttons
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

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -HEADER_HEIGHT)
sidebar.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

local sideDivider = Instance.new("Frame")
sideDivider.Size = UDim2.new(0, 1, 1, -HEADER_HEIGHT)
sideDivider.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, HEADER_HEIGHT)
sideDivider.BackgroundColor3 = Color3.fromRGB(70, 30, 140)
sideDivider.BorderSizePixel = 0
sideDivider.Parent = mainFrame
uiElements.SideDivider = sideDivider

local divGrad = Instance.new("UIGradient", sideDivider)
divGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 30, 140)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 60, 220)), ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 140))})
divGrad.Rotation = 90

-- Mini icon for minimized state
local miniIcon = Instance.new("ImageButton")
miniIcon.Size = UDim2.new(0, isTouch and 35 or 52, 0, isTouch and 35 or 52)
miniIcon.Position = UDim2.new(0, 10, 0.5, -26)
miniIcon.BackgroundColor3 = Color3.fromRGB(55, 15, 130)
miniIcon.Image = "rbxassetid://996833752434053"
miniIcon.Visible = false
miniIcon.BorderSizePixel = 0
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 14)

local miniIconStroke = Instance.new("UIStroke", miniIcon)
miniIconStroke.Color = Color3.fromRGB(150, 80, 255)
miniIconStroke.Thickness = 2
miniIconStroke.Transparency = 0.1
uiElements.MiniIcon = miniIcon
uiElements.MiniIconStroke = miniIconStroke

minimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    mainFrame.Visible = false
    glowFrame.Visible = false
    resizeHandle.Visible = false
    miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
    playClickSound()
    mainFrame.Visible = true
    glowFrame.Visible = true
    resizeHandle.Visible = true
    miniIcon.Visible = false
end)

-- Content area
local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX + 4), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Tab buttons
local tabButtons = {}
local tabESP, tabCombat, tabCollect, tabMovement, tabVisuals, tabInfo

function createTabBtn(btnText, btnIcon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, isTouch and 38 or 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = isTouch and btnIcon .. ("\n" .. btnText) or btnIcon .. ("  " .. btnText)
    btn.TextColor3 = Color3.fromRGB(120, 110, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TAB_FONT_SIZE
    btn.TextXAlignment = isTouch and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    btn.TextWrapped = true
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    
    if not isTouch then
        local btnPad = Instance.new("UIPadding", btn)
        btnPad.PaddingLeft = UDim.new(0, 10)
    end
    
    table.insert(tabButtons, { btn = btn, stroke = btnStroke })
    return btn
end

function setActiveTab(activeBtn)
    for _, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(120, 110, 150)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
    end
    
    local theme = themes[currentTheme] and themes[currentTheme].activeTab or Color3.fromRGB(65, 20, 150)
    local accent = themes[currentTheme] and themes[currentTheme].accent or Color3.fromRGB(150, 80, 255)
    activeBtn.BackgroundColor3 = theme
    activeBtn.TextColor3 = Color3.new(1, 1, 1)
    
    for _, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = accent
            tab.stroke.Transparency = 0.1
        end
    end
end

-- Create 6 tabs
tabESP = createTabBtn("ESP", "👁️", 0)
tabCombat = createTabBtn("COMBAT", "⚔️", 1)
tabCollect = createTabBtn("COLLECT", "🎒", 2)
tabMovement = createTabBtn("MOVEMENT", "🚀", 3)
tabVisuals = createTabBtn("VISUALS", "🌟", 4)
tabInfo = createTabBtn("INFO", "📋", 5)

-- Create pages
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = isTouch and 3 or 2
    page.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = contentFrame
    return page
end

local espPage = createPage()
local combatPage = createPage()
local collectPage = createPage()
local movementPage = createPage()
local visualsPage = createPage()
local infoPage = createPage()

-- Page padding
local function addPagePadding(page)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 10)
end

addPagePadding(espPage)
addPagePadding(combatPage)
addPagePadding(collectPage)
addPagePadding(movementPage)
addPagePadding(visualsPage)
addPagePadding(infoPage)

-- Page layouts
local espLayout = Instance.new("UIListLayout", espPage)
espLayout.Padding = UDim.new(0, 8)
espLayout.SortOrder = Enum.SortOrder.LayoutOrder

local combatLayout = Instance.new("UIListLayout", combatPage)
combatLayout.Padding = UDim.new(0, 8)
combatLayout.SortOrder = Enum.SortOrder.LayoutOrder

local collectLayout = Instance.new("UIListLayout", collectPage)
collectLayout.Padding = UDim.new(0, 8)
collectLayout.SortOrder = Enum.SortOrder.LayoutOrder

local movementLayout = Instance.new("UIListLayout", movementPage)
movementLayout.Padding = UDim.new(0, 8)
movementLayout.SortOrder = Enum.SortOrder.LayoutOrder

local visualsLayout = Instance.new("UIListLayout", visualsPage)
visualsLayout.Padding = UDim.new(0, 8)
visualsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local infoLayout = Instance.new("UIListLayout", infoPage)
infoLayout.Padding = UDim.new(0, 8)
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ========================== FITUR CHEAT (DARI SKATA) ==========================
-- ESP Settings & Variables
local espData = {}
local lastESPUpdate = 0
local espUpdateInterval = 0.05
local espUpdateConnection = nil
local enemyMonitor = nil
local enemyRemovedMonitor = nil

local espSettings = {
    TrackEnemies = false,
    DetectionRadius = 500,
    ShowDistance = true,
    EnemyColor = Color3.fromRGB(255, 0, 0)
}

-- Aimbot Settings
local aimbotSettings = { Enabled = false, Smoothness = 0.3, TargetPart = 'Head' }
local aimbotConnection = nil

-- Kill Aura Settings
local killAuraSettings = { Enabled = false, AttackDelay = 0.1, MaxTargets = 3 }
local killAuraActive = false
local lastAttackTime = 0
local killAuraConnection = nil

-- Auto-Collect Settings
local collectSettings = { Enabled = false, Mode = 'Radius', Radius = 20, FOV = 150, CollectDelay = 0.5 }
local radiusRing = nil
local fovCircle = nil
local lastCollectTime = 0
local collectLoopConnection = nil

-- Fly Mode Settings
local flySettings = { Enabled = false, Speed = 50 }
local flyConnection = nil

-- Fullbright Settings
local fullbrightSettings = { Enabled = false }
local originalLighting = {}
local fullbrightConnections = {}

-- Auto-Reload Settings
local reloadSettings = { Enabled = false }
local lastReloadTime = 0
local reloadingWeapons = {}
local reloadLoopConnection = nil

-- FPS Counter
local fpsConnection = nil
local fpsStartTime = tick()
local fpsFrameCount = 0
local fpsLabel = nil

-- Status Bar
local statusFrame = nil
local hpFill = nil
local hpText = nil
local staminaFill = nil
local staminaText = nil
local statusUpdateConnection = nil

-- ========== ESP FUNCTIONS ==========
function GetHRP(instance)
    if instance:IsA('Model') then
        return instance:FindFirstChild('HumanoidRootPart') or instance:FindFirstChild('Head') or instance.PrimaryPart
    end
    return instance
end

function GetHumanoid(instance)
    if instance:IsA('Model') then
        return instance:FindFirstChild('Humanoid')
    end
    return nil
end

function CreateHighlight(entity, color)
    local highlight = Instance.new('Highlight')
    highlight.Name = 'ZHubESP'
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.3
    highlight.Parent = entity
    return highlight
end

function CreateDistanceLabel(entity, text)
    local billboard = Instance.new('BillboardGui')
    billboard.Name = 'DistanceLabel'
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = entity
    
    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    return billboard, label
end

function RemoveESP(entity)
    local data = espData[entity]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.distLabel then data.distLabel:Destroy() end
        espData[entity] = nil
    end
end

function AddEnemy(entity)
    if espData[entity] then return end
    local humanoid = GetHumanoid(entity)
    local hrp = GetHRP(entity)
    if not humanoid or not hrp or humanoid.Health <= 0 then return end
    
    local color = espSettings.EnemyColor
    local highlight = CreateHighlight(entity, color)
    local billboard, label = CreateDistanceLabel(entity, entity.Name)
    
    espData[entity] = {
        entryType = 'enemy',
        humanoid = humanoid,
        hrp = hrp,
        highlight = highlight,
        distLabel = billboard,
        distText = label,
        displayName = entity.Name,
        lastColor = color,
        lastVisible = false,
        lastDistanceStuds = 0,
        lastRadius = espSettings.DetectionRadius,
        lastShowDist = espSettings.ShowDistance
    }
end

function UpdateESP()
    local now = os.clock()
    if now - lastESPUpdate < espUpdateInterval then return end
    lastESPUpdate = now
    
    local localChar = player.Character
    local localHrp = localChar and localChar:FindFirstChild('HumanoidRootPart')
    if not localHrp then return end
    
    local localPos = localHrp.Position
    local radius = espSettings.DetectionRadius
    local showDistance = espSettings.ShowDistance
    local trackEnemies = espSettings.TrackEnemies
    
    for entity, data in pairs(espData) do
        if not entity or entity.Parent == nil then
            RemoveESP(entity)
            goto continue
        end
        
        if data.entryType == 'enemy' then
            if not trackEnemies or entity == localChar or not data.humanoid or data.humanoid.Health <= 0 then
                RemoveESP(entity)
                goto continue
            end
        end
        
        local targetHrp = data.hrp or GetHRP(entity)
        if not targetHrp then
            RemoveESP(entity)
            goto continue
        end
        
        local lastVisible = data.lastVisible
        local samePos = data.lastPlayerPos and (data.lastPlayerPos - localPos).Magnitude <= 0.05
        local sameObjPos = data.lastObjectPos and (data.lastObjectPos - targetHrp.Position).Magnitude <= 0.05
        local needUpdate = not samePos or not sameObjPos or lastVisible == nil or data.lastRadius ~= radius or data.lastShowDist ~= showDistance
        
        local distance = data.lastDistanceStuds
        local visible = lastVisible
        
        if needUpdate then
            distance = math.floor((localPos - targetHrp.Position).Magnitude)
            visible = distance <= radius
            data.lastPlayerPos = localPos
            data.lastObjectPos = targetHrp.Position
            data.lastDistanceStuds = distance
            data.lastRadius = radius
        end
        
        if visible == nil then visible = false end
        data.lastVisible = visible
        data.lastShowDist = showDistance
        
        if data.highlight and data.highlight.Parent and lastVisible ~= visible then
            data.highlight.Enabled = visible
        end
        
        if data.distLabel and data.distLabel.Parent then
            if lastVisible ~= visible then data.distLabel.Enabled = visible end
            if visible and data.distText then
                local displayName = data.displayName or entity.Name
                if needUpdate or data.distText.Text == '' then
                    local text = showDistance and (displayName .. ' [' .. distance .. ' studs]') or displayName
                    if data.distText.Text ~= text then data.distText.Text = text end
                end
            end
        end
        
        if visible and data.entryType == 'enemy' and data.humanoid and data.highlight then
            local healthPercent = data.humanoid.Health / data.humanoid.MaxHealth
            local color
            if healthPercent > 0.5 then
                color = Color3.fromRGB(80, 220, 80)
            elseif healthPercent > 0.25 then
                color = Color3.fromRGB(255, 200, 50)
            else
                color = Color3.fromRGB(220, 60, 60)
            end
            if data.lastColor ~= color then
                data.highlight.FillColor = color
                data.highlight.OutlineColor = color
                data.lastColor = color
            end
            if data.distText and data.distText.TextColor3 ~= color then
                data.distText.TextColor3 = color
            end
        end
        
        ::continue::
    end
end

function StartEnemyESP()
    if enemyMonitor then enemyMonitor:Disconnect() end
    if enemyRemovedMonitor then enemyRemovedMonitor:Disconnect() end
    
    local characters = Workspace:FindFirstChild('Characters')
    if not characters then return end
    
    for _, child in ipairs(characters:GetChildren()) do AddEnemy(child) end
    
    enemyMonitor = characters.ChildAdded:Connect(AddEnemy)
    enemyRemovedMonitor = characters.ChildRemoved:Connect(RemoveESP)
end

function StopEnemyESP()
    if enemyMonitor then enemyMonitor:Disconnect() end
    if enemyRemovedMonitor then enemyRemovedMonitor:Disconnect() end
    for entity, _ in pairs(espData) do
        if espData[entity] and espData[entity].entryType == 'enemy' then RemoveESP(entity) end
    end
end

-- ========== AIMBOT FUNCTIONS ==========
function GetClosestEnemy()
    local localChar = player.Character
    local localHrp = localChar and localChar:FindFirstChild('HumanoidRootPart')
    if not localHrp then return nil end
    
    local bestTarget = nil
    local bestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for entity, data in pairs(espData) do
        if data.entryType == 'enemy' and data.hrp and data.hrp.Parent then
            local targetPart = data.hrp
            if aimbotSettings.TargetPart == 'Head' then
                local head = entity:FindFirstChild('Head')
                if head then targetPart = head end
            end
            
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if distToCenter < bestDistance then
                    bestDistance = distToCenter
                    bestTarget = targetPart
                end
            end
        end
    end
    
    return bestTarget
end

function AimLocker()
    if not aimbotSettings.Enabled then return end
    
    local character = player.Character
    local humanoid = character and character:FindFirstChild('Humanoid')
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then return end
    end
    
    local target = GetClosestEnemy()
    if target then
        local screenPos, onScreen = camera:WorldToViewportPoint(target.Position)
        if onScreen then
            local mousePos = UserInputService:GetMouseLocation()
            local deltaX = (screenPos.X - mousePos.X) * aimbotSettings.Smoothness
            local deltaY = (screenPos.Y - mousePos.Y) * aimbotSettings.Smoothness
            
            if math.abs(deltaX) <= 200 and math.abs(deltaY) <= 200 then
                if mousemoverel then mousemoverel(deltaX, deltaY) end
            end
        end
    end
end

function ToggleAimbot(enabled)
    aimbotSettings.Enabled = enabled
    if enabled then
        if not aimbotConnection then aimbotConnection = RunService.RenderStepped:Connect(AimLocker) end
    else
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end

-- ========== KILL AURA FUNCTIONS ==========
function GetNearbyEnemies()
    local localChar = player.Character
    local localHrp = localChar and localChar:FindFirstChild('HumanoidRootPart')
    if not localHrp then return {} end
    
    local enemies = {}
    local radius = 20
    
    for entity, data in pairs(espData) do
        if data.entryType == 'enemy' and data.hrp and data.hrp.Parent then
            local distance = (localHrp.Position - data.hrp.Position).Magnitude
            if distance <= radius then table.insert(enemies, entity) end
        end
    end
    
    return enemies
end

function KillAura()
    if not killAuraSettings.Enabled then return end
    if killAuraActive then return end
    
    local now = tick()
    if now - lastAttackTime < killAuraSettings.AttackDelay then return end
    
    local character = player.Character
    local hrp = character and character:FindFirstChild('HumanoidRootPart')
    if not hrp then return end
    
    local enemies = GetNearbyEnemies()
    if #enemies == 0 then return end
    
    local attackRemote = nil
    for _, remote in ipairs(ReplicatedStorage:GetChildren()) do
        if remote:IsA('RemoteEvent') and remote.Name:find('Attack') then attackRemote = remote; break end
    end
    
    if not attackRemote then return end
    
    killAuraActive = true
    
    task.spawn(function()
        if killAuraActive and killAuraSettings.Enabled then
            attackRemote:FireServer()
            task.wait(0.05)
            
            local validTargets = {}
            for _, enemy in ipairs(enemies) do
                local humanoid = enemy:FindFirstChildOfClass('Humanoid')
                local npc = enemy:FindFirstChild('MockHumanoid')
                local isValid = false
                
                if humanoid and humanoid.Health > 0 then isValid = true
                elseif npc and npc:GetAttribute('Health') and npc:GetAttribute('Health') > 0 then isValid = true end
                
                if isValid then table.insert(validTargets, enemy) end
            end
            
            if #validTargets > 0 then
                lastAttackTime = now
                attackRemote:FireServer(validTargets)
            end
            
            killAuraActive = false
        end
    end)
end

function ToggleKillAura(enabled)
    killAuraSettings.Enabled = enabled
    if enabled then
        if not killAuraConnection then killAuraConnection = RunService.Heartbeat:Connect(KillAura) end
    else
        if killAuraConnection then killAuraConnection:Disconnect() killAuraConnection = nil end
    end
end

-- ========== AUTO-COLLECT FUNCTIONS ==========
function IsValidItem(item)
    if not item or not item.Parent then return false end
    if item:IsA('Model') or item:IsA('BasePart') then
        local prompt = item:FindFirstChildOfClass('ProximityPrompt')
        if prompt and not prompt.Enabled then return false end
        return true
    end
    return false
end

function GetItemPrimaryPart(item)
    if item:IsA('BasePart') then return item end
    return item.PrimaryPart or item:FindFirstChild('Handle') or item:FindFirstChild('Head') or item:FindFirstChildWhichIsA('BasePart')
end

function PickupItem(item)
    local remote = ReplicatedStorage:FindFirstChild('PickUpItem') or ReplicatedStorage:FindFirstChild('AdjustBackpack')
    if remote then pcall(function() remote:FireServer(item) end) end
end

function AutoCollectLoop()
    if not collectSettings.Enabled then
        if radiusRing then radiusRing.Visible = false end
        if fovCircle then fovCircle.Visible = false end
        return
    end
    
    local now = tick()
    if now - lastCollectTime < collectSettings.CollectDelay then return end
    
    local character = player.Character
    local hrp = character and character:FindFirstChild('HumanoidRootPart')
    if not hrp then return end
    
    local targetItems = {}
    local playerPos = hrp.Position
    local droppedItems = Workspace:FindFirstChild('DroppedItems')
    if not droppedItems then return end
    
    if collectSettings.Mode == 'Radius' then
        if radiusRing then
            radiusRing.Visible = true
            radiusRing.Transparency = 0.7
            radiusRing.Size = Vector3.new(0.1, collectSettings.Radius * 2, collectSettings.Radius * 2)
            radiusRing.CFrame = hrp.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, math.rad(90))
        end
        if fovCircle then fovCircle.Visible = false end
        
        for _, item in ipairs(droppedItems:GetChildren()) do
            if IsValidItem(item) then
                local part = GetItemPrimaryPart(item)
                if part then
                    local dist = (playerPos - part.Position).Magnitude
                    if dist <= collectSettings.Radius then
                        table.insert(targetItems, item)
                        if #targetItems >= 5 then break end
                    end
                end
            end
        end
        
    elseif collectSettings.Mode == 'Mouse FOV' then
        if radiusRing then radiusRing.Visible = false end
        if radiusRing then radiusRing.Transparency = 1 end
        
        local mousePos = UserInputService:GetMouseLocation()
        if fovCircle then
            fovCircle.Visible = true
            fovCircle.Size = UDim2.new(0, collectSettings.FOV * 2, 0, collectSettings.FOV * 2)
            fovCircle.Position = UDim2.new(0, mousePos.X - collectSettings.FOV, 0, mousePos.Y - collectSettings.FOV)
        end
        
        for _, item in ipairs(droppedItems:GetChildren()) do
            if IsValidItem(item) then
                local part = GetItemPrimaryPart(item)
                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distToMouse <= collectSettings.FOV then
                            local dist3D = (playerPos - part.Position).Magnitude
                            if dist3D <= 18 then
                                table.insert(targetItems, item)
                                if #targetItems >= 5 then break end
                            end
                        end
                    end
                end
            end
        end
    end
    
    for _, item in ipairs(targetItems) do
        PickupItem(item)
        task.wait(0.02)
    end
    
    lastCollectTime = now
end

-- ========== FLY MODE FUNCTIONS ==========
function FlyMode()
    if not flySettings.Enabled then return end
    
    local moveDir = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    
    if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
    
    local character = player.Character
    local hrp = character and character:FindFirstChild('HumanoidRootPart')
    local head = character and character:FindFirstChild('Head')
    
    if hrp and hrp.Parent then hrp.Velocity = moveDir * flySettings.Speed end
    if head and head.Parent then head.CFrame = camera.CFrame end
end

function ToggleFly(enabled)
    flySettings.Enabled = enabled
    if enabled then
        if not flyConnection then flyConnection = RunService.RenderStepped:Connect(FlyMode) end
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    end
end

-- ========== FULLBRIGHT FUNCTIONS ==========
function ApplyFullbright()
    local lighting = Lighting
    
    if fullbrightSettings.Enabled then
        if lighting.Brightness ~= 2 then lighting.Brightness = 2 end
        if lighting.Ambient ~= Color3.fromRGB(255, 255, 255) then lighting.Ambient = Color3.fromRGB(255, 255, 255) end
        if lighting.OutdoorAmbient ~= Color3.fromRGB(255, 255, 255) then lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) end
        if lighting.FogEnd ~= 100000 then lighting.FogEnd = 100000 end
        
        for _, child in ipairs(lighting:GetChildren()) do
            if child:IsA('BlurEffect') or child:IsA('ColorCorrectionEffect') then child.Enabled = false end
        end
    else
        lighting.Brightness = originalLighting.Brightness or 1
        lighting.Ambient = originalLighting.Ambient or Color3.fromRGB(0, 0, 0)
        lighting.OutdoorAmbient = originalLighting.OutdoorAmbient or Color3.fromRGB(127, 127, 127)
        lighting.FogEnd = originalLighting.FogEnd or lighting.FogEnd
        
        for _, child in ipairs(lighting:GetChildren()) do
            if child:IsA('BlurEffect') or child:IsA('ColorCorrectionEffect') then child.Enabled = true end
        end
    end
end

function ToggleFullbright(enabled)
    if not originalLighting.Brightness then
        originalLighting.Brightness = Lighting.Brightness
        originalLighting.Ambient = Lighting.Ambient
        originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLighting.FogEnd = Lighting.FogEnd
    end
    
    fullbrightSettings.Enabled = enabled
    ApplyFullbright()
    
    if enabled then
        if not fullbrightConnections.Ambient then fullbrightConnections.Ambient = Lighting:GetPropertyChangedSignal('Ambient'):Connect(ApplyFullbright) end
        if not fullbrightConnections.Brightness then fullbrightConnections.Brightness = Lighting:GetPropertyChangedSignal('Brightness'):Connect(ApplyFullbright) end
        if not fullbrightConnections.OutdoorAmbient then fullbrightConnections.OutdoorAmbient = Lighting:GetPropertyChangedSignal('OutdoorAmbient'):Connect(ApplyFullbright) end
        if not fullbrightConnections.FogEnd then fullbrightConnections.FogEnd = Lighting:GetPropertyChangedSignal('FogEnd'):Connect(ApplyFullbright) end
    else
        for _, conn in pairs(fullbrightConnections) do if conn then conn:Disconnect() end end
        fullbrightConnections = {}
    end
end

-- ========== AUTO-RELOAD FUNCTIONS ==========
function AutoReloadWeapon()
    if not reloadSettings.Enabled then return end
    
    local character = player.Character
    local tool = character and character:FindFirstChildOfClass('Tool')
    if not tool then return end
    
    pcall(function()
        local toolBackpack = tool:FindFirstChild('Backpack') or tool
        if not toolBackpack then return end
        
        local reloadRemote = toolBackpack:FindFirstChild('Reload')
        if not reloadRemote then return end
        
        local hoverModel = toolBackpack:FindFirstChild('HoverModel')
        local gunModels = hoverModel and hoverModel:FindFirstChild('GunModels')
        if not gunModels then return end
        
        local totalSlots = #gunModels:GetChildren()
        local emptySlots = {}
        
        for i = 1, totalSlots do
            local slot = gunModels:FindFirstChild(tostring(i))
            if slot then
                local isReloading = reloadingWeapons[i] ~= nil
                local ammo = slot:GetAttribute('Ammo') or 0
                local isReloadingFromUI = false
                local currentAmmo = 0
                
                local playerGui = player.PlayerGui
                local toolUI = playerGui:FindFirstChild('ToolUI')
                if toolUI then
                    local remoteArsenal = toolUI:FindFirstChild('RemoteArsenal')
                    if remoteArsenal and remoteArsenal:FindFirstChild(tostring(i)) then
                        local ammoText = remoteArsenal[tostring(i)].Ammo.Text
                        if ammoText == 'Reloading...' then
                            isReloadingFromUI = true
                        else
                            ammo = tonumber(ammoText:match('^(%d+)/')) or ammo
                            currentAmmo = tonumber(ammoText:match('/(%d+)$')) or 0
                        end
                    end
                end
                
                if not (isReloading or isReloadingFromUI) and ammo and ammo <= 0 and currentAmmo > 0 then
                    table.insert(emptySlots, i)
                end
            end
        end
        
        if #emptySlots > 0 then
            lastReloadTime = os.clock()
            local syncAmmo = toolBackpack:FindFirstChild('SyncAmmo')
            
            for _, slotIndex in ipairs(emptySlots) do
                local slot = gunModels:FindFirstChild(tostring(slotIndex))
                reloadingWeapons[slotIndex] = os.clock()
                if syncAmmo then syncAmmo:FireServer(slotIndex) end
                
                task.spawn(function()
                    local success, result = pcall(function() return reloadRemote:InvokeServer(nil, slotIndex) end)
                    if success and result and slot then slot:SetAttribute('Ammo', result) end
                    reloadingWeapons[slotIndex] = nil
                end)
            end
        end
        
        local nowTime = os.clock()
        local anyReloading = false
        for idx, reloadTime in pairs(reloadingWeapons) do
            if nowTime - reloadTime < 10 then anyReloading = true
            else reloadingWeapons[idx] = nil end
        end
        
        for i = 1, totalSlots do
            local slot = gunModels:FindFirstChild(tostring(i))
            if slot and slot:GetAttribute('Reloading') ~= anyReloading then
                slot:SetAttribute('Reloading', anyReloading)
            end
        end
    end)
    
    pcall(function()
        local ammo = tool:GetAttribute('Ammo')
        if ammo and ammo <= 0 then
            local nowTime = os.clock()
            if nowTime - lastReloadTime < 0.2 then return end
            lastReloadTime = nowTime
            
            local reloadRemote = tool:FindFirstChild('Reload') or tool:FindFirstChild('ReloadOne')
            if reloadRemote then
                task.spawn(function()
                    for _ = 1, 3 do reloadRemote:InvokeServer() end
                end)
            end
        end
    end)
end

-- ========== FPS COUNTER ==========
function ToggleFPS(visible, label)
    fpsLabel = label
    if visible then
        if not fpsConnection then
            fpsStartTime = tick()
            fpsFrameCount = 0
            fpsConnection = RunService.RenderStepped:Connect(function()
                fpsFrameCount = fpsFrameCount + 1
                local now = tick()
                if now - fpsStartTime >= 1 then
                    if fpsLabel and fpsLabel.Parent then
                        fpsLabel.Text = 'FPS: ' .. math.floor(fpsFrameCount / (now - fpsStartTime))
                    end
                    fpsFrameCount = 0
                    fpsStartTime = now
                end
            end)
        end
    else
        if fpsConnection then fpsConnection:Disconnect() fpsConnection = nil end
    end
end

-- ========== STATUS BAR ==========
function UpdateStatusBar()
    if not statusFrame or not statusFrame.Parent then
        if statusUpdateConnection then statusUpdateConnection:Disconnect() statusUpdateConnection = nil end
        return
    end
    
    local character = player.Character
    local humanoid = character and character:FindFirstChild('Humanoid')
    if not humanoid or humanoid.Health <= 0 then
        if statusFrame then statusFrame.Visible = false end
        return
    end
    
    if statusFrame then statusFrame.Visible = true end
    
    local healthPercent = math.clamp(humanoid.Health, 0, humanoid.MaxHealth) / humanoid.MaxHealth
    if hpFill then hpFill.Size = UDim2.new(healthPercent, 0, 1, 0) end
    if hpText then hpText.Text = tostring(math.floor(humanoid.Health)) end
    
    if healthPercent > 0.5 then
        if hpFill then hpFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80) end
    elseif healthPercent > 0.25 then
        if hpFill then hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50) end
    else
        if hpFill then hpFill.BackgroundColor3 = Color3.fromRGB(220, 60, 60) end
    end
    
    local hunger = character:GetAttribute('Hunger') or 0
    local hungerPercent = math.clamp(hunger / 100, 0, 1)
    if staminaFill then staminaFill.Size = UDim2.new(hungerPercent, 0, 1, 0) end
    if staminaText then staminaText.Text = tostring(math.floor(hunger)) end
end

-- ========================== CREATE UI TOGGLES ==========================
function createToggle(label, parent, defaultValue, callback, order)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
    toggleFrame.LayoutOrder = order
    toggleFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
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
    
    local toggleWidth = 44
    local toggleHeight = 22
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleBg.Position = UDim2.new(1, -(toggleWidth + 6), 0.5, -toggleHeight / 2)
    toggleBg.BackgroundColor3 = defaultValue and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleFrame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local knobSize = 16
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
        toggleBg.BackgroundColor3 = state and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
        knob.Position = state and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)
    
    return toggleFrame
end

-- ========== ESP PAGE ==========
local espPanel = Instance.new("Frame")
espPanel.Size = UDim2.new(1, 0, 0, 0)
espPanel.AutomaticSize = Enum.AutomaticSize.Y
espPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
espPanel.BorderSizePixel = 0
espPanel.Parent = espPage
Instance.new("UICorner", espPanel).CornerRadius = UDim.new(0, 12)

local espPad = Instance.new("UIPadding", espPanel)
espPad.PaddingLeft = UDim.new(0, 12)
espPad.PaddingRight = UDim.new(0, 12)
espPad.PaddingTop = UDim.new(0, 10)
espPad.PaddingBottom = UDim.new(0, 10)

local espLayoutPanel = Instance.new("UIListLayout", espPanel)
espLayoutPanel.Padding = UDim.new(0, 8)
espLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

createToggle("👁️ TRACK ENEMIES", espPanel, false, function(val)
    espSettings.TrackEnemies = val
    if val then
        StartEnemyESP()
        if not espUpdateConnection then espUpdateConnection = RunService.Heartbeat:Connect(UpdateESP) end
    else
        StopEnemyESP()
        if espUpdateConnection then espUpdateConnection:Disconnect() espUpdateConnection = nil end
    end
end, 1)

-- ========== COMBAT PAGE ==========
local combatPanel = Instance.new("Frame")
combatPanel.Size = UDim2.new(1, 0, 0, 0)
combatPanel.AutomaticSize = Enum.AutomaticSize.Y
combatPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
combatPanel.BorderSizePixel = 0
combatPanel.Parent = combatPage
Instance.new("UICorner", combatPanel).CornerRadius = UDim.new(0, 12)

local combatPad = Instance.new("UIPadding", combatPanel)
combatPad.PaddingLeft = UDim.new(0, 12)
combatPad.PaddingRight = UDim.new(0, 12)
combatPad.PaddingTop = UDim.new(0, 10)
combatPad.PaddingBottom = UDim.new(0, 10)

local combatLayoutPanel = Instance.new("UIListLayout", combatPanel)
combatLayoutPanel.Padding = UDim.new(0, 8)
combatLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

createToggle("🎯 AIMBOT", combatPanel, false, function(val) ToggleAimbot(val) end, 1)
createToggle("🗡️ KILL AURA", combatPanel, false, function(val) ToggleKillAura(val) end, 2)
createToggle("🔄 AUTO RELOAD", combatPanel, false, function(val)
    reloadSettings.Enabled = val
    if val and not reloadLoopConnection then
        reloadLoopConnection = RunService.Heartbeat:Connect(AutoReloadWeapon)
    elseif not val and reloadLoopConnection then
        reloadLoopConnection:Disconnect()
        reloadLoopConnection = nil
    end
end, 3)

-- ========== COLLECT PAGE ==========
local collectPanel = Instance.new("Frame")
collectPanel.Size = UDim2.new(1, 0, 0, 0)
collectPanel.AutomaticSize = Enum.AutomaticSize.Y
collectPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
collectPanel.BorderSizePixel = 0
collectPanel.Parent = collectPage
Instance.new("UICorner", collectPanel).CornerRadius = UDim.new(0, 12)

local collectPad = Instance.new("UIPadding", collectPanel)
collectPad.PaddingLeft = UDim.new(0, 12)
collectPad.PaddingRight = UDim.new(0, 12)
collectPad.PaddingTop = UDim.new(0, 10)
collectPad.PaddingBottom = UDim.new(0, 10)

local collectLayoutPanel = Instance.new("UIListLayout", collectPanel)
collectLayoutPanel.Padding = UDim.new(0, 8)
collectLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

createToggle("🎒 AUTO COLLECT", collectPanel, false, function(val)
    collectSettings.Enabled = val
    if val and not collectLoopConnection then
        collectLoopConnection = RunService.Heartbeat:Connect(AutoCollectLoop)
        radiusRing = Instance.new("Part")
        radiusRing.Name = "RadiusRing"
        radiusRing.Size = Vector3.new(0.1, 0.1, 0.1)
        radiusRing.Anchored = true
        radiusRing.CanCollide = false
        radiusRing.Transparency = 0.7
        radiusRing.Material = Enum.Material.Neon
        radiusRing.Parent = Workspace
        radiusRing.Visible = false
        
        fovCircle = Instance.new("Frame")
        fovCircle.Name = "FOVCircle"
        fovCircle.Size = UDim2.new(0, 300, 0, 300)
        fovCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
        fovCircle.BackgroundTransparency = 0.8
        fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        fovCircle.BorderSizePixel = 0
        fovCircle.Visible = false
        fovCircle.Parent = screenGui
        Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    elseif not val and collectLoopConnection then
        collectLoopConnection:Disconnect()
        collectLoopConnection = nil
        if radiusRing then radiusRing.Visible = false end
        if fovCircle then fovCircle.Visible = false end
    end
end, 1)

-- ========== MOVEMENT PAGE ==========
local movementPanel = Instance.new("Frame")
movementPanel.Size = UDim2.new(1, 0, 0, 0)
movementPanel.AutomaticSize = Enum.AutomaticSize.Y
movementPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
movementPanel.BorderSizePixel = 0
movementPanel.Parent = movementPage
Instance.new("UICorner", movementPanel).CornerRadius = UDim.new(0, 12)

local movementPad = Instance.new("UIPadding", movementPanel)
movementPad.PaddingLeft = UDim.new(0, 12)
movementPad.PaddingRight = UDim.new(0, 12)
movementPad.PaddingTop = UDim.new(0, 10)
movementPad.PaddingBottom = UDim.new(0, 10)

local movementLayoutPanel = Instance.new("UIListLayout", movementPanel)
movementLayoutPanel.Padding = UDim.new(0, 8)
movementLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

createToggle("🚀 FLY MODE", movementPanel, false, function(val) ToggleFly(val) end, 1)

-- ========== VISUALS PAGE ==========
local visualsPanel = Instance.new("Frame")
visualsPanel.Size = UDim2.new(1, 0, 0, 0)
visualsPanel.AutomaticSize = Enum.AutomaticSize.Y
visualsPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
visualsPanel.BorderSizePixel = 0
visualsPanel.Parent = visualsPage
Instance.new("UICorner", visualsPanel).CornerRadius = UDim.new(0, 12)

local visualsPad = Instance.new("UIPadding", visualsPanel)
visualsPad.PaddingLeft = UDim.new(0, 12)
visualsPad.PaddingRight = UDim.new(0, 12)
visualsPad.PaddingTop = UDim.new(0, 10)
visualsPad.PaddingBottom = UDim.new(0, 10)

local visualsLayoutPanel = Instance.new("UIListLayout", visualsPanel)
visualsLayoutPanel.Padding = UDim.new(0, 8)
visualsLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

createToggle("☀️ FULLBRIGHT", visualsPanel, false, function(val) ToggleFullbright(val) end, 1)
createToggle("📊 FPS COUNTER", visualsPanel, true, function(val) ToggleFPS(val, fpsLabel) end, 2)

-- FPS Label
fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -24, 0, 24)
fpsLabel.Position = UDim2.new(0, 12, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 000"
fpsLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = TEXT_SIZE_SMALL
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = visualsPanel
fpsLabel.Visible = true

-- Status Bar Frame
statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -24, 0, 70)
statusFrame.Position = UDim2.new(0, 12, 0, 0)
statusFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = visualsPanel
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 12)

local statusTitle = Instance.new("TextLabel")
statusTitle.Size = UDim2.new(1, 0, 0, 20)
statusTitle.Position = UDim2.new(0, 0, 0, 4)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "❤️ HP & STAMINA"
statusTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = TEXT_SIZE_SMALL
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = statusFrame

local statusDivider = Instance.new("Frame")
statusDivider.Size = UDim2.new(1, 0, 0, 1)
statusDivider.Position = UDim2.new(0, 0, 0, 26)
statusDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
statusDivider.BorderSizePixel = 0
statusDivider.Parent = statusFrame

-- HP Bar
local hpBarFrame = Instance.new("Frame")
hpBarFrame.Size = UDim2.new(1, 0, 0, 16)
hpBarFrame.Position = UDim2.new(0, 0, 0, 32)
hpBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hpBarFrame.BorderSizePixel = 0
hpBarFrame.Parent = statusFrame
Instance.new("UICorner", hpBarFrame).CornerRadius = UDim.new(0, 8)

hpFill = Instance.new("Frame")
hpFill.Size = UDim2.new(1, 0, 1, 0)
hpFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
hpFill.BorderSizePixel = 0
hpFill.Parent = hpBarFrame
Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 8)

hpText = Instance.new("TextLabel")
hpText.Size = UDim2.new(1, 0, 1, 0)
hpText.BackgroundTransparency = 1
hpText.Text = "100"
hpText.TextColor3 = Color3.new(1, 1, 1)
hpText.Font = Enum.Font.GothamBold
hpText.TextSize = 10
hpText.Parent = hpBarFrame

-- Stamina Bar
local staminaBarFrame = Instance.new("Frame")
staminaBarFrame.Size = UDim2.new(1, 0, 0, 16)
staminaBarFrame.Position = UDim2.new(0, 0, 0, 52)
staminaBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
staminaBarFrame.BorderSizePixel = 0
staminaBarFrame.Parent = statusFrame
Instance.new("UICorner", staminaBarFrame).CornerRadius = UDim.new(0, 8)

staminaFill = Instance.new("Frame")
staminaFill.Size = UDim2.new(1, 0, 1, 0)
staminaFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
staminaFill.BorderSizePixel = 0
staminaFill.Parent = staminaBarFrame
Instance.new("UICorner", staminaFill).CornerRadius = UDim.new(0, 8)

staminaText = Instance.new("TextLabel")
staminaText.Size = UDim2.new(1, 0, 1, 0)
staminaText.BackgroundTransparency = 1
staminaText.Text = "100"
staminaText.TextColor3 = Color3.new(1, 1, 1)
staminaText.Font = Enum.Font.GothamBold
staminaText.TextSize = 10
staminaText.Parent = staminaBarFrame

-- ========== INFO PAGE ==========
local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(1, 0, 0, 0)
infoPanel.AutomaticSize = Enum.AutomaticSize.Y
infoPanel.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
infoPanel.BorderSizePixel = 0
infoPanel.Parent = infoPage
Instance.new("UICorner", infoPanel).CornerRadius = UDim.new(0, 12)

local infoPadPanel = Instance.new("UIPadding", infoPanel)
infoPadPanel.PaddingLeft = UDim.new(0, 12)
infoPadPanel.PaddingRight = UDim.new(0, 12)
infoPadPanel.PaddingTop = UDim.new(0, 10)
infoPadPanel.PaddingBottom = UDim.new(0, 10)

local infoLayoutPanel = Instance.new("UIListLayout", infoPanel)
infoLayoutPanel.Padding = UDim.new(0, 8)
infoLayoutPanel.SortOrder = Enum.SortOrder.LayoutOrder

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, 0, 0, 24)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "📋 R4NzDev + ZHub Cheat"
infoTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = TEXT_SIZE_SMALL
infoTitle.TextXAlignment = Enum.TextXAlignment.Center
infoTitle.Parent = infoPanel

local infoDivider = Instance.new("Frame")
infoDivider.Size = UDim2.new(1, 0, 0, 1)
infoDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
infoDivider.BorderSizePixel = 0
infoDivider.Parent = infoPanel

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 0, 0)
infoText.AutomaticSize = Enum.AutomaticSize.Y
infoText.BackgroundTransparency = 1
infoText.Text = "Fitur yang tersedia:\n\n👁️ ESP - Melihat posisi musuh\n⚔️ COMBAT - Aimbot, Kill Aura, Auto Reload\n🎒 COLLECT - Mengumpulkan item otomatis\n🚀 MOVEMENT - Fly Mode\n🌟 VISUALS - Fullbright, FPS Counter, HP Bar\n\nVersion: 2.0.0\nLast update: 11 Mar 2026"
infoText.TextColor3 = Color3.fromRGB(170, 155, 200)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = TEXT_SIZE_SMALL
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextWrapped = true
infoText.Parent = infoPanel

-- ========== FINAL SETUP ==========
function showPage(page)
    local pages = { espPage, combatPage, collectPage, movementPage, visualsPage, infoPage }
    for _, p in pairs(pages) do if p then p.Visible = false end end
    if page then page.Visible = true end
end

showPage(espPage)
setActiveTab(tabESP)

-- Tab click handlers
tabESP.MouseButton1Click:Connect(function() showPage(espPage); setActiveTab(tabESP); playClickSound() end)
tabCombat.MouseButton1Click:Connect(function() showPage(combatPage); setActiveTab(tabCombat); playClickSound() end)
tabCollect.MouseButton1Click:Connect(function() showPage(collectPage); setActiveTab(tabCollect); playClickSound() end)
tabMovement.MouseButton1Click:Connect(function() showPage(movementPage); setActiveTab(tabMovement); playClickSound() end)
tabVisuals.MouseButton1Click:Connect(function() showPage(visualsPage); setActiveTab(tabVisuals); playClickSound() end)
tabInfo.MouseButton1Click:Connect(function() showPage(infoPage); setActiveTab(tabInfo); playClickSound() end)

closeBtn.MouseButton1Click:Connect(function() playClickSound(); CleanupScript() end)

-- Drag window (PC only)
if not isTouch then
    local isDragging = false
    local dragStartPos, dragStartMouse
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStartMouse = input.Position
            dragStartPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local delta = input.Position - dragStartMouse
            mainFrame.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
            syncGlowWrapper()
        end
    end)
    
    miniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingMini = true
            dragStart = input.Position
            dragStartPos = miniIcon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDraggingMini = false end
            end)
        end
    end)
    
    miniIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDraggingMini then
            local delta = input.Position - dragStart
            miniIcon.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
        end
    end)
end

-- Start status bar update
statusUpdateConnection = RunService.RenderStepped:Connect(UpdateStatusBar)

-- Apply initial theme
applyTheme("CYBERPUNK")

print("✅ R4NzDev + ZHub Cheat berhasil dimuat!")
print("🔹 6 Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS | INFO")
print("🔹 Tekan minimize (⛎) untuk menyembunyikan GUI")
print("🔹 Tekan ikon kecil untuk membuka kembali")