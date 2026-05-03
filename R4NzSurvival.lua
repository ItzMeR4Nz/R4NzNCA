-- ============================================
-- R4NzDev UI - 5 TABS (DENGAN AUTO COLLECT DARI ZHUB)
-- ============================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local camera = Workspace.CurrentCamera

local scriptKey = "R4NzDev_UI_ZHub"

if CoreGui:FindFirstChild("R4NzDev") then
    CoreGui.R4NzDev:Destroy()
end

local isRunning = true
_G[scriptKey] = function()
    isRunning = false
    if collectLoopConnection then collectLoopConnection:Disconnect() end
    if radiusRing then radiusRing:Destroy() end
    if fovCircle then fovCircle:Destroy() end
    local old = CoreGui:FindFirstChild("R4NzDev")
    if old then old:Destroy() end
end

local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 300 or 460
local HEIGHT = isTouch and 250 or 310
local SIDEBAR_WIDTH = isTouch and 85 or 105
local HEADER_HEIGHT = isTouch and 42 or 46
local TAB_FONT_SIZE = isTouch and 9 or 11
local TOGGLE_HEIGHT = isTouch and 32 or 36
local TEXT_SIZE_SMALL = isTouch and 10 or 12
local TOGGLE_SMALL_HEIGHT = isTouch and 30 or 34

local function playClickSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1396568322785649"
        sound.Volume = 0.3
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 1)
    end)
end

-- ============================================================
-- AUTO COLLECT VARIABLES (DARI ZHUB)
-- ============================================================
local collectSettings = {
    Enabled = false,
    Mode = 'Radius',  -- 'Radius' or 'Mouse FOV'
    Radius = 20,
    FOV = 150,
    CollectDelay = 0.5,
    PreventBasePickup = true,
    BaseCenter = Vector3.new(0, 0, 0),
    BaseSize = Vector3.new(50, 50, 50)
}

local radiusRing = nil
local fovCircle = nil
local lastCollectTime = 0
local collectLoopConnection = nil

-- Fungsi Auto Collect dari ZHub
local function IsValidItem(item)
    if not item or not item.Parent then return false end
    if item:IsA('Model') or item:IsA('BasePart') then
        local prompt = item:FindFirstChildOfClass('ProximityPrompt')
        if prompt and not prompt.Enabled then return false end
        return true
    end
    return false
end

local function GetItemPrimaryPart(item)
    if item:IsA('BasePart') then return item end
    return item.PrimaryPart or item:FindFirstChild('Handle') or 
           item:FindFirstChild('Head') or item:FindFirstChildWhichIsA('BasePart')
end

local function PickupItem(item)
    local remote = ReplicatedStorage:FindFirstChild('PickUpItem') or 
                   ReplicatedStorage:FindFirstChild('AdjustBackpack')
    if remote then
        pcall(function() remote:FireServer(item) end)
    end
end

local function AutoCollectLoop()
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
        -- Mode Radius
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
                    if collectSettings.PreventBasePickup then
                        local itemPos = part.Position
                        if math.abs(itemPos.X - collectSettings.BaseCenter.X) <= collectSettings.BaseSize.X and
                           math.abs(itemPos.Z - collectSettings.BaseCenter.Z) <= collectSettings.BaseSize.Z then
                            goto skipItem
                        end
                    end
                    local dist = (playerPos - part.Position).Magnitude
                    if dist <= collectSettings.Radius then
                        table.insert(targetItems, item)
                        if #targetItems >= 5 then break end
                    end
                end
            end
            ::skipItem::
        end
        
    elseif collectSettings.Mode == 'Mouse FOV' then
        -- Mode Mouse FOV
        if radiusRing then radiusRing.Visible = false end
        if radiusRing then radiusRing.Transparency = 1 end
        
        local mousePos = UserInputService:GetMouseLocation()
        if fovCircle and fovCircle.Parent then
            fovCircle.Visible = true
            fovCircle.Size = UDim2.new(0, collectSettings.FOV * 2, 0, collectSettings.FOV * 2)
            fovCircle.Position = UDim2.new(0, mousePos.X - collectSettings.FOV, 0, mousePos.Y - collectSettings.FOV)
        end
        
        for _, item in ipairs(droppedItems:GetChildren()) do
            if IsValidItem(item) then
                local part = GetItemPrimaryPart(item)
                if part then
                    if collectSettings.PreventBasePickup then
                        local itemPos = part.Position
                        if math.abs(itemPos.X - collectSettings.BaseCenter.X) <= collectSettings.BaseSize.X and
                           math.abs(itemPos.Z - collectSettings.BaseCenter.Z) <= collectSettings.BaseSize.Z then
                            goto skipItemFOV
                        end
                    end
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
            ::skipItemFOV::
        end
    end
    
    for _, item in ipairs(targetItems) do
        PickupItem(item)
        task.wait(0.02)
    end
    
    lastCollectTime = now
