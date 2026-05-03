--[[
    SPYMM v8.3 - Exploits Only (Dengan Floating Button Auto Pickup - FULLY WORKING)
    Ukuran icon 45x45, bisa ON/OFF, bisa drag/geser
]]

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- REMOTES
-- ============================================
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

local pickUpItemRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("PickUpItem")
local adjustBackpackRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AdjustBackpack")

-- ============================================
-- OBSIDIAN UI SETUP
-- ============================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "SPYMM v8.3 - Exploits Only",
    Footer = "Survive the Apocalypse",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Exploits = Window:AddTab("Exploits", "zap"),
    ["UI Settings"] = Window:AddTab("UI Settings", "sliders-horizontal"),
}

-- ============================================
-- STATE VARIABLES
-- ============================================
local connections = {}
local autoPickupActive = false
local autoPickupThread = nil
local autoPickupAttempts = {}
local repairAuraConn = nil
local structuresFolder = nil
local floatingButton = nil

-- ============================================
-- FOLDER DISCOVERY
-- ============================================
local droppedItemsFolder = nil
local function discoverFolders()
    droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")
    structuresFolder = Workspace:FindFirstChild("Structures")
        or Workspace:FindFirstChild("PlayerStructures")
        or Workspace:FindFirstChild("Buildings")
end
discoverFolders()

task.spawn(function()
    while not Library.Unloaded do
        task.wait(5)
        discoverFolders()
    end
end)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

-- ============================================
-- FLOATING BUTTON (Ukuran 45x45, bisa drag & click)
-- ============================================
local function createFloatingButton()
    if floatingButton then return end
    
    -- Buat ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoPickupFloatingButton"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Tombol utama (ukuran 45x45)
    local button = Instance.new("ImageButton")
    button.Name = "ToggleButton"
    button.Size = UDim2.new(0, 45, 0, 45)
    button.Position = UDim2.new(0.85, 0, 0.5, 0)
    button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    button.BackgroundTransparency = 0.15
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = screenGui
    
    -- Corner bulat sempurna
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Stroke/border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 100)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Parent = button
    
    -- Icon magnet 🧲
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "🧲"
    icon.TextColor3 = Color3.fromRGB(0, 255, 150)
    icon.TextSize = 22
    icon.Font = Enum.Font.GothamBold
    icon.TextScaled = true
    icon.Parent = button
    
    -- Variabel untuk drag
    local dragging = false
    local dragStartPos = nil
    local buttonStartPos = nil
    local startMousePos = nil
    
    -- Fungsi update tampilan button (ON/OFF)
    local function updateButtonAppearance(isOn)
        if isOn then
            stroke.Color = Color3.fromRGB(0, 255, 100)
            stroke.Transparency = 0
            icon.Text = "🧲"
            icon.TextColor3 = Color3.fromRGB(0, 255, 150)
            button.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
            button.BackgroundTransparency = 0.1
        else
            stroke.Color = Color3.fromRGB(255, 80, 80)
            stroke.Transparency = 0.3
            icon.Text = "🧲"
            icon.TextColor3 = Color3.fromRGB(255, 100, 100)
            button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            button.BackgroundTransparency = 0.15
        end
    end
    
    -- Event untuk drag dan click (pakai MouseButton1)
    local isDragging = false
    local dragThreshold = 5
    
    button.MouseButton1Down:Connect(function(x, y)
        isDragging = false
        dragStartPos = Vector2.new(x, y)
        buttonStartPos = button.Position
        startMousePos = Vector2.new(x, y)
    end)
    
    button.MouseButton1Up:Connect(function(x, y)
        local endPos = Vector2.new(x, y)
        local distance = (endPos - dragStartPos).Magnitude
        
        -- Jika jarak kecil berarti klik (bukan drag)
        if distance <= dragThreshold then
            -- Toggle Auto Pickup
            if Toggles.AutoPickup then
                local currentState = Toggles.AutoPickup.Value
                Toggles.AutoPickup:Set(not currentState)
                updateButtonAppearance(not currentState)
                
                if not currentState then
                    startAutoPickup()
                    Library:Notify({ Title = "Auto Pickup", Description = "Enabled via floating button", Time = 1 })
                else
                    stopAutoPickup()
                    Library:Notify({ Title = "Auto Pickup", Description = "Disabled via floating button", Time = 1 })
                end
            end
        end
        
        isDragging = false
    end)
    
    -- Drag movement (pakai UserInputService untuk tracking)
    local dragConnection = nil
    local dragEndConnection = nil
    
    button.MouseButton1Down:Connect(function()
        -- Mulai drag
        local startPos = button.Position
        
        dragConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Delta
                if math.abs(delta.X) > 0 or math.abs(delta.Y) > 0 then
                    isDragging = true
                    local newX = startPos.X.Scale + (delta.X / game:GetService("CoreGui").AbsoluteSize.X)
                    local newY = startPos.Y.Scale + (delta.Y / game:GetService("CoreGui").AbsoluteSize.Y)
                    newX = math.clamp(newX, 0.03, 0.97)
                    newY = math.clamp(newY, 0.03, 0.97)
                    button.Position = UDim2.new(newX, 0, newY, 0)
                    startPos = button.Position
                end
            end
        end)
        
        dragEndConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dragConnection then dragConnection:Disconnect() end
                if dragEndConnection then dragEndConnection:Disconnect() end
            end
        end)
    end)
    
    -- Efek hover ringan
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0})
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        if Toggles.AutoPickup and Toggles.AutoPickup.Value then
            local leaveTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.1})
            leaveTween:Play()
        else
            local leaveTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.15})
            leaveTween:Play()
        end
    end)
    
    -- Simpan referensi
    floatingButton = {
        Gui = screenGui,
        Button = button,
        Update = updateButtonAppearance
    }
    
    -- Update status awal
    if Toggles.AutoPickup and Toggles.AutoPickup.Value then
        updateButtonAppearance(true)
    else
        updateButtonAppearance(false)
    end
    
    return floatingButton
