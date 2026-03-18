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
        if gui then
            gui.Visible = false
        end
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

local currentTheme = "CYBERPUNK"
local uiElements = {}

function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    currentTheme = themeName
    print("🎨 Tema diterapkan: " .. themeName)
end

-- Membuat layar utama GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.Parent = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame efek glow
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
titleLabel.Size = UDim2.new(0, 180, 1, 0)
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
    for i, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(120, 110, 150)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
    end
    activeBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 150)
    activeBtn.TextColor3 = Color3.new(1, 1, 1)
    for i, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = Color3.fromRGB(150, 80, 255)
            tab.stroke.Transparency = 0.1
        end
    end
end

local tabInfo = createTabBtn("INFO", "📋", 0)
local tabMain = createTabBtn("MAIN", "⚡", 1)
local tabUtil = createTabBtn("UTIL", "🔧", 2)
local tabNyawa = createTabBtn("NYAWA", "🕤", 3)

local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX + 4), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

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

function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.Parent = contentFrame
    return page
end

local infoPage = createPage()
local mainPage = createPage()
local utilPage = createPage()
local nyawaPage = createPage()

infoPage.ScrollingDirection = Enum.ScrollingDirection.Y
infoPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
infoPage.ScrollBarThickness = isTouch and 3 or 2
infoPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)

mainPage.ScrollingDirection = Enum.ScrollingDirection.Y
mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainPage.ScrollBarThickness = isTouch and 3 or 2
mainPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)

utilPage.ScrollingDirection = Enum.ScrollingDirection.Y
utilPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
utilPage.ScrollBarThickness = isTouch and 3 or 2
utilPage.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)

nyawaPage.ScrollingDirection = Enum.ScrollingDirection.Y
nyawaPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
nyawaPage.ScrollBarThickness = isTouch and 3 or 2
nyawaPage.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)

local infoPad = Instance.new("UIPadding", infoPage)
infoPad.PaddingLeft = UDim.new(0, 6)
infoPad.PaddingRight = UDim.new(0, 6)
infoPad.PaddingTop = UDim.new(0, 8)
infoPad.PaddingBottom = UDim.new(0, 10)

local mainPad = Instance.new("UIPadding", mainPage)
mainPad.PaddingLeft = UDim.new(0, 5)
mainPad.PaddingRight = UDim.new(0, 5)
mainPad.PaddingTop = UDim.new(0, 5)
mainPad.PaddingBottom = UDim.new(0, 10)

local utilPad = Instance.new("UIPadding", utilPage)
utilPad.PaddingLeft = UDim.new(0, 6)
utilPad.PaddingRight = UDim.new(0, 6)
utilPad.PaddingTop = UDim.new(0, 8)

local nyawaPad = Instance.new("UIPadding", nyawaPage)
nyawaPad.PaddingLeft = UDim.new(0, 6)
nyawaPad.PaddingRight = UDim.new(0, 6)
nyawaPad.PaddingTop = UDim.new(0, 8)
nyawaPad.PaddingBottom = UDim.new(0, 8)

local infoLayout = Instance.new("UIListLayout")
infoLayout.Padding = UDim.new(0, 8)
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Parent = infoPage

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, isTouch and 5 or 7)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainPage

local utilLayout = Instance.new("UIListLayout")
utilLayout.Padding = UDim.new(0, 8)
utilLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilLayout.Parent = utilPage

local nyawaLayout = Instance.new("UIListLayout")
nyawaLayout.Padding = UDim.new(0, 6)
nyawaLayout.SortOrder = Enum.SortOrder.LayoutOrder
nyawaLayout.Parent = nyawaPage

-- ==============================================
-- DATABASE DAN FITUR AUTO ANSWER
-- ==============================================

local database = {
    belakang = {},
    depan = {}
}

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

database.depan = zX

local categoryUrls = {
    IF = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/IF.txt",
    X = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/X.txt",
    NG = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/NG.txt",
    AI = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/AI.txt",
    KS = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/KS.txt",
    CY = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/CY.txt",
    UI = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/UI.txt",
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
    TT = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/tt.txt",
    ["SEMUA KATA SULIT"] = "https://raw.githubusercontent.com/DexterHUB99/DexterHUB/refs/heads/main/sulit.txt"
}

local polaAkhiran = {
    IF = "if$", X = "x$", NG = "ng$", AI = "ai$", KS = "ks$",
    CY = "cy$", UI = "ui$", LY = "ly$", GY = "gy$", LT = "lt$",
    EO = "eo$", OE = "oe$", EKS = "eks$", OO = "oo$", KN = "kn$",
    Q = "q$", MP = "mp$", SF = "sf$", TT = "tt$"
}

