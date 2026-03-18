local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local scriptKey = "R4NzDev_v3_EKSTRIM"

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
        local gui = CoreGui.RobloxGui
        if gui then gui.Visible = false end
    end)
end)

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
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- =============================================
-- TEMA WARNA
-- =============================================
local themes = {
    CYBERPUNK = {
        primary = Color3.fromRGB(100, 30, 220), mid = Color3.fromRGB(65, 15, 160),
        dark = Color3.fromRGB(30, 10, 100), headerBg = Color3.fromRGB(55, 15, 120),
        accent = Color3.fromRGB(150, 80, 255), glow = Color3.fromRGB(100, 40, 200),
        activeTab = Color3.fromRGB(65, 20, 150), logText = Color3.fromRGB(160, 100, 255)
    },
    CRIMSON = {
        primary = Color3.fromRGB(200, 20, 40), mid = Color3.fromRGB(150, 15, 30),
        dark = Color3.fromRGB(80, 8, 16), headerBg = Color3.fromRGB(120, 10, 25),
        accent = Color3.fromRGB(255, 80, 100), glow = Color3.fromRGB(200, 30, 50),
        activeTab = Color3.fromRGB(160, 15, 35), logText = Color3.fromRGB(255, 100, 120)
    },
    MATRIX = {
        primary = Color3.fromRGB(0, 180, 60), mid = Color3.fromRGB(0, 130, 40),
        dark = Color3.fromRGB(0, 60, 20), headerBg = Color3.fromRGB(0, 80, 25),
        accent = Color3.fromRGB(50, 255, 120), glow = Color3.fromRGB(0, 160, 60),
        activeTab = Color3.fromRGB(0, 110, 40), logText = Color3.fromRGB(80, 255, 140)
    },
    SAKURA = {
        primary = Color3.fromRGB(210, 60, 140), mid = Color3.fromRGB(170, 40, 110),
        dark = Color3.fromRGB(100, 20, 65), headerBg = Color3.fromRGB(130, 30, 85),
        accent = Color3.fromRGB(255, 130, 200), glow = Color3.fromRGB(210, 70, 150),
        activeTab = Color3.fromRGB(160, 40, 110), logText = Color3.fromRGB(255, 150, 210)
    },
    OCEAN = {
        primary = Color3.fromRGB(0, 100, 220), mid = Color3.fromRGB(0, 70, 170),
        dark = Color3.fromRGB(0, 35, 100), headerBg = Color3.fromRGB(0, 55, 130),
        accent = Color3.fromRGB(60, 160, 255), glow = Color3.fromRGB(0, 110, 220),
        activeTab = Color3.fromRGB(0, 75, 170), logText = Color3.fromRGB(80, 180, 255)
    },
    FLAME = {
        primary = Color3.fromRGB(220, 100, 0), mid = Color3.fromRGB(180, 70, 0),
        dark = Color3.fromRGB(100, 35, 0), headerBg = Color3.fromRGB(140, 55, 0),
        accent = Color3.fromRGB(255, 160, 50), glow = Color3.fromRGB(220, 110, 0),
        activeTab = Color3.fromRGB(170, 65, 0), logText = Color3.fromRGB(255, 180, 70)
    }
}

local currentTheme = "CYBERPUNK"
local uiElements = {}

-- Forward declarations — supaya tidak error saat dipanggil sebelum UI dibuat
local analisaLabel = nil
local logFloatScroll = nil
local logListLayout = nil
local copyLogBtn = nil

function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    currentTheme = themeName
    print("🎨 Tema diterapkan: " .. themeName)
end

-- =============================================
-- BUAT GUI
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok, _ = pcall(function() screenGui.Parent = CoreGui end)
if not ok then screenGui.Parent = player:WaitForChild("PlayerGui") end

local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2)-2, 0.5, -(HEIGHT/2)-2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = 0
glowFrame.Parent = screenGui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 18)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

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

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
header.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

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

local headerDot = Instance.new("Frame")
headerDot.Size = UDim2.new(0, 7, 0, 7)
headerDot.Position = UDim2.new(0, 10, 0.5, -3.5)
headerDot.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
headerDot.BorderSizePixel = 0
headerDot.Parent = header
Instance.new("UICorner", headerDot).CornerRadius = UDim.new(1, 0)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "R4NzDev EKSTRIM v3.0"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = TEXT_SIZE_MEDIUM
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local iconSize = isTouch and 18 or 26
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, iconSize, 0, iconSize)
minimizeBtn.Position = UDim2.new(1, -(iconSize*2+10), 0.5, -iconSize/2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
minimizeBtn.Text = "⛎"
minimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = isTouch and 11 or 16
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, iconSize, 0, iconSize)
closeBtn.Position = UDim2.new(1, -(iconSize+6), 0.5, -iconSize/2)
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

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, isTouch and 4 or 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, isTouch and 8 or 12)
sidePad.PaddingLeft = UDim.new(0, isTouch and 4 or 7)
sidePad.PaddingRight = UDim.new(0, isTouch and 4 or 7)

local tabButtons = {}

function createTabBtn(btnText, btnIcon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, isTouch and 38 or 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = isTouch and (btnIcon.."\n"..btnText) or (btnIcon.."  "..btnText)
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
    activeBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 150)
    activeBtn.TextColor3 = Color3.new(1, 1, 1)
    for _, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = Color3.fromRGB(150, 80, 255)
            tab.stroke.Transparency = 0.1
        end
    end
end

local tabInfo  = createTabBtn("INFO",  "📋", 0)
local tabMain  = createTabBtn("MAIN",  "⚡", 1)
local tabUtil  = createTabBtn("UTIL",  "🔧", 2)
local tabNyawa = createTabBtn("NYAWA", "🕤", 3)

local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX+4), 1, -(HEADER_HEIGHT+6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT+4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Mini icon
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

-- =============================================
-- BUAT HALAMAN
-- =============================================
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.Parent = contentFrame
    return page
end

local infoPage  = createPage()
local mainPage  = createPage()
local utilPage  = createPage()
local nyawaPage = createPage()

for _, pg in pairs({infoPage, mainPage, utilPage}) do
    pg.ScrollingDirection = Enum.ScrollingDirection.Y
    pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pg.ScrollBarThickness = isTouch and 3 or 2
    pg.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
end

nyawaPage.ScrollingDirection = Enum.ScrollingDirection.Y
nyawaPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
nyawaPage.ScrollBarThickness = isTouch and 3 or 2
nyawaPage.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)

-- Padding & layout
local function addPadLayout(page, padV, padH, spacing)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, padH)
    pad.PaddingRight = UDim.new(0, padH)
    pad.PaddingTop = UDim.new(0, padV)
    pad.PaddingBottom = UDim.new(0, padV + 2)
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, spacing)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return layout
end

addPadLayout(infoPage,  8, 6, 8)
addPadLayout(mainPage,  5, 5, isTouch and 5 or 7)
addPadLayout(utilPage,  8, 6, 8)
addPadLayout(nyawaPage, 8, 6, 6)

-- =============================================
-- DATABASE
-- =============================================
local zX = {
    "abad","abadi","abang","abjad","acara","adalah","adanya","adapun","adaptasi",
    "adat","adegan","adil","aduk","agama","agar","agen","agung","ahad","ahli",
    "air","ajak","ajar","ajeg","akad","akal","akan","akar","akhir","akhlak",
    "akibat","akrab","aksara","aksi","aku","akun","akurat","alam","alamat",
    "alang","alas","alat","album","ali","alias","alih","alim","alir","alis",
    "alun","alur","amal","aman","ambil","ampuh","angin","angka","angkat",
    "antar","apel","arah","atas","atau","atap","atlet","awal","awas","ayam"
}

-- Database per kategori (diisi dari GitHub)
local dropData = {
    IF={}, X={}, NG={}, AI={}, KS={}, CY={}, UI={}, LY={}, GY={},
    LT={}, EO={}, OE={}, EKS={}, OO={}, KN={}, Q={}, MP={}, SF={},
    TT={}, ["SEMUA KATA SULIT"]={}
}

local dropState = {
    IF=false, X=false, NG=false, AI=false, KS=false, CY=false, UI=false,
    LY=false, GY=false, LT=false, EO=false, OE=false, EKS=false, OO=false,
    KN=false, Q=false, MP=false, SF=false, TT=false,
    ["SEMUA KATA SULIT"]=false, ["SEMUA KATA EKSTRIM"]=false
}

-- Kata yang sudah dipakai (reset tiap match)
local MX = {}