end

-- Fungsi untuk membuat visual Auto Collect
local function CreateAutoCollectVisuals()
    -- Radius Ring (Part 3D)
    radiusRing = Instance.new("Part")
    radiusRing.Name = "RadiusRing"
    radiusRing.Size = Vector3.new(0.1, 0.1, 0.1)
    radiusRing.Anchored = true
    radiusRing.CanCollide = false
    radiusRing.Transparency = 0.7
    radiusRing.Material = Enum.Material.Neon
    radiusRing.Parent = Workspace
    radiusRing.Visible = false
    
    -- FOV Circle (2D ScreenGui)
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
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "R4NzDev"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = CoreGui

-- GLOW FRAME
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

-- RESIZE HANDLE
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

resizeHandle.Position = UDim2.new(
    0, mainFrame.Position.X.Offset + mainFrame.Size.X.Offset - 24,
    0, mainFrame.Position.Y.Offset + mainFrame.Size.Y.Offset - 24
)

-- HEADER
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
titleLabel.Text = "R4NzDev + ZHub"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- MINIMIZE BUTTON
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

-- CLOSE BUTTON
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

closeBtn.MouseButton1Click:Connect(function()
    if _G[scriptKey] then _G[scriptKey]() end
end)

-- SIDEBAR
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

-- CONTENT AREA
local contentStartX = SIDEBAR_WIDTH + 7
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -(contentStartX+4), 1, -(HEADER_HEIGHT+6))
contentFrame.Position = UDim2.new(0, contentStartX, 0, HEADER_HEIGHT+4)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- MINI ICON (saat minimize)
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

-- ============================================================
-- CREATE PAGE FUNCTION
-- ============================================================
local function createPage()
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

-- 5 PAGES
local pageESP = createPage()
local pageCombat = createPage()
local pageCollect = createPage()
local pageMovement = createPage()
local pageVisuals = createPage()

local function addPagePadding(page)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 10)
end

addPagePadding(pageESP)
addPagePadding(pageCombat)
addPagePadding(pageCollect)
addPagePadding(pageMovement)
addPagePadding(pageVisuals)

local function addPageLayout(page)
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
end

addPageLayout(pageESP)
addPageLayout(pageCombat)
addPageLayout(pageCollect)
addPageLayout(pageMovement)
addPageLayout(pageVisuals)

-- ============================================================
-- TAB BUTTONS
-- ============================================================
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

-- CREATE 5 TABS
local tabESP = createTabBtn("ESP", "👁️", 0)
local tabCombat = createTabBtn("COMBAT", "⚔️", 1)
local tabCollect = createTabBtn("COLLECT", "🎒", 2)
local tabMovement = createTabBtn("MOVEMENT", "🚀", 3)
local tabVisuals = createTabBtn("VISUALS", "🌟", 4)

-- ============================================================
-- CREATE TOGGLE FUNCTION
-- ============================================================
local function createToggle(label, parent, defaultValue, callback, order, isSmall)
    local height = isSmall and TOGGLE_SMALL_HEIGHT or TOGGLE_HEIGHT
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -4, 0, height)
    toggleFrame.LayoutOrder = order
    toggleFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 9)

    local fs = Instance.new("UIStroke", toggleFrame)
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
    lbl.Parent = toggleFrame

    local tw = isTouch and 48 or 44
    local th = isTouch and 26 or 22

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, tw, 0, th)
    bg.Position = UDim2.new(1, -(tw+6), 0.5, -th/2)
    bg.BackgroundColor3 = defaultValue and Color3.fromRGB(30,180,110) or Color3.fromRGB(180,40,50)
    bg.BorderSizePixel = 0
    bg.Parent = toggleFrame
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
    hit.Parent = toggleFrame

    local state = defaultValue
    hit.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and Color3.fromRGB(30,180,110) or Color3.fromRGB(180,40,50)
        knob.Position = state and UDim2.new(1, -(ks+3), 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2)
        playClickSound()
        if callback then callback(state) end
    end)

    return toggleFrame
end

-- ============================================================
-- ADD CONTENT TO PAGES
-- ============================================================

-- ESP PAGE
createToggle("👁️ TRACK ENEMIES", pageESP, false, function(val)
    print("[ESP] Track Enemies: " .. tostring(val))
end, 1)

createToggle("📏 SHOW DISTANCE", pageESP, true, function(val)
    print("[ESP] Show Distance: " .. tostring(val))
end, 2)