task.spawn(function()
    for cat, url in pairs(categoryUrls) do
        task.spawn(function()
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success and type(response) == "string" then
                database.belakang[cat] = database.belakang[cat] or {}
                local pola = polaAkhiran[cat]
                for word in string.gmatch(response, "[^\r\n]+") do
                    local cleanWord = (word:gsub("%s+", "")):lower()
                    if #cleanWord > 1 and string.match(cleanWord, "^%a+$") then
                        if cat == "SEMUA KATA SULIT" then
                            database.belakang.SEMUA = database.belakang.SEMUA or {}
                            table.insert(database.belakang.SEMUA, cleanWord)
                        elseif pola and string.match(cleanWord, pola) then
                            table.insert(database.belakang[cat], cleanWord)
                        end
                    end
                end
                print("🔥 Database " .. cat .. " loaded! (" .. #(database.belakang[cat] or {}) .. " kata)")
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
        database.depan = zX
        print("🔥 Kamus utama loaded! " .. #zX .. " kata")
    end
end)

-- ==============================================
-- SISTEM LOG DAN ANALISA
-- ==============================================

local currentGameLogs = {}
local allGameLogs = {}
local matchCounter = 0

local systemPatterns = {
    matches = {},
    pattern = {
        depan = 0, belakang = 0,
        huruf1 = 0, huruf2 = 0, huruf3 = 0
    }
}

-- ==============================================
-- LIVE LOG FLOATING
-- ==============================================

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
logHeaderTitle.Text = "📋 LIVE LOG EKSTRIM"
logHeaderTitle.TextColor3 = Color3.new(1, 1, 1)
logHeaderTitle.Font = Enum.Font.GothamBold
logHeaderTitle.TextSize = 11
logHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
logHeaderTitle.Parent = logHeader

local copyLogBtn = Instance.new("TextButton")
copyLogBtn.Size = UDim2.new(0, 40, 0, 20)
copyLogBtn.Position = UDim2.new(1, -45, 0.5, -10)
copyLogBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
copyLogBtn.Text = "COPY"
copyLogBtn.TextColor3 = Color3.new(1, 1, 1)
copyLogBtn.Font = Enum.Font.GothamBold
copyLogBtn.TextSize = 8
copyLogBtn.Parent = logHeader
Instance.new("UICorner", copyLogBtn).CornerRadius = UDim.new(0, 4)

-- ScrollingFrame log dengan UIListLayout (PERBAIKAN UTAMA)
local logFloatScroll = Instance.new("ScrollingFrame")
logFloatScroll.Size = UDim2.new(1, -10, 1, -38)
logFloatScroll.Position = UDim2.new(0, 5, 0, 33)
logFloatScroll.BackgroundTransparency = 1
logFloatScroll.ScrollBarThickness = 4
logFloatScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
logFloatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logFloatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFloatScroll.Parent = logFloating

-- UIListLayout di dalam scroll (KUNCI PERBAIKAN)
local logListLayout = Instance.new("UIListLayout")
logListLayout.Padding = UDim.new(0, 2)
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Parent = logFloatScroll

-- Padding scroll
local logScrollPad = Instance.new("UIPadding", logFloatScroll)
logScrollPad.PaddingTop = UDim.new(0, 2)
logScrollPad.PaddingBottom = UDim.new(0, 2)

-- ==============================================
-- FUNGSI UPDATE LOG (DIPERBAIKI TOTAL)
-- ==============================================

function updateLogDisplayFloating()
    -- Hapus semua item log lama (kecuali Layout dan Padding)
    for _, child in pairs(logFloatScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Tampilkan pesan kosong jika belum ada log
    if #currentGameLogs == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 40)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Menunggu soal... Match #" .. matchCounter
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 10
        emptyLabel.TextWrapped = true
        emptyLabel.LayoutOrder = 0
        emptyLabel.Parent = logFloatScroll
        return
    end

    -- Render setiap log entry
    for i, log in ipairs(currentGameLogs) do
        local bgColor = i % 2 == 0
            and Color3.fromRGB(25, 23, 35)
            or Color3.fromRGB(30, 28, 40)
        if log.tipe == "depan" then
            bgColor = Color3.fromRGB(35, 28, 48)
        end

        local logItem = Instance.new("Frame")
        logItem.Name = "LogItem_" .. i
        logItem.Size = UDim2.new(1, 0, 0, 26)
        logItem.BackgroundColor3 = bgColor
        logItem.BorderSizePixel = 0
        logItem.LayoutOrder = i
        logItem.Parent = logFloatScroll
        Instance.new("UICorner", logItem).CornerRadius = UDim.new(0, 4)

        -- Nomor urut
        local numLabel = Instance.new("TextLabel")
        numLabel.Size = UDim2.new(0, 18, 1, 0)
        numLabel.Position = UDim2.new(0, 2, 0, 0)
        numLabel.BackgroundTransparency = 1
        numLabel.Text = tostring(i)
        numLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
        numLabel.Font = Enum.Font.Gotham
        numLabel.TextSize = 8
        numLabel.Parent = logItem

        -- Waktu
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0, 44, 1, 0)
        timeLabel.Position = UDim2.new(0, 20, 0, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = log.time
        timeLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        timeLabel.Font = Enum.Font.Gotham
        timeLabel.TextSize = 8
        timeLabel.Parent = logItem

        -- Soal (huruf besar, warna ungu)
        local qLabel = Instance.new("TextLabel")
        qLabel.Size = UDim2.new(0, 28, 1, 0)
        qLabel.Position = UDim2.new(0, 66, 0, 0)
        qLabel.BackgroundTransparency = 1
        qLabel.Text = log.question
        qLabel.TextColor3 = Color3.fromRGB(200, 160, 255)
        qLabel.Font = Enum.Font.GothamBold
        qLabel.TextSize = 13
        qLabel.Parent = logItem

        -- Arrow
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 14, 1, 0)
        arrow.Position = UDim2.new(0, 96, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "→"
        arrow.TextColor3 = Color3.fromRGB(100, 100, 120)
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 10
        arrow.Parent = logItem

        -- Jawaban (potong kalau terlalu panjang)
        local jawabanTampil = #log.answer > 9
            and string.sub(log.answer, 1, 9) .. ".."
            or log.answer
        local aLabel = Instance.new("TextLabel")
        aLabel.Size = UDim2.new(1, -135, 1, 0)
        aLabel.Position = UDim2.new(0, 112, 0, 0)
        aLabel.BackgroundTransparency = 1
        aLabel.Text = jawabanTampil
        aLabel.TextColor3 = log.status == "✓"
            and Color3.fromRGB(80, 255, 120)
            or Color3.fromRGB(255, 80, 80)
        aLabel.Font = Enum.Font.GothamBold
        aLabel.TextSize = 10
        aLabel.TextXAlignment = Enum.TextXAlignment.Left
        aLabel.Parent = logItem

        -- Ikon tipe depan/belakang
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Size = UDim2.new(0, 18, 1, 0)
        typeLabel.Position = UDim2.new(1, -20, 0, 0)
        typeLabel.BackgroundTransparency = 1
        typeLabel.Text = log.tipe == "depan" and "⬆" or "⬇"
        typeLabel.TextColor3 = log.tipe == "depan"
            and Color3.fromRGB(255, 200, 80)
            or Color3.fromRGB(80, 180, 255)
        typeLabel.Font = Enum.Font.GothamBold
        typeLabel.TextSize = 11
        typeLabel.Parent = logItem
    end

    -- Auto scroll ke bawah (entry terbaru)
    task.defer(function()
        local contentSize = logListLayout.AbsoluteContentSize.Y
        local scrollSize = logFloatScroll.AbsoluteSize.Y
        if contentSize > scrollSize then
            logFloatScroll.CanvasPosition = Vector2.new(0, contentSize - scrollSize)
        end
    end)
end

-- ==============================================
-- FUNGSI addGameLog (DIPERBAIKI)
-- ==============================================

function addGameLog(question, answer, status, tipe)
    local timestamp = os.date("%H:%M:%S")
    local panjang = #question

    if tipe == "depan" then
        systemPatterns.pattern.depan = systemPatterns.pattern.depan + 1
    else
        systemPatterns.pattern.belakang = systemPatterns.pattern.belakang + 1
    end

    if panjang == 1 then
        systemPatterns.pattern.huruf1 = systemPatterns.pattern.huruf1 + 1
    elseif panjang == 2 then
        systemPatterns.pattern.huruf2 = systemPatterns.pattern.huruf2 + 1
    elseif panjang == 3 then
        systemPatterns.pattern.huruf3 = systemPatterns.pattern.huruf3 + 1
    end

    local logEntry = {
        time = timestamp,
        question = question:upper(),
        answer = answer:upper(),
        status = status or "✓",
        match = matchCounter,
        tipe = tipe or "belakang"
    }

    table.insert(currentGameLogs, logEntry)
    table.insert(allGameLogs, logEntry)
    table.insert(systemPatterns.matches, logEntry)

    -- Update UI di thread terpisah agar tidak blocking
    task.defer(function()
        updateLogDisplayFloating()
        if analisaLabel then
            updateAnalisaUI()
        end
    end)

    print("📝 [Match " .. matchCounter .. "] " .. question .. " → " .. answer .. " (" .. (tipe or "belakang") .. ")")
end

function newMatch()
    matchCounter = matchCounter + 1
    currentGameLogs = {}
    task.defer(function()
        updateLogDisplayFloating()
    end)
    print("🆕 Match " .. matchCounter .. " dimulai")
end

-- Fungsi copy log
function copyLiveLog()
    local textToCopy = "=== R4NzDev LIVE LOG EKSTRIM ===\n"
    textToCopy = textToCopy .. "Match #" .. matchCounter .. "\n"
    textToCopy = textToCopy .. string.rep("-", 40) .. "\n"
    textToCopy = textToCopy .. "Waktu   | Soal | Jawaban       | Tipe\n"
    textToCopy = textToCopy .. string.rep("-", 40) .. "\n"

    for i, log in ipairs(currentGameLogs) do
        textToCopy = textToCopy .. string.format("%s |  %s   | %-12s | %s\n",
            log.time, log.question, log.answer,
            log.tipe == "depan" and "DEPAN" or "BELAKANG")
    end

    textToCopy = textToCopy .. string.rep("-", 40) .. "\n"
    textToCopy = textToCopy .. "Total: " .. #currentGameLogs .. " jawaban\n"

    local total = systemPatterns.pattern.depan + systemPatterns.pattern.belakang
    if total > 0 then
        textToCopy = textToCopy .. "\n📊 ANALISA SISTEM:\n"
        textToCopy = textToCopy .. "Depan: " .. systemPatterns.pattern.depan .. "x\n"
        textToCopy = textToCopy .. "Belakang: " .. systemPatterns.pattern.belakang .. "x\n"
        textToCopy = textToCopy .. "1 huruf: " .. systemPatterns.pattern.huruf1 .. "x\n"
        textToCopy = textToCopy .. "2 huruf: " .. systemPatterns.pattern.huruf2 .. "x\n"
        textToCopy = textToCopy .. "3 huruf: " .. systemPatterns.pattern.huruf3 .. "x\n"
    end

    if setclipboard then
        setclipboard(textToCopy)
        copyLogBtn.Text = "✓"
        copyLogBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 30)
        task.delay(1.5, function()
            copyLogBtn.Text = "COPY"
            copyLogBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
        end)
    end
end

copyLogBtn.MouseButton1Click:Connect(copyLiveLog)

-- ==============================================
-- ANALISA UI DI MAIN PAGE
-- ==============================================

local analisaFrame = Instance.new("Frame")
analisaFrame.Size = UDim2.new(1, -4, 0, 100)
analisaFrame.LayoutOrder = 1
analisaFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
analisaFrame.Parent = mainPage
Instance.new("UICorner", analisaFrame).CornerRadius = UDim.new(0, 9)

local analisaLabel = Instance.new("TextLabel")
analisaLabel.Size = UDim2.new(1, -10, 1, -10)
analisaLabel.Position = UDim2.new(0, 5, 0, 5)
analisaLabel.BackgroundTransparency = 1
analisaLabel.Text = [[
🔍 ANALISA SISTEM ROBLOX:
   
📊 Match tercatat: 0
🎯 Mode: BELUM DETECT
📏 Pola huruf: -
⚡ Main dulu 5 match biar tau polanya
]]
analisaLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
analisaLabel.Font = Enum.Font.Gotham
analisaLabel.TextSize = 10
analisaLabel.TextXAlignment = Enum.TextXAlignment.Left
analisaLabel.Parent = analisaFrame

function updateAnalisaUI()
    local total = #systemPatterns.matches
    if total == 0 then
        analisaLabel.Text = [[
🔍 ANALISA SISTEM ROBLOX:
   
📊 Match tercatat: 0
🎯 Mode: MASI NGUMPULIN DATA
📏 Pola huruf: -
⚡ Main dulu 5 match biar tau polanya
]]
        return
    end

    local depan = systemPatterns.pattern.depan
    local belakang = systemPatterns.pattern.belakang
    local huruf1 = systemPatterns.pattern.huruf1
    local huruf2 = systemPatterns.pattern.huruf2
    local huruf3 = systemPatterns.pattern.huruf3

    local mode = belakang > depan and "HURUF BELAKANG" or "HURUF DEPAN"
    local persen = math.floor(math.max(depan, belakang) / total * 100)

    local polaHuruf = ""
    if huruf2 > huruf1 and huruf2 > huruf3 then
        polaHuruf = "2 HURUF (" .. huruf2 .. "x)"
    elseif huruf1 > huruf3 then
        polaHuruf = "1 HURUF (" .. huruf1 .. "x)"
    else
        polaHuruf = "3 HURUF (" .. huruf3 .. "x)"
    end

    analisaLabel.Text = string.format([[
🔍 ANALISA SISTEM ROBLOX:
   
📊 Match tercatat: %d
🎯 Mode: %s (%d%%)
📏 Pola huruf: %s
⚡ Depan: %dx | Belakang: %dx
]], total, mode, persen, polaHuruf, depan, belakang)
end

-- ==============================================
-- VARIABEL AUTO ANSWER
-- ==============================================

local autoTulisEnabled = false
local autoRejoinEnabled = true
local delayMin = 0.03
local delayMax = 0.08
local intervalMin = 0.15
local intervalMax = 0.5
local Sx = false
local tx = false
local NX = false
local qX = 0
local WX = 0
local JX = 3
local LX = false
local bX = false

local dropState = {
    IF = false, X = false, NG = false, AI = false, KS = false, CY = false, UI = false,
    LY = false, GY = false, LT = false, EO = false, OE = false, EKS = false, OO = false,
    KN = false, Q = false, MP = false, SF = false, TT = false,
    ["SEMUA KATA SULIT"] = false,
    ["SEMUA KATA EKSTRIM"] = false
}

local MX = {}

-- ==============================================
-- FUNGSI CARI KATA
-- ==============================================

function cariBerdasarkanAkhiran(soal, kategori)
    local panjangSoal = #soal
    local hasil = {}
    local databaseKategori = database.belakang[kategori] or {}
    for _, word in ipairs(databaseKategori) do
        if string.sub(word, -panjangSoal) == soal and not MX[word] then
            table.insert(hasil, word)
        end
    end
    return hasil
end

function cariBerdasarkanAwalan(soal)
    local panjangSoal = #soal
    local hasil = {}
    for _, word in ipairs(database.depan) do
        if string.sub(word, 1, panjangSoal) == soal and not MX[word] then
            table.insert(hasil, word)
        end
    end
    return hasil
end

-- ==============================================
-- FUNGSI simulateTyping (DIPERBAIKI)
-- ==============================================

function simulateTyping(text, totalLength)
    if not isRunning then return end

    if text == "" then
        -- Tidak ada yang perlu diketik, langsung Enter
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        return
    end

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

    task.wait(intervalMin + math.random() * (intervalMax - intervalMin))

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    task.wait(0.02)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

-- ==============================================
-- FUNGSI AUTO ANSWER gX() (DIPERBAIKI)
-- ==============================================

function gX()
    if not autoTulisEnabled or not isRunning or LX then return end
    LX = true

    local awalan = ""

    -- Scan semua TextLabel yang visible, cari soal (1-4 huruf)
    local playerGui = player:WaitForChild("PlayerGui")
    for _, obj in pairs(playerGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local text = (obj.Text:gsub("%s+", "")):lower()
            if #text >= 1 and #text <= 4 and string.match(text, "^%a+$") then
                -- Ambil yang paling pendek (kemungkinan soal)
                if awalan == "" or #text < #awalan then
                    awalan = text
                end
            end
        end
    end

    if awalan == "" then
        print("⚠️ Soal tidak terdeteksi!")
        task.wait(0.3)
        LX = false
        return
    end

    print("🔍 Soal terdeteksi: " .. awalan:upper())

    local candidates = {}
    local tipe = "belakang"

    -- 1. Cari di semua kategori yang aktif (berdasarkan akhiran)
    for cat, enabled in pairs(dropState) do
        if enabled and cat ~= "SEMUA KATA EKSTRIM" then
            local catWords = database.belakang[cat] or {}
            for _, word in ipairs(catWords) do
                if string.sub(word, -#awalan) == awalan and not MX[word] then
                    table.insert(candidates, word)
                end
            end
        end
    end

    -- 2. Fallback: cari di semua database.belakang
    if #candidates == 0 then
        for _, catWords in pairs(database.belakang) do
            if type(catWords) == "table" then
                for _, word in ipairs(catWords) do
                    if string.sub(word, -#awalan) == awalan and not MX[word] then
                        table.insert(candidates, word)
                    end
                end
            end
        end
    end

    -- 3. Fallback: cari berdasarkan awalan (database.depan)
    if #candidates == 0 then
        tipe = "depan"
        for _, word in ipairs(database.depan) do
            if string.sub(word, 1, #awalan) == awalan and not MX[word] then
                table.insert(candidates, word)
            end
        end
    end

    -- 4. Tidak ada kandidat sama sekali
    if #candidates == 0 then
        print("❌ Tidak ada kandidat untuk: " .. awalan:upper())
        task.wait(0.3)
        LX = false
        return
    end

    local selected = candidates[math.random(1, #candidates)]
    print("✅ Jawaban: " .. selected:upper() .. " | Soal: " .. awalan:upper() .. " | Mode: " .. tipe)

    -- Catat ke log
    addGameLog(awalan, selected, "✓", tipe)

    -- Tandai sudah dipakai
    MX[selected] = true

    -- Hitung bagian yang perlu diketik
    local kataTulis = ""
    if tipe == "belakang" then
        -- Soal adalah akhiran, jadi ketik huruf-huruf di DEPAN kata
        kataTulis = string.sub(selected, 1, #selected - #awalan)
    else
        -- Soal adalah awalan, jadi ketik huruf-huruf di BELAKANG kata
        kataTulis = string.sub(selected, #awalan + 1)
    end

    simulateTyping(kataTulis, #selected)

    task.wait(0.3)
    LX = false
end

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
                if not LX then
                    task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
                    task.spawn(gX)
                end
            elseif event == "Eliminated" or event == "EndMatch" or event == "HideMatchUI" then
                newMatch()
                startInstantRejoin()
            end
        end)
    end
end

-- Loop backup auto-answer (jika event remote tidak terpanggil)
task.spawn(function()
    while isRunning do
        if autoTulisEnabled and not LX then
            task.spawn(gX)
        end
        task.wait(1.5)
    end
end)

-- ==============================================
-- AUTO REJOIN
-- ==============================================

function startInstantRejoin()
    if not autoRejoinEnabled or bX then return end
    bX = true
    task.wait(1)

    pcall(function()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, false, game, 0)
    end)

    task.spawn(function()
        while bX and isRunning do
            if not autoRejoinEnabled then
                bX = false
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

-- ==============================================
-- UI TOGGLE
-- ==============================================

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
    knob.Position = defaultValue
        and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2)
        or UDim2.new(0, 3, 0.5, -knobSize / 2)
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
        knob.Position = state
            and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2)
            or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)

    return toggleFrame
end

createToggle("🔥 AUTO TULIS EKSTRIM", mainPage, false, function(val)
    autoTulisEnabled = val
    if autoTulisEnabled then
        task.wait(0.3)
        task.spawn(gX)
    end
end, 2)

createToggle("⚡ AUTO REJOIN", mainPage, true, function(val)
    autoRejoinEnabled = val
end, 3)

createToggle("🕠 MODE MANUSIA", mainPage, false, function(val)
    Sx = val
end, 4)

createToggle("👻 MODE TUYUL", mainPage, false, function(val)
    tx = val
    if not val then
        NX = false
        qX = 0
        WX = 0
    end
end, 5)

-- ==============================================
-- DROPDOWN KATEGORI
-- ==============================================

local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
dropBtn.LayoutOrder = 6
dropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
dropBtn.Text = "⪼  SET KATA EKSTRIM ⪼"
dropBtn.TextColor3 = Color3.new(1, 1, 1)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = TEXT_SIZE_SMALL
dropBtn.Parent = mainPage
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 9)

local dropBtnGrad = Instance.new("UIGradient", dropBtn)
dropBtnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120))
})

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.new(1, -4, 0, 0)
dropFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
dropFrame.ClipsDescendants = true
dropFrame.BorderSizePixel = 0
dropFrame.Parent = mainPage
dropFrame.LayoutOrder = 7

local dropStroke = Instance.new("UIStroke", dropFrame)
dropStroke.Color = Color3.fromRGB(80, 35, 160)
dropStroke.Thickness = 1
dropStroke.Transparency = 0.3

local categories = {
    "IF", "X", "NG", "AI", "KS", "CY", "UI", "LY", "GY", "LT",
    "EO", "OE", "EKS", "OO", "KN", "Q", "MP", "SF", "TT",
    "SEMUA KATA SULIT",
    "SEMUA KATA EKSTRIM"
}

local itemHeight = isTouch and 37 or 33
local isDropOpen = false

function refreshDropUI()
    for i, child in pairs(dropFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for i, cat in ipairs(categories) do
        local isAllSelected = (dropState["SEMUA KATA SULIT"] or dropState["SEMUA KATA EKSTRIM"])
            and cat ~= "SEMUA KATA SULIT" and cat ~= "SEMUA KATA EKSTRIM"
        local isSelected = dropState[cat]

        local catBtn = Instance.new("TextButton")
        catBtn.Size = UDim2.new(1, -12, 0, isTouch and 32 or 28)
        catBtn.Position = UDim2.new(0, 6, 0, (i - 1) * itemHeight + 5)
        catBtn.BackgroundColor3 = isAllSelected and Color3.fromRGB(25, 22, 36)
            or isSelected and Color3.fromRGB(80, 30, 170)
            or Color3.fromRGB(28, 25, 42)

        if cat == "SEMUA KATA EKSTRIM" then
            catBtn.BackgroundColor3 = isSelected and Color3.fromRGB(180, 40, 80) or Color3.fromRGB(80, 20, 40)
        end

        catBtn.Text = (isSelected and "✔  " or "   ") .. cat
        catBtn.TextColor3 = isAllSelected and Color3.fromRGB(70, 65, 90)
            or isSelected and Color3.new(1, 1, 1)
            or Color3.fromRGB(160, 150, 190)
        catBtn.Font = Enum.Font.GothamBold
        catBtn.TextSize = TEXT_SIZE_SMALL
        catBtn.TextXAlignment = Enum.TextXAlignment.Left
        catBtn.Parent = dropFrame
        Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 7)

        local catPad = Instance.new("UIPadding", catBtn)
        catPad.PaddingLeft = UDim.new(0, 8)

        catBtn.MouseButton1Click:Connect(function()
            if isAllSelected then return end
            playClickSound()

            if cat == "SEMUA KATA SULIT" then
                dropState["SEMUA KATA SULIT"] = not dropState["SEMUA KATA SULIT"]
                if dropState["SEMUA KATA SULIT"] then
                    for c, _ in pairs(dropState) do
                        if c ~= "SEMUA KATA SULIT" and c ~= "SEMUA KATA EKSTRIM" then
                            dropState[c] = false
                        end
                    end
                    dropState["SEMUA KATA EKSTRIM"] = false
                end

            elseif cat == "SEMUA KATA EKSTRIM" then
                dropState["SEMUA KATA EKSTRIM"] = not dropState["SEMUA KATA EKSTRIM"]
                if dropState["SEMUA KATA EKSTRIM"] then
                    dropState.IF = true; dropState.X = true; dropState.NG = true
                    dropState.AI = true; dropState.KS = true; dropState.CY = true
                    dropState.UI = true; dropState.LY = true; dropState.GY = true
                    dropState.LT = true; dropState.EO = true; dropState.OE = true
                    dropState.EKS = true; dropState.OO = true; dropState.KN = true
                    dropState.Q = true; dropState.MP = true; dropState.SF = true
                    dropState.TT = true
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
    dropBtn.Text = isDropOpen and "⪼  SET KATA EKSTRIM ⪻" or "⪼  SET KATA EKSTRIM ⪼"
    dropFrame:TweenSize(UDim2.new(1, -4, 0, isDropOpen and (#categories * itemHeight + 10) or 0), "Out", "Quart", 0.3, true)
    refreshDropUI()
end)

-- ==============================================
-- TEMA DROPDOWN
-- ==============================================

local themeDropBtn = Instance.new("TextButton")
themeDropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
themeDropBtn.LayoutOrder = 8
themeDropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
themeDropBtn.Text = "🎨 PILIH TEMA WARNA"
themeDropBtn.TextColor3 = Color3.new(1, 1, 1)
themeDropBtn.Font = Enum.Font.GothamBold
themeDropBtn.TextSize = TEXT_SIZE_SMALL
themeDropBtn.Parent = mainPage
Instance.new("UICorner", themeDropBtn).CornerRadius = UDim.new(0, 9)

local themeDropGrad = Instance.new("UIGradient", themeDropBtn)
themeDropGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120))
})

local themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(1, -4, 0, 0)
themeFrame.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
themeFrame.ClipsDescendants = true
themeFrame.BorderSizePixel = 0
themeFrame.Parent = mainPage
themeFrame.LayoutOrder = 9

local themeStroke = Instance.new("UIStroke", themeFrame)
themeStroke.Color = Color3.fromRGB(80, 35, 160)
themeStroke.Thickness = 1
themeStroke.Transparency = 0.3

local themes_list = { "CYBERPUNK", "CRIMSON", "MATRIX", "SAKURA", "OCEAN", "FLAME" }
local themeItemHeight = isTouch and 32 or 28
local isThemeOpen = false

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

-- ==============================================
-- NAVIGASI HALAMAN
-- ==============================================

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

tabNyawa.MouseButton1Click:Connect(function()
    showPage(nyawaPage)
    setActiveTab(tabNyawa)
    playClickSound()
end)

closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if _G[scriptKey] then
        _G[scriptKey]()
    end
end)

-- ==============================================
-- DRAG WINDOW
-- ==============================================

local isDragging = false
local dragStart, dragPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
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
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = mainFrame.AbsoluteSize
    newX = math.clamp(newX, 10, viewportSize.X - frameSize.X - 10)
    newY = math.clamp(newY, 10, viewportSize.Y - frameSize.Y - 10)
    mainFrame.Position = UDim2.new(0, newX, 0, newY)
    glowFrame.Position = UDim2.new(0, newX - 2, 0, newY - 2)
    resizeHandle.Position = UDim2.new(0, newX + frameSize.X - 24, 0, newY + frameSize.Y - 24)
    logFloating.Position = UDim2.new(1, -290, 0, 10)
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
        isDragging = true
        dragStart = input.Position
        dragPosition = mainFrame.Position
    end
end)