-- Load per kategori
local categoryUrls = {
    IF="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/IF.txt",
    X="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/X.txt",
    NG="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/NG.txt",
    AI="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/AI.txt",
    KS="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/KS.txt",
    CY="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/CY.txt",
    UI="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/UI.txt",
    LY="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/ly.txt",
    GY="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/gy.txt",
    LT="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/lt.txt",
    EO="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/eo.txt",
    OE="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/oe.txt",
    EKS="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/eks.txt",
    OO="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/oo.txt",
    KN="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/kn.txt",
    Q="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/q.txt",
    MP="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/mp.txt",
    SF="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/sf.txt",
    TT="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/tt.txt",
    ["SEMUA KATA SULIT"]="https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/sulit.txt"
}

task.spawn(function()
    for cat, url in pairs(categoryUrls) do
        task.spawn(function()
            local ok, res = pcall(function() return game:HttpGet(url) end)
            if ok and type(res) == "string" then
                for word in res:gmatch("[^\r\n]+") do
                    local w = word:gsub("%s+",""):lower()
                    if #w > 1 and w:match("^%a+$") then
                        table.insert(dropData[cat], w)
                    end
                end
                print("✅ "..cat.." loaded: "..#dropData[cat].." kata")
            end
        end)
    end
end)

task.spawn(function()
    local ok, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/DexterHUB99/Cari-Kata/refs/heads/main/kamus.txt")
    end)
    if ok and type(res) == "string" and #res > 1000 then
        zX = {}
        for word in res:gmatch("[^\r\n]+") do
            local w = word:gsub("%s+",""):lower()
            if #w > 1 and w:match("^%a+$") then
                table.insert(zX, w)
            end
        end
        -- Acak urutan
        for i = #zX, 2, -1 do
            local j = math.random(i)
            zX[i], zX[j] = zX[j], zX[i]
        end
        print("✅ Kamus utama loaded: "..#zX.." kata")
    end
end)

-- =============================================
-- SISTEM LOG & ANALISA
-- =============================================
local currentGameLogs = {}
local allGameLogs = {}
local matchCounter = 0
local systemPatterns = {
    matches = {},
    pattern = { depan=0, belakang=0, huruf1=0, huruf2=0, huruf3=0 }
}

-- =============================================
-- LIVE LOG FLOATING
-- =============================================
local logFloating = Instance.new("Frame")
logFloating.Name = "LogFloating"
logFloating.Size = UDim2.new(0, 280, 0, 220)
logFloating.Position = UDim2.new(1, -290, 0, 10)
logFloating.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
logFloating.BorderSizePixel = 0
logFloating.Parent = screenGui
Instance.new("UICorner", logFloating).CornerRadius = UDim.new(0, 8)

local logFloatStroke = Instance.new("UIStroke", logFloating)
logFloatStroke.Color = Color3.fromRGB(100, 40, 200)
logFloatStroke.Thickness = 1.5

local logHeader = Instance.new("Frame")
logHeader.Size = UDim2.new(1, 0, 0, 28)
logHeader.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
logHeader.BorderSizePixel = 0
logHeader.Parent = logFloating
Instance.new("UICorner", logHeader).CornerRadius = UDim.new(0, 8)

local logHeaderTitle = Instance.new("TextLabel")
logHeaderTitle.Size = UDim2.new(1, -50, 1, 0)
logHeaderTitle.Position = UDim2.new(0, 8, 0, 0)
logHeaderTitle.BackgroundTransparency = 1
logHeaderTitle.Text = "📋 LIVE LOG"
logHeaderTitle.TextColor3 = Color3.new(1, 1, 1)
logHeaderTitle.Font = Enum.Font.GothamBold
logHeaderTitle.TextSize = 11
logHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
logHeaderTitle.Parent = logHeader

copyLogBtn = Instance.new("TextButton")
copyLogBtn.Size = UDim2.new(0, 40, 0, 20)
copyLogBtn.Position = UDim2.new(1, -45, 0.5, -10)
copyLogBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
copyLogBtn.Text = "COPY"
copyLogBtn.TextColor3 = Color3.new(1, 1, 1)
copyLogBtn.Font = Enum.Font.GothamBold
copyLogBtn.TextSize = 8
copyLogBtn.Parent = logHeader
Instance.new("UICorner", copyLogBtn).CornerRadius = UDim.new(0, 4)

logFloatScroll = Instance.new("ScrollingFrame")
logFloatScroll.Size = UDim2.new(1, -10, 1, -38)
logFloatScroll.Position = UDim2.new(0, 5, 0, 33)
logFloatScroll.BackgroundTransparency = 1
logFloatScroll.ScrollBarThickness = 4
logFloatScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
logFloatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logFloatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFloatScroll.Parent = logFloating

-- UIListLayout di scroll (WAJIB agar tidak tumpang tindih)
logListLayout = Instance.new("UIListLayout")
logListLayout.Padding = UDim.new(0, 2)
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Parent = logFloatScroll

local logScrollPad = Instance.new("UIPadding", logFloatScroll)
logScrollPad.PaddingTop = UDim.new(0, 2)
logScrollPad.PaddingBottom = UDim.new(0, 2)

-- =============================================
-- FUNGSI UPDATE LOG (DIPERBAIKI)
-- =============================================
function updateLogDisplayFloating()
    for _, child in pairs(logFloatScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    if #currentGameLogs == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 40)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Menunggu soal... Match #"..matchCounter
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 10
        emptyLabel.TextWrapped = true
        emptyLabel.LayoutOrder = 0
        emptyLabel.Parent = logFloatScroll
        return
    end

    for i, log in ipairs(currentGameLogs) do
        local bgColor = i % 2 == 0
            and Color3.fromRGB(25, 23, 35)
            or  Color3.fromRGB(30, 28, 40)

        local logItem = Instance.new("Frame")
        logItem.Name = "LogItem_"..i
        logItem.Size = UDim2.new(1, 0, 0, 26)
        logItem.BackgroundColor3 = bgColor
        logItem.BorderSizePixel = 0
        logItem.LayoutOrder = i
        logItem.Parent = logFloatScroll
        Instance.new("UICorner", logItem).CornerRadius = UDim.new(0, 4)

        -- Nomor
        local numLbl = Instance.new("TextLabel")
        numLbl.Size = UDim2.new(0, 18, 1, 0)
        numLbl.Position = UDim2.new(0, 2, 0, 0)
        numLbl.BackgroundTransparency = 1
        numLbl.Text = tostring(i)
        numLbl.TextColor3 = Color3.fromRGB(100, 100, 120)
        numLbl.Font = Enum.Font.Gotham
        numLbl.TextSize = 8
        numLbl.Parent = logItem

        -- Waktu
        local timeLbl = Instance.new("TextLabel")
        timeLbl.Size = UDim2.new(0, 44, 1, 0)
        timeLbl.Position = UDim2.new(0, 20, 0, 0)
        timeLbl.BackgroundTransparency = 1
        timeLbl.Text = log.time
        timeLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        timeLbl.Font = Enum.Font.Gotham
        timeLbl.TextSize = 8
        timeLbl.Parent = logItem

        -- Soal/awalan
        local qLbl = Instance.new("TextLabel")
        qLbl.Size = UDim2.new(0, 30, 1, 0)
        qLbl.Position = UDim2.new(0, 66, 0, 0)
        qLbl.BackgroundTransparency = 1
        qLbl.Text = log.question
        qLbl.TextColor3 = Color3.fromRGB(200, 160, 255)
        qLbl.Font = Enum.Font.GothamBold
        qLbl.TextSize = 13
        qLbl.Parent = logItem

        -- Arrow
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 14, 1, 0)
        arrow.Position = UDim2.new(0, 98, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "→"
        arrow.TextColor3 = Color3.fromRGB(100, 100, 120)
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 10
        arrow.Parent = logItem

        -- Jawaban
        local jawabanTampil = #log.answer > 9
            and log.answer:sub(1, 9)..".."
            or  log.answer
        local aLbl = Instance.new("TextLabel")
        aLbl.Size = UDim2.new(1, -135, 1, 0)
        aLbl.Position = UDim2.new(0, 114, 0, 0)
        aLbl.BackgroundTransparency = 1
        aLbl.Text = jawabanTampil
        aLbl.TextColor3 = log.status == "✓"
            and Color3.fromRGB(80, 255, 120)
            or  Color3.fromRGB(255, 80, 80)
        aLbl.Font = Enum.Font.GothamBold
        aLbl.TextSize = 10
        aLbl.TextXAlignment = Enum.TextXAlignment.Left
        aLbl.Parent = logItem

        -- Sumber / tipe
        local srcLbl = Instance.new("TextLabel")
        srcLbl.Size = UDim2.new(0, 22, 1, 0)
        srcLbl.Position = UDim2.new(1, -24, 0, 0)
        srcLbl.BackgroundTransparency = 1
        local isSkakEntry = (log.src == "SKAKMAT" or log.src == "SKAKMAT★")
        srcLbl.Text = log.src == "SKAKMAT★" and "⚔★"
                   or log.src == "SKAKMAT"  and "⚔"
                   or log.src == "CAT"      and "★"
                   or "·"
        srcLbl.TextColor3 = (log.src == "SKAKMAT★") and Color3.fromRGB(255, 80, 80)
                         or (log.src == "SKAKMAT")  and Color3.fromRGB(255, 140, 50)
                         or (log.src == "CAT")      and Color3.fromRGB(255, 200, 80)
                         or Color3.fromRGB(120, 120, 140)
        srcLbl.Font = Enum.Font.GothamBold
        srcLbl.TextSize = 10
        srcLbl.Parent = logItem
    end

    -- Auto scroll ke bawah
    task.defer(function()
        local contentSize = logListLayout.AbsoluteContentSize.Y
        local scrollSize = logFloatScroll.AbsoluteSize.Y
        if contentSize > scrollSize then
            logFloatScroll.CanvasPosition = Vector2.new(0, contentSize - scrollSize)
        end
    end)
end

-- =============================================
-- FUNGSI addGameLog
-- =============================================
function addGameLog(question, answer, status, src)
    local panjang = #question
    systemPatterns.pattern.depan = systemPatterns.pattern.depan + 1
    if panjang == 1 then
        systemPatterns.pattern.huruf1 = systemPatterns.pattern.huruf1 + 1
    elseif panjang == 2 then
        systemPatterns.pattern.huruf2 = systemPatterns.pattern.huruf2 + 1
    elseif panjang >= 3 then
        systemPatterns.pattern.huruf3 = systemPatterns.pattern.huruf3 + 1
    end

    local entry = {
        time = os.date("%H:%M:%S"),
        question = question:upper(),
        answer = answer:upper(),
        status = status or "✓",
        match = matchCounter,
        src = src or "KBB"
    }

    table.insert(currentGameLogs, entry)
    table.insert(allGameLogs, entry)
    table.insert(systemPatterns.matches, entry)

    task.defer(function()
        updateLogDisplayFloating()
        if analisaLabel then updateAnalisaUI() end
    end)

    print("📝 ["..question:upper().."] → ["..answer:upper().."] ("..( src or "KBB")..")")
end

function newMatch()
    matchCounter = matchCounter + 1
    currentGameLogs = {}
    MX = {}  -- Reset kata yang sudah dipakai tiap match baru
    task.defer(updateLogDisplayFloating)
    print("🆕 Match "..matchCounter.." dimulai — MX direset")
end

-- Copy log
function copyLiveLog()
    local txt = "=== R4NzDev LIVE LOG ===\nMatch #"..matchCounter.."\n"
    txt = txt..string.rep("-",40).."\n"
    for _, log in ipairs(currentGameLogs) do
        txt = txt..string.format("%s | %-4s → %-14s | %s\n",
            log.time, log.question, log.answer, log.src)
    end
    txt = txt..string.rep("-",40).."\nTotal: "..#currentGameLogs.." jawaban\n"
    if setclipboard then
        setclipboard(txt)
        copyLogBtn.Text = "✓"
        copyLogBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 30)
        task.delay(1.5, function()
            copyLogBtn.Text = "COPY"
            copyLogBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
        end)
    end
end
copyLogBtn.MouseButton1Click:Connect(copyLiveLog)

-- =============================================
-- ANALISA UI
-- =============================================
local analisaFrame = Instance.new("Frame")
analisaFrame.Size = UDim2.new(1, -4, 0, 88)
analisaFrame.LayoutOrder = 1
analisaFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
analisaFrame.Parent = mainPage
Instance.new("UICorner", analisaFrame).CornerRadius = UDim.new(0, 9)

analisaLabel = Instance.new("TextLabel")
analisaLabel.Size = UDim2.new(1, -10, 1, -8)
analisaLabel.Position = UDim2.new(0, 5, 0, 4)
analisaLabel.BackgroundTransparency = 1
analisaLabel.Text = "🔍 ANALISA: Belum ada data\n⚡ Aktifkan AUTO TULIS lalu mainkan"
analisaLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
analisaLabel.Font = Enum.Font.Gotham
analisaLabel.TextSize = 10
analisaLabel.TextXAlignment = Enum.TextXAlignment.Left
analisaLabel.TextWrapped = true
analisaLabel.Parent = analisaFrame

function updateAnalisaUI()
    local total = #systemPatterns.matches
    if total == 0 then
        analisaLabel.Text = "🔍 ANALISA: Belum ada data\n⚡ Aktifkan AUTO TULIS lalu mainkan"
        return
    end
    local h1 = systemPatterns.pattern.huruf1
    local h2 = systemPatterns.pattern.huruf2
    local h3 = systemPatterns.pattern.huruf3
    local polaHuruf = "?"
    if h2 >= h1 and h2 >= h3 then
        polaHuruf = "2 huruf ("..h2.."x)"
    elseif h1 >= h3 then
        polaHuruf = "1 huruf ("..h1.."x)"
    else
        polaHuruf = "3+ huruf ("..h3.."x)"
    end
    analisaLabel.Text = string.format(
        "🔍 ANALISA SISTEM:\n📊 Total jawaban: %d | Match: #%d\n📏 Pola: %s",
        total, matchCounter, polaHuruf
    )
end

-- =============================================
-- VARIABEL AUTO ANSWER
-- =============================================
local autoTulisEnabled = false
local autoRejoinEnabled = true
local delayMin = 0.03
local delayMax = 0.08
local intervalMin = 0.15
local intervalMax = 0.5
local Sx = false   -- Mode manusia
local tx = false   -- Mode tuyul
local NX = false   -- Tuyul aktif
local qX = 0       -- Counter tuyul
local WX = 0       -- Spam counter tuyul
local JX = 3       -- Target jawab sebelum tuyul
local LX = false   -- Lock gX
local bX = false          -- Rejoin lock
local skakmatEnabled = false  -- Mode skakmat (prioritas kata akhiran sulit)

local kataRandom = {"wkwk","receh","noob","lemah","kasian","santuy","ezz","lol","mudah","ajib"}

-- =============================================
-- POLA AKHIRAN SKAKMAT PER KATEGORI
-- =============================================
-- Mapping kategori → pola akhiran (untuk deteksi kata skakmat)
local polaAkhiranKat = {
    IF  = "if$",  X   = "x$",   NG  = "ng$",  AI  = "ai$",
    KS  = "ks$",  CY  = "cy$",  UI  = "ui$",  LY  = "ly$",
    GY  = "gy$",  LT  = "lt$",  EO  = "eo$",  OE  = "oe$",
    EKS = "eks$", OO  = "oo$",  KN  = "kn$",  Q   = "q$",
    MP  = "mp$",  SF  = "sf$",  TT  = "tt$"
}

-- Fungsi cek apakah kata berakhiran sulit (skakmat)
function isKataSkakmat(word)
    for cat, pola in pairs(polaAkhiranKat) do
        if word:match(pola) then
            return true, cat
        end
    end
    return false, nil
end

-- =============================================
-- FUNGSI CARI KATA
-- =============================================
-- Alur prioritas:
--   1. SKAKMAT dari kategori aktif  (★★ paling diinginkan)
--   2. SKAKMAT dari kamus umum zX   (★ lumayan)
--   3. Kata biasa dari kategori aktif
--   4. Kata biasa dari kamus umum   (fallback terakhir)

function cariKataByAwalan(awalan)
    local panjang = #awalan

    local skakmatCat  = {}   -- kata akhiran sulit, dari kategori aktif
    local skakmatKBB  = {}   -- kata akhiran sulit, dari kamus umum
    local biasaCat    = {}   -- kata biasa dari kategori aktif
    local biasaKBB    = {}   -- kata biasa dari kamus umum

    -- Kumpulkan dari semua kategori aktif
    for cat, enabled in pairs(dropState) do
        if enabled and cat ~= "SEMUA KATA EKSTRIM" then
            local pool = dropData[cat] or {}
            for _, word in ipairs(pool) do
                if #word > panjang
                    and word:sub(1, panjang) == awalan
                    and not MX[word] then
                    local isSkak, _ = isKataSkakmat(word)
                    if isSkak then
                        table.insert(skakmatCat, {word=word, src="SKAKMAT"})
                    else
                        table.insert(biasaCat, {word=word, src="CAT"})
                    end
                end
            end
        end
    end

    -- Kumpulkan dari kamus umum zX
    for _, word in ipairs(zX) do
        if #word > panjang
            and word:sub(1, panjang) == awalan
            and not MX[word] then
            local isSkak, _ = isKataSkakmat(word)
            if isSkak then
                table.insert(skakmatKBB, {word=word, src="SKAKMAT"})
            else
                table.insert(biasaKBB, {word=word, src="KBB"})
            end
        end
    end

    -- Kembalikan berdasarkan prioritas
    -- Kalau skakmatEnabled ON → utamakan kata akhiran sulit
    -- Kalau skakmatEnabled OFF → langsung pakai semua kandidat (biasa dulu)
    if skakmatEnabled then
        if #skakmatCat > 0 then
            return skakmatCat, "SKAKMAT★"
        elseif #skakmatKBB > 0 then
            return skakmatKBB, "SKAKMAT"
        elseif #biasaCat > 0 then
            return biasaCat, "CAT"
        else
            return biasaKBB, "KBB"
        end
    else
        -- Skakmat OFF: pakai kategori aktif dulu, baru kamus umum
        if #biasaCat > 0 or #skakmatCat > 0 then
            local pool = {}
            for _, v in ipairs(skakmatCat) do table.insert(pool, v) end
            for _, v in ipairs(biasaCat)   do table.insert(pool, v) end
            return pool, "CAT"
        else
            local pool = {}
            for _, v in ipairs(skakmatKBB) do table.insert(pool, v) end
            for _, v in ipairs(biasaKBB)   do table.insert(pool, v) end
            return pool, "KBB"
        end
    end
end

-- =============================================
-- simulateTyping (logika v2)
-- =============================================
function simulateTyping(text)
    if not isRunning or text == "" then
        -- Tetap tekan Enter meski tidak ada yang diketik
        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        return
    end

    if Sx then
        -- Mode manusia: sesekali typo lalu hapus
        local errorsDone = 0
        local errorCount = math.random(1, 2)
        local i = 1
        while i <= #text do
            if not isRunning then return end

            -- Typo acak
            if errorsDone < errorCount and i > 1 and math.random() < 0.12 then
                errorsDone = errorsDone + 1
                task.wait(math.random() * 0.5 + 0.15)
                local rch = "QWERTYUIOPASDFGHJKLZXCVBNM"
                local typoCount = math.random(1, 2)
                for _ = 1, typoCount do
                    local rc = rch:sub(math.random(1,#rch), math.random(1,#rch))
                    local kc = Enum.KeyCode[rc]
                    if kc then
                        VirtualInputManager:SendKeyEvent(true,  kc, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, kc, false, game)
                        task.wait(delayMin + math.random()*(delayMax-delayMin))
                    end
                end
                task.wait(0.08 + math.random()*0.15)
                for _ = 1, typoCount do
                    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.04)
                end
            end

            local ch = text:sub(i,i):upper()
            local kc = Enum.KeyCode[ch]
            if kc then
                VirtualInputManager:SendKeyEvent(true,  kc, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, kc, false, game)
                task.wait(delayMin + math.random()*(delayMax-delayMin))
            end
            i = i + 1
        end
    else
        -- Mode normal
        for i = 1, #text do
            if not isRunning then return end
            local ch = text:sub(i,i):upper()
            local kc = Enum.KeyCode[ch]
            if kc then
                VirtualInputManager:SendKeyEvent(true,  kc, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, kc, false, game)
                task.wait(delayMin + math.random()*(delayMax-delayMin))
            end
        end
    end

    task.wait(intervalMin + math.random()*(intervalMax-intervalMin))
    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
    task.wait(0.02)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

-- =============================================
-- FUNGSI DETEKSI AWALAN DARI UI
-- =============================================
function detectAwalan()
    local awalan = ""
    local playerGui = player:WaitForChild("PlayerGui")

    -- Cari objek bernama WordServer / Word / soal pendek
    for _, obj in pairs(playerGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local raw = obj.Text:gsub("%s+",""):lower()
            -- Soal: 1–4 huruf, hanya alfabet
            if #raw >= 1 and #raw <= 4 and raw:match("^%a+$") then
                -- Ambil yang paling pendek (kemungkinan besar soal)
                if awalan == "" or #raw < #awalan then
                    awalan = raw
                end
            end
        end
    end

    return awalan
end

-- =============================================
-- FUNGSI UTAMA gX() — LOGIKA V2 YANG BENAR
-- =============================================
function gX()
    if not autoTulisEnabled or not isRunning or LX then return end
    LX = true

    -- ---- MODE TUYUL (spam salah) ----
    if tx and NX then
        local awalan = detectAwalan()
        if awalan ~= "" then
            if uiElements.LogAwalan then
                if uiElements.LogAwalan then uiElements.LogAwalan.Text = "👻 SPAM "..WX+1.."/2" end
            end
            -- Ketik awalan dulu
            for i = 1, #awalan do
                local kc = Enum.KeyCode[awalan:sub(i,i):upper()]
                if kc then
                    VirtualInputManager:SendKeyEvent(true, kc, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, kc, false, game)
                    task.wait(0.01)
                end
            end
            -- Ketik 2 huruf random (jawaban salah sengaja)
            local rch = {"A","Q","X","Z","J","V"}
            for _ = 1, 2 do
                local kc = Enum.KeyCode[rch[math.random(1,#rch)]]
                if kc then
                    VirtualInputManager:SendKeyEvent(true, kc, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, kc, false, game)
                    task.wait(0.01)
                end
            end
            task.wait(intervalMin + math.random()*(intervalMax-intervalMin))
            VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end

        WX = WX + 1
        if WX >= 2 then
            NX = false; WX = 0; qX = 0
            if uiElements.tuyulStatus then
                if uiElements.tuyulStatus then uiElements.tuyulStatus.Text = "Siap: 0/"..JX.." jawaban" end
                if uiElements.tuyulStatus then uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255) end
            end
        end
        task.wait(0.3)
        LX = false
        return
    end

    -- ---- MODE NORMAL ----
    local awalan = detectAwalan()

    if awalan == "" then
        print("⚠️ Soal tidak terdeteksi!")
        task.wait(0.3)
        LX = false
        return
    end

    -- Update log awalan
    if uiElements.LogAwalan then
        if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: "..awalan:upper() end
    end
    print("🔍 Soal terdeteksi: "..awalan:upper())

    -- Cari kandidat kata — prioritas SKAKMAT dulu
    local candidates, tierTag = cariKataByAwalan(awalan)

    if #candidates == 0 then
        print("❌ Tidak ada kandidat untuk: "..awalan:upper())
        if uiElements.LogAwalan then if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end end
        if uiElements.LogIsi then if uiElements.LogIsi then uiElements.LogIsi.Text = "❌ Tidak ditemukan" end end
        task.wait(0.5)
        LX = false
        return
    end

    -- Pilih acak dari kandidat (semua sudah dalam tier terbaik)
    local picked = candidates[math.random(1, #candidates)]
    local selectedWord = picked.word
    local srcTag = picked.src

    -- Tandai di log awalan apakah kata ini skakmat
    local isSkak = isKataSkakmat(selectedWord)
    if uiElements.LogAwalan then
        local skakLabel = isSkak and " ⚔SKAKMAT" or ""
        if uiElements.LogAwalan then if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: "..awalan:upper() end..skakLabel end
    end

    print("✅ Jawaban: "..selectedWord:upper().." | Soal: "..awalan:upper().." | Src: "..srcTag)

    -- Update log isi
    if uiElements.LogIsi then if uiElements.LogIsi then uiElements.LogIsi.Text = selectedWord:upper() end end

    -- Catat ke live log
    addGameLog(awalan, selectedWord, "✓", srcTag)

    -- Tandai sudah dipakai
    MX[selectedWord] = true

    -- KETIK SISA HURUF (huruf setelah awalan sudah ada di kotak)
    local sisaHuruf = selectedWord:sub(#awalan + 1)
    simulateTyping(sisaHuruf)

    -- Update counter tuyul
    if tx and not NX then
        qX = qX + 1
        if uiElements.tuyulStatus then
            if uiElements.tuyulStatus then uiElements.tuyulStatus.Text = "Benar: "..qX.."/"..JX.." → "..(JX-qX).."x lagi" end
            if uiElements.tuyulStatus then uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255) end
        end
        if qX >= JX then
            NX = true; WX = 0
            if uiElements.tuyulStatus then
                if uiElements.tuyulStatus then uiElements.tuyulStatus.Text = "👻 SPAM MODE AKTIF!" end
                if uiElements.tuyulStatus then uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80) end
            end
        end
    end

    task.wait(0.3)
    if uiElements.LogAwalan then if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end end
    if uiElements.LogIsi     then uiElements.LogIsi.Text     = "-" end
    LX = false
end

-- Loop backup (jika remote tidak terpanggil)
task.spawn(function()
    while isRunning do
        if autoTulisEnabled and not LX then
            task.spawn(gX)
        end
        task.wait(1.5)
    end
end)

-- =============================================
-- EVENT DARI GAME
-- =============================================
local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:FindFirstChild("Remotes")
if remotes then
    local matchUIRemote = remotes:FindFirstChild("MatchUI")
    if matchUIRemote then
        matchUIRemote.OnClientEvent:Connect(function(event)
            if not isRunning then return end

            if event == "StartTurn" or event == "YourTurn" then
                bX = false
                if not LX then
                    task.wait(intervalMin + math.random()*(intervalMax-intervalMin))
                    task.spawn(gX)
                end

            elseif event == "Eliminated" or event == "EndMatch" or event == "HideMatchUI" then
                newMatch()
                NX = false; WX = 0; qX = 0
                if uiElements.tuyulStatus then
                    if uiElements.tuyulStatus then uiElements.tuyulStatus.Text = "Siap: 0/"..JX.." jawaban" end
                    if uiElements.tuyulStatus then uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255) end
                end
                startInstantRejoin()
            end
        end)
    end
end

-- =============================================
-- AUTO REJOIN
-- =============================================
function startInstantRejoin()
    if not autoRejoinEnabled or bX then return end
    bX = true
    task.wait(1)

    pcall(function()
        local vs = workspace.CurrentCamera.ViewportSize
        VirtualInputManager:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, true,  game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, false, game, 0)
    end)

    task.spawn(function()
        while bX and isRunning do
            if not autoRejoinEnabled then bX = false; break end
            pcall(function()
                VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.E, false, game)
                task.wait(0.02)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
            task.wait(0.15)
        end
    end)
end

-- =============================================
-- TOGGLE BUILDER
-- =============================================
function createToggle(label, parent, defaultValue, callback, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
    f.LayoutOrder = order
    f.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)

    local fs = Instance.new("UIStroke", f)
    fs.Color = Color3.fromRGB(55, 30, 100)
    fs.Thickness = 1
    fs.Transparency = 0.4

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(210, 200, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = TEXT_SIZE_SMALL
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local tw = isTouch and 48 or 44
    local th = isTouch and 26 or 22
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, tw, 0, th)
    bg.Position = UDim2.new(1, -(tw+6), 0.5, -th/2)
    bg.BackgroundColor3 = defaultValue and Color3.fromRGB(30,180,110) or Color3.fromRGB(180,40,50)
    bg.BorderSizePixel = 0
    bg.Parent = f
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local ks = isTouch and 20 or 16
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, ks, 0, ks)
    knob.Position = defaultValue
        and UDim2.new(1, -(ks+3), 0.5, -ks/2)
        or  UDim2.new(0, 3, 0.5, -ks/2)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,0,1,0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = f

    local state = defaultValue
    hit.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and Color3.fromRGB(30,180,110) or Color3.fromRGB(180,40,50)
        knob.Position = state
            and UDim2.new(1, -(ks+3), 0.5, -ks/2)
            or  UDim2.new(0, 3, 0.5, -ks/2)
        playClickSound()
        callback(state)
    end)
    return f
end

-- =============================================
-- TOGGLE DI MAIN PAGE
-- =============================================
createToggle("🔥 AUTO TULIS", mainPage, false, function(val)
    autoTulisEnabled = val
    if val then task.wait(0.3); task.spawn(gX) end
end, 2)

createToggle("⚡ AUTO REJOIN", mainPage, true, function(val)
    autoRejoinEnabled = val
end, 3)

createToggle("🕠 MODE MANUSIA", mainPage, false, function(val)
    Sx = val
end, 4)

-- Toggle Skakmat — tombol utama untuk aktifkan kata jebakan
local skakmatToggleFrame = createToggle("⚔ MODE SKAKMAT", mainPage, false, function(val)
    skakmatEnabled = val
    if uiElements.skakmatStatus then
        if val then
            if uiElements.skakmatStatus then uiElements.skakmatStatus.Text = "ON — Kata akhiran sulit diprioritaskan" end
            if uiElements.skakmatStatus then uiElements.skakmatStatus.TextColor3 = Color3.fromRGB(255, 100, 50) end
        else
            if uiElements.skakmatStatus then uiElements.skakmatStatus.Text = "OFF — Pakai kata biasa" end
            if uiElements.skakmatStatus then uiElements.skakmatStatus.TextColor3 = Color3.fromRGB(130, 130, 160) end
        end
    end
end, 5)

-- Label status skakmat (di bawah toggle)
local skakmatStatusFrame = Instance.new("Frame")
skakmatStatusFrame.Size = UDim2.new(1, -4, 0, isTouch and 28 or 24)
skakmatStatusFrame.LayoutOrder = 6
skakmatStatusFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 10)
skakmatStatusFrame.BorderSizePixel = 0
skakmatStatusFrame.Parent = mainPage
Instance.new("UICorner", skakmatStatusFrame).CornerRadius = UDim.new(0, 7)

local skakmatStatusStroke = Instance.new("UIStroke", skakmatStatusFrame)
skakmatStatusStroke.Color = Color3.fromRGB(180, 60, 20)
skakmatStatusStroke.Thickness = 1
skakmatStatusStroke.Transparency = 0.5

local skakmatHint = Instance.new("TextLabel")
skakmatHint.Size = UDim2.new(0, 22, 1, 0)
skakmatHint.Position = UDim2.new(0, 4, 0, 0)
skakmatHint.BackgroundTransparency = 1
skakmatHint.Text = "⚔"
skakmatHint.TextColor3 = Color3.fromRGB(255, 120, 50)
skakmatHint.Font = Enum.Font.GothamBold
skakmatHint.TextSize = 12
skakmatHint.Parent = skakmatStatusFrame

local skakmatStatusLbl = Instance.new("TextLabel")
skakmatStatusLbl.Size = UDim2.new(1, -30, 1, 0)
skakmatStatusLbl.Position = UDim2.new(0, 28, 0, 0)
skakmatStatusLbl.BackgroundTransparency = 1
skakmatStatusLbl.Text = "OFF — Pakai kata biasa"
skakmatStatusLbl.TextColor3 = Color3.fromRGB(130, 130, 160)
skakmatStatusLbl.Font = Enum.Font.Gotham
skakmatStatusLbl.TextSize = isTouch and 9 or 10
skakmatStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
skakmatStatusLbl.Parent = skakmatStatusFrame
uiElements.skakmatStatus = skakmatStatusLbl

createToggle("👻 MODE TUYUL", mainPage, false, function(val)
    tx = val
    if not val then NX=false; qX=0; WX=0 end
end, 7)

-- =============================================
-- SPEED SETTINGS PANEL
-- =============================================
local speedPanelHeight = isTouch and 48 or 42
local speedTotalHeight = 28 + 4 * speedPanelHeight + 6

local speedPanel = Instance.new("Frame")
speedPanel.Size = UDim2.new(1, -4, 0, speedTotalHeight)
speedPanel.LayoutOrder = 8
speedPanel.BackgroundColor3 = Color3.fromRGB(12, 11, 20)
speedPanel.BorderSizePixel = 0
speedPanel.Parent = mainPage
Instance.new("UICorner", speedPanel).CornerRadius = UDim.new(0, 11)

local speedPanelStroke = Instance.new("UIStroke", speedPanel)
speedPanelStroke.Color = Color3.fromRGB(60, 30, 110)
speedPanelStroke.Thickness = 1
speedPanelStroke.Transparency = 0.3

local speedHeader = Instance.new("Frame")
speedHeader.Size = UDim2.new(1, 0, 0, 26)
speedHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
speedHeader.BorderSizePixel = 0
speedHeader.Parent = speedPanel
Instance.new("UICorner", speedHeader).CornerRadius = UDim.new(0, 11)

local speedHeaderCover = Instance.new("Frame")
speedHeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
speedHeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
speedHeaderCover.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
speedHeaderCover.BorderSizePixel = 0
speedHeaderCover.Parent = speedHeader

local speedHeaderTitle = Instance.new("TextLabel")
speedHeaderTitle.Size = UDim2.new(1, -12, 1, 0)
speedHeaderTitle.Position = UDim2.new(0, 12, 0, 0)
speedHeaderTitle.BackgroundTransparency = 1
speedHeaderTitle.Text = "⚡  SPEED SETTINGS"
speedHeaderTitle.TextColor3 = Color3.fromRGB(180, 140, 255)
speedHeaderTitle.Font = Enum.Font.GothamBold
speedHeaderTitle.TextSize = 10
speedHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
speedHeaderTitle.Parent = speedHeader

-- Data slider
local speedSliders = {
    {
        icon = "⌨", label = "NULIS",
        min = 0.01, max = 1.0,
        defMin = 0.03, defMax = 0.08,
        dec = 2, suffix = "s",
        cbMin = function(v) delayMin = v end,
        cbMax = function(v) delayMax = v end
    },
    {
        icon = "⍱", label = "DELAY GILIRAN",
        min = 0.1, max = 5.0,
        defMin = 0.15, defMax = 0.5,
        dec = 1, suffix = "s",
        cbMin = function(v) intervalMin = v end,
        cbMax = function(v) intervalMax = v end
    },
    {
        icon = "⏱", label = "INTERVAL",
        min = 0.01, max = 3.0,
        defMin = 0.15, defMax = 0.5,
        dec = 2, suffix = "s",
        cbMin = function(v) intervalMin = v end,
        cbMax = function(v) intervalMax = v end
    },
    {
        icon = "🗑", label = "DELETE",
        min = 0.01, max = 1.0,
        defMin = 0.02, defMax = 0.06,
        dec = 2, suffix = "s",
        cbMin = function(v) delayMin = math.min(v, delayMax) end,
        cbMax = function(v) delayMax = math.max(v, delayMin) end
    }
}

-- Inisialisasi nilai default
for _, s in ipairs(speedSliders) do
    s.cbMin(s.defMin)
    s.cbMax(s.defMax)
end

local knobPx = isTouch and 16 or 12

for idx, s in ipairs(speedSliders) do
    local yPos = 28 + (idx - 1) * speedPanelHeight
    local rowH = speedPanelHeight - 4

    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, -10, 0, rowH)
    rowFrame.Position = UDim2.new(0, 5, 0, yPos)
    rowFrame.BackgroundColor3 = idx % 2 == 0
        and Color3.fromRGB(16, 14, 26)
        or  Color3.fromRGB(13, 12, 22)
    rowFrame.BorderSizePixel = 0
    rowFrame.Parent = speedPanel
    Instance.new("UICorner", rowFrame).CornerRadius = UDim.new(0, 7)

    -- Label nama
    local rowLabel = Instance.new("TextLabel")
    rowLabel.Size = UDim2.new(0, 90, 0, 14)
    rowLabel.Position = UDim2.new(0, 8, 0, 4)
    rowLabel.BackgroundTransparency = 1
    rowLabel.Text = s.icon.." "..s.label
    rowLabel.TextColor3 = Color3.fromRGB(170, 155, 210)
    rowLabel.Font = Enum.Font.GothamBold
    rowLabel.TextSize = isTouch and 8 or 9
    rowLabel.TextXAlignment = Enum.TextXAlignment.Left
    rowLabel.Parent = rowFrame

    -- Label nilai
    local fmt = "%."..s.dec.."f"
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 100, 0, 14)
    valLabel.Position = UDim2.new(1, -104, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = isTouch and 8 or 9
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
    valLabel.Parent = rowFrame

    local minVal = s.defMin
    local maxVal = s.defMax

    local function updateValLabel()
        valLabel.Text = string.format(fmt, minVal).." ~ "..string.format(fmt, maxVal)..s.suffix
    end
    updateValLabel()

    -- Track bar
    local barY = isTouch and 26 or 22
    local barFrame = Instance.new("Frame")
    barFrame.Size = UDim2.new(1, -16, 0, 4)
    barFrame.Position = UDim2.new(0, 8, 0, barY)
    barFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    barFrame.BorderSizePixel = 0
    barFrame.Parent = rowFrame
    Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)

    local fillBar = Instance.new("Frame")
    fillBar.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
    fillBar.BorderSizePixel = 0
    fillBar.Parent = barFrame
    Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)

    local knobMin = Instance.new("Frame")
    knobMin.Size = UDim2.new(0, knobPx, 0, knobPx)
    knobMin.BackgroundColor3 = Color3.new(1, 1, 1)
    knobMin.BorderSizePixel = 0
    knobMin.ZIndex = 3
    knobMin.Parent = barFrame
    Instance.new("UICorner", knobMin).CornerRadius = UDim.new(1, 0)
    local kminStroke = Instance.new("UIStroke", knobMin)
    kminStroke.Color = Color3.fromRGB(150, 80, 255)
    kminStroke.Thickness = 1.5

    local knobMax = Instance.new("Frame")
    knobMax.Size = UDim2.new(0, knobPx, 0, knobPx)
    knobMax.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
    knobMax.BorderSizePixel = 0
    knobMax.ZIndex = 3
    knobMax.Parent = barFrame
    Instance.new("UICorner", knobMax).CornerRadius = UDim.new(1, 0)
    local kmaxStroke = Instance.new("UIStroke", knobMax)
    kmaxStroke.Color = Color3.fromRGB(200, 150, 255)
    kmaxStroke.Thickness = 1.5

    local kR = knobPx / 2

    local function snapVal(v)
        local m = 10 ^ s.dec
        return math.floor(v * m + 0.5) / m
    end

    local function updateVis()
        local minR = (minVal - s.min) / (s.max - s.min)
        local maxR = (maxVal - s.min) / (s.max - s.min)
        fillBar.Position = UDim2.new(minR, 0, 0, 0)
        fillBar.Size     = UDim2.new(maxR - minR, 0, 1, 0)
        knobMin.Position = UDim2.new(minR, -kR, 0.5, -kR)
        knobMax.Position = UDim2.new(maxR, -kR, 0.5, -kR)
        updateValLabel()
    end
    updateVis()

    -- Hitbox drag
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, knobPx * 2)
    hitbox.Position = UDim2.new(0, 0, 0.5, -knobPx)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.ZIndex = 4
    hitbox.Parent = barFrame

    local draggingMin = false
    local draggingMax = false

    local function getRatio(posX)
        local bPos = barFrame.AbsolutePosition.X
        local bSize = barFrame.AbsoluteSize.X
        return math.clamp((posX - bPos) / bSize, 0, 1)
    end

    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
           and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local v = snapVal(s.min + getRatio(input.Position.X) * (s.max - s.min))
        if math.abs(v - minVal) <= math.abs(v - maxVal) then
            draggingMin = true
        else
            draggingMax = true
        end
    end)

    -- Pakai UserInputService global agar drag tetap jalan
    -- walau mouse keluar dari barFrame
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
           and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not (draggingMin or draggingMax) then return end
        local nv = snapVal(s.min + getRatio(input.Position.X) * (s.max - s.min))
        local step = 1 / (10 ^ s.dec)
        if draggingMin then
            minVal = math.clamp(nv, s.min, maxVal - step)
            s.cbMin(minVal)
        else
            maxVal = math.clamp(nv, minVal + step, s.max)
            s.cbMax(maxVal)
        end
        updateVis()
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            draggingMin = false
            draggingMax = false
        end
    end)
