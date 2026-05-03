-- ============================================
-- R4NzDev UI + Auto Pickup (dari SPYMM v8.3)
-- Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS
-- ============================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local scriptKey = "R4NzDev_AutoPickup"

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("R4NzDev") then
    CoreGui.R4NzDev:Destroy()
end

local isRunning = true
local connections = {}
_G[scriptKey] = function()
    isRunning = false
    stopAutoPickup()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    local old = CoreGui:FindFirstChild("R4NzDev")
    if old then old:Destroy() end
end

-- ============================================================
-- AUTO PICKUP (dari SPYMM v8.3)
-- ============================================================
local autoPickupActive = false
local autoPickupThread = nil
local autoPickupAttempts = {}
local droppedItemsFolder = nil

-- Remote Events
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local pickUpItemRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("PickUpItem")
local adjustBackpackRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AdjustBackpack")

-- Item lists (dari SPYMM)
local pickupItemSet = {
    -- Guns
    ["AA-12"]=true,["AK-47"]=true,["Assault Rifle"]=true,["Desert Eagle"]=true,["Double Barrel"]=true,
    ["Flamethrower"]=true,["Grenade Launcher"]=true,["LMG"]=true,["MediGun"]=true,["Pistol"]=true,
    ["Ray Gun"]=true,["Revolver"]=true,["Rifle"]=true,["Shotgun"]=true,["Sniper"]=true,["SVD"]=true,["Uzi"]=true,
    -- Melee
    ["Bat"]=true,["Chainsaw"]=true,["Crowbar"]=true,["Fire Axe"]=true,["Hatchet"]=true,["Katana"]=true,["Knife"]=true,
    ["Riot Shield"]=true,["Scythe"]=true,["Sledgehammer"]=true,["Spear"]=true,["Spiked Bat"]=true,
    -- Medical
    ["Bandage"]=true,["Compound H"]=true,["Compound I"]=true,["Compound R"]=true,["Compound S"]=true,["Medkit"]=true,
    -- Armor
    ["Power Armor"]=true,["Light Armor"]=true,["Medium Armor"]=true,["Heavy Armor"]=true,
    -- Food
    ["Chips"]=true,["Carrot"]=true,["Bloxiade"]=true,["Beans"]=true,["MRE"]=true,["Bloxy Cola"]=true,
    -- Ammo
    ["Ammo Box"]=true,["Long Ammo"]=true,["Medium Ammo"]=true,["Pistol Ammo"]=true,["Shells"]=true,
    -- Structures
    ["Ammo Crate"]=true,["Barbed Wire"]=true,["Bear Trap"]=true,["Boost Pad"]=true,["Electric Fence"]=true,
    ["Farm Plot"]=true,["Fence"]=true,["Floodlight"]=true,["Gate"]=true,["Landmine"]=true,["Map"]=true,
    ["Repair Drone"]=true,["Shelf"]=true,["Teleporter"]=true,["Time Machine"]=true,["Turret"]=true,
    ["Wall"]=true,["Watchtower"]=true,
    -- Backpacks
    ["Basic Backpack"]=true,["Good Backpack"]=true,["Great Backpack"]=true,
    -- Misc
    ["Grenade"]=true,["Molotov"]=true,["Emerald"]=true,["Gas Mask"]=true,
    ["Blueprint"]=true,["Military Keycard"]=true,["Repair Hammer"]=true,["Suppressor"]=true,
}

local itemNames = {}
for k in pairs(pickupItemSet) do
    table.insert(itemNames, k)
end
table.sort(itemNames)

local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

local function discoverDroppedItemsFolder()
    droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")
end
discoverDroppedItemsFolder()

-- Auto Pickup Settings
local autoPickupSettings = {
    Enabled = false,
    Radius = 20,
    AllItems = true,
    Whitelist = {},
    Blacklist = {},
    UseRemote = true,
    UseTouch = true,
    UsePrompt = true,
}

local function stopAutoPickup()
    autoPickupActive = false
    if autoPickupThread then
        pcall(function() task.cancel(autoPickupThread) end)
        autoPickupThread = nil
    end
    pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
    autoPickupAttempts = {}
end

