local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local okVIM, VirtualInputManager = pcall(function()
    return game:GetService("VirtualInputManager")
end)

local player = Players.LocalPlayer
if not player then
    warn("❌ LocalPlayer tidak ditemukan")
    return
end

local scriptKey = "R4NzDev_v3_EKSTRIM"

local GuiParent = CoreGui
pcall(function()
    if gethui then
        GuiParent = gethui()
    end
end)

if GuiParent:FindFirstChild("R4NzDev") then
    warn("⚠️ R4NzDev sudah berjalan! Tutup dulu sebelum execute ulang.")
    return
end

local isRunning = true
local startInstantRejoin
local updateAnalisaUI
local analisaLabel

_G[scriptKey] = function()
    isRunning = false
    local old = GuiParent:FindFirstChild("R4NzDev")
    if old then
        old:Destroy()
    end
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        local gui = CoreGui:FindFirstChild("RobloxGui")
        if gui and gui:IsA("ScreenGui") then
            -- sengaja tidak di-disable agar tidak bentrok UI
        end
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

local function isTouchOrMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function playClickSound()
    local ok, err = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1396568322785649"
        sound.Volume = 0.3
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 1)
    end)
    if not ok then
        warn("Sound error:", err)
    end
end

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

local glowFrame
local mainFrame
local header
local headerLine
local headerDot
local resizeHandle
local logFloatStroke
local logHeader
local sideDivider

local function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    currentTheme = themeName

    pcall(function()
        if glowFrame then glowFrame.BackgroundColor3 = theme.glow end
        if header then header.BackgroundColor3 = theme.headerBg end
        if headerLine then headerLine.BackgroundColor3 = theme.accent end
        if headerDot then headerDot.BackgroundColor3 = theme.accent end
        if resizeHandle then
            resizeHandle.BackgroundColor3 = theme.mid
            resizeHandle.TextColor3 = theme.accent
        end
        if logFloatStroke then logFloatStroke.Color = theme.glow end
        if logHeader then logHeader.BackgroundColor3 = theme.headerBg end
        if sideDivider then sideDivider.BackgroundColor3 = theme.mid end
    end)

    print("🎨 Tema diterapkan: " .. themeName)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

local okParent, parentErr = pcall(function()
    screenGui.Parent = GuiParent
end)

if not okParent then
    warn("❌ Gagal pasang GUI:", parentErr)
    return
end

glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2)-2, 0.5, -(HEIGHT/2)-2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = 0
glowFrame.Parent = screenGui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 18)

mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

resizeHandle = Instance.new("TextButton")
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

resizeHandle.Position = UDim2.new(
    0, mainFrame.Position.X.Offset + mainFrame.Size.X.Offset - 24,
    0, mainFrame.Position.Y.Offset + mainFrame.Size.Y.Offset - 24
)

header = Instance.new("Frame")
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

headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
headerLine.BorderSizePixel = 0
headerLine.Parent = header

headerDot = Instance.new("Frame")
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

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -HEADER_HEIGHT)
sidebar.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

sideDivider = Instance.new("Frame")
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

local function createTabBtn(btnText, btnIcon, order)
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

local function setActiveTab(activeBtn)
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

local function createPage()
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

local zX = {
    "abad","abadi","abang","abjad","acara","adalah","adanya","adapun","adaptasi",
    "adat","adegan","adil","aduk","agama","agar","agen","agung","ahad","ahli",
    "air","ajak","ajar","ajeg","akad","akal","akan","akar","akhir","akhlak",
    "akibat","akrab","aksara","aksi","aku","akun","akurat","alam","alamat",
    "alang","alas","alat","album","ali","alias","alih","alim","alir","alis",
    "alun","alur","amal","aman","ambil","ampuh","angin","angka","angkat",
    "antar","apel","arah","atas","atau","atap","atlet","awal","awas","ayam"
}

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

local MX = {}

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
            local success, res = pcall(function()
                return game:HttpGet(url)
            end)
            if success and type(res) == "string" and #res > 0 then
                dropData[cat] = {}
                for word in res:gmatch("[^\r\n]+") do
                    local w = word:gsub("%s+",""):lower()
                    if #w > 1 and w:match("^%a+$") then
                        table.insert(dropData[cat], w)
                    end
                end
                print("✅ "..cat.." loaded: "..#dropData[cat].." kata")
            else
                warn("❌ Gagal load kategori:", cat)
            end
        end)
    end
end)

