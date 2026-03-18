local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local scriptKey = "R4NzDev_v2"

-- Cek apakah GUI sudah terpasang
if CoreGui:FindFirstChild("R4NzDev") then
    print("⚠️ R4NzDev sudah berjalan! Tutup dulu sebelum execute ulang.")
    return
end

local isRunning = true
_G[scriptKey] = function()
    isRunning = false
    if CoreGui:FindFirstChild("R4NzDev") then
        CoreGui.R4NzDev:Destroy()
    end
end

-- Sembunyikan GUI Roblox bawaan
game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        local gui = CoreGui.RobloxGui.FocusNavigationCoreScriptsWrapper
        gui.Visible = false
    end)
end)

-- Pengaturan ukuran untuk HP (Touch) dan PC (Mouse)
local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 300 or 460
local HEIGHT = isTouch and 250 or 310
local SIDEBAR_WIDTH = isTouch and 85 or 105
local HEADER_HEIGHT = isTouch and 42 or 46
local TAB_FONT_SIZE = isTouch and 9 or 11
local TOGGLE_HEIGHT = isTouch and 32 or 36
local TEXT_SIZE_SMALL = isTouch and 10 or 12
local TEXT_SIZE_MEDIUM = isTouch and 13 or 15

-- Fungsi utilitas
function isTouchOrMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

function isMoveTouchOrMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- Tema warna UI
local themes = {
    CYBERPUNK = {
        primary = Color3.fromRGB(100, 30, 220),
        mid = Color3.fromRGB(65, 15, 160),
        dark = Color3.fromRGB(30, 10, 100),
        headerBg = Color3.fromRGB(55, 15, 120),
        accent = Color3.fromRGB(150, 80, 255),
        glow = Color3.fromRGB(100, 40, 200),
        activeTab = Color3.fromRGB(65, 20, 150),
        logText = Color3.fromRGB(160, 100, 255)
    },
    CRIMSON = {
        primary = Color3.fromRGB(200, 20, 40),
        mid = Color3.fromRGB(150, 15, 30),
        dark = Color3.fromRGB(80, 8, 16),
        headerBg = Color3.fromRGB(120, 10, 25),
        accent = Color3.fromRGB(255, 80, 100),
        glow = Color3.fromRGB(200, 30, 50),
        activeTab = Color3.fromRGB(160, 15, 35),
        logText = Color3.fromRGB(255, 100, 120)
    },
    MATRIX = {
        primary = Color3.fromRGB(0, 180, 60),
        mid = Color3.fromRGB(0, 130, 40),
        dark = Color3.fromRGB(0, 60, 20),
        headerBg = Color3.fromRGB(0, 80, 25),
        accent = Color3.fromRGB(50, 255, 120),
        glow = Color3.fromRGB(0, 160, 60),
        activeTab = Color3.fromRGB(0, 110, 40),
        logText = Color3.fromRGB(80, 255, 140)
    },
    SAKURA = {
        primary = Color3.fromRGB(210, 60, 140),
        mid = Color3.fromRGB(170, 40, 110),
        dark = Color3.fromRGB(100, 20, 65),
        headerBg = Color3.fromRGB(130, 30, 85),
        accent = Color3.fromRGB(255, 130, 200),
        glow = Color3.fromRGB(210, 70, 150),
        activeTab = Color3.fromRGB(160, 40, 110),
        logText = Color3.fromRGB(255, 150, 210)
    },
    OCEAN = {
        primary = Color3.fromRGB(0, 100, 220),
        mid = Color3.fromRGB(0, 70, 170),
        dark = Color3.fromRGB(0, 35, 100),
        headerBg = Color3.fromRGB(0, 55, 130),
        accent = Color3.fromRGB(60, 160, 255),
        glow = Color3.fromRGB(0, 110, 220),
        activeTab = Color3.fromRGB(0, 75, 170),
        logText = Color3.fromRGB(80, 180, 255)
    },
    FLAME = {
        primary = Color3.fromRGB(220, 100, 0),
        mid = Color3.fromRGB(180, 70, 0),
        dark = Color3.fromRGB(100, 35, 0),
        headerBg = Color3.fromRGB(140, 55, 0),
        accent = Color3.fromRGB(255, 160, 50),
        glow = Color3.fromRGB(220, 110, 0),
        activeTab = Color3.fromRGB(170, 65, 0),
        logText = Color3.fromRGB(255, 180, 70)
    }
}

-- Tema aktif
local currentTheme = "CYBERPUNK"
local uiElements = {}

-- Fungsi mengaplikasikan tema ke semua elemen UI
function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    currentTheme = themeName

    if uiElements.Header then uiElements.Header.BackgroundColor3 = theme.headerBg end
    if uiElements.HeaderGrad then uiElements.HeaderGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.primary), ColorSequenceKeypoint.new(0.6, theme.mid), ColorSequenceKeypoint.new(1, theme.dark)}) end
    if uiElements.HeaderCover then uiElements.HeaderCover.BackgroundColor3 = theme.headerBg end
    if uiElements.HeaderLine then uiElements.HeaderLine.BackgroundColor3 = theme.accent end
    if uiElements.LineGrad then uiElements.LineGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.accent), ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, theme.accent)}) end
    if uiElements.HeaderDot then uiElements.HeaderDot.BackgroundColor3 = theme.accent end
    if uiElements.PremBadge then uiElements.PremBadge.BackgroundColor3 = theme.mid end
    if uiElements.BadgeGrad then uiElements.BadgeGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.accent), ColorSequenceKeypoint.new(1, theme.primary)}) end
    if uiElements.GlowWrapper then uiElements.GlowWrapper.BackgroundColor3 = theme.glow end
    if uiElements.SideDivider then uiElements.SideDivider.BackgroundColor3 = theme.mid end
    if uiElements.DivGrad then uiElements.DivGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.mid), ColorSequenceKeypoint.new(0.5, theme.accent), ColorSequenceKeypoint.new(1, theme.mid)}) end
    if uiElements.MiniIconStroke then uiElements.MiniIconStroke.Color = theme.accent end
    if uiElements.MiniIcon then uiElements.MiniIcon.BackgroundColor3 = theme.headerBg end
    if uiElements.DropMainBtn then uiElements.DropMainBtn.BackgroundColor3 = theme.mid end
    if uiElements.dropBtnGrad then uiElements.dropBtnGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.primary), ColorSequenceKeypoint.new(1, theme.dark)}) end
    if uiElements.dropStroke then uiElements.dropStroke.Color = theme.mid end
    if uiElements.logStroke then uiElements.logStroke.Color = theme.mid end
    if uiElements.LogAwalan then uiElements.LogAwalan.TextColor3 = theme.logText end
    if uiElements.ScrollBar then uiElements.ScrollBar.ScrollBarImageColor3 = theme.accent end

    for name, element in pairs(uiElements) do
        if type(element) == "table" and element.fill then
            element.fill.BackgroundColor3 = theme.primary
            element.knobMinStroke.Color = theme.accent
            element.knobMaxStroke.Color = theme.accent
            element.knobMax.BackgroundColor3 = theme.accent
            element.valLbl.TextColor3 = theme.logText
        end
    end

    if uiElements.activeTabColor then uiElements.activeTabColor.value = theme.activeTab end
    if uiElements.SkinDropBtn then uiElements.SkinDropBtn.BackgroundColor3 = theme.mid end
    if uiElements.SkinDropGrad then uiElements.SkinDropGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.primary), ColorSequenceKeypoint.new(1, theme.dark)}) end
    if uiElements.SkinDropStroke then uiElements.SkinDropStroke.Color = theme.mid end
    if uiElements.ResizeHandle then uiElements.ResizeHandle.BackgroundColor3 = theme.mid end
    if uiElements.ResizeStroke then uiElements.ResizeStroke.Color = theme.accent end
    if uiElements.tuyulStroke then uiElements.tuyulStroke.Color = theme.accent end
    if uiElements.tuyulHeader then uiElements.tuyulHeader.TextColor3 = theme.accent end
    if uiElements.tuyulStatus then uiElements.tuyulStatus.TextColor3 = theme.accent end
    if uiElements.themeBtnStroke then uiElements.themeBtnStroke.Color = theme.accent end
    if uiElements.themeDFStroke then uiElements.themeDFStroke.Color = theme.mid end
    if uiElements.UtilScrollBar then uiElements.UtilScrollBar.ScrollBarImageColor3 = theme.accent end
    if uiElements.pcStroke then uiElements.pcStroke.Color = theme.accent end
    if uiElements.scStroke then uiElements.scStroke.Color = theme.accent end
    if uiElements.ncStroke then uiElements.ncStroke.Color = theme.accent end
    if uiElements.cscStroke then uiElements.cscStroke.Color = theme.accent end
    if uiElements.vcStroke then uiElements.vcStroke.Color = theme.accent end
    if uiElements.statValRefs then for i, stat in ipairs(uiElements.statValRefs) do end end
end

-- Membuat layar utama GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.Parent = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Frame efek glow di belakang
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2) - 2, 0.5, -(HEIGHT/2) - 2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
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
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Tombol resize
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 24, 0, 24)
resizeHandle.BackgroundColor3 = Color3.fromRGB(65, 15, 160)
resizeHandle.Text = "↘️"
resizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = isTouch and 12 or 14
resizeHandle.ZIndex = 10
resizeHandle.Parent = screenGui
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 8)

local resizeStroke = Instance.new("UIStroke", resizeHandle)
resizeStroke.Color = Color3.fromRGB(150, 80, 255)
resizeStroke.Thickness = 1.5
resizeStroke.Transparency = 0.1
uiElements.ResizeHandle = resizeHandle
uiElements.ResizeStroke = resizeStroke

-- Sinkronisasi posisi tombol resize
function syncResizeHandle()
    local pos = mainFrame.Position
    local size = mainFrame.Size
    local handleSize = resizeHandle.Size.X.Offset
    resizeHandle.Position = UDim2.new(pos.X.Scale, (pos.X.Offset + size.X.Offset) - handleSize, pos.Y.Scale, (pos.Y.Offset + size.Y.Offset) - handleSize)
end

game:GetService("RunService").RenderStepped:Connect(function()
    if mainFrame.Visible then
        syncResizeHandle()
    end
end)
syncResizeHandle()

-- Logika drag untuk resize
local isResizing = false
local startPos, startWidth, startHeight

function clampWindow(w, h)
    return math.clamp(w, isTouch and 260 or 300, isTouch and 500 or 720), math.clamp(h, isTouch and 200 or 230, isTouch and 480 or 600)
end

function syncGlowWrapper()
    local pos = mainFrame.Position
    glowFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 2, pos.Y.Scale, pos.Y.Offset - 2)
    glowFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset + 4, 0, mainFrame.Size.Y.Offset + 4)
    syncResizeHandle()
end

resizeHandle.InputBegan:Connect(function(input)
    if not isTouchOrMouse(input) then return end
    isResizing = true
    startPos = input.Position
    startWidth = mainFrame.Size.X.Offset
    startHeight = mainFrame.Size.Y.Offset
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            isResizing = false
        end
    end)
end)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
header.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0.5, 0)
headerCover.Position = UDim2.new(0, 0, 0.5, 0)
headerCover.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
headerCover.BorderSizePixel = 0
headerCover.Parent = header
headerCover.ZIndex = header.ZIndex - 1

local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 220)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 15, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 10, 100))
})
headerGrad.Rotation = 135

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local lineGrad = Instance.new("UIGradient", headerLine)
lineGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255))
})

local headerDot = Instance.new("Frame")
headerDot.Size = UDim2.new(0, 7, 0, 7)
headerDot.Position = UDim2.new(0, 10, 0.5, -3.5)
headerDot.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
headerDot.BorderSizePixel = 0
headerDot.Parent = header
Instance.new("UICorner", headerDot).CornerRadius = UDim.new(1, 0)

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

uiElements.Header = header
uiElements.HeaderGrad = headerGrad
uiElements.HeaderCover = headerCover
uiElements.HeaderLine = headerLine
uiElements.LineGrad = lineGrad
uiElements.HeaderDot = headerDot

-- Badge PREMIUM (hanya untuk PC)
if not isTouch then
    local badgeFrame = Instance.new("Frame")
    badgeFrame.Size = UDim2.new(0, 64, 0, 17)
    badgeFrame.Position = UDim2.new(0, 130, 0.5, -8.5)
    badgeFrame.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
    badgeFrame.BorderSizePixel = 0
    badgeFrame.Parent = header
    Instance.new("UICorner", badgeFrame).CornerRadius = UDim.new(1, 0)

    local badgeGrad = Instance.new("UIGradient", badgeFrame)
    badgeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 40, 200))
    })

    local badgeText = Instance.new("TextLabel")
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = "PREMIUM"
    badgeText.TextColor3 = Color3.new(1, 1, 1)
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 9
    badgeText.Parent = badgeFrame

    uiElements.PremBadge = badgeFrame
    uiElements.BadgeGrad = badgeGrad
end

uiElements.GlowWrapper = glowFrame

-- Tombol minimize
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

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
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

local divGrad = Instance.new("UIGradient", sideDivider)
divGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 30, 140)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 60, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 140))
})
divGrad.Rotation = 90

uiElements.SideDivider = sideDivider
uiElements.DivGrad = divGrad

-- Layout di dalam sidebar
local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, isTouch and 4 or 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, isTouch and 8 or 12)
sidePad.PaddingLeft = UDim.new(0, isTouch and 4 or 7)
sidePad.PaddingRight = UDim.new(0, isTouch and 4 or 7)

-- Tabel untuk menyimpan tombol tab
local tabButtons = {}

-- Fungsi membuat tombol tab
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