end

-- =============================================
-- LOG FRAME DI MAIN PAGE
-- =============================================
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -4, 0, isTouch and 55 or 50)
logFrame.LayoutOrder = 9
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainPage
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 9)

local logStroke = Instance.new("UIStroke", logFrame)
logStroke.Color = Color3.fromRGB(80, 40, 140)
logStroke.Thickness = 1
logStroke.Transparency = 0.4

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

-- =============================================
-- DROPDOWN KATEGORI
-- =============================================
local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
dropBtn.LayoutOrder = 10
dropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
dropBtn.Text = "⪼  SET KATA SULIT ⪼"
dropBtn.TextColor3 = Color3.new(1, 1, 1)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = TEXT_SIZE_SMALL
dropBtn.Parent = mainPage
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 9)

local dropBtnGrad = Instance.new("UIGradient", dropBtn)
dropBtnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90,30,190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50,15,120))
})

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.new(1, -4, 0, 0)
dropFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
dropFrame.ClipsDescendants = true
dropFrame.BorderSizePixel = 0
dropFrame.Parent = mainPage
dropFrame.LayoutOrder = 11

local dropStroke = Instance.new("UIStroke", dropFrame)
dropStroke.Color = Color3.fromRGB(80, 35, 160)
dropStroke.Thickness = 1
dropStroke.Transparency = 0.3