task.spawn(function()
    local success, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/DexterHUB99/Cari-Kata/refs/heads/main/kamus.txt")
    end)
    if success and type(res) == "string" and #res > 1000 then
        zX = {}
        for word in res:gmatch("[^\r\n]+") do
            local w = word:gsub("%s+",""):lower()
            if #w > 1 and w:match("^%a+$") then
                table.insert(zX, w)
            end
        end
        for i = #zX, 2, -1 do
            local j = math.random(i)
            zX[i], zX[j] = zX[j], zX[i]
        end
        print("✅ Kamus utama loaded: "..#zX.." kata")
    else
        warn("❌ Gagal load kamus utama")
    end
end)

local currentGameLogs = {}
local allGameLogs = {}
local matchCounter = 0
local systemPatterns = {
    matches = {},
    pattern = { depan=0, belakang=0, huruf1=0, huruf2=0, huruf3=0 }
}

local logFloating = Instance.new("Frame")
logFloating.Name = "LogFloating"
logFloating.Size = UDim2.new(0, 280, 0, 220)
logFloating.Position = UDim2.new(1, -290, 0, 10)
logFloating.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
logFloating.BorderSizePixel = 0
logFloating.Parent = screenGui
Instance.new("UICorner", logFloating).CornerRadius = UDim.new(0, 8)

logFloatStroke = Instance.new("UIStroke", logFloating)
logFloatStroke.Color = Color3.fromRGB(100, 40, 200)
logFloatStroke.Thickness = 1.5

logHeader = Instance.new("Frame")
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

local logFloatScroll = Instance.new("ScrollingFrame")
logFloatScroll.Size = UDim2.new(1, -10, 1, -38)
logFloatScroll.Position = UDim2.new(0, 5, 0, 33)
logFloatScroll.BackgroundTransparency = 1
logFloatScroll.ScrollBarThickness = 4
logFloatScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
logFloatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logFloatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFloatScroll.Parent = logFloating

local logListLayout = Instance.new("UIListLayout")
logListLayout.Padding = UDim.new(0, 2)
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Parent = logFloatScroll

local logScrollPad = Instance.new("UIPadding", logFloatScroll)
logScrollPad.PaddingTop = UDim.new(0, 2)
logScrollPad.PaddingBottom = UDim.new(0, 2)

local function updateLogDisplayFloating()
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
        local bgColor = i % 2 == 0 and Color3.fromRGB(25, 23, 35) or Color3.fromRGB(30, 28, 40)

        local logItem = Instance.new("Frame")
        logItem.Name = "LogItem_"..i
        logItem.Size = UDim2.new(1, 0, 0, 26)
        logItem.BackgroundColor3 = bgColor
        logItem.BorderSizePixel = 0
        logItem.LayoutOrder = i
        logItem.Parent = logFloatScroll
        Instance.new("UICorner", logItem).CornerRadius = UDim.new(0, 4)

        local numLbl = Instance.new("TextLabel")
        numLbl.Size = UDim2.new(0, 18, 1, 0)
        numLbl.Position = UDim2.new(0, 2, 0, 0)
        numLbl.BackgroundTransparency = 1
        numLbl.Text = tostring(i)
        numLbl.TextColor3 = Color3.fromRGB(100, 100, 120)
        numLbl.Font = Enum.Font.Gotham
        numLbl.TextSize = 8
        numLbl.Parent = logItem

        local timeLbl = Instance.new("TextLabel")
        timeLbl.Size = UDim2.new(0, 44, 1, 0)
        timeLbl.Position = UDim2.new(0, 20, 0, 0)
        timeLbl.BackgroundTransparency = 1
        timeLbl.Text = log.time
        timeLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        timeLbl.Font = Enum.Font.Gotham
        timeLbl.TextSize = 8
        timeLbl.Parent = logItem

        local qLbl = Instance.new("TextLabel")
        qLbl.Size = UDim2.new(0, 30, 1, 0)
        qLbl.Position = UDim2.new(0, 66, 0, 0)
        qLbl.BackgroundTransparency = 1
        qLbl.Text = log.question
        qLbl.TextColor3 = Color3.fromRGB(200, 160, 255)
        qLbl.Font = Enum.Font.GothamBold
        qLbl.TextSize = 13
        qLbl.Parent = logItem

        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 14, 1, 0)
        arrow.Position = UDim2.new(0, 98, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "→"
        arrow.TextColor3 = Color3.fromRGB(100, 100, 120)
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 10
        arrow.Parent = logItem

        local jawabanTampil = #log.answer > 9 and log.answer:sub(1, 9)..".." or log.answer

        local aLbl = Instance.new("TextLabel")
        aLbl.Size = UDim2.new(1, -135, 1, 0)
        aLbl.Position = UDim2.new(0, 114, 0, 0)
        aLbl.BackgroundTransparency = 1
        aLbl.Text = jawabanTampil
        aLbl.TextColor3 = log.status == "✓" and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80)
        aLbl.Font = Enum.Font.GothamBold
        aLbl.TextSize = 10
        aLbl.TextXAlignment = Enum.TextXAlignment.Left
        aLbl.Parent = logItem

        local srcLbl = Instance.new("TextLabel")
        srcLbl.Size = UDim2.new(0, 22, 1, 0)
        srcLbl.Position = UDim2.new(1, -24, 0, 0)
        srcLbl.BackgroundTransparency = 1
        srcLbl.Text = log.src == "SKAKMAT★" and "⚔★"
                   or log.src == "SKAKMAT" and "⚔"
                   or log.src == "CAT" and "★"
                   or "·"
        srcLbl.TextColor3 = (log.src == "SKAKMAT★") and Color3.fromRGB(255, 80, 80)
                         or (log.src == "SKAKMAT") and Color3.fromRGB(255, 140, 50)
                         or (log.src == "CAT") and Color3.fromRGB(255, 200, 80)
                         or Color3.fromRGB(120, 120, 140)
        srcLbl.Font = Enum.Font.GothamBold
        srcLbl.TextSize = 10
        srcLbl.Parent = logItem
    end

    task.defer(function()
        local contentSize = logListLayout.AbsoluteContentSize.Y
        local scrollSize = logFloatScroll.AbsoluteSize.Y
        if contentSize > scrollSize then
            logFloatScroll.CanvasPosition = Vector2.new(0, contentSize - scrollSize)
        end
    end)