-- ==============================================
-- RESIZE WINDOW
-- ==============================================

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

UserInputService.InputChanged:Connect(function(input, processed)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        local newWidth = math.max(startWidth + delta.X, isTouch and 260 or 300)
        local newHeight = math.max(startHeight + delta.Y, isTouch and 200 or 230)
        newWidth, newHeight = clampWindow(newWidth, newHeight)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        local pos = mainFrame.Position
        glowFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 2, pos.Y.Scale, pos.Y.Offset - 2)
        glowFrame.Size = UDim2.new(0, newWidth + 4, 0, newHeight + 4)
        resizeHandle.Position = UDim2.new(pos.X.Scale, pos.X.Offset + newWidth - 24, pos.Y.Scale, pos.Y.Offset + newHeight - 24)
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if mainFrame.Visible then
        local pos = mainFrame.Position
        local size = mainFrame.Size
        resizeHandle.Position = UDim2.new(pos.X.Scale, pos.X.Offset + size.X.Offset - 24, pos.Y.Scale, pos.Y.Offset + size.Y.Offset - 24)
    end
end)

-- ==============================================
-- DEBUG OVERLAY
-- ==============================================

local debugFrame = Instance.new("Frame")
debugFrame.Size = UDim2.new(1, 0, 0, 200)
debugFrame.Position = UDim2.new(0, 0, 1, -200)
debugFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
debugFrame.BackgroundTransparency = 0.6
debugFrame.BorderSizePixel = 0
debugFrame.ZIndex = 100
debugFrame.Parent = screenGui