local categories = {
    "IF","X","NG","AI","KS","CY","UI","LY","GY","LT",
    "EO","OE","EKS","OO","KN","Q","MP","SF","TT",
    "SEMUA KATA SULIT","SEMUA KATA EKSTRIM"
}
local itemHeight = isTouch and 37 or 33
local isDropOpen = false

function refreshDropUI()
    for _, child in pairs(dropFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for i, cat in ipairs(categories) do
        local isSemua = dropState["SEMUA KATA SULIT"] or dropState["SEMUA KATA EKSTRIM"]
        local isAllSelected = isSemua and cat ~= "SEMUA KATA SULIT" and cat ~= "SEMUA KATA EKSTRIM"
        local isSelected = dropState[cat]

        local catBtn = Instance.new("TextButton")
        catBtn.Size = UDim2.new(1, -12, 0, isTouch and 32 or 28)
        catBtn.Position = UDim2.new(0, 6, 0, (i-1)*itemHeight + 5)
        catBtn.BackgroundColor3 = isAllSelected and Color3.fromRGB(25,22,36)
            or isSelected and (cat == "SEMUA KATA EKSTRIM"
                and Color3.fromRGB(180,40,80)
                or  Color3.fromRGB(80,30,170))
            or (cat == "SEMUA KATA EKSTRIM" and Color3.fromRGB(80,20,40)
                or  Color3.fromRGB(28,25,42))
        catBtn.Text = (isSelected and "✔  " or "   ")..cat
        catBtn.TextColor3 = isAllSelected and Color3.fromRGB(70,65,90)
            or isSelected and Color3.new(1,1,1)
            or  Color3.fromRGB(160,150,190)
        catBtn.Font = Enum.Font.GothamBold
        catBtn.TextSize = TEXT_SIZE_SMALL
        catBtn.TextXAlignment = Enum.TextXAlignment.Left
        catBtn.Parent = dropFrame
        Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 7)

        local cp = Instance.new("UIPadding", catBtn)
        cp.PaddingLeft = UDim.new(0, 8)

        -- Jumlah kata
        local cnt = #(dropData[cat] or {})
        local cntLbl = Instance.new("TextLabel")
        cntLbl.Size = UDim2.new(0, 60, 1, 0)
        cntLbl.Position = UDim2.new(1, -64, 0, 0)
        cntLbl.BackgroundTransparency = 1
        cntLbl.Text = cnt > 0 and (cnt.." kata") or "loading..."
        cntLbl.TextColor3 = Color3.fromRGB(120, 100, 180)
        cntLbl.Font = Enum.Font.Gotham
        cntLbl.TextSize = isTouch and 8 or 9
        cntLbl.TextXAlignment = Enum.TextXAlignment.Right
        cntLbl.ZIndex = catBtn.ZIndex + 1
        cntLbl.Parent = catBtn

        catBtn.MouseButton1Click:Connect(function()
            if isAllSelected then return end
            playClickSound()

            if cat == "SEMUA KATA SULIT" then
                dropState["SEMUA KATA SULIT"] = not dropState["SEMUA KATA SULIT"]
                if dropState["SEMUA KATA SULIT"] then
                    for c in pairs(dropState) do
                        if c ~= "SEMUA KATA SULIT" and c ~= "SEMUA KATA EKSTRIM" then
                            dropState[c] = false
                        end
                    end
                    dropState["SEMUA KATA EKSTRIM"] = false
                end

            elseif cat == "SEMUA KATA EKSTRIM" then
                dropState["SEMUA KATA EKSTRIM"] = not dropState["SEMUA KATA EKSTRIM"]
                if dropState["SEMUA KATA EKSTRIM"] then
                    for _, c in ipairs({"IF","X","NG","AI","KS","CY","UI","LY","GY",
                                        "LT","EO","OE","EKS","OO","KN","Q","MP","SF","TT"}) do
                        dropState[c] = true
                    end
                    dropState["SEMUA KATA SULIT"] = false
                end
            else
                dropState[cat] = not dropState[cat]
            end
            refreshDropUI()
        end)
    end