end

local function addGameLog(question, answer, status, src)
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
        if analisaLabel and updateAnalisaUI then
            updateAnalisaUI()
        end
    end)

    print("📝 ["..question:upper().."] → ["..answer:upper().."] ("..(src or "KBB")..")")
end

local function newMatch()
    matchCounter = matchCounter + 1
    currentGameLogs = {}
    MX = {}
    task.defer(updateLogDisplayFloating)
    print("🆕 Match "..matchCounter.." dimulai — MX direset")
end

local function copyLiveLog()
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

updateAnalisaUI = function()
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
local skakmatEnabled = false

local kataRandom = {"wkwk","receh","noob","lemah","kasian","santuy","ezz","lol","mudah","ajib"}

local polaAkhiranKat = {
    IF  = "if$",  X   = "x$",   NG  = "ng$",  AI  = "ai$",
    KS  = "ks$",  CY  = "cy$",  UI  = "ui$",  LY  = "ly$",
    GY  = "gy$",  LT  = "lt$",  EO  = "eo$",  OE  = "oe$",
    EKS = "eks$", OO  = "oo$",  KN  = "kn$",  Q   = "q$",
    MP  = "mp$",  SF  = "sf$",  TT  = "tt$"
}

local function isKataSkakmat(word)
    for cat, pola in pairs(polaAkhiranKat) do
        if word:match(pola) then
            return true, cat
        end
    end
    return false, nil
end

local function cariKataByAwalan(awalan)
    local panjang = #awalan

    local skakmatCat  = {}
    local skakmatKBB  = {}
    local biasaCat    = {}
    local biasaKBB    = {}

    for cat, enabled in pairs(dropState) do
        if enabled and cat ~= "SEMUA KATA EKSTRIM" then
            local pool = dropData[cat] or {}
            for _, word in ipairs(pool) do
                if #word > panjang and word:sub(1, panjang) == awalan and not MX[word] then
                    local isSkak = isKataSkakmat(word)
                    if isSkak then
                        table.insert(skakmatCat, {word=word, src="SKAKMAT"})
                    else
                        table.insert(biasaCat, {word=word, src="CAT"})
                    end
                end
            end
        end
    end

    for _, word in ipairs(zX) do
        if #word > panjang and word:sub(1, panjang) == awalan and not MX[word] then
            local isSkak = isKataSkakmat(word)
            if isSkak then
                table.insert(skakmatKBB, {word=word, src="SKAKMAT"})
            else
                table.insert(biasaKBB, {word=word, src="KBB"})
            end
        end
    end

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
        if #biasaCat > 0 or #skakmatCat > 0 then
            local pool = {}
            for _, v in ipairs(skakmatCat) do table.insert(pool, v) end
            for _, v in ipairs(biasaCat) do table.insert(pool, v) end
            return pool, "CAT"
        else
            local pool = {}
            for _, v in ipairs(skakmatKBB) do table.insert(pool, v) end
            for _, v in ipairs(biasaKBB) do table.insert(pool, v) end
            return pool, "KBB"
        end
    end
end