local function startAutoPickup()
    stopAutoPickup()
    autoPickupActive = true

    pcall(function() if setsimulationradius then setsimulationradius(2048, 2048) end end)

    autoPickupThread = task.spawn(function()
        while autoPickupActive and autoPickupSettings.Enabled do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not droppedItemsFolder then 
                task.wait(0.5) 
                discoverDroppedItemsFolder()
                goto continue 
            end

            local myPos = hrp.Position
            local radius = autoPickupSettings.Radius
            local allItems = autoPickupSettings.AllItems
            local whitelist = autoPickupSettings.Whitelist
            local blacklist = autoPickupSettings.Blacklist
            local useRemote = autoPickupSettings.UseRemote
            local useTouch = autoPickupSettings.UseTouch
            local usePrompt = autoPickupSettings.UsePrompt

            for _, item in ipairs(droppedItemsFolder:GetChildren()) do
                if not autoPickupActive then break end
                if not item.Parent then continue end

                -- Filter berdasarkan whitelist/blacklist
                if not allItems and not whitelist[item.Name] then continue end

                local mainPart = getItemMainPart(item)
                if not mainPart then continue end

                local dist = (mainPart.Position - myPos).Magnitude
                if dist > radius then continue end

                -- Rate limit per item
                local now = tick()
                if autoPickupAttempts[item] and (now - autoPickupAttempts[item]) < 0.35 then continue end
                autoPickupAttempts[item] = now

                -- Method A: Remote
                if useRemote then
                    if not blacklist[item.Name] then
                        pcall(function()
                            if pickUpItemRemote then pickUpItemRemote:FireServer(item) end
                        end)
                    end
                    pcall(function()
                        if adjustBackpackRemote then adjustBackpackRemote:FireServer(item) end
                    end)
                end

                -- Method B: firetouchinterest
                if useTouch then
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(hrp, mainPart, 0)
                            firetouchinterest(hrp, mainPart, 1)
                        end
                    end)
                end

                -- Method C: ProximityPrompt
                if usePrompt then
                    pcall(function()
                        if fireproximityprompt then
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                        end
                    end)
                end

                task.wait()
            end

            -- Cleanup attempt map
            for itemRef in pairs(autoPickupAttempts) do
                if not itemRef.Parent then
                    autoPickupAttempts[itemRef] = nil
                end
            end

            task.wait(0.1)
            ::continue::
        end
        autoPickupActive = false
        pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
    end)
end

local function toggleAutoPickup(enabled)
    autoPickupSettings.Enabled = enabled
    if enabled then
        discoverDroppedItemsFolder()
        startAutoPickup()
    else
        stopAutoPickup()
    end
end

-- ============================================================
-- UI SETTINGS
-- ============================================================
local isTouch = UserInputService.TouchEnabled
local WIDTH = isTouch and 300 or 460
local HEIGHT = isTouch and 250 or 310
local SIDEBAR_WIDTH = isTouch and 85 or 105
local HEADER_HEIGHT = isTouch and 42 or 46
local TAB_FONT_SIZE = isTouch and 9 or 11
local TOGGLE_HEIGHT = isTouch and 32 or 36
local TEXT_SIZE_SMALL = isTouch and 10 or 12
local TEXT_SIZE_MEDIUM = isTouch and 13 or 15
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
titleLabel.Text = "R4NzDev + AutoPickup"
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

-- MINI ICON
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
local function createToggle(label, parent, defaultValue, callback, order)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -4, 0, TOGGLE_HEIGHT)
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

-- ============================================================
-- COLLECT PAGE (AUTO PICKUP DARI SPYMM)
-- ============================================================

-- Main toggle
createToggle("🎒 AUTO PICKUP", pageCollect, false, function(val)
    toggleAutoPickup(val)
    print("[COLLECT] Auto Pickup: " .. tostring(val))
end, 1)

-- Radius slider
local radiusFrame = Instance.new("Frame")
radiusFrame.Size = UDim2.new(1, -4, 0, TOGGLE_SMALL_HEIGHT)
radiusFrame.LayoutOrder = 2
radiusFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
radiusFrame.BorderSizePixel = 0
radiusFrame.Parent = pageCollect
Instance.new("UICorner", radiusFrame).CornerRadius = UDim.new(0, 9)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, -60, 1, 0)
radiusLabel.Position = UDim2.new(0, 10, 0, 0)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "📏 RADIUS: " .. autoPickupSettings.Radius
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
    autoPickupSettings.Radius = math.max(5, autoPickupSettings.Radius - 1)
    radiusLabel.Text = "📏 RADIUS: " .. autoPickupSettings.Radius
    playClickSound()
    if autoPickupSettings.Enabled then
        stopAutoPickup()
        startAutoPickup()
    end
end)

radiusUp.MouseButton1Click:Connect(function()
    autoPickupSettings.Radius = math.min(35, autoPickupSettings.Radius + 1)
    radiusLabel.Text = "📏 RADIUS: " .. autoPickupSettings.Radius
    playClickSound()
    if autoPickupSettings.Enabled then
        stopAutoPickup()
        startAutoPickup()
    end
end)

-- All Items toggle
createToggle("📦 ALL ITEMS", pageCollect, true, function(val)
    autoPickupSettings.AllItems = val
    print("[COLLECT] All Items: " .. tostring(val))
end, 3)

-- Method A toggle
createToggle("🔌 METHOD A (REMOTE)", pageCollect, true, function(val)
    autoPickupSettings.UseRemote = val
    print("[COLLECT] Method A (Remote): " .. tostring(val))
end, 4)

-- Method B toggle
createToggle("🖐️ METHOD B (TOUCH)", pageCollect, true, function(val)
    autoPickupSettings.UseTouch = val
    print("[COLLECT] Method B (Touch): " .. tostring(val))
end, 5)

-- Method C toggle
createToggle("💬 METHOD C (PROMPT)", pageCollect, true, function(val)
    autoPickupSettings.UsePrompt = val
    print("[COLLECT] Method C (Prompt): " .. tostring(val))
end, 6)

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
        local character = LocalPlayer.Character
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
local lastMousePos = Vector2.new(0, 0)

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        lastMousePos = UserInputService:GetMouseLocation()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos
        
        local newX = mainFrame.Position.X.Offset + delta.X
        local newY = mainFrame.Position.Y.Offset + delta.Y
        
        mainFrame.Position = UDim2.new(0, newX, 0, newY)
        glowFrame.Position = UDim2.new(0, newX - 2, 0, newY - 2)
        
        local newHandleX = newX + mainFrame.Size.X.Offset - 24
        local newHandleY = newY + mainFrame.Size.Y.Offset - 24
        resizeHandle.Position = UDim2.new(0, newHandleX, 0, newHandleY)
    end
end)

-- ============================================================
-- RESIZE WINDOW
-- ============================================================
local isResizing = false
local resizeStartPos = Vector2.new(0, 0)
local resizeStartSize = Vector2.new(WIDTH, HEIGHT)
local resizeStartMouse = Vector2.new(0, 0)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        resizeStartMouse = UserInputService:GetMouseLocation()
        resizeStartSize = Vector2.new(mainFrame.Size.X.Offset, mainFrame.Size.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isResizing = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - resizeStartMouse
        
        local newWidth = math.max(resizeStartSize.X + delta.X, isTouch and 260 or 300)
        local newHeight = math.max(resizeStartSize.Y + delta.Y, isTouch and 200 or 230)
        
        newWidth = math.clamp(newWidth, isTouch and 260 or 300, isTouch and 500 or 720)
        newHeight = math.clamp(newHeight, isTouch and 200 or 230, isTouch and 480 or 600)
        
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        glowFrame.Size = UDim2.new(0, newWidth + 4, 0, newHeight + 4)
        
        local pos = mainFrame.Position
        resizeHandle.Position = UDim2.new(0, pos.X.Offset + newWidth - 24, 0, pos.Y.Offset + newHeight - 24)
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
    resizeHandle.Position = UDim2.new(0, pos.X.Offset + sz.X.Offset - 24, 0, pos.Y.Offset + sz.Y.Offset - 24)
end)

-- Discover dropped items folder periodically
task.spawn(function()
    while isRunning do
        discoverDroppedItemsFolder()
        task.wait(10)
    end
end)

-- ============================================================
-- INIT
-- ============================================================
print("✅ R4NzDev + Auto Pickup (SPYMM) berhasil dimuat!")
print("🔹 5 Tab: ESP | COMBAT | COLLECT | MOVEMENT | VISUALS")
print("🔹 AUTO PICKUP: 4 metode FE (Remote, Touch, Prompt)")
print("🔹 Item terdaftar: " .. #itemNames .. " item")
print("🔹 Tekan dan tahan header untuk drag window")
print("🔹 Tekan dan tahan ↘️ untuk resize")