end

local function destroyFloatingButton()
    if floatingButton then
        pcall(function() floatingButton.Gui:Destroy() end)
        floatingButton = nil
    end
end

-- ============================================
-- AUTO PICKUP
-- ============================================
local function stopAutoPickup()
    autoPickupActive = false
    if autoPickupThread then
        pcall(function() task.cancel(autoPickupThread) end)
        autoPickupThread = nil
    end
    pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
    autoPickupAttempts = {}
    
    if floatingButton and floatingButton.Update then
        floatingButton.Update(false)
    end
end

local function startAutoPickup()
    stopAutoPickup()
    autoPickupActive = true

    pcall(function() if setsimulationradius then setsimulationradius(2048, 2048) end end)
    
    if floatingButton and floatingButton.Update then
        floatingButton.Update(true)
    end

    autoPickupThread = task.spawn(function()
        while autoPickupActive and Toggles.AutoPickup and Toggles.AutoPickup.Value do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not droppedItemsFolder then task.wait(0.5) continue end

            local myPos = hrp.Position
            local radius = Options.AutoPickupRadius and Options.AutoPickupRadius.Value or 20
            local allItems = Toggles.AutoPickupAll and Toggles.AutoPickupAll.Value
            local whitelist = Options.AutoPickupWhitelist and Options.AutoPickupWhitelist.Value or {}
            local blacklist = Options.AutoPickupBlacklist and Options.AutoPickupBlacklist.Value or {}

            local useRemote = not Toggles.AutoPickupMethodRemote or Toggles.AutoPickupMethodRemote.Value
            local useTouch = not Toggles.AutoPickupMethodTouch or Toggles.AutoPickupMethodTouch.Value
            local usePrompt = not Toggles.AutoPickupMethodPrompt or Toggles.AutoPickupMethodPrompt.Value

            for _, item in ipairs(droppedItemsFolder:GetChildren()) do
                if not autoPickupActive then break end
                if not item.Parent then continue end

                if not allItems and not whitelist[item.Name] then continue end

                local mainPart = item.PrimaryPart or getItemMainPart(item)
                if not mainPart then continue end

                local dist = (mainPart.Position - myPos).Magnitude
                if dist > radius then continue end

                local now = tick()
                if autoPickupAttempts[item] and (now - autoPickupAttempts[item]) < 0.35 then continue end
                autoPickupAttempts[item] = now

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

                if useTouch then
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(hrp, mainPart, 0)
                            firetouchinterest(hrp, mainPart, 1)
                        end
                    end)
                end

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

            for itemRef in pairs(autoPickupAttempts) do
                if not itemRef.Parent then
                    autoPickupAttempts[itemRef] = nil
                end
            end

            task.wait(0.1)
        end

        autoPickupActive = false
        pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
        
        if floatingButton and floatingButton.Update then
            floatingButton.Update(false)
        end
    end)
end

-- ============================================
-- REPAIR AURA
-- ============================================
local function stopRepairAura()
    if repairAuraConn then
        repairAuraConn:Disconnect()
        repairAuraConn = nil
    end
end

local function startRepairAura()
    stopRepairAura()
    local lastFire = 0

    repairAuraConn = RunService.Heartbeat:Connect(function()
        if not Toggles.RepairAura or not Toggles.RepairAura.Value then return end

        local rate = Options.RepairAuraRate and Options.RepairAuraRate.Value or 1
        local interval = 1 / rate
        local now = tick()
        if now - lastFire < interval then return end

        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool or tool.Name ~= "Repair Hammer" then return end

        local repairRemote = tool:FindFirstChild("Repair")
        if not repairRemote then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local myPos = hrp.Position
        local maxDist = Options.RepairAuraRange and Options.RepairAuraRange.Value or 30

        if not structuresFolder then return end
        local nearest = nil
        local nearestDist = math.huge
        for _, child in ipairs(structuresFolder:GetDescendants()) do
            if child:IsA("Model") then
                local part = child.PrimaryPart or getItemMainPart(child)
                if part then
                    local dist = (myPos - part.Position).Magnitude
                    if dist <= maxDist and dist < nearestDist then
                        nearestDist = dist
                        nearest = child
                    end
                end
            end
        end

        if nearest then
            lastFire = now
            pcall(function()
                repairRemote:FireServer(nearest)
            end)
        end
    end)
end

-- ============================================
-- ITEM NAMES FOR DROPDOWNS
-- ============================================
local itemNames = {
    "AA-12", "AK-47", "Assault Rifle", "Desert Eagle", "Double Barrel",
    "Flamethrower", "Grenade Launcher", "LMG", "MediGun", "Pistol",
    "Ray Gun", "Revolver", "Rifle", "Shotgun", "Sniper", "SVD", "Uzi",
    "Bat", "Chainsaw", "Crowbar", "Fire Axe", "Hatchet", "Katana", "Knife",
    "Riot Shield", "Scythe", "Sledgehammer", "Spear", "Spiked Bat",
    "Bandage", "Compound H", "Compound I", "Compound R", "Compound S", "Medkit",
    "Power Armor", "Light Armor", "Medium Armor", "Heavy Armor",
    "Chips", "Carrot", "Bloxiade", "Beans", "MRE", "Bloxy Cola",
    "AC", "Battery", "Battery Pack", "Bucket", "Dumbell", "Exhaust Pipe",
    "Reactor Component", "Refined Metal", "Satellite Dish", "Scrap",
    "Screws", "Spatula", "Tray", "TV", "Watch", "Zombie Heart",
    "Nuclear Fuel", "Refined Fuel", "Fuel",
    "Ammo Box", "Long Ammo", "Medium Ammo", "Pistol Ammo", "Shells",
    "Grenade", "Molotov", "Basic Backpack", "Good Backpack", "Great Backpack",
    "Blueprint", "Military Keycard", "Repair Hammer", "Suppressor"
}
table.sort(itemNames)