local function simulateTyping(text)
    if not okVIM or not VirtualInputManager then
        warn("⚠️ VirtualInputManager tidak tersedia")
        return
    end

    if not isRunning then
        return
    end

    text = text or ""

    if text == "" then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        return
    end

    if Sx then
        local errorsDone = 0
        local errorCount = math.random(1, 2)
        local i = 1

        while i <= #text do
            if not isRunning then return end

            if errorsDone < errorCount and i > 1 and math.random() < 0.12 then
                errorsDone += 1
                task.wait(math.random() * 0.5 + 0.15)
                local rch = "QWERTYUIOPASDFGHJKLZXCVBNM"
                local typoCount = math.random(1, 2)

                for _ = 1, typoCount do
                    local idx = math.random(1, #rch)
                    local rc = rch:sub(idx, idx)
                    local kc = Enum.KeyCode[rc]
                    if kc then
                        VirtualInputManager:SendKeyEvent(true, kc, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, kc, false, game)
                        task.wait(delayMin + math.random() * (delayMax - delayMin))
                    end
                end

                task.wait(0.08 + math.random() * 0.15)

                for _ = 1, typoCount do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.04)
                end
            end

            local ch = text:sub(i, i):upper()
            local kc = Enum.KeyCode[ch]
            if kc then
                VirtualInputManager:SendKeyEvent(true, kc, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, kc, false, game)
                task.wait(delayMin + math.random() * (delayMax - delayMin))
            end

            i += 1
        end
    else
        for i = 1, #text do
            if not isRunning then return end
            local ch = text:sub(i, i):upper()
            local kc = Enum.KeyCode[ch]
            if kc then
                VirtualInputManager:SendKeyEvent(true, kc, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, kc, false, game)
                task.wait(delayMin + math.random() * (delayMax - delayMin))
            end
        end
    end

    task.wait(intervalMin + math.random() * (intervalMax - intervalMin))
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    task.wait(0.02)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function detectAwalan()
    local awalan = ""
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return "" end

    for _, obj in pairs(playerGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible and obj.Text then
            local raw = obj.Text:gsub("%s+",""):lower()
            if #raw >= 1 and #raw <= 4 and raw:match("^%a+$") then
                if awalan == "" or #raw < #awalan then
                    awalan = raw
                end
            end
        end
    end

    return awalan
end

local function gX()
    if not autoTulisEnabled or not isRunning or LX then return end
    LX = true

    if tx and NX then
        local awalan = detectAwalan()
        if awalan ~= "" and okVIM and VirtualInputManager then
            if uiElements.LogAwalan then
                uiElements.LogAwalan.Text = "👻 SPAM "..(WX + 1).."/2"
            end

            for i = 1, #awalan do
                local char = awalan:sub(i, i):upper()
                local kc = Enum.KeyCode[char]
                if kc then
                    VirtualInputManager:SendKeyEvent(true, kc, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, kc, false, game)
                    task.wait(0.01)
                end
            end

            local rch = {"A","Q","X","Z","J","V"}
            for _ = 1, 2 do
                local kc = Enum.KeyCode[rch[math.random(1, #rch)]]
                if kc then
                    VirtualInputManager:SendKeyEvent(true, kc, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, kc, false, game)
                    task.wait(0.01)
                end
            end

            task.wait(intervalMin + math.random()*(intervalMax-intervalMin))
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end

        WX = WX + 1
        if WX >= 2 then
            NX = false
            WX = 0
            qX = 0
            if uiElements.tuyulStatus then
                uiElements.tuyulStatus.Text = "Siap: 0/"..JX.." jawaban"
                uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
            end
        end

        task.wait(0.3)
        LX = false
        return
    end

    local awalan = detectAwalan()

    if awalan == "" then
        print("⚠️ Soal tidak terdeteksi!")
        task.wait(0.3)
        LX = false
        return
    end

    if uiElements.LogAwalan then
        uiElements.LogAwalan.Text = "AWALAN: "..awalan:upper()
    end

    print("🔍 Soal terdeteksi: "..awalan:upper())

    local candidates = cariKataByAwalan(awalan)

    if not candidates or #candidates == 0 then
        print("❌ Tidak ada kandidat untuk: "..awalan:upper())
        if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end
        if uiElements.LogIsi then uiElements.LogIsi.Text = "❌ Tidak ditemukan" end
        task.wait(0.5)
        LX = false
        return
    end

    local picked = candidates[math.random(1, #candidates)]
    local selectedWord = picked.word
    local srcTag = picked.src

    local isSkak = isKataSkakmat(selectedWord)
    if uiElements.LogAwalan then
        local skakLabel = isSkak and " ⚔SKAKMAT" or ""
        uiElements.LogAwalan.Text = "AWALAN: "..awalan:upper()..skakLabel
    end

    print("✅ Jawaban: "..selectedWord:upper().." | Soal: "..awalan:upper().." | Src: "..srcTag)

    if uiElements.LogIsi then
        uiElements.LogIsi.Text = selectedWord:upper()
    end

    addGameLog(awalan, selectedWord, "✓", srcTag)

    MX[selectedWord] = true

    local sisaHuruf = selectedWord:sub(#awalan + 1)
    simulateTyping(sisaHuruf)

    if tx and not NX then
        qX = qX + 1
        if uiElements.tuyulStatus then
            uiElements.tuyulStatus.Text = "Benar: "..qX.."/"..JX.." → "..(JX-qX).."x lagi"
            uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
        end
        if qX >= JX then
            NX = true
            WX = 0
            if uiElements.tuyulStatus then
                uiElements.tuyulStatus.Text = "👻 SPAM MODE AKTIF!"
                uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end
    end

    task.wait(0.3)
    if uiElements.LogAwalan then uiElements.LogAwalan.Text = "AWALAN: -" end
    if uiElements.LogIsi then uiElements.LogIsi.Text = "-" end
    LX = false
end

task.spawn(function()
    while isRunning do
        if autoTulisEnabled and not LX then
            task.spawn(gX)
        end
        task.wait(1.5)
    end
end)

local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if remotes then
    local matchUIRemote = remotes:FindFirstChild("MatchUI")
    if matchUIRemote and matchUIRemote:IsA("RemoteEvent") then
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
                NX = false
                WX = 0
                qX = 0
                if uiElements.tuyulStatus then
                    uiElements.tuyulStatus.Text = "Siap: 0/"..JX.." jawaban"
                    uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
                end
                if startInstantRejoin then
                    startInstantRejoin()
                end
            end
        end)
    end
end

startInstantRejoin = function()
    if not autoRejoinEnabled or bX then return end
    if not okVIM or not VirtualInputManager then
        warn("⚠️ VirtualInputManager tidak tersedia untuk rejoin")
        return
    end

    bX = true
    task.wait(1)

    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            local vs = cam.ViewportSize
            VirtualInputManager:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, false, game, 0)
        end
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

local function createToggle(label, parent, defaultValue, callback, order)
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
    knob.Position = defaultValue and UDim2.new(1, -(ks+3), 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2)
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
        knob.Position = state and UDim2.new(1, -(ks+3), 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2)
        playClickSound()
        callback(state)
    end)

    return f
end

createToggle("🔥 AUTO TULIS", mainPage, false, function(val)
    autoTulisEnabled = val
    if val then
        task.wait(0.3)
        task.spawn(gX)
        if uiElements.LogAwalan then
            uiElements.LogAwalan.Text = "AWALAN: Menunggu soal..."
        end
    end
end, 2)

createToggle("⚡ AUTO REJOIN", mainPage, true, function(val)
    autoRejoinEnabled = val
end, 3)

createToggle("🕠 MODE MANUSIA", mainPage, false, function(val)
    Sx = val
end, 4)

createToggle("⚔ MODE SKAKMAT", mainPage, false, function(val)
    skakmatEnabled = val
    if uiElements.skakmatStatus then
        if val then
            uiElements.skakmatStatus.Text = "ON — Kata akhiran sulit diprioritaskan"
            uiElements.skakmatStatus.TextColor3 = Color3.fromRGB(255, 100, 50)
        else
            uiElements.skakmatStatus.Text = "OFF — Pakai kata biasa"
            uiElements.skakmatStatus.TextColor3 = Color3.fromRGB(130, 130, 160)
        end
    end
end, 5)

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
    if not val then
        NX = false
        qX = 0
        WX = 0
        if uiElements.tuyulStatus then
            uiElements.tuyulStatus.Text = "STATUS: OFF"
            uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    else
        if uiElements.tuyulStatus then
            uiElements.tuyulStatus.Text = "Siap: 0/"..JX.." jawaban"
            uiElements.tuyulStatus.TextColor3 = Color3.fromRGB(180, 80, 255)
        end
    end
end, 7)

local speedPanel = Instance.new("Frame")
speedPanel.Size = UDim2.new(1, -4, 0, 140)
speedPanel.LayoutOrder = 8
speedPanel.BackgroundColor3 = Color3.fromRGB(12, 11, 20)
speedPanel.BorderSizePixel = 0
speedPanel.Parent = mainPage
Instance.new("UICorner", speedPanel).CornerRadius = UDim.new(0, 11)

local speedHeader = Instance.new("TextLabel")
speedHeader.Size = UDim2.new(1, -12, 0, 26)
speedHeader.Position = UDim2.new(0, 12, 0, 5)
speedHeader.BackgroundTransparency = 1
speedHeader.Text = "⚡ SPEED SETTINGS"
speedHeader.TextColor3 = Color3.fromRGB(180, 140, 255)
speedHeader.Font = Enum.Font.GothamBold
speedHeader.TextSize = 10
speedHeader.TextXAlignment = Enum.TextXAlignment.Left
speedHeader.Parent = speedPanel

local delayMinLabel = Instance.new("TextLabel")
delayMinLabel.Size = UDim2.new(0.5, -10, 0, 20)
delayMinLabel.Position = UDim2.new(0, 12, 0, 35)
delayMinLabel.BackgroundTransparency = 1
delayMinLabel.Text = "⌨ Delay Min: "..string.format("%.2fs", delayMin)
delayMinLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayMinLabel.Font = Enum.Font.Gotham
delayMinLabel.TextSize = 9
delayMinLabel.TextXAlignment = Enum.TextXAlignment.Left
delayMinLabel.Parent = speedPanel

local delayMaxLabel = Instance.new("TextLabel")
delayMaxLabel.Size = UDim2.new(0.5, -10, 0, 20)
delayMaxLabel.Position = UDim2.new(0.5, -5, 0, 35)
delayMaxLabel.BackgroundTransparency = 1
delayMaxLabel.Text = "⌨ Delay Max: "..string.format("%.2fs", delayMax)
delayMaxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayMaxLabel.Font = Enum.Font.Gotham
delayMaxLabel.TextSize = 9
delayMaxLabel.TextXAlignment = Enum.TextXAlignment.Left
delayMaxLabel.Parent = speedPanel

local intervalMinLabel = Instance.new("TextLabel")
intervalMinLabel.Size = UDim2.new(0.5, -10, 0, 20)
intervalMinLabel.Position = UDim2.new(0, 12, 0, 60)
intervalMinLabel.BackgroundTransparency = 1
intervalMinLabel.Text = "⏱ Interval Min: "..string.format("%.2fs", intervalMin)
intervalMinLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
intervalMinLabel.Font = Enum.Font.Gotham
intervalMinLabel.TextSize = 9
intervalMinLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalMinLabel.Parent = speedPanel

local intervalMaxLabel = Instance.new("TextLabel")
intervalMaxLabel.Size = UDim2.new(0.5, -10, 0, 20)
intervalMaxLabel.Position = UDim2.new(0.5, -5, 0, 60)
intervalMaxLabel.BackgroundTransparency = 1
intervalMaxLabel.Text = "⏱ Interval Max: "..string.format("%.2fs", intervalMax)
intervalMaxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
intervalMaxLabel.Font = Enum.Font.Gotham
intervalMaxLabel.TextSize = 9
intervalMaxLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalMaxLabel.Parent = speedPanel

local function createAdjustButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 22)
    btn.Position = UDim2.new(0.5, -30, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = speedPanel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        callback()
        delayMinLabel.Text = "⌨ Delay Min: "..string.format("%.2fs", delayMin)
        delayMaxLabel.Text = "⌨ Delay Max: "..string.format("%.2fs", delayMax)
        intervalMinLabel.Text = "⏱ Interval Min: "..string.format("%.2fs", intervalMin)
        intervalMaxLabel.Text = "⏱ Interval Max: "..string.format("%.2fs", intervalMax)
    end)

    return btn
end

createAdjustButton("⬆️ +", 85, function()
    delayMin = math.min(delayMin + 0.01, 0.5)
    delayMax = math.min(delayMax + 0.01, 0.5)
end)

createAdjustButton("⬇️ -", 110, function()
    delayMin = math.max(delayMin - 0.01, 0.01)
    delayMax = math.max(delayMax - 0.01, 0.02)
    if delayMax < delayMin then
        delayMax = delayMin + 0.01
    end
end)

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

local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
dropBtn.LayoutOrder = 10
dropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
dropBtn.Text = "📂 SET KATA SULIT ▼"
dropBtn.TextColor3 = Color3.new(1, 1, 1)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = TEXT_SIZE_SMALL
dropBtn.Parent = mainPage
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 9)

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.new(1, -4, 0, 0)
dropFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
dropFrame.ClipsDescendants = true
dropFrame.BorderSizePixel = 0
dropFrame.Parent = mainPage
dropFrame.LayoutOrder = 11

local dropLayout = Instance.new("UIListLayout")
dropLayout.Padding = UDim.new(0, 2)
dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
dropLayout.Parent = dropFrame

local dropPad = Instance.new("UIPadding", dropFrame)
dropPad.PaddingTop = UDim.new(0, 5)
dropPad.PaddingBottom = UDim.new(0, 5)
dropPad.PaddingLeft = UDim.new(0, 5)
dropPad.PaddingRight = UDim.new(0, 5)

local categories = {"IF","X","NG","AI","KS","CY","UI","LY","GY","LT","EO","OE","EKS","OO","KN","Q","MP","SF","TT"}
local isDropOpen = false

for _, cat in ipairs(categories) do
    local catBtn = Instance.new("TextButton")
    catBtn.Size = UDim2.new(1, 0, 0, isTouch and 30 or 26)
    catBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
    catBtn.Text = "  "..cat
    catBtn.TextColor3 = Color3.fromRGB(180, 170, 220)
    catBtn.Font = Enum.Font.Gotham
    catBtn.TextSize = TEXT_SIZE_SMALL
    catBtn.TextXAlignment = Enum.TextXAlignment.Left
    catBtn.Parent = dropFrame
    Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 5)

    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(0, 20, 1, 0)
    check.Position = UDim2.new(1, -25, 0, 0)
    check.BackgroundTransparency = 1
    check.Text = dropState[cat] and "✓" or ""
    check.TextColor3 = dropState[cat] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)
    check.Font = Enum.Font.GothamBold
    check.TextSize = 12
    check.Parent = catBtn

    catBtn.MouseButton1Click:Connect(function()
        playClickSound()
        dropState[cat] = not dropState[cat]
        check.Text = dropState[cat] and "✓" or ""
        check.TextColor3 = dropState[cat] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)
        catBtn.BackgroundColor3 = dropState[cat] and Color3.fromRGB(65, 20, 145) or Color3.fromRGB(30, 25, 45)
    end)