-- Fungsi mengatur tab aktif
function setActiveTab(activeBtn)
    for i, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(120, 110, 150)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
    end

    local theme = themes[currentTheme] and themes[currentTheme].activeTab or Color3.fromRGB(65, 20, 150)
    local accent = themes[currentTheme] and themes[currentTheme].accent or Color3.fromRGB(150, 80, 255)
    activeBtn.BackgroundColor3 = theme
    activeBtn.TextColor3 = Color3.new(1, 1, 1)

    for i, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = accent
            tab.stroke.Transparency = 0.1
        end
    end
end

-- Membuat semua tombol tab (SKIN dan FAKE dihapus)
local tabInfo = createTabBtn("INFO", "📋", 0)
local tabMain = createTabBtn("MAIN", "⚡", 1)
local tabUtil = createTabBtn("UTIL", "🔧", 2)
local tabNyawa = createTabBtn("NYAWA", "🕤", 3)

-- Area konten utama
local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX + 4), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Ikon mini (saat diminimize)
local miniIcon = Instance.new("ImageButton")
miniIcon.Name = "R4NzDevMiniIcon"
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

-- Logika minimize
local clickCount = 0
minimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    mainFrame.Visible = false
    glowFrame.Visible = false
    resizeHandle.Visible = false
    miniIcon.Visible = true
    clickCount = 0
end)

-- Logika drag untuk ikon mini
local isDraggingMini, dragStartPos, dragStartPosIcon
miniIcon.InputBegan:Connect(function(input)
    if not isTouchOrMouse(input) then return end
    isDraggingMini = true
    clickCount = 0
    dragStartPos = input.Position
    dragStartPosIcon = miniIcon.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            isDraggingMini = false
        end
    end)
end)

miniIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMini = false
        local dist = dragStartPos and (input.Position - dragStartPos).Magnitude or 999
        if dist <= 12 then
            playClickSound()
            mainFrame.Visible = true
            glowFrame.Visible = true
            resizeHandle.Visible = true
            miniIcon.Visible = false
        end
        clickCount = 0
    end
end)

miniIcon.MouseButton1Click:Connect(function()
    if isTouch then return end
    if clickCount > 10 then
        clickCount = 0
        return
    end
    playClickSound()
    mainFrame.Visible = true
    glowFrame.Visible = true
    resizeHandle.Visible = true
    miniIcon.Visible = false
    clickCount = 0
end)

-- Fungsi membuat halaman
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.Parent = contentFrame
    return page
end

-- Halaman INFO
local infoPage, mainPage, utilPage, nyawaPage
infoPage = createPage()
infoPage.ScrollingDirection = Enum.ScrollingDirection.Y
infoPage.CanvasSize = UDim2.new(0, 0, 0, 0)
infoPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
infoPage.ScrollBarThickness = isTouch and 3 or 2
infoPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
infoPage.ScrollBarImageTransparency = 0

local infoPad = Instance.new("UIPadding", infoPage)
infoPad.PaddingLeft = UDim.new(0, 6)
infoPad.PaddingRight = UDim.new(0, 6)
infoPad.PaddingTop = UDim.new(0, 8)
infoPad.PaddingBottom = UDim.new(0, 10)

local infoLayout = Instance.new("UIListLayout")
infoLayout.Padding = UDim.new(0, 8)
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Parent = infoPage

-- Frame Profil
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, 0, 0, isTouch and 80 or 90)
profileFrame.LayoutOrder = 1
profileFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
profileFrame.BorderSizePixel = 0
profileFrame.Parent = infoPage
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 12)

local pcStroke = Instance.new("UIStroke", profileFrame)
pcStroke.Color = Color3.fromRGB(90, 40, 180)
pcStroke.Thickness = 1.5
pcStroke.Transparency = 0.2
uiElements.pcStroke = pcStroke

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, isTouch and 54 or 64, 0, isTouch and 54 or 64)
avatarFrame.Position = UDim2.new(0, 10, 0.5, -(isTouch and 27 or 32))
avatarFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = profileFrame
Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(1, 0)

local avatarStroke = Instance.new("UIStroke", avatarFrame)
avatarStroke.Color = Color3.fromRGB(130, 60, 255)
avatarStroke.Thickness = 2
avatarStroke.Transparency = 0.1

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = ""
avatarImage.ScaleType = Enum.ScaleType.Crop
avatarImage.Parent = avatarFrame

task.spawn(function()
    local success, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if success and thumb then
        avatarImage.Image = thumb
    end
end)
Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

local avatarOffset = (isTouch and 54 or 64) + 20
local displayNameLabel = Instance.new("TextLabel")
displayNameLabel.Size = UDim2.new(1, -(avatarOffset + 8), 0, 22)
displayNameLabel.Position = UDim2.new(0, avatarOffset, 0, isTouch and 14 or 18)
displayNameLabel.BackgroundTransparency = 1
displayNameLabel.Text = player.DisplayName
displayNameLabel.TextColor3 = Color3.new(1, 1, 1)
displayNameLabel.Font = Enum.Font.GothamBold
displayNameLabel.TextSize = isTouch and 13 or 15
displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
displayNameLabel.Parent = profileFrame

local userNameLabel = Instance.new("TextLabel")
userNameLabel.Size = UDim2.new(1, -(avatarOffset + 8), 0, 18)
userNameLabel.Position = UDim2.new(0, avatarOffset, 0, isTouch and 34 or 40)
userNameLabel.BackgroundTransparency = 1
userNameLabel.Text = "@" .. player.Name
userNameLabel.TextColor3 = Color3.fromRGB(130, 110, 180)
userNameLabel.Font = Enum.Font.Gotham
userNameLabel.TextSize = isTouch and 10 or 11
userNameLabel.TextXAlignment = Enum.TextXAlignment.Left
userNameLabel.Parent = profileFrame

-- Badge role
local isDev = player.UserId == 10109673684 or player.UserId == 10627496254
local roleFrame = Instance.new("Frame")
roleFrame.Size = UDim2.new(0, 70, 0, 16)
roleFrame.Position = UDim2.new(0, avatarOffset, 0, isTouch and 53 or 60)
roleFrame.BorderSizePixel = 0
roleFrame.Parent = profileFrame
Instance.new("UICorner", roleFrame).CornerRadius = UDim.new(1, 0)

local roleGrad = Instance.new("UIGradient", roleFrame)
if isDev then
    roleFrame.BackgroundColor3 = Color3.fromRGB(80, 30, 180)
    roleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 50, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 20, 180))
    })
else
    roleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    roleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 160)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 100))
    })
end

local roleText = Instance.new("TextLabel")
roleText.Size = UDim2.new(1, 0, 1, 0)
roleText.BackgroundTransparency = 1
roleText.Text = isDev and "DEVELOPER" or "MEMBER"
roleText.TextColor3 = Color3.new(1, 1, 1)
roleText.Font = Enum.Font.GothamBold
roleText.TextSize = 9
roleText.Parent = roleFrame

-- Frame Statistik
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 0, isTouch and 108 or 118)
statsFrame.LayoutOrder = 2
statsFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = infoPage
Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 12)

local scStroke = Instance.new("UIStroke", statsFrame)
scStroke.Color = Color3.fromRGB(90, 40, 180)
scStroke.Thickness = 1.5
scStroke.Transparency = 0.2
uiElements.scStroke = scStroke

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, -24, 0, 20)
statsTitle.Position = UDim2.new(0, 12, 0, 8)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📊 STATISTIK"
statsTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = isTouch and 11 or 12
statsTitle.TextXAlignment = Enum.TextXAlignment.Center
statsTitle.Parent = statsFrame

local statsDivider = Instance.new("Frame")
statsDivider.Size = UDim2.new(1, -24, 0, 1)
statsDivider.Position = UDim2.new(0, 12, 0, 30)
statsDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
statsDivider.BorderSizePixel = 0
statsDivider.Parent = statsFrame

