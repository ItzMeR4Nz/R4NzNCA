local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
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

-- Fungsi mengaplikasikan tema
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
    if uiElements.ResizeHandle then uiElements.ResizeHandle.BackgroundColor3 = theme.mid end
    if uiElements.ResizeStroke then uiElements.ResizeStroke.Color = theme.accent end
    if uiElements.themeBtnStroke then uiElements.themeBtnStroke.Color = theme.accent end
    if uiElements.themeDFStroke then uiElements.themeDFStroke.Color = theme.mid end
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
uiElements.GlowWrapper = glowFrame

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

-- Resize logic
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
uiElements.Header = header

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0.5, 0)
headerCover.Position = UDim2.new(0, 0, 0.5, 0)
headerCover.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
headerCover.BorderSizePixel = 0
headerCover.Parent = header
headerCover.ZIndex = header.ZIndex - 1
uiElements.HeaderCover = headerCover

local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 220)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 15, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 10, 100))
})
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
lineGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255))
})
uiElements.LineGrad = lineGrad

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
local isDraggingMini = false
local dragStartPos, dragStartPosIcon

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
uiElements.SideDivider = sideDivider

local divGrad = Instance.new("UIGradient", sideDivider)
divGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 30, 140)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 60, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 140))
})
divGrad.Rotation = 90
uiElements.DivGrad = divGrad

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, isTouch and 4 or 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, isTouch and 8 or 12)
sidePad.PaddingLeft = UDim.new(0, isTouch and 4 or 7)
sidePad.PaddingRight = UDim.new(0, isTouch and 4 or 7)

-- Tombol tab (hanya MAIN)
local tabButtons = {}

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
    for i, tab in ipairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(120, 110, 150)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
    end

    local theme = themes[currentTheme] and themes[currentTheme].activeTab or Color3.fromRGB(65, 20, 150)
    local accent = themes[currentTheme] and themes[currentTheme].accent or Color3.fromRGB(150, 80, 255)
    activeBtn.BackgroundColor3 = theme
    activeBtn.TextColor3 = Color3.new(1, 1, 1)

    for i, tab in ipairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = accent
            tab.stroke.Transparency = 0.1
        end
    end
end

-- Hanya buat satu tab (MAIN)
local tabMain = createTabBtn("MAIN", "⚡", 1)
setActiveTab(tabMain)

-- Area konten utama
local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX + 4), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Halaman MAIN
local mainPage = Instance.new("ScrollingFrame")
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.Visible = true
mainPage.ScrollBarThickness = isTouch and 3 or 2
mainPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
mainPage.ScrollBarImageTransparency = 0
mainPage.ScrollingDirection = Enum.ScrollingDirection.Y
mainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainPage.Parent = contentFrame
uiElements.ScrollBar = mainPage

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, isTouch and 5 or 7)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainPage

local mainPad = Instance.new("UIPadding", mainPage)
mainPad.PaddingLeft = UDim.new(0, 5)
mainPad.PaddingRight = UDim.new(0, 5)
mainPad.PaddingTop = UDim.new(0, 5)
mainPad.PaddingBottom = UDim.new(0, 10)

-- Variabel untuk fitur
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
local kataRandom = { "wkwk", "receh", "noob", "lemah", "kasian", "santuy", "ezz", "wkwk", "lol", "mudah" }
local dropData = { IF = {}, X = {}, NG = {}, AI = {}, KS = {}, CY = {}, UI = {}, LY = {}, GY = {}, LT = {}, EO = {}, OE = {}, EKS = {}, OO = {}, KN = {}, Q = {}, MP = {}, SF = {}, TT = {}, ["SEMUA KATA SULIT"] = {} }
local dropState = { IF = false, X = false, NG = false, AI = false, KS = false, CY = false, UI = false, LY = false, GY = false, LT = false, EO = false, OE = false, EKS = false, OO = false, KN = false, Q = false, MP = false, SF = false, TT = false, ["SEMUA KATA SULIT"] = false }

-- ===== FITUR AUTO TULIS DENGAN KAMUS =====
local wordList = {} -- Menyimpan daftar kata dari web
local isLoadingWords = false
local autoTulisCoroutine = nil