end

dropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isDropOpen = not isDropOpen
    dropBtn.Text = isDropOpen and "📂 SET KATA SULIT ▲" or "📂 SET KATA SULIT ▼"
    dropFrame.Size = isDropOpen and UDim2.new(1, -4, 0, #categories * (isTouch and 34 or 30) + 10) or UDim2.new(1, -4, 0, 0)
end)

local themeDropBtn = Instance.new("TextButton")
themeDropBtn.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
themeDropBtn.LayoutOrder = 12
themeDropBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
themeDropBtn.Text = "🎨 PILIH TEMA WARNA ▼"
themeDropBtn.TextColor3 = Color3.new(1, 1, 1)
themeDropBtn.Font = Enum.Font.GothamBold
themeDropBtn.TextSize = TEXT_SIZE_SMALL
themeDropBtn.Parent = mainPage
Instance.new("UICorner", themeDropBtn).CornerRadius = UDim.new(0, 9)

local themeDropFrame = Instance.new("Frame")
themeDropFrame.Size = UDim2.new(1, -4, 0, 0)
themeDropFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
themeDropFrame.ClipsDescendants = true
themeDropFrame.BorderSizePixel = 0
themeDropFrame.Parent = mainPage
themeDropFrame.LayoutOrder = 13

local themeLayout = Instance.new("UIListLayout")
themeLayout.Padding = UDim.new(0, 2)
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder
themeLayout.Parent = themeDropFrame