local STATS_ROW_HEIGHT = isTouch and 34 or 38
local statData = {
    { labelL = "🏆 MENANG", labelR = "💀 KALAH", 
      fnL = function() local s, v = pcall(function() return player.leaderstats.Wins.Value end) return s and tostring(v) or "-" end, 
      fnR = function() local s, v = pcall(function() return player.leaderstats.Losses.Value end) return s and tostring(v) or "-" end, 
      colorL = Color3.fromRGB(255, 200, 60), colorR = Color3.fromRGB(255, 90, 90) },
    { labelL = "📈 WIN RATE", labelR = "💰 KOIN",
      fnL = function() 
          local sW, wins = pcall(function() return player.leaderstats.Wins.Value end)
          local sL, losses = pcall(function() return player.leaderstats.Losses.Value end)
          if not sW or not sL then return "-" end
          return math.floor((wins / math.max(wins + losses, 1)) * 100) .. "%"
      end,
      fnR = function()
          local s, money = pcall(function() return player.leaderstats.Money.Value end)
          if not s then return "-" end
          local moneyStr = tostring(math.floor(money))
          local formatted = ""
          for i = 1, #moneyStr, 1 do
              formatted = formatted .. moneyStr:sub(i, i)
              if (#moneyStr - i) % 3 == 0 and i ~= #moneyStr then
                  formatted = formatted .. "."
              end
          end
          return "Rp" .. formatted
      end,
      colorL = Color3.fromRGB(80, 220, 120), colorR = Color3.fromRGB(255, 200, 60) }
}

local statRefs = {}
for i = 1, 2, 1 do
    local yPos = 36 + (i - 1) * STATS_ROW_HEIGHT
    local data = statData[i]

    local leftLabel = Instance.new("TextLabel")
    leftLabel.Size = UDim2.new(0.5, 0, 0, 14)
    leftLabel.Position = UDim2.new(0, 0, 0, yPos)
    leftLabel.BackgroundTransparency = 1
    leftLabel.Text = data.labelL
    leftLabel.TextColor3 = Color3.fromRGB(140, 125, 175)
    leftLabel.Font = Enum.Font.GothamBold
    leftLabel.TextSize = isTouch and 8 or 9
    leftLabel.TextXAlignment = Enum.TextXAlignment.Center
    leftLabel.Parent = statsFrame

    local leftValue = Instance.new("TextLabel")
    leftValue.Size = UDim2.new(0.5, 0, 0, 20)
    leftValue.Position = UDim2.new(0, 0, 0, yPos + 15)
    leftValue.BackgroundTransparency = 1
    leftValue.Text = data.fnL()
    leftValue.TextColor3 = data.colorL
    leftValue.Font = Enum.Font.GothamBold
    leftValue.TextSize = isTouch and 15 or 17
    leftValue.TextXAlignment = Enum.TextXAlignment.Center
    leftValue.Parent = statsFrame

    local rightLabel = Instance.new("TextLabel")
    rightLabel.Size = UDim2.new(0.5, 0, 0, 14)
    rightLabel.Position = UDim2.new(0.5, 0, 0, yPos)
    rightLabel.BackgroundTransparency = 1
    rightLabel.Text = data.labelR
    rightLabel.TextColor3 = Color3.fromRGB(140, 125, 175)
    rightLabel.Font = Enum.Font.GothamBold
    rightLabel.TextSize = isTouch and 8 or 9
    rightLabel.TextXAlignment = Enum.TextXAlignment.Center
    rightLabel.Parent = statsFrame

    local rightValue = Instance.new("TextLabel")
    rightValue.Size = UDim2.new(0.5, 0, 0, 20)
    rightValue.Position = UDim2.new(0.5, 0, 0, yPos + 15)
    rightValue.BackgroundTransparency = 1
    rightValue.Text = data.fnR()
    rightValue.TextColor3 = data.colorR
    rightValue.Font = Enum.Font.GothamBold
    rightValue.TextSize = isTouch and 15 or 17
    rightValue.TextXAlignment = Enum.TextXAlignment.Center
    rightValue.Parent = statsFrame

    table.insert(statRefs, { vL = leftValue, vR = rightValue, fnL = data.fnL, fnR = data.fnR })
end

uiElements.statValRefs = statRefs

task.spawn(function()
    while task.wait(3) do
        if not isRunning then break end
        pcall(function()
            for i, stat in ipairs(statRefs) do
                stat.vL.Text = stat.fnL()
                stat.vR.Text = stat.fnR()
            end
        end)
    end
end)

-- Frame Notes
local notesFrame = Instance.new("Frame")
notesFrame.Size = UDim2.new(1, 0, 0, 0)
notesFrame.AutomaticSize = Enum.AutomaticSize.Y
notesFrame.LayoutOrder = 3
notesFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
notesFrame.BorderSizePixel = 0
notesFrame.Parent = infoPage
Instance.new("UICorner", notesFrame).CornerRadius = UDim.new(0, 12)

local ncStroke = Instance.new("UIStroke", notesFrame)
ncStroke.Color = Color3.fromRGB(90, 40, 180)
ncStroke.Thickness = 1.5
ncStroke.Transparency = 0.2
uiElements.ncStroke = ncStroke

local ncPad = Instance.new("UIPadding", notesFrame)
ncPad.PaddingLeft = UDim.new(0, 12)
ncPad.PaddingRight = UDim.new(0, 12)
ncPad.PaddingTop = UDim.new(0, 10)
ncPad.PaddingBottom = UDim.new(0, 10)

local notesLayout = Instance.new("UIListLayout")
notesLayout.Padding = UDim.new(0, 6)
notesLayout.SortOrder = Enum.SortOrder.LayoutOrder
notesLayout.Parent = notesFrame

local notesTitle = Instance.new("TextLabel")
notesTitle.Size = UDim2.new(1, 0, 0, 18)
notesTitle.LayoutOrder = 1
notesTitle.BackgroundTransparency = 1
notesTitle.Text = "Selamat datang di R4NzDev!"
notesTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
notesTitle.Font = Enum.Font.GothamBold
notesTitle.TextSize = isTouch and 11 or 12
notesTitle.TextXAlignment = Enum.TextXAlignment.Left
notesTitle.Parent = notesFrame

local notesDivider = Instance.new("Frame")
notesDivider.Size = UDim2.new(1, 0, 0, 1)
notesDivider.LayoutOrder = 2
notesDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
notesDivider.BorderSizePixel = 0
notesDivider.Parent = notesFrame

local notesContent = {
    { order = 3, text = "⚜️  Gunakan semaksimal mungkin," },
    { order = 4, text = "     Jangan sampai ketahuan admin." },
    { order = 5, text = "⚜️  Aku ga bertanggung jawab apabila terkena banned." },
    { order = 6, text = "     Jangan Bar2." },
    { order = 7, text = "⚜️  Hati-hati kawan." },
    { order = 8, text = "     SCRIPT INI 100% FREE (UNTUK SAAT INI!)." },
    { order = 9, text = "Bismillahirrahmanirrahim Al-Fatihah." }
}

for i, note in ipairs(notesContent) do
    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(1, 0, 0, note.text == "" and 4 or isTouch and 15 or 16)
    noteLabel.LayoutOrder = note.order
    noteLabel.BackgroundTransparency = 1
    noteLabel.Text = note.text
    noteLabel.TextColor3 = Color3.fromRGB(170, 155, 200)
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextSize = isTouch and 9 or 10
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.TextWrapped = true
    noteLabel.Parent = notesFrame
end

-- Frame Update
local updateFrame = Instance.new("Frame")
updateFrame.Size = UDim2.new(1, 0, 0, 0)
updateFrame.AutomaticSize = Enum.AutomaticSize.Y
updateFrame.LayoutOrder = 4
updateFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
updateFrame.BorderSizePixel = 0
updateFrame.Parent = infoPage
Instance.new("UICorner", updateFrame).CornerRadius = UDim.new(0, 12)

local cscStroke = Instance.new("UIStroke", updateFrame)
cscStroke.Color = Color3.fromRGB(90, 40, 180)
cscStroke.Thickness = 1.5
cscStroke.Transparency = 0.2
uiElements.cscStroke = cscStroke

local cscPad = Instance.new("UIPadding", updateFrame)
cscPad.PaddingLeft = UDim.new(0, 12)
cscPad.PaddingRight = UDim.new(0, 12)
cscPad.PaddingTop = UDim.new(0, 10)
cscPad.PaddingBottom = UDim.new(0, 10)

local cscLayout = Instance.new("UIListLayout")
cscLayout.Padding = UDim.new(0, 5)
cscLayout.SortOrder = Enum.SortOrder.LayoutOrder
cscLayout.Parent = updateFrame

local updateTitle = Instance.new("TextLabel")
updateTitle.Size = UDim2.new(1, 0, 0, 18)
updateTitle.LayoutOrder = 1
updateTitle.BackgroundTransparency = 1
updateTitle.Text = "🔥 NEW UPDATE"
updateTitle.TextColor3 = Color3.fromRGB(255, 180, 50)
updateTitle.Font = Enum.Font.GothamBold
updateTitle.TextSize = isTouch and 11 or 12
updateTitle.TextXAlignment = Enum.TextXAlignment.Left
updateTitle.Parent = updateFrame

local updateDivider = Instance.new("Frame")
updateDivider.Size = UDim2.new(1, 0, 0, 1)
updateDivider.LayoutOrder = 2
updateDivider.BackgroundColor3 = Color3.fromRGB(80, 60, 20)
updateDivider.BorderSizePixel = 0
updateDivider.Parent = updateFrame

local updateItems = {
    { order = 3, icon = "🕤", text = "INFO — liat profil dan info selanjutnya" },
    { order = 4, icon = "🕤", text = "NYAWA — deteksi sisa nyawa musuh" },
    { order = 5, icon = "🕋", text = "ANTI ADMIN — auto exit kalo ada admin datang" },
    { order = 6, icon = "🕾", text = "MODE TUYUL — auto mengalah setiap tujuan tercapai" }
}

for i, item in ipairs(updateItems) do
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, 0, 0, isTouch and 20 or 22)
    itemFrame.LayoutOrder = item.order
    itemFrame.BackgroundTransparency = 1
    itemFrame.Parent = updateFrame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 20, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = item.icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = isTouch and 11 or 12
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = itemFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -24, 1, 0)
    textLabel.Position = UDim2.new(0, 24, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = item.text
    textLabel.TextColor3 = Color3.fromRGB(170, 155, 200)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = isTouch and 9 or 10
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = itemFrame
end

-- Frame Versi
local versionFrame = Instance.new("Frame")
versionFrame.Size = UDim2.new(1, 0, 0, isTouch and 36 or 40)
versionFrame.LayoutOrder = 5
versionFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
versionFrame.BorderSizePixel = 0
versionFrame.Parent = infoPage
Instance.new("UICorner", versionFrame).CornerRadius = UDim.new(0, 12)

local vcStroke = Instance.new("UIStroke", versionFrame)
vcStroke.Color = Color3.fromRGB(90, 40, 180)
vcStroke.Thickness = 1.5
vcStroke.Transparency = 0.2
uiElements.vcStroke = vcStroke

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, -16, 1, 0)
versionLabel.Position = UDim2.new(0, 12, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version: 2.0.2  —  Last update: 11 Mar 2026"
versionLabel.TextColor3 = Color3.fromRGB(100, 90, 140)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = isTouch and 9 or 10
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = versionFrame

-- Halaman lainnya
mainPage = createPage()
mainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainPage.ScrollBarThickness = isTouch and 3 or 2
mainPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
mainPage.ScrollBarImageTransparency = 0
mainPage.ScrollingDirection = Enum.ScrollingDirection.Y

utilPage = createPage()
utilPage.CanvasSize = UDim2.new(0, 0, 0, 0)
utilPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
utilPage.ScrollBarThickness = isTouch and 3 or 2
utilPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
utilPage.ScrollBarImageTransparency = 0
utilPage.ScrollingDirection = Enum.ScrollingDirection.Y
uiElements.UtilScrollBar = utilPage

local utilLayout = Instance.new("UIListLayout")
utilLayout.Padding = UDim.new(0, 8)
utilLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilLayout.Parent = utilPage

nyawaPage = createPage()
nyawaPage.CanvasSize = UDim2.new(0, 0, 0, 0)
nyawaPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
nyawaPage.ScrollBarThickness = isTouch and 3 or 2
nyawaPage.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)
nyawaPage.ScrollBarImageTransparency = 0
nyawaPage.ScrollingDirection = Enum.ScrollingDirection.Y

local nyawaPad = Instance.new("UIPadding", nyawaPage)
nyawaPad.PaddingLeft = UDim.new(0, 6)
nyawaPad.PaddingRight = UDim.new(0, 6)
nyawaPad.PaddingTop = UDim.new(0, 8)
nyawaPad.PaddingBottom = UDim.new(0, 8)

local nyawaLayout = Instance.new("UIListLayout")
nyawaLayout.Padding = UDim.new(0, 6)
nyawaLayout.SortOrder = Enum.SortOrder.LayoutOrder
nyawaLayout.Parent = nyawaPage

-- Header halaman Nyawa
local nyawaHeaderFrame = Instance.new("Frame")
nyawaHeaderFrame.Size = UDim2.new(1, 0, 0, 24)
nyawaHeaderFrame.LayoutOrder = 0
nyawaHeaderFrame.BackgroundTransparency = 1
nyawaHeaderFrame.Parent = nyawaPage

local nyawaHeaderTitle = Instance.new("TextLabel")
nyawaHeaderTitle.Size = UDim2.new(1, -80, 1, 0)
nyawaHeaderTitle.BackgroundTransparency = 1
nyawaHeaderTitle.Text = "🕤 NYAWA PEMAIN 1 MATCH"
nyawaHeaderTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
nyawaHeaderTitle.Font = Enum.Font.GothamBold
nyawaHeaderTitle.TextSize = 10
nyawaHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
nyawaHeaderTitle.Parent = nyawaHeaderFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 72, 1, 0)
refreshBtn.Position = UDim2.new(1, -72, 0, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 55)
refreshBtn.Text = "🔃 REFRESH"
refreshBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 9
refreshBtn.Parent = nyawaHeaderFrame
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 7)

local refreshStroke = Instance.new("UIStroke", refreshBtn)
refreshStroke.Color = Color3.fromRGB(120, 60, 220)
refreshStroke.Thickness = 1.5
refreshStroke.Transparency = 0.2

-- Tabel kartu Nyawa
local nyawaCards = {}

-- Fungsi membuat kartu Nyawa
function createNyawaCard(index)
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, isTouch and 62 or 68)
    cardFrame.LayoutOrder = index
    cardFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
    cardFrame.BorderSizePixel = 0
    cardFrame.Visible = false
    cardFrame.Parent = nyawaPage
    Instance.new("UICorner", cardFrame).CornerRadius = UDim.new(0, 10)

    local cardStroke = Instance.new("UIStroke", cardFrame)
    cardStroke.Color = Color3.fromRGB(80, 20, 20)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -90, 0, 22)
    nameLabel.Position = UDim2.new(0, 10, 0, 6)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "..."
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = isTouch and 11 or 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = cardFrame

    local hearts = {}
    local heartPositions = { -140, -116 }
    for i = 1, 2, 1 do
        local heartLabel = Instance.new("TextLabel")
        heartLabel.Size = UDim2.new(0, 20, 0, 20)
        heartLabel.Position = UDim2.new(1, heartPositions[i], 0, 8)
        heartLabel.BackgroundTransparency = 1
        heartLabel.Text = "🕤"
        heartLabel.Font = Enum.Font.GothamBold
        heartLabel.TextSize = 16
        heartLabel.TextColor3 = Color3.new(1, 1, 1)
        heartLabel.Parent = cardFrame
        hearts[i] = heartLabel
    end

    local badgeLabel = Instance.new("TextLabel")
    badgeLabel.Size = UDim2.new(0, 55, 0, 18)
    badgeLabel.Position = UDim2.new(1, -62, 0, 7)
    badgeLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    badgeLabel.Text = "HIDUP"
    badgeLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    badgeLabel.Font = Enum.Font.GothamBold
    badgeLabel.TextSize = 9
    badgeLabel.Parent = cardFrame
    Instance.new("UICorner", badgeLabel).CornerRadius = UDim.new(1, 0)

    local dividerLine = Instance.new("Frame")
    dividerLine.Size = UDim2.new(1, -20, 0, 1)
    dividerLine.Position = UDim2.new(0, 10, 0, 32)
    dividerLine.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
    dividerLine.BorderSizePixel = 0
    dividerLine.Parent = cardFrame

    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 24)
    statsFrame.Position = UDim2.new(0, 0, 0, 36)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Parent = cardFrame

    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.Padding = UDim.new(0, 0)
    statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    statsLayout.Parent = statsFrame

    function makeStatLabel(icon, color, order)
        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(0.25, 0, 1, 0)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = icon .. " —"
        statLabel.TextColor3 = color
        statLabel.Font = Enum.Font.GothamBold
        statLabel.TextSize = isTouch and 9 or 10
        statLabel.TextXAlignment = Enum.TextXAlignment.Center
        statLabel.LayoutOrder = order
        statLabel.Parent = statsFrame
        return statLabel
    end

    local winsLabel = makeStatLabel("🏆", Color3.fromRGB(255, 210, 60), 1)
    local lossesLabel = makeStatLabel("💀", Color3.fromRGB(255, 80, 80), 2)
    local rateLabel = makeStatLabel("📈", Color3.fromRGB(80, 220, 120), 3)
    local moneyLabel = makeStatLabel("💰", Color3.fromRGB(120, 190, 255), 4)

    return {
        frame = cardFrame,
        nameLbl = nameLabel,
        hearts = hearts,
        badge = badgeLabel,
        winsLbl = winsLabel,
        lossesLbl = lossesLabel,
        rateLbl = rateLabel,
        moneyLbl = moneyLabel
    }
end

for i = 1, 8, 1 do
    nyawaCards[i] = createNyawaCard(i)
end

local emptyMsgLabel = Instance.new("TextLabel")
emptyMsgLabel.Size = UDim2.new(1, 0, 0, 40)
emptyMsgLabel.LayoutOrder = 9
emptyMsgLabel.BackgroundTransparency = 1
emptyMsgLabel.Text = "⚜️ Belum ada match aktif"
emptyMsgLabel.TextColor3 = Color3.fromRGB(100, 90, 130)
emptyMsgLabel.Font = Enum.Font.Gotham
emptyMsgLabel.TextSize = 10
emptyMsgLabel.TextWrapped = true
emptyMsgLabel.Parent = nyawaPage

local matchPlayers = {}
local hasSnapshotted = false