end

dropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isDropOpen = not isDropOpen
    dropBtn.Text = isDropOpen and "⪼  SET KATA SULIT ⪻" or "⪼  SET KATA SULIT ⪼"
    dropFrame:TweenSize(
        UDim2.new(1,-4, 0, isDropOpen and (#categories*itemHeight+10) or 0),
        "Out","Quart",0.3,true)
    refreshDropUI()
end)

-- =============================================
-- DROPDOWN TEMA
-- =============================================
local themeDropBtn = Instance.new("TextButton")
themeDropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
themeDropBtn.LayoutOrder = 12
themeDropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
themeDropBtn.Text = "🎨 PILIH TEMA WARNA"
themeDropBtn.TextColor3 = Color3.new(1, 1, 1)
themeDropBtn.Font = Enum.Font.GothamBold
themeDropBtn.TextSize = TEXT_SIZE_SMALL
themeDropBtn.Parent = mainPage
Instance.new("UICorner", themeDropBtn).CornerRadius = UDim.new(0, 9)

local themeDropGrad = Instance.new("UIGradient", themeDropBtn)
themeDropGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90,30,190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50,15,120))
})

local themeDropFrame = Instance.new("Frame")
themeDropFrame.Size = UDim2.new(1, -4, 0, 0)
themeDropFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
themeDropFrame.ClipsDescendants = true
themeDropFrame.BorderSizePixel = 0
themeDropFrame.Parent = mainPage
themeDropFrame.LayoutOrder = 13

