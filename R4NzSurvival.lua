-- R4NzDev UI - 5 TABS (ESP, COMBAT, COLLECT, MOVEMENT, VISUALS)
-- Versi minimal yang PASTI MUNCUL

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = game:GetService("Players").LocalPlayer

-- Hapus GUI lama jika ada
local oldGui = CoreGui:FindFirstChild("R4NzDev")
if oldGui then oldGui:Destroy() end

local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 300 or 460
local HEIGHT = isTouch and 250 or 310
local SIDEBAR_WIDTH = isTouch and 85 or 105
local HEADER_HEIGHT = isTouch and 42 or 46

function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1396568322785649"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- MAIN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Resize Handle
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 24, 0, 24)
resizeHandle.Position = UDim2.new(1, -24, 1, -24)
resizeHandle.BackgroundColor3 = Color3.fromRGB(65, 15, 160)
resizeHandle.Text = "↘️"
resizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 14
resizeHandle.Parent = mainFrame
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame")
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

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 140, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "R4NzDev"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -64, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
minimizeBtn.Text = "⛎"
minimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

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

-- Sidebar layout
local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, 12)
sidePad.PaddingLeft = UDim.new(0, 7)
sidePad.PaddingRight = UDim.new(0, 7)

-- Content area
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(SIDEBAR_WIDTH + 7), 1, -(HEADER_HEIGHT + 6))
contentFrame.Position = UDim2.new(0, SIDEBAR_WIDTH + 7, 0, HEADER_HEIGHT + 4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ========================== CREATE 5 TABS ==========================
local tabButtons = {}
local tabESP, tabCombat, tabCollect, tabMovement, tabVisuals

function createTabBtn(btnText, btnIcon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = btnIcon .. "  " .. btnText
    btn.TextColor3 = Color3.fromRGB(120, 110, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    
    local btnPad = Instance.new("UIPadding", btn)
    btnPad.PaddingLeft = UDim.new(0, 10)
    
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

-- Create 5 tab buttons
tabESP = createTabBtn("ESP", "👁️", 0)
tabCombat = createTabBtn("COMBAT", "⚔️", 1)
tabCollect = createTabBtn("COLLECT", "🎒", 2)
tabMovement = createTabBtn("MOVEMENT", "🚀", 3)
tabVisuals = createTabBtn("VISUALS", "🌟", 4)

-- ========================== CREATE PAGES ==========================
function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
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

-- Add padding to pages
function addPagePadding(page)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
end

addPagePadding(espPage)
addPagePadding(combatPage)
addPagePadding(collectPage)
addPagePadding(movementPage)
addPagePadding(visualsPage)

-- Layouts for pages
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

-- ========================== CREATE TOGGLE FUNCTION ==========================
function createToggle(label, parent, defaultValue, callback, order)
    local toggleHeight = 36
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, toggleHeight)
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
    labelText.TextSize = 12
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame
    
    local toggleWidth = 44
    local toggleHeightSmall = 22
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, toggleWidth, 0, toggleHeightSmall)
    toggleBg.Position = UDim2.new(1, -(toggleWidth + 6), 0.5, -toggleHeightSmall / 2)
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
        if callback then callback(state) end
    end)
    
    return toggleFrame
end

-- Add content to ESP page
createToggle("👁️ TRACK ENEMIES", espPage, false, function(val)
    print("ESP Track Enemies: " .. tostring(val))
end, 1)

createToggle("📏 SHOW DISTANCE", espPage, true, function(val)
    print("Show Distance: " .. tostring(val))
end, 2)

-- Add content to COMBAT page
createToggle("🎯 AIMBOT", combatPage, false, function(val)
    print("Aimbot: " .. tostring(val))
end, 1)

createToggle("🗡️ KILL AURA", combatPage, false, function(val)
    print("Kill Aura: " .. tostring(val))
end, 2)

createToggle("🔄 AUTO RELOAD", combatPage, false, function(val)
    print("Auto Reload: " .. tostring(val))
end, 3)

-- Add content to COLLECT page
createToggle("🎒 AUTO COLLECT", collectPage, false, function(val)
    print("Auto Collect: " .. tostring(val))
end, 1)

-- Add content to MOVEMENT page
createToggle("🚀 FLY MODE", movementPage, false, function(val)
    print("Fly Mode: " .. tostring(val))
end, 1)

-- Add content to VISUALS page
createToggle("☀️ FULLBRIGHT", visualsPage, false, function(val)
    print("Fullbright: " .. tostring(val))
end, 1)

createToggle("📊 FPS COUNTER", visualsPage, true, function(val)
    print("FPS Counter: " .. tostring(val))
end, 2)

-- FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 30)
fpsLabel.LayoutOrder = 3
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 000"
fpsLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Parent = visualsPage

-- Update FPS
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

-- Status Bar
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 60)
statusFrame.LayoutOrder = 4
statusFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = visualsPage
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 12)

local statusTitle = Instance.new("TextLabel")
statusTitle.Size = UDim2.new(1, 0, 0, 20)
statusTitle.Position = UDim2.new(0, 0, 0, 4)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "❤️ HP & STAMINA"
statusTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 10
statusTitle.TextXAlignment = Enum.TextXAlignment.Center
statusTitle.Parent = statusFrame

-- HP Bar
local hpBarFrame = Instance.new("Frame")
hpBarFrame.Size = UDim2.new(1, -20, 0, 16)
hpBarFrame.Position = UDim2.new(0, 10, 0, 28)
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

-- Update HP (contoh, nanti bisa dihubungkan ke karakter)
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

-- ========================== SHOW DEFAULT PAGE ==========================
function showPage(page)
    local pages = { espPage, combatPage, collectPage, movementPage, visualsPage }
    for _, p in pairs(pages) do
        if p then p.Visible = false end
    end
    if page then page.Visible = true end
end

showPage(espPage)
setActiveTab(tabESP)

-- Tab click handlers
tabESP.MouseButton1Click:Connect(function()
    showPage(espPage)
    setActiveTab(tabESP)
    playClickSound()
end)

tabCombat.MouseButton1Click:Connect(function()
    showPage(combatPage)
    setActiveTab(tabCombat)
    playClickSound()
end)

tabCollect.MouseButton1Click:Connect(function()
    showPage(collectPage)
    setActiveTab(tabCollect)
    playClickSound()
end)

tabMovement.MouseButton1Click:Connect(function()
    showPage(movementPage)
    setActiveTab(tabMovement)
    playClickSound()
end)

tabVisuals.MouseButton1Click:Connect(function()
    showPage(visualsPage)
    setActiveTab(tabVisuals)
    playClickSound()
end)

-- Minimize functionality
local minimized = false
local miniIcon = Instance.new("ImageButton")
miniIcon.Size = UDim2.new(0, 52, 0, 52)
miniIcon.Position = UDim2.new(0, 10, 0.5, -26)
miniIcon.BackgroundColor3 = Color3.fromRGB(55, 15, 130)
miniIcon.Image = "rbxassetid://996833752434053"
miniIcon.Visible = false
miniIcon.BorderSizePixel = 0
miniIcon.Parent = screenGui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 14)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Visible = not minimized
    resizeHandle.Visible = not minimized
    miniIcon.Visible = minimized
end)

miniIcon.MouseButton1Click:Connect(function()
    minimized = false
    mainFrame.Visible = true
    resizeHandle.Visible = true
    miniIcon.Visible = false
end)

-- Drag functionality (PC only)
if not isTouch then
    local dragging = false
    local dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

print("✅ R4NzDev UI berhasil dimuat - 5 TABS: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS")