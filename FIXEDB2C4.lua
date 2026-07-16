local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local localPlayer = players.LocalPlayer or players:GetPropertyChangedSignal("LocalPlayer"):Wait() or players.LocalPlayer

-- Main ScreenGui setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalMenuGui_Delta"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = coreGui
else
    screenGui.Parent = coreGui
end

----------------------------------------------------
-- MAIN CONTAINER WINDOW
----------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 580, 0, 420)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false 
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

----------------------------------------------------
-- FLOATING TOGGLE BUTTON (Bilog sa Left-Middle)
----------------------------------------------------
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25) 
toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleButton.BackgroundTransparency = 0.1
toggleButton.Text = ""
toggleButton.Active = true
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 30, 30)
toggleStroke.Thickness = 1.5
toggleStroke.Transparency = 0.4
toggleStroke.Parent = toggleButton

local toggleIcon = Instance.new("ImageLabel")
toggleIcon.Size = UDim2.new(0, 28, 0, 28)
toggleIcon.Position = UDim2.new(0.5, -14, 0.5, -14)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://10840244199"
toggleIcon.ImageColor3 = Color3.fromRGB(255, 30, 30)
toggleIcon.Parent = toggleButton

----------------------------------------------------
-- DRAGGING FEATURE
----------------------------------------------------
local userInputService = game:GetService("UserInputService")

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

makeDraggable(mainFrame)
makeDraggable(toggleButton)

----------------------------------------------------
-- TOGGLE LOGIC
----------------------------------------------------
-- UPDATED TOGGLE LOGIC (Open & Close Cleanly)
----------------------------------------------------
local uiTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isMenuOpen = false -- Flag para subaybayan kung bukas o sarado ang UI
local isTweening = false -- Anti-spam check para iwas sira sa animation

local function minimizeToButton()
    if isTweening then return end
    isTweening = true
    
    local closeTween = TweenService:Create(mainFrame, uiTweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        mainFrame.Visible = false
        isMenuOpen = false
        isTweening = false
    end)
end

local function openMenu()
    if isTweening then return end
    isTweening = true
    
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0) -- Reset size bago mag-animate
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = TweenService:Create(mainFrame, uiTweenInfo, {
        Size = UDim2.new(0, 580, 0, 420),
        Position = UDim2.new(0.5, -290, 0.5, -210)
    })
    openTween:Play()
    openTween.Completed:Connect(function()
        isMenuOpen = true
        isTweening = false
    end)
end

-- Isang click function na lang para sa bilog na button
toggleButton.MouseButton1Click:Connect(function()
    if isMenuOpen then
        minimizeToButton() -- Kung bukas, isasara niya
    else
        openMenu() -- Kung sarado, bubuksan niya
    end
end)

----------------------------------------------------
-- TOP WINDOW CONTROL DOTS
----------------------------------------------------
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "Controls"
controlsFrame.Size = UDim2.new(0, 60, 0, 20)
controlsFrame.Position = UDim2.new(1, -75, 0, 15)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = mainFrame

local colors = {Color3.fromRGB(255, 95, 87), Color3.fromRGB(254, 188, 46), Color3.fromRGB(40, 200, 64)}
for i, color in ipairs(colors) do
    local dot = Instance.new("TextButton")
    dot.Name = "ControlDot" .. i
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, (i - 1) * 20, 0, 4)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Text = ""
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    dot.Parent = controlsFrame
    
    dot.MouseButton1Click:Connect(minimizeToButton)
end

-- Top Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "IOHUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Top Left Logo
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 15, 0, 12)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://10840244199" 
logo.ImageColor3 = Color3.fromRGB(255, 30, 30)
logo.Parent = mainFrame

----------------------------------------------------
-- NAVIGATION & PAGES HOLDER SETUP
----------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local uiListSide = Instance.new("UIListLayout")
uiListSide.Padding = UDim.new(0, 8)
uiListSide.SortOrder = Enum.SortOrder.LayoutOrder
uiListSide.Parent = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -195, 1, -65)
contentFrame.Position = UDim2.new(0, 180, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentFrame.BackgroundTransparency = 0.4
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local clientHeader = Instance.new("TextLabel")
clientHeader.Size = UDim2.new(1, -30, 0, 35)
clientHeader.Position = UDim2.new(0, 15, 0, 10)
clientHeader.BackgroundTransparency = 1
clientHeader.Text = "Client"
clientHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
clientHeader.Font = Enum.Font.GothamBold
clientHeader.TextSize = 16
clientHeader.TextXAlignment = Enum.TextXAlignment.Left
clientHeader.Parent = contentFrame

local tabs = {}
local pages = {}
local activeTab = nil

local function createPageContainer()
    local scrollPage = Instance.new("ScrollingFrame")
    scrollPage.Size = UDim2.new(1, -10, 1, -50)
    scrollPage.Position = UDim2.new(0, 5, 0, 45)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPage.ScrollBarThickness = 2
    scrollPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollPage.Visible = false
    scrollPage.Parent = contentFrame

    local uiListContent = Instance.new("UIListLayout")
    uiListContent.Padding = UDim.new(0, 14)
    uiListContent.SortOrder = Enum.SortOrder.LayoutOrder
    uiListContent.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListContent.Parent = scrollPage
    
    uiListContent:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollPage.CanvasSize = UDim2.new(0, 0, 0, uiListContent.AbsoluteContentSize.Y + 20)
    end)

    return scrollPage
end

local function switchTab(tabName)
    for name, btnElements in pairs(tabs) do
        if name == tabName then
            btnElements.Button.BackgroundTransparency = 0.9
            btnElements.Icon.ImageColor3 = Color3.fromRGB(255, 100, 120)
            btnElements.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            if btnElements.Stroke then btnElements.Stroke.Enabled = true end
            
            pages[name].Visible = true
            clientHeader.Text = name
        else
            btnElements.Button.BackgroundTransparency = 1
            btnElements.Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
            btnElements.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            if btnElements.Stroke then btnElements.Stroke.Enabled = false end
            
            pages[name].Visible = false
        end
    end
    activeTab = tabName
end

local function createSidebarTab(name, iconId, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 20, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Enabled = false
    stroke.Parent = btn
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    icon.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
    
    btn.Parent = sidebar
    
    tabs[name] = {Button = btn, Icon = icon, Label = lbl, Stroke = stroke}
    pages[name] = createPageContainer()
end

----------------------------------------------------
-- TOGGLE CREATOR (May On/Off switch)
----------------------------------------------------
local function createToggle(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 55)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        if callback then callback(enabled) end
    end)
    
    toggleBtn.Parent = row
    row.Parent = targetPage
end

----------------------------------------------------
-- NEW: BUTTON CREATOR (Katulad ng Export Configs)
----------------------------------------------------
local function createButton(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 55)
    row.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    -- Ang mismong Clickable Icon Button na gaya ng nasa screenshot mo (Mouse/Click Icon)
    local actionBtn = Instance.new("ImageButton")
    actionBtn.Size = UDim2.new(0, 22, 0, 22)
    actionBtn.Position = UDim2.new(1, -35, 0.5, -11)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Image = "rbxassetid://10734896206" -- Mouse click cursor icon asset
    actionBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
    
    -- Click Effect (Slight flash)
    actionBtn.MouseButton1Click:Connect(function()
        actionBtn.ImageColor3 = Color3.fromRGB(255, 100, 120)
        task.wait(0.1)
        actionBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
        if callback then callback() end
    end)
    
    actionBtn.Parent = row
    row.Parent = targetPage
end

----------------------------------------------------
-- POPULATING TABS & CONTENT
----------------------------------------------------
createSidebarTab("Yen", "rbxassetid://10822165440", 1)
createSidebarTab("Section 1", "rbxassetid://10723345479", 2)
createSidebarTab("Section 2", "rbxassetid://10723345479", 3)
createSidebarTab("Section 3", "rbxassetid://10723345479", 4)
createSidebarTab("Section 4", "rbxassetid://10723345479", 5)
createSidebarTab("Section 5", "rbxassetid://10723345479", 6)
createSidebarTab("Core Settings", "rbxassetid://10734951111", 7)

-- Welcome Tab Content
createToggle("Yen", "Esp Yen", "Display Yen Location.", function(state)
    print("Welcome Intro Set:", state)
end)

-- Client Tab Content (Dito ko nilagay yung Teleport Buttons mo)
createButton("Section 1", "Skip Enzukai", "Teleport to White Door.", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = CFrame.new(4944.86719, -64.27565, 1206.07715) -- Baguhin mo rito ang coordinates ng pupuntahan
    end
end)



createButton("Section 1", "Floor 6 NPC", "Teleport to NPC in Floor 6 and auto interact", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        -- 1. Teleport sa NPC
        rootPart.CFrame = CFrame.new(4449.49902, 43.9929123, 1659.43604)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Clear momentum para iwas talsik
        
        -- 2. Maikling pahinga para mag-sync ang character sa bagong posisyon
        task.wait(0.2)
        
        -- 3. Scan at fire ng malapit na ProximityPrompt (20 studs radius mula sa NPC coordinates)
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local target = prompt.Parent
                if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                    local promptPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                    local distance = (rootPart.Position - promptPos).Magnitude
                    
                    if distance <= 20 then
                        prompt.HoldDuration = 0 -- Bypass holding delay
                        fireproximityprompt(prompt)
                        break -- Hihinto na kapag nahanap at na-fire na ang prompt ng NPC
                    end
                end
            end
        end
    end
end)


createButton("Section 1", "Auto Code & Shovel", "Bypasses Keypad and safely collects Shovel with perfect timing", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        -- [[ CONFIGURATIONS & CFRAMES ]]
        local keypadCFrame = CFrame.new(4471.92773, 43.9939728, 1634.44971, 0.999974132, -3.06141068e-09, -0.00719286967, 2.99835112e-09, 1, -8.77774298e-09, 0.00719286967, 8.75594885e-09, 0.999974132)
        local shovelCFrame = CFrame.new(4464.73975, 43.9939728, 1625.5343, 0.220124543, -8.13470194e-11, 0.975471795, -1.96750491e-10, 1, 1.27791111e-10, -0.975471795, -2.20054516e-10, 0.220124543)
        
        local floors = {"6thFloor", "5thFloor", "4thFloor", "3rdFloor", "2ndFloor", "1stFloor"}
        local codeTable = {}
        local success = true
        
        -- [[ STEP 1: SILENT CODE SCANNER ]]
        for _, fName in pairs(floors) do
            local folder = workspace:FindFirstChild("Section1")
            local objective = folder and folder:FindFirstChild("PlayerObjective")
            local codeNums = objective and objective:FindFirstChild("CodeNumbers")
            local floor = codeNums and codeNums:FindFirstChild(fName)
            local surfaceGui = floor and floor:FindFirstChild("SurfaceGui")
            local randomLabel = surfaceGui and surfaceGui:FindFirstChild("Random")
            
            if randomLabel and randomLabel:IsA("TextLabel") then
                local codeStr = (randomLabel.ContentText ~= "" and randomLabel.ContentText) or randomLabel.Text
                local codeNum = tonumber(codeStr)
                if codeNum then
                    table.insert(codeTable, codeNum)
                else
                    success = false; break
                end
            else
                success = false; break
            end
        end
        
        -- Safe Check kung nabasa ba lahat ng floor numbers
        if not success or #codeTable ~= 6 then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB Error",
                Text = "❌ Hindi mabasa ang mga numero sa floors! Subukan ulit.",
                Duration = 3
            })
            return
        end
        
        -- [[ STEP 2: TP SA KEYPAD AT SPECIFIC PROMPT FIRE ]]
        rootPart.CFrame = keypadCFrame
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        task.wait(0.3) -- Sync delay pagkalapag
        
        -- Dito natin sinisiguro na sa CodeDoor model LANG kukuha ng prompt para hindi malito sa ibang pinto
        local codeDoorFolder = workspace:FindFirstChild("Section1") 
                               and workspace.Section1:FindFirstChild("PlayerObjective") 
                               and workspace.Section1.PlayerObjective:FindFirstChild("CodeDoor")
                               
        if codeDoorFolder then
            for _, obj in pairs(codeDoorFolder:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    obj.HoldDuration = 0
                    fireproximityprompt(obj)
                    break -- Isang fire lang sa keypad, hinto na agad ang scan
                end
            end
        end
        task.wait(0.2)
        
        -- [[ STEP 3: REMOTE EVENT FIRE BYPASS ]]
        local remote = codeDoorFolder and (codeDoorFolder:FindFirstChild("Remote") or codeDoorFolder:FindFirstChild("RemoteEvent"))
                       
        if remote then
            remote:FireServer(1, codeTable)
        end
        
        -- ATTEMPT DELAY: 0.8 seconds na hihintayin para maproseso ng server ang code bago lumipad sa pala
        task.wait(0.8) 
        
        -- [[ STEP 4: TP SA LALAGYAN NG PALA (SHOVEL) ]]
        rootPart.CFrame = shovelCFrame
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        task.wait(0.4) -- Delay para mag-load ang shovel model at prompt sa screen mo
        
        -- Pagkuha ng Pala gamit ang eksaktong Pangalan nito sa workspace (Recursive search)
        local shovelObj = workspace:FindFirstChild("Shovel", true) -- Palitan ang "Shovel" kung iba ang name sa explorer
        if shovelObj then
            local prompt = shovelObj:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                prompt.HoldDuration = 0
                fireproximityprompt(prompt)
            end
        else
            -- Back-up scan kung sakaling naka-attach sa iba ang shovel prompt
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local promptPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        if (rootPart.Position - promptPos).Magnitude <= 15 then
                            prompt.HoldDuration = 0
                            fireproximityprompt(prompt)
                            break
                        end
                    end
                end
            end
        end
        
        -- [[ FINAL SUCCESS NOTIFICATION ]]
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Success",
            Text = "🔓 Code Submitted & Shovel Collected Safely!",
            Duration = 3
        })
    end)
end)



createButton("Section 2", "Auto Walkie Talkie", "Automatically completes all NPCs and leaves", function()
    -- Gagamit ng task.spawn para mag-run sa background nang hindi nagla-lag ang menu
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return end

        -- Helper function para maghanap at mag-fire ng pinakamalapit na prompt pagkatapos mag-TP
        local function interactWithNearestPrompt()
            task.wait(0.5) -- Bigyan ng 0.5 seconds ang laro para mag-load ang character sa bagong posisyon
            
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        local distance = (rootPart.Position - targetPos).Magnitude
                        
                        -- Dahil nag-teleport ka na sa mismong pwesto nila, dapat napakababa lang ng distansya (e.g. within 15 studs)
                        if distance <= 15 then
                            fireproximityprompt(prompt)
                            break -- Tapos na sa prompt na ito, proceed sa susunod na NPC
                        end
                    end
                end
            end
        end

        -- [[ START OF AUTO FARM ROUTINE ]]
        
        -- 1. Teleport to NPC 1 + Interact
        rootPart.CFrame = CFrame.new(-1218.073, -165.374435, -963.733826)
        interactWithNearestPrompt()
        task.wait(0.1) -- Kaunting pahinga bago lumipat sa susunod

        -- 2. Teleport to NPC 2 + Interact
        rootPart.CFrame = CFrame.new(-1194.18591, -165.374435, -1003.34747)
        interactWithNearestPrompt()
        task.wait(0.1)

        -- 3. Teleport to NPC 3 + Interact
        rootPart.CFrame = CFrame.new(-1144.55237, -142.647232, -1037.26892)
        interactWithNearestPrompt()
        task.wait(0.1)

        -- 4. Teleport to NPC 4 + Interact
        rootPart.CFrame = CFrame.new(-1108.55176, -142.274261, -1038.53027)
        interactWithNearestPrompt()
        task.wait(0.1) -- Medyo habasan natin bago mag-leave para sure na pumasok yung huling prompt

        -- 5. LEAVE THE MALL
        rootPart.CFrame = CFrame.new(-1335.1084, -165.374435, -1118.14185)

        -- Notification pag tapos na lahat!
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Auto-Quest",
            Text = "Walkie Talkie Quest Finished!",
            Duration = 5
        })
    end)
end)

if _G.NextCoinIndex == nil then _G.NextCoinIndex = 1 end

createButton("Section 2", "Instant Collect 5 Coins", "Instant TPs to next 5 coins, deposits, and goes to Escalator", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local runService = game:GetService("RunService")
        
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local carouselCFrame = CFrame.new(-1284.86865, -141.74498, -1096.00964)
        -- Safe Escalator CFrame
        local escalatorCFrame = CFrame.new(-1160.70581, -149.304581, -1011.77954, 0.991296649, -7.29874339e-09, 0.131647274, 8.19504553e-09, 1, -6.26657481e-09, -0.131647274, 7.29089011e-09, 0.991296649)
        
        
        
        -- INSTANT TELEPORT ENGINE (Bypass Tween)
        local function instantTeleport(targetCFrame)
            rootPart.CFrame = targetCFrame
            -- Patayin ang momentum para hindi mag-slide o mag-rubberband
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            task.wait(0.1) -- Sobrang bilis na antala para mag-sync ang physics sa server
        end
        
        -- 1. Ipunin ang mga barya
        local allCoins = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") and obj.Parent then
                table.insert(allCoins, obj)
            end
        end
        
        local totalCoinsFound = #allCoins
        if totalCoinsFound == 0 or _G.NextCoinIndex > totalCoinsFound then
            _G.NextCoinIndex = 1
            if batchNoclip then batchNoclip:Disconnect() end
            return
        end
        
        local coinsCollectedThisBatch = 0
        local maxPerBatch = 5
        
        -- 2. Kolektahin ang barya gamit ang Instant Teleport
        while coinsCollectedThisBatch < maxPerBatch and _G.NextCoinIndex <= totalCoinsFound do
            local targetCoin = allCoins[_G.NextCoinIndex]
            if targetCoin and targetCoin.Parent then
                -- Teleport direkta sa ibabaw ng barya
                instantTeleport(targetCoin.CFrame * CFrame.new(0, 1.5, 0))
                
                local prompt = targetCoin:FindFirstChildOfClass("ProximityPrompt") or targetCoin.Parent:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    prompt.HoldDuration = 0
                    fireproximityprompt(prompt)
                end
                coinsCollectedThisBatch = coinsCollectedThisBatch + 1
                task.wait(0.3) -- Sobrang bilis na transition bago lumipat sa sunod
            end
            _G.NextCoinIndex = _G.NextCoinIndex + 1
        end
        
        -- 3. Deposit sa Carousel at TP sa Escalator
        if coinsCollectedThisBatch > 0 then
            -- Teleport agad sa Carousel deposit box
            instantTeleport(carouselCFrame)
            task.wait(0.2)
            
            -- Fire Deposit Prompt
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local promptPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        if (rootPart.Position - promptPos).Magnitude <= 25 then
                            prompt.HoldDuration = 0
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
            
            -- Pagkatapos mag-deposit, teleport agad sa Safe Escalator
            task.wait(0.2)
            rootPart.CFrame = escalatorCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB Success",
                Text = "⚡ Instant deposit done! Teleported to Safe Escalator.",
                Duration = 2
            })
        end
        
        if batchNoclip then batchNoclip:Disconnect() end
    end)
end)






createButton("Section 2", "Batch Auto Punch Eyes", "Stable auto punch per wave with safe escalator purge", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return end
        
        local section2 = workspace:FindFirstChild("Section2")
        local floor1 = section2 and section2:FindFirstChild("Floor1")
        local timedTrial = floor1 and floor1:FindFirstChild("TimedTrial")
        local safeEscalator = CFrame.new(-1160.70581, -149.304581, -1011.77954, 0.991296649, -7.29874339e-09, 0.131647274, 8.19504553e-09, 1, -6.26657481e-09, -0.131647274, 7.29089011e-09, 0.991296649) -- Siguraduhing tama ang coords mo rito
        
        if not timedTrial then return end
        
        -- Kunin ang kasalukuyang folder base sa global counter
        if _G.CurrentEyeWave == nil then _G.CurrentEyeWave = 1 end
        local currentFolder = timedTrial:FindFirstChild(tostring(_G.CurrentEyeWave))
        
        if not currentFolder then
            _G.CurrentEyeWave = 1
            return
        end
        
        -- Ipunin ang mga mata sa folder na ito
        local activeTargets = {}
        for _, child in pairs(currentFolder:GetChildren()) do
            if child.Name == "EyePunch" then
                table.insert(activeTargets, child)
            end
        end
        
        if #activeTargets == 0 then
            _G.CurrentEyeWave = (_G.CurrentEyeWave < 5) and (_G.CurrentEyeWave + 1) or 1
            return
        end
        
        -- LOOP na may tamang delays para sa stability
        local punchCount = 0
        for _, eye in ipairs(activeTargets) do
            if not eye or not rootPart or not rootPart.Parent then break end
            
            local targetCFrame = eye:IsA("BasePart") and eye.CFrame or eye:IsA("Model") and eye:GetPivot()
            
            if targetCFrame then
                punchCount = punchCount + 1
                
                -- 1. Stable TP
                rootPart.CFrame = targetCFrame
                task.wait(0.3) -- Stable delay para mag-sync
                
                -- 2. Optimized Prompt Fire
                local foundPrompt = eye:FindFirstChildWhichIsA("ProximityPrompt", true)
                if foundPrompt and foundPrompt.Enabled then
                    foundPrompt.HoldDuration = 0
                    for i = 1, 3 do -- Tatlong pitik para sure punch
                        fireproximityprompt(foundPrompt)
                        task.wait(0.1)
                    end
                else
                    -- Back-up scan
                    for _, subChild in pairs(eye:GetDescendants()) do
                        if subChild:IsA("ProximityPrompt") and subChild.Enabled then
                            subChild.HoldDuration = 0
                            for i = 1, 3 do
                                fireproximityprompt(subChild)
                                task.wait(0.1)
                            end
                            break
                        end
                    end
                end
                
                task.wait(0.5) -- Stable delay bago lumipat sa susunod na mata
            end
        end
        
        -- 3. Teleport sa Safe Escalator pagkatapos ng wave
        if punchCount > 0 and rootPart and rootPart.Parent then
            rootPart.CFrame = safeEscalator
        end
        
        -- I-advance ang wave
        _G.CurrentEyeWave = (_G.CurrentEyeWave < 5) and (_G.CurrentEyeWave + 1) or 1
    end)
end)



createButton("Section 2", "TP & Pickup Speaker", "TPs to Speaker, picks it up, then TPs to End Mall", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        -- [[ STEP 1: TP SA SPEAKER ]]
        local speakerModel = workspace.Section2.Speaker.SPEAKER
        rootPart.CFrame = speakerModel:GetPivot() * CFrame.new(0, 1.5, 0)
        task.wait(0.5) -- Hinto para mag-load ang prompt sa paligid mo
        
        -- [[ STEP 2: FIRE PICKUP PROMPT ]]
        local found = false
        for _, obj in pairs(speakerModel:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                fireproximityprompt(obj)
                found = true
                break -- Tapos na, nakuha na
            end
        end
        
        if not found then
            -- Backup kung walang prompt, subukan i-fire ang remote na nakita natin dati
            local pickupRemote = speakerModel:FindFirstChild("Pick Up")
            if pickupRemote then
                pickupRemote:FireServer()
                found = true
            end
        end

        if found then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB",
                Text = "Speaker picked up! Moving to End Mall...",
                Duration = 2
            })
            
            task.wait(1.0) -- Hantayin na pumasok sa inventory ang speaker
            
            -- [[ STEP 3: TP SA NEW END MALL LOCATION ]]
            rootPart.CFrame = CFrame.new(-1338.47424, -125.925087, -933.825439, 0.341684461, -7.77278952e-09, 0.939814746, -1.18997062e-10, 1, 8.31381808e-09, -0.939814746, -2.95253755e-09, 0.341684461)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB Error",
                Text = "Hindi ma-pickup ang speaker. Check console.",
                Duration = 3
            })
        end
    end)
end)



-- [[ GLOBAL VARIABLES ]]
local HttpService = game:GetService("HttpService")
local recordedFrames = {}
local isPlayingPath = false

-- FUNCTION: Tagabalik ng Table patungong CFrame
local function tableToCFrame(tbl)
    return CFrame.new(unpack(tbl))
end

-- [[ AUTO-LOAD VIA GITHUB HTTPGET ]]
task.spawn(function()
    local githubUrl = "https://raw.githubusercontent.com/Moymoy21/Main-Iyongofficial/refs/heads/main/IOHUB_PureMacro.lua"
    
    local success, rawData = pcall(function()
        return game:HttpGet(githubUrl)
    end)
    
    if success and rawData then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(rawData)
        end)
        
        if decodeSuccess and data then
            recordedFrames = {}
            for _, tbl in ipairs(data) do
                table.insert(recordedFrames, tableToCFrame(tbl))
            end
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB Cloud Loader",
                Text = "☁️ Macro successfully loaded from GitHub! (" .. tostring(#recordedFrames) .. " frames)",
                Duration = 5
            })
        else
            warn("[IOHUB Error] Hindi ma-parse ang JSON data mula sa GitHub link. Siguraduhing pure JSON array ang laman nito.")
        end
    else
        warn("[IOHUB Error] Failed to fetch data from GitHub URL.")
    end
end)

-- ==========================================
-- BUTTON 2: THE PLAYBACK (Collision-Friendly & One-Time Play)
-- ==========================================
createButton("Section 2", "Play/Stop Movement Macro", "Plays back movement once while keeping collisions active", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end
    
    if isPlayingPath then
        isPlayingPath = false
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Playback",
            Text = "🛑 Macro STOPPED.",
            Duration = 3
        })
        return
    end
    
    if #recordedFrames == 0 then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Error",
            Text = "Walang recorded frames sa memory! Nabigo ang pag-load mula sa GitHub.",
            Duration = 4
        })
        return
    end
    
    isPlayingPath = true

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Playback",
        Text = "🟢 PLAYBACK STARTED! (From GitHub Cloud)",
        Duration = 3
    })
    
    task.spawn(function()
        for i, targetCFrame in ipairs(recordedFrames) do
            if not isPlayingPath or not rootPart or not rootPart.Parent then break end
            
            rootPart.CFrame = targetCFrame
            game:GetService("RunService").Heartbeat:Wait() 
        end
        
        -- Automatic stop toggle kapag tapos na ang buong frames list
        isPlayingPath = false
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Playback",
            Text = "🏁 Nakarating na sa dulo at huminto na!",
            Duration = 4
        })
    end)
end)





createButton("Section 2", "Skip Chase 2", "Teleport to Elevator.", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = CFrame.new(-3911.04688, -252.090607, -1103.42798, 0.418543696, -0.0546392314, 0.90655154, 0.00858846679, 0.998382092, 0.056208808, -0.908155978, -0.0157399513, 0.418335795) -- Baguhin mo rito ang coordinates ng pupuntahan
    end
end)



-- [[ 1. I-initialize ang index para sa Batch Cycle ]]
if _G.BatchIndex == nil then _G.BatchIndex = 1 end