-- COMBAT PAGE
createToggle("🎯 AIMBOT", pageCombat, false, function(val)
    print("[COMBAT] Aimbot: " .. tostring(val))
end, 1)

createToggle("🗡️ KILL AURA", pageCombat, false, function(val)
    print("[COMBAT] Kill Aura: " .. tostring(val))
end, 2)

createToggle("🔄 AUTO RELOAD", pageCombat, false, function(val)
    print("[COMBAT] Auto Reload: " .. tostring(val))
end, 3)

-- COLLECT PAGE (DENGAN AUTO COLLECT DARI ZHUB)
createToggle("🎒 AUTO COLLECT", pageCollect, false, function(val)
    collectSettings.Enabled = val
    print("[COLLECT] Auto Collect: " .. tostring(val))
    if val then
        if not collectLoopConnection then
            CreateAutoCollectVisuals()
            collectLoopConnection = RunService.Heartbeat:Connect(AutoCollectLoop)
        end
    else
        if collectLoopConnection then
            collectLoopConnection:Disconnect()
            collectLoopConnection = nil
        end
        if radiusRing then radiusRing.Visible = false end
        if fovCircle then fovCircle.Visible = false end
    end
end, 1)

-- MODE SELECTOR (RADIUS / MOUSE FOV)
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, -4, 0, TOGGLE_SMALL_HEIGHT)
modeFrame.LayoutOrder = 2
modeFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
modeFrame.BorderSizePixel = 0
modeFrame.Parent = pageCollect
Instance.new("UICorner", modeFrame).CornerRadius = UDim.new(0, 9)

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -100, 1, 0)
modeLabel.Position = UDim2.new(0, 10, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "🎯 MODE: RADIUS"
modeLabel.TextColor3 = Color3.fromRGB(210, 200, 230)
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = TEXT_SIZE_SMALL
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = modeFrame

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0, 80, 0, 28)
modeBtn.Position = UDim2.new(1, -88, 0.5, -14)
modeBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
modeBtn.Text = "RADIUS"
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 10
modeBtn.Parent = modeFrame
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)

modeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if collectSettings.Mode == 'Radius' then
        collectSettings.Mode = 'Mouse FOV'
        modeLabel.Text = "🎯 MODE: MOUSE FOV"
        modeBtn.Text = "MOUSE FOV"
    else
        collectSettings.Mode = 'Radius'
        modeLabel.Text = "🎯 MODE: RADIUS"
        modeBtn.Text = "RADIUS"
    end
    print("[COLLECT] Mode changed to: " .. collectSettings.Mode)
end)

-- SLIDER RADIUS
local radiusFrame = Instance.new("Frame")
radiusFrame.Size = UDim2.new(1, -4, 0, TOGGLE_SMALL_HEIGHT)
radiusFrame.LayoutOrder = 3
radiusFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
radiusFrame.BorderSizePixel = 0
radiusFrame.Parent = pageCollect
Instance.new("UICorner", radiusFrame).CornerRadius = UDim.new(0, 9)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, -60, 1, 0)
radiusLabel.Position = UDim2.new(0, 10, 0, 0)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "📏 RADIUS: " .. collectSettings.Radius
radiusLabel.TextColor3 = Color3.fromRGB(210, 200, 230)
radiusLabel.Font = Enum.Font.GothamBold
radiusLabel.TextSize = TEXT_SIZE_SMALL
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
radiusLabel.Parent = radiusFrame

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 30, 0, 24)
radiusDown.Position = UDim2.new(1, -38, 0.5, -12)
radiusDown.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
radiusDown.Text = "-"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.Font = Enum.Font.GothamBold
radiusDown.TextSize = 14
radiusDown.Parent = radiusFrame
Instance.new("UICorner", radiusDown).CornerRadius = UDim.new(0, 6)

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 30, 0, 24)
radiusUp.Position = UDim2.new(1, -72, 0.5, -12)
radiusUp.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(1, 1, 1)
radiusUp.Font = Enum.Font.GothamBold
radiusUp.TextSize = 14
radiusUp.Parent = radiusFrame
Instance.new("UICorner", radiusUp).CornerRadius = UDim.new(0, 6)

radiusDown.MouseButton1Click:Connect(function()
    collectSettings.Radius = math.max(5, collectSettings.Radius - 1)
    radiusLabel.Text = "📏 RADIUS: " .. collectSettings.Radius
    playClickSound()
end)

radiusUp.MouseButton1Click:Connect(function()
    collectSettings.Radius = math.min(50, collectSettings.Radius + 1)
    radiusLabel.Text = "📏 RADIUS: " .. collectSettings.Radius
    playClickSound()
end)

