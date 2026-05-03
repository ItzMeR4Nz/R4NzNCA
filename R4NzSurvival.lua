-- ============================================
-- R4NzDev UI - 5 TABS (Android Touch)
-- FIXED: Touch drag, Touch resize, Touch scroll
-- ============================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Hapus GUI lama jika ada
local oldGui = CoreGui:FindFirstChild("R4NzDev")
if oldGui then oldGui:Destroy() end

-- ========== UKURAN UNTUK TOUCH ==========
local WIDTH = 350
local HEIGHT = 500
local SIDEBAR_WIDTH = 100
local HEADER_HEIGHT = 50

local isResizing = false
local isDragging = false
local resizeStartPos = nil
local dragStartPos = nil
local startWidth, startHeight, startX, startY

function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- ========== MAIN GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- GLOW FRAME
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowWrapper"
glowFrame.Size = UDim2.new(0, WIDTH + 4, 0, HEIGHT + 4)
glowFrame.Position = UDim2.new(0.5, -(WIDTH/2) - 2, 0.5, -(HEIGHT/2) - 2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.Parent = screenGui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 18)

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

function syncGlowWrapper()
    local pos = mainFrame.Position
    glowFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 2, pos.Y.Scale, pos.Y.Offset - 2)
    glowFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset + 4, 0, mainFrame.Size.Y.Offset + 4)
end

-- ========== DRAG WINDOW (TOUCH) ==========
local dragActive = false
local dragStartTouch, dragStartFramePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragActive = true
        dragStartTouch = input.Position
        dragStartFramePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragActive = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartTouch
        mainFrame.Position = UDim2.new(dragStartFramePos.X.Scale, dragStartFramePos.X.Offset + delta.X, dragStartFramePos.Y.Scale, dragStartFramePos.Y.Offset + delta.Y)
        syncGlowWrapper()
    end
end)

-- ========== RESIZE WINDOW (TOUCH) ==========
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 40, 0, 40)
resizeHandle.Position = UDim2.new(1, -40, 1, -40)
resizeHandle.BackgroundColor3 = Color3.fromRGB(65, 15, 160)
resizeHandle.Text = "↘️"
resizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 24
resizeHandle.ZIndex = 10
resizeHandle.Parent = mainFrame
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 12)

local resizingActive = false
local resizeStartTouch, resizeStartWidth, resizeStartHeight

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        resizingActive = true
        resizeStartTouch = input.Position
        resizeStartWidth = mainFrame.Size.X.Offset
        resizeStartHeight = mainFrame.Size.Y.Offset
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizingActive = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizingActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - resizeStartTouch
        local newWidth = math.clamp(resizeStartWidth + delta.X, 300, 600)
        local newHeight = math.clamp(resizeStartHeight + delta.Y, 400, 700)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        syncGlowWrapper()
    end
end)

-- ========== HEADER ==========
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

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 160, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "R4NzDev"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- ========== BUTTON MINIMIZE ==========
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -90, 0.5, -20)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
minimizeBtn.Text = "⛎"
minimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- ========== BUTTON CLOSE ==========
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0.5, -20)
closeBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========== MINIMIZE FUNCTION ==========
local isMinimized = false
local miniIcon = Instance.new("ImageButton")
miniIcon.Size = UDim2.new(0, 70, 0, 70)
miniIcon.Position = UDim2.new(0, 15, 0.5, -35)
miniIcon.BackgroundColor3 = Color3.fromRGB(55, 15, 130)
miniIcon.Image = "rbxassetid://996833752434053"
miniIcon.Visible = false
miniIcon.BorderSizePixel = 0
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 16)

minimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = true
    mainFrame.Visible = false
    glowFrame.Visible = false
    resizeHandle.Visible = false
    miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = false
    mainFrame.Visible = true
    glowFrame.Visible = true
    resizeHandle.Visible = true
    miniIcon.Visible = false
end)

-- DRAG MINI ICON
local miniDragActive = false
local miniDragStart, miniStartPos

miniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        miniDragActive = true
        miniDragStart = input.Position
        miniStartPos = miniIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                miniDragActive = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if miniDragActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - miniDragStart
        miniIcon.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

-- ========== SIDEBAR ==========
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

-- ========== CONTENT AREA ==========
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(SIDEBAR_WIDTH + 10), 1, -(HEADER_HEIGHT + 10))
contentFrame.Position = UDim2.new(0, SIDEBAR_WIDTH + 5, 0, HEADER_HEIGHT + 5)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ========== CREATE 5 TABS ==========
local tabButtons = {}
local currentPage = nil

function createTabBtn(btnText, btnIcon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, order * 55 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = btnIcon .. "  " .. btnText
    btn.TextColor3 = Color3.fromRGB(120, 110, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1.5
    btnStroke.Transparency = 0.6
    
    local btnPad = Instance.new("UIPadding", btn)
    btnPad.PaddingLeft = UDim.new(0, 15)
    
    table.insert(tabButtons, { btn = btn, text = btnText, stroke = btnStroke })
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

-- Buat tombol tab
local btnESP = createTabBtn("ESP", "👁️", 0)
local btnCombat = createTabBtn("COMBAT", "⚔️", 1)
local btnCollect = createTabBtn("COLLECT", "🎒", 2)
local btnMovement = createTabBtn("MOVEMENT", "🚀", 3)
local btnVisuals = createTabBtn("VISUALS", "🌟", 4)

-- ========== CREATE PAGES (SCROLLING) ==========
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
    page.BorderSizePixel = 0
    page.Visible = false
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = contentFrame
    Instance.new("UICorner", page).CornerRadius = UDim.new(0, 12)
    return page
end

local pageESP = createPage()
local pageCombat = createPage()
local pageCollect = createPage()
local pageMovement = createPage()
local pageVisuals = createPage()

-- Padding untuk halaman
function addPagePadding(page)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
end

addPagePadding(pageESP)
addPagePadding(pageCombat)
addPagePadding(pageCollect)
addPagePadding(pageMovement)
addPagePadding(pageVisuals)

-- Layout untuk halaman
function addPageLayout(page)
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
end

addPageLayout(pageESP)
addPageLayout(pageCombat)
addPageLayout(pageCollect)
addPageLayout(pageMovement)
addPageLayout(pageVisuals)

-- ========== FUNCTION TOGGLE ==========
function createToggle(label, parent, defaultValue, callback, order)
    local toggleHeight = 50
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, toggleHeight)
    toggleFrame.LayoutOrder = order
    toggleFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 12)
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -70, 1, 0)
    labelText.Position = UDim2.new(0, 15, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(210, 200, 230)
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame
    
    local toggleWidth = 55
    local toggleHeightSmall = 28
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, toggleWidth, 0, toggleHeightSmall)
    toggleBg.Position = UDim2.new(1, -(toggleWidth + 10), 0.5, -toggleHeightSmall / 2)
    toggleBg.BackgroundColor3 = defaultValue and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleFrame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local knobSize = 22
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position = defaultValue and UDim2.new(1, -(knobSize + 4), 0.5, -knobSize / 2) or UDim2.new(0, 4, 0.5, -knobSize / 2)
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
        knob.Position = state and UDim2.new(1, -(knobSize + 4), 0.5, -knobSize / 2) or UDim2.new(0, 4, 0.5, -knobSize / 2)
        playClickSound()
        if callback then callback(state) end
    end)
    
    return toggleFrame
end

-- ========== ISI KONTEN ==========
-- ESP PAGE
createToggle("TRACK ENEMIES", pageESP, false, function(val)
    print("[ESP] Track Enemies: " .. tostring(val))
end, 1)

createToggle("SHOW DISTANCE", pageESP, true, function(val)
    print("[ESP] Show Distance: " .. tostring(val))
end, 2)

-- COMBAT PAGE
createToggle("AIMBOT", pageCombat, false, function(val)
    print("[COMBAT] Aimbot: " .. tostring(val))
end, 1)