local themePad = Instance.new("UIPadding", themeDropFrame)
themePad.PaddingTop = UDim.new(0, 5)
themePad.PaddingBottom = UDim.new(0, 5)
themePad.PaddingLeft = UDim.new(0, 5)
themePad.PaddingRight = UDim.new(0, 5)

local themes_list = {"CYBERPUNK","CRIMSON","MATRIX","SAKURA","OCEAN","FLAME"}
local isThemeOpen = false

for _, tname in ipairs(themes_list) do
    local themeBtn = Instance.new("TextButton")
    themeBtn.Size = UDim2.new(1, 0, 0, isTouch and 30 or 26)
    themeBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
    themeBtn.Text = "  "..tname
    themeBtn.TextColor3 = Color3.fromRGB(180, 170, 220)
    themeBtn.Font = Enum.Font.Gotham
    themeBtn.TextSize = TEXT_SIZE_SMALL
    themeBtn.TextXAlignment = Enum.TextXAlignment.Left
    themeBtn.Parent = themeDropFrame
    Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 5)

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 16, 0, 16)
    preview.Position = UDim2.new(1, -25, 0.5, -8)
    preview.BackgroundColor3 = themes[tname].primary
    preview.BorderSizePixel = 0
    preview.Parent = themeBtn
    Instance.new("UICorner", preview).CornerRadius = UDim.new(1, 0)

    themeBtn.MouseButton1Click:Connect(function()
        playClickSound()
        applyTheme(tname)
    end)
end

themeDropBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isThemeOpen = not isThemeOpen
    themeDropBtn.Text = isThemeOpen and "🎨 PILIH TEMA WARNA ▲" or "🎨 PILIH TEMA WARNA ▼"
    themeDropFrame.Size = isThemeOpen and UDim2.new(1, -4, 0, #themes_list * (isTouch and 34 or 30) + 10) or UDim2.new(1, -4, 0, 0)
end)

local tuyulFrame = Instance.new("Frame")
tuyulFrame.Size = UDim2.new(1, 0, 0, 130)
tuyulFrame.LayoutOrder = 1
tuyulFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
tuyulFrame.BorderSizePixel = 0
tuyulFrame.Parent = utilPage
Instance.new("UICorner", tuyulFrame).CornerRadius = UDim.new(0, 12)

local tuyulStroke = Instance.new("UIStroke", tuyulFrame)
tuyulStroke.Color = Color3.fromRGB(90, 40, 180)

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

DIBUAT OLEH R4NzDev
]]
infoDesc.TextColor3 = Color3.fromRGB(180, 170, 210)
infoDesc.Font = Enum.Font.Gotham
infoDesc.TextSize = 11
infoDesc.TextWrapped = true
infoDesc.TextXAlignment = Enum.TextXAlignment.Left
infoDesc.Parent = infoPage

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