-- MOVEMENT PAGE
createToggle("🚀 FLY MODE", pageMovement, false, function(val)
    print("[MOVEMENT] Fly Mode: " .. tostring(val))
end, 1)

-- VISUALS PAGE
createToggle("☀️ FULLBRIGHT", pageVisuals, false, function(val)
    print("[VISUALS] Fullbright: " .. tostring(val))
end, 1)

createToggle("📊 FPS COUNTER", pageVisuals, true, function(val)
    print("[VISUALS] FPS Counter: " .. tostring(val))
end, 2)

-- FPS LABEL
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -20, 0, 30)
fpsLabel.LayoutOrder = 3
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 000"
fpsLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Parent = pageVisuals

-- UPDATE FPS
local frameCount = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    if not isRunning then return end
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = now
    end
end)

-- HP BAR
local hpFrame = Instance.new("Frame")
hpFrame.Size = UDim2.new(1, -20, 0, 50)
hpFrame.LayoutOrder = 4
hpFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
hpFrame.BorderSizePixel = 0
hpFrame.Parent = pageVisuals
Instance.new("UICorner", hpFrame).CornerRadius = UDim.new(0, 12)

local hpTitle = Instance.new("TextLabel")
hpTitle.Size = UDim2.new(1, 0, 0, 18)
hpTitle.Position = UDim2.new(0, 0, 0, 4)
hpTitle.BackgroundTransparency = 1
hpTitle.Text = "❤️ HP"
hpTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
hpTitle.Font = Enum.Font.GothamBold
hpTitle.TextSize = 10
hpTitle.TextXAlignment = Enum.TextXAlignment.Center
hpTitle.Parent = hpFrame

local hpBar = Instance.new("Frame")
hpBar.Size = UDim2.new(1, -10, 0, 14)
hpBar.Position = UDim2.new(0, 5, 0, 25)
hpBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hpBar.BorderSizePixel = 0
hpBar.Parent = hpFrame
Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 8)

local hpFill = Instance.new("Frame")
hpFill.Size = UDim2.new(1, 0, 1, 0)
hpFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
hpFill.BorderSizePixel = 0
hpFill.Parent = hpBar
Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 8)

-- UPDATE HP
task.spawn(function()
    while isRunning do
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
        task.wait(0.1)
    end
end)

-- ============================================================
-- TAB NAVIGATION
-- ============================================================
local function showPage(page)
    local pages = {pageESP, pageCombat, pageCollect, pageMovement, pageVisuals}
    for _, p in pairs(pages) do
        if p then p.Visible = false end
    end
    if page then page.Visible = true end
end

showPage(pageCollect)
setActiveTab(tabCollect)

tabESP.MouseButton1Click:Connect(function()
    showPage(pageESP)
    setActiveTab(tabESP)
    playClickSound()
end)

tabCombat.MouseButton1Click:Connect(function()
    showPage(pageCombat)
    setActiveTab(tabCombat)
    playClickSound()
end)

tabCollect.MouseButton1Click:Connect(function()
    showPage(pageCollect)
    setActiveTab(tabCollect)
    playClickSound()
end)

tabMovement.MouseButton1Click:Connect(function()
    showPage(pageMovement)
    setActiveTab(tabMovement)
    playClickSound()
end)

tabVisuals.MouseButton1Click:Connect(function()
    showPage(pageVisuals)
    setActiveTab(tabVisuals)
    playClickSound()
end)

-- ============================================================
-- DRAG WINDOW
-- ============================================================
local isDragging = false
local dragOffset = Vector2.new(0, 0)

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ============================================================
-- RESIZE WINDOW
-- ============================================================
local isResizing = false
local resizeStartPos = Vector2.new(0, 0)
local resizeStartSize = Vector2.new(WIDTH, HEIGHT)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

-- ============================================================
-- UPDATE RESIZE HANDLE POSITION
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not mainFrame or not mainFrame.Parent then return end
    if not mainFrame.Visible then return end

    local pos = mainFrame.Position
    local sz = mainFrame.Size
    resizeHandle.Position = UDim2.new(
        pos.X.Scale, pos.X.Offset + sz.X.Offset - 24,
        pos.Y.Scale, pos.Y.Offset + sz.Y.Offset - 24
    )
end)

-- ============================================================
-- INIT
-- ============================================================
print("✅ R4NzDev + ZHub UI berhasil dimuat!")
print("🔹 5 Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS")
print("🔹 AUTO COLLECT dari ZHub telah ditambahkan di tab COLLECT")
print("🔹 Mode: Radius (lingkaran 3D) atau Mouse FOV (lingkaran di layar)")
print("🔹 Tekan dan tahan header untuk drag window")
print("🔹 Tekan dan tahan ↘️ untuk resize")
print("🔹 Scroll halaman dengan sentuhan")