-- Fungsi untuk mengambil kata dari URL
function fetchWordList()
    local success, result = pcall(function()
        return HttpService:GetAsync("https://raw.githubusercontent.com/DexterHUB99/Cari-Kata/refs/heads/main/kamus.txt")
    end)
    
    if success and result then
        -- Split berdasarkan newline
        local words = {}
        for word in string.gmatch(result, "[^\r\n]+") do
            -- Hanya ambil kata dengan minimal 3 huruf
            if #word >= 3 then
                table.insert(words, word)
            end
        end
        wordList = words
        logIsi.Text = "Kamus dimuat: " .. #wordList .. " kata"
        print("✅ R4NzDev: Kamus dimuat dengan " .. #wordList .. " kata")
    else
        wordList = kataRandom -- Fallback ke kata random jika gagal
        logIsi.Text = "Gagal muat kamus, pakai default"
        print("⚠️ R4NzDev: Gagal muat kamus, pakai kata default")
    end
    isLoadingWords = false
end

-- Panggil fungsi untuk mengambil kata saat script dimuat
isLoadingWords = true
logIsi.Text = "Memuat kamus..."
task.spawn(fetchWordList)

-- Fungsi untuk mendapatkan kata acak dari daftar
function getRandomWord()
    if #wordList == 0 then
        -- Jika kamus kosong, ambil dari kataRandom
        return kataRandom[math.random(1, #kataRandom)]
    else
        return wordList[math.random(1, #wordList)]
    end
end

-- Fungsi untuk mengetik otomatis
function startAutoTulis()
    if autoTulisCoroutine then
        coroutine.close(autoTulisCoroutine)
        autoTulisCoroutine = nil
    end
    
    autoTulisCoroutine = coroutine.create(function()
        while autoTulisEnabled and isRunning do
            -- Cek apakah chat box terbuka (biasanya dengan menekan Enter)
            -- Di Roblox, kita bisa mensimulasikan menekan tombol "/" untuk membuka chat
            -- Tapi untuk mempermudah, kita akan langsung mengetik di chat box yang aktif
            
            -- Cari TextBox yang aktif (chat box)
            local chatBox = nil
            for _, v in ipairs(player.PlayerGui:GetDescendants()) do
                if v:IsA("TextBox") and v.Visible and v:IsFocused() then
                    chatBox = v
                    break
                end
            end
            
            if chatBox then
                -- Dapatkan kata acak
                local wordToType = getRandomWord()
                logAwalan.Text = "MENGIRIM:"
                logIsi.Text = wordToType
                
                -- Ketik kata
                for i = 1, #wordToType do
                    local char = wordToType:sub(i, i)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[char:upper()], false, nil)
                    task.wait(delayMin + math.random() * (delayMax - delayMin))
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[char:upper()], false, nil)
                    task.wait(delayMin + math.random() * (delayMax - delayMin))
                end
                
                -- Tekan Enter untuk mengirim
                task.wait(holdDelay)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                task.wait(deleteDelay)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                
                -- Tunggu interval sebelum mengetik lagi
                task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
            else
                -- Jika chat box tidak aktif, tunggu sebentar
                task.wait(1)
            end
        end
        autoTulisCoroutine = nil
    end)
    
    coroutine.resume(autoTulisCoroutine)
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

-- Fungsi membuat panel speed
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

    local sliderItemHeight = isTouch and 16 or 11
    local knobSize = isTouch and 20 or 12

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
        label.TextSize = isTouch and 8 or 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame

        local formatStr = "%." .. (s.dec .. "f")
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 90, 0, 14)
        valueLabel.Position = UDim2.new(1, -94, 0, 4)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = isTouch and 8 or 9
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame

        local minVal, maxVal = s.defMin, s.defMax

        function updateValueLabel()
            valueLabel.Text = string.format(formatStr, minVal) .. " ~ " .. (string.format(formatStr, maxVal) .. s.suffix)
            local theme = themes[currentTheme]
            valueLabel.TextColor3 = theme and theme.logText or Color3.fromRGB(150, 100, 255)
        end
        updateValueLabel()

        local barHeight = isTouch and 32 or 26
        local barPad = isTouch and 6 or 4
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
        knobMinStroke.Thickness = 1.5

        local knobMax = Instance.new("Frame")
        knobMax.Size = UDim2.new(0, knobSize, 0, knobSize)
        knobMax.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
        knobMax.BorderSizePixel = 0
        knobMax.ZIndex = 3
        knobMax.Parent = barFrame
        Instance.new("UICorner", knobMax).CornerRadius = UDim.new(1, 0)

        local knobMaxStroke = Instance.new("UIStroke", knobMax)
        knobMaxStroke.Color = Color3.fromRGB(200, 150, 255)
        knobMaxStroke.Thickness = 1.5

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

        local hitbox = Instance.new("TextButton")
        hitbox.Size = UDim2.new(1, 0, 0, knobSize * 2)
        hitbox.Position = UDim2.new(0, 0, 0.5, -knobSize)
        hitbox.BackgroundTransparency = 1
        hitbox.Text = ""
        hitbox.ZIndex = 4
        hitbox.Parent = barFrame

        local isDraggingMin, isDraggingMax = false, false

        function getRatio(posX)
            local barPos = barFrame.AbsolutePosition.X
            local barSize = barFrame.AbsoluteSize.X
            return math.clamp((posX - barPos) / barSize, 0, 1)
        end

        function getValueFromRatio(ratio)
            return snapValue(s.min + ratio * (s.max - s.min))
        end

        hitbox.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local val = getValueFromRatio(getRatio(input.Position.X))
            if math.abs(val - minVal) <= math.abs(val - maxVal) then
                isDraggingMin = true
            else
                isDraggingMax = true
            end
        end)

        barFrame.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not (isDraggingMin or isDraggingMax) then return end

            local newVal = getValueFromRatio(getRatio(input.Position.X))
            local step = 1 / (10 ^ s.dec)

            if isDraggingMin then
                minVal = math.clamp(newVal, s.min, maxVal - step)
                s.cbMin(minVal)
            else
                maxVal = math.clamp(newVal, minVal + step, s.max)
                s.cbMax(maxVal)
            end
            updateVisual()
        end)

        barFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingMin = false
                isDraggingMax = false
            end
        end)

        table.insert(uiElements, { fill = fillBar, knobMinStroke = knobMinStroke, knobMaxStroke = knobMaxStroke, valLbl = valueLabel, knobMax = knobMax })
    end
    return panel
end

-- Buat toggle di halaman MAIN
createToggle("AUTO TULIS", mainPage, false, function(val) 
    autoTulisEnabled = val 
    if val then
        if #wordList == 0 and not isLoadingWords then
            logIsi.Text = "Memuat kamus..."
            task.spawn(fetchWordList)
            task.wait(1)
        end
        startAutoTulis()
    elseif autoTulisCoroutine then
        coroutine.close(autoTulisCoroutine)
        autoTulisCoroutine = nil
        logAwalan.Text = "AWALAN: -"
        logIsi.Text = "-"
    end
end, 1)

createToggle("AUTO REJOIN", mainPage, true, function(val) autoRejoinEnabled = val end, 3)
createCompactSpeedPanel(mainPage, 31)
createToggle("🕠 MANUSIA [FIX]", mainPage, false, function(val) autoManusiaEnabled = val end, 32)
createToggle("💰 BLATANT MODE", mainPage, false, function(val) end, 33)

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
warningText3.Text = "🕡  Tulis apa aja, tekan Enter — kata valid dikirim otomatis."
warningText3.TextColor3 = Color3.fromRGB(160, 200, 160)
warningText3.Font = Enum.Font.Gotham
warningText3.TextSize = isTouch and 9 or 10
warningText3.TextXAlignment = Enum.TextXAlignment.Left
warningText3.TextWrapped = true
warningText3.Parent = warningPanel

-- Tombol dropdown kata sulit
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
uiElements.DropMainBtn = dropBtn

local dropBtnGrad = Instance.new("UIGradient", dropBtn)
dropBtnGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120)) })
uiElements.dropBtnGrad = dropBtnGrad

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
uiElements.dropStroke = dropStroke

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

-- Drag window (hanya untuk PC)
if not isTouch then
    local isDragging = false
    local dragStart, dragStartPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            dragStartPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local delta = input.Position - dragStart
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
                if input.UserInputState == Enum.UserInputState.End then
                    isDraggingMini = false
                end
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

-- Resize window
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

-- Hubungkan tombol close
closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if _G[scriptKey] then
        _G[scriptKey]()
    end
end)

-- Terapkan tema awal
applyTheme("CYBERPUNK")

-- Notifikasi sukses
print("✅ R4NzDev v2.0 berhasil dimuat!")
print("🔹 Tekan tombol minimize (⛎) untuk menyembunyikan GUI")
print("🔹 Tekan ikon kecil untuk membuka kembali")