local tdfStroke = Instance.new("UIStroke", themeDropFrame)
tdfStroke.Color = Color3.fromRGB(80, 35, 160)
tdfStroke.Thickness = 1
tdfStroke.Transparency = 0.3

local themes_list = {"CYBERPUNK","CRIMSON","MATRIX","SAKURA","OCEAN","FLAME"}
local themeItemH = isTouch and 32 or 28
local isThemeOpen = false

function refreshThemeUI()
    for _, child in pairs(themeDropFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for i, tname in ipairs(themes_list) do
        local tb = Instance.new("TextButton")
        tb.Size = UDim2.new(1,-12, 0, themeItemH)
        tb.Position = UDim2.new(0,6, 0, (i-1)*(themeItemH+2)+5)
        local active = currentTheme == tname
        tb.BackgroundColor3 = active and Color3.fromRGB(80,30,170) or Color3.fromRGB(28,25,42)
        tb.Text = (active and "✔ " or "   ")..tname
        tb.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(160,150,190)
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = TEXT_SIZE_SMALL
        tb.TextXAlignment = Enum.TextXAlignment.Left
        tb.Parent = themeDropFrame
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local tp = Instance.new("UIPadding", tb)
        tp.PaddingLeft = UDim.new(0, 8)
        if active then
            local as = Instance.new("UIStroke", tb)
            as.Color = Color3.fromRGB(130, 70, 220)
            as.Thickness = 1
            as.Transparency = 0.2
        end
        local cp = Instance.new("Frame")
        cp.Size = UDim2.new(0,16,0,16)
        cp.Position = UDim2.new(1,-24, 0.5,-8)
        cp.BackgroundColor3 = themes[tname].primary
        cp.BorderSizePixel = 0
        cp.Parent = tb
        Instance.new("UICorner", cp).CornerRadius = UDim.new(1, 0)
        tb.MouseButton1Click:Connect(function()
            playClickSound()
            applyTheme(tname)
            refreshThemeUI()
        end)
    end
end

themeDropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isThemeOpen = not isThemeOpen
    themeDropBtn.Text = isThemeOpen and "🎨 PILIH TEMA ▼" or "🎨 PILIH TEMA WARNA"
    themeDropFrame:TweenSize(
        UDim2.new(1,-4, 0, isThemeOpen and (#themes_list*(themeItemH+2)+10) or 0),
        "Out","Quart",0.3,true)
    refreshThemeUI()
end)

-- =============================================
-- UTIL PAGE — STATUS TUYUL
-- =============================================
local tuyulFrame = Instance.new("Frame")
tuyulFrame.Size = UDim2.new(1, 0, 0, 130)
tuyulFrame.LayoutOrder = 1
tuyulFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
tuyulFrame.BorderSizePixel = 0
tuyulFrame.Parent = utilPage
Instance.new("UICorner", tuyulFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", tuyulFrame).Color = Color3.fromRGB(90, 40, 180)

local tuyulHeader = Instance.new("TextLabel")
tuyulHeader.Size = UDim2.new(1,-24, 0, 20)
tuyulHeader.Position = UDim2.new(0,12, 0,8)
tuyulHeader.BackgroundTransparency = 1
tuyulHeader.Text = "👻 MODE TUYUL"
tuyulHeader.TextColor3 = Color3.fromRGB(150, 80, 255)
tuyulHeader.Font = Enum.Font.GothamBold
tuyulHeader.TextSize = isTouch and 11 or 12
tuyulHeader.TextXAlignment = Enum.TextXAlignment.Left
tuyulHeader.Parent = tuyulFrame

local tuyulDesc = Instance.new("TextLabel")
tuyulDesc.Size = UDim2.new(1,-24, 0, 32)
tuyulDesc.Position = UDim2.new(0,12, 0,30)
tuyulDesc.BackgroundTransparency = 1
tuyulDesc.Text = "Auto salah setiap N jawaban benar. Cocok untuk farming dengan aman."
tuyulDesc.TextColor3 = Color3.fromRGB(170, 155, 200)
tuyulDesc.Font = Enum.Font.Gotham
tuyulDesc.TextSize = isTouch and 9 or 10
tuyulDesc.TextWrapped = true
tuyulDesc.TextXAlignment = Enum.TextXAlignment.Left
tuyulDesc.Parent = tuyulFrame

local tuyulStatus = Instance.new("TextLabel")
tuyulStatus.Size = UDim2.new(1,-24, 0, 22)
tuyulStatus.Position = UDim2.new(0,12, 0,66)
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
        tuyulStatus.Text = "Siap: 0/"..JX.." jawaban"
        tuyulStatus.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        tuyulStatus.Text = "STATUS: OFF"
        tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        NX=false; qX=0; WX=0
    end
end, 2)
tuyulToggle.Parent = tuyulFrame
tuyulToggle.Position = UDim2.new(0,12, 0,94)
tuyulToggle.Size = UDim2.new(1,-24, 0, TOGGLE_HEIGHT)

-- =============================================
-- INFO PAGE
-- =============================================
local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1,-20, 0, 28)
infoTitle.LayoutOrder = 1
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "📋 R4NzDev EKSTRIM v3.0"
infoTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 15
infoTitle.Parent = infoPage

local infoDesc = Instance.new("TextLabel")
infoDesc.Size = UDim2.new(1,-20, 0, 300)
infoDesc.LayoutOrder = 2
infoDesc.BackgroundTransparency = 1
infoDesc.Text = [[
⚔ APA ITU KATA SKAKMAT?
Kata yang huruf BELAKANGNYA susah
dilanjutkan lawan. Contoh:
  • UNIX   → lawan harus cari kata "X"
  • KOMIKS → lawan harus cari kata "KS"
  • STEREO → lawan harus cari kata "EO"
  • VOODOO → lawan harus cari kata "OO"

🔥 CARA KERJA AUTO TULIS:
1. Script deteksi soal (awalan 1-4 huruf)
2. Cari kata berawalan sama
3. PRIORITAS: kata akhiran sulit (skakmat)
4. Ketik sisa huruf otomatis

📊 SIMBOL DI LIVE LOG:
  ⚔★ = Skakmat dari kategori dipilih
  ⚔  = Skakmat dari kamus umum
  ★  = Kata dari kategori dipilih
  ·  = Kata dari kamus umum (fallback)

📂 CARA AKTIFKAN SKAKMAT:
Buka "SET KATA SULIT" → pilih kategori
Misal aktifkan X, KS, OO, MP, SF, TT
Script otomatis prioritaskan kata-kata
yang berakhiran huruf-huruf tersebut!

DIBUAT OLEH R4NzDev
]]
infoDesc.TextColor3 = Color3.fromRGB(180, 170, 210)
infoDesc.Font = Enum.Font.Gotham
infoDesc.TextSize = 11
infoDesc.TextWrapped = true
infoDesc.TextXAlignment = Enum.TextXAlignment.Left
infoDesc.Parent = infoPage

-- =============================================
-- NYAWA PAGE (MINIMAL)
-- =============================================
local nyawaTitle = Instance.new("TextLabel")
nyawaTitle.Size = UDim2.new(1, 0, 0, 24)
nyawaTitle.LayoutOrder = 1
nyawaTitle.BackgroundTransparency = 1
nyawaTitle.Text = "🕤 NYAWA PEMAIN"
nyawaTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
nyawaTitle.Font = Enum.Font.GothamBold
nyawaTitle.TextSize = 11
nyawaTitle.TextXAlignment = Enum.TextXAlignment.Left
nyawaTitle.Parent = nyawaPage

local nyawaInfo = Instance.new("TextLabel")
nyawaInfo.Size = UDim2.new(1, 0, 0, 40)
nyawaInfo.LayoutOrder = 2
nyawaInfo.BackgroundTransparency = 1
nyawaInfo.Text = "Fitur nyawa akan menampilkan status pemain dalam match saat ini."
nyawaInfo.TextColor3 = Color3.fromRGB(170, 155, 200)
nyawaInfo.Font = Enum.Font.Gotham
nyawaInfo.TextSize = 10
nyawaInfo.TextWrapped = true
nyawaInfo.TextXAlignment = Enum.TextXAlignment.Left
nyawaInfo.Parent = nyawaPage

-- =============================================
-- NAVIGASI
-- =============================================
function showPage(page)
    for _, p in pairs({infoPage, mainPage, utilPage, nyawaPage}) do
        if p then p.Visible = false end
    end
    if page then page.Visible = true end
end

showPage(mainPage)
setActiveTab(tabMain)

tabInfo.MouseButton1Click:Connect(function()
    showPage(infoPage); setActiveTab(tabInfo); playClickSound()
end)
tabMain.MouseButton1Click:Connect(function()
    showPage(mainPage); setActiveTab(tabMain); playClickSound()
end)
tabUtil.MouseButton1Click:Connect(function()
    showPage(utilPage); setActiveTab(tabUtil); playClickSound()
end)
tabNyawa.MouseButton1Click:Connect(function()
    showPage(nyawaPage); setActiveTab(tabNyawa); playClickSound()
end)

closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if _G[scriptKey] then _G[scriptKey]() end
end)