-- [[ 2. DATA NG MGA BATCHES ]]
local batchData = {
    [1] = {
        name = "Batch 1 (Wheels 1-3)",
        items = {Vector3.new(-2144.361, -98.017, 1629.158), Vector3.new(-1968.292, -98.022, 1626.370), Vector3.new(-1870.036, -95.532, 1504.396)}
    },
    [2] = {
        name = "Batch 2 (Wheel 4, Eng, Wheel)",
        items = {Vector3.new(-1958.030, -98.019, 1510.578), Vector3.new(-1977.489, -97.527, 1559.782), Vector3.new(-2045.800, -98.076, 1562.678)}
    },
    [3] = {
        name = "Batch 3 (Gas Cans)",
        items = {Vector3.new(-1922.088, -97.451, 1630.484), Vector3.new(-1942.218, -97.447, 1512.191), Vector3.new(-2035.270, -97.446, 1569.895)}
    }
}

-- [[ 3. ANG BUTTON FUNCTION ]]
createButton("Section 2", "Auto collect Car Parts", "I-cycle ang mga batches ng items at babalik sa kotse", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local currentBatch = batchData[_G.BatchIndex]
    
    -- I-loop ang items sa loob ng napiling batch para sa auto-collect
    for _, pos in ipairs(currentBatch.items) do
        rootPart.CFrame = CFrame.new(pos + Vector3.new(0, 1, 0))
        task.wait(0.3) -- Oras para mag-load ang item sa server
        
        -- Hanapin at mabilis na pindutin ang prompt
        for _, obj in pairs(workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(8, 8, 8))) do
            local p = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
            if p then
                p.HoldDuration = 0
                fireproximityprompt(p)
            end
        end
    end

    -- [[ TELEPORT BACK TO CAR ]]
    -- Dadalhin ka nito sa gitna ng mga slots ng kotse para diretso kabit ka na lang agad
    task.wait(0.2)
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.CFrame = CFrame.new(-1918.0, -94.5, 1602.0) -- Eksaktong pwesto sa tabi ng kotse

    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Collector",
        Text = "📦 Done " .. currentBatch.name .. "! Teleported back to Car.",
        Duration = 3
    })
    
    -- I-advance ang batch (1 -> 2 -> 3 -> 1)
    _G.BatchIndex = (_G.BatchIndex % #batchData) + 1
end)




createButton("Section 3", "Auto Draw (Orchid Perfect Sync)", "Eksaktong posisyon ng Orchid ang pupuntahan", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not rootPart or not humanoid then return end
        
        local toolName = "Ink" 
        local TweenService = game:GetService("TweenService")
        local promptService = game:GetService("ProximityPromptService")
        
        -- Pag-equip ng Ink
        local function forceEquipInk()
            if character:FindFirstChild(toolName) then return end
            local tool = player.Backpack:FindFirstChild(toolName)
            if tool then
                humanoid:EquipTool(tool)
                task.wait(0.3)
            end
        end

        -- Tanggalin ang hawak na bowl/items para hindi ma-block ang Orchid prompt
        local function unequipAllTools()
            humanoid:UnequipTools()
            task.wait(0.3)
        end

        -- SWABENG TWEEN ENGINE (Naka-physics sync)
        local function tweenTo(targetCFrame)
            local distance = (rootPart.Position - targetCFrame.Position).Magnitude
            local speed = 50 -- Ligtas na bilis para sumabay ang server physics replication
            local duration = distance / speed
            
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
            
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.5) -- Sobrang kritikal na hinto para malaman ng server na "nakatayo" ka na doon
        end

        -- [[ STEP ROUTINE WITH PERFECT SYNC ]]
        local drawSteps = {
            {name = "Paintstation A (Get Ink)", cf = CFrame.new(105.733383, -429.446381, 9308.95117)},
            {name = "Mix Orchid", cf = nil}, -- Naka-nil muna dahil dynamic nating kukunin ang CFrame nito sa ibaba!
            {name = "Mix Water", cf = CFrame.new(93.5755463, -429.446381, 9342.38672)},
            {name = "Bless the Ink", cf = CFrame.new(-36.5126572, -428.145172, 9298.2168)},
            {name = "Paintstation A (Start Draw)", cf = CFrame.new(105.499695, -429.446381, 9308.87793)}
        }

        for index, step in ipairs(drawSteps) do
            if not rootPart or not rootPart.Parent then break end
            
            -- [[ DETAILED CHECK KUNG ORCHID STEP NA ]]
            if step.name == "Mix Orchid" then
                unequipAllTools()
                
                -- Kukunin natin ang mismong Model mula sa nakita nating absolute path mo sa Mini Dex
                local success, orchidModel = pcall(function()
                    return workspace.Section3.PaintPuzzle.Ingredients.Orchid
                end)
                
                if success and orchidModel then
                    -- Kukunin ang EKSAKTONG posisyon ng Orchid Model para doon ka t-tween
                    local orchidPosition = orchidModel:GetPivot().Position
                    -- I-landing ang character mo nang swabe sa mismong tapat ng model (Y-axis: -430.6)
                    local targetCFrame = CFrame.new(orchidPosition.X, -430.609894, orchidPosition.Z)
                    
                    tweenTo(targetCFrame)
                    task.wait(0.5) -- Hinga saglit para mag-sync ang physics
                    
                    -- Hahanapin ang ProximityPrompt sa mismong loob ng tinarget nating Orchid
                    local prompt = orchidModel:FindFirstChildOfClass("ProximityPrompt") or orchidModel:FindFirstChild("ProximityPrompt")
                    if prompt then
                        task.spawn(function()
                            fireproximityprompt(prompt)
                        end)
                        task.wait(prompt.HoldDuration + 1.5) -- Maghintay hanggang matapos ang hold duration at mawala ang bulaklak
                    else
                        -- Fallback scanner kung sakaling hiwalay ang prompt sa hierarchy pero doon lang din sa area
                        for _, p in pairs(workspace:GetDescendants()) do
                            if p:IsA("ProximityPrompt") and p.Enabled and p.Parent and p.Parent.Name == "Orchid" then
                                task.spawn(function()
                                    fireproximityprompt(p)
                                end)
                                task.wait(p.HoldDuration + 1.5)
                                break
                            end
                        end
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "IOHUB Error",
                        Text = "Hindi nahanap ang Orchid Model path!",
                        Duration = 3
                    })
                end
            else
                -- STANDARD STEP (Get Ink, Water, Bless, Draw)
                tweenTo(step.cf)
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "IOHUB Paint System",
                    Text = "Nakarating na sa: " .. step.name,
                    Duration = 2
                })
                
                if index > 1 then
                    forceEquipInk()
                end
                
                -- STANDARD DISTANCE SCANNER para sa ibang stations
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local target = prompt.Parent
                        if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                            local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                            local distance = (rootPart.Position - targetPos).Magnitude
                            
                            if distance <= 15 and target.Name ~= "Orchid" then
                                task.spawn(function()
                                    fireproximityprompt(prompt)
                                end)
                                task.wait(prompt.HoldDuration + 0.5)
                                break
                            end
                        end
                    end
                end
            end
            
            task.wait(1.0)
        end

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Finished",
            Text = "Kumpleto na ang pagpinta sa Section 3! 🎨✨",
            Duration = 4
        })
    end)
end)