createToggle("KILL AURA", pageCombat, false, function(val)
    print("[COMBAT] Kill Aura: " .. tostring(val))
end, 2)

-- COLLECT PAGE
createToggle("AUTO COLLECT", pageCollect, false, function(val)
    print("[COLLECT] Auto Collect: " .. tostring(val))
end, 1)

-- MOVEMENT PAGE
createToggle("FLY MODE", pageMovement, false, function(val)
    print("[MOVEMENT] Fly Mode: " .. tostring(val))
end, 1)

-- VISUALS PAGE
createToggle("FULLBRIGHT", pageVisuals, false, function(val)
    print("[VISUALS] Fullbright: " .. tostring(val))
end, 1)

createToggle("FPS COUNTER", pageVisuals, true, function(val)
    print("[VISUALS] FPS Counter: " .. tostring(val))
end, 2)

-- FPS LABEL
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 40)
fpsLabel.LayoutOrder = 3
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 000"
fpsLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Parent = pageVisuals

-- UPDATE FPS
local frameCount = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = now
    end
end)

-- ========== SHOW PAGE ==========
function showPage(page)
    local pages = {pageESP, pageCombat, pageCollect, pageMovement, pageVisuals}
    for _, p in pairs(pages) do
        if p then p.Visible = false end
    end
    if page then page.Visible = true end
end

showPage(pageESP)
setActiveTab(btnESP)

-- TAB CLICK HANDLERS
btnESP.MouseButton1Click:Connect(function()
    showPage(pageESP)
    setActiveTab(btnESP)
    playClickSound()
end)

btnCombat.MouseButton1Click:Connect(function()
    showPage(pageCombat)
    setActiveTab(btnCombat)
    playClickSound()
end)

btnCollect.MouseButton1Click:Connect(function()
    showPage(pageCollect)
    setActiveTab(btnCollect)
    playClickSound()
end)

btnMovement.MouseButton1Click:Connect(function()
    showPage(pageMovement)
    setActiveTab(btnMovement)
    playClickSound()
end)

btnVisuals.MouseButton1Click:Connect(function()
    showPage(pageVisuals)
    setActiveTab(btnVisuals)
    playClickSound()
end)

-- ========== HP / STAMINA BAR ==========
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 70)
statusFrame.LayoutOrder = 4
statusFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = pageVisuals
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 12)

local statusTitle = Instance.new("TextLabel")
statusTitle.Size = UDim2.new(1, 0, 0, 25)
statusTitle.Position = UDim2.new(0, 0, 0, 5)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "❤️ HP & STAMINA"
statusTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 12
statusTitle.TextXAlignment = Enum.TextXAlignment.Center
statusTitle.Parent = statusFrame

-- HP BAR
local hpBarFrame = Instance.new("Frame")
hpBarFrame.Size = UDim2.new(1, -20, 0, 18)
hpBarFrame.Position = UDim2.new(0, 10, 0, 35)
hpBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hpBarFrame.BorderSizePixel = 0
hpBarFrame.Parent = statusFrame
Instance.new("UICorner", hpBarFrame).CornerRadius = UDim.new(0, 8)

local hpFill = Instance.new("Frame")
hpFill.Size = UDim2.new(1, 0, 1, 0)
hpFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
hpFill.BorderSizePixel = 0
hpFill.Parent = hpBarFrame
Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 8)

-- UPDATE HP
task.spawn(function()
    while task.wait(0.1) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            hpFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            if healthPercent > 0.5 then
                hpFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
            elseif healthPercent > 0.25 then
                hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            else
                hpFill.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            end
        end
    end
end)

-- ========== NOTIFIKASI ==========
print("✅ R4NzDev UI berhasil dimuat untuk Android!")
print("🔹 5 Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS")
print("🔹 Tekan dan tahan pada header untuk drag")
print("🔹 Tekan dan tahan pada ↘️ untuk resize")
print("🔹 Scroll daftar menu dengan sentuhan")
print("🔹 Tekan ⛎ untuk minimize, ✕ untuk tutup")