-- =============================================
-- DRAG WINDOW
-- =============================================
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
    local delta = input.Position - dragStart
    local newX = dragPosition.X.Offset + delta.X
    local newY = dragPosition.Y.Offset + delta.Y
    local vs = workspace.CurrentCamera.ViewportSize
    local fs = mainFrame.AbsoluteSize
    newX = math.clamp(newX, 10, vs.X - fs.X - 10)
    newY = math.clamp(newY, 10, vs.Y - fs.Y - 10)
    mainFrame.Position = UDim2.new(0, newX, 0, newY)
    glowFrame.Position = UDim2.new(0, newX-2, 0, newY-2)
    resizeHandle.Position = UDim2.new(0, newX+fs.X-24, 0, newY+fs.Y-24)
    logFloating.Position = UDim2.new(1, -290, 0, 10)
end)

header.InputEnded:Connect(function(input)
    if isTouchOrMouse(input) then isDragging = false end
end)

titleLabel.InputBegan:Connect(function(input)
    if isTouchOrMouse(input) then
        isDragging = true
        dragStart = input.Position
        dragPosition = mainFrame.Position
    end
end)

-- =============================================
-- RESIZE WINDOW
-- =============================================
local isResizing = false
local startPos, startWidth, startHeight

function clampWindow(w, h)
    return math.clamp(w, isTouch and 260 or 300, isTouch and 500 or 720),
           math.clamp(h, isTouch and 200 or 230, isTouch and 480 or 600)