local function showPage(page)
    for _, p in pairs({infoPage, mainPage, utilPage, nyawaPage}) do
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

local isDragging = false
local dragOffset = Vector2.new(0, 0)

header.InputBegan:Connect(function(input)
    if isTouchOrMouse(input) then
        isDragging = true
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = mainFrame.AbsolutePosition
        dragOffset = Vector2.new(mousePos.X - framePos.X, mousePos.Y - framePos.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local newX = mousePos.X - dragOffset.X
        local newY = mousePos.Y - dragOffset.Y

        local cam = workspace.CurrentCamera
        if cam then
            local vs = cam.ViewportSize
            local fs = mainFrame.AbsoluteSize
            newX = math.clamp(newX, 10, vs.X - fs.X - 10)
            newY = math.clamp(newY, 10, vs.Y - fs.Y - 10)
        end

        mainFrame.Position = UDim2.new(0, newX, 0, newY)
        glowFrame.Position = UDim2.new(0, newX - 2, 0, newY - 2)
        resizeHandle.Position = UDim2.new(0, newX + mainFrame.Size.X.Offset - 24, 0, newY + mainFrame.Size.Y.Offset - 24)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if isTouchOrMouse(input) then
        isDragging = false
    end
end)

local isResizing = false
local resizeStartPos = Vector2.new(0, 0)
local resizeStartSize = Vector2.new(WIDTH, HEIGHT)

resizeHandle.InputBegan:Connect(function(input)
    if isTouchOrMouse(input) then
        isResizing = true
        resizeStartPos = UserInputService:GetMouseLocation()
        resizeStartSize = Vector2.new(mainFrame.Size.X.Offset, mainFrame.Size.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local delta = mousePos - resizeStartPos

        local newWidth = math.max(resizeStartSize.X + delta.X, isTouch and 260 or 300)
        local newHeight = math.max(resizeStartSize.Y + delta.Y, isTouch and 200 or 230)

        newWidth = math.clamp(newWidth, isTouch and 260 or 300, isTouch and 500 or 720)
        newHeight = math.clamp(newHeight, isTouch and 200 or 230, isTouch and 480 or 600)

        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        glowFrame.Size = UDim2.new(0, newWidth + 4, 0, newHeight + 4)

        local pos = mainFrame.Position
        resizeHandle.Position = UDim2.new(pos.X.Scale, pos.X.Offset + newWidth - 24, pos.Y.Scale, pos.Y.Offset + newHeight - 24)
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if isTouchOrMouse(input) then
        isResizing = false
    end
end)

RunService.RenderStepped:Connect(function()
    if mainFrame and mainFrame.Visible then
        local pos = mainFrame.Position
        local sz = mainFrame.Size
        resizeHandle.Position = UDim2.new(
            pos.X.Scale, pos.X.Offset + sz.X.Offset - 24,
            pos.Y.Scale, pos.Y.Offset + sz.Y.Offset - 24
        )
    end
end)

local ok, err = pcall(function()
    applyTheme("CYBERPUNK")
    logFloating.Position = UDim2.new(1, -290, 0, 10)
    updateLogDisplayFloating()

    print("✅ R4NzDev EKSTRIM v3.0 loaded!")
    print("🔑 Logika AUTO TULIS: cari kata berawalan soal, ketik sisa huruf")
    print("📋 Live log aktif — jawab soal untuk melihat hasil")
end)

if not ok then
    warn("❌ Runtime error:", err)
end