local debugText = Instance.new("TextLabel")
debugText.Size = UDim2.new(1, -10, 1, -10)
debugText.Position = UDim2.new(0, 5, 0, 5)
debugText.BackgroundTransparency = 1
debugText.TextColor3 = Color3.new(1, 1, 0)
debugText.TextWrapped = true
debugText.TextXAlignment = Enum.TextXAlignment.Left
debugText.TextYAlignment = Enum.TextYAlignment.Top
debugText.Font = Enum.Font.Code
debugText.TextSize = 12
debugText.Text = "=== DEBUG OUTPUT ===\n"
debugText.ZIndex = 101
debugText.Parent = debugFrame

local oldPrint = print
print = function(...)
    local args = {...}
    local str = ""
    for i, v in ipairs(args) do
        str = str .. tostring(v) .. " "
    end
    oldPrint(str)
    debugText.Text = debugText.Text .. "\n" .. str
    local lines = {}
    for line in debugText.Text:gmatch("[^\n]+") do
        table.insert(lines, line)
    end
    if #lines > 30 then
        table.remove(lines, 1)
        table.remove(lines, 1)
        debugText.Text = table.concat(lines, "\n")
    end
end

-- ==============================================
-- INFO PAGE
-- ==============================================

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, -20, 0, 30)
infoTitle.Position = UDim2.new(0, 10, 0, 10)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "📋 R4NzDev EKSTRIM v3.0"
infoTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 16
infoTitle.Parent = infoPage