-- ========================================================
-- INDEX INITIALIZATION (Sinisiguradong magsisimula sa 1)
-- ========================================================
if _G.PaintStationIndex == nil then _G.PaintStationIndex = 1 end
if _G.PillarIndex == nil then _G.PillarIndex = 1 end

local localPlayer = game:GetService("Players").LocalPlayer

-- ========================================================
-- BUTTON 1: CYCLE PAINTSTATIONS (A to D)
-- ========================================================
createButton("Section 3", "Cycle PaintStations", "Cycle teleports between PaintStation A, B, C, and D", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local paintStations = {
        {name = "PaintStation A", cf = CFrame.new(105.499695, -429.446381, 9308.87793)},
        {name = "PaintStation B", cf = CFrame.new(73.4825668, -430.113983, 9490.88184, 0, 0, -1, 0, 1, 0, 1, 0, 0)},
        {name = "PaintStation C", cf = CFrame.new(-141.955887, -430.113983, 9491.11816, 0, 0, 1, 0, 1, -0, -1, 0, 0)},
        {name = "PaintStation D", cf = CFrame.new(-173.364304, -430.113983, 9491.08398, 0, 0, -1, 0, 1, 0, 1, 0, 0)}
    }
    
    -- Teleport agad sa current station
    local currentStation = paintStations[_G.PaintStationIndex]
    rootPart.CFrame = currentStation.cf
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Paint Teleport",
        Text = "🎨 Moved to: " .. currentStation.name,
        Duration = 2
    })
    
    -- AUTO PROMPT LOGIC (Inilagay sa task.spawn para hindi harangan ang index cycle)
    task.spawn(function()
        task.wait(0.15) -- Bahagyang tinaasan para siguradong nakalapag na ang character
        if rootPart and rootPart.Parent then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local distance = (rootPart.Position - obj.Parent:GetPivot().Position).Magnitude
                    if distance <= 15 then
                        fireproximityprompt(obj)
                        break
                    end
                end
            end
        end
    end)
    
    -- AGAD NA MAG-AAVANCE SA SUSUNOD NA STATION (Safe mula sa delay)
    _G.PaintStationIndex = (_G.PaintStationIndex % #paintStations) + 1
end)



-- ========================================================
-- BUTTON 2: CYCLE PILLARS (A to D)
-- ========================================================
createButton("Section 3", "Cycle Pillars", "Cycle teleports between Pillar A, B, C, and D", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local pillars = {
        {name = "Pillar A", cf = CFrame.new(137.126053, -424.783478, 9257.35059, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar B", cf = CFrame.new(-207.579758, -424.186523, 9249.00391, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar C", cf = CFrame.new(-207.573715, -424.33197, 9552.47461, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar D", cf = CFrame.new(137.130341, -424.574371, 9552.47656, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)}
    }
    
    local currentPillar = pillars[_G.PillarIndex]
    rootPart.CFrame = currentPillar.cf
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Pillar Teleport",
        Text = "🏛️ Moved to: " .. currentPillar.name,
        Duration = 2
    })
    
    _G.PillarIndex = (_G.PillarIndex % #pillars) + 1
end)


createButton("Section 3", "Auto Exit Quest", "Submit ink, wait, claim bow, wait, and auto board the vehicle", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return end
        
        -- [[ EXIT ROUTINE COORDINATES ]]
        local exitSteps = {
            {name = "Submit the Ink", cf = CFrame.new(-36.5126572, -428.145172, 9298.2168)},
            {name = "Claim Bow", cf = CFrame.new(-33.8734093, -429.471313, 9482.53125)},
            {name = "Sakay sa Kotse", cf = CFrame.new(71.8169327, -431.12738, 9146.96191)}
        }

        for index, step in ipairs(exitSteps) do
            if not rootPart or not rootPart.Parent then break end
            
            -- 1. Teleport sa pwesto
            rootPart.CFrame = step.cf
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB Exit System",
                Text = "Papunta sa: " .. step.name,
                Duration = 2
            })
            
            task.wait(0.5) 
            
            -- 2. Scan at Trigger ng ProximityPrompt
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        local distance = (rootPart.Position - targetPos).Magnitude
                        
                        if distance <= 15 then
                            prompt.HoldDuration = 0 
                            for i = 1, 3 do
                                fireproximityprompt(prompt)
                                task.wait(0.05)
                            end
                            break
                        end
                    end
                end
            end
            
            -- 3. [[ WAITING LOGIC ]]
            -- Mag-aantay ng 5 seconds pagkatapos ng Submit (Step 1) at pagkatapos ng Claim (Step 2)
            if index == 1 then
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "IOHUB Wait", Text = "Naghihintay ng 5s pagkatapos mag-submit...", Duration = 5})
                task.wait(10.0)
            elseif index == 2 then
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "IOHUB Wait", Text = "Naghihintay ng 5s pagkatapos mag-claim...", Duration = 5})
                task.wait(10.0)
            end
        end

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB Finished",
            Text = "Naka-exit at nakasakay na nang ligtas! 🏹🚗",
            Duration = 4
        })
    end)
end)


if _G.CurrentCivilianBatch == nil then
    _G.CurrentCivilianBatch = 1
end

createButton("Section 4", "Instant Help Civilians", "Lag-free live NPC rescue by 3s (with delays)", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return end
        
        local section4 = workspace:FindFirstChild("Section4")
        local rescue = section4 and section4:FindFirstChild("Rescue")
        local npcsFolder = rescue and rescue:FindFirstChild("NPCs")
        local refugeLocation = CFrame.new(-97.4970551, -1.30489147, -2337.78174)
        
        if not npcsFolder then return end
        
        -- Kunin ang mga kasalukuyang live NPCs sa folder
        local allCivilians = {}
        for _, child in pairs(npcsFolder:GetChildren()) do
            if child.Name == "Pose" then
                table.insert(allCivilians, child)
            end
        end
        
        local perBatch = 3
        local startIndex = ((_G.CurrentCivilianBatch - 1) * perBatch) + 1
        local endIndex = startIndex + (perBatch - 1)
        
        if startIndex > #allCivilians then
            _G.CurrentCivilianBatch = 1
            return
        end
        
        -- LIGHTWEIGHT SEQUENCE LOOP (May saktong antala para makagat ng server)
        local rescueCount = 0
        for index = startIndex, endIndex do
            local npc = allCivilians[index]
            if not npc or not rootPart or not rootPart.Parent then break end
            
            local targetCFrame = npc:IsA("BasePart") and npc.CFrame or npc:IsA("Model") and npc:GetPivot()
            
            if targetCFrame then
                rescueCount = rescueCount + 1
                
                -- 1. Teleport sa pwesto ng NPC
                rootPart.CFrame = targetCFrame
                task.wait(0.3) -- Bigyan ng oras ang server para mag-sync ang character mo sa pwesto
                
                -- 2. I-fire ang ProximityPrompt mula sa loob mismo ng NPC folder (Iwas Lag!)
                local foundPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true) 
                
                if foundPrompt and foundPrompt.Enabled then
                    foundPrompt.HoldDuration = 0
                    -- 3 mabilisang pitik para siguradong pumasok sa server ang interact command
                    for i = 1, 3 do
                        fireproximityprompt(foundPrompt)
                        task.wait(0.1) 
                    end
                else
                    -- Back-up scan kung sakaling nakatago sa ilalim ng mga sub-parts ng Model ang prompt
                    for _, subChild in pairs(npc:GetDescendants()) do
                        if subChild:IsA("ProximityPrompt") and subChild.Enabled then
                            subChild.HoldDuration = 0
                            for i = 1, 3 do
                                fireproximityprompt(subChild)
                                task.wait(0.1)
                            end
                            break
                        end
                    end
                end
                
                task.wait(0.4) -- Pahinga sandali bago lipadin ang kasunod na civilian ng batch upang maiwasan ang laktaw
            end
        end
        
        -- 3. Pagkatapos makuha ang batch ng 3, lipad sa Refuge para ibaba sila
        if rescueCount > 0 and rootPart and rootPart.Parent then
            rootPart.CFrame = refugeLocation
            task.wait(1.5) -- Sapat na oras para mag-trigger ang zone detector ng Refuge
        end
        
        -- I-advance ang batch counter para sa susunod na click ng button
        if (endIndex < #allCivilians) then
            _G.CurrentCivilianBatch = _G.CurrentCivilianBatch + 1
        else
            _G.CurrentCivilianBatch = 1
        end
    end)