-- Fungsi mengambil snapshot pemain dalam match
function snapshotMatch()
    local currentTable = player:GetAttribute("CurrentTable")
    matchPlayers = {}

    for i, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local inMatch = false
            if currentTable then
                local success, plrTable = pcall(function() return plr:GetAttribute("CurrentTable") end)
                if success and (plrTable and plrTable == currentTable) then
                    inMatch = true
                end
            end

            if not inMatch and not currentTable then
                local success, lives = pcall(function() return plr:GetAttribute("Lives") end)
                if success and typeof(lives) == "number" then
                    inMatch = true
                end
            end

            if inMatch then
                local success, lives = pcall(function() return plr:GetAttribute("Lives") end)
                local wins, losses, winrate, money = nil, nil, nil, nil

                local leaderstats = plr:FindFirstChild("leaderstats")
                if leaderstats then
                    local winsStat = leaderstats:FindFirstChild("Wins")
                    local lossesStat = leaderstats:FindFirstChild("Losses")
                    local moneyStat = leaderstats:FindFirstChild("Money")

                    if winsStat and lossesStat then
                        wins = winsStat.Value
                        losses = lossesStat.Value
                        local total = wins + losses
                        winrate = total > 0 and math.floor((wins / total) * 100) or 0
                    end
                    if moneyStat then
                        money = moneyStat.Value
                    end
                end

                table.insert(matchPlayers, {
                    player = plr,
                    nama = plr.Name,
                    lives = success and lives or nil,
                    dead = false,
                    wins = wins,
                    losses = losses,
                    winrate = winrate,
                    money = money
                })
            end
        end
    end
    print("[R4NzDev] Nyawa: Snapshot " .. (#matchPlayers .. " musuh"))
end

-- Fungsi memperbarui halaman Nyawa
function updateNyawaPage()
    local currentTable = player:GetAttribute("CurrentTable")

    if currentTable and not hasSnapshotted then
        snapshotMatch()
        hasSnapshotted = true
    end
    if not currentTable and hasSnapshotted then
        hasSnapshotted = false
        matchPlayers = {}
    end

    if currentTable and #matchPlayers > 0 then
        for i, plrData in ipairs(matchPlayers) do
            if not plrData.dead then
                local success, tableName = pcall(function() return plrData.player:GetAttribute("CurrentTable") end)
                if not success or tableName ~= currentTable then
                    plrData.dead = true
                else
                    local success, lives = pcall(function() return plrData.player:GetAttribute("Lives") end)
                    if success and typeof(lives) == "number" then
                        plrData.lives = lives
                        if lives <= 0 then
                            plrData.dead = true
                        end
                    end
                end

                local nameSuccess, name = pcall(function() return plrData.player.Name end)
                if nameSuccess then
                    plrData.nama = name
                end

                local leaderstats = plrData.player:FindFirstChild("leaderstats")
                if leaderstats then
                    local winsStat = leaderstats:FindFirstChild("Wins")
                    local lossesStat = leaderstats:FindFirstChild("Losses")
                    local moneyStat = leaderstats:FindFirstChild("Money")

                    if winsStat and lossesStat then
                        plrData.wins = winsStat.Value
                        plrData.losses = lossesStat.Value
                        local total = plrData.wins + plrData.losses
                        plrData.winrate = total > 0 and math.floor((plrData.wins / total) * 100) or 0
                    end
                    if moneyStat then
                        plrData.money = moneyStat.Value
                    end
                end
            end
        end
    end

    for i = 1, 8, 1 do
        nyawaCards[i].frame.Visible = false
    end

    if #matchPlayers == 0 then
        emptyMsgLabel.Text = currentTable and "🔎 Mendeteksi musuh... (coba REFRESH)" or "⚜️ Kamu belum di match"
        emptyMsgLabel.Visible = true
        return
    end

    emptyMsgLabel.Visible = false

    for i, plrData in ipairs(matchPlayers) do
        if i > 8 then break end
        local card = nyawaCards[i]
        card.frame.Visible = true
        card.nameLbl.Text = plrData.nama

        local winsText = plrData.wins ~= nil and tostring(plrData.wins) or "?"
        local lossesText = plrData.losses ~= nil and tostring(plrData.losses) or "?"
        local rateText = plrData.winrate ~= nil and tostring(plrData.winrate) .. "%" or "?"
        local moneyText = plrData.money ~= nil and "Rp" .. tostring(plrData.money) or "?"

        card.winsLbl.Text = "🏆 " .. winsText
        card.lossesLbl.Text = "💀 " .. lossesText
        card.rateLbl.Text = "📈 " .. rateText
        card.moneyLbl.Text = "💰 " .. moneyText

        local stroke = card.frame:FindFirstChildOfClass("UIStroke")
        if plrData.dead then
            card.hearts[1].Text = "🕤"
            card.hearts[2].Text = "🕤"
            card.badge.Text = "MATI"
            card.badge.TextColor3 = Color3.fromRGB(255, 60, 60)
            if stroke then stroke.Color = Color3.fromRGB(150, 20, 20) end
        elseif typeof(plrData.lives) ~= "number" then
            card.hearts[1].Text = "🕤"
            card.hearts[2].Text = "🕤"
            card.badge.Text = "SIAP"
            card.badge.TextColor3 = Color3.fromRGB(150, 150, 150)
            if stroke then stroke.Color = Color3.fromRGB(60, 60, 80) end
        elseif plrData.lives >= 2 then
            card.hearts[1].Text = "🕤"
            card.hearts[2].Text = "🕤"
            card.badge.Text = "FULL"
            card.badge.TextColor3 = Color3.fromRGB(80, 255, 80)
            if stroke then stroke.Color = Color3.fromRGB(20, 100, 20) end
        elseif plrData.lives == 1 then
            card.hearts[1].Text = "🕤"
            card.hearts[2].Text = "🕤"
            card.badge.Text = "1 NYAWA"
            card.badge.TextColor3 = Color3.fromRGB(255, 200, 0)
            if stroke then stroke.Color = Color3.fromRGB(150, 100, 0) end
        else
            card.hearts[1].Text = "🕤"
            card.hearts[2].Text = "🕤"
            card.badge.Text = "MATI"
            card.badge.TextColor3 = Color3.fromRGB(255, 60, 60)
            if stroke then stroke.Color = Color3.fromRGB(150, 20, 20) end
            plrData.dead = true
        end
    end
end

-- Event refresh button
refreshBtn.MouseButton1Click:Connect(function()
    local currentTable = player:GetAttribute("CurrentTable")
    if not currentTable then
        refreshBtn.Text = "⚆ Belum di match"
        refreshBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        task.delay(1.5, function()
            refreshBtn.Text = "🔃 REFRESH"
            refreshBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
        end)
        return
    end

    playClickSound()
    refreshBtn.Text = "⌛ ..."
    refreshBtn.TextColor3 = Color3.fromRGB(255, 200, 50)

    matchPlayers = {}
    hasSnapshotted = false

    task.spawn(function()
        task.wait(0.3)
        hasSnapshotted = true
        pcall(snapshotMatch)
        pcall(updateNyawaPage)
        task.wait(0.5)
        refreshBtn.Text = "🔃 REFRESH"
        refreshBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
    end)
end)

-- Loop update nyawa
task.spawn(function()
    while task.wait(1) do
        if not isRunning then break end
        pcall(updateNyawaPage)
    end
end)

-- Event ketika CurrentTable berubah
player:GetAttributeChangedSignal("CurrentTable"):Connect(function()
    local currentTable = player:GetAttribute("CurrentTable")
    if currentTable then
        task.delay(2, function()
            pcall(snapshotMatch)
            pcall(updateNyawaPage)
        end)
        task.delay(5, function()
            if #matchPlayers == 0 then
                pcall(snapshotMatch)
                pcall(updateNyawaPage)
                print("[R4NzDev] Nyawa: Second attempt snapshot")
            end
        end)
    else
        hasSnapshotted = false
        matchPlayers = {}
        pcall(updateNyawaPage)
    end
end)

-- Event ketika player baru masuk
Players.PlayerAdded:Connect(function(plr)
    plr:GetAttributeChangedSignal("Lives"):Connect(function()
        pcall(updateNyawaPage)
    end)
end)

for i, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr:GetAttributeChangedSignal("Lives"):Connect(function()
            pcall(updateNyawaPage)
        end)
    end
end

task.spawn(function()
    task.wait(3)
    local currentTable = player:GetAttribute("CurrentTable")
    if currentTable and not hasSnapshotted then
        hasSnapshotted = true
        pcall(snapshotMatch)
        pcall(updateNyawaPage)
        print("[R4NzDev] Nyawa: Detected in match on load!")
    end
    task.wait(3)
    if hasSnapshotted and #matchPlayers == 0 then
        pcall(snapshotMatch)
        pcall(updateNyawaPage)
    end
end)

-- Fungsi menampilkan halaman
function showPage(page)
    local pages = { infoPage, mainPage, utilPage, nyawaPage }
    for i, p in pairs(pages) do
        if p then p.Visible = false end
    end
    if page then page.Visible = true end
end

showPage(mainPage)
setActiveTab(tabMain)

tabInfo.MouseButton1Click:Connect(function()
    showPage(infoPage)
    setActiveTab(tabInfo)
    playClickSound()
end)

tabNyawa.MouseButton1Click:Connect(function()
    showPage(nyawaPage)
    setActiveTab(tabNyawa)
    playClickSound()
end)

tabMain.MouseButton1Click:Connect(function()
    showPage(mainPage)
    setActiveTab(tabMain)
    playClickSound()
end)

tabUtil.MouseButton1Click:Connect(function()
    showPage(utilPage)
    setActiveTab(tabUtil)
    playClickSound()
end)

-- ==============================================
-- BAGIAN AUTO TULIS / AUTO ANSWER
-- ==============================================

-- Variabel untuk fitur auto tulis
local autoTulisEnabled = false
local autoRejoinEnabled = true
local delayMin = 0.03
local delayMax = 0.08
local intervalMin = 0.15
local intervalMax = 0.5
local deleteDelay = 0.02
local holdDelay = 0.06
local autoManusiaEnabled = false
local lastMessage = ""
local lastTarget = ""

-- Variabel untuk auto answer
local Sx = false  -- Mode manusia (salah ketik)
local tx = false  -- Mode tuyul
local JX = 3      -- Jumlah target jawab tuyul
local qX = 0      -- Counter jawaban tuyul
local NX = false  -- Status mode tuyul
local WX = 0      -- Counter spam tuyul
local vX = 2      -- Versi tuyul
local pX = false  -- Mode blatant
local ZX = ""     -- Kata untuk blatant
local eX = ""     -- Awalan untuk blatant

-- Database kata random
local kataRandom = { "wkwk", "receh", "noob", "lemah", "kasian", "santuy", "ezz", "wkwk", "lol", "mudah" }

-- Database kata per kategori
local dropData = { 
    IF = {}, X = {}, NG = {}, AI = {}, KS = {}, CY = {}, UI = {}, LY = {}, GY = {}, 
    LT = {}, EO = {}, OE = {}, EKS = {}, OO = {}, KN = {}, Q = {}, MP = {}, SF = {}, 
    TT = {}, ["SEMUA KATA SULIT"] = {} 
}

-- Status toggle per kategori
local dropState = { 
    IF = false, X = false, NG = false, AI = false, KS = false, CY = false, UI = false, 
    LY = false, GY = false, LT = false, EO = false, OE = false, EKS = false, OO = false, 
    KN = false, Q = false, MP = false, SF = false, TT = false, ["SEMUA KATA SULIT"] = false 
}

-- Variabel untuk menyimpan kata yang sudah pernah dipakai
local MX = {}

-- Database kata umum
local zX = {
    "abad", "abadi", "abang", "abdul", "abi", "abjad", "acara", "adalah", "adanya",
    "adapun", "adaptasi", "adat", "adegan", "adil", "adinda", "aduk", "adukan",
    "agama", "agar", "agen", "agung", "ahad", "ahli", "air", "aja", "ajak",
    "ajar", "ajeg", "aji", "aju", "akad", "akal", "akan", "akar", "akhir", "akhlak",
    "akibat", "akrab", "aksara", "aksi", "aku", "akun", "akurat", "alam", "alamat",
    "alang", "alas", "alat", "album", "alfabet", "algojo", "ali", "alias", "alih",
    "alim", "alir", "aliran", "alis", "alkali", "alkitab", "allah", "alpa", "alu",
    "alun", "alur", "aluran", "amal", "aman"
}

-- ==============================================
-- FITUR LOG PERMAINAN (PER MATCH & SEMUA MATCH)
-- ==============================================

-- Log untuk match saat ini
local currentGameLogs = {}  -- Format: { time = "12:34:56", question = "R", answer = "RUMAH", status = "✓" }

-- Log untuk semua match (history)
local allGameLogs = {}  -- Format: { time = "12:34:56", question = "R", answer = "RUMAH", status = "✓", match = 1 }

-- Counter match
local matchCounter = 0

-- Fungsi menambah log baru
function addGameLog(question, answer, status)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = {
        time = timestamp,
        question = question:upper(),
        answer = answer:upper(),
        status = status or "✓",
        match = matchCounter
    }
    
    -- Tambahkan ke log match saat ini
    table.insert(currentGameLogs, logEntry)
    
    -- Tambahkan ke semua log
    table.insert(allGameLogs, logEntry)
    
    -- Update tampilan
    if logScrollingFrame then
        updateLogDisplay()
    end
    
    -- Debug
    print("📝 [Match " .. matchCounter .. "] " .. question .. " → " .. answer .. " " .. (status or "✓"))
end

-- Fungsi reset log untuk match baru
function newMatch()
    matchCounter = matchCounter + 1
    currentGameLogs = {}
    if logScrollingFrame then
        updateLogDisplay()
    end
    print("🆕 Match " .. matchCounter .. " dimulai")
end

-- Fungsi mendapatkan teks log untuk match saat ini
function getCurrentMatchText()
    if #currentGameLogs == 0 then
        return "Belum ada data untuk match ini"
    end
    
    local text = "=== R4NzDev Game Logs ===\n"
    text = text .. "Match #" .. matchCounter .. "\n"
    text = text .. string.rep("=", 40) .. "\n"
    text = text .. "Waktu   | Soal | Jawaban | Status\n"
    text = text .. string.rep("-", 40) .. "\n"
    
    for _, log in ipairs(currentGameLogs) do
        text = text .. string.format("%s |  %s   | %-10s | %s\n", 
            log.time, 
            log.question, 
            log.answer, 
            log.status
        )
    end
    
    text = text .. string.rep("-", 40) .. "\n"
    text = text .. "Total: " .. #currentGameLogs .. " jawaban"
    
    return text
end

-- Fungsi mendapatkan teks semua log
function getAllMatchesText()
    if #allGameLogs == 0 then
        return "Belum ada data permainan"
    end
    
    local text = "=== R4NzDev All Matches Logs ===\n"
    text = text .. string.rep("=", 50) .. "\n\n"
    
    local currentMatch = 0
    local matchLogs = {}
    
    -- Kelompokkan berdasarkan match
    for _, log in ipairs(allGameLogs) do
        if log.match ~= currentMatch then
            if #matchLogs > 0 then
                text = text .. "Match #" .. currentMatch .. "\n"
                text = text .. string.rep("-", 40) .. "\n"
                for _, mlog in ipairs(matchLogs) do
                    text = text .. string.format("%s | %s | %-10s | %s\n", 
                        mlog.time, mlog.question, mlog.answer, mlog.status)
                end
                text = text .. "\n"
            end
            currentMatch = log.match
            matchLogs = {}
        end
        table.insert(matchLogs, log)
    end
    
    -- Match terakhir
    if #matchLogs > 0 then
        text = text .. "Match #" .. currentMatch .. "\n"
        text = text .. string.rep("-", 40) .. "\n"
        for _, mlog in ipairs(matchLogs) do
            text = text .. string.format("%s | %s | %-10s | %s\n", 
                mlog.time, mlog.question, mlog.answer, mlog.status)
        end
        text = text .. "\n"
    end
    
    text = text .. string.rep("=", 50) .. "\n"
    text = text .. "Total: " .. #allGameLogs .. " jawaban dari " .. matchCounter .. " match"
    
    return text
end

-- Fungsi copy ke clipboard
function copyToClipboard(mode)
    local text = ""
    if mode == "current" then
        text = getCurrentMatchText()
    else
        text = getAllMatchesText()
    end
    
    -- Copy ke clipboard
    if setclipboard then
        setclipboard(text)
        if logNotif then
            logNotif.Text = "✓ Log disalin ke clipboard!"
            logNotif.Visible = true
            task.delay(2, function()
                if logNotif then logNotif.Visible = false end
            end)
        end
    else
        if logNotif then
            logNotif.Text = "⚠️ Fitur clipboard tidak tersedia"
            logNotif.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            logNotif.Visible = true
            task.delay(2, function()
                if logNotif then 
                    logNotif.Visible = false
                    logNotif.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
                end
            end)
        end
    end
end

-- Fungsi hapus log
function deleteLogs(mode)
    if mode == "current" then
        currentGameLogs = {}
        if logNotif then
            logNotif.Text = "✓ Log match ini dihapus"
            logNotif.Visible = true
            task.delay(2, function()
                if logNotif then logNotif.Visible = false end
            end)
        end
    else
        currentGameLogs = {}
        allGameLogs = {}
        matchCounter = 0
        if logNotif then
            logNotif.Text = "✓ Semua log dihapus"
            logNotif.Visible = true
            task.delay(2, function()
                if logNotif then logNotif.Visible = false end
            end)
        end
    end
    updateLogDisplay()
end

-- Fungsi update tampilan log
function updateLogDisplay()
    if not logScrollingFrame then return end
    
    -- Hapus semua child
    for _, child in pairs(logScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Jika tidak ada log
    if #currentGameLogs == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, -20, 0, 60)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "📭 Belum ada jawaban untuk match ini\n\nMatch #" .. matchCounter
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 12
        emptyLabel.TextWrapped = true
        emptyLabel.TextXAlignment = Enum.TextXAlignment.Center
        emptyLabel.Parent = logScrollingFrame
        
        logScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 80)
        return
    end
    
    -- Header match
    local headerLabel = Instance.new("TextLabel")
    headerLabel.Size = UDim2.new(1, -20, 0, 25)
    headerLabel.Position = UDim2.new(0, 10, 0, 5)
    headerLabel.BackgroundTransparency = 1
    headerLabel.Text = "📊 Match #" .. matchCounter
    headerLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    headerLabel.Font = Enum.Font.GothamBold
    headerLabel.TextSize = 14
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    headerLabel.Parent = logScrollingFrame
    
    -- Tampilkan log
    local yPos = 35
    for i, log in ipairs(currentGameLogs) do
        local logItem = Instance.new("Frame")
        logItem.Size = UDim2.new(1, -20, 0, 35)
        logItem.Position = UDim2.new(0, 10, 0, yPos)
        logItem.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(25, 23, 35) or Color3.fromRGB(30, 28, 40)
        logItem.BorderSizePixel = 0
        logItem.Parent = logScrollingFrame
        Instance.new("UICorner", logItem).CornerRadius = UDim.new(0, 4)
        
        -- Waktu
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0, 50, 1, 0)
        timeLabel.Position = UDim2.new(0, 5, 0, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = log.time
        timeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        timeLabel.Font = Enum.Font.Gotham
        timeLabel.TextSize = 10
        timeLabel.TextXAlignment = Enum.TextXAlignment.Left
        timeLabel.Parent = logItem
        
        -- Soal
        local questionLabel = Instance.new("TextLabel")
        questionLabel.Size = UDim2.new(0, 30, 1, 0)
        questionLabel.Position = UDim2.new(0, 60, 0, 0)
        questionLabel.BackgroundTransparency = 1
        questionLabel.Text = log.question
        questionLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
        questionLabel.Font = Enum.Font.GothamBold
        questionLabel.TextSize = 16
        questionLabel.TextXAlignment = Enum.TextXAlignment.Center
        questionLabel.Parent = logItem
        
        -- Jawaban
        local answerLabel = Instance.new("TextLabel")
        answerLabel.Size = UDim2.new(1, -140, 1, 0)
        answerLabel.Position = UDim2.new(0, 95, 0, 0)
        answerLabel.BackgroundTransparency = 1
        answerLabel.Text = log.answer
        answerLabel.TextColor3 = log.status == "✓" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        answerLabel.Font = Enum.Font.GothamBold
        answerLabel.TextSize = 14
        answerLabel.TextXAlignment = Enum.TextXAlignment.Left
        answerLabel.Parent = logItem
        
        -- Status
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0, 25, 1, 0)
        statusLabel.Position = UDim2.new(1, -30, 0, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = log.status
        statusLabel.TextColor3 = log.status == "✓" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 18
        statusLabel.Parent = logItem
        
        yPos = yPos + 40
    end
    
    -- Update canvas size
    logScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- Layout halaman MAIN
local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, isTouch and 5 or 7)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainPage

local mainPad = Instance.new("UIPadding", mainPage)
mainPad.PaddingLeft = UDim.new(0, 5)
mainPad.PaddingRight = UDim.new(0, 5)
mainPad.PaddingTop = UDim.new(0, 5)
mainPad.PaddingBottom = UDim.new(0, 10)

-- ==============================================
-- SPEED SETTINGS YANG SUDAH DIPERBAIKI UNTUK HP
-- ==============================================
function createCompactSpeedPanel(parent, order)
    local panelHeight = isTouch and 48 or 42
    local totalHeight = (28 + 4 * panelHeight) + 6
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(1, -4, 0, totalHeight)
    panel.LayoutOrder = order
    panel.BackgroundColor3 = Color3.fromRGB(12, 11, 20)
    panel.BorderSizePixel = 0
    panel.Parent = parent
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 11)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Color3.fromRGB(60, 30, 110)
    panelStroke.Thickness = 1
    panelStroke.Transparency = 0.3

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 26)
    headerFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = panel
    Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 11)

    local headerCoverFrame = Instance.new("Frame")
    headerCoverFrame.Size = UDim2.new(1, 0, 0.5, 0)
    headerCoverFrame.Position = UDim2.new(0, 0, 0.5, 0)
    headerCoverFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    headerCoverFrame.BorderSizePixel = 0
    headerCoverFrame.Parent = headerFrame

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -12, 1, 0)
    headerTitle.Position = UDim2.new(0, 12, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "⚡  SPEED SETTINGS"
    headerTitle.TextColor3 = Color3.fromRGB(180, 140, 255)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 10
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = headerFrame

    local sliders = {
        { icon = "⌨", label = "NULIS", min = 0.01, max = 1, defMin = 0.19, defMax = 0.37, dec = 2, suffix = "s", cbMin = function(val) delayMin = val end, cbMax = function(val) delayMax = val end },
        { icon = "⍱", label = "DELAY GILIRAN", min = 0.1, max = 5, defMin = 1.5, defMax = 2.5, dec = 1, suffix = "s", cbMin = function(val) intervalMin = val end, cbMax = function(val) intervalMax = val end },
        { icon = "⍎", label = "INTER", min = 0.01, max = 3, defMin = 0.2, defMax = 0.5, dec = 2, suffix = "s", cbMin = function(val) intervalMin = val end, cbMax = function(val) intervalMax = val end },
        { icon = "🗑", label = "DELETE", min = 0.01, max = 1, defMin = 0.2, defMax = 0.3, dec = 2, suffix = "s", cbMin = function(val) deleteDelay = val end, cbMax = function(val) holdDelay = val end }
    }

    for i, s in ipairs(sliders) do
        s.cbMin(s.defMin)
        s.cbMax(s.defMax)
    end

    local sliderItemHeight = isTouch and 20 or 14  -- Diperbesar untuk HP
    local knobSize = isTouch and 24 or 16  -- Knob lebih besar untuk HP

    for i, s in ipairs(sliders) do
        local yPos = 28 + (i - 1) * panelHeight
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, panelHeight - 4)
        sliderFrame.Position = UDim2.new(0, 5, 0, yPos)
        sliderFrame.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(16, 14, 26) or Color3.fromRGB(13, 12, 22)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = panel
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 7)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 80, 0, 14)
        label.Position = UDim2.new(0, 8, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = s.icon .. (" " .. s.label)
        label.TextColor3 = Color3.fromRGB(170, 155, 210)
        label.Font = Enum.Font.GothamBold
        label.TextSize = isTouch and 9 or 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame

        local formatStr = "%." .. (s.dec .. "f")
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 90, 0, 14)
        valueLabel.Position = UDim2.new(1, -94, 0, 4)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = isTouch and 9 or 9
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame

        local minVal, maxVal = s.defMin, s.defMax

        function updateValueLabel()
            valueLabel.Text = string.format(formatStr, minVal) .. " ~ " .. (string.format(formatStr, maxVal) .. s.suffix)
            local theme = themes[currentTheme]
            valueLabel.TextColor3 = theme and theme.logText or Color3.fromRGB(150, 100, 255)
        end
        updateValueLabel()

        local barHeight = isTouch and 40 or 30  -- Area bar lebih tinggi untuk HP
        local barPad = isTouch and 8 or 4
        local barFrame = Instance.new("Frame")
        barFrame.Size = UDim2.new(1, -16, 0, barPad)
        barFrame.Position = UDim2.new(0, 8, 0, barHeight)
        barFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
        barFrame.BorderSizePixel = 0
        barFrame.Parent = sliderFrame
        Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)

        local fillBar = Instance.new("Frame")
        fillBar.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
        fillBar.BorderSizePixel = 0
        fillBar.Parent = barFrame
        Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)

        local knobMin = Instance.new("Frame")
        knobMin.Size = UDim2.new(0, knobSize, 0, knobSize)
        knobMin.BackgroundColor3 = Color3.new(1, 1, 1)
        knobMin.BorderSizePixel = 0
        knobMin.ZIndex = 3
        knobMin.Parent = barFrame
        Instance.new("UICorner", knobMin).CornerRadius = UDim.new(1, 0)

        local knobMinStroke = Instance.new("UIStroke", knobMin)
        knobMinStroke.Color = Color3.fromRGB(150, 80, 255)
        knobMinStroke.Thickness = 2

        local knobMax = Instance.new("Frame")
        knobMax.Size = UDim2.new(0, knobSize, 0, knobSize)
        knobMax.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
        knobMax.BorderSizePixel = 0
        knobMax.ZIndex = 3
        knobMax.Parent = barFrame
        Instance.new("UICorner", knobMax).CornerRadius = UDim.new(1, 0)

        local knobMaxStroke = Instance.new("UIStroke", knobMax)
        knobMaxStroke.Color = Color3.fromRGB(200, 150, 255)
        knobMaxStroke.Thickness = 2

        function snapValue(val)
            local mult = 10 ^ s.dec
            return math.floor(val * mult + 0.5) / mult
        end

        local knobRadius = knobSize / 2

        function updateVisual()
            local minRatio = (minVal - s.min) / (s.max - s.min)
            local maxRatio = (maxVal - s.min) / (s.max - s.min)
            fillBar.Position = UDim2.new(minRatio, 0, 0, 0)
            fillBar.Size = UDim2.new(maxRatio - minRatio, 0, 1, 0)
            knobMin.Position = UDim2.new(minRatio, -knobRadius, 0.5, -knobRadius)
            knobMax.Position = UDim2.new(maxRatio, -knobRadius, 0.5, -knobRadius)
            updateValueLabel()
        end
        updateVisual()

        -- BUTTON KHUSUS UNTUK DRAG (diperbaiki untuk HP)
        local dragButton = Instance.new("TextButton")
        dragButton.Size = UDim2.new(1, 0, 1, 0)
        dragButton.Position = UDim2.new(0, 0, 0, 0)
        dragButton.BackgroundTransparency = 1
        dragButton.Text = ""
        dragButton.ZIndex = 5
        dragButton.Parent = barFrame

        local isDraggingMin, isDraggingMax = false, false
        local dragStartX

        function getRatioFromPosition(inputPos)
            local barPos = barFrame.AbsolutePosition.X
            local barSize = barFrame.AbsoluteSize.X
            return math.clamp((inputPos - barPos) / barSize, 0, 1)
        end

        function getValueFromRatio(ratio)
            return snapValue(s.min + ratio * (s.max - s.min))
        end

        -- INPUT BEGAN (mulai drag)
        dragButton.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and 
               input.UserInputType ~= Enum.UserInputType.Touch then return end
            
            local pos = input.Position.X
            local ratio = getRatioFromPosition(pos)
            local val = getValueFromRatio(ratio)
            
            if math.abs(val - minVal) <= math.abs(val - maxVal) then
                isDraggingMin = true
                dragStartX = pos
            else
                isDraggingMax = true
                dragStartX = pos
            end
            
            -- Mencegah event bubbling
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDraggingMin = false
                    isDraggingMax = false
                end
            end)
        end)

        -- INPUT CHANGED (saat digeser)
        dragButton.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and 
               input.UserInputType ~= Enum.UserInputType.Touch then return end
            
            if not (isDraggingMin or isDraggingMax) then return end

            local pos = input.Position.X
            local ratio = getRatioFromPosition(pos)
            local newVal = getValueFromRatio(ratio)
            local step = 1 / (10 ^ s.dec)

            if isDraggingMin then
                minVal = math.clamp(newVal, s.min, maxVal - step)
                s.cbMin(minVal)
            elseif isDraggingMax then
                maxVal = math.clamp(newVal, minVal + step, s.max)
                s.cbMax(maxVal)
            end
            updateVisual()
        end)

        -- INPUT ENDED (lepas drag)
        dragButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                isDraggingMin = false
                isDraggingMax = false
            end
        end)

        table.insert(uiElements, { 
            fill = fillBar, 
            knobMinStroke = knobMinStroke, 
            knobMaxStroke = knobMaxStroke, 
            valLbl = valueLabel, 
            knobMax = knobMax 
        })
    end
    return panel