-- ============================================
-- UI: EXPLOITS TAB
-- ============================================
do
    local autoPickupGroup = Tabs.Exploits:AddLeftGroupbox("Auto Pickup", "magnet")

    autoPickupGroup:AddToggle("AutoPickup", {
        Text = "Auto Pickup",
        Default = false,
        Tooltip = "Automatically picks up items within radius. Menampilkan floating button di layar.",
        Callback = function(state)
            if state then
                createFloatingButton()
                startAutoPickup()
                Library:Notify({ Title = "Auto Pickup", Description = "Active – Floating button muncul di layar", Time = 3 })
            else
                destroyFloatingButton()
                stopAutoPickup()
                Library:Notify({ Title = "Auto Pickup", Description = "Stopped", Time = 2 })
            end
        end,
    })

    autoPickupGroup:AddSlider("AutoPickupRadius", {
        Text = "Radius",
        Default = 20,
        Min = 5,
        Max = 35,
        Rounding = 0,
        Suffix = " studs",
        Tooltip = "How far away items are picked up.",
    })

    autoPickupGroup:AddToggle("AutoPickupAll", {
        Text = "All Items",
        Default = false,
        Tooltip = "Pick up every item. Disable to use whitelist.",
    })

    autoPickupGroup:AddDivider()
    autoPickupGroup:AddLabel("FE Methods (combine to test)")

    autoPickupGroup:AddToggle("AutoPickupMethodRemote", {
        Text = "A – Remote (PickUpItem)",
        Default = true,
        Tooltip = "FireServer on PickUpItem remote.",
    })

    autoPickupGroup:AddToggle("AutoPickupMethodTouch", {
        Text = "B – Touch Simulate",
        Default = true,
        Tooltip = "firetouchinterest - simulates touching the item.",
    })

    autoPickupGroup:AddToggle("AutoPickupMethodPrompt", {
        Text = "C – ProximityPrompt",
        Default = true,
        Tooltip = "fireproximityprompt - triggers proximity prompt.",
    })

    autoPickupGroup:AddDivider()
    autoPickupGroup:AddLabel("Item Whitelist (when All Items is off)")
    autoPickupGroup:AddDropdown("AutoPickupWhitelist", {
        Values = itemNames,
        Default = 1,
        Multi = true,
        Text = "Whitelist",
        Tooltip = "Items to pick up.",
        Searchable = true,
    })

    autoPickupGroup:AddDivider()
    autoPickupGroup:AddLabel("Blacklist (blocks PickUpItem remote)")
    autoPickupGroup:AddDropdown("AutoPickupBlacklist", {
        Values = itemNames,
        Default = {
            "Chips", "Carrot", "Bloxiade", "Beans", "MRE", "Bloxy Cola",
            "Nuclear Fuel", "Refined Fuel", "Fuel",
        },
        Multi = true,
        Text = "Blacklist",
        Tooltip = "Blacklisted items skip the PickUpItem remote.",
        Searchable = true,
    })

    -- Repair Aura
    local repairAuraGroup = Tabs.Exploits:AddRightGroupbox("Repair Aura", "wrench")

    repairAuraGroup:AddToggle("RepairAura", {
        Text = "Repair Aura",
        Default = false,
        Tooltip = "Automatically repairs structures within range. Repair Hammer must be equipped.",
        Callback = function(state)
            if state then
                startRepairAura()
                Library:Notify({ Title = "Repair Aura", Description = "Active – repairing structures", Time = 2 })
            else
                stopRepairAura()
                Library:Notify({ Title = "Repair Aura", Description = "Stopped", Time = 2 })
            end
        end,
    })

    repairAuraGroup:AddSlider("RepairAuraRange", {
        Text = "Range",
        Default = 30,
        Min = 5,
        Max = 30,
        Rounding = 0,
        Suffix = " studs",
        Tooltip = "Maximum distance to structures.",
    })

    repairAuraGroup:AddSlider("RepairAuraRate", {
        Text = "Rate",
        Default = 1,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Suffix = "/s",
        Tooltip = "How many repairs per second.",
    })

    repairAuraGroup:AddLabel("Requires: Repair Hammer equipped")
end

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(0.5)
    if Toggles.AutoPickup and Toggles.AutoPickup.Value then
        startAutoPickup()
    end
end)

-- ============================================
-- UNLOAD CLEANUP
-- ============================================
Library:OnUnload(function()
    for _, conn in ipairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    connections = {}

    stopAutoPickup()
    stopRepairAura()
    destroyFloatingButton()

    Library:Notify({ Title = "SPYMM", Description = "Unloaded. Bye!", Time = 3 })
    print("SPYMM v8.3 (Exploits Only) unloaded.")
end)

-- ============================================
-- UI SETTINGS TAB
-- ============================================
do
    local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

    MenuGroup:AddToggle("KeybindMenuOpen", {
        Default = Library.KeybindFrame.Visible,
        Text = "Open Keybind Menu",
        Callback = function(value)
            Library.KeybindFrame.Visible = value
        end,
    })

    MenuGroup:AddToggle("ShowCustomCursor", {
        Text = "Custom Cursor",
        Default = true,
        Callback = function(Value)
            Library.ShowCustomCursor = Value
        end,
    })

    MenuGroup:AddDropdown("NotificationSide", {
        Values = { "Left", "Right" },
        Default = "Right",
        Text = "Notification Side",
        Callback = function(Value)
            Library:SetNotifySide(Value)
        end,
    })

    MenuGroup:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",
        Text = "DPI Scale",
        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)
            Library:SetDPIScale(DPI)
        end,
    })

    MenuGroup:AddSlider("UICornerSlider", {
        Text = "Corner Radius",
        Default = Library.CornerRadius,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(value)
            Window:SetCornerRadius(value)
        end,
    })

    MenuGroup:AddDivider()
    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
end

Library.ToggleKeybind = Options.MenuKeybind

-- ============================================
-- THEME & SAVE MANAGERS
-- ============================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("SPYMM")
SaveManager:SetFolder("SPYMM/survive-the-apocalypse")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ============================================
-- INIT NOTIFICATION
-- ============================================
Library:Notify({ Title = "SPYMM v8.3", Description = "Exploits Only - Auto Pickup & Repair Aura\nFloating button 🧲 bisa diklik dan digeser\nRight Shift = toggle menu.", Time = 5 })
print("SPYMM v8.3 (Exploits Only) loaded | Right Shift = menu")