end)




-- Global index para sa pag-track kung anong kotse ang susunod
if _G.CarZoneIndex == nil then _G.CarZoneIndex = 1 end

createButton("Section 4", "Cycle Car Zones", "Cycle between Car 1, Car 2, and Car 3 safe zones", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end
    
    -- Listahan ng mga Car SafeZone coordinates na binigay mo
    local carLocations = {
        {
            name = "Car 1", 
            cf = CFrame.new(229.233398, 1.19240487, -2973.14209, -0.998964667, -1.70509017e-12, 0.0454926528, -6.5097927e-13, 1, 2.318583e-11, -0.0454926528, 2.31322097e-11, -0.998964667)
        },
        {
            name = "Car 2", 
            cf = CFrame.new(-169.403137, 1.22625685, -2923.49487, 0.981042325, -2.64125717e-13, 0.193793714, 9.54707342e-13, 1, -3.4700953e-12, -0.193793714, 3.58932654e-12, 0.981042325)
        },
        {
            name = "Car 3", 
            cf = CFrame.new(229.839569, 0.971463382, -2449.49536, -0.0690083355, -8.48871551e-14, 0.997616112, 1.14436065e-12, 1, 1.64249135e-13, -0.997616112, 1.15296715e-12, -0.0690083355)
        }
    }
    
    -- Kunin ang kasalukuyang target na kotse base sa index
    local currentCar = carLocations[_G.CarZoneIndex]
    
    -- Instant Teleport/Snap
    rootPart.CFrame = currentCar.cf
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- I-stop ang momentum para iwas talsik
    
    -- Notification para alam mo kung saang kotse ka napunta
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Car Dash",
        Text = "🚗 Teleported to: " .. currentCar.name,
        Duration = 2
    })
    
    -- I-advance ang index para sa susunod na click, at babalik sa 1 kapag lumampas sa 3
    _G.CarZoneIndex = (_G.CarZoneIndex % #carLocations) + 1
end)


createButton("Section 4", "TP Best Shooting Drag", "Teleport to the best shooting spot", function()
    local player = game:GetService("Players").LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = CFrame.new(-53.3475876, 38.4058571, -2760.94141)
    end
end)

local runService = game:GetService("RunService")
local bossLoopConn = nil
local noclipConn = nil


local ToggleGiantLock = false
local giantLoopConn = nil
local giantNoclipConn = nil