local infoDesc = Instance.new("TextLabel")
infoDesc.Size = UDim2.new(1, -20, 0, 240)
infoDesc.Position = UDim2.new(0, 10, 0, 50)
infoDesc.BackgroundTransparency = 1
infoDesc.Text = [[
🔥 FITUR EKSTRIM:
• Fokus HURUF BELAKANG (bukan depan!)
• Support semua kategori: IF, X, NG, AI, KS, CY, UI, LY, GY, LT, EO, OE, EKS, OO, KN, Q, MP, SF, TT
• Tombol "SEMUA KATA EKSTRIM" untuk aktifkan semua
• Deteksi otomatis 1,2,3 huruf
• Live log floating + COPY (auto scroll ke terbaru)
• Analisa pola sistem Roblox
• Auto rejoin cepat
• Mode manusia & tuyul
• 6 tema warna

CARA PAKAI:
1. Aktifkan AUTO TULIS EKSTRIM
2. Pilih kategori di dropdown
3. Mainkan game, lihat live log
4. Klik COPY untuk menyalin log

Dibuat oleh R4NzDev
]]
infoDesc.TextColor3 = Color3.fromRGB(180, 170, 210)
infoDesc.Font = Enum.Font.Gotham
infoDesc.TextSize = 12
infoDesc.TextWrapped = true
infoDesc.TextXAlignment = Enum.TextXAlignment.Left
infoDesc.Parent = infoPage

-- ==============================================
-- INISIALISASI
-- ==============================================

logFloating.Position = UDim2.new(1, -290, 0, 10)
updateLogDisplayFloating()

print("✅ R4NzDev EKSTRIM v3.0 berhasil dimuat!")
print("🔥 Log live aktif — jawab soal untuk melihat hasil")
print("📋 Klik COPY di log untuk menyalin semua jawaban")