end

-- Fungsi membuat toggle
function createToggle(label, parent, defaultValue, callback, order)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
    toggleFrame.LayoutOrder = order
    toggleFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 9)

    local toggleStroke = Instance.new("UIStroke", toggleFrame)
    toggleStroke.Color = Color3.fromRGB(55, 30, 100)
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.4

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
    toggleBg.BackgroundColor3 = defaultValue and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
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
        toggleBg.BackgroundColor3 = state and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
        knob.Position = state and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)

    return toggleFrame
end

-- ==============================================
-- FUNGSI UTAMA AUTO ANSWER
-- ==============================================

function simulateTyping(text, totalLength)
    if not isRunning then return end
    
    totalLength = totalLength or #text
    
    if Sx then
        local errorCount = math.random(1, 2)
        local errorsDone = 0
        
        if errorsDone < errorCount and math.random() < 0.3 then
            errorsDone = errorsDone + 1
            task.wait(math.random() * 0.8 + 0.3)
        end
        
        local i = 1
        while i <= #text do
            if not isRunning then return end
            
            if errorsDone < errorCount and (i > 1 and math.random() < 0.12) then
                errorsDone = errorsDone + 1
                task.wait(math.random() * 0.6 + 0.2)
                
                local randomChars = "qwertyuiopasdfghjklzxcvbnm"
                local typoCount = math.random(1, 2)
                for t = 1, typoCount do
                    local randIdx = math.random(1, #randomChars)
                    local randChar = string.upper(string.sub(randomChars, randIdx, randIdx))
                    local keyCode = Enum.KeyCode[randChar]
                    if keyCode then
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                        task.wait(delayMin + math.random() * (delayMax - delayMin))
                    end
                end
                
                task.wait(0.1 + math.random() * 0.2)
                
                for t = 1, typoCount do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.04)
                end
            end
            
            if errorsDone < errorCount and math.random() < 0.1 then
                errorsDone = errorsDone + 1
                local randomChars = "qwertyuiopasdfghjklzxcvbnm"
                local randIdx = math.random(1, #randomChars)
                local randChar = string.upper(string.sub(randomChars, randIdx, randIdx))
                local keyCode = Enum.KeyCode[randChar]
                
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(delayMin + math.random() * (delayMax - delayMin))
                    
                    task.wait(0.08 + math.random() * 0.15)
                    
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.05 + math.random() * 0.1)
                end
            end
            
            local char = string.upper(string.sub(text, i, i))
            local keyCode = Enum.KeyCode[char]
            
            if keyCode then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                task.wait(delayMin + math.random() * (delayMax - delayMin))
            end
            
            i = i + 1
        end
        
        if errorsDone < errorCount and math.random() < 0.15 then
            errorsDone = errorsDone + 1
            local randomWord = kataRandom[math.random(1, #kataRandom)]
            
            task.wait(0.2 + math.random() * 0.3)
            
            for c = 1, #randomWord do
                local char = string.upper(string.sub(randomWord, c, c))
                local keyCode = Enum.KeyCode[char]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(delayMin * 0.7 + (math.random() * delayMax) * 0.5)
                end
            end
            
            task.wait(0.15 + math.random() * 0.2)
            
            for c = 1, #randomWord do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                task.wait(0.03)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                task.wait(0.03)
            end
            
            task.wait(0.1 + math.random() * 0.15)
        end
        
    else
        for i = 1, #text do
            local char = string.upper(string.sub(text, i, i))
            local keyCode = Enum.KeyCode[char]
            
            if keyCode then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                task.wait(delayMin + math.random() * (delayMax - delayMin))
            end
        end
    end
    
    task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local LX = false
local bX = false

gX = function()
    if not autoTulisEnabled or not isRunning or LX then 
        return 
    end
    
    LX = true
    
    if tx and NX then
        local playerGui = player:WaitForChild("PlayerGui")
        local matchUI = playerGui:FindFirstChild("MatchUI", true)
        local awalan = ""
        
        if matchUI then
            for _, obj in pairs(matchUI:GetDescendants()) do
                if (obj.Name == "WordServer" or obj.Name == "Word") and 
                   (obj:IsA("TextLabel") and obj.Visible) then
                    local text = (obj.Text:gsub("%s+", "")):lower()
                    if #text >= 1 and #text <= 4 then
                        awalan = text
                    end
                end
            end
        end
        
        if awalan ~= "" then
            if uiElements.LogAwalan then uiElements.LogAwalan.Text = "👻 SPAM " .. (WX + 1) .. "/2" end
            
            for i = 1, #awalan do
                local char = string.upper(string.sub(awalan, i, i))
                local keyCode = Enum.KeyCode[char]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(0.01)
                end
            end
            
            local randomChars = { "A", "Q", "X", "Z", "J", "V" }
            for r = 1, 2 do
                local randChar = randomChars[math.random(1, #randomChars)]
                local keyCode = Enum.KeyCode[randChar]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(0.01)
                end
            end
            
            task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
        
        WX = WX + 1
        if WX >= 2 then
            NX = false
            WX = 0
            qX = 0
            if uiElements.tuyulStatus then 
                uiElements.tuyulStatus.Text = "Siap: 0/" .. JX .. " jawaban benar"
                uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
            end
            if uiElements.LogIsi then uiElements.LogIsi.Text = "-" end
        else
            if uiElements.tuyulStatus then
                uiElements.tuyulStatus.Text = "SPAM GILIRAN " .. WX .. "/2..."
                uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end
        
        LX = false
        return
    end
    
    local playerGui = player:WaitForChild("PlayerGui")
    local matchUI = playerGui:FindFirstChild("MatchUI", true)
    local awalan = ""
    
    if matchUI then
        for _, obj in pairs(matchUI:GetDescendants()) do
            if (obj.Name == "WordServer" or obj.Name == "Word") and 
               (obj:IsA("TextLabel") and obj.Visible) then
                local text = (obj.Text:gsub("%s+", "")):lower()
                if #text >= 1 and #text <= 4 then
                    awalan = text
                end
            end
        end
    end
    
    if awalan ~= "" then
        if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: " .. awalan:upper() end
        
        local candidates = {}
        local candidatesFromCat = {}
        
        for cat, enabled in pairs(dropState) do
            if enabled then
                for _, word in ipairs(dropData[cat] or {}) do
                    if string.sub(word, 1, #awalan) == awalan and 
                       (not MX[word] and #word > #awalan) then
                        table.insert(candidatesFromCat, word)
                    end
                end
            end
        end
        
        if #candidatesFromCat > 0 then
            candidates = candidatesFromCat
        end
        
        if #candidates == 0 then
            for _, word in ipairs(zX) do
                if string.sub(word, 1, #awalan) == awalan and 
                   (not MX[word] and #word > #awalan) then
                    table.insert(candidates, word)
                end
            end
        end
        
        if #candidates > 0 then
            local selectedWord = candidates[math.random(1, #candidates)]
            
            local sourceCat = "KBB I (SEMUA)"
            for cat, enabled in pairs(dropState) do
                if enabled and table.find(dropData[cat] or {}, selectedWord) then
                    sourceCat = "KATA SULIT (" .. cat .. ")"
                    break
                end
            end
            
            print("🤖 R4NzDev: " .. selectedWord:upper() .. 
                  " | Awalan: " .. awalan:upper() .. 
                  " | " .. sourceCat)
            
            if uiElements.LogIsi then uiElements.LogIsi.Text = selectedWord:upper() end
            
            -- TAMBAHKAN LOG KE GAME LOG
            addGameLog(awalan, selectedWord, "✓")
            
            local mX = selectedWord
            
            simulateTyping(string.sub(selectedWord, #awalan + 1), #selectedWord)
            
            MX[selectedWord] = true
            
            if tx and not NX then
                qX = qX + 1
                if uiElements.tuyulStatus then
                    uiElements.tuyulStatus.Text = "Jawaban benar: " .. qX .. "/" .. JX .. " ➔ " .. (JX - qX) .. "x lagi"
                    uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
                end
                
                if qX >= JX then
                    NX = true
                    WX = 0
                    if uiElements.tuyulStatus then
                        uiElements.tuyulStatus.Text = "SPAM MODE AKTIF!"
                        uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
                    end
                    if uiElements.LogIsi then uiElements.LogIsi.Text = "👻 SPAM MODE" end
                end
            end
            
            task.wait(1)
            if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end
            if uiElements.LogIsi then uiElements.LogIsi.Text = "-" end
        end
    end
    
    task.wait(0.5)
    LX = false
end

-- ==============================================
-- LOAD DATABASE DARI GITHUB
-- ==============================================

task.spawn(function()
    local categoryUrls = {
        IF = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/IF.txt",
        X = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/X.txt",
        NG = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/NG.txt",
        AI = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/AI.txt",
        ["SEMUA KATA SULIT"] = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/sulit.txt",
        CY = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/CY.txt",
        UI = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/UI.txt",
        KS = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/KS.txt",
        LY = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/ly.txt",
        GY = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/gy.txt",
        LT = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/lt.txt",
        EO = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/eo.txt",
        OE = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/oe.txt",
        EKS = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/eks.txt",
        OO = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/oo.txt",
        KN = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/kn.txt",
        Q = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/q.txt",
        MP = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/mp.txt",
        SF = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/sf.txt",
        TT = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/tt.txt"
    }
    
    for cat, url in pairs(categoryUrls) do
        task.spawn(function()
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            
            if success and type(response) == "string" then
                for word in string.gmatch(response, "[^\r\n]+") do
                    local cleanWord = (word:gsub("%s+", "")):lower()
                    if #cleanWord > 1 and string.match(cleanWord, "^%a+$") then
                        table.insert(dropData[cat], cleanWord)
                    end
                end
                print("🔥 Category " .. cat .. " Loaded!")
            end
        end)
    end
end)

task.spawn(function()
    local url = "https://raw.githubusercontent.com/DexterHUB99/Cari-Kata/refs/heads/main/kamus.txt"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and (type(response) == "string" and #response > 1000) then
        zX = {}
        
        for word in string.gmatch(response, "[^\r\n]+") do
            local cleanWord = (word:gsub("%s+", "")):lower()
            if #cleanWord > 1 and string.match(cleanWord, "^%a+$") then
                table.insert(zX, cleanWord)
            end
        end
        
        for i = #zX, 2, -1 do
            local j = math.random(i)
            zX[i], zX[j] = zX[j], zX[i]
        end
        
        print("🔥 R4NzDev: " .. #zX .. " kata dari kamus utama berhasil dimuat!")
    else
        print("⚠️ Gagal memuat kamus utama, menggunakan database bawaan.")
    end
end)

-- ==============================================
-- EVENT DETECTOR DARI GAME
-- ==============================================

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:FindFirstChild("Remotes")
if remotes then
    local matchUIRemote = remotes:FindFirstChild("MatchUI")
    if matchUIRemote then
        matchUIRemote.OnClientEvent:Connect(function(event)
            if not isRunning then return end
            
            if event == "StartTurn" or event == "YourTurn" then
                bX = false
                
                if not LX and not pX then
                    task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
                    gX()
                end
                
            elseif event == "Eliminated" or event == "EndMatch" or event == "HideMatchUI" then
                NX = false
                WX = 0
                qX = 0
                
                if tx and uiElements.tuyulStatus then
                    uiElements.tuyulStatus.Text = "Siap: 0/" .. JX .. " jawaban benar"
                    uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
                end
                
                if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end
                if uiElements.LogIsi then uiElements.LogIsi.Text = "-" end
                
                startInstantRejoin()
            end
        end)
    end
end

-- ==============================================
-- FUNGSI AUTO REJOIN
-- ==============================================

function dismissEndScreen()
    pcall(function()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, false, game, 0)
    end)
end

function startInstantRejoin()
    if not autoRejoinEnabled or bX then return end
    
    bX = true
    task.wait(1)
    dismissEndScreen()
    
    task.spawn(function()
        local playerGui = player:WaitForChild("PlayerGui")
        
        while bX and isRunning do
            if not autoRejoinEnabled then
                bX = false
                break
            end
            
            local matchUI = playerGui:FindFirstChild("MatchUI", true)
            if matchUI and matchUI.Enabled == true then
                bX = false
                if autoTulisEnabled then
                    task.wait(1.5)
                    gX()
                end
                break
            end
            
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.02)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
            
            task.wait(0.15)
        end
    end)
end

-- Membuat toggle di halaman MAIN
createToggle("AUTO TULIS", mainPage, false, function(val) 
    autoTulisEnabled = val 
    if autoTulisEnabled then 
        task.wait(0.3) 
        gX() 
    end 
end, 1)

createToggle("AUTO REJOIN", mainPage, true, function(val) 
    autoRejoinEnabled = val 
end, 3)

createCompactSpeedPanel(mainPage, 31)

createToggle("🕠 MANUSIA [FIX]", mainPage, false, function(val) 
    Sx = val 
end, 32)

createToggle("👻 MODE TUYUL", mainPage, false, function(val) 
    tx = val 
    if not val then
        NX = false
        qX = 0
        WX = 0
    end
end, 33)

-- Panel peringatan
local warningPanel = Instance.new("Frame")
warningPanel.Size = UDim2.new(1, -4, 0, 0)
warningPanel.AutomaticSize = Enum.AutomaticSize.Y
warningPanel.LayoutOrder = 34
warningPanel.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
warningPanel.BorderSizePixel = 0
warningPanel.Parent = mainPage
Instance.new("UICorner", warningPanel).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", warningPanel).Color = Color3.fromRGB(180, 40, 40)

local warningPad = Instance.new("UIPadding", warningPanel)
warningPad.PaddingLeft = UDim.new(0, 10)
warningPad.PaddingRight = UDim.new(0, 10)
warningPad.PaddingTop = UDim.new(0, 8)
warningPad.PaddingBottom = UDim.new(0, 8)

local warningLayout = Instance.new("UIListLayout", warningPanel)
warningLayout.Padding = UDim.new(0, 4)
warningLayout.SortOrder = Enum.SortOrder.LayoutOrder

local warningText1 = Instance.new("TextLabel")
warningText1.Size = UDim2.new(1, 0, 0, 0)
warningText1.AutomaticSize = Enum.AutomaticSize.Y
warningText1.LayoutOrder = 1
warningText1.BackgroundTransparency = 1
warningText1.Text = "⚜️  WAJIB MATIKAN AUTO TULIS"
warningText1.TextColor3 = Color3.fromRGB(255, 80, 80)
warningText1.Font = Enum.Font.GothamBold
warningText1.TextSize = isTouch and 9 or 10
warningText1.TextXAlignment = Enum.TextXAlignment.Left
warningText1.TextWrapped = true
warningText1.Parent = warningPanel

local warningText2 = Instance.new("TextLabel")
warningText2.Size = UDim2.new(1, 0, 0, 0)
warningText2.AutomaticSize = Enum.AutomaticSize.Y
warningText2.LayoutOrder = 2
warningText2.BackgroundTransparency = 1
warningText2.Text = "⚜️  Hati-hati! Fitur ini gampang kena banned."
warningText2.TextColor3 = Color3.fromRGB(255, 140, 50)
warningText2.Font = Enum.Font.GothamBold
warningText2.TextSize = isTouch and 9 or 10
warningText2.TextXAlignment = Enum.TextXAlignment.Left
warningText2.TextWrapped = true
warningText2.Parent = warningPanel

local warningText3 = Instance.new("TextLabel")
warningText3.Size = UDim2.new(1, 0, 0, 0)
warningText3.AutomaticSize = Enum.AutomaticSize.Y
warningText3.LayoutOrder = 3
warningText3.BackgroundTransparency = 1
warningText3.Text = "🕡  Auto answer akan menjawab sesuai database kata"
warningText3.TextColor3 = Color3.fromRGB(160, 200, 160)
warningText3.Font = Enum.Font.Gotham
warningText3.TextSize = isTouch and 9 or 10
warningText3.TextXAlignment = Enum.TextXAlignment.Left
warningText3.TextWrapped = true
warningText3.Parent = warningPanel

-- Tombol dropdown
local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
dropBtn.LayoutOrder = 4
dropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
dropBtn.Text = "⪼  SET KATA SULIT ⪼"
dropBtn.TextColor3 = Color3.new(1, 1, 1)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = TEXT_SIZE_SMALL
dropBtn.Parent = mainPage
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 9)

local dropBtnGrad = Instance.new("UIGradient", dropBtn)
dropBtnGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120)) })

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.new(1, -4, 0, 0)
dropFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
dropFrame.ClipsDescendants = true
dropFrame.BorderSizePixel = 0
dropFrame.Parent = mainPage
dropFrame.LayoutOrder = 5

local dropStroke = Instance.new("UIStroke", dropFrame)
dropStroke.Color = Color3.fromRGB(80, 35, 160)
dropStroke.Thickness = 1
dropStroke.Transparency = 0.3

uiElements.DropMainBtn = dropBtn
uiElements.dropBtnGrad = dropBtnGrad
uiElements.dropStroke = dropStroke
uiElements.ScrollBar = mainPage

local itemHeight = isTouch and 37 or 33

function refreshDropUI()
    for i, child in pairs(dropFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local categories = { "IF", "X", "NG", "AI", "KS", "CY", "UI", "LY", "GY", "LT", "EO", "OE", "EKS", "OO", "KN", "Q", "MP", "SF", "TT", "SEMUA KATA SULIT" }

    for i, cat in ipairs(categories) do
        local catBtn = Instance.new("TextButton")
        catBtn.Size = UDim2.new(1, -12, 0, isTouch and 32 or 28)
        catBtn.Position = UDim2.new(0, 6, 0, (i - 1) * itemHeight + 5)

        local isAllSelected = dropState["SEMUA KATA SULIT"] and cat ~= "SEMUA KATA SULIT"
        local isSelected = dropState[cat]

        catBtn.BackgroundColor3 = isAllSelected and Color3.fromRGB(25, 22, 36) or isSelected and Color3.fromRGB(80, 30, 170) or Color3.fromRGB(28, 25, 42)
        catBtn.Text = (isSelected and "✔  " or "   ") .. (cat .. (isSelected and "  [ON]" or ""))
        catBtn.TextColor3 = isAllSelected and Color3.fromRGB(70, 65, 90) or isSelected and Color3.new(1, 1, 1) or Color3.fromRGB(160, 150, 190)
        catBtn.Font = Enum.Font.GothamBold
        catBtn.TextSize = TEXT_SIZE_SMALL
        catBtn.TextXAlignment = Enum.TextXAlignment.Left
        catBtn.Parent = dropFrame
        Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 7)

        local catPad = Instance.new("UIPadding", catBtn)
        catPad.PaddingLeft = UDim.new(0, 8)

        if isSelected then
            local catStroke = Instance.new("UIStroke", catBtn)
            catStroke.Color = Color3.fromRGB(130, 70, 220)
            catStroke.Thickness = 1
            catStroke.Transparency = 0.2
        end

        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0, 60, 1, 0)
        countLabel.Position = UDim2.new(1, -64, 0, 0)
        countLabel.BackgroundTransparency = 1
        local count = #(dropData[cat] or {})
        countLabel.Text = count > 0 and count .. " kata" or "loading..."
        countLabel.TextColor3 = isAllSelected and Color3.fromRGB(60, 55, 80) or Color3.fromRGB(120, 100, 180)
        countLabel.Font = Enum.Font.Gotham
        countLabel.TextSize = isTouch and 8 or 9
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.ZIndex = catBtn.ZIndex + 1
        countLabel.Parent = catBtn

        catBtn.MouseButton1Click:Connect(function()
            if isAllSelected then return end
            playClickSound()
            if cat == "SEMUA KATA SULIT" then
                dropState["SEMUA KATA SULIT"] = not dropState["SEMUA KATA SULIT"]
                if dropState["SEMUA KATA SULIT"] then
                    dropState.IF = false
                    dropState.X = false
                    dropState.NG = false
                    dropState.AI = false
                    dropState.KS = false
                    dropState.CY = false
                    dropState.UI = false
                    dropState.LY = false
                    dropState.GY = false
                    dropState.LT = false
                    dropState.EO = false
                    dropState.OE = false
                    dropState.EKS = false
                    dropState.OO = false
                    dropState.KN = false
                    dropState.Q = false
                    dropState.MP = false
                    dropState.SF = false
                    dropState.TT = false
                end
            else
                dropState[cat] = not dropState[cat]
            end
            refreshDropUI()
        end)
    end
end

local isDropOpen = false

dropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isDropOpen = not isDropOpen
    dropBtn.Text = isDropOpen and "⪼  SET KATA SULIT ⪻" or "⪼  SET KATA SULIT ⪼"
    dropFrame:TweenSize(UDim2.new(1, -4, 0, isDropOpen and 20 * itemHeight + 10 or 0), "Out", "Quart", 0.3, true)
    refreshDropUI()
end)

-- Frame log
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -4, 0, isTouch and 55 or 50)
logFrame.LayoutOrder = 10
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainPage
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 9)

local logStroke = Instance.new("UIStroke", logFrame)
logStroke.Color = Color3.fromRGB(80, 40, 140)
logStroke.Thickness = 1
logStroke.Transparency = 0.4
uiElements.logStroke = logStroke

local logAwalan = Instance.new("TextLabel")
logAwalan.Size = UDim2.new(1, -12, 0, 22)
logAwalan.Position = UDim2.new(0, 8, 0, 4)
logAwalan.BackgroundTransparency = 1
logAwalan.Text = "AWALAN: -"
logAwalan.TextColor3 = Color3.fromRGB(160, 100, 255)
logAwalan.Font = Enum.Font.GothamBold
logAwalan.TextSize = isTouch and 10 or 11
logAwalan.TextXAlignment = Enum.TextXAlignment.Left
logAwalan.Parent = logFrame
uiElements.LogAwalan = logAwalan

local logIsi = Instance.new("TextLabel")
logIsi.Size = UDim2.new(1, -12, 0, 24)
logIsi.Position = UDim2.new(0, 8, 0, 26)
logIsi.BackgroundTransparency = 1
logIsi.Text = "-"
logIsi.TextColor3 = Color3.fromRGB(230, 230, 255)
logIsi.Font = Enum.Font.GothamBold
logIsi.TextSize = isTouch and 14 or 16
logIsi.TextXAlignment = Enum.TextXAlignment.Left
logIsi.Parent = logFrame
uiElements.LogIsi = logIsi

-- ==============================================
-- HALAMAN UTIL
-- ==============================================

local utilPad = Instance.new("UIPadding", utilPage)
utilPad.PaddingLeft = UDim.new(0, 6)
utilPad.PaddingRight = UDim.new(0, 6)
utilPad.PaddingTop = UDim.new(0, 8)

-- Frame Anti Admin
local antiAdminFrame = Instance.new("Frame")
antiAdminFrame.Size = UDim2.new(1, 0, 0, isTouch and 80 or 90)
antiAdminFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
antiAdminFrame.BorderSizePixel = 0
antiAdminFrame.Parent = utilPage
Instance.new("UICorner", antiAdminFrame).CornerRadius = UDim.new(0, 12)

local aaStroke = Instance.new("UIStroke", antiAdminFrame)
aaStroke.Color = Color3.fromRGB(90, 40, 180)
aaStroke.Thickness = 1.5
aaStroke.Transparency = 0.2

local aaTitle = Instance.new("TextLabel")
aaTitle.Size = UDim2.new(1, -24, 0, 20)
aaTitle.Position = UDim2.new(0, 12, 0, 8)
aaTitle.BackgroundTransparency = 1
aaTitle.Text = "🛡️ ANTI ADMIN"
aaTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
aaTitle.Font = Enum.Font.GothamBold
aaTitle.TextSize = isTouch and 11 or 12
aaTitle.TextXAlignment = Enum.TextXAlignment.Left
aaTitle.Parent = antiAdminFrame

local aaDesc = Instance.new("TextLabel")
aaDesc.Size = UDim2.new(1, -24, 0, 40)
aaDesc.Position = UDim2.new(0, 12, 0, 32)
aaDesc.BackgroundTransparency = 1
aaDesc.Text = "Auto keluar game jika ada admin yang join. Daftar admin akan diupdate secara berkala."
aaDesc.TextColor3 = Color3.fromRGB(170, 155, 200)
aaDesc.Font = Enum.Font.Gotham
aaDesc.TextSize = isTouch and 9 or 10
aaDesc.TextWrapped = true
aaDesc.TextXAlignment = Enum.TextXAlignment.Left
aaDesc.Parent = antiAdminFrame

local aaToggle = createToggle("AKTIFKAN ANTI ADMIN", antiAdminFrame, false, function(val) end, 1)
aaToggle.Position = UDim2.new(0, 12, 0, 72)
aaToggle.Size = UDim2.new(1, -24, 0, TOGGLE_HEIGHT)

-- Frame Tuyul Mode
local tuyulFrame = Instance.new("Frame")
tuyulFrame.Size = UDim2.new(1, 0, 0, isTouch and 120 or 130)
tuyulFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
tuyulFrame.BorderSizePixel = 0
tuyulFrame.Parent = utilPage
Instance.new("UICorner", tuyulFrame).CornerRadius = UDim.new(0, 12)

local tuyulStroke = Instance.new("UIStroke", tuyulFrame)
tuyulStroke.Color = Color3.fromRGB(90, 40, 180)
tuyulStroke.Thickness = 1.5
tuyulStroke.Transparency = 0.2
uiElements.tuyulStroke = tuyulStroke

local tuyulHeader = Instance.new("TextLabel")
tuyulHeader.Size = UDim2.new(1, -24, 0, 20)
tuyulHeader.Position = UDim2.new(0, 12, 0, 8)
tuyulHeader.BackgroundTransparency = 1
tuyulHeader.Text = "👻 MODE TUYUL"
tuyulHeader.TextColor3 = Color3.fromRGB(150, 80, 255)
tuyulHeader.Font = Enum.Font.GothamBold
tuyulHeader.TextSize = isTouch and 11 or 12
tuyulHeader.TextXAlignment = Enum.TextXAlignment.Left
tuyulHeader.Parent = tuyulFrame
uiElements.tuyulHeader = tuyulHeader

local tuyulDesc = Instance.new("TextLabel")
tuyulDesc.Size = UDim2.new(1, -24, 0, 32)
tuyulDesc.Position = UDim2.new(0, 12, 0, 32)
tuyulDesc.BackgroundTransparency = 1
tuyulDesc.Text = "Auto mengalah saat semua tujuan tercapai. Cocok untuk farming."
tuyulDesc.TextColor3 = Color3.fromRGB(170, 155, 200)
tuyulDesc.Font = Enum.Font.Gotham
tuyulDesc.TextSize = isTouch and 9 or 10
tuyulDesc.TextWrapped = true
tuyulDesc.TextXAlignment = Enum.TextXAlignment.Left
tuyulDesc.Parent = tuyulFrame

local tuyulStatus = Instance.new("TextLabel")
tuyulStatus.Size = UDim2.new(0.5, -12, 0, 24)
tuyulStatus.Position = UDim2.new(0, 12, 0, 68)
tuyulStatus.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
tuyulStatus.Text = "STATUS: OFF"
tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
tuyulStatus.Font = Enum.Font.GothamBold
tuyulStatus.TextSize = isTouch and 10 or 11
tuyulStatus.Parent = tuyulFrame
Instance.new("UICorner", tuyulStatus).CornerRadius = UDim.new(0, 6)
uiElements.tuyulStatus = tuyulStatus

local tuyulToggle = createToggle("AKTIFKAN TUYUL", tuyulFrame, false, function(val) 
    tx = val
    if val then
        tuyulStatus.Text = "STATUS: ON"
        tuyulStatus.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        tuyulStatus.Text = "STATUS: OFF"
        tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        NX = false
        qX = 0
        WX = 0
    end
end, 2)
tuyulToggle.Position = UDim2.new(0.5, 6, 0, 68)
tuyulToggle.Size = UDim2.new(0.5, -18, 0, TOGGLE_HEIGHT)

-- ==============================================
-- HALAMAN LOG PERMAINAN (di UTIL)
-- ==============================================

local logGameFrame = Instance.new("Frame")
logGameFrame.Size = UDim2.new(1, 0, 0, isTouch and 300 or 320)
logGameFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
logGameFrame.BorderSizePixel = 0
logGameFrame.Parent = utilPage
Instance.new("UICorner", logGameFrame).CornerRadius = UDim.new(0, 12)

local logGameStroke = Instance.new("UIStroke", logGameFrame)
logGameStroke.Color = Color3.fromRGB(90, 40, 180)
logGameStroke.Thickness = 1.5
logGameStroke.Transparency = 0.2

local logGameTitle = Instance.new("TextLabel")
logGameTitle.Size = UDim2.new(1, -24, 0, 20)
logGameTitle.Position = UDim2.new(0, 12, 0, 8)
logGameTitle.BackgroundTransparency = 1
logGameTitle.Text = "📋 LOG PERMAINAN"
logGameTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
logGameTitle.Font = Enum.Font.GothamBold
logGameTitle.TextSize = isTouch and 11 or 12
logGameTitle.TextXAlignment = Enum.TextXAlignment.Left
logGameTitle.Parent = logGameFrame

local buttonY = 32
local buttonWidth = 70

-- Tombol Copy Current Match
local copyCurrentBtn = Instance.new("TextButton")
copyCurrentBtn.Size = UDim2.new(0, buttonWidth, 0, 24)
copyCurrentBtn.Position = UDim2.new(0, 12, 0, buttonY)
copyCurrentBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
copyCurrentBtn.Text = "COPY"
copyCurrentBtn.TextColor3 = Color3.new(1, 1, 1)
copyCurrentBtn.Font = Enum.Font.GothamBold
copyCurrentBtn.TextSize = 9
copyCurrentBtn.Parent = logGameFrame
Instance.new("UICorner", copyCurrentBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Copy All Matches
local copyAllBtn = Instance.new("TextButton")
copyAllBtn.Size = UDim2.new(0, buttonWidth, 0, 24)
copyAllBtn.Position = UDim2.new(0, buttonWidth + 17, 0, buttonY)
copyAllBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 200)
copyAllBtn.Text = "COPY ALL"
copyAllBtn.TextColor3 = Color3.new(1, 1, 1)
copyAllBtn.Font = Enum.Font.GothamBold
copyAllBtn.TextSize = 9
copyAllBtn.Parent = logGameFrame
Instance.new("UICorner", copyAllBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Delete Current Match
local deleteCurrentBtn = Instance.new("TextButton")
deleteCurrentBtn.Size = UDim2.new(0, buttonWidth, 0, 24)
deleteCurrentBtn.Position = UDim2.new(0, (buttonWidth + 17) * 2, 0, buttonY)
deleteCurrentBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
deleteCurrentBtn.Text = "DELETE"
deleteCurrentBtn.TextColor3 = Color3.new(1, 1, 1)
deleteCurrentBtn.Font = Enum.Font.GothamBold
deleteCurrentBtn.TextSize = 9
deleteCurrentBtn.Parent = logGameFrame
Instance.new("UICorner", deleteCurrentBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Delete All Matches
local deleteAllBtn = Instance.new("TextButton")
deleteAllBtn.Size = UDim2.new(0, buttonWidth, 0, 24)
deleteAllBtn.Position = UDim2.new(0, (buttonWidth + 17) * 3, 0, buttonY)
deleteAllBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
deleteAllBtn.Text = "DELETE ALL"
deleteAllBtn.TextColor3 = Color3.new(1, 1, 1)
deleteAllBtn.Font = Enum.Font.GothamBold
deleteAllBtn.TextSize = 9
deleteAllBtn.Parent = logGameFrame
Instance.new("UICorner", deleteAllBtn).CornerRadius = UDim.new(0, 6)

-- Notifikasi
local logNotif = Instance.new("TextLabel")
logNotif.Size = UDim2.new(1, -24, 0, 20)
logNotif.Position = UDim2.new(0, 12, 0, buttonY + 28)
logNotif.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
logNotif.Text = ""
logNotif.TextColor3 = Color3.new(1, 1, 1)
logNotif.Font = Enum.Font.GothamBold
logNotif.TextSize = 10
logNotif.Visible = false
logNotif.Parent = logGameFrame
Instance.new("UICorner", logNotif).CornerRadius = UDim.new(0, 6)

-- Scrolling Frame untuk log
local logScrollingFrame = Instance.new("ScrollingFrame")
logScrollingFrame.Size = UDim2.new(1, -24, 1, -(buttonY + 58))
logScrollingFrame.Position = UDim2.new(0, 12, 0, buttonY + 58)
logScrollingFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
logScrollingFrame.BorderSizePixel = 0
logScrollingFrame.ScrollBarThickness = 4
logScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
logScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logScrollingFrame.Parent = logGameFrame
Instance.new("UICorner", logScrollingFrame).CornerRadius = UDim.new(0, 6)

-- Hubungkan tombol
copyCurrentBtn.MouseButton1Click:Connect(function()
    playClickSound()
    copyToClipboard("current")
end)

copyAllBtn.MouseButton1Click:Connect(function()
    playClickSound()
    copyToClipboard("all")
end)

deleteCurrentBtn.MouseButton1Click:Connect(function()
    playClickSound()
    deleteLogs("current")
end)

deleteAllBtn.MouseButton1Click:Connect(function()
    playClickSound()
    deleteLogs("all")
end)

-- ==============================================
-- TEMA WARNA (DIPINDAHKAN KE MAIN PAGE)
-- ==============================================

-- Dropdown tema warna (sekarang di MAIN page)
local themeDropBtn = Instance.new("TextButton")
themeDropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
themeDropBtn.LayoutOrder = 35  -- Letakkan setelah mode tuyul
themeDropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
themeDropBtn.Text = "🎨 PILIH TEMA WARNA"
themeDropBtn.TextColor3 = Color3.new(1, 1, 1)
themeDropBtn.Font = Enum.Font.GothamBold
themeDropBtn.TextSize = TEXT_SIZE_SMALL
themeDropBtn.Parent = mainPage  -- PINDAHKAN KE MAIN PAGE
Instance.new("UICorner", themeDropBtn).CornerRadius = UDim.new(0, 9)

local themeDropGrad = Instance.new("UIGradient", themeDropBtn)
themeDropGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120)) })
uiElements.SkinDropBtn = themeDropBtn
uiElements.SkinDropGrad = themeDropGrad

local themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(1, -4, 0, 0)
themeFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
themeFrame.ClipsDescendants = true
themeFrame.BorderSizePixel = 0
themeFrame.Parent = mainPage  -- PINDAHKAN KE MAIN PAGE
themeFrame.LayoutOrder = 36

local themeStroke = Instance.new("UIStroke", themeFrame)
themeStroke.Color = Color3.fromRGB(80, 35, 160)
themeStroke.Thickness = 1
themeStroke.Transparency = 0.3
uiElements.SkinDropStroke = themeStroke

local themeItemHeight = isTouch and 32 or 28
local isThemeOpen = false

local themes_list = { "CYBERPUNK", "CRIMSON", "MATRIX", "SAKURA", "OCEAN", "FLAME" }

function refreshThemeUI()
    for i, child in pairs(themeFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for i, themeName in ipairs(themes_list) do
        local themeBtn = Instance.new("TextButton")
        themeBtn.Size = UDim2.new(1, -12, 0, themeItemHeight)
        themeBtn.Position = UDim2.new(0, 6, 0, (i - 1) * (themeItemHeight + 2) + 5)

        local isActive = (currentTheme == themeName)
        themeBtn.BackgroundColor3 = isActive and Color3.fromRGB(80, 30, 170) or Color3.fromRGB(28, 25, 42)
        themeBtn.Text = (isActive and "✔ " or "   ") .. themeName
        themeBtn.TextColor3 = isActive and Color3.new(1, 1, 1) or Color3.fromRGB(160, 150, 190)
        themeBtn.Font = Enum.Font.GothamBold
        themeBtn.TextSize = TEXT_SIZE_SMALL
        themeBtn.TextXAlignment = Enum.TextXAlignment.Left
        themeBtn.Parent = themeFrame
        Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 7)

        local themePad = Instance.new("UIPadding", themeBtn)
        themePad.PaddingLeft = UDim.new(0, 8)

        if isActive then
            local activeStroke = Instance.new("UIStroke", themeBtn)
            activeStroke.Color = Color3.fromRGB(130, 70, 220)
            activeStroke.Thickness = 1
            activeStroke.Transparency = 0.2
        end

        local colorPreview = Instance.new("Frame")
        colorPreview.Size = UDim2.new(0, 16, 0, 16)
        colorPreview.Position = UDim2.new(1, -24, 0.5, -8)
        colorPreview.BackgroundColor3 = themes[themeName].primary
        colorPreview.BorderSizePixel = 0
        colorPreview.Parent = themeBtn
        Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(1, 0)

        themeBtn.MouseButton1Click:Connect(function()
            playClickSound()
            applyTheme(themeName)
            refreshThemeUI()
        end)
    end
end

themeDropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isThemeOpen = not isThemeOpen
    themeDropBtn.Text = isThemeOpen and "🎨 PILIH TEMA WARNA ▼" or "🎨 PILIH TEMA WARNA ▶"
    themeFrame:TweenSize(UDim2.new(1, -4, 0, isThemeOpen and (#themes_list * (themeItemHeight + 2) + 10) or 0), "Out", "Quart", 0.3, true)
    refreshThemeUI()
end)

applyTheme("CYBERPUNK")

-- Hubungkan tombol close
closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if _G[scriptKey] then
        _G[scriptKey]()
    end
end)

-- ==============================================
-- FITUR DRAG WINDOW (GESER GUI)
-- ==============================================

local isDragging = false
local dragInput, dragStart, dragPosition

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        dragPosition = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end

local function updateDrag(input)
    if not isDragging then return end
    
    local delta = input.Position - dragStart
    local newX = dragPosition.X.Offset + delta.X
    local newY = dragPosition.Y.Offset + delta.Y
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = mainFrame.AbsoluteSize
    
    newX = math.clamp(newX, 10, viewportSize.X - frameSize.X - 10)
    newY = math.clamp(newY, 10, viewportSize.Y - frameSize.Y - 10)
    
    mainFrame.Position = UDim2.new(0, newX, 0, newY)
    syncGlowWrapper()
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

miniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMini = true
        dragStart = input.Position
        dragPosition = miniIcon.Position
    end
end)

miniIcon.InputChanged:Connect(function(input)
    if not isDraggingMini then return end
    
    local delta = input.Position - dragStart
    local newX = dragPosition.X.Offset + delta.X
    local newY = dragPosition.Y.Offset + delta.Y
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local iconSize = miniIcon.AbsoluteSize
    
    newX = math.clamp(newX, 10, viewportSize.X - iconSize.X - 10)
    newY = math.clamp(newY, 10, viewportSize.Y - iconSize.Y - 10)
    
    miniIcon.Position = UDim2.new(0, newX, 0, newY)
end)

miniIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMini = false
    end
end)

print("✅ Fitur Drag Window telah diaktifkan!")

-- ==============================================
-- RESIZE WINDOW
-- ==============================================
UserInputService.InputChanged:Connect(function(input, processed)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        local newWidth = math.max(startWidth + delta.X, isTouch and 260 or 300)
        local newHeight = math.max(startHeight + delta.Y, isTouch and 200 or 230)
        newWidth, newHeight = clampWindow(newWidth, newHeight)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        syncGlowWrapper()
    end
end)

-- ==============================================
-- NOTIFIKASI SUKSES
-- ==============================================
print("✅ R4NzDev v2.0 berhasil dimuat!")
print("🔹 Tekan tombol minimize (⛎) untuk menyembunyikan GUI")
print("🔹 Tekan ikon kecil untuk membuka kembali")
print("🔥 Fitur Auto Answer siap digunakan!")
print("📚 Database kata: " .. #zX .. " kata siap pakai")
print("📋 Fitur Log per Match dengan COPY & DELETE telah aktif!")