end

resizeHandle.InputBegan:Connect(function(input)
    if not isTouchOrMouse(input) then return end
    isResizing = true
    startPos = input.Position
    startWidth = mainFrame.Size.X.Offset
    startHeight = mainFrame.Size.Y.Offset
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        local nw = math.max(startWidth + delta.X, isTouch and 260 or 300)
        local nh = math.max(startHeight + delta.Y, isTouch and 200 or 230)
        nw, nh = clampWindow(nw, nh)
        mainFrame.Size = UDim2.new(0, nw, 0, nh)
        local pos = mainFrame.Position
        glowFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset-2, pos.Y.Scale, pos.Y.Offset-2)
        glowFrame.Size = UDim2.new(0, nw+4, 0, nh+4)
        resizeHandle.Position = UDim2.new(pos.X.Scale, pos.X.Offset+nw-24, pos.Y.Scale, pos.Y.Offset+nh-24)
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if isTouchOrMouse(input) then isResizing = false end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if mainFrame.Visible then
        local pos = mainFrame.Position
        local sz = mainFrame.Size
        resizeHandle.Position = UDim2.new(pos.X.Scale, pos.X.Offset+sz.X.Offset-24,
                                          pos.Y.Scale, pos.Y.Offset+sz.Y.Offset-24)
    end
end)

-- =============================================
-- DEBUG OVERLAY
-- =============================================
local debugFrame = Instance.new("Frame")
debugFrame.Size = UDim2.new(1, 0, 0, 160)
debugFrame.Position = UDim2.new(0, 0, 1, -160)
debugFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
debugFrame.BackgroundTransparency = 0.6
debugFrame.BorderSizePixel = 0
debugFrame.ZIndex = 100
debugFrame.Parent = screenGui

local debugText = Instance.new("TextLabel")
debugText.Size = UDim2.new(1,-10,1,-10)
debugText.Position = UDim2.new(0,5,0,5)
debugText.BackgroundTransparency = 1
debugText.TextColor3 = Color3.new(1,1,0)
debugText.TextWrapped = true
debugText.TextXAlignment = Enum.TextXAlignment.Left
debugText.TextYAlignment = Enum.TextYAlignment.Top
debugText.Font = Enum.Font.Code
debugText.TextSize = 11
debugText.Text = "=== DEBUG ===\n"
debugText.ZIndex = 101
debugText.Parent = debugFrame

local oldPrint = print
print = function(...)
    local args = {...}
    local str = ""
    for _, v in ipairs(args) do str = str..tostring(v).." " end
    oldPrint(str)
    debugText.Text = debugText.Text.."\n"..str
    local lines = {}
    for line in debugText.Text:gmatch("[^\n]+") do table.insert(lines, line) end
    if #lines > 25 then
        while #lines > 25 do table.remove(lines, 1) end
        debugText.Text = table.concat(lines, "\n")
    end
end

-- =============================================
-- INISIALISASI AKHIR
-- =============================================
applyTheme("CYBERPUNK")
logFloating.Position = UDim2.new(1, -290, 0, 10)
updateLogDisplayFloating()

print("✅ R4NzDev EKSTRIM v3.0 loaded!")
print("🔑 Logika AUTO TULIS: cari kata berawalan soal, ketik sisa huruf")
print("★ = dari kategori dipilih  |  · = kamus umum")
print("📋 Live log aktif — jawab soal untuk melihat hasil")