createToggle("Section 4", "EnzukaiRyu Giant Lock", "Auto-locks behind, auto-evades, and auto-returns based on boss State.", function(state)
    ToggleGiantLock = state
    
    local player = game:GetService("Players").LocalPlayer
    local runService = game:GetService("RunService")
    local evadeCFrame = CFrame.new(-53.3475876, 38.4058571, -2760.94141)
    
    local giantDistance = 38
    local giantHeight = 8

    if ToggleGiantLock then
        -- Noclip setup
        giantNoclipConn = runService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        
        -- Main Loop
        giantLoopConn = runService.RenderStepped:Connect(function()
            local char = player.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local boss = workspace:FindFirstChild("Section4") and workspace.Section4.BossMonster:FindFirstChild("EnzukaiRyu")
            if not boss or not boss:FindFirstChild("HumanoidRootPart") then return end
            
            local bossRoot = boss.HumanoidRootPart
            local currentState = boss:GetAttribute("State")
            
            -- [[ AUTOMATION LOGIC ]]
            if currentState == 1 then
                -- AUTO-RETURN & LOCK POSITION
                -- Ginagamit natin ang CFrame.lookAt para nakaharap ka lagi sa boss
                local targetCFrame = bossRoot.CFrame * CFrame.new(0, giantHeight, giantDistance)
                rootPart.CFrame = CFrame.lookAt(targetCFrame.Position, bossRoot.Position)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                
                -- Auto Prompt
                local prompt = boss:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then fireproximityprompt(prompt) end
            else
                -- AUTO-EVADE
                rootPart.CFrame = evadeCFrame
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        -- Clean up
        if giantLoopConn then giantLoopConn:Disconnect() giantLoopConn = nil end
        if giantNoclipConn then giantNoclipConn:Disconnect() giantNoclipConn = nil end
    end
end)






local ToggleBossLock = false
local bossLoopConn = nil
local noclipConn = nil

createToggle("Section 4", "Multi-Boss Back Lock", "Locks behind Rin2, Tsukiya2, or Tenome2 (Old Troll Rotation)", function(state)
    ToggleBossLock = state
    
    if ToggleBossLock then
        local player = game:GetService("Players").LocalPlayer
        local runService = game:GetService("RunService")
        
        local lastPosition = Vector3.new(0, 0, 0)
        local timeStationary = 0
        local defaultDistance = 22 -- Safe distance sa likod habang lumalaban
        local currentDistance = defaultDistance
        
        -- [[ 1. BUILT-IN NOCLIP LOOP ]]
        noclipConn = runService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        -- [[ 2. MAIN OLD TROLL BACK-LOCK LOOP ]]
        bossLoopConn = runService.RenderStepped:Connect(function()
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local section4 = workspace:FindFirstChild("Section4")
            local targetMonster = nil
            
            -- SMART AUTO-SWITCH
            if section4 then
                local m2 = section4:FindFirstChild("Monster2")
                local m3 = section4:FindFirstChild("Monster3")
                local m4 = section4:FindFirstChild("Monster4")
                
                if m2 and m2:FindFirstChild("Rin2") then
                    targetMonster = m2.Rin2
                elseif m4 and m4:FindFirstChild("Tsukiya2") then
                    targetMonster = m4.Tsukiya2
                elseif m3 and m3:FindFirstChild("Tenome2") then
                    targetMonster = m3.Tenome2
                end
            end
            
            if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                local monsterRoot = targetMonster.HumanoidRootPart
                local monsterHumanoid = targetMonster:FindFirstChildOfClass("Humanoid")
                
                -- Detect agad kung may prompt na (para sa cutscene trigger)
                local deathPrompt = targetMonster:FindFirstChildWhichIsA("ProximityPrompt", true) 
                                 or targetMonster:FindFirstChild("ProximityPrompt", true)
                
                -- Check kung nakatigil na ang monster
                local distanceMoved = (monsterRoot.Position - lastPosition).Magnitude
                
                if (monsterHumanoid and monsterHumanoid.Health <= 0) or (deathPrompt and deathPrompt.Enabled) or (distanceMoved < 0.2) then
                    timeStationary = timeStationary + 0.016
                else
                    timeStationary = 0
                    currentDistance = defaultDistance 
                    lastPosition = monsterRoot.Position
                end
                
                -- [[ INSTANT TELEPORT TO CENTER KAPAG READY NA ]]
                if timeStationary >= 5.0 or (deathPrompt and deathPrompt.Enabled) then
                    currentDistance = 0
                end
                
                -- [[ ORIGINAL OLD TROLL MOTION FIX ]]
                if currentDistance == 0 then
                    -- Teleport sa mismong gitna ng monster para mapindot ang prompt
                    rootPart.CFrame = monsterRoot.CFrame
                else
                    -- Heto ang OLD TROLL LOGIC: 
                    -- Kokopyahin ang mismong anggulo at direksyon ng monster (monsterRoot.CFrame)
                    -- Saka lalagyan ng offset na 2 studs pataas at 22 studs sa likod (CFrame.new(0, 2, currentDistance))
                    -- Dahil walang extra multiplication ng rotation, KAHARAP MO ANG LIKOD NYA at pareho kayo ng view direction!
                    rootPart.CFrame = monsterRoot.CFrame * CFrame.new(0, 2, currentDistance)
                end
                
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                
                -- [[ AUTO PROMPT PRESSER ]]
                if deathPrompt and deathPrompt.Enabled then
                    deathPrompt.HoldDuration = 0
                    fireproximityprompt(deathPrompt)
                end
            end
        end)
    else
        -- CLEAN UP
        if bossLoopConn then bossLoopConn:Disconnect() bossLoopConn = nil end
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end)








-- Global index para sa pag-track kung anong location ang susunod
if _G.SafeZoneIndex == nil then _G.SafeZoneIndex = 1 end

createButton("Section 5", "Cycle Safe Zones", "Cycle between Back, Front, and Side zones", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end
    
    -- Listahan ng mga locations
    local locations = {
        {name = "Back Safe Zone", cf = CFrame.new(-291.185944, -37.9413147, 9.22403526, 0.194873005, 3.50615847e-12, -0.980828464, 2.28005158e-12, 1, 4.02769615e-12, 0.980828464, -3.02122888e-12, 0.194873005)},
        {name = "Front Safe Zone", cf = CFrame.new(-114.207428, -37.9413147, 100.513153, 0.976414144, 0, 0.215905979, 0, 1, 0, -0.215905979, 0, 0.976414144)},
        {name = "Side Safe Zone", cf = CFrame.new(-110.123703, -37.9413147, -105.478928, -0.987310231, 0, 0.158803359, 0, 1, 0, -0.158803359, 0, -0.987310231)}
    }
    
    -- I-teleport sa kasalukuyang location
    local currentLoc = locations[_G.SafeZoneIndex]
    rootPart.CFrame = currentLoc.cf
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "IOHUB Dash",
        Text = "🚀 Moved to: " .. currentLoc.name,
        Duration = 2
    })
    
    -- I-advance ang index para sa susunod na click (1->2->3->1)
    _G.SafeZoneIndex = (_G.SafeZoneIndex % #locations) + 1
end)



local coreGui = game:GetService("CoreGui")
local weakPointsFolder = nil
local espTracker = {} 
local folderConnection = nil 

local targetEyes = {
    ["EyeA"] = true, ["EyeB"] = true, ["EyeC"] = true, ["EyeD"] = true, ["EyeE"] = true
}

local function getWeakPointsFolder()
    local section5 = workspace:FindFirstChild("Section5")
    local weakPoints = section5 and section5:FindFirstChild("WeakPoints")
    return weakPoints and weakPoints:FindFirstChild("Points")
end

local function createEyeESP(part)
    if not part:IsA("BasePart") or espTracker[part] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "IOHUB_EyeESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 100) 
    highlight.FillTransparency = 0.4 
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
    highlight.OutlineTransparency = 0 
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
    highlight.Adornee = part
    highlight.Parent = coreGui 
    
    espTracker[part] = highlight
end

local function checkWeakPoint(weakPoint)
    if weakPoint.Name == "EnzukaiWeakPoint" then
        for _, child in pairs(weakPoint:GetChildren()) do
            if targetEyes[child.Name] then
                createEyeESP(child)
            end
        end
    end
end

-- [[ GAMIT NA NATIN ANG CREATETOGGLE DITO ]]
createToggle("Section 5", "WeakPoints ESP", "Highlights EyeA-EyeE inside all EnzukaiWeakPoints", function(state)
    if state then
        -- ===== STATE IS TRUE (TOGGLE ON) =====
        weakPointsFolder = getWeakPointsFolder()
        if not weakPointsFolder then 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "IOHUB ESP Error",
                Text = "❌ Hindi pa load ang Section5 folder sa Workspace!",
                Duration = 3
            })
            return 
        end
        
        -- 1. I-scan lahat ng EnzukaiWeakPoint na nandyan na
        for _, child in pairs(weakPointsFolder:GetChildren()) do
            checkWeakPoint(child)
        end
        
        -- 2. I-on ang dynamic listener para sa mga bagong spawn
        folderConnection = weakPointsFolder.ChildAdded:Connect(function(child)
            task.wait(0.1) 
            checkWeakPoint(child)
        end)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB ESP Active",
            Text = "👁️ Boss WeakPoints ESP: ON",
            Duration = 3
        })
    else
        -- ===== STATE IS FALSE (TOGGLE OFF) =====
        -- 1. Patayin ang event listener
        if folderConnection then
            folderConnection:Disconnect()
            folderConnection = nil
        end
        
        -- 2. Burahin lahat ng nakakabit na neon highlights
        for part, highlight in pairs(espTracker) do
            if highlight then highlight:Destroy() end
        end
        table.clear(espTracker)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "IOHUB ESP Status",
            Text = "⚪ Boss WeakPoints ESP: OFF",
            Duration = 2
        })
    end
end)



-- Core Settings Content
createButton("Core Settings", "Export Configs", "Copy config to your clipboard", function()

end)





-- Default open tab inside frame configuration
